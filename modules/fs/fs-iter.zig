const std = @import("std");
const builtin = @import("builtin");
const path = @import("./fs-path.zig");
const str = @import("../ziggy.str.zig");

const ReaderType = std.fs.File.Reader;
const BufReaderType = std.io.BufferedReader(4096, ReaderType);
const BufReaderReaderType = BufReaderType.Reader;

/// A generic iterator to read a buffer line by line given a delimiter or until it reaces EOF.
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

test "should iterate iterator.txt line by line" {
    const allocator = std.testing.allocator;

    const iteratorPath = try path.from_cwd(allocator, "./test_data/iterator.txt", .{});
    defer allocator.free(iteratorPath);

    const file = try std.fs.openFileAbsolute(iteratorPath, .{});

    var iterator = ReadUntilDelimiterIterator.init(allocator, file, '\n');
    var test_data_count: usize = 0;
    const test_data: []const []const u8 = &.{ "hello", "this", "is", "a", "line", "by", "line", "iterator!" };

    while (try iterator.next()) |line| {
        const test_data_slice = test_data[test_data_count];
        try std.testing.expect(str.equals(test_data_slice, line));
        test_data_count += 1;
    }
}

test "should iterate a large text input line by line" {
    const allocator = std.testing.allocator;

    const iteratorPath = try path.from_cwd(allocator, "./test_data/dutch-words.txt", .{});
    defer allocator.free(iteratorPath);

    const file = try std.fs.openFileAbsolute(iteratorPath, .{});

    var iterator = ReadUntilDelimiterIterator.init(allocator, file, '\n');
    var count: i32 = 0;

    while (try iterator.next()) |line| {
        try std.testing.expect(str.has_text(line));
        count += 1;
    }

    try std.testing.expect(199403 == count);
}

// Open a file and get the (buffered) reader from it.
// Rational:
//   a) Opening a file and getting a reader seems like a very common operation.
//   b) I'm personally of the opinion a reader also belongs in std.fs and not std.io.
pub inline fn line_iterator(allocator: std.mem.Allocator, filePath: []const u8) ReadUntilDelimiterIterator {
    const file = try std.fs.openFileAbsolute(filePath, .{});

    //TODO: "\n" is not bulletproof for all platforms.
    return ReadUntilDelimiterIterator.init(allocator, file, '\n');
}
