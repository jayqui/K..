require 'yaml'
require_relative '../config/user_info'
require_relative 'helpers/date_transformer'
require_relative 'helpers/string_sanitizer'
require_relative 'ok_cupid_scraper'

YEAR  = Date.today.year
MONTH = Date.today.month
DAY   = Date.today.day
FILE_AND_FOLDER_NAME = "#{YEAR}.#{MONTH}.#{DAY}"

# array of usernames to scrape directly from okcupid.com
username_list = YAML::load_file(File.join(__dir__, 'screen_names.yml'))

scraper = OkCupidScraper.new(
  username: UserInfo::OKC_USERNAME,
  password: UserInfo::OKC_PASSWORD,
)

scraper.login
scraper.scrape_each(username_list)
