require_relative "../lib/helper"
require 'matrix'

class Solution14
  include Helper

  FILE_NAME = "14th-day/input.txt"
  MAX_X = 101
  MAX_Y = 103
  MOVES_PART_A = 100

  def solution()
    prepare_data

    @robots.each do |robot|
      move_robot(robot, MOVES_PART_A)
      # puts robot[:position].to_s
    end

    count_quadrants()
  end

  def solution_part2()
    @robots = nil
    prepare_data

    draw_robots
  end

  def prepare_data
    return @robots if @robots

    @robots = []

    robot = new_robot.clone
    
    read_file(FILE_NAME).map do |line|
      _, x, y, _, v_x, v_y = line.strip.split(/,| |\=/).map(&:to_i)

      robot[:position] = { x: x, y: y }

      v_x = MAX_X + v_x if v_x < 0
      v_y = MAX_Y + v_y if v_y < 0

      robot[:velocity] = { x: v_x, y: v_y }

      @robots << robot
      robot = new_robot.clone
    end

    @robots
  end

  def new_robot
    {
      position: {
        x: 0,
        y: 0,
      },
      velocity: {
        x: 0,
        y: 0,
      }
    }
  end

  def move_robot(robot, moves)
    robot[:position][:x] = (robot[:position][:x] + robot[:velocity][:x] * moves) % MAX_X
    robot[:position][:y] = (robot[:position][:y] + robot[:velocity][:y] * moves) % MAX_Y
  end

  def count_quadrants()
    middle_x = MAX_X / 2
    middle_y = MAX_Y / 2

    first_x = (0..middle_x - 1)
    second_x = (middle_x + 1..MAX_X - 1)
    first_y = (0..middle_y - 1)
    second_y = (middle_y + 1..MAX_Y - 1)

    first_quadrant = @robots.select do |robot|
      first_x.to_a.include?(robot[:position][:x]) && first_y.to_a.include?(robot[:position][:y])
    end.count
    second_quadrant = @robots.select do |robot|
      second_x.to_a.include?(robot[:position][:x]) && first_y.to_a.include?(robot[:position][:y])
    end.count
    third_quadrant = @robots.select do |robot|
      first_x.to_a.include?(robot[:position][:x]) && second_y.to_a.include?(robot[:position][:y])
    end.count
    fourth_quadrant = @robots.select do |robot|
      second_x.to_a.include?(robot[:position][:x]) && second_y.to_a.include?(robot[:position][:y])
    end.count

    # puts first_quadrant
    # puts second_quadrant
    # puts third_quadrant
    # puts fourth_quadrant

    first_quadrant * second_quadrant * third_quadrant * fourth_quadrant
  end

  def draw_robots
    seconds = 0
    list = Array.new(MAX_Y){ Array.new(MAX_X, ".") }
    
    while (list.select { |l| l.join("").include?("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@") }.count == 0)
      check = false
      list = Array.new(MAX_Y){ Array.new(MAX_X, ".") }
      # puts list[0].to_s
      @robots.each do |robot|
        move_robot(robot, 1)
        list[robot[:position][:y]][robot[:position][:x]] = "@"
      end

      seconds += 1
    end

    seconds
  end
end


# 1100 is too low