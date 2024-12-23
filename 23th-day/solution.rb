require_relative "../lib/helper"
require 'matrix'

class Solution23
  include Helper

  FILE_NAME = "23th-day/input.txt"

  def solution()
    final_sets = []
    sets
    sets.select { |k, _v| k.start_with?("t") }.each do |k, v|
      next if v.count < 2

      v.each do |pc|
        other_pcs = sets[pc]
        connected_pcs = (v & other_pcs)
        final_sets += connected_pcs.map { |third| [k, pc, third].sort }
      end      
    end

    final_sets.uniq.count
  end

  def solution_part2()
    sets
    @cliques = []
    bronkerbosch([], sets.keys, [])
    @cliques.sort_by { |clique| -clique.size }.first.sort.join(",")
  end

  def sets
    return @sets if @sets

    @sets = {}

    read_file(FILE_NAME).each do |line|
      first, second = line.strip.split("-")    

      @sets[first] ||= []
      @sets[first] << second
      
      @sets[second] ||= []
      @sets[second] << first
    end
  end

  def bronkerbosch(r, p, x)
    if p.size == 0 && x.size == 0
      @cliques << r.dup
      return
    end

    p.uniq.each do |v|
      bronkerbosch(r + [v], (p & @sets[v]), (x & @sets[v]))
      p.uniq!
      p.delete(v)
      x << v
    end
  end
end
