# frozen_string_literal: true

require "./solution.rb"

class Day12 < Solution
  Up = Data.define do
    class << self
      def for(y, x)
        [y - 1, x]
      end
    end
  end

  Down = Data.define do
    class << self
      def for(y, x)
        [y + 1, x]
      end
    end
  end

  Right = Data.define do
    class << self
      def for(y, x)
        [y, x + 1]
      end
    end
  end

  Left = Data.define do
    class << self
      def for(y, x)
        [y, x - 1]
      end
    end
  end

  Plot = Data.define(:location, :surfaces) do
  end

  Region = Data.define(:name, :plots) do
    def area
      plots.count
    end

    def perimeter
      plots.flat_map(&:surfaces).count
    end

    def sides
      horizontal = [Up, Down].sum do |direction|
        plots
          .filter_map { |plot| plot.location if plot.surfaces.include?(direction) }
          .group_by(&:first)
          .values
          .map { _1.map(&:last).sort }
          .reduce(0) do |memo, nums|
            memo + calculate_consecutive_pieces(nums)
          end
      end

      vertical = [Left, Right].sum do |direction|
        plots
          .filter_map { |plot| plot.location if plot.surfaces.include?(direction) }
          .group_by(&:last)
          .values
          .map { _1.map(&:first).sort }
          .reduce(0) do |memo, nums|
            memo + calculate_consecutive_pieces(nums)
          end
      end

      horizontal + vertical
    end

    def calculate_consecutive_pieces(nums)
      nums.each_cons(2).count do |pair|
        left, right = pair
        right - left > 1
      end + 1
    end
  end

  def part_one
    map, unvisited = parse_map
    regions = build_regions(map, unvisited)
    regions.sum { _1.area * _1.perimeter }
  end

  def part_two
    map, unvisited = parse_map
    regions = build_regions(map, unvisited)
    regions.sum { _1.area * _1.sides }
  end

  private

  def build_regions(map, unvisited)
    regions = []
    until unvisited.empty?
      start = unvisited.first
      unvisited.delete(start)
      name = map.dig(*start)
      regions << explore_region(map, unvisited, Region.new(name, []), start)
    end
    regions
  end

  def explore_region(map, unvisited, region, curr_pos)
    y, x = curr_pos
    neighbors, surfaces = [Up, Down, Left, Right].partition do |candidate|
      new_y, new_x = candidate.for(y, x)
      next false if new_y < 0 || new_x < 0

      map.dig(new_y, new_x) == region.name
    end
    region.plots << Plot.new(curr_pos, surfaces)
    neighbors.each do |neighbor|
      next_step = neighbor.for(y, x)
      next unless unvisited.include?(next_step)

      unvisited.delete(next_step)
      explore_region(map, unvisited, region, next_step)
    end
    region
  end

  def parse_map
    map = @input.map { _1.split("") }
    unvisited = map.size.times.flat_map do |y|
      map.first.size.times.map do |x|
        [y, x]
      end
    end.to_set
    [map, unvisited]
  end
end
