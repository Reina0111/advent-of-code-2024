require_relative "../lib/helper"

class Solution1
  include Helper

  FILE_NAME = "1st-day/input.txt"

  def solution()
    lines = read_file(FILE_NAME)
    count = 0

    lines.each do |line|
        row = line.split(" ").map(&:strip).map(&:to_i)
        differences = row.each_cons(2).map { |a,b| b-a }
        
        if differences.count { |num| ![-1,-2,-3].include?(num) } == 0 || differences.count { |num| ![1,2,3].include?(num) } == 0
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
        
        # order is right or only first or last element is wrong so we can just skip it
        if differences.count { |num| ![-1,-2,-3].include?(num) } == 0 || differences.count { |num| ![1,2,3].include?(num) } == 0 ||
           differences[1..-1].count { |num| ![-1,-2,-3].include?(num) } == 0 || differences[1..-1].count { |num| ![1,2,3].include?(num) } == 0 ||
           differences[0..-2].count { |num| ![-1,-2,-3].include?(num) } == 0 || differences[0..-2].count { |num| ![1,2,3].include?(num) } == 0
            count += 1
        else
            next if differences.count { |num| [1,2,3].include?(num) } > 1 && differences.count { |num| ![1,2,3].include?(num) } > 1
            next if differences.count { |num| [-1,-2,-3].include?(num) } > 1 && differences.count { |num| ![-1,-2,-3].include?(num) } > 1
            
            next if differences.all? { |num| num > 0 } || differences.all? { |num| num < 0 }
            # if all differences are more than 0 then we have at least one gap of 4 or more and deleting it will only widen the gap
            puts "#{row.join(" ")} = #{differences.join(" ")}"
            next if differences.count { |num| num > 3 || num < -3 || num == 0 } > 1
            
            puts "OK"
            count += 1
        end
            
    end

    count
  end
end