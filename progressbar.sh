#!/bin/env bash
set -e 
###################################################################
# Progressbar Format
# progressbar2.sh can display the progress bar in two differnet format  # 1- inline progress bar as showing bellow:
#       output text: [#############] ET: 3.00s
# 2- Display the progress bar on a separate line as showing bellow:
#       output text:
#       [#############] ET: 3.00s
#-----------------------------------------------------------------
# Usage:
# Use 'progressbar2.sh' from the command line
#   progressbar2 "sleep 3"
#   progressbar2 "sleep 3" "sometext"
#   progressbar2 "myscript.sh"               # progressbar on new line
#   progressbar2 "myscript.sh" "sometext"    # progressbar on the same line (inline) 

# Use 'progressbar.sh from inside your script'
#   1- source ~/path/to/progressbar2.sh
#   2- progress_bar "myfunction"
#      progress_bar "myfunction" "sometext"
# Use [printf string format] to pass format to printf e.g. [%-20s]
# progress_bar "myfunction" "[%-20s]sometext"
# progress_bar "myfunction" "[\t%15s]sometext"
# progressbar2.sh "sleep 3" "[\t\t%10s]sometext"
####################################################################
progress () {
    local s=0.25
    local f=0.25
    local TXT="${1}"
    local fmt="${2}"
    local str="#############"

    while true; do
        for i in {1..14}; do
            sleep $f 
            s=$(echo ${s} + ${f} | bc)
            printf "\r${fmt}[%-13s%s" "${TXT#*]}" "${str:0:$i}" "] ET: ${s}s" | tee ${tmpfile}
        done
    done
}
# Use progress_bar function from inside script
progress_bar() {
    # Make sure the num of args < 3 
    if [ ! -z "${3}" ]; then
        echo "progressbar2.sh: Too many arguments, usage: progress_bar \"arg1\" \"[arg2]\""
        exit 1
    fi
    main_progress "${1}" "${2}"
}
# main progressbar function
main_progress() {
    local TXT="${2}"                #optional
    local fmt=$(echo "$TXT" | sed -n 's/^\[\(%\?.[^]]*s\).*/\1/p')          #passing string format from inside shell 
    local fmt=${fmt:-%s}
    local bg_process="${1}"
    local tmpfile=$(mktemp -t progress.XXXXXXXX)

    while true; do progress "${TXT}" ${fmt}; done &
    ${bg_process} &>/dev/null || err=1 # cant use exit 1, the progressbar will not be killed if exit

    local total_time="$(sed -n 's/.*:\(.*s\)/\1/p' ${tmpfile})"
    total_time=${total_time:-" 0.00s"}
    if [ ${err:-0} -ne 1 ]; then
        printf "\r${fmt}[%-13s%s\n" "${TXT#*]}" "#############" "] ET:${total_time}"
    fi
    rm -f ${tmpfile}
    kill $!; trap 'kill $!' SIGTERM SIGINT
}
#Case of command line
if [[ "$0" == "./progressbar2.sh" && $# -gt 0 && $# -lt 3 ]]; then
    main_progress "${1}" "${2}"
elif [ "$0" == "./progressbar2.sh" ]; then
    if [ $# -eq 0 ]; then
        echo "progressbar2: missing argument"
        exit 1
    else
        echo "progressbar2.sh: Too many arguments"
        exit 1
    fi
fi
