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
        end
      end
    end

    # puts shortcuts.map { |k, v| [k, v.count] }.to_s

    shortcuts.select { |k, v| k >= 100 }.values.flatten(1).uniq.count
  end

  def solution_part2()
    data
    graph
    cheat_graph
    
    @result = dijkstra_all_paths(@graph, @snake_position)
    path = @result[:paths][@end_position][0]
    numbered_path = path.each_with_index.map { |position, index| [position, index] }.to_h

    shortcuts = {}
    checked_paths = {}

    # puts @cheat_graph.to_s

    path[0..-2].each do |i, j|
      # previous_step = path[numbered_path[[i, j]] - 1]
      # next_step = path[numbered_path[[i, j]] + 1]
      # @cheat_graph[[[i, j], @data[i ,j]]].delete([previous_step, @data[previous_step[0], previous_step[1]]]) if @data[i, j] != "S"
      # @cheat_graph[[[i, j], @data[i ,j]]].delete([next_step, @data[next_step[0], next_step[1]]])

      # puts "#{[i, j]} - #{numbered_path[[i, j]]}"
      possible_cheats = dijkstra_all_paths(@cheat_graph, [[i, j], @data[i, j]], skip_paths: true, limit: 20)
      # puts "after dijkstra"

      # puts possible_cheats[:distances].to_s

      # # puts [i, j].to_s

      possible_cheats[:distances].select { |k, v| k[1] == "." || k[1] == "E" }.each do |k, distance|
        saved = numbered_path[k[0]] - numbered_path[[i, j]] - distance
        next if saved <= 0

        # if saved == 50
        #   puts "#{saved} for #{[[i, j], k[0]]}: #{numbered_path[k[0]]} - #{numbered_path[[i,j]]} - #{distance}"
        #   puts possible_cheats[:paths][k][0].to_s
        # end
        
        shortcuts[saved] ||= []
        shortcuts[saved] << [[i, j], k[0]]
      end

      # @cheat_graph[[[i, j], @data[i ,j]]][[previous_step, @data[previous_step[0], previous_step[1]]]] = 1 if @data[i, j] != "S"
      # @cheat_graph[[[i, j], @data[i ,j]]][[next_step, @data[next_step[0], next_step[1]]]] = 1
    end
    
    # puts checked_paths.to_s
    # puts shortcuts[76].sort.to_s
    # puts shortcuts.select { |k, v| k >= 100 }.map { |k, v| [k, v.count]}.sort.to_h.to_s

    shortcuts.select { |k, v| k >= 100 }.values.flatten(1).uniq.count
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

  def cheat_graph
    @cheat_graph = {}

    (0..@data.row_count-1).each do |i|
      @data.row(i).to_a.each_with_index do |el, j|
        @cheat_graph[[[i, j], @data[i, j]]] ||= {}
        # [UP, RIGHT, DOWN, LEFT].each do |direction|
        #   direction = [direction, [2, 2]].transpose.map { |a| a.reduce(:*) }
        #   index = [[i, j], direction].transpose.map(&:sum)
        #   if index[0] >= 0 && index[0] <= @max_xy && index[1] >= 0 && index[1] <= @max_xy
        #     @cheat_graph[[[i, j], @data[i, j]]][[index, @data[index[0], index[1]]]] = 2
        #   end
        # end

        # [[-1,-1], [-1, 1], [1, -1], [1,1]].each do |direction|
        #   index = [[i, j], direction].transpose.map(&:sum)
        #   if index[0] >= 0 && index[0] <= @max_xy && index[1] >= 0 && index[1] <= @max_xy
        #     @cheat_graph[[[i, j], @data[i, j]]][[index, @data[index[0], index[1]]]] = 2
        #   end
        # end

        [UP, RIGHT, DOWN, LEFT].each do |direction|
          index = [[i, j], direction].transpose.map(&:sum)
          if index[0] >= 0 && index[0] <= @max_xy && index[1] >= 0 && index[1] <= @max_xy
            @cheat_graph[[[i, j], @data[i, j]]][[index, @data[index[0], index[1]]]] = 1
          end
        end
      end
    end
  end
end
