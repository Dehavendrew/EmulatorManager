#!/bin/bash

NUM_TERMINALS=1
MAX_TERMINALS=20
SESSION=emulator_manager

while getopts ":n:" flag;do
    if [ $flag == "n" ]; then
        NUM_TERMINALS=$OPTARG
    fi
done

if [ $NUM_TERMINALS -gt $MAX_TERMINALS ]; then
    echo "MAX Terminals exeeceded, clipping to $MAX_TERMINALS";
    NUM_TERMINALS=$MAX_TERMINALS;
fi

ROWS=0
COLS=0
RET=$(python3 calc_grid.py $NUM_TERMINALS)
RET=($RET)
ROWS=${RET[0]}
COLS=${RET[1]}


tmux new-session -d -s $SESSION

for ((j=0; j < COLS - 1 ; j++)) ; do
    tmux split-window -h
done

for ((j=0; j < COLS ; j++)) ; do
    tmux selectp -t $(($j * $ROWS))
    for ((i=0; i < ROWS - 1 ; i++)) ; do
        tmux split-window -v
    done
done

tmux select-layout tiled

tmux attach -t $SESSION


