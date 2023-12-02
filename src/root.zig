const std = @import("std");

/// Read a line of input from `reader`, where each line is denoted by a "\n"
/// character.
///
/// This was copied (and adapted) from
/// https://ziglearn.org/chapter-2/#readers-and-writers, and it will also strip
/// the trailing "\r" character from the end of the line.
pub fn readLine(reader: anytype, buffer: []u8) !?[]const u8 {
    const line = (try reader.readUntilDelimiterOrEof(buffer, '\n')) orelse return null;

    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(u8, line, "\r");
    }

    return line;
}

/// Calculate the sum of all numeric values in `items`.
pub fn sum(comptime T: type, items: []const T) isize {
    var n: isize = 0;
    for (items) |i| {
        const m: isize = @intCast(i);
        n += m;
    }
    return n;
}
