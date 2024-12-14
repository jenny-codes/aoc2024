# frozen_string_literal: true

require "./solution.rb"

class Day2 < Solution
  def part_one
    @input.count { valid_report?(_1.split(" ").map(&:to_i)) }
  end

  def part_two
    @input.count do |line| 
      report = line.split(" ").map(&:to_i)
      report.count.times.any? do |idx|
        sub_report = report.dup
        sub_report.delete_at(idx)
        valid_report?(sub_report)
      end
    end
  end

  def valid_report?(report)
    sorted_report = report.sort
    return false unless (sorted_report == report || sorted_report == report.reverse)
    return false if sorted_report.each_cons(2).any? { |left, right| right - left > 3 || right - left < 1 }

    true
  end
end

