# libraries
require 'yaml'
require 'fileutils'
require 'csv'

# gems
require 'mechanize'
require 'procto'
require 'require_all'

# files & directories
# `require_rel` via require_all gem: https://github.com/jarmo/require_all
require_rel 'helpers/*'
require_rel '../config'
require_relative 'ok_cupid_scraper'

# constants
class Constants
  YEAR  = Date.today.year
  MONTH = Date.today.month
  DAY   = Date.today.day
  FILE_AND_FOLDER_NAME = "#{YEAR}.#{MONTH}.#{DAY}".freeze
end

# array of usernames to scrape directly from okcupid.com
username_list = YAML::load_file(File.join(__dir__, 'screen_names.yml'))

scraper = OkCupidScraper.call(
  username: UserInfo::OKC_USERNAME,
  password: UserInfo::OKC_PASSWORD,
  usernames_to_scrape: username_list,
)
