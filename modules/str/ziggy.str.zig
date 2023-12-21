//TODO: Introduce a "string" type that basically is []u8 or []const u8

//Comparison of string.
const cmp = @import("ziggy.str-cmp.zig");
pub const equals = cmp.equals;
pub const has_text = cmp.has_text;

//Formatting of string.
const fmt = @import("ziggy.str-fmt.zig");
pub const format = fmt.format;
pub const remove = fmt.remove;

//Find all the tests inside other packages.
test {
    _ = cmp;
    _ = fmt;
}
