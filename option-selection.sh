#!/bin/bash

# ---------------------
#    Signal Trapping
# ---------------------
trap 'GET_TERM_SIZE' 28
trap 'CLEANUP' 2

# ---------------------------
#    Variable Localization
# ---------------------------
ESC=$(printf "\033")
INIT () { PRINT 1 0 "\033[1mTest1\033[0m"; PRINT 2 0 "\033[0mTest2\033[0m"; PRINT 3 0 "\033[0mTest3\033[0m"; }

# ---------------------
#    Main Event Loop
# ---------------------
GET_TERM_SIZE
DECTCEM_F
DECAWM_F
ED
CUP_R
INIT

SEL=1

while :
do
    read -s -n3 KEY 2>/dev/null

    if [ "$KEY" = "$ESC[A" ]; then
        if [ $SEL -eq 1 ]; then
            continue;
        elif [ $SEL -eq 2 ]; then
            ED;
            PRINT 1 0 "\033[1mTest1\033[0m";
            PRINT 2 0 "\033[0mTest2\033[0m";
            PRINT 3 0 "\033[0mTest3\033[0m";
            SEL=1
        elif [ $SEL -eq 3 ]; then
            ED;
            PRINT 1 0 "\033[0mTest1\033[0m";
            PRINT 2 0 "\033[1mTest2\033[0m";
            PRINT 3 0 "\033[0mTest3\033[0m";
            SEL=2
        fi
    fi

    if [ "$KEY" = "$ESC[B" ]; then
        if [ $SEL -eq 1 ]; then
            ED;
            PRINT 1 0 "\033[0mTest1\033[0m";
            PRINT 2 0 "\033[1mTest2\033[0m";
            PRINT 3 0 "\033[0mTest3\033[0m";
            SEL=2
        elif [ $SEL -eq 2 ]; then
            ED;
            PRINT 1 0 "\033[0mTest1\033[0m";
            PRINT 2 0 "\033[0mTest2\033[0m";
            PRINT 3 0 "\033[1mTest3\033[0m";
            SEL=3
        elif [ $SEL -eq 3 ]; then
            continue;
        fi
    fi

    if [ "$KEY" = "" ]; then
        printf "\n $SEL \n"
        sleep 1
        CLEANUP
    fi
done