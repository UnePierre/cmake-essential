include_guard(GLOBAL)
include("${CMAKE_CURRENT_LIST_DIR}/ParseArguments.cmake")

# `resolve_hostname()`
#
# See: https://unix.stackexchange.com/a/20793
#
function(resolve_hostname variable_name)
    parse_arguments(1 "" "" "HOSTNAME;RESULT")

    if(NOT HOSTNAME)
        set(HOSTNAME "${variable_name}")
    endif()

    execute_process(
        COMMAND dig +short ${HOSTNAME}
        OUTPUT_STRIP_TRAILING_WHITESPACE
        RESULT_VARIABLE ok
        OUTPUT_VARIABLE output
        ERROR_VARIABLE error)
    if(ok EQUAL 0)
        string(REGEX REPLACE ".*\n" "" output "${output}") # only last line in case there are aliases and/or multiple IPv4/IPv6
        set(${variable_name} "${output}" PARENT_SCOPE)
        message(TRACE "resolve_hostname(); ${HOSTNAME} --> ${output}")
        if(RESULT)
            set(${RESULT} "true" PARENT_SCOPE)
        endif()
    else()
        if(RESULT)
            message(TRACE "resolve_hostname(): 'dig +short ${HOSTNAME}' unsuccessful! (${error})")
            set(${RESULT} "false" PARENT_SCOPE)
        else()
            message(FATAL_ERROR "resolve_hostname(): 'dig +short ${HOSTNAME}' unsuccessful! (${error})")
        endif()
    endif()

endfunction()
