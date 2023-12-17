const std = @import("std");
const cmp = @import("ziggy.cmp.zig");


// Wrapper for std.fmt.allocPrint.
// Rational:
//   a) It does not reflect the intent, we're not 'printing', we're formatting a pattern with variables and returning it.
//   b) I personally prefer going with allocator passing instead of out buffers.
pub inline fn format(allocator: std.mem.Allocator, comptime fmt: []const u8, args: anytype) std.fmt.AllocPrintError![]u8 {
    return try std.fmt.allocPrint(allocator, fmt, args);
}

test "format string" {
    const allocator = std.heap.page_allocator;
    const pattern = "Hello {s}";
    const args = .{ "World" };
    const result = try format(allocator, pattern, args);
    try std.testing.expect(cmp.strEq(result, "Hello World"));
}

test "format integer" {
    const allocator = std.heap.page_allocator;
    const pattern = "Hello {d}";
    const args = .{ 42 };
    const result = try format(allocator, pattern, args);
    try std.testing.expect(cmp.strEq(result, "Hello 42"));
}