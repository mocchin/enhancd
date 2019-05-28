#!/bin/bash

__enhancd::utils::available()
{
    __enhancd::core::get_filter_command "$ENHANCD_FILTER" &>/dev/null &&
        [[ -s $ENHANCD_DIR/enhancd.log ]]
}

# __enhancd::utils::grep prints in regular expression
__enhancd::utils::grep()
{
    if [[ -n $1 ]] && [[ -f $1 ]]; then
        cat "$1"
        shift
    else
        cat <&0
    fi \
        | command grep -E "$@" 2>/dev/null
}

# __enhancd::utils::sed replaces 1st arg with 2nd arg
# Use blank char instead if no argument is given
__enhancd::utils::sed()
{
    local g='' sep='!'

    while (( $# > 0 ))
    do
        case "$1" in
            -g)
                g='g'
                shift
                ;;
            -d)
                sep="${2:?}"
                shift
                shift
                ;;
            -* | --*)
                shift
                ;;
            *)
                break
                ;;
        esac
    done

    cat <&0 \
        | command sed -E "s$sep$1$sep$2$sep$g" 2>/dev/null
}

# __enhancd::utils::has returns true if $1 exists in the PATH environment variable
__enhancd::utils::has()
{
    if [[ -z $1 ]]; then
        return 1
    fi

    type "$1" >/dev/null 2>&1
    return $?
}

# __enhancd::utils::nl reads lines from the named file or the standard input
# if the file argument is ommitted, applies a configurable line numbering filter operation
# and writes the result to the standard output
__enhancd::utils::nl()
{
    # d in awk's argument is a delimiter
    $ENHANCD_AWK -v d="${1:-": "}" '
    BEGIN {
        i = 1
    }
    {
        print i d $0
        i++
    }' 2>/dev/null
}

# __enhancd::utils::awk returns gawk if found, else awk
__enhancd::utils::awk()
{
    type gawk &>/dev/null && echo "gawk" || echo "awk"
}
