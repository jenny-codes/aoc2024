# frozen_string_literal: true

require "./solution.rb"

class Day3 < Solution
  NUM_PATTERN = /mul\((\d{1,3}),(\d{1,3})\)/
  DO_PATTERN = "do()"
  DONT_PATTERN = "don't()"

  def part_one
    @input.join("\n").scan(NUM_PATTERN).sum do |pair|
      pair.map(&:to_i).reduce(:*)
    end
  end

  def part_two
    list = []
    @input.join("\n").scan(NUM_PATTERN) do |match|
      list << { 
        pattern: "NUM",
        index: Regexp.last_match.begin(0),
        value: match.map(&:to_i).reduce(:*),
      }
    end
    @input.join("\n").scan(DO_PATTERN) do |match|
      list << { 
        pattern: "DO",
        index: Regexp.last_match.begin(0),
      }
    end
    @input.join("\n").scan(DONT_PATTERN) do |match|
      list << { 
        pattern: "DONT",
        index: Regexp.last_match.begin(0),
      }
    end

    is_switch_on = true
    result = 0
    list.sort_by { _1[:index] }.each do |instruction|
      case instruction[:pattern]
      when "NUM"
        if is_switch_on
          result += instruction[:value]
        end
      when "DO"
        is_switch_on = true
      when "DONT"
        is_switch_on = false
      else
        raise "there is bug"
      end
    end

    result
  end
end

