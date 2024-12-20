require_relative "../lib/helper"

class Solution17
  include Helper

  FILE_NAME = "17th-day/input.txt"

  def solution()
    data

    get_result().join(",")
  end

  # it was solved more from try and error kind of approach half by hand
  # I don't know how to write into code that does it itself
  def solution_part2()
    data
    finishing_program = [@register_B, @register_C, @operations]
    result = []
    operations = []
    i = 14037376621
    while @operations != operations && i < 300000000000000
      i += 17179869184
      data

      @register_A = i
      @register_B = finishing_program[0]
      @register_C = finishing_program[1]
      operations = get_result()

      result = [@register_B, @register_C, operations]
      if operations[0..13] == [2,4,1,3,7,5,0,3,4,3,1,5,5,5]
        puts "checking #{i.to_s(2)}"
        puts "checking #{operations.to_s}"
      end

      # puts "current loop #{i} #{operations.to_s}" if i % 100000 == 0
    end

    i
  end

  def data
    @operations = []

    lines = read_file(FILE_NAME)

    @register_A = lines[0].strip.split(": ").last.to_i
    @register_B = lines[1].strip.split(": ").last.to_i
    @register_C = lines[2].strip.split(": ").last.to_i

    @operations = lines[4].strip.split(": ").last.split(",").map(&:to_i)
  end

  def get_result
    operation_index = 0

    result = []

    while operation_index < @operations.count - 1
      operation = @operations[operation_index]
      operand = @operations[operation_index + 1]
      case operation
      when 0
        adv(get_value(operand))
      when 1
        bxl(operand)
      when 2
        bst(get_value(operand))
      when 3
        jump = jnz(operand)
        operation_index = jump if jump != nil
      when 4
        bxc(operand)
      when 5
        result << out(get_value(operand))
      when 6
        bdv(get_value(operand))
      when 7
        cdv(get_value(operand))
      end
      # puts "A #{@register_A} | B #{@register_B} | C #{@register_C} | #{operation_index}"
 
      operation_index += 2
    end

    result
  end

  def get_result_quick
    operation_index = 0
    a = @register_A
    result = []

    while operation_index < @operations.count - 1
      operation = @operations[operation_index]
      operand = @operations[operation_index + 1]
      case operation
      when 0
        adv(get_value(operand))
      when 1
        bxl(operand)
      when 2
        bst(get_value(operand))
      when 3
        jump = jnz(operand)
        operation_index = jump if jump != nil
      when 4
        bxc(operand)
      when 5
        result << out(get_value(operand))
      when 6
        bdv(get_value(operand))
      when 7
        cdv(get_value(operand))
      end
      # puts result.to_s
      # puts "A #{@register_A} | B #{@register_B} | C #{@register_C} | #{operation_index}"
      if result.size > 0
        index = result.each_with_index.find { |value, i| value != @operations[i] }&.last
        if index
          # if result[0..1] == [2,4]
          #   puts "checking #{a}"
          #   puts "checking #{result.to_s}"
          # end
          return result
        end
      end
 
      operation_index += 2
    end

    result
  end

  def get_value(combo_operand)
    case combo_operand
    when 4
      @register_A
    when 5
      @register_B
    when 6
      @register_C
    when 7
      throw NameError.new("can't use 7")
    else
      combo_operand
    end
  end

  def adv(value)
    @register_A = @register_A / (2 ** value)
  end

  def bxl(value)
    @register_B = (value ^ @register_B)
  end

  def bst(value)
    @register_B = value % 8
  end

  def jnz(value)
    @register_A == 0 ? nil : value - 2
  end

  def bxc(_value)
    @register_B = (@register_B ^ @register_C)
  end

  def out(value)
    value % 8
  end

  def bdv(value)
    @register_B = @register_A / (2 ** value)
  end

  def cdv(value)
    @register_C = @register_A / (2 ** value)
  end
end
