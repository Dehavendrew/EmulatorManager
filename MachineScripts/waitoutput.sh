MAX_TERMINALS=20
TERMINAL_ID=1
TIMEOUT_SEC=60
SESSION=emulator_manager
LINES=2

while getopts "t:o:n:" flag;do
    if [ $flag == "t" ]; then
        TERMINAL_ID=$OPTARG
    fi
    if [ $flag == "o" ]; then
	    TIMEOUT_SEC=$OPTARG
    fi
    if [ $flag == "n" ]; then
        LINES=$OPTARG
    fi
done

ARG1=${@:$OPTIND:1}
start=$EPOCHSECONDS

while [ $(tmux capture-pane -pt $TERMINAL_ID -S -10 | tail -n "$LINES" | grep -c "$ARG1") == 0 ]; do
   sleep 0.5
   #echo $(tmux capture-pane -pt $TERMINAL_ID -S -10 | tail -n "$LINES" | grep "whoami" )
   if(( EPOCHSECONDS-start > TIMEOUT_SEC )); then exit 1; fi
done
