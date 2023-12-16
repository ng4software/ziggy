const std = @import("std");

pub fn build(b: *std.build.Builder) void {

    // CreateModuleOptions from std:
    // pub const CreateModuleOptions = struct {
    //     source_file: LazyPath,
    //     dependencies: []const ModuleDependency = &.{},
    // };

    //LazyPath from std:
    // pub const LazyPath = union(enum) {
    //      path: []co`nst u8,
    //      generated: *const GeneratedFile,
    //      cwd_relative: []const u8,
    //      dependency: struct {
    //          dependency: *Dependency,
    //          sub_path: []const u8,
    //      },
    // }
    const ziggy_module_options = .{
        .source_file = .{ .path = "ziggy.zig" }
    };

    // addModule from std:
    // pub fn addModule(b: *Build, name: []const u8, options: CreateModuleOptions) *Module 
    _ = b.addModule("ziggy", ziggy_module_options);

    //TODO: Add test steps.
}