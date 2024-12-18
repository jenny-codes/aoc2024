# frozen_string_literal: true

require "./solution.rb"

class Day13 < Solution
  def part_one
    machines = parse
    machines.sum do |machine|
      solutions = play(Game.new(machine, Coord.new(0, 0), 0, 0), Set.new)
      solutions.min || 0
    end
  end

  def part_two
  end

  private

  def play(game, lookup)
    return if lookup.include?([game.a_pressed, game.b_pressed])

    if game.won?
      game.token_spent
    elsif game.over?
      nil
    else
      [game.press(:a), game.press(:b)].filter_map do |game|
        result = play(game, lookup)
        lookup << [game.a_pressed, game.b_pressed]
        result
      end.flatten
    end
  end

  Game = Data.define(:machine, :progress, :a_pressed, :b_pressed) do
    BUTTON_PRESS_LIMIT = 100

    def press(button)
      case button
      when :a
        Game.new(
          machine,
          progress + machine.a.vector,
          a_pressed + 1,
          b_pressed,
        )
      when :b
        Game.new(
          machine,
          progress + machine.b.vector,
          a_pressed,
          b_pressed + 1,
        )
      end
    end

    def token_spent
      a_pressed * machine.a.cost + b_pressed * machine.b.cost
    end

    def won?
      progress == machine.prize
    end

    def over?
      a_pressed > BUTTON_PRESS_LIMIT ||
        b_pressed > BUTTON_PRESS_LIMIT ||
        progress.exceeds?(machine.prize)
    end
  end

  Machine = Data.define(:a, :b, :prize)
  Button = Data.define(:cost, :vector)
  Coord = Data.define(:y, :x) do
    def +(other)
      Coord.new(y + other.y, x + other.x)
    end

    def exceeds?(other)
      y > other.y || x > other.x
    end
  end

  def parse
    @input.each_slice(4).map do |set|
      a, b, prize = set.map { |item| item.scan(/\d+/).map(&:to_i) }
      Machine.new(
        Button.new(3, Coord.new(*a)),
        Button.new(1, Coord.new(*b)),
        Coord.new(*prize),
      )
    end
  end
end
