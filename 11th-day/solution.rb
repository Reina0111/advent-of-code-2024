require_relative "../lib/helper"

class Solution11
  include Helper

  FILE_NAME = "11th-day/input.txt"
  MAX_STEP = 25
  MAX_STEP2 = 75
  KEYS = [1, 2, 4, 8, 16, 32, 64]

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
    list = data.clone().tally

    data.each do |number|
      make_map(number)
    end

    [2, 4, 8, 16, 32, 64].each do |x|
      known_steps_by_x.keys.each do |number|
        make_map_per_x(number, x)
      end
      # puts "finished map for #{x}"
    end
    # puts known_steps_by_x

    remaining_steps = MAX_STEP2

    while remaining_steps > 0
      step = KEYS.select { |k| k <= remaining_steps }.max
      remaining_steps -= step
      # puts remaining_steps
      # puts step

      new_list = {}
      list.map do |el, value|
        hash = known_steps_by_x[el][step].map { |k, count| [k, count * value] }.to_h
        new_list = new_list.merge(hash) { |key, old_val, new_val| old_val + new_val }
      end
      # puts "#{MAX_STEP2 - remaining_steps}"

      list = new_list
    end

    list.values.sum
  end

  def known_steps
    return @known_steps if @known_steps

    @known_steps = {
      0 => [1]
    }
  end

  def known_steps_by_x
    return @known_steps_by_x if @known_steps_by_x

    @known_steps_by_x = @known_steps.map { |k, v| [k, { 1 => v.tally }] }.to_h
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

  def make_map_per_x(number, x = 2)
    return if known_steps_by_x[number][x]
    # puts number
    # puts "known_steps_by_x[#{number}]: #{known_steps_by_x[number]}"

    # puts known_steps_by_x[number][x / 2] if number == 2024 && x == 4
    res = known_steps_by_x[number][x / 2].map do |key, value| 
      hash = known_steps_by_x[key][x / 2] # {253000=>1}
      hash.map { |k, v| [k, v * value ] }.to_h
    end
    # puts res if number == 2024 && x == 4
    if res.length > 1
      res[1..-1].each do |next_res|
        res[0] = res[0].merge(next_res) { |key, old_val, new_val| old_val + new_val }
      end
    end
    # puts res[0] if number == 2024 && x == 4
    @known_steps_by_x[number][x] = res[0]
    # puts "known_steps_by_x[#{number}]: #{known_steps_by_x[number]}"
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
