require_relative "../lib/helper"
require 'matrix'

class Solution15
  include Helper

  FILE_NAME = "15th-day/input.txt"


  def solution()
    data[:directions].each do |direction|
      move_robot(direction)
    end

    get_coordinates()
  end

  def solution_part2()
    # @data = nil
    # @data2 = data

    data2[:directions].each_with_index do |direction, index|
      # puts direction.to_s
      # if index % 500 == 0
      #   puts "#{index}, #{direction}"
      #   pretty_print_matrix(data2[:map])
      # end
      move_robot2(direction)
    end

    # pretty_print_matrix(data2[:map])
    get_coordinates(data2[:map], "[")
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
        # puts line
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

  def data2
    return @data2 if @data2

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
        map << line.strip.split("").map do |el|
          case el
          when "#"
            ["#", "#"]
          when "O"
            ["[", "]"]
          when "@"
            ["@", "."]
          else
            [".", "."]
          end
        end.flatten
      end
    end

    @data2 = {
      map: Matrix[*map],
      directions: directions,
    }

    @robot_position = @data2[:map].index("@")

    @data2
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

  def get_coordinates(map = data[:map], element_to_find = "O")
    i = 1

    sum = 0

    while (row = map.row(i))
      row = map.row(i)
      indexes = row.each_with_index.select { |el, index| el == element_to_find }.map { |el, index| index }

      # puts row.to_s
      # puts indexes.to_s
      # puts i
      # puts 100 * i * indexes.size + indexes.sum

      sum += 100 * i * indexes.size + indexes.sum

      i += 1
    end

    sum
  end

  def move_robot2(direction)
    what_to_move = moving_index2(direction, robot_position)
    # puts "direction: #{direction}, what to move #{what_to_move}"
    return if what_to_move == [nil]

    # puts what_to_move.to_s
    what_to_move.each do |axis, section|
    # puts "axis #{axis}, section: #{section}"
      case direction
      when UP
        array = @data2[:map].column(axis)[section].rotate(1)
        section.to_a.each_with_index do |map_index, array_index|
          @data2[:map][map_index, axis] = array[array_index]
        end
      when RIGHT
        array = @data2[:map].row(axis)[section].rotate(-1)
        section.to_a.each_with_index do |map_index, array_index|
          @data2[:map][axis, map_index] = array[array_index]
        end
      when DOWN
        array = @data2[:map].column(axis)[section].rotate(-1)
        section.to_a.each_with_index do |map_index, array_index|
          @data2[:map][map_index, axis] = array[array_index]
        end
      when LEFT
        array = @data2[:map].row(axis)[section].rotate(1)
        section.to_a.each_with_index do |map_index, array_index|
          @data2[:map][axis, map_index] = array[array_index]
        end
      end
    end

    @robot_position = @data2[:map].index("@")
  end

  def moving_index2(direction, robot_index, skip_indexes = [])
    # puts "get result for #{robot_index} and #{direction}"
    case direction
    when UP
      map = @data2[:map].column(robot_index[1]).to_a[0..robot_index[0] - 1]
      # puts "#{robot_index} -> #{map.to_s}"
      obstacle_index = map.rindex { |place| ["#", "."].include?(place) }
      if data2[:map].column(robot_index[1])[obstacle_index] == "#"
        # no movement
        return [nil]
      else
        indexes = find_last_indexes(map).uniq.select { |i| i >= obstacle_index }
        result = [[robot_index[1], (obstacle_index..robot_index[0])]]
        # puts obstacle_index
        # puts indexes.map { |i| [i, robot_index[1]] }.to_s
        indexes.each do |index|
          next if ["#", "."].include?(data2[:map][index, robot_index[1]])
          case data2[:map][index, robot_index[1]]
          when "["
            result += moving_index2(direction, [index, robot_index[1] + 1])
          else
            result += moving_index2(direction, [index, robot_index[1] - 1])
          end
          return [nil] if result.select { |res| res == nil }.count > 0
        end
        if result.select { |res| res == nil }.count > 0
          return [nil]
        else
          # puts "finish result for #{robot_index} and #{direction}"
          return combine_ranges(result)
        end
      end
    when RIGHT
      obstacle_index = @data2[:map].row(robot_index[0]).to_a[robot_index[1] + 1..-1].index { |place| ["#", "."].include?(place) }
      if data2[:map].row(robot_index[0])[robot_index[1] + obstacle_index + 1] == "#"
        # no movement
        return [nil]
      else
        return [[robot_index[0], (robot_index[1]..robot_index[1] + obstacle_index + 1)]]
      end
    when DOWN
      map = @data2[:map].column(robot_index[1]).to_a[robot_index[0] + 1..-1]
      # puts "#{robot_index} -> #{map.to_s}"
      obstacle_index = map.index { |place| ["#", "."].include?(place) }
      if data2[:map].column(robot_index[1])[robot_index[0] + obstacle_index + 1] == "#"
        # no movement
        return [nil]
      else
        last_index = map.index { |el| ["#", "."].include?(el) }
        result = [[robot_index[1], (robot_index[0]..robot_index[0] + obstacle_index + 1)]]
        (0..last_index - 1).each do |index|
          next if ["#", "."].include?(data2[:map][robot_index[0] + index + 1, robot_index[1]])
          case data2[:map][robot_index[0] + index + 1, robot_index[1]]
          when "["
            # puts "get right result for #{robot_index} and #{direction} -> #{[robot_index[0] + index + 1, robot_index[1] + 1]}"
            result += moving_index2(direction, [robot_index[0] + index + 1, robot_index[1] + 1])
            # puts "#{robot_index} -> right #{result}"
          when "]"
            # puts "get left result for #{robot_index} and #{direction} -> #{[robot_index[0] + index + 1, robot_index[1] - 1]}"
            result += moving_index2(direction, [robot_index[0] + index + 1, robot_index[1] - 1])
            # puts "#{robot_index} -> left #{result}"
          end
          return [nil] if result.select { |res| res == nil }.count > 0
        end
      # puts result
        if result.select { |res| res == nil }.count > 0
          return [nil]
        else
          # puts "finish result for #{robot_index} and #{direction}"
          # puts combine_ranges(result).to_s
          return combine_ranges(result)
        end
      end
    when LEFT
      obstacle_index = @data2[:map].row(robot_index[0]).to_a[0..robot_index[1] - 1].rindex { |place| ["#", "."].include?(place) }
      if data2[:map].row(robot_index[0])[obstacle_index] == "#"
        # no movement
        return [nil]
      else
        return [[robot_index[0], (obstacle_index..robot_index[1])]]
      end
    end
  end

  def combine_ranges(ranges)
    sorted_ranges = ranges.sort_by { |index, range| [index, range.begin, range.end] }
  
    merged_ranges = {}
    sorted_ranges.group_by { |index, _range| index }.map { |k, v| [k, v.map { |i, range| range }] }.to_h.each do |index, index_ranges|
      merged_ranges[index] ||= []
        index_ranges.each do |range|
        if merged_ranges[index].empty? || merged_ranges[index].last.end < range.begin - 1
          merged_ranges[index] << range
        else
          last_range = merged_ranges[index].pop
          merged_ranges[index] << (last_range.begin..[last_range.end, range.end].max)
        end
      end
    end

    merged_ranges.map { |k, v| v.map { |el| [k, el] }}.flatten(1)
  end

  def find_last_indexes(array)
    last_indexes = []
    
    array.each_with_index do |elem, index|
      if index == array.size - 1 || elem != array[index + 1]
        last_indexes << index
      end
    end
    
    last_indexes
  end

  def find_first_indexes(array)
    array.slice_when { |a, b| a != b } 
         .map { |group| array.index(group.first) }
  end
end
