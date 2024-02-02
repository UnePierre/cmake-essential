# assert(<test> [...])
#
# Output a SEND_ERROR message, iff the test fails, including the test and all other arguments.
#
macro(assert test)
if(NOT ${test})
    string(JOIN " " arguments ${ARGV})
    message(SEND_ERROR "Assertion failed: ${arguments}")
endif()
endmacro()
