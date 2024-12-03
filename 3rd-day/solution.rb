require_relative "../lib/helper"

class Solution3
  include Helper

  FILE_NAME = "3rd-day/input.txt"

  REGEX = /mul\((\d{1,3})\,(\d{1,3})\)/
  DO_REGEX = /(do\(\)|don't\(\))/

  def solution()
    lines = read_file(FILE_NAME)
    result = 0
    lines.each do |command|
      result += command.scan(REGEX).map { |first, second| first.to_i * second.to_i }.sum
    end

    result
  end

  def solution_part2()
    lines = read_file(FILE_NAME)
    result = 0
    last_do = true
    lines.each do |command|
      do_donts = [[0, last_do]]
      command.scan(DO_REGEX) do |c|
        do_donts << [Regexp.last_match.offset(0).first, c.first == "do()"] if do_donts.last[1] != (c.first == "do()")
      end

      muls = []
      command.scan(REGEX) { |c| muls << [Regexp.last_match.offset(0).first, c[0].to_i * c[1].to_i] }

      last_do = do_donts.last.last
      do_donts = do_donts.to_h
      do_donts_keys = do_donts.keys
      muls = muls.to_h

      muls.each do |k, v|
        result += v if do_donts[do_donts_keys.filter { |key| key < k }.last]
      end
    end

    result
  end
end
