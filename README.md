# Ziggy

A personally biased utility library.  
This is intended for personal use, but you're free to use it (preferably fork it).  
Don't expect a stable api, no breaking changes, support nor continuity.  

Issues and merge requests are welcome.  
For motives other than it not being the idiomatic way to use zig.

### Conventions
- Modules can be abbriviated (fs = file system, fmt = format etc.) for the sake of brevity for the end user (i.e. ziggy.fileSystem is not pleasant to write everytime).
- Function names should fully expand their name, avoiding things like "fmt" or "eq", to show the end user what the intent is.
- Function names should not double up from their module, for example a function inside "fs" should prefer names like "open_file" and not "filesystem_open_file" or "fs_open_file". One exception would be if it nullifies the function name (i.e. a function "format" inside ziggy.fmt module).
- If a function does not specify an operand, it's a get operation. For instance "from_cwd(...)" essentially means "from_cwd(...)". but ziggy.str.equals(..) implies the operand is comparing and thus does not "get" anything.
- Tests must include the function it's testing, to easily scan which test is failing.
- Tests names should describe the intent of the test well.
- Tests must be grouped _under_ the function definition.

### Areas of improvement
- We've been completely oblivious to error handling, explore this area and how this would fit into the library and where we want to handle such (inside the library, or let the end user deal with it?).
- Every function passes an allocator, can we make this more convient and partly do this within the library instead of the user (how do we avoid having multiple flavours of achieving essentially the same thing?)
- Performance testing, is what we doing performant compared to std.
- Consistency and conforming to zig's style guidelines, which at the time of writing are not too familiar with.
- Double check user-facing elements such as docs, make sure they conform to our conventions (i.e. using cwd in doc strings when a function name would be fully expanded).
- Automatic releases via github actions.
- Deduplicate tests, often it shared a lot of functionality, we just copy and paste it atm.
- Better way to expose classes in submodules, so we don't have to manually add 'pub const X = module.X'.
- Documentation for code, what the parameters do etc.