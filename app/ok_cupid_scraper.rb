require_rel 'csv'

class OkCupidScraper
  include Procto.call

  def initialize(username:, password:, usernames_to_scrape:)
    @username = username
    @password = password
    @usernames_to_scrape = usernames_to_scrape
    @mechanize = Mechanize.new
  end

  def call
    login
    scrape_each(usernames_to_scrape)
  end

  private

  attr_reader :mechanize, :username, :password, :usernames_to_scrape

  def login
    login_page = mechanize.get('https://www.okcupid.com/login')
    login_form = login_page.form_with(id: 'loginbox_form')
    login_form.field_with(id: 'login_username').value = username
    login_form.field_with(id: 'login_password').value = password
    login_form.submit
  end

  def scrape_each(screen_names)
    CSV::FileHeaderCreator.call(destination_directory: destination_directory)

    screen_names.uniq.each do |screen_name|
      begin
        html = get_html(screen_name)
        read_and_record_data!(html: html, screen_name: screen_name)
      rescue
        next
      end
    end
  end

  def get_html(screen_name)
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

  def read_and_record_data!(html:, screen_name:)
    CSV::RowAdder.call(
      file_to_scrape: html,
      destination_directory: destination_directory,
    )
    puts ". . . . . Recorded data for #{screen_name}"
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
    mechanize.get(
      "https://www.okcupid.com/profile/#{screen_name}?cf=regular,matchsearch"
    )
  end
end
