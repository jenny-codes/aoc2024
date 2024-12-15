# frozen_string_literal: true

require "./solution.rb"

class Day6 < Solution
  UP = 'up'
  LEFT = 'left'
  DOWN = 'down'
  RIGHT = 'right'
  def part_one
    map = @input.map { _1.split("") }
    start = find_start(map)
    walk(map, Set.new([start]), start, UP).count
  end

  def part_two
    map = @input.map { _1.split("") }
    start = find_start(map)
    route = walk(map, Set.new, start, UP).delete(start)
    route.count do |obstacle|
      modify_map(map, obstacle) do |modified_map|
        is_in_loop?(modified_map, [start, UP])
      end
    end
  end

  private

  def find_start(map)
    y = map.find_index { _1.include?("^") }
    x = map[y].find_index("^")
    [y, x]
  end

  def walk(map, traversed, coord, direction)
    new_coord, new_direction = find_next(map, coord, direction)
    return traversed unless new_coord

    traversed << new_coord
    walk(map, traversed, new_coord, new_direction)
  end

  def find_next(map, coord, direction)
    y, x = coord
    new_y, new_x, new_direction = case direction
    when UP
      [y-1, x, RIGHT]
    when RIGHT
      [y, x+1, DOWN]
    when DOWN
      [y+1, x, LEFT]
    when LEFT
      [y, x-1, UP]
    end

    return nil if new_y < 0 || new_x < 0

    case map.dig(new_y, new_x)
    when ".", "^"
      [[new_y, new_x], direction]
    when "#"
      find_next(map, coord, new_direction)
    when nil
      nil
    end
  end

  def is_in_loop?(modified_map, step)
    case walk_again(modified_map, Set.new([step]), step)
    when :exited
      false
    when :is_loop
      true
    else
      raise "huh"
    end
  end

  def walk_again(map, traversed, current_step)
    coord, direction = current_step
    next_step = find_next(map, coord, direction)
    if next_step.nil?
      :exited
    elsif traversed.include?(next_step)
      :is_loop
    else
      traversed << next_step
      walk_again(map, traversed, next_step)
    end
  end

  def modify_map(map, new_obstacle, &block)
    y, x = new_obstacle
    map[y][x] = "#"
    result = block.call(map)
    map[y][x] = "."
    result
  end

  def debug_draw_route(map, traversed)
    traversed.each do |coord|
      y, x = coord
      map[y][x] = "x"
    end
    puts map.map(&:join).join("\n")
  end
end

