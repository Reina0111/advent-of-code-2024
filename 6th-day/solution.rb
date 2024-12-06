require_relative "../lib/helper"
require 'matrix'

class Solution6
  include Helper

  FILE_NAME = "6th-day/input.txt"


  def solution()
    get_loop_distance
  end

  def solution_part2()
    0
  end

  # obstacles are marked as true, free spaces as false
  # every field is an array
  # first element says if it's an obstacle or not
  # second if it was already visited
  def data
    return @data if @data

    lines = read_file(FILE_NAME)
    @data = []
    s_index = nil

    @data = lines.each_with_index.map do |line, index|
      @start = [index, s_index] if (s_index = line.index("^"))
      line.split("").reject { |e| e == "\n" }.map { |position| [position == "#", position == "^"] }
    end

    @data
  end

  def start
    return @start if @start

    data

    @start
  end
  
  def get_loop_distance()
    current_direction = [-1, 0]
    distance = 1 # starting position
    current_index = start

    current_direction, current_position = correct_move(current_direction, current_index)
    
    while (current_position != nil) do
      distance += data[current_position[0]][current_position[1]][1] ? 0 : 1
      data[current_position[0]][current_position[1]][1] = true

      current_direction, current_position = correct_move(current_direction, current_position)
    end
    
    distance
  end

  MAP_DIRECTIONS = {
    [-1, 0] => [0, 1],
    [0, 1] => [1, 0],
    [1, 0] => [0, -1],
    [0, -1] => [-1, 0]
  }

  # moves 1 field
  # returns direction for next move and our current position
  # if next position exits map then current_position == nil
  def correct_move(direction, index)
    new_index = [index, direction].transpose.map(&:sum)

    while data[new_index[0]] && data[new_index[0]][new_index[1]] && data[new_index[0]][new_index[1]][0]
      # obstacle
      direction = MAP_DIRECTIONS[direction]
      new_index = [index, direction].transpose.map(&:sum)
    end

    if [-1, data.size].include?(new_index[0]) || [-1, data[0].size].include?(new_index[1])
      [direction, nil]
    else
      [direction, new_index]
    end
  end
end