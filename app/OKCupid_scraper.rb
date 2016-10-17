require 'mechanize'

require_relative 'CSV_creator'

class OKCupidScraper
  def initialize(username:, password:)
    @username = username
    @password = password
    @scraper = Mechanize.new
  end

  def login
    login_page = @scraper.get 'https://www.okcupid.com/login'
    login_form = login_page.form_with(id: 'loginbox_form')
    login_form.field_with(id: 'login_username').value = @username
    login_form.field_with(id: 'login_password').value = @password
    login_form.submit
  end

  def scrape_each(screen_names)
    CSVCreator.create_csv_file_header!

    screen_names.shuffle.each do |screen_name|
      html_file = @scraper.get "https://www.okcupid.com/profile/#{screen_name}"
      html_file.save!("../html/#{YEAR}.#{MONTH}/#{FILE_AND_FOLDER_NAME}/#{html_file.title.gsub(/ \/ /,'_').sub('OkCupid','')}.html")
      sleep rand(0.5)
      CSVCreator.add_rows_to_csv_file!([html_file])
    end
  end
end
