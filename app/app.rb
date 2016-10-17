require 'nokogiri'
require 'csv'
require_relative 'helpers/date_transformer'
require_relative 'helpers/string_sanitizer'

YEAR  = '2016'
MONTH =   '10'
DAY   =   '16'
FILE_AND_FOLDER_NAME = "#{YEAR}.#{MONTH}.#{DAY}"

CSV.open("../csv_files/#{YEAR}.#{MONTH}/#{FILE_AND_FOLDER_NAME}.csv", "w", headers: true) do |csv|
  csv << ["priority", "username", "last messaged", "match %", "basics", "background", "lifestyle", "last online", "age", "city",]
  Dir.foreach("../html/#{YEAR}.#{MONTH}/#{FILE_AND_FOLDER_NAME}") do |file|
    next if file == "." || file == ".." || file == ".DS_Store"
    doc = File.open(File.dirname(__FILE__) + "/../html/#{YEAR}.#{MONTH}/#{FILE_AND_FOLDER_NAME}/" + file) { |f| Nokogiri::HTML(f) }

    username = doc.css(".userinfo2015-basics-username").text.strip
    p "Collecting data for #{username}"

    insert_into_csv = []
    insert_into_csv << 'woohoo refactoring'
    insert_into_csv << username
    insert_into_csv << DateTransformer.handle_last_contacted(doc)
    insert_into_csv << doc.css(".userinfo2015-basics-asl").css(".userinfo2015-basics-asl-match a").text.gsub(" Match", "").gsub('%', '')
    insert_into_csv << StringSanitizer.sanitize!(doc.css(".details2015-section.basics").text)
    insert_into_csv << StringSanitizer.sanitize!(doc.css(".details2015-section.background").text)
    insert_into_csv << StringSanitizer.sanitize!(doc.css(".details2015-section.misc").text)
    insert_into_csv << DateTransformer.transform(doc.css(".userinfo2015-basics-username-online")[0].attributes["data-tooltip"].value)
    insert_into_csv << doc.css(".userinfo2015-basics-asl").css(".userinfo2015-basics-asl-age").text
    insert_into_csv << doc.css(".userinfo2015-basics-asl").css(".userinfo2015-basics-asl-location").text
    insert_into_csv << doc.css(".essays2015-essay-content").text

    csv << insert_into_csv
  end
end
