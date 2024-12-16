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

  def pretty_print_matrix(matrix)
    array = matrix.to_a
    column_width = array.flatten.map { |elem| elem.to_s.length }.max
    array.each do |row|
      puts row.map { |elem| elem.to_s.rjust(column_width) }.join
    end
    puts ""
  end
end