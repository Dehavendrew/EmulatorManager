MAX_TERMINALS=20
TERMINAL_ID=1
LINES=10
SESSION=emulator_manager

while getopts "t:n:" flag;do
    if [ $flag == "t" ]; then
        TERMINAL_ID=$OPTARG
    fi
    if [ $flag == "n" ]; then
        LINES=$OPTARG
    fi
done

ARG1=${@:$OPTIND:1}
start=$EPOCHSECONDS

if [ $(tmux capture-pane -pt $TERMINAL_ID -S -10 | tail -n "$LINES" | grep -c "$ARG1") == 0 ]; then
   exit 0
else
   exit 1
fi
