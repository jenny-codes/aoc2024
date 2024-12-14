# Advent of Code 2024


## QOL commands

- `rake start\[day\]`
  - The argument `day` defaults to the current day, if left unspecified.
  - Example: `rake start\[day1\]`, which will
  - Create a new source file at ./day1.rb with some template code.
  - Download the input into data/day1.txt.
  - Needs an environmental variable `AOC_SESSION_TOKEN` to fetch the input data. Can find it in your browswer network inspector under the 'session' cookie.
- `rake solve\[day\]`
  - The argument `day` defaults to the current day, if left unspecified.
  - Example: `rake solve\[day1\]`, which will
  - Run the code to solve the day's puzzles and print the outputs.
