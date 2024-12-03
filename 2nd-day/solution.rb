require_relative "../lib/helper"

class Solution2
  include Helper

  FILE_NAME = "2nd-day/input.txt"

  def solution()
    lines = read_file(FILE_NAME)
    count = 0

    lines.each do |line|
        row = line.split(" ").map(&:strip).map(&:to_i)
        differences = row.each_cons(2).map { |a,b| b-a }
        sorted = row.sort
        if (row == sorted || row == sorted.reverse()) && (differences.uniq - [-3,-2,-1, 1,2,3]).empty?
            count += 1
        end
    end

    count
  end

  def solution_part2()
    lines = read_file(FILE_NAME)
    count = 0

    lines.each do |line|
        row = line.split(" ").map(&:strip).map(&:to_i)
        differences = row.each_cons(2).map { |a,b| b-a }
        
        if differences.count { |num| ![-1,-2,-3].include?(num) } == 0 || differences.count { |num| ![1,2,3].include?(num) } == 0
            count += 1
            next
        end

        i = 0
        done = false
        while i < row.size() && !done do
          shorter_row = row.clone()
          shorter_row.delete_at(i)

          differences = shorter_row.each_cons(2).map { |a,b| b-a }
          if differences.count { |num| ![-1,-2,-3].include?(num) } == 0 || differences.count { |num| ![1,2,3].include?(num) } == 0
            count += 1
            done = true
          end
          i += 1
        end
    end

    count
  end
end