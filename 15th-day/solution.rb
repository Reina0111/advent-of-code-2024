require_relative "../lib/helper"
require 'matrix'

class Solution15
  include Helper

  FILE_NAME = "15th-day/input.txt"


  def solution()
    data[:directions].each do |direction|
      move_robot(direction)
    end

    puts data[:map]
  end

  def solution_part2()
    0
  end

  def data
    return @data if @data

    map = []
    directions = []

    read_directions = false
    read_file(FILE_NAME).each do |line|
      if read_directions
        directions += line.strip.split("").map do |dir|
          case dir
          when "<"
            LEFT
          when ">"
            RIGHT
          when "^"
            UP
          when "v"
            DOWN
          end
        end
      elsif line.strip == ""
        read_directions = true
      else
        map << line.strip.split("")
      end
    end

    @data = {
      map: Matrix[*map],
      directions: directions,
    }

    @robot_position = @data[:map].index("@")

    @data
  end

  def robot_position
    return @robot_position if @robot_position

    data

    @robot_position
  end

  def move_robot(direction)
    what_to_move = moving_index(direction, robot_position)
    # puts "direction: #{direction}, what to move #{what_to_move}"
    return if what_to_move == nil

    case direction
    when UP
      array = @data[:map].column(@robot_position[1])[what_to_move].rotate(1)
      what_to_move.to_a.each_with_index do |map_index, array_index|
        @data[:map][map_index, @robot_position[1]] = array[array_index]
      end
    when RIGHT
      array = @data[:map].row(@robot_position[0])[what_to_move].rotate(-1)
      what_to_move.to_a.each_with_index do |map_index, array_index|
        @data[:map][@robot_position[0], map_index] = array[array_index]
      end
    when DOWN
      array = @data[:map].column(@robot_position[1])[what_to_move].rotate(-1)
      what_to_move.to_a.each_with_index do |map_index, array_index|
        @data[:map][map_index, @robot_position[1]] = array[array_index]
      end
    when LEFT
      array = @data[:map].row(@robot_position[0])[what_to_move].rotate(1)
      what_to_move.to_a.each_with_index do |map_index, array_index|
        @data[:map][@robot_position[0], map_index] = array[array_index]
      end
    end

    @robot_position = @data[:map].index("@")
  end

  def moving_index(direction, robot_index)
    case direction
    when UP
      obstacle_index = @data[:map].column(robot_index[1]).to_a[0..robot_index[0] - 1].rindex { |place| ["#", "."].include?(place) }
      if data[:map].column(robot_index[1])[obstacle_index] == "#"
        # no movement
        return nil
      else
        return (obstacle_index..robot_index[0])
      end
    when RIGHT
      obstacle_index = @data[:map].row(robot_index[0]).to_a[robot_index[1] + 1..-1].index { |place| ["#", "."].include?(place) }
      if data[:map].row(robot_index[0])[robot_index[1] + obstacle_index + 1] == "#"
        # no movement
        return nil
      else
        return (robot_index[1]..robot_index[1] + obstacle_index + 1)
      end
    when DOWN
      obstacle_index = @data[:map].column(robot_index[1]).to_a[robot_index[0] + 1..-1].index { |place| ["#", "."].include?(place) }
      # puts "obstacle robot_index #{obstacle_index} DOWN" 
      # puts "#{@data[:map].column(robot_index[1]).to_a[robot_index[0] + 1..-1]}"
      # puts "obstacle robot_index #{obstacle_index} RIGHT"
      # puts robot_index[1] + obstacle_index
      if data[:map].column(robot_index[1])[robot_index[0] + obstacle_index + 1] == "#"
        # no movement
        return nil
      else
        return (robot_index[0]..robot_index[0] + obstacle_index + 1)
      end
    when LEFT
      obstacle_index = @data[:map].row(robot_index[0]).to_a[0..robot_index[1] - 1].rindex { |place| ["#", "."].include?(place) }
      # puts "obstacle robot_index #{obstacle_index} LEFT" 
      if data[:map].row(robot_index[0])[obstacle_index] == "#"
        # no movement
        return nil
      else
        return (obstacle_index..robot_index[1])
      end
    end
  end
end
