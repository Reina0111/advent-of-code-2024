require_relative "../lib/helper"
require 'matrix'

class Solution8
  include Helper

  FILE_NAME = "8th-day/input.txt"


  def solution()
    @antinodes = []

    get_antinodes_for_antennas

    return @antinodes.uniq.size
  end

  def solution_part2()
    @antinodes = []

    get_antinodes_for_antennas_all_distances

    return @antinodes.uniq.size
  end

  def antennas
    return @antennas if @antennas

    lines = read_file(FILE_NAME)
    @antennas = {}
    @max_i = lines.size() - 1 
    @max_j = lines.first.strip.size() - 1 # remember the \n

    lines.each_with_index do |line, i|
      line.split("").each_with_index do |object, j|
        next if object == "." || object == "\n"

        @antennas[object] ||= []
        @antennas[object] << [i, j]
      end
    end

    @antennas
  end

  def max_i
    return @max_i if @max_i

    antennas

    @max_i
  end

  def max_j
    return @max_j if @max_j

    antennas

    @max_j
  end

  MULTIPLY_VECTORS = [[1, 1], [-1, -1]]

  def get_antinodes_for_antennas
    antennas.each do |key, list|
      list[0..-2].each_with_index do |antenna, index|
        list[index+1..-1].each do |second_antenna|
          # antenna = [1, 8]
          # second_antenna = [2, 6]
          # distance = [1, -2]
          distance = [second_antenna[0] - antenna[0], second_antenna[1] - antenna[1]]

          MULTIPLY_VECTORS.each do |vector|
            antinode = [antenna[0] + distance[0] * vector[0], antenna[1] + distance[1] * vector[1]]

            if ![antenna, second_antenna].include?(antinode) && antinode[0] > -1 && antinode[0] <= @max_i && antinode[1] > -1 && antinode[1] <= @max_j
              # puts "[#{antenna.join(", ")}], [#{second_antenna.join(", ")}], [#{antinode.join(", ")}], (#{distance.join(", ")})"
              @antinodes << antinode
            end

            antinode = [second_antenna[0] + distance[0] * vector[0], second_antenna[1] + distance[1] * vector[1]]

            if ![antenna, second_antenna].include?(antinode) && antinode[0] > -1 && antinode[0] <= @max_i && antinode[1] > -1 && antinode[1] <= @max_j
              # puts "[#{antenna.join(", ")}], [#{second_antenna.join(", ")}], [#{antinode.join(", ")}], (#{distance.join(", ")})"
              @antinodes << antinode
            end
          end
        end
      end
    end
  end
  def get_antinodes_for_antennas_all_distances
    antennas.each do |key, list|
      list[0..-2].each_with_index do |antenna, index|
        list[index+1..-1].each do |second_antenna|
          # antenna = [1, 8]
          # second_antenna = [2, 6]
          # distance = [1, -2]
          dist = [second_antenna[0] - antenna[0], second_antenna[1] - antenna[1]]
          distance = [0, 0]

          while distance[0].abs <= @max_i && distance[1].abs <= @max_j
            MULTIPLY_VECTORS.each do |vector|
              antinode = [antenna[0] + distance[0] * vector[0], antenna[1] + distance[1] * vector[1]]

              if antinode[0] > -1 && antinode[0] <= @max_i && antinode[1] > -1 && antinode[1] <= @max_j
                # puts "[#{antenna.join(", ")}], [#{second_antenna.join(", ")}], [#{antinode.join(", ")}], (#{distance.join(", ")})"
                @antinodes << antinode
              end

              antinode = [second_antenna[0] + distance[0] * vector[0], second_antenna[1] + distance[1] * vector[1]]

              if antinode[0] > -1 && antinode[0] <= @max_i && antinode[1] > -1 && antinode[1] <= @max_j
                # puts "[#{antenna.join(", ")}], [#{second_antenna.join(", ")}], [#{antinode.join(", ")}], (#{distance.join(", ")})"
                @antinodes << antinode
              end
            end

            distance = [dist[0] + distance[0], dist[1] + distance[1]]
          end
        end
      end
    end
  end
end
