//! Submodule to deal with comparisons.
//! TODO: How do we deal with []u8 and []const u8 or comptime []const u8? which flavour do we prefer? do we need to support all three?

const std = @import("std");

///
/// Compares two strings (u8 slices) for equality.
/// TODO: Optional arguments for case insensitive comparison.
/// TODO: Optional arguments for trimming and ignoring whitespace characters (i.e. \n, \r, \t).
///
pub inline fn equals(first: []const u8, second: []const u8) bool {
    return std.mem.eql(u8, first, second);
}

test "str.equals() should return true if both strings are equal" {
    const result = equals("Hello World", "Hello World");
    try std.testing.expect(result);
}

test "str.equals() should return false if one of the string has a different case" {
    const result = equals("Hello World", "hello world");
    try std.testing.expect(!result);
}

///
/// Returns true if a string (u8 slice) contains visible text (excl. whitespaces, line ending etc.).
/// TODO: Don't consider whitespace or line endings as text.
///
pub inline fn has_text(string: []const u8) bool {
    return !std.mem.eql(u8, string, "");
}

test "str.has_text() should return true if string contains text" {
    try std.testing.expect(has_text("hello world"));
}

test "str.has_text() should return false if string contains nothing" {
    try std.testing.expect(has_text("") == false);
}

test "str.has_text() should return false if string is empty slice" {
    const empty_slice: []const u8 = &.{};
    try std.testing.expect(has_text(empty_slice) == false);
}
