require_relative "../lib/helper"
require 'matrix'
require 'dijkstra_fast'

class Solution18
  include Helper

  FILE_NAME = "18th-day/input.txt"
  MAX_XY = 70
  OBSTACLES = 1024

  def solution()
    data
    fill_obstacles

    graph
    # puts graph.to_s
    
    @result = dijkstra_all_paths(@graph, @start_position, skip_paths: true)
    @result[:distances][@end_position]
  end

  def solution_part2()
    i = OBSTACLES
    data
    fill_obstacles

    loop do
      fill_obstacles(i-1, i)
      graph
      # puts graph.to_s
      
      @result = dijkstra_all_paths(@graph, @start_position, skip_paths: true)
      break if @result[:distances][@end_position] == Float::INFINITY

      # puts i
      i += 1
    end
    
    @obstacles[i+1].reverse.join(",")
  end

  def data
    @data = Matrix[*(Array.new(MAX_XY+1) { Array.new(MAX_XY+1, ".") })]

    @start_position = [0, 0]
    @end_position = [MAX_XY, MAX_XY]

    get_obstacles

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
            if index[0] >= 0 && index[0] <= MAX_XY && index[1] >= 0 && index[1] <= MAX_XY && @data[index[0], index[1]] != "#"
              @graph[[i, j]][index] = 1
            end
          end
        end
      end
    end
  end

  def fill_obstacles(start = 0, ending = OBSTACLES)
    i = start

    while i < ending
      obstacle = @obstacles[i]
      @data[obstacle[0], obstacle[1]] = "#"
      i += 1
    end
  end

  def get_obstacles
    @obstacles = []

    read_file(FILE_NAME).each do |line|
      y, x = line.strip.split(",").map(&:to_i)

      @obstacles << [x, y]
    end
  end
end
