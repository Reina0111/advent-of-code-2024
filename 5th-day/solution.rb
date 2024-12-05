require_relative "../lib/helper"
require 'matrix'

class Solution5
  include Helper

  FILE_NAME = "5th-day/input.txt"


  def solution()
    rules_before, rules_after, pages = get_rules_and_pages

    result = 0
    pages.each do |page|
      result += check_if_page_correct(page, rules_before, rules_after)
    end

    result
  end

  def solution_part2()
    rules_before, rules_after, pages = get_rules_and_pages
    result = 0
    incorrect_pages = []
    pages.each do |page|
      if check_if_page_correct(page, rules_before, rules_after) == 0
        incorrect_pages << page[0]
      end
    end
    
    incorrect_pages.each do |page|
      result += fix_incorrect_page(page, rules_before, rules_after)
    end

    result
  end

  def get_rules_and_pages
    return [@rules_before, @rules_after, @pages] if @rules_before && @rules_after && @pages
    
    @rules_before = {}
    @rules_after = {}
    @pages = []

    get_pages = false
    lines.each do |line|
      if line.strip == ""
        get_pages = true
      end

      if get_pages
        line_array = line.strip.split(",")
        @pages << [line_array, line_array[line_array.size / 2].to_i]
      else
        before, after = line.strip.split("|")
        @rules_before[before] ||= []
        @rules_before[before] << after
        @rules_after[after] ||= []
        @rules_after[after] << before
      end
    end

    [@rules_before, @rules_after, @pages]
  end

  def lines
    @lines = read_file(FILE_NAME)
  end

  def check_if_page_correct(page, rules_before, rules_after)
    page, result = page

    page.each_with_index do |number, index|
      if index > 0
        # page[0..index-1] = [75,47,61]
        # rules_before[53] = [29,13]
        return 0 if ((rules_before[number] || []) & page[0..index-1]).size > 0
      end

      if index < page.size - 1
        # page[index+1..-1] = [29]
        # rules_after[75] = [47,75,61,97]
        return 0 if ((rules_after[number] || []) & page[index+1..-1]).size > 0
      end
    end

    result
  end

  def fix_incorrect_page(page, rules_before, rules_after)
    fixed_page = sort_partialy(page[0], page).flatten

    fixed_page[fixed_page.size / 2].to_i
  end

  def sort_partialy(start, page, sorted = [])
    return [] if !start

    after = ((@rules_after[start] || []) & page) - sorted
    before = ((@rules_before[start] || []) & page) - sorted

    [sort_partialy(after[0], page, ([start] + before + sorted).uniq), start, sort_partialy(before[0], page, ([start] + after + sorted).uniq)]
  end
end