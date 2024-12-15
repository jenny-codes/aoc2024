# frozen_string_literal: true

require "./solution.rb"

class Day8 < Solution
  def part_one
    map = @input.map { _1.split("") }
    locate_antennas(map).reduce(Set.new) do |memo, antenna|
      memo + antinode_locations(antenna, map)
    end.count
  end

  def part_two
    map = @input.map { _1.split("") }
    locate_antennas(map).reduce(Set.new) do |memo, antenna|
      memo + aggressive_antinode_locations(antenna, map)
    end.count
  end

  private

  def antinode_locations(antenna, map)
    _name, locations = antenna
    locations.combination(2).flat_map do |pair|
      a, b = pair
      ay, ax = a
      by, bx = b
      x_diff = ax - bx
      y_diff = ay - by
      [[by - y_diff, bx - x_diff], [ay + y_diff, ax + x_diff]].filter do |candidate|
        valid_location?(map, *candidate)
      end
    end
  end

  def aggressive_antinode_locations(antenna, map)
    _name, locations = antenna
    locations.combination(2).flat_map do |pair|
      result = []
      a, b = pair
      ay, ax = a
      by, bx = b
      x_diff = ax - bx
      y_diff = ay - by

      while valid_location?(map, by, bx)
        result << [by, bx]
        by -= y_diff
        bx -= x_diff
      end

      while valid_location?(map, ay, ax)
        result << [ay, ax]
        ay += y_diff
        ax += x_diff
      end

      result
    end
  end

  def valid_location?(map, y, x)
    return false if x < 0 || y < 0
    return false unless map.dig(y, x)

    true
  end

  def locate_antennas(map)
    @antennas ||=
      map.each_with_index.with_object(Hash.new { |h, k| h[k] = [] }) do |line, memo|
        row, y = line
        row.each_with_index do |name, x|
          if name != "."
            memo[name] << [y, x]
          end
        end
      end
  end
end
