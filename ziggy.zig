//! Root file of Ziggy, here is where we reference our wonderful modules.

//File system operations.
pub const fs = @import("modules/fs/ziggy.fs.zig");

//String manipulation.
pub const str = @import("modules/str/ziggy.str.zig");

//Buffer iteration tools.
pub const iter = @import("modules/iter/ziggy.iter.zig");

//File path utility.
pub const path = @import("modules/path/ziggy.path.zig");

test {
    _ = fs;
    _ = str;
    _ = iter;
    _ = path;
}
