const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;
const expect = std.testing.expect;
const aoc = @import("root.zig");

pub fn main() !void {
    const stdin_file = std.io.getStdIn();
    var bw = std.io.bufferedReader(stdin_file.reader());
    const stdin = bw.reader();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const check = gpa.deinit();
        if (check == .leak) expect(false) catch @panic("DEINIT FAILED");
    }
    const alloc = gpa.allocator();

    var list = std.ArrayList(usize).init(alloc);
    defer list.deinit();

    var sum: usize = 0;
    var buffer: [100]u8 = undefined;
    while (try aoc.readLine(stdin, &buffer)) |line| {
        // If we encounter a blank line, take the current sum, and add it to
        // our ArrayList.
        if (line.len == 0) {
            try list.append(sum);
            sum = 0;
            continue;
        }

        const n = try fmt.parseUnsigned(usize, line, 10);
        sum += n;
    }

    // Find the elf carrying the most calories.
    // const calories = try list.toOwnedSlice();
    mem.sort(usize, list.items, {}, std.sort.desc(usize));
    const max = list.items[0];
    std.debug.print("{d}\n", .{max});

    // Part 2.
    const top_three = list.items[0] + list.items[1] + list.items[2];
    std.debug.print("{d}\n", .{top_three});
}
