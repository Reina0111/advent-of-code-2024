require_relative "../lib/helper"

class Solution19
  include Helper

  FILE_NAME = "19th-day/input.txt"

  def solution()
    prepare_data

    # puts @sorted_stripes.to_s
    # puts @designs.to_s

    result = 0
    @possible_designs = []

    @designs.each do |design|
      # puts "OK #{design}" if check_if_possible(design)
      if check_if_possible(design)
        result += 1
        @possible_designs << design
      end
    end

    result
  end

  def solution_part2()
    solution if !@possible_designs

    result = 0

    @possible_designs.each do |design|
      puts design
      result += divided_parts(design)
    end

    result
  end

  def prepare_data
    lines = read_file(FILE_NAME)

    stripes = lines[0].strip.split(",").map(&:strip)

    @unsorted_stripes = {}
    @sorted_stripes = {}

    @max_length = 0

    stripes.each do |stripe|
      @unsorted_stripes[stripe[0]] ||= []
      @unsorted_stripes[stripe[0]] << stripe
      @max_length = [stripe.length, @max_length].max
    end

    @unsorted_stripes.each do |k, v|
      @sorted_stripes[k] = v.sort_by { |el| -el.length }
    end

    @designs = []
    lines[2..-1].each do |line|
      @designs << line.strip
    end
  end

  def check_if_possible(design)
    possible_stripes = @sorted_stripes[design[0]]

    return false if !possible_stripes

    possible_stripes.each do |stripe|
      # puts "checking #{design} with #{stripe}"
      next if stripe.length > design.length || stripe != design[0..stripe.length - 1]

      return true if stripe == design || (stripe == design[0..stripe.length - 1] && check_if_possible(design[stripe.length..-1]))
    end

    false
  end

  def check_all_possible(design)
    possible_stripes = @sorted_stripes[design[0]]

    return 0 if !possible_stripes

    counter = 0

    possible_stripes.each do |stripe|
      # puts "checking #{design} with #{stripe}"
      next if stripe.length > design.length || stripe != design[0..stripe.length - 1]

      if stripe == design
        counter += 1
        next
      end

      if stripe == design[0..stripe.length - 1]
        counter += check_all_possible(design[stripe.length..-1])
      end
    end

    counter
  end

  def check_all_possible(design)
    possible_stripes = @sorted_stripes[design[0]]

    return 0 if !possible_stripes

    counter = 0

    possible_stripes.each do |stripe|
      # puts "checking #{design} with #{stripe}"
      next if stripe.length > design.length || stripe != design[0..stripe.length - 1]

      if stripe == design
        # puts "single option finished OK"
        counter += 1
        next
      end

      if stripe == design[0..stripe.length - 1]
        counter += check_all_possible(design[stripe.length..-1])
      end
    end

    counter
  end

  def divided_parts(design)
    map = {}
    max_index = design.length - 1
    design.split("").each_with_index do |letter, index|
      map[index] = []

      next if !@sorted_stripes[letter]
      @sorted_stripes[letter].each do |stripe|
        map[index] << stripe if stripe == design[index..index + stripe.length - 1]
      end
    end

    puts map.to_s

    i = 0
    start = 0
    result = 1
    while start <= max_index
      loop do
        i += 1 if map[i].length == 0
        longest_stripe = map[i].sort_by { |s| -s.length }[0]

        break if longest_stripe.length == 1

        i += longest_stripe.length - 1
      end

      puts "found i #{i}"
      puts "found current start #{start}"

      result *= check_all_possible(design[start..i])
      i += 1
      start = i
    end

    result
  end
end
