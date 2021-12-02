# Advent of code Aoc2021

This repository contains the solutions of the problems of the
[advent of code 2021](https://adventofcode.com/2021/) written in [Elixir](https://elixir-lang.org/).
The repository has been configured as a Mix application.

## Running it

To run the code with the example input provided in each problem run `mix test test/aoc2021_dayN_test.exs`, for N∈[1, 25].
This runs the code with the example input for the day N and compares the result with the solution provided.

To run the code with the real input:

    iex -S mix
    iex(1)> Aoc2021.DayN.run(:part1)
    iex(2)> Aoc2021.DayN.run(:part2)

again for N∈[1, 25].
Input files for each day are saved into the dir `inputs`.
Code is in the `lib` dir.
