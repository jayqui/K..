class CSV::RowAdder
  include Procto.call

  def initialize(file_to_scrape:, destination_directory:)
    @file = file_to_scrape # OKC profile html file
    @destination_directory = destination_directory
    @adapter = CSV::RowAdder::Adapter.new(file: file)
  end

  def call
    CSV.open(filename, "a") do |csv|
      csv << create_csv_row!
    end
  end

  private

  attr_reader :file, :destination_directory, :adapter

  def filename
    "#{destination_directory}/#{FILE_AND_FOLDER_NAME}.csv"
  end

  def create_csv_row!
    [
      '',
      adapter.username,
      adapter.last_messaged,
      adapter.match_percentage,
      adapter.basics,
      adapter.feet,
      adapter.inches,
      adapter.body,
      adapter.age,
      adapter.city,
      adapter.last_online,
      adapter.has_kids,
      adapter.wants_kids,
      adapter.lifestyle,
      adapter.background,
      adapter.description,
    ]
  end
end
