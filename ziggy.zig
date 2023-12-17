//Import all our wonderful modules.
pub const cmp = @import("modules/ziggy.cmp.zig");
pub const fmt = @import("modules/ziggy.fmt.zig");
pub const fs = @import("modules/ziggy.fs.zig");

//Find all the tests inside other packages.
test {
    @import("std").testing.refAllDecls(@This());
}