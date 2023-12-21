//TODO: Introduce a "string" type that basically is []u8 or []const u8

const cmp = @import("str/str-cmp.zig");
pub const equals = cmp.equals;
pub const has_text = cmp.has_text;

const fmt = @import("str/str-fmt.zig");
pub const format = fmt.format;
pub const remove = fmt.remove;

//Find all the tests inside other packages.
test {
    @import("std").testing.refAllDecls(@This());
}