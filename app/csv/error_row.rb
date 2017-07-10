class CSV::ErrorRow
  include Procto.call

  def initialize(destination_directory:, screen_name:, message:)
    @destination_directory = destination_directory
    @screen_name = screen_name
    @message = message
  end

  def call
    CSV.open(filename, "a") do |csv|
      csv << ["", screen_name, message]
    end
  end

  private

  attr_reader :destination_directory, :screen_name

  def filename
    "#{destination_directory}/#{Constants::FILE_AND_FOLDER_NAME}.csv"
  end
end
