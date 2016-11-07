require 'mechanize'
require 'fileutils'

require_relative 'CSV_creator'

class OKCupidScraper
  def initialize(username:, password:)
    @username = username
    @password = password
    @scraper = Mechanize.new
  end

  def make_html_directory!
    array = FileUtils.mkdir_p("#{__dir__}/../html/#{YEAR}.#{MONTH}")
    array[0]
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

    screen_names.uniq.each do |screen_name|
      begin
        html_file = @scraper.get "https://www.okcupid.com/profile/#{screen_name}?cf=regular,matchsearch"
        dirname = make_html_directory!
        html_file.save!("#{dirname}/#{html_file.title.gsub(/ \/ /,'_').sub('OkCupid','')}.html")
        sleep rand(0.25)
        p "Collecting data for #{screen_name}"
        CSVCreator.add_rows_to_csv_file!([html_file])
      rescue
        p "No data for #{screen_name}"
        CSVCreator.create_error_row!(screen_name)
        next
      end
    end
  end
end
