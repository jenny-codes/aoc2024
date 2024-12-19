# frozen_string_literal: true

require "./solution.rb"

class Day13 < Solution
  def part_one
    play(parse_for_part_one)
  end

  def part_two
    play(parse_for_part_two)
  end

  private

  Machine = Data.define(:a, :b, :prize)
  Button = Data.define(:cost, :vector)
  Coord = Data.define(:y, :x)

  CalibrationResult = Data.define(:button, :range)

  def play(machines)
    machines.sum do |machine|
      result = calibrate(machine.prize, machine.a.vector, machine.b.vector)
      next 0 unless result

      subject = result.button == :a ? machine.a : machine.b
      object = result.button == :a ? machine.b : machine.a

      solutions = result.range.reduce([]) do |memo, subject_pressed|
        object_y = (machine.prize.y - subject_pressed * subject.vector.y)
        object_x = (machine.prize.x - subject_pressed * subject.vector.x)
        y_matched = (object_y % object.vector.y) == 0
        x_matched = (object_x % object.vector.x) == 0
        next memo unless y_matched && x_matched

        y_needed = object_y / object.vector.y
        x_needed = object_x / object.vector.x
        next memo unless x_needed == y_needed

        memo << (subject_pressed * subject.cost + y_needed * object.cost).to_i
      end
      solutions.min || 0
    end
  end

  def calibrate(prize, vec_a, vec_b, range_a = 0..Float::INFINITY, range_b = 0..Float::INFINITY)
    if range_a.begin > range_a.end || range_b.begin > range_b.end
      return
    end

    a_upper_bound = [
      ((prize.y - range_b.begin * vec_b.y) / vec_a.y).floor,
      ((prize.x - range_b.begin * vec_b.x) / vec_a.x).floor,
    ].min

    b_upper_bound = [
      ((prize.y - range_a.begin * vec_a.y) / vec_b.y).floor,
      ((prize.x - range_a.begin * vec_a.x) / vec_b.x).floor,
    ].min

    a_lower_bound = [
      0,
      ((prize.y - b_upper_bound * vec_b.y) / vec_a.y).ceil,
      ((prize.x - b_upper_bound * vec_b.x) / vec_a.x).ceil,
    ].max

    b_lower_bound = [
      0,
      ((prize.y - a_upper_bound * vec_a.y) / vec_b.y).ceil,
      ((prize.x - a_upper_bound * vec_a.x) / vec_b.x).ceil,
    ].max

    if [a_upper_bound, a_lower_bound, b_upper_bound, b_lower_bound].any?(&:negative?)
      raise "bug!"
    end

    if (a_upper_bound < a_lower_bound) || (b_upper_bound < b_lower_bound)
      return
    end

    new_range_a = a_lower_bound..a_upper_bound
    new_range_b = b_lower_bound..b_upper_bound

    if new_range_a == range_a && new_range_b == range_b
      result = if range_a.count <= range_b.count
        CalibrationResult.new(:a, range_a)
      else
        CalibrationResult.new(:b, range_b)
      end
      return result
    end

    calibrate(prize, vec_a, vec_b, new_range_a, new_range_b)
  end

  def parse_for_part_one
    @input.each_slice(4).map do |set|
      a, b, prize = set.map { |item| item.scan(/\d+/).map(&:to_i) }
      Machine.new(
        Button.new(3, Coord.new(*a)),
        Button.new(1, Coord.new(*b)),
        Coord.new(*prize),
      )
    end
  end

  def parse_for_part_two
    @input.each_slice(4).map do |set|
      a, b, prize = set.map { |item| item.scan(/\d+/) }
      a = a.map(&:to_f)
      b = b.map(&:to_f)
      prize = prize.map { |d| d.to_i + 10000000000000 }
      Machine.new(
        Button.new(3, Coord.new(*a)),
        Button.new(1, Coord.new(*b)),
        Coord.new(*prize),
      )
    end
  end
end
