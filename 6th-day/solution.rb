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
    data
    data2

    get_loop_distance(true).compact.uniq.count
  end

  # obstacles are marked as true, free spaces as false
  # every field is an array
  # first element says if it's an obstacle or not
  # second if it was already visited
  # third is an array of directions in which space was crossed
  def data
    return @data if @data

    lines = read_file(FILE_NAME)
    @data = []
    s_index = nil

    @data = lines.each_with_index.map do |line, index|
      @start = [index, s_index] if (s_index = line.index("^"))
      line.split("").reject { |e| e == "\n" }.map { |position| [position == "#", false, position == "^" ? [[-1, 0]] : []] }
    end

    @data
  end

  def data2
    return @data2 if @data2

    @data2 = Matrix[*read_file(FILE_NAME).map { |line| line.strip.split("").map { |position| [position == "#", position == "^", position == "^" ? [[-1, 0]] : []] } }]

    @start = @data2.index([false, true, [[-1, 0]]])

    @data2
  end

  def start
    return @start if @start

    data

    @start
  end
  
  def get_loop_distance(check_for_new_obstacles = false)
    current_direction = [-1, 0]
    distance = 1 # starting position
    loops = []
    current_position = start

    loops << check_for_loop(current_position, current_direction) if check_for_new_obstacles

    data[current_position[0]][current_position[1]][1] = true

    current_direction, current_position = correct_move(current_direction, current_position)
    
    while (current_position != nil) do
      loops << check_for_loop(current_position, current_direction) if check_for_new_obstacles

      # puts current_position.to_s
      distance += data[current_position[0]][current_position[1]][1] ? 0 : 1
      data[current_position[0]][current_position[1]][1] = true

      current_direction, current_position = correct_move(current_direction, current_position)
    end
    
    check_for_new_obstacles ? loops : distance
  end

  MAP_DIRECTIONS = {
    UP => RIGHT,
    RIGHT => DOWN,
    DOWN => LEFT,
    LEFT => UP
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
    new_position = current_position.clone
    new_direction = direction.clone
    visited = []

    while new_position && !visited.include?([new_direction, new_position]) && @all_visited[[new_direction, new_position]] == nil &&
      (!data[new_position[0]][new_position[1]][2].include?(new_direction) || !data[new_position[0]][new_position[1]][1])
      visited << [new_direction, new_position]
      new_direction, new_position = correct_move(new_direction, new_position)
      # puts "#{new_direction}, #{new_position}"
      # puts "#{visited}"
    end

    if (new_direction == direction && new_position && data[new_position[0]][new_position[1]][2].include?(direction)) ||
      (new_direction != direction && new_position && data[new_position[0]][new_position[1]][2].include?(new_direction)) ||
      @all_visited[[new_direction, new_position]]
      # puts "[#{new_direction}], [#{new_position}]"
      # puts @all_visited[[new_direction, new_position]]
      # puts "OK #{current_position}"
      @all_visited.merge!(visited.map { |visit| [visit, true] }.to_h)
      true
    else
      # puts "NIE OK [#{new_position&.join(", ")}]"
      @all_visited.merge!(visited.map { |visit| [visit, false] }.to_h)
      false
    end
  end

  # point - current point
  # direction - original direction we would go from the point
  def check_for_loop(point, direction)
    # puts "check for loop start #{[point, direction]}"
    x, y = [0, 0]
    loop do
      x, y = [point, direction].transpose.map(&:sum)
      # puts "[#{x}, #{y}]"
      direction = MAP_DIRECTIONS[direction]
      break if x < 0 || y < 0 || @data2[x, y] == nil || @data2[x, y][0] != true
    end

    return nil if x < 0 || y < 0 || @data2[x, y] == nil || data[x][y][1]
    # puts @data2[x, y].to_s
    # puts "[#{x}, #{y}]"
    @data2[x, y][0] = true
    visited_points = []

    # puts [point, direction].to_s
    while point != nil && !visited_points.include?([point, direction])
      visited_points << [point, direction]
      direction, point = correct_move_long(direction, point)
      # puts visited_points.to_s if visited_points.size < 5
      # puts direction.to_s if visited_points.size < 5
      # puts point.to_s if visited_points.size < 5
    end

    # puts "UDAŁO SIĘ #{[x, y]}" if point
    # puts "BUUUU #{[x, y]}" if point == nil

    # puts visited_points.to_s

    @data2[x, y][0] = false
    # puts point.to_s if point
    # puts "check for loop end #{[point, direction]} -> #{point != nil}"
    
    # return point ? correct_move(MAP_DIRECTIONS.invert[direction], point)[1] : nil

    return point ? [x, y] : nil
  end

  def correct_move_long(direction, index)
    case direction
    when UP
      obstacle_index = @data2.column(index[1]).to_a[0..index[0] - 1].rindex { |obstacle, _, _| obstacle }
      # puts "obstacle index #{obstacle_index} UP" 
      if obstacle_index == nil
        return [direction, nil]
      else
        return [MAP_DIRECTIONS[direction], [obstacle_index + 1, index[1]]]
      end
    when RIGHT
      obstacle_index = @data2.row(index[0]).to_a[index[1] + 1..-1].index { |obstacle, _, _| obstacle }
      # puts "obstacle index #{obstacle_index} RIGHT" 
      if obstacle_index == nil
        return [direction, nil]
      else
        return [MAP_DIRECTIONS[direction], [index[0], index[1] + obstacle_index]]
      end
    when DOWN
      obstacle_index = @data2.column(index[1]).to_a[index[0] + 1..-1].index { |obstacle, _, _| obstacle }
      # puts "obstacle index #{obstacle_index} DOWN" 
      if obstacle_index == nil
        return [direction, nil]
      else
        return [MAP_DIRECTIONS[direction], [index[0] + obstacle_index, index[1]]]
      end
    when LEFT
      obstacle_index = @data2.row(index[0]).to_a[0..index[1] - 1].rindex { |obstacle, _, _| obstacle }
      # puts "obstacle index #{obstacle_index} LEFT" 
      if obstacle_index == nil
        return [direction, nil]
      else
        return [MAP_DIRECTIONS[direction], [index[0], obstacle_index + 1]]
      end
    end
  end
end

# 1413 too low
# 1455 wrong
# 1500 wrong
# 1618 wrong