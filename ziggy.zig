const std = @import("std");

pub fn getNumber() i32 {
    return 42;
}

test "getNumber should return 42" {
    try std.testing.expectEqual(42, getNumber());
}