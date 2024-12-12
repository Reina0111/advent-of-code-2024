require_relative "../lib/helper"

class Solution10
  include Helper

  FILE_NAME = "10th-day/input.txt"


  def solution()
    @stats = {}
    result = 0

    nines.each do |i, j|
      count_score(i, j, [i, j])
    end

    @stats.keys.each do |key|
    end

    zeros.each do |zero|
      result += @stats[zero].size || 0
    end

    result
  end

  def solution_part2()
    @stats_rating = {}
    result = 0

    nines.each do |i, j|
      count_rating(i, j)
    end

    zeros.each do |zero|
      result += @stats_rating[zero] || 0
    end

    result
  end

  def data
    return @data if @data

    @data = {
      map: [],
      nines: [],
      zeros: [],
    }

    lines = read_file(FILE_NAME)
    lines.each_with_index do |line, index|
      row = line.strip.split("").map { |el| el == "." ? -1 : el.to_i }
      @data[:map] << row
      @data[:nines] += row.each_with_index.map { |num, i| num == 9 ? [index, i] : nil }.compact
      @data[:zeros] += row.each_with_index.map { |num, i| num == 0 ? [index, i] : nil }.compact
    end

    @data
  end

  def map
    data[:map]
  end

  def nines
    data[:nines]
  end

  def zeros
    data[:zeros]
  end

  def count_rating(i, j)
    @stats_rating[[i, j]] ||= 0
    @stats_rating[[i, j]] += 1
    if i < 0 || j < 0 || map[i][j] == 0
      return
    end


    if i > 0 && map[i-1] && map[i-1][j] && map[i-1][j] == map[i][j] - 1
      count_rating(i-1, j)
    end
    
    if i < map.size && map[i+1] && map[i+1][j] && map[i+1][j] == map[i][j] - 1
      count_rating(i+1, j)
    end
    
    if j > 0 && map[i][j-1] && map[i][j-1] == map[i][j] - 1
      count_rating(i, j-1)
    end

    if j < map[i].size && map[i][j+1] && map[i][j+1] == map[i][j] - 1
      count_rating(i, j+1)
    end
  end

  def count_score(i, j, nine)
    if map[i][j] == 0
      @stats[[i, j]] ||= []
      @stats[[i, j]] << nine
      @stats[[i, j]].uniq!
    end


    if i > 0 && map[i-1] && map[i-1][j] && map[i-1][j] == map[i][j] - 1
      count_score(i-1, j, nine)
    end
    
    if i < map.size && map[i+1] && map[i+1][j] && map[i+1][j] == map[i][j] - 1
      count_score(i+1, j, nine)
    end
    
    if j > 0 && map[i][j-1] && map[i][j-1] == map[i][j] - 1
      count_score(i, j-1, nine)
    end

    if j < map[i].size && map[i][j+1] && map[i][j+1] == map[i][j] - 1
      count_score(i, j+1, nine)
    end
  end
end
