const std = @import("std");
const expect = std.testing.expect;

pub fn main() !void {
    // Premable for reading stuff from standard input.
    const stdin_file = std.io.getStdIn();
    var bw = std.io.bufferedReader(stdin_file.reader());
    const stdin = bw.reader();
    _ = stdin;

    // Initializes an allocator, and makes sure it gets cleaned up at the end,
    // along with checking to make sure no allocations were leaked.
    // Make sure that if something uses the allocator (e.g. std.ArrayList),
    // that you free it or call its "deinit" method (if it has one).
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const check = gpa.deinit();
        if (check == .leak) expect(false) catch @panic("DEINIT FAILED");
    }
    const alloc = gpa.allocator();

    // Initializes a std.ArrayList for storing input.
    var list = std.ArrayList(usize).init(alloc);
    defer list.deinit(); // This frees the underlying storage of the ArrayList.

    // Print the puzzle solutions to standard error.
    std.debug.print("todo.\n", .{});
}
