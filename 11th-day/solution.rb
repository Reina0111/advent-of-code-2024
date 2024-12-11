require_relative "../lib/helper"
require 'matrix'

class Solution11
  include Helper

  FILE_NAME = "11th-day/input.txt"
  MAX_STEP = 25

  def solution()
    data = read_file(FILE_NAME).first.strip.split(" ").map(&:to_i)
    list = data.clone()

    data.each do |number|
      make_map(number)
    end
 
    result = 0
    
    data.each do |number|
      result += get_length(number)
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

  def make_map(number)
    return if known_steps[number]

    new_numbers = next_step(number)
    @known_steps[number] = new_numbers

    new_numbers.each do |new_number|
      make_map(new_number)
    end
  end

  def get_length(number, distance = MAX_STEP)
    if distance == 0
      return 1
    end

    step = next_step(number)
    if step.size == 1
      get_length(step.first, distance - 1)
    else
      get_length(step.first, distance - 1) + get_length(step.last, distance - 1)
    end
  end
end
