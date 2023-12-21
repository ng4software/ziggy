//! This module provides utility functions to iterate over data, such as buffers.

const std = @import("std");
const builtin = @import("builtin");
const z = @import("../../ziggy.zig");

const ReaderType = std.fs.File.Reader;
const BufReaderType = std.io.BufferedReader(4096, ReaderType);
const BufReaderReaderType = BufReaderType.Reader;

///
/// A generic iterator that will read the underlying buffer to some delimiter or end of file.
///
pub const ReadUntilDelimiterIterator = struct {
    allocator: std.mem.Allocator,
    delimiter: u8,
    stream: ?BufReaderReaderType,
    buffer: [4096]u8,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, file: std.fs.File, delimeter: u8) Self {
        const file_reader: ReaderType = file.reader();
        var buffered_stream: BufReaderType = std.io.bufferedReader(file_reader);

        return ReadUntilDelimiterIterator{
            .allocator = allocator,
            .delimiter = delimeter,
            .stream = buffered_stream.reader(),
            .buffer = undefined,
        };
    }

    pub fn next(self: *Self) !?[]const u8 {
        if (self.stream) |stream| {
            if (try stream.readUntilDelimiterOrEof(&self.buffer, self.delimiter)) |line| {
                if (builtin.os.tag == .windows) {
                    //NOTE: Windows uses CRLF (\n\r), we need to manually strip the LF part.
                    //TODO: Make a function that will correctly normalize a string based on os tag.
                    return std.mem.trimRight(u8, line, "\r");
                } else {
                    return line;
                }
            }

            return null;
        }

        unreachable;
    }
};

test "ReadUntilDelimiterIterator should iterate iterator.txt line by line" {
    const allocator = std.testing.allocator;

    const iteratorPath = try z.path.from_cwd(allocator, "./test_data/iterator.txt", .{});
    defer allocator.free(iteratorPath);

    const file = try std.fs.openFileAbsolute(iteratorPath, .{});

    var iterator = ReadUntilDelimiterIterator.init(allocator, file, '\n');
    var test_data_count: usize = 0;
    const test_data: []const []const u8 = &.{ "hello", "this", "is", "a", "line", "by", "line", "iterator!" };

    while (try iterator.next()) |line| {
        const test_data_slice = test_data[test_data_count];
        try std.testing.expect(z.str.equals(test_data_slice, line));
        test_data_count += 1;
    }
}

test "ReadUntilDelimiterIterator should iterate a large text input line by line" {
    const allocator = std.testing.allocator;

    const iteratorPath = try z.path.from_cwd(allocator, "./test_data/dutch-words.txt", .{});
    defer allocator.free(iteratorPath);

    const file = try std.fs.openFileAbsolute(iteratorPath, .{});

    var iterator = ReadUntilDelimiterIterator.init(allocator, file, '\n');
    var count: i32 = 0;

    while (try iterator.next()) |line| {
        try std.testing.expect(z.str.has_text(line));
        count += 1;
    }

    try std.testing.expect(199403 == count);
}

///
/// Create a new iterator that will read the buffer line by line, delimited by a line ending \n (CR)
/// TODO: Currently does not support CR or LF delimited buffers.
///
pub inline fn line_iterator(allocator: std.mem.Allocator, filePath: []const u8) !ReadUntilDelimiterIterator {
    const file = try std.fs.openFileAbsolute(filePath, .{});

    //TODO: "\n" is not bulletproof for all platforms.
    return ReadUntilDelimiterIterator.init(allocator, file, '\n');
}

test "fs.line_iterator() should open file and create a line-by-line iterator" {
    const allocator = std.testing.allocator;

    const iteratorPath = try z.path.from_cwd(allocator, "./test_data/dutch-words.txt", .{});
    defer allocator.free(iteratorPath);

    var iterator = try line_iterator(allocator, iteratorPath);
    var count: i32 = 0;

    while (try iterator.next()) |line| {
        try std.testing.expect(z.str.has_text(line));
        count += 1;
    }

    try std.testing.expect(199403 == count);
}
