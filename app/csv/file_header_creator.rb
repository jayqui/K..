require 'procto'

class CSV::FileHeaderCreator
  include Procto.call

  def call
    create_csv_file_header!
  end

  private

  def make_csv_directory!
    dirname = "#{__dir__}/../../csv_files/#{YEAR}.#{MONTH}"
    array = FileUtils.mkdir_p(dirname)

    puts "found or created directory #{dirname}"

    array[0]
  end

  def create_csv_file_header!
    dirname = make_csv_directory!

    CSV.open("#{dirname}/#{FILE_AND_FOLDER_NAME}.csv", "w", headers: true) do |csv|
      csv << [
        'priority',
        'username',
        'last messaged',
        'match %',
        'basics',
        'ft.',
        'in.',
        'body',
        'age',
        'city',
        'last online',
        'has kids',
        'wants kids',
        'lifestyle',
        'background',
        'description'
     ]
    end
  end
end
