# frozen_string_literal: true

class Solution
  def self.for(day, input)
    Object.const_get(day.capitalize).new(input)
  end

  def initialize(input)
    @input = input
  end

  def part_one
    raise 'Need to implement :part_one function'
  end

  def part_two
    raise 'Need to implement :part_two function'
  end
end
