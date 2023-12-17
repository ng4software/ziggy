const std = @import("std");

// Basic string comparison, is case sensitive.
// TODO: Add args to allow for a) trimming and b) case insensitive comparison.
// TODO: Does this not need to live in a "str" module?
pub inline fn strEq(first: []const u8, second: []const u8) bool {
    return std.mem.eql(u8, first, second);
}

test "should equal" {
    const result = strEq("Hello World", "Hello World");
    try std.testing.expect(result);
}

test "should be case sensitive" {
    const result = strEq("Hello World", "hello world");
    try std.testing.expect(!result);
}