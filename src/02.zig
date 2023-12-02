const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;
const aoc = @import("root.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const result = gpa.deinit();
        if (result == .leak) std.testing.expect(false) catch @panic("LEAK DETECTED");
    }
    const alloc = gpa.allocator();

    // Input for part 1.
    var games = std.ArrayList(Game).init(alloc);
    defer games.deinit();

    // Read from STDIN.
    const stdin = std.io.getStdIn().reader();
    var buffer: [1024]u8 = undefined;
    while (try aoc.readLine(stdin, &buffer)) |line| {
        const game = try parseGame(alloc, line);
        try games.append(game);
    }

    // For part 1, we need to find the sum of the game IDs where each game is
    // possible, given a `limit` of the number of cubes in the bag.
    var possible_sum: usize = 0;
    const limit = Cubes{ .red = 12, .green = 13, .blue = 14 };

    // For part 2, we need to find the fewest number of each colour cube that
    // could have been in the bag to make each game possible.
    // After we find that, we calculate the "power" of the set of cubes for
    // each game, and sum all of the powers together.
    var power_sum: usize = 0;

    for (games.items) |game| {
        if (game.possible(limit)) {
            possible_sum += game.id;
        }

        power_sum += game.power();

        game.deinit();
    }

    std.debug.print("{d}\n{d}\n", .{ possible_sum, power_sum });
}

fn parseGame(allocator: mem.Allocator, input: []const u8) !Game {
    // Parse the game ID.
    const prefix = "Game ";
    const colon = mem.indexOf(u8, input, ":").?;
    const id = try fmt.parseUnsigned(usize, input[prefix.len..colon], 10);

    // Parse each draw.
    // The draws for each game start after the ":" character, and each draw in
    // a game is separated by a semicolon (";").
    var draws = std.ArrayList(Cubes).init(allocator);
    var start = colon + 2; // We use 2 to skip the space after the ":"
    // var draw_num: usize = 1;
    while (true) {
        const end = if (mem.indexOf(u8, input[start..], ";")) |i| i else input.len - start;
        const draw = input[start .. start + end];

        // std.debug.print("Game {d}: draw({d}) = {s}\n", .{ id, draw_num, draw });
        // draw_num += 1;

        const result = try parseCubes(draw);
        try draws.append(result);

        start += end + 2; // Again, +2 to skip the leading space.
        if (start >= input.len) break;
    }

    return Game{ .id = id, .draws = draws };
}

const Game = struct {
    const Self = @This();

    // The game ID.
    id: usize,

    // The results of each time cubes were drawn from the bag.
    draws: std.ArrayList(Cubes),

    // Deinitializes the game, freeing up memory.
    fn deinit(self: Self) void {
        self.draws.deinit();
    }

    // Indicates whether or not this game is possible given the known number
    // of cubes in the bag.
    fn possible(self: Self, limits: Cubes) bool {
        for (self.draws.items) |draw| {
            if (!draw.possible(limits)) return false;
        }
        return true;
    }

    // Finds the minimum number of cubes that could be in the bag to make this
    // game possible, and returns the "power" of the set of cubes.
    fn power(self: Self) usize {
        // Find the minimum number of cubes to make all games possible.
        var reds: u8 = 0;
        var greens: u8 = 0;
        var blues: u8 = 0;
        for (self.draws.items) |draw| {
            if (draw.red > reds) {
                reds = draw.red;
            }
            if (draw.green > greens) {
                greens = draw.green;
            }
            if (draw.blue > blues) {
                blues = draw.blue;
            }
        }

        const red: usize = @intCast(reds);
        const green: usize = @intCast(greens);
        const blue: usize = @intCast(blues);

        return red * green * blue;
    }
};

// Parse the cubes from a `draw`.
//
// Draws are expected to be in the format "1 red, 2 green, 6 blue" for example.
fn parseCubes(draw: []const u8) !Cubes {
    var red: u8 = 0;
    var green: u8 = 0;
    var blue: u8 = 0;

    var iter = mem.splitSequence(u8, draw, ", ");
    while (iter.next()) |num_color| {
        // std.debug.print("num_color = {s}\n", .{num_color});

        const i = mem.indexOf(u8, num_color, " ").?;
        const n = try fmt.parseUnsigned(u8, num_color[0..i], 10);

        const colour = num_color[i + 1 ..];
        if (mem.eql(u8, colour, "red")) {
            red = n;
        } else if (mem.eql(u8, colour, "green")) {
            green = n;
        } else if (mem.eql(u8, colour, "blue")) {
            blue = n;
        } else {
            unreachable;
        }
    }

    return Cubes{
        .red = red,
        .green = green,
        .blue = blue,
    };
}

const Cubes = struct {
    red: u8,
    green: u8,
    blue: u8,

    // Indicates if this draw is possible, given the `limits` available.
    inline fn possible(self: *const Cubes, limit: Cubes) bool {
        return (self.red <= limit.red and self.green <= limit.green and self.blue <= limit.blue);
    }
};
