const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("ziggy", . {
        .source_file = . { .path = "lib/ziggy.zig"}
    });

    const lib = b.addStaticLibrary(.{
        .name = "ziggy",
        .root_source_file = .{ .path = "lib/ziggy.zig" },
        .target = target,
        .optimize = optimize,
    });

     b.installArtifact(lib);

    const ziggyTests = b.addTest(.{
        .root_source_file = . { .path = "lib/ziggy.zig"},
        .target = target,
        .optimize = optimize
    });

    const ziggyTestsRun = b.addRunArtifact(ziggyTests);

    const ziggyTestStep = b.step("test", "Run tests inside the ziggy package.");
    ziggyTestStep.dependOn(&ziggyTestsRun.step);
}