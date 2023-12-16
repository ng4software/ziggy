pub const cmp = @import("modules/ziggy.cmp.zig");
pub const fmt = @import("modules/ziggy.fmt.zig");
pub const fs = @import("modules/ziggy.fs.zig");

test {
    @import("std").testing.refAllDecls(@This());
}