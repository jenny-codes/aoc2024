# frozen_string_literal: true

require "./solution.rb"

class Day11 < Solution
  def part_one
    stones = parse
    iterate(25, stones.tally).values.reduce(&:+)
  end

  def part_two
    stones = parse
    iterate(75, stones.tally).values.reduce(&:+)
  end

  private

  def iterate(step, stones)
    if step == 0
      return stones
    end

    stones.map do |curr_stone, curr_count|
      prev_stones = iterate(step - 1, { curr_stone => curr_count })
      result = {}
      prev_stones.each do |stone, count|
        apply_rule(stone).each do |new_stone|
          result[new_stone] ? result[new_stone] += count : result[new_stone] = count
        end
      end
      result.transform_values { |v| v * curr_count }
    end.reduce do |memo, tally|
      memo.merge(tally) { |_key, left, right| left + right }
    end
  end

  def apply_rule(num)
    return [1] if num == 0

    digits = num.digits.reverse
    if digits.count.even?
      left, right = digits.each_slice(digits.count / 2).to_a
      return [left.join.to_i, right.join.to_i]
    end

    [num * 2024]
  end

  def parse
    @input.first.split.map(&:to_i)
  end
end
