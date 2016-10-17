require 'csv'

class CSVCreator
  def create_csv_file!(files_to_scrape) # for files already saved to a directory
    create_csv_file_header!
    add_rows_to_csv_file!(files_to_scrape)
  end

  def self.create_csv_file_header!
    CSV.open("../csv_files/#{YEAR}.#{MONTH}/#{FILE_AND_FOLDER_NAME}.csv", "w", headers: true) do |csv|
      csv << ["priority", "username", "last messaged", "match %", "basics", "background", "lifestyle", "last online", "age", "city",]
    end
  end

  def self.add_rows_to_csv_file!(files_to_scrape)
    CSV.open("../csv_files/#{YEAR}.#{MONTH}/#{FILE_AND_FOLDER_NAME}.csv", "a") do |csv|
      files_to_scrape.each do |file|
        next if file == "." || file == ".." || file == ".DS_Store"
        csv << create_csv_row!(file)
      end
    end
  end

  def self.create_csv_row!(doc)
    username = doc.css(".userinfo2015-basics-username").text.strip
    p "Collecting data for #{username}"

    csv_row = []
    csv_row << ''
    csv_row << username
    csv_row << DateTransformer.handle_last_contacted(doc)
    csv_row << doc.css(".userinfo2015-basics-asl").css(".userinfo2015-basics-asl-match a").text.gsub(" Match", "").gsub('%', '')
    csv_row << StringSanitizer.sanitize!(doc.css(".details2015-section.basics").text)
    csv_row << StringSanitizer.sanitize!(doc.css(".details2015-section.background").text)
    csv_row << StringSanitizer.sanitize!(doc.css(".details2015-section.misc").text)
    csv_row << DateTransformer.transform(doc.css(".userinfo2015-basics-username-online")[0].attributes["data-tooltip"].value)
    csv_row << doc.css(".userinfo2015-basics-asl").css(".userinfo2015-basics-asl-age").text
    csv_row << doc.css(".userinfo2015-basics-asl").css(".userinfo2015-basics-asl-location").text
    csv_row << doc.css(".essays2015-essay-content").text

    csv_row
  end
end
