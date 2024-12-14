# frozen_string_literal: true

require "./solution.rb"
Dir["./day*.rb"].each {|file| require file }

YEAR = 2024

desc 'Run the code in a given file. Defaults to today. E.g., rake solve day1'
task :solve, [:day] do |_t, args|
  day = args.day || "day#{Time.now.day}"
  # Read data into arrays of strings
  input = File.readlines("data/#{day}.txt").map(&:strip)
  solution = Solution.for(day, input)

  puts("Part 1: #{solution.part_one}")
  puts("Part 2: #{solution.part_two}")
end

desc 'Setup files for the day. Need AOC_SESSION_TOKEN env var.'
task :start, [:day] do |_t, args|
  token = ENV.fetch('AOC_SESSION_TOKEN')
  day = args.day || "day#{Time.now.day}"
  day_num = day.gsub("day", "")

  # If one doesn't already exist, create a source code file
  source_path = "#{day}.rb"
  unless File.exist?(source_path)
    `echo '#{template}' | sed s/DAY/#{day.capitalize}/ > #{source_path}`
  end

  # Create a new input file
  input_path = "data/#{day}.txt"
  unless File.exist?(input_path)
    `curl --header 'cookie: session=#{token}' -o #{input_path} https://adventofcode.com/#{YEAR}/day/#{day_num}/input`
  end

  puts "Generated files for #{day} 🎄"
  `open https://adventofcode.com/#{YEAR}/day/#{day_num}`
end

def template
  <<~TEMPLATE
    # frozen_string_literal: true

    require "./solution.rb"
    
    class DAY < Solution
      def part_one
        @input
      end

      def part_two
      end
    end
  TEMPLATE
end

