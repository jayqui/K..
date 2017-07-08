require 'procto'

class CSV::FindOrCreateDirectory
  include Procto.call

  def call
    dirname = "#{__dir__}/../../csv_files/#{YEAR}.#{MONTH}"
    array = FileUtils.mkdir_p(dirname)

    puts "found or created directory #{dirname}"

    array[0]
  end
end
