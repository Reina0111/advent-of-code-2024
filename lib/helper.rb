module Helper
  def read_file(file_name)
    lines = []
    File.open(file_name).read.each_line do |line|
      lines << line
    end

    lines
  end
end