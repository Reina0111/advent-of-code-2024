require_relative "../lib/helper"
require 'matrix'

class Solution11
  include Helper

  FILE_NAME = "11th-day/input.txt"
  MAX_STEP = 2

  def solution()
    @steps_statistics = {
      0 => {
        1 => [1]
      }
    }
    data = read_file(FILE_NAME).first.strip.split(" ").map(&:to_i)
    puts data.join(", ")
    result = 0
    data.each do |elements|
      elements = [elements]
      step = 0
      full_result = []

      while step < MAX_STEP do
        puts "pętla #{step}, dla [#{elements.join(", ")}]"
        res1 = []
        elements.flatten.each do |el|
          res = next_step(el)
          # puts "[#{res.join(", ")}]"

          @known_steps[el] = res
          full_result << res if step == MAX_STEP - 1
          res1 << res
          res1.flatten
        end

        puts "po pętli #{step}, dla [#{elements.join(", ")}]: [#{res1.join(", ")}]"
        elements = res1
        step += 1
      end

      result += full_result.size
    end
    
    result
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
end

# 120193 is too low