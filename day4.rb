# frozen_string_literal: true

require "./solution.rb"

class Day4 < Solution
  def part_one
    input_in_array = @input.map { _1.split("") }

    horizontal = @input
    vertical = input_in_array.transpose.map(&:join)
    diagonal_right = draw_diagonal(input_in_array)
    diagonal_left = draw_diagonal(input_in_array.map(&:reverse))

    [horizontal, vertical, diagonal_right, diagonal_left].sum do |data|
      count_for("XMAS", data)
    end
  end

  def part_two
    input_with_original_positions = with_original_positions(@input.map { _1.split("") })

    diagonal_right_match_locations = find_match_locations_for("MAS", draw_diagonal(input_with_original_positions, output_in_array: true))
    diagonal_left_match_locations = find_match_locations_for("MAS", draw_diagonal(input_with_original_positions.map(&:reverse), output_in_array: true))

    Set.new(diagonal_left_match_locations).intersection(Set.new(diagonal_right_match_locations)).count
  end

  private

  def count_for(word, input)
    input.sum {_1.scan(word).count } + input.sum { _1.scan(word.reverse).count }
  end

  def find_match_locations_for(word, input)
    input.flat_map do |line|
      locations_for(word, line) + locations_for(word.reverse, line)
    end
  end

  def locations_for(word, line)
    result = []
    offset = 0
    str = line.map(&:first).join
    while index = str.index(word, offset)
      a = line[index + 1] # yes arbitrary
      result << a[1..]
      offset = index + 2
    end
    result
  end

  def draw_diagonal(original, output_in_array: false)
    starting_points = original.count.times.map { [_1, 0] } + original.first.count.times.map { [0, _1]}
    starting_points.uniq.reduce([]) do |memo, starting_point|
      y = starting_point.first
      x = starting_point.last
      result = []
      while char = original.dig(y, x)
        result << char
        y += 1
        x += 1
      end
      memo << (output_in_array ? result : result.join)
    end
  end


  def with_original_positions(input)
    input.each_with_index.map do |line, y|
      line.each_with_index.map do |char, x|
        [char, y, x]
      end
    end
  end
end

