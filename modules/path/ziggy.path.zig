const std = @import("std");
const z = @import("../../ziggy.zig");

// Get relative path from the working directory.
// Rational:
//   a) "realPathAlloc" really doesn't tell what the intent is.
//   b) Also a desire to be relative to an arbitraty directory other than cwd (hence cwd_prefix for now).
//   c) Formattable, the last any type can be left empty.
pub inline fn from_cwd(allocator: std.mem.Allocator, comptime pattern: []const u8, args: anytype) ![]u8 {
    const path = try z.str.format(allocator, pattern, args);
    defer allocator.free(path);

    return std.fs.cwd().realpathAlloc(allocator, path);
}

test "fs.from_cwd() gets cwd if empty sub directory is provided." {
    const allocator = std.testing.allocator;
    const cwd = try std.fs.cwd().realpathAlloc(allocator, "");
    defer allocator.free(cwd);

    const format_from_cwd = try from_cwd(allocator, "", .{});
    defer allocator.free(format_from_cwd);

    try std.testing.expect(z.str.equals(cwd, format_from_cwd));
}

test "fs.from_cwd() should get cwd with specified sub directory" {
    const allocator = std.testing.allocator;
    const cwd = try std.fs.cwd().realpathAlloc(allocator, ".");
    defer allocator.free(cwd);

    //TODO: This test will fail on linux since path seperators are based on how windows do things.
    const to_path = "test_data\\to\\my\\file.txt";

    //TODO: &[_][]const u8{ cwd, to_path } is extremely ugly, can we also wrap this at some point?
    const from_cwd_to_path = try std.fs.path.join(allocator, &[_][]const u8{ cwd, to_path });
    defer allocator.free(from_cwd_to_path);

    const cwd_with_to_path = try from_cwd(allocator, to_path, .{});
    defer allocator.free(cwd_with_to_path);

    try std.testing.expect(z.str.equals(from_cwd_to_path, cwd_with_to_path));
}
