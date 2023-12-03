const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;
const aoc = @import("root.zig");

pub fn main() !void {
    // Read from STDIN.
    const stdin = std.io.getStdIn().reader();
    var p1sum: isize = 0;
    var p2sum: isize = 0;
    var buffer: [1024]u8 = undefined;
    while (try aoc.readLine(stdin, &buffer)) |line| {
        // Part 1.
        {
            const first = try fmt.charToDigit(firstDigitChar(line), 10);
            const last = try fmt.charToDigit(lastDigitChar(line), 10);
            const n = (first * 10) + last;
            p1sum += n;
        }

        // Part 2.
        {
            const first = firstDigit(line);
            const last = lastDigit(line);
            const n = (first * 10) + last;
            p2sum += n;
        }
    }
    std.debug.print("{d}\n{d}\n", .{ p1sum, p2sum });
}

fn firstDigitChar(line: []const u8) u8 {
    for (line) |c| {
        if (isDigit(c)) return c;
    }
    unreachable;
}

inline fn isDigit(c: u8) bool {
    return (c >= '0' and c <= '9');
}

fn lastDigitChar(line: []const u8) u8 {
    var i = line.len - 1;
    while (i >= 0) : (i -= 1) {
        if (isDigit(line[i])) return line[i];
    }
    unreachable;
}

const DigitName = struct {
    name: []const u8,
    value: u8,
};

const digits_by_name = [_]DigitName{
    .{ .name = "one", .value = 1 },
    .{ .name = "two", .value = 2 },
    .{ .name = "three", .value = 3 },
    .{ .name = "four", .value = 4 },
    .{ .name = "five", .value = 5 },
    .{ .name = "six", .value = 6 },
    .{ .name = "seven", .value = 7 },
    .{ .name = "eight", .value = 8 },
    .{ .name = "nine", .value = 9 },
    .{ .name = "1", .value = 1 },
    .{ .name = "2", .value = 2 },
    .{ .name = "3", .value = 3 },
    .{ .name = "4", .value = 4 },
    .{ .name = "5", .value = 5 },
    .{ .name = "6", .value = 6 },
    .{ .name = "7", .value = 7 },
    .{ .name = "8", .value = 8 },
    .{ .name = "9", .value = 9 },
};

fn firstDigit(line: []const u8) u8 {
    for (0..line.len) |start| {
        for (digits_by_name) |prefix| {
            if (mem.startsWith(u8, line[start..], prefix.name)) return prefix.value;
        }
    }
    unreachable;
}

fn lastDigit(line: []const u8) u8 {
    var end: usize = line.len;
    while (end > 0) : (end -= 1) {
        for (digits_by_name) |suffix| {
            if (mem.endsWith(u8, line[0..end], suffix.name)) return suffix.value;
        }
    }
    unreachable;
}
