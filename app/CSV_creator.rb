require 'csv'
require 'pry'

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
      csv << [
        'priority',
        'username',
        'last messaged',
        'match %',
        'basics',
        'ft.',
        'in.',
        'body',
        'age',
        'city',
        'last online',
        'has kids',
        'wants kids',
        'lifestyle',
        'background',
        'description'
     ]
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
    csv_row = []

    csv_row << ''
    csv_row << username(doc)
    csv_row << last_messaged(doc)
    csv_row << match_percentage(doc)
    csv_row << StringSanitizer.sanitize!(basics(doc)[1]) rescue 'n/a'
    csv_row << StringSanitizer.sanitize!(feet(doc)) rescue 'n/a'
    csv_row << StringSanitizer.sanitize!(inches(doc)) rescue 'n/a'
    csv_row << StringSanitizer.sanitize!(body(doc)) rescue 'n/a'
    csv_row << age(doc)
    csv_row << city(doc)
    csv_row << last_online(doc)
    csv_row << has_kids(doc)
    csv_row << wants_kids(doc)
    csv_row << lifestyle(doc)
    csv_row << background(doc)
    csv_row << description(doc)

    csv_row
  end

  def self.create_error_row!(screen_name)
    dirname = make_csv_directory!
    CSV.open("#{dirname}/#{FILE_AND_FOLDER_NAME}.csv", "a") do |csv|
      csv << ["",screen_name, "deleted apparently"]
    end
  end

  private

  def self.username(doc)
    doc.css(".userinfo2015-basics-username").text.strip
  end

  def self.last_messaged(doc)
    DateTransformer.handle_last_contacted(doc)
  end

  def self.match_percentage(doc)
    doc.
      css(".userinfo2015-basics-asl").
      css(".userinfo2015-basics-asl-match a").
      text.
      gsub(" Match", "").
      gsub('%', '')
  end

  def self.basics(doc)
    basics = doc.css(".details2015-section.basics td")[1].text
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

  def self.lifestyle(doc)
    StringSanitizer.sanitize!(doc.css(".details2015-section.misc td")[1].text)
  end

  def self.last_online(doc)
    DateTransformer.
      transform(
        doc.
          css(".userinfo2015-basics-username-online")[0].
          attributes["data-tooltip"].
          value
      )
  end

  def self.age(doc)
    doc.css(".userinfo2015-basics-asl").css(".userinfo2015-basics-asl-age").text
  end

  def self.city(doc)
    doc.
      css(".userinfo2015-basics-asl").
      css(".userinfo2015-basics-asl-location").
      text
  end


  # static _hasKids() {
  #   let lifestyle = this._lifestyle();
  #   if (!lifestyle) { return "" }
  #   if (lifestyle.includes("Has kids")) { return "TRUE" }
  #   if (lifestyle.includes("oesn’t have kids")) { return "FALSE" }
  #   return "n/a"
  # }

  def self.has_kids(doc)
    return unless lifestyle(doc)

    case lifestyle(doc)
    when /as kids/ then "TRUE"
    when /oesn’t have kids/ then "FALSE"
    else
      "n/a"
    end
  end

  def self.wants_kids(doc)
    return unless lifestyle(doc)

    case lifestyle(doc)
    when /wants/ then "TRUE"
    when /might want/ then "MAYBE"
    when /oesn’t want/ then "FALSE"
    else
      "n/a"
    end
  end

  def self.background(doc)
    StringSanitizer.sanitize!(doc.css(".details2015-section.background td")[1].text)
  end

  def self.description(doc)
    doc.css(".essays2015-essay-content").text
  end
end
