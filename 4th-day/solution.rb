require_relative "../lib/helper"
require 'matrix'

class Solution4
  include Helper

  FILE_NAME = "4th-day/input.txt"


  def solution()
    count = 0
    x_positions.each do |x_position|
      count += search_xmas(x_position)
    end

    count
  end

  def solution_part2()
    count = 0    
    a_positions.each do |a_position|
      count += search_cross(a_position)
    end

    count
  end

  def map
    @map ||= Matrix[*prepare_map]
  end

  def mirror_map
    @mirror_map ||= Matrix[*map.row_vectors.reverse.map(&:to_a)]
  end

  def x_positions
    return @x_positions if @x_positions
    
    @x_positions = []
    map.row_vectors.each_with_index do |line, index|
      @x_positions += line.to_a.each_index.select { |i| line[i] == "X" }.map { |i| [index, i] }
    end

    @x_positions
  end

  def a_positions
    return @a_positions if @a_positions
    
    @a_positions = []
    map.row_vectors.each_with_index do |line, index|
      @a_positions += line.to_a.each_index.select { |i| line[i] == "A" }.map { |i| [index, i] }
    end

    @a_positions
  end

  def prepare_map
    lines = read_file(FILE_NAME)
    lines.map { |line| line.strip.split("") }
  end

  def search_xmas(x_position)
    count = 0

    count += 1 if search_horizontal(x_position)
    count += 1 if search_horizontal(x_position, true)

    count += 1 if search_vertical(x_position)
    count += 1 if search_vertical(x_position, true)

    count += search_diagonal(x_position)

    count
  end

  def search_horizontal(x_position, reverse = false)
    if reverse
      line = map.row(x_position[0]).to_a[0..x_position[1]].reverse()
    else
      line = map.row(x_position[0]).to_a[x_position[1]..-1]
    end

    return false if line.size < 4

    line[0..3].join("") == "XMAS"
  end

  def search_vertical(x_position, reverse = false)
    if reverse
      line = map.column(x_position[1]).to_a[0..x_position[0]].reverse()
    else
      line = map.column(x_position[1]).to_a[x_position[0]..-1]
    end

    return false if line.size < 4

    line[0..3].join("") == "XMAS"
  end

  def search_diagonal(x_position)
    lines = []
    # diagonal from left up to right down
    if x_position[0] < map.column(0).size - 3 && x_position[1] < map.row(0).size - 3
      lines << map.minor(x_position[0]..-1, x_position[1]..-1).each(:diagonal).to_a
    end
    
    # diagonal from right down to left up
    if x_position[0] >= 3 && x_position[1] >= 3
      lines << map.minor((x_position[0] - 3)..x_position[0], (x_position[1] - 3)..x_position[1]).each(:diagonal).to_a.reverse
    end

    x_position_mirror = [map.column(0).size - x_position[0] - 1, x_position[1]]
    
    # diagona from left down to right up
    if x_position_mirror[0] < map.column(0).size - 3 && x_position_mirror[1] < map.row(0).size - 3
      lines << mirror_map.minor(x_position_mirror[0]..-1, x_position_mirror[1]..-1).each(:diagonal).to_a
    end

    # diagonal from right up to left down
    if x_position_mirror[0] >= 3 && x_position_mirror[1] >= 3
      lines << mirror_map.minor(x_position_mirror[0] - 3..x_position_mirror[0], x_position_mirror[1] - 3..x_position_mirror[1]).each(:diagonal).to_a.reverse
    end

    count = 0

    lines.each do |line|
      count += 1 if line.size >= 4 && line[0..3].join("") == "XMAS"
    end

    count
  end

  def search_cross(a_position)
    return 0 if a_position[0] < 1 || a_position[1] < 1 || a_position[0] > map.column(0).size - 2 || a_position[1] > map.row(0).size - 2

    left_up = map.row(a_position[0] - 1)[a_position[1] - 1]
    right_up = map.row(a_position[0] - 1)[a_position[1] + 1]
    left_down = map.row(a_position[0] + 1)[a_position[1] - 1]
    right_down = map.row(a_position[0] + 1)[a_position[1] + 1]
    case [left_up, right_up]
    when ["M", "M"]
      if left_down == "S" && right_down == "S"
        return 1
      else
        return 0
      end
    when ["M", "S"]
      if left_down == "M" && right_down == "S"
        return 1
      else
        return 0
      end
    when ["S", "M"]
      if left_down == "S" && right_down == "M"
        return 1
      else
        return 0
      end
    when ["S", "S"]
      if left_down == "M" && right_down == "M"
        return 1
      else
        return 0
      end
    else
      return 0
    end
  end
end
