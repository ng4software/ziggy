const std = @import("std");

//TODO: How do we deal with []u8 and []const u8 or comptime []const u8?
//      Too inexperienced to know what we should be doing with these different types... maybe std is smart enough to deal with this?

/// Compare one slice against another and check if they are equal.
/// TODO: Optional arguments for case insensitive comparison.
/// TODO: Optional arguments for trimming and ignoring whitespace characters (i.e. \n, \r, \t).
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

/// Checks if the given slice has any text present.
/// TODO: Optional arguments for trimming and ignoring whitespace characters (i.e. \n, \r, \t).
pub inline fn has_text(string: []const u8) bool {
    return !std.mem.eql(u8, string, "");
}

test "str.has_text() should return false if string contains nothing" {
    try std.testing.expect(has_text("") == false);
}

test "str.has_text() should return false if string is empty slice" {
    const empty_slice: []const u8 = &.{};
    try std.testing.expect(has_text(empty_slice) == false);
}
