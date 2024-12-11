require_relative "../lib/helper"
require 'matrix'

class Solution6
  include Helper

  FILE_NAME = "6th-day/input.txt"


  def solution()
    get_loop_distance
  end

  def solution_part2()
    @data = nil
    @new_obstacles = []
    @all_visited = {}
    get_loop_distance(true)

    # puts @new_obstacles.to_s
    @new_obstacles.size
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
      line.split("").reject { |e| e == "\n" }.map { |position| [position == "#", position == "^", position == "^" ? [[-1, 0]] : []] }
    end

    @data
  end

  def start
    return @start if @start

    data

    @start
  end
  
  def get_loop_distance(check_for_new_obstacles = false)
    current_direction = [-1, 0]
    distance = 1 # starting position
    current_index = start

    current_direction, current_position = correct_move(current_direction, current_index)
    
    while (current_position != nil) do
      if check_for_new_obstacles
        # this check checks for only nearby positions
        # we have to check if any position in this line was visited with correct direction
        #puts "any_position_visited(#{MAP_DIRECTIONS[current_direction]}, #{current_position})"
        next_dir, next_pos = correct_move(current_direction, current_position)
        if (any_position_visited(MAP_DIRECTIONS[next_dir], current_position))
          # puts "still ok"
          if next_pos != nil
            @new_obstacles << next_pos
            @new_obstacles.uniq!
          end
        else

        end
        data[current_position[0]][current_position[1]][2] << current_direction
        data[current_position[0]][current_position[1]][2].uniq!

        puts "#{distance}, #{@all_visited.keys.count}"
        # puts "#{data[current_position[0]][current_position[1]][2]} - #{data[current_position[0]][current_position[1]][2].size}" if distance > 38
      end
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

  def any_position_visited(direction, current_position)
    # puts "checking for [#{current_position}], [#{direction}]"
    new_direction = direction.clone
    visited = []

    while current_position && !visited.include?([new_direction, current_position]) && !@all_visited[[new_direction, current_position]] &&
      (!data[current_position[0]][current_position[1]][2].include?(new_direction) || !data[current_position[0]][current_position[1]][1])
      visited << [new_direction, current_position]
      new_direction, current_position = correct_move(new_direction, current_position)
      # puts "#{new_direction}, #{current_position}"
      # puts "#{visited}"
    end

    if (new_direction == direction && current_position && data[current_position[0]][current_position[1]][2].include?(direction)) ||
      (new_direction != direction && current_position && data[current_position[0]][current_position[1]][2].include?(new_direction)) ||
      @all_visited[[new_direction, current_position]]
       # puts "OK [#{current_position.join(", ")}]"
      @all_visited.merge!(visited.map { |visit| [visit, true] }.to_h)
      true
    else
      # puts "NIE OK [#{current_position&.join(", ")}]"
      @all_visited.merge!(visited.map { |visit| [visit, false] }.to_h)
      false
    end
  end
end

# 1413 too low