# Advent of Code 2023

My solutions to [Advent of Code][aoc] puzzles, in [Zig][zig]!

## Running the solutions

Before you can run any of the solutions, you will need to get your puzzle input, and save it.
If you want, the `input/` directory is completely ignored from git.
For example, you could save your puzzle into to `input/01.txt`.

There are two ways to run a solution for a day's puzzle:

1. `zig build NN < path/to/input/NN.txt`
2. `zig run src/NN.zig < path/to/input/NN.txt` (preferred)

where `NN` is the zero-prefix, two digit day (e.g. day 1 is `01`).
Each program reads the puzzle input from STDIN.

The second approach is my preferred method, since the compiler messages get garbled up with
the program output.

![zig logo](https://github.com/ziglang/logo/blob/master/zig-mark-neg-black.svg)

[aoc]: https://adventofcode.com
[zig]: https://ziglang.org
