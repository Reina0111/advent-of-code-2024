require_relative "../lib/helper"
require 'matrix'

class Solution11
  include Helper

  FILE_NAME = "11th-day/input.txt"
  MAX_STEP = 10

  def solution()
    @steps_statistics = {}
    data = read_file(FILE_NAME).first.strip.split(" ").map(&:to_i)
    list = data.clone()

    set_statistics((0..9).to_a)
    
    puts @steps_statistics
    
    # result
  end

  def solution_part2()
  end

  def known_steps
    return @known_steps if @known_steps

    @known_steps = {
      0 => [1]
    }
  end

  def next_step(current)
    if known_steps[current]
      return known_steps[current]
    end

    if current == 0
      return [1]
    end

    current_as_string = current.to_s
    size = current_as_string.size
    if size % 2 == 0
      return [current_as_string[0, size / 2].to_i, current_as_string[size / 2, size / 2].to_i]
    end

    return [current * 2024]
  end

  def set_statistics(list)
    current_step = 1
    while current_step <= MAX_STEP do
      new_list = []
      list.each do |element|
        @steps_statistics[element] ||= {}
        next if @steps_statistics[element][1]


        step = next_step(element)
        @steps_statistics[element][1] = step

        @steps_statistics.each do |key, stats|
          found_step = stats.values.index { |a| a.include?(element) }
          if found_step
            @steps_statistics[key][found_step + 2] ||= []
            @steps_statistics[key][found_step + 2] += step
            @steps_statistics[key][found_step + 2].uniq!
          end
        end

        new_list += step
      end

      list = new_list
      current_step += 1
    end
  end
end

# 120193 is too low