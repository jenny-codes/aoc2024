# frozen_string_literal: true

require "./solution.rb"

class Day10 < Solution
  def part_one
    map, trailheads = parse
    trailheads.sum { find_tops(map, _1, 0).uniq.count }
  end

  def part_two
    map, trailheads = parse
    trailheads.sum { count_paths(map, _1, 0) }
  end

  private

  def find_tops(map, pos, height)
    return [pos] if height == 9

    next_height = height + 1
    find_next_steps(map, pos, next_height)
      .flat_map { find_tops(map, _1, next_height) }
  end

  def count_paths(map, pos, height)
    return 1 if height == 9

    next_height = height + 1
    find_next_steps(map, pos, next_height)
      .sum { count_paths(map, _1, next_height) }
  end

  def find_next_steps(map, pos, target_height)
    y, x = pos
    [[y - 1, x], [y + 1, x], [y, x - 1], [y, x + 1]].filter do |next_pos|
      next_y, next_x = next_pos
      next false if next_y < 0 || next_x < 0
      next false unless map.dig(next_y, next_x) == target_height

      true
    end
  end

  def parse
    map = @input.map { _1.split("").map(&:to_i) }
    trailheads = map.each_with_index.with_object([]) do |pair, memo|
      row, y = pair
      row.each_with_index do |height, x|
        memo << [y, x] if height == 0
      end
    end
    [map, trailheads]
  end
end
