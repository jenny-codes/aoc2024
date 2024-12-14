# frozen_string_literal: true

require "./solution.rb"

class Day5 < Solution
  def part_one
    rules, updates = parse_input

    updates
      .filter_map { |update| valid_update?(update, rules) ? update : nil }
      .sum { |update| update[update.count/2] }
  end

  def part_two
    rules, updates = parse_input

    updates
      .filter_map { |update| !valid_update?(update, rules) ? update : nil }
      .map { |update| fix_until_valid(update, rules) }
      .sum { |update| update[update.count/2] }
  end

  private

  def valid_update?(update, rules)
    update.combination(2).all? { |pair| !rules.include?(pair.reverse) }
  end

  def fix_until_valid(iteration, rules)
    violation = iteration.combination(2).find { |pair| rules.include?(pair.reverse) }
    return iteration if violation.nil?

    left, right = violation
    left_index, right_index = [iteration.index(left), iteration.index(right)]
    iteration[left_index] = right
    iteration[right_index] = left

    fix_until_valid(iteration, rules)
  end

  def parse_input
    separate_at = @input.index("")
    rules = @input[...separate_at].map { _1.split("|").map(&:to_i) }.to_set
    updates = @input[(separate_at+1)...].map { _1.split(",").map(&:to_i) }

    [rules, updates]
  end
end

