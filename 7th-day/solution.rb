require_relative "../lib/helper"
require 'matrix'

class Solution7
  include Helper

  FILE_NAME = "7th-day/input.txt"


  def solution()
    res = 0
    data.each do |result, list|
      if check_correctness(list, result)
        res += result
      end
    end

    res
  end

  def solution_part2()
    res = 0
    @data = nil

    data.each do |result, list|
      if check_correctness2(list, result)
        res += result
      else
        # puts result
      end
    end

    res
  end

  def data
    return @data if @data

    @data = []

    lines = read_file(FILE_NAME)

    lines.each do |line|
      result, list = line.split(":")
      @data << [result.strip.to_i, list.strip.split(" ").map { |a| a.to_i }]
    end

    @data
  end

  def check_correctness(list, current, result = 0)
    # puts "[#{list.join(", ")}], #{current}, #{result == 0 ? "dodawanie" : "mnożenie"}"

    if list.size == 0 || result < 0
      res = current == result
    else
      last_element = list.pop(1).first
      if current % last_element == 0
        res = check_correctness(list.clone(), current / last_element, 1) || check_correctness(list.clone(), current - last_element, 0)
      else
        res = check_correctness(list.clone(), current - last_element, 0)
      end
    end

    return res
  end

  def check_correctness2(list, current, result = 0)
    # puts "[#{list.join(", ")}], #{current}, #{result == 0 ? "dodawanie" : "mnożenie"}"

    if list.size == 0 || result < 0
      res = current == result
    else
      last_element = list.pop(1).first
      if (current % (10 ** last_element.to_s.length)) == last_element
        divided_element = (current - last_element) / (10 ** last_element.to_s.length)
        if current % last_element == 0
          res = check_correctness2(list.clone(), divided_element, 0) || check_correctness2(list.clone(), current / last_element, 1) || check_correctness2(list.clone(), current - last_element, 0)
        else
          res = check_correctness2(list.clone(), divided_element, 0) || check_correctness2(list.clone(), current - last_element, 0)
        end
      else
        if current % last_element == 0
          res = check_correctness2(list.clone(), current / last_element, 1) || check_correctness2(list.clone(), current - last_element, 0)
        else
          res = check_correctness2(list.clone(), current - last_element, 0)
        end
      end
    end

    return res
  end
end
