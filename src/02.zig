const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;
const aoc = @import("root.zig");

pub fn main() !void {
    // This prefix starts each line of the input.
    // We are going to use it to do some string splitting later on.
    const prefix = "Game ";

    // For part 1, we need to find the sum of the game IDs where each game is
    // possible, given a `limit` of the number of cubes in the bag.
    var possible_sum: usize = 0;
    const max_reds: usize = 12;
    const max_greens: usize = 13;
    const max_blues: usize = 14;

    // For part 2, we need to find the fewest number of each colour cube that
    // could have been in the bag to make each game possible.
    // After we find that, we calculate the "power" of the set of cubes for
    // each game, and sum all of the powers together.
    var power_sum: usize = 0;

    // Read from STDIN.
    const stdin = std.io.getStdIn().reader();
    var buffer: [1024]u8 = undefined;
    while (try aoc.readLine(stdin, &buffer)) |line| {
        // Parse the game ID.
        const colon = mem.indexOf(u8, line, ":").?;
        const game_id = try fmt.parseUnsigned(usize, line[prefix.len..colon], 10);

        // For part 1, we need to know if this game is possible.
        //
        // We will start out assuming the game is possible, and set this to
        // false if we determine it isn't.
        var game_possible: bool = true;

        // For part 2, to calculate the "power" of each game, we need to know
        // the minimum number of each colour of cube that needs to be in the
        // bag, for all draws to be possible.
        // Then we multiply the values together, and add it to `power_sum`.
        var min_reds: usize = 0;
        var min_greens: usize = 0;
        var min_blues: usize = 0;

        // Parse each draw of cubes.
        var draws = mem.splitScalar(u8, line[colon + 1 ..], ';');
        while (draws.next()) |draw| {
            const trimmed = mem.trim(u8, draw, " ");

            var red: usize = 0;
            var green: usize = 0;
            var blue: usize = 0;
            var cubes = mem.splitSequence(u8, trimmed, ", ");
            while (cubes.next()) |num_color| {
                const space = mem.indexOf(u8, num_color, " ").?;
                const num = try fmt.parseUnsigned(u8, num_color[0..space], 10);
                const color = num_color[space + 1 ..];
                if (mem.eql(u8, color, "red")) {
                    red = num; // part 1
                    if (num > min_reds) min_reds = num; // part 2
                } else if (mem.eql(u8, color, "green")) {
                    green = num; // part 1
                    if (num > min_greens) min_greens = num; // part 2
                } else if (mem.eql(u8, color, "blue")) {
                    blue = num; // part 1
                    if (num > min_blues) min_blues = num; // part 2
                } else {
                    unreachable;
                }
            }

            // Part 1: Is this game possible?
            if (red > max_reds or green > max_greens or blue > max_blues) {
                game_possible = false;
            }
        }

        // Part 1: Add the game ID to the sum of possible game IDs.
        if (game_possible) {
            possible_sum += game_id;
        }

        // Part 2: Calculate the "power" based on the minimum number of each
        // colour of cube that must be in the bag so that the game is possible,
        // then add it to a rolling sum of power levels.
        power_sum += (min_reds * min_greens * min_blues);
    }

    std.debug.print("{d}\n{d}\n", .{ possible_sum, power_sum });
}
