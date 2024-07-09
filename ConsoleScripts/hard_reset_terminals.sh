#!/bin/bash

MAX_TERMINALS=20
NUM_TERMINALS=1
SESSION=emulator_manager
PANES=$(tmux list-panes | wc -l)
IMAGE_PATH=/home/drew/EmulatorMachine/Images
BASE_IMAGE=Phoenix
GOLDEN_PATH=/home/drew/EmulatorMachine/Images/GoldenCopies

while getopts ":n:" flag;do
    if [ $flag == "n" ]; then
        NUM_TERMINALS=$OPTARG
    fi
done

if [ $NUM_TERMINALS -gt $MAX_TERMINALS ]; then
    echo "MAX Terminals exeeceded, clipping to $MAX_TERMINALS";
    NUM_TERMINALS=$MAX_TERMINALS;
fi

for ((i=0; i < NUM_TERMINALS ; i++)) ; do
    sleep 0.05
    tmux send-keys -t $i "echo $i" ENTER
done

for ((i=0; i < NUM_TERMINALS ; i++)) ; do
    sleep 0.05
    tmux send-keys -t $i "clear" ENTER
done

for ((i=0; i < NUM_TERMINALS ; i++)) ; do
    sleep 0.05
    tmux send-keys -t $i "rm -rf $IMAGE_PATH/$BASE_IMAGE" "_$i" ENTER
    tmux send-keys -t $i "mkdir $IMAGE_PATH/$BASE_IMAGE" "_$i" ENTER
    tmux send-keys -t $i "cd $IMAGE_PATH/$BASE_IMAGE" "_$i" ENTER
    tmux send-keys -t $i "cp -R $GOLDEN_PATH/$BASE_IMAGE ." ENTER
    tmux send-keys -t $i "cd $BASE_IMAGE" ENTER
    tmux send-keys -t $i "./run.sh" ENTER
done