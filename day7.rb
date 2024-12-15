# frozen_string_literal: true

require "./solution"

class Day7 < Solution
  Equation = Data.define(:result, :operands)

  ADD = "+"
  MUL = "*"
  CONCAT = "||"

  def part_one
    equations.reduce(0) do |memo, eq|
      calculated = {}
      op_candidates = [ADD, MUL].repeated_permutation(eq.operands.count - 1)
      valid_op = op_candidates.find do |operations|
        calculate(eq.operands, operations, calculated) == eq.result
      end
      valid_op ? (memo + eq.result) : memo
    end
  end

  def part_two
    equations.reduce(0) do |memo, eq|
      calculated = {}
      op_candidates = [ADD, MUL, CONCAT].repeated_permutation(eq.operands.count - 1)
      valid_op = op_candidates.find do |operations|
        calculate(eq.operands, operations, calculated) == eq.result
      end
      valid_op ? memo + eq.result : memo
    end
  end

  private

  def calculate(operands, operations, calculated)
    cached_result = calculated[operations]
    if cached_result
      return cached_result
    end

    prev_step_result = if operations.one?
      raise "something is wrong" unless operands.count == 2

      operands.first
    else

      calculate(operands[...-1], operations[...-1], calculated)
    end

    curr_operation = operations.last
    curr_operand = operands.last
    result = case curr_operation
    when ADD
      prev_step_result + curr_operand
    when MUL
      prev_step_result * curr_operand
    when CONCAT
      (prev_step_result.to_s + curr_operand.to_s).to_i
    else
      raise "What is this? #{curr_operation}"
    end
    calculated[operations] = result
    result
  end

  def equations
    @equations ||= @input.map do |raw|
      result, operands = raw.split(":")
      Equation.new(result.to_i, operands.strip.split.map(&:to_i))
    end
  end
end
