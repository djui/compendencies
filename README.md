# Compendencies

The compilation dependencies module/app lists file needed during
compile time by the Erlang compiler. These files are usually included
using the `-include()` and `-include_lib()` preprocessor flags.

The module you want to analyze needs to be compiled with the
`debug_info` flag.

Note: Currently not all returned paths are absolute paths.

# Usage

To analyse loaded modules for dependant include files, the following
examples shows the dependencies for the Erlang `code` module:

    $ erl -pa ebin
    :
    :
    1> compendencies:go(code).
    ["./code.erl",
     "/Users/dev/OTP/src/otp_r14b01/bootstrap/lib/kernel/include/file.hrl"]

You can also directly use the beam file as parameter:

    $ erl -pa ebin
    :
    :
    1> compendencies:go("./ebin/compendencies.beam").
    ["src/compendencies.erl"]
