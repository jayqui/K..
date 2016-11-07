require 'csv'

class CSVCreator

  def self.make_csv_directory!
    array = FileUtils.mkdir_p("#{__dir__}/../csv_files/#{YEAR}.#{MONTH}")
    array[0]
  end

  def self.create_csv_file!(files_to_scrape) # for files already saved to a directory
    create_csv_file_header!
    add_rows_to_csv_file!(files_to_scrape)
  end

  def self.create_csv_file_header!
    dirname = make_csv_directory!
    CSV.open("#{dirname}/#{FILE_AND_FOLDER_NAME}.csv", "w", headers: true) do |csv|
      csv << ['priority', 'username', 'last messaged', 'match %', 'basics', 'ft.', 'in.', 'body', 'background', 'lifestyle', 'last online', 'age', 'city', 'description']
    end
  end

  def self.add_rows_to_csv_file!(files_to_scrape)
    dirname = make_csv_directory!
    CSV.open("#{dirname}/#{FILE_AND_FOLDER_NAME}.csv", "a") do |csv|
      files_to_scrape.each do |file|
        next if file == "." || file == ".." || file == ".DS_Store"
        csv << create_csv_row!(file)
      end
    end
  end

  def self.create_csv_row!(doc)
    username = doc.css(".userinfo2015-basics-username").text.strip

    csv_row = []
    csv_row << ''
    csv_row << username
    csv_row << DateTransformer.handle_last_contacted(doc)
    csv_row << doc.css(".userinfo2015-basics-asl").css(".userinfo2015-basics-asl-match a").text.gsub(" Match", "").gsub('%', '')
    csv_row << StringSanitizer.sanitize!(basics(doc)[1]) rescue 'n/a'
    csv_row << StringSanitizer.sanitize!(feet(doc)) rescue 'n/a'
    csv_row << StringSanitizer.sanitize!(inches(doc)) rescue 'n/a'
    csv_row << StringSanitizer.sanitize!(body(doc)) rescue 'n/a'
    csv_row << StringSanitizer.sanitize!(doc.css(".details2015-section.background").text)
    csv_row << StringSanitizer.sanitize!(doc.css(".details2015-section.misc").text)
    csv_row << DateTransformer.transform(doc.css(".userinfo2015-basics-username-online")[0].attributes["data-tooltip"].value)
    csv_row << doc.css(".userinfo2015-basics-asl").css(".userinfo2015-basics-asl-age").text
    csv_row << doc.css(".userinfo2015-basics-asl").css(".userinfo2015-basics-asl-location").text
    csv_row << doc.css(".essays2015-essay-content").text

    csv_row
  end

  def self.create_error_row!(screen_name)
    dirname = make_csv_directory!
    CSV.open("#{dirname}/#{FILE_AND_FOLDER_NAME}.csv", "a") do |csv|
      csv << ["",screen_name, "deleted apparently"]
    end
  end

  private

  def self.basics(doc)
    basics = doc.css(".details2015-section.basics").text
    basics.match(/(.*)(4’.|5’.|6’.)(.{1,2}”)(.*)/) || basics.match(/(.*)/)
  end

  def self.feet(doc)
    feet = basics(doc)[2] || ''
    feet.sub(/’/,'')
  end

  def self.inches(doc)
    inches = basics(doc)[3] || ''
    inches.sub(/”/,'')
  end

  def self.body(doc)
    body = basics(doc)[4] || ''
    body.sub(/, /, '')
  end
end
