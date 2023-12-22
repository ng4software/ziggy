//! Submodule to format/manipulate string.

const std = @import("std");
const z = @import("../../ziggy.zig");

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

///
/// Returns the first character of a string.
///
pub inline fn first(string: []const u8) ?u8 {
    if (string.len == 0) {
        return null;
    }

    return string[0];
}

test "str.first() should return first character of string" {
    try std.testing.expect(first("Hello World") == 'H');
}

test "str.first() should return first character if string is one character long" {
    try std.testing.expect(first("1") == '1');
}

test "str.first() returns empty optional if string is empty" {
    if (first("")) |_| {
        try std.testing.expect(false);
    } else {
        try std.testing.expect(true);
    }
}

///
/// Returns the first character of a string.
///
pub inline fn last(string: []const u8) ?u8 {
    if (string.len == 0) {
        return null;
    }

    return string[string.len - 1];
}

test "str.last() should return first character of string" {
    try std.testing.expect(last("Hello World!") == '!');
}

test "str.last() should return first character if string is one character long" {
    try std.testing.expect(last("1") == '1');
}

test "str.last() returns empty optional if string is empty" {
    if (last("")) |_| {
        try std.testing.expect(false);
    } else {
        try std.testing.expect(true);
    }
}

///
/// Filters the character of a string given a function.
///
pub inline fn filter(allocator: std.mem.Allocator, string: []const u8, filterFn: *const fn (u8) bool) ![]const u8 {
    var result = std.ArrayList(u8).init(allocator);
    defer result.deinit();

    for (string) |char| {
        if (filterFn(char)) {
            try result.append(char);
        }
    }

    return result.toOwnedSlice();
}

test "str.filter() filters according filter predicate" {
    const alloc = std.testing.allocator;
    const onlyDigits: []const u8 = try filter(alloc, "one2three4five6", &std.ascii.isDigit);
    defer alloc.free(onlyDigits);

    try std.testing.expectEqualSlices(u8, "246", onlyDigits);
}
