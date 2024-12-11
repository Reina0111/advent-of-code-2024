require_relative "../lib/helper"
require 'matrix'

class Solution11
  include Helper

  FILE_NAME = "11th-day/input.txt"
  MAX_STEP = 25
  MAX_STEP2 = 25

  def solution()
    data = read_file(FILE_NAME).first.strip.split(" ").map(&:to_i)
    list = data.clone()

    data.each do |number|
      make_map(number)
    end
 
    result = []
    
    data.each do |number|
      number_result = get_stones(number)
      result += number_result
      # puts "length for #{number} -> #{number_result.join(", ")}"
    end
    
    # puts result.join(", ")

    result.size
  end

  def solution_part2()
    data = read_file(FILE_NAME).first.strip.split(" ").map(&:to_i)
    list = data.clone()

    data.each do |number|
      make_map(number)
    end

    known_steps.keys.each do |number|
      make_map_per_5(number)
    end

    puts known_steps.keys.size

    known_steps.keys.each do |number|
      make_map_per_25(number)
    end
    puts "make_map_per_25 done"
 
    result = []
    
    data.each do |number|
      number_result = get_stones(number, MAX_STEP2 / 25, known_steps_by_25)
      result += number_result
      puts "length for #{number} -> #{number_result.size}"
    end

    result.size
  end

  def known_steps
    return @known_steps if @known_steps

    @known_steps = {
      0 => [1]
    }
  end

  def known_steps_by_5
    return @known_steps_by_5 if @known_steps_by_5

    @known_steps_by_5 = {}
  end

  def known_steps_by_25
    return @known_steps_by_25 if @known_steps_by_25

    @known_steps_by_25 = {}
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

  def make_map_per_5(number)
    return if known_steps_by_5[number]

    number_result = get_stones(number, 5)
    known_steps_by_5[number] = number_result
  end

  def make_map_per_25(number)
    return if known_steps_by_25[number]

    number_result = get_stones(number, 5, known_steps_by_5)
    known_steps_by_25[number] = number_result
  end

  def get_stones(number, distance = MAX_STEP, map = known_steps)
    if distance == 0
      return [number]
    end

    step = map[number]
    result = []
    step.each do |num|
      result += get_stones(num, distance - 1, map)
    end

    result
  end
end
