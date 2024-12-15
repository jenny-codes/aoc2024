# Advent of Code 2024


## Commands

- `exe/start day*`
  - \* is the day that you want to start on. E.g., `exe/solve day1`. It defaults to the current day, if left unspecified.
  - It will create a new source file at ./day*.rb with some template code.
  - It will download the input into data/day*.txt.
  - Needs to either have set an environmental variable `AOC_SESSION_TOKEN` or to provide one via prompt to fetch the input data. Can find it in your browswer network inspector under the 'session' cookie.

- `exe/solve day*`
  - \* is the day that you want to solve for. E.g., `exe/solve day1`. It defaults to the current day, if left unspecified.
  - It will run the code to solve the day's puzzles and print the outputs.

