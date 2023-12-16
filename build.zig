const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const ziggy_module_options = .{
        .source_file = .{ .path = "ziggy.zig" }
    };

    _ = b.addModule("ziggy", ziggy_module_options);

    const tests = b.addTest(.{
        .root_source_file = .{ .path = "ziggy.zig"},
        .target = target,
        .optimize = optimize
    });

    const tests_artifact = b.addRunArtifact(tests);
    const tests_run_step = b.step("tests", "Run unit tests");
    tests_run_step.dependOn(&tests_artifact.step);
}