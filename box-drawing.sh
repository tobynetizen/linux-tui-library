#!/bin/bash

# ----------------
# Signal Trapping
# ----------------
trap 'GET_TERM_SIZE' 28
trap 'ED' 28
trap 'CLEANUP' 2

# -----------------------------
# Light & Heavy Box Components
# -----------------------------
L_TLC='\u250C'; L_TRC='\u2510'; L_BLC='\u2514'; L_BRC='\u2518'; # Light Corners
H_TLC='\u250F'; H_TRC='\u2513'; H_BLC='\u2517'; H_BRC='\u251B'; # Heavy Corners
L_BVR='\u251C'; L_BVL='\u2524'; L_BVD='\u252C'; L_BVU='\u2534'; # Light Borders
H_BHR='\u2523'; H_BHL='\u252B'; H_BHD='\u2533'; H_BHU='\u253B'; # Heavy Borders
L_HSL='\u2500'; L_VSL='\u2502';                                 # Light Solid Lines
H_HSL='\u2501'; H_VSL='\u2503';                                 # Heavy Solid Lines
L_CRSS='\u253C';                                                # Light Cross
H_CRSS='\u254B';                                                # Heavy Cross
L_ATL='\u256D'; L_ATR='\u256E'; L_ABL='\u2570'; L_ABR='\u256F'; # Light Arcs

# ---------------
# Initialization
# ---------------
GET_TERM_SIZE; DECTCEM_F; DECAWM_F; ED; CUP_R;
ESC=$(printf "\033");
ED;

# ----------------
# Main Event Loop
# ----------------
while :
do
    sleep 0.02;
    PRINT 1 0 "$H_TLC";
    for ((i = 2; i <= $COLS - 1; i++)); do
        PRINT 1 $i "$H_HSL";
        PRINT 3 $i "$H_HSL";
    done
    PRINT 1 $COLS "$H_TRC";
    for ((j = 2; j <= $ROWS - 1; j++)); do
        PRINT $j 1 "$H_VSL";
        PRINT $j $COLS "$H_VSL";
    done
    PRINT $ROWS 1 "$H_BLC";
    for ((k = 2; k <= $COLS - 1; k++)); do
        PRINT $ROWS $k "$H_HSL";
    done
    PRINT $ROWS $COLS "$H_BRC";
    #read -s -n3 KEY 2>/dev/null
done