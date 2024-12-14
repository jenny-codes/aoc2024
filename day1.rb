# frozen_string_literal: true

require './solution.rb'

class Day1 < Solution
  def part_one
    @input
      .map { _1.split(" ").map(&:to_i) }
      .transpose
      .map(&:sort)
      .transpose
      .sum { |a, b| (a-b).abs }
  end

  def part_two
    left_tally, right_tally = @input
      .map { _1.split(" ").map(&:to_i) }
      .transpose
      .map(&:tally)

    left_tally.reduce(0) do |memo, pair|
      key, left_value = pair
      right_value = right_tally.dig(key)
      next memo unless right_value

      memo += key * left_value * right_value
    end
  end
end

