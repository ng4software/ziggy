const std = @import("std");
const fmt = @import("ziggy.fmt.zig");
const cmp = @import("ziggy.cmp.zig");

// Get relative path from the working directory.
// Rational:
//   a) "realPathAlloc" really doesn't tell what the intent is.
//   b) Also a desire to be relative to an arbitraty directory other than cwd (hence cwd_prefix for now).
pub inline fn relative_path(allocator: std.mem.Allocator, comptime pattern: []const u8, args: anytype) ![]u8 {
    const path = try fmt.format(allocator, pattern, args);
    defer allocator.free(path);

    return std.fs.cwd().realpathAlloc(allocator, path);
}

test "should get cwd" {
    const allocator = std.testing.allocator;
    const cwd = try std.fs.cwd().realpathAlloc(allocator, ".");
    defer allocator.free(cwd);

    const cwd_from_relative_path = try relative_path(allocator, ".", .{});
    defer allocator.free(cwd_from_relative_path);

    try std.testing.expect(cmp.strEq(cwd, cwd_from_relative_path));
}

test "should get cwd plus path" {
    const allocator = std.testing.allocator;
    const cwd = try std.fs.cwd().realpathAlloc(allocator, ".");
    defer allocator.free(cwd);

    //TODO: This test will fail on linux since path seperators are based on how windows do things.
    const to_path = "test_data\\to\\my\\file.txt";
    const cwd_to_path = try std.fs.path.join(allocator, &[_][]const u8{ cwd, to_path });
    defer allocator.free(cwd_to_path);

    const cwd_with_to_path = try relative_path(allocator, to_path, .{});
    defer allocator.free(cwd_with_to_path);

    try std.testing.expect(cmp.strEq(cwd_to_path, cwd_with_to_path));
}

test "should get path with fmt" {
    const allocator = std.testing.allocator;
    const cwd = try std.fs.cwd().realpathAlloc(allocator, ".");
    defer allocator.free(cwd);

    //TODO: This test will fail on linux since path seperators are based on how windows do things.
    const to_path_args = .{ "test_data", "file" };
    const to_path = "{s}\\to\\my\\{s}.txt";
    const to_path_fmt = try fmt.format(allocator, to_path, to_path_args);
    defer allocator.free(to_path_fmt);

    //TODO: Oh man, "&[_][]const u8 {...}" is so ugly, can we make this a part of ziggy to do properly?
    const cwd_to_path = try std.fs.path.join(allocator, &[_][]const u8{ cwd, to_path_fmt});
    defer allocator.free(cwd_to_path);

    const cwd_with_to_path = try relative_path(allocator, to_path, to_path_args);
    defer allocator.free(cwd_with_to_path);

    try std.testing.expect(cmp.strEq(cwd_to_path, cwd_with_to_path));
}