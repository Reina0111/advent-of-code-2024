require_relative "../lib/helper"

class Solution1
  include Helper

  FILE_NAME = "1st-day/input.txt"

  def solution()
    lines = read_file(FILE_NAME)

    first_set = []
    second_set = []
    first, second = lines.map { |line| line.split(" ").map(&:strip).map(&:to_i) }
    first_set << first
    second_set << second

    first_set.sort!
    second_set.sort!

    results = []

    first_set.each_with_index do |value, index|
        results << (value - second_set[index]).abs
    end

    results.sum
  end

  def solution_part2()
    lines = read_file(FILE_NAME)

    first_set = []
    second_set = []
    first, second = lines.map { |line| line.split(" ").map(&:strip).map(&:to_i) }
    first_set << first
    second_set << second

    f = first_set.tally
    s = second_set.tally
    
    result = 0
    
    f.each do |k, v|
        if s[k]
            result += k * v * s[k] 
        end
    end
    
    result
  end
end