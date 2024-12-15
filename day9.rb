# frozen_string_literal: true

require "./solution.rb"

class Day9 < Solution
  Block = Data.define(:start, :length) do
    def expand
      (start...(start + length)).to_a
    end
  end

  Fille = Data.define(:id, :block)

  def part_one
    files, free_spaces = parse
    free_space_expanded = free_spaces.flat_map(&:expand)
    is_filled = false
    files
      .reverse
      .reduce(0) do |memo, f|
        file_expanded = f.block.expand
        positions = if is_filled
          file_expanded
        else
          file_expanded.map do |file_pos|
            free_space_pos = free_space_expanded.shift
            if free_space_pos > file_pos
              is_filled = true
              file_pos
            else
              free_space_pos
            end
          end
        end
        memo + (f.id * positions.reduce(:+))
      end
  end

  def part_two
    files, free_spaces = parse
    files
      .reverse
      .reduce(0) do |memo, f|
        free_space_idx = free_spaces.index do |fs|
          fs.length >= f.block.length && fs.start < f.block.start
        end
        positions = if free_space_idx
          fs = free_spaces[free_space_idx]
          taken = f.block.length
          new_fs = Block.new(fs.start + taken, fs.length - taken)
          free_spaces[free_space_idx] = new_fs
          fs.expand.first(taken)
        else
          f.block.expand
        end
        memo + (f.id * positions.reduce(:+))
      end
  end

  private

  def parse
    file_blocks = []
    free_spaces = []
    cursor = 0
    @input.first.chars.map(&:to_i).each_with_index do |length, index|
      if index.even?
        file_blocks << Block.new(cursor, length)
      else
        free_spaces << Block.new(cursor, length)
      end
      cursor += length
    end

    files = file_blocks.each_with_index.map { |block, index| Fille.new(index, block) }

    [files, free_spaces]
  end
end
