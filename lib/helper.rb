module Helper
  UP = [-1, 0]
  RIGHT = [0, 1]
  DOWN = [1, 0]
  LEFT = [0, -1]

  def read_file(file_name)
    lines = []
    File.open(file_name).read.each_line do |line|
      lines << line
    end

    lines
  end
end