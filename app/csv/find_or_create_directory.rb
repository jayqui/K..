class CSV::FindOrCreateDirectory
  include Procto.call

  def call
    dirname = "#{__dir__}/../../csv_files/#{Constants::YEAR}.#{Constants::MONTH}"
    array = FileUtils.mkdir_p(dirname)

    puts "found or created directory #{dirname}"

    array[0]
  end
end
