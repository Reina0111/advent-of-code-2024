require_relative "../lib/helper"
require 'matrix'

class Solution12
  include Helper

  FILE_NAME = "12th-day/input.txt"
  MAX_STEP = 25
  MAX_STEP2 = 75
  KEYS = [1, 2, 4, 8, 16, 32, 64]

  def solution()
    prepare_data()

    # puts @regions
    # puts @regions.keys.map { |k, v| k }.to_s

    result = 0
    @regions.each do |_key, region|
      price = check_fence_price(region)
      result += price
      # puts region.to_s
      # puts price
    end

    result
  end

  def solution_part2()
    prepare_data()

    # puts @regions
    # puts @regions.keys.map { |k, v| k }.to_s

    result = 0
    @regions.each do |key, region|
      price = check_fence_price_discount(region, key[1], key)
      result += price
      # puts region.to_s
      # puts price
    end

    result
  end

  def prepare_data
    @garden = Matrix[*read_file(FILE_NAME).map { |line| line.strip.split("").map { |el| [el, false] } }]
    @max_i = @garden.row_count - 1
    @max_j = @garden.column_count - 1
    i = 0
    j = 0
    @regions = {}

    while i <= @max_i
      while j <= @max_j
        place, checked = @garden[i, j]
        if !checked
          @garden[i, j][1] = true
          @regions[[place, [i, j]]] = [[i, j]] + make_region(place, i, j)
        end
        j += 1
      end

      i += 1
      j = 0
    end
  end

  def make_region(letter, i, j)
    list = []

    if i < @max_i && @garden[i + 1, j][0] == letter && !@garden[i + 1, j][1]
      list << [i + 1, j]
      @garden[i + 1, j][1] = true

      list += make_region(letter, i + 1, j)
    end
    if i > 0 && @garden[i - 1, j][0] == letter && !@garden[i - 1, j][1]
      list << [i - 1, j]
      @garden[i - 1, j][1] = true

      list += make_region(letter, i - 1, j)
    end
    if j < @max_j && @garden[i, j + 1][0] == letter && !@garden[i, j + 1][1]
      list << [i, j + 1]
      @garden[i, j + 1][1] = true

      list += make_region(letter, i, j + 1)
    end
    if j > 0 && @garden[i, j - 1][0] == letter && !@garden[i, j - 1][1]
      list << [i, j - 1]
      @garden[i, j - 1][1] = true

      list += make_region(letter, i, j - 1)
    end

    list
  end

  def check_fence_price(region)
    area = region.size
    perimeter = 0
    region.each do |point|
      perimeter += 4 - region.select { |x, y| ((x == point[0] - 1 || x == point[0] + 1 ) && y == point[1]) || (x == point[0] && (y == point[1] - 1 || y == point[1] + 1)) }.size
    end

    area * perimeter
  end

  def check_fence_price_discount(region, starting_position, printing)
    # puts "BIG START #{starting_position}"
    neighbour_vectors = [[[0, 1], "RIGHT"], [[0, -1], "LEFT"], [[1, 0], "DOWN"], [[-1, 0], "UP"]]
    area = region.size
    borders = []
    region.each do |point|
      neighbours = region.select { |x, y| ((x == point[0] - 1 || x == point[0] + 1 ) && y == point[1]) || (x == point[0] && (y == point[1] - 1 || y == point[1] + 1)) }
      # puts neighbours.to_s
      not_neghbours = neighbour_vectors.map do |vector, point_dir|
        # puts [[point, vector].transpose.map(&:sum), point_dir].to_s
        [[point, vector].transpose.map(&:sum), point_dir]
      end.select { |possible_neighbour, _dir| !neighbours.include?(possible_neighbour) }

      # puts "#{point} -> #{not_neghbours} | #{neighbours}"

      borders += not_neghbours.map { |p, point_dir| [[point, [point, p].transpose.map { |a, b| -1 * (a - b) / 2.0}].transpose.map(&:sum), point_dir] }
    end

    # puts borders.to_s
    border_start = borders.first

    sides = 0
    while borders.size > 0
      side_borders = []
      positions = []
      # puts "start #{border_start}"
      if border_start[0][0].to_i == border_start[0][0]
        side_borders = borders.select { |b, dir| b[1] == border_start[0][1] && dir == border_start[1] }.sort { |b1, b2| b1[0][0] <=> b2[0][0]  }
        positions = side_borders.map { |x, y| x[0] }.sort
      else
        side_borders = borders.select { |b, dir| b[0] == border_start[0][0] && dir == border_start[1] }.sort { |b1, b2| b1[0][1] <=> b2[0][1]  }
        positions = side_borders.map { |x, y| x[1] }.sort
      end

      # puts "original side_borders #{side_borders}"

      # puts positions.to_s
      # puts positions.each_cons(2).map { |a, b| b - a }.to_s
      first_bad_index = positions.each_cons(2).map { |a, b| b - a }.index { |a| a > 1 }
      if first_bad_index
        side_borders = side_borders[0..first_bad_index]
      end

      sides += 1
      # puts "final #{side_borders}"
      borders -= side_borders

      border_start = borders.first
    end

    # puts starting_position.to_s
    # puts "#{printing} -> #{sides}, #{area}, #{sides * area}"
    sides * area
  end
end
