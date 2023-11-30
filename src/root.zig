const std = @import("std");
const fmt = std.fmt;
const testing = std.testing;

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}

/// Read a line of input from `reader`, where each line is denoted by a "\n"
/// character.
///
/// This was copied (and adapted) from
/// https://ziglearn.org/chapter-2/#readers-and-writers, and it will also
/// strip the trailing "\r" character from the end of the line.
pub fn readLine(reader: anytype, buffer: []u8) !?[]const u8 {
    const line = (try reader.readUntilDelimiterOrEof(buffer, '\n')) orelse return null;

    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(u8, line, "\r");
    }

    return line;
}

/// Reads a line of input from `reader`, converting it to a signed or unsigned
/// integer `T`, with the given `base`.
///
/// If the line that was read is empty -- because sometimes, the puzzles like
/// to use blank lines as delimiters -- this function will return null.
pub fn readInt(comptime T: type, reader: anytype, base: u8) !?T {
    var buf: [100]u8 = undefined;
    const line = (try readLine(reader, &buf)) orelse return null;
    const n: T = (try fmt.parseInt(T, line, base)) orelse return null;
    return n;
}

test "parseUnsigned" {
    const n = try fmt.parseUnsigned(usize, "15931", 10);
    try testing.expect(n == 15931);
}
