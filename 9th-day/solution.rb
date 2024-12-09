require_relative "../lib/helper"
require 'matrix'

class Solution9
  include Helper

  FILE_NAME = "9th-day/input.txt"


  def solution()
    fill_empty()
    count_checksum
  end

  def solution_part2()
    @data = nil
    fill_empty_whole_files()

    count_checksum
  end

  def data
    return @data if @data

    @data = {
      set: [],
      empty: [],
      filled: [],
    }

    line = read_file(FILE_NAME).first

    file_index = 0
    size = 0
    line.split("").each_with_index do |number, index|
      if index % 2 == 0
        @data[:set] << [file_index, number.to_i, size]
        size += 1
      else
        @data[:empty] << [file_index, number.to_i] if number.to_i > 0
      end

      file_index += number.to_i
    end

    @data
  end

  def fill_empty
    last_file = [0, 0]
    data[:empty].each do |index, length|
      i = index
      while length > 0
        last_file = data[:set].pop(1).first if last_file[1] <= 0

        if last_file[0] < i
          break
        end

        amount = [last_file[1], length].min
        res = [i, amount, last_file[2]]
        data[:filled] << res
        last_file[1] -= amount
        length -= amount
        i += amount
      end
    end
    if last_file[1] > 0
      data[:set] << last_file
    end
  end

  def fill_empty_whole_files
    last_file = data[:set].pop(1).first
    while last_file
      empty_index = data[:empty].find_index { |_, length| length >= last_file[1] }
      if empty_index && data[:empty][empty_index][0] < last_file[0]
        place = data[:empty].delete_at(empty_index)
        data[:filled] << [place[0], last_file[1], last_file[2]]
        data[:empty].insert(empty_index, [place[0] + last_file[1], place[1] - last_file[1]]) if place[1] - last_file[1] > 0
      else
        data[:filled] << last_file
      end
      
      last_file = data[:set].pop(1).first
    end
  end

  def count_checksum
    result = 0
    result += data[:set].sum { |index, length, value| (index..index + length-1).sum * value }
    result += data[:filled].sum { |index, length, value| (index..index + length-1).sum * value }

    result
  end
end
