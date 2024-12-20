require_relative "../lib/helper"
require 'matrix'

class Solution20
  include Helper

  FILE_NAME = "20th-day/input.txt"

  def solution()
    data
    graph
    
    @result = dijkstra_all_paths(@graph, @snake_position)
    path = @result[:paths][@end_position][0]

    numbered_path = path.each_with_index.map { |position, index| [position, index] }.to_h
    path_indexes = path.each_with_index.map { |position, index| [index, position] }.to_h

    shortcuts = {}

    # puts numbered_path.to_s

    path[0..-2].each do |i, j|
      [UP, RIGHT, DOWN, LEFT].each do |direction|
        index = [[i, j], direction].transpose.map(&:sum)
        index2 = [index, direction].transpose.map(&:sum)

        # puts "shortcut? #{[i, j]}, #{index}, #{index2}"

        if index2[0] >= 0 && index2[0] < @max_xy && index2[1] >= 0 && index2[1] < @max_xy && @data[index2[0], index2[1]] != "#" && @data[index[0], index[1]] == "#"
          saved = numbered_path[index2] - numbered_path[[i, j]] - 2

          # puts "shortcut? #{[i, j]}, #{index}, #{index2}" if saved == 8 
          next if saved < 0
          shortcuts[saved] ||= []
          shortcuts[saved] << index
          shortcuts[saved].uniq!
        end
      end
    end

    # puts shortcuts.map { |k, v| [k, v.count] }.to_s

    shortcuts.select { |k, v| k >= 100 }.values.flatten(1).count
  end

  def solution_part2()
    0
  end

  def data
    return @data if @data

    map = []
    directions = []

    read_file(FILE_NAME).each do |line|
      map << line.strip.split("")
    end

    @data = Matrix[*map]
    @max_xy = @data.row(0).count

    @snake_position = @data.index("S")
    @end_position = @data.index("E")

    @data
  end

  def graph
    @graph = {}

    (0..@data.row_count-1).each do |i|
      @data.row(i).to_a.each_with_index do |el, j|
        if el != '#' && el != "E"
          @graph[[i, j]] ||= {}
          [UP, RIGHT, DOWN, LEFT].each do |direction|
            index = [[i, j], direction].transpose.map(&:sum)
            if index[0] >= 0 && index[0] <= @max_xy && index[1] >= 0 && index[1] <= @max_xy && @data[index[0], index[1]] != "#"
              @graph[[i, j]][index] = 1
            end
          end
        end
      end
    end
  end
end
