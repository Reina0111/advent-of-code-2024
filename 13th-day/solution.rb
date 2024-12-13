require_relative "../lib/helper"
require 'matrix'

class Solution13
  include Helper

  FILE_NAME = "13th-day/input.txt"

  def solution()
    result = 0

    prepare_data

    @sets.each do |set|
      res = check_prize_math(set)
      result += res
    end

    result
  end

  def solution_part2()
    result = 0

    prepare_data

    @sets.each do |set|
      set[:prize][:x] += 10000000000000
      set[:prize][:y] += 10000000000000
      res = check_prize_math(set, false)
      # res2 = check_prize_b(set)
      # puts "#{set} - #{res}, #{res2}" if res != res2
      # if res > 0 && res2 > 0
      #   puts "#{[res, res2].min}" if res != res2
      #   result += [res, res2].min
      # else
      #   puts "#{[res, res2].max}" if res != res2
      #   result += [res, res2].max
      # end
      result += res
    end

    result
  end

  def prepare_data
    return @sets if @sets

    @sets = []

    set = new_set.clone
    
    read_file(FILE_NAME).map do |line|
      type, x, _, y = line.strip.split(/\+|, |\=/)

      next if type.to_s.size == 0

      if type.start_with?("Button A")
        set[:a][:x] = x.to_i
        set[:a][:y] = y.to_i
      elsif type.start_with?("Button B")
        set[:b][:x] = x.to_i
        set[:b][:y] = y.to_i
      else
        set[:prize][:x] = x.to_i
        set[:prize][:y] = y.to_i

        @sets << set
        set = new_set.clone
      end
    end

    @sets
  end

  def new_set
    {
      a: {
        x: 0,
        y: 0,
      },
      b: {
        x: 0,
        y: 0,
      },
      prize: {
        x: 0,
        y: 0,
      }
    }
  end

  # brute force
  # def check_prize_a(set)
  #   x = 0
  #   y = 0

  #   i = 1
    
  #   while i <= 100 && set[:a][:x] * i <= set[:prize][:x] && set[:a][:y] * i <= set[:prize][:y]
  #     x = set[:a][:x] * i
  #     y = set[:a][:y] * i

  #     b_x = (set[:prize][:x] - x) / set[:b][:x]
  #     b_y = (set[:prize][:y] - y) / set[:b][:y]
      
  #     i += 1

  #     next if b_x != b_y || b_x > 100

  #     x +=  set[:b][:x] * b_x
  #     y +=  set[:b][:y] * b_x

      
  #     if x == set[:prize][:x] && y == set[:prize][:y]
  #       # puts "A: #{i - 1}, B: #{b_x}"
  #       return 3 * (i - 1) + b_x
  #     end
  #   end

  #   return 0
  # end

  # brute force 2
  # def check_prize_b(set)
  #   x = 0
  #   y = 0

  #   i = 1
    
  #   while i <= 100 && set[:b][:x] * i <= set[:prize][:x] && set[:b][:y] * i <= set[:prize][:y]
  #     x = set[:b][:x] * i
  #     y = set[:b][:y] * i

  #     a_x = (set[:prize][:x] - x) / set[:a][:x]
  #     a_y = (set[:prize][:y] - y) / set[:a][:y]
      
  #     i += 1

  #     next if a_x != a_y || a_x > 100

  #     x +=  set[:a][:x] * a_x
  #     y +=  set[:a][:y] * a_x

  #     if x == set[:prize][:x] && y == set[:prize][:y]
  #       # puts "A: #{a_x}, B: #{i - 1}"
  #       return 3 * a_x + (i - 1)
  #     end
  #   end

  #   return 0
  # end

  def check_prize_math(set, limit = true)
    a_x = set[:a][:x]
    b_x = set[:b][:x]
    p_x = set[:prize][:x]
    
    a_y = set[:a][:y]
    b_y = set[:b][:y]
    p_y = set[:prize][:y]

    b = ((a_x * p_y - a_y * p_x) * 1.0) / (a_x * b_y - a_y * b_x)

    return 0 if b != b.to_i

    a = (p_x - b_x * b) / a_x

    return 0 if a != a.to_i

    a = a.to_i
    b = b.to_i
    
    # puts "#{set[:prize]} - A: #{a}, B: #{b}"

    return 0 if (limit && (a > 100 || b > 100)) || p_x != a_x * a + b_x * b || p_y != a_y * a + b_y * b

    # puts "A: #{a}, B: #{b}"
    return a * 3 + b
  end
end
