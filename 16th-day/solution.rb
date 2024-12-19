require_relative "../lib/helper"
require 'matrix'
require 'dijkstra_fast'

class Solution16
  include Helper

  FILE_NAME = "16th-day/input.txt"


  def solution()
    data
    graph
    
    @result = dijkstra_all_paths(@graph, [@snake_position, RIGHT])
    @result[:distances][[@end_position, RIGHT]]
  end

  def solution_part2()
    data
    graph
    
    @result = dijkstra_all_paths(@graph, [@snake_position, RIGHT]) if !@result
    @result[:paths][[@end_position, RIGHT]].flatten(1).map { |place, dir| place }.uniq.count
  end

  def data
    return @data if @data

    map = []
    directions = []

    read_file(FILE_NAME).each do |line|
      map << line.strip.split("")
    end

    @data = Matrix[*map]

    @snake_position = @data.index("S")
    @end_position = @data.index("E")

    @data
  end

  def graph
    return @graph if @graph
    @graph = {}
    (1..@data.row_count-2).each do |i|
      @data.row(i).to_a.each_with_index do |el, j|
        if el != '#' && el != "E"
          [UP, RIGHT, DOWN, LEFT].each do |direction|
            @graph[[[i, j], direction]] ||= {}
            index = [[i, j], direction].transpose.map(&:sum)
            if @data[index[0], index[1]] != "#"
              @graph[[[i, j], direction]][[index, direction]] = 1
            end
            @graph[[[i, j], direction]][[[i, j], UP]] = 1000
            @graph[[[i, j], direction]][[[i, j], DOWN]] = 1000
            @graph[[[i, j], direction]][[[i, j], LEFT]] = 1000
            @graph[[[i, j], direction]][[[i, j], RIGHT]] = 1000
          end
        end
      end
    end

    @graph[[@end_position, UP]] ||= {}
    @graph[[@end_position, LEFT]] ||= {}
    @graph[[@end_position, RIGHT]] ||= {}
    @graph[[@end_position, DOWN]] ||= {}
    @graph[[@end_position, UP]][[@end_position, LEFT]] = 0
    @graph[[@end_position, LEFT]][[@end_position, UP]] = 0
    @graph[[@end_position, RIGHT]][[@end_position, LEFT]] = 0
    @graph[[@end_position, LEFT]][[@end_position, RIGHT]] = 0
    @graph[[@end_position, DOWN]][[@end_position, LEFT]] = 0
    @graph[[@end_position, LEFT]][[@end_position, DOWN]] = 0
  end
end
