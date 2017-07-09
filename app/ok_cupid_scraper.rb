require 'mechanize'
require 'fileutils'
require 'require_all'
require 'csv'

require_rel 'csv' # via require_all gem : https://github.com/jarmo/require_all

class OkCupidScraper
  def initialize(username:, password:)
    @username = username
    @password = password
    @scraper = Mechanize.new
  end

  def login
    login_page = scraper.get('https://www.okcupid.com/login')
    login_form = login_page.form_with(id: 'loginbox_form')
    login_form.field_with(id: 'login_username').value = username
    login_form.field_with(id: 'login_password').value = password
    login_form.submit
  end

  def scrape_each(screen_names)
    CSV::FileHeaderCreator.call(destination_directory: destination_directory)

    screen_names.uniq.each do |screen_name|
      begin
        html_file = get_html_file!(screen_name)
        read_and_record_data!(html_file: html_file, screen_name: screen_name)
      rescue
        next
      end
    end
  end

  private

  attr_reader :scraper, :username, :password

  def get_html_file!(screen_name)
    puts "Looking up data for #{screen_name}"
    sleep rand(0.25)
    get_profile(screen_name)
  rescue
    puts ". . . . . No data for #{screen_name}"
    CSV::ErrorRow.call(
      destination_directory: destination_directory,
      screen_name: screen_name,
      message: "deleted apparently",
    )
  end

  def read_and_record_data!(html_file:, screen_name:)
    puts ". . . . . Recording data for #{screen_name}"
    CSV::RowAdder.call(
      file_to_scrape: html_file,
      destination_directory: destination_directory,
    )
  rescue
    puts ". . . . . Unreadable data for #{screen_name}"
    CSV::ErrorRow.call(
      destination_directory: destination_directory,
      screen_name: screen_name,
      message: "Couldn't read data for #{screen_name}. Please report this bug to the creator at jayqui@outlook.com.",
    )
  end

  def destination_directory
    @destination_directory ||= CSV::FindOrCreateDirectory.call
  end

  def get_profile(screen_name)
    scraper.get(
      "https://www.okcupid.com/profile/#{screen_name}?cf=regular,matchsearch"
    )
  end
end
