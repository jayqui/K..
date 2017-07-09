# libraries
require 'yaml'
require 'fileutils'
require 'csv'

# gems
require 'mechanize'
require 'procto'
require 'require_all'

# files & directories
require_rel '../config' # via require_all gem : https://github.com/jarmo/require_all
require_rel 'helpers'
require_relative 'ok_cupid_scraper'

# constants
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
