//Import all our wonderful modules.
pub const fs = @import("modules/ziggy.fs.zig");
pub const str = @import("modules/ziggy.str.zig");

//Find all the tests inside other packages.
//TODO: Can we use 'refAllDeclsRecursive' instead? so all the submodules don't need to do this to run their tests.
//NOTE: A module/file needs to have atleast one public decl for the tests to run!
test {
    @import("std").testing.refAllDecls(@This());
}