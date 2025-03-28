## > Linux Terminal UI Library
A basic library for creating user interfaces in the Linux terminal.

### Code
```
GET_TERM_SIZE () { read ROWS COLS < <(stty size); }
O_DPY         () { printf "\033[?1049h"; } # non-VT100 sequence (refer to ch. 5.36)
RE_DPY        () { printf "\033[?1049l"; }  # non-VT100 sequence (refer to ch. 5.36)
DECTCEM_T     () { printf "\033[?25h"; }
DECTCEM_F     () { printf "\033[?25l"; }
DECAWM_T      () { printf "\033[?7h"; }
DECAWM_F      () { printf "\033[?7l"; }
CUP_R         () { printf "\033[H"; }
CUP           () { local Y=$1; local X=$2; printf "\033[${Y};${X}H"; }
CUU           () { printf "\033[A"; }
CUU_X         () { local V=$1; printf "\033[${V}A"; }
CUD           () { printf "\033[B"; }
CUD_X         () { local V=$1; printf "\033[${V}B"; }
CUL           () { printf "\033[D"; }
CUL_X         () { local V=$1; printf "\033[${V}D"; }
CUR           () { printf "\033[C"; }
CUR_X         () { local V=$1; printf "\033[${V}C"; }
ED            () { printf "\033[2J"; }
ED_CUP        () { local Y=$1; local X=$2; printf "\033[2J\033[${Y};${X}H"; }
PRINT         () { CUP $1 $2; printf $3; SEL=$1; }
CLEANUP       () { ED && DECTCEM_T && DECAWM_T && CUP_R; kill -9 $$; }
```
*All function and variable naming conventions are based on the VT510 reference manual provided by VT100.net*

### Functions
- **GET_TERM_SIZE:** Gets the terminal size and sets the variables $ROWS and $COLS accordingly.
- **O_DPY:** Saves the terminal screen.
- **RE_DPY:** Restores the terminal screen.
- **DECTCEM_T:** Makes the text cursor visible.
- **DECTCEM_F:** Makes the text cursor invisible.
- **DECAWM_T:** Enables autowrap mode.
- **DECAWM_F:** Disables autowrap mode.
- **CUP_R:** Resets the cursor position.
- **CUP:** Places cursor at position $Y and $X.
- **CUU:** Moves cursor up by default increment.
- **CUU_X:** Moves cursor up by specific increment.
- **CUD:** Moves cursor down by default increment.
- **CUD_X:** Moves cursor down by specific increment.
- **CUL:** Moves cursor left by default increment.
- **CUL_X:** Moves cursor left by specific increment.
- **CUR:** Moves cursor right by default increment.
- **CUR_X:** Moves cursor right by specific increment.
- **ED:** Erases the terminal screen *(display)*.
- **ED_CUP:** Erases the terminal screen and places cursor at position $Y and $X.
- **PRINT:** Outputs the following string at specified position.
- **CLEANUP:** Cleans up artifacts for regular terminal usage after program exit.

### Notes
* Usage of `printf` over `echo -en` for compatibility.
* `O_DPY` and `RE_DPY` are non-VT100 sequences.

# Examples
### Option Selection
```
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
```

### Box Drawing
```
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
```

### Resources
- https://vt100.net/docs/vt510-rm/contents.html
- https://github.com/dylanaraps/writing-a-tui-in-bash
- https://unix.stackexchange.com/questions/288962/what-does-1049h-and-1h-ansi-escape-sequences-do
- https://www.shellscript.sh/