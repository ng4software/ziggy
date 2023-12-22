//! This module provides utility functions to manipulating strings.
//! In Zig, this is just another a u8 slice.
//! TODO: Introduce a "string" type that basically is []u8 or []const u8

//Comparison of string.
const cmp = @import("ziggy.str-cmp.zig");
pub const equals = cmp.equals;
pub const has_text = cmp.has_text;

//Manipulating strings.
const manip = @import("ziggy.str-manip.zig");
pub const format = manip.format;
pub const remove = manip.remove;
pub const first = manip.first;
pub const last = manip.last;

//Find all the tests inside other packages.
test {
    _ = cmp;
    _ = manip;
}
