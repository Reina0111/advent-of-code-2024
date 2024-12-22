require_relative "../lib/helper"
require 'matrix'

class Solution22
  include Helper

  FILE_NAME = "22th-day/input.txt"
  ITERATIONS = 2000

  def solution()
    result = 0

    read_file(FILE_NAME).each do |line|
      number = line.strip.to_i
      for i in (1..ITERATIONS) do
        number = calculate_next_number(number)
      end

      result += number
    end

    result
  end

  def solution_part2()
    @changes_difs = {}

    read_file(FILE_NAME).each_with_index do |line, ind|
      visited_changes = []
      visited_numbers = []
      current_change = []
      number = line.strip.to_i
      for i in (1..ITERATIONS) do
        next_number = calculate_next_number(number)

        current_change << (next_number % 10) - (number % 10)
        
        current_change.shift if current_change.length > 4

        if current_change.length == 4
          cc = current_change.clone

          if !visited_changes.include?(cc)

            @changes_difs[cc] ||= 0
            @changes_difs[cc] += next_number % 10

            visited_changes << cc
          end
        end

        break if visited_numbers.include?(next_number)
        visited_numbers << next_number

        number = next_number
      end
      
      # puts "line #{ind} finished"
    end

    #  puts @changes_difs.to_a.sort_by { |k, v| -v }[0].to_s

    @changes_difs.to_a.sort_by { |k, v| -v }[0][1]
  end

  def calculate_next_number(number)
    new_number = number * 64
    new_number = mix(number, new_number)
    new_number = prune(new_number)

    new_number2 = new_number / 32
    new_number2 = mix(new_number, new_number2)
    new_number2 = prune(new_number2)

    new_number3 = new_number2 * 2048
    new_number3 = mix(new_number2, new_number3)
    new_number3 = prune(new_number3)
    
    new_number3
  end

  def mix(original_number, new_number)
    original_number ^ new_number
  end

  def prune(number)
    number % 16777216
  end
end