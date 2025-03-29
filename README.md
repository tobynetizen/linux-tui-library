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

### Resources
- https://vt100.net/docs/vt510-rm/contents.html
- https://github.com/dylanaraps/writing-a-tui-in-bash
- https://unix.stackexchange.com/questions/288962/what-does-1049h-and-1h-ansi-escape-sequences-do
- https://www.shellscript.sh/