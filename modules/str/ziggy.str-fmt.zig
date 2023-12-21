//! Submodule to format/manipulate string.

const std = @import("std");
const z = @import("../../ziggy.zig");

// Format and create a string from a pattern and it's given arguments.
// Rational:
//   a) It does not reflect the intent, we're not 'printing', we're formatting a pattern with variables and returning it.
//   b) I personally prefer going with allocator passing instead of out buffers.
// TODO: Can we do comptime checking if the args in respect to a pattern is valid?
//       Currently zig std gives an ugly error that's hard to grasp what is wrong.

///
/// Format to a string given a pattern and the variables to subsitute.
/// TODO: Can we validate if a pattern is valid? So we don't throw ugly errors.
///
pub inline fn format(allocator: std.mem.Allocator, comptime pattern: []const u8, args: anytype) std.fmt.AllocPrintError![]u8 {
    return try std.fmt.allocPrint(allocator, pattern, args);
}

test "str.format() formats a pattern with a string '{s}' placeholder." {
    const allocator = std.heap.page_allocator;
    const pattern = "Hello {s}";
    const args = .{"World"};
    const result = try format(allocator, pattern, args);
    try std.testing.expect(z.str.equals(result, "Hello World"));
}

test "str.format() formats a pattern with a integer '{d}' placeholder." {
    const allocator = std.heap.page_allocator;
    const pattern = "Hello {d}";
    const args = .{42};
    const result = try format(allocator, pattern, args);
    try std.testing.expect(z.str.equals(result, "Hello 42"));
}

///
/// Removes all occurences of the character (or sequence of characters) in a string.
///
pub inline fn remove(allocator: std.mem.Allocator, haystack: []const u8, needle: []const u8) ![]const u8 {
    const outputSize = std.mem.replacementSize(u8, haystack, needle, "");
    const output = try allocator.alloc(u8, outputSize);
    _ = std.mem.replace(u8, haystack, needle, "", output);
    return output;
}

test "str.remove() should remove all occurences of 'l' in the word 'hello world'" {
    const allocator = std.testing.allocator;
    const string = "hello world!";

    const new_string = try remove(allocator, string, "l");
    defer allocator.free(new_string);

    try std.testing.expectEqualSlices(u8, "heo word!", new_string);
}

test "str.remove() should remove line endings" {
    const allocator = std.testing.allocator;
    const string: []const u8 = "hello world!\n";

    const new_string = try remove(allocator, string, "\n");
    defer allocator.free(new_string);

    try std.testing.expectEqualSlices(u8, "hello world!", new_string);
}
