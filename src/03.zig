const std = @import("std");
const aoc = @import("root.zig");

pub fn main() !void {
    // For holding the entire schematic.
    // We are going to hold the entire thing in memory.
    //
    // NOTE: Looking at my input, the schematic was 140 x 140 characters.
    var schematic: [140][140]u8 = undefined;

    // Read from STDIN.
    const stdin = std.io.getStdIn().reader();
    var buffer: [1024]u8 = undefined;
    var i: usize = 0;
    while (try aoc.readLine(stdin, &buffer)) |line| {
        std.mem.copy(u8, &schematic[i], line[0..]);
        i += 1;
    }

    var sum: usize = 0;
    for (schematic, 0..) |row, y| {
        // Keep track of whether or not we are in a number, which X-index the
        // number starts at (numbers are only horizontal), and whether or not
        // any of the digits in this number are adjacent to a symbol character.
        var in_number: bool = false;
        var num_start: usize = undefined;
        var symbol_adjacent: bool = false;

        // Iterate through each character in the row.
        for (row, 0..) |c, x| {
            if (c == '.' or isSymbol(c) or x + 1 == 140) {
                // If we encounter a period "." or symbol character, check to
                // see if we are currently "in a number".
                if (in_number) {
                    // We are in a number? Awesome!
                    // Parse the number and add it to our sum if any of its
                    // digits are adjacent to a symbol.
                    var num_end = x;
                    if (x == 139 and std.ascii.isDigit(c)) num_end += 1; // account for last char in row being a digit
                    const n = try std.fmt.parseUnsigned(usize, schematic[y][num_start..num_end], 10);
                    if (symbol_adjacent) sum += n;
                }

                // Reset our state, and skip on to the next iteration of this
                // loop.
                in_number = false;
                num_start = undefined;
                symbol_adjacent = false;

                continue;
            } else if (std.ascii.isDigit(c)) {
                // We found a digit!
                //
                // If we weren't already "in" a number, update our state to
                // indicate we are, and set the starting index for this number.
                // (We parse this number above.)
                if (!in_number) {
                    in_number = true;
                    num_start = x;
                }

                // Check to see if this digit is adjacent to a symbol.
                //
                // Note that we are clamping the values of `y_start` and
                // `x_start` so that we never go below 0 (zero).
                // This is to prevent an integer underflow since array and
                // slice indexes are usizes.
                const y_start = if (y == 0) y else y - 1;
                for (y_start..y + 2) |yy| {
                    const x_start = if (x == 0) x else x - 1;
                    for (x_start..x + 2) |xx| {
                        if (isSymbol(getChar(schematic, yy, xx))) symbol_adjacent = true;
                    }
                }
            }
        }
    }
    std.debug.print("{d}\n", .{sum});
}

// Get the character at `y` (row) and `x` (column) coordinates, from
// `schematic`.
// Returns null if `x` or `y` are outside the bounds of `schematic`.
fn getChar(schematic: [140][140]u8, y: usize, x: usize) ?u8 {
    if (y < 0 or y >= 140 or x < 0 or x >= 140) return null;
    return schematic[y][x];
}

// Indicate if `char` is any character other than a number, or a period.
// Returns false if `char` is null.
fn isSymbol(char: ?u8) bool {
    if (char) |c| {
        return !std.ascii.isDigit(c) and c != '.';
    }
    return false;
}
