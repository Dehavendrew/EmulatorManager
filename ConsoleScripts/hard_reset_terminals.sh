#!/bin/bash

MAX_TERMINALS=20
NUM_TERMINALS=1
OFFSET=0
SESSION=emulator_manager
PANES=$(tmux list-panes | wc -l)
IMAGE_PATH=/home/drew/EmulatorMachine/Images
BASE_IMAGE=Phoenix
BASE_NAME=Phoenix
GOLDEN_PATH=/home/drew/EmulatorMachine/Images/GoldenCopies

while getopts ":n:o:b:i:" flag;do
    if [ $flag == "n" ]; then
        NUM_TERMINALS=$OPTARG
    fi
    if [ $flag == "o" ]; then
        OFFSET=$OPTARG
    fi
    if [ $flag == "i" ]; then
        BASE_IMAGE=$OPTARG
    fi
    if [ $flag == "b" ]; then
        BASE_NAME=$OPTARG
    fi
done

END_IDX=$(($OFFSET + $NUM_TERMINALS))

if [ $NUM_TERMINALS -gt $MAX_TERMINALS ]; then
    echo "MAX Terminals exeeceded, clipping to $MAX_TERMINALS";
    NUM_TERMINALS=$MAX_TERMINALS;
fi

for ((i=OFFSET; i < END_IDX ; i++)) ; do
    sleep 0.05
    tmux send-keys -t $i "echo $i" ENTER
done

for ((i=OFFSET; i < END_IDX ; i++)) ; do
    sleep 0.05
    tmux send-keys -t $i "clear" ENTER
done

for ((i=OFFSET; i < END_IDX ; i++)) ; do
    sleep 0.05
    if [ $NUM_TERMINALS -gt 1 ]; then
        tmux send-keys -t $i "rm -rf $IMAGE_PATH/$BASE_NAME" "_$i" ENTER
        tmux send-keys -t $i "mkdir $IMAGE_PATH/$BASE_NAME" "_$i" ENTER
        tmux send-keys -t $i "cd $IMAGE_PATH/$BASE_NAME" "_$i" ENTER
    else
        tmux send-keys -t $i "rm -rf $IMAGE_PATH/$BASE_NAME" ENTER
        tmux send-keys -t $i "mkdir $IMAGE_PATH/$BASE_NAME" ENTER
        tmux send-keys -t $i "cd $IMAGE_PATH/$BASE_NAME" ENTER
    fi
    tmux send-keys -t $i "cp -R $GOLDEN_PATH/$BASE_IMAGE ." ENTER
    tmux send-keys -t $i "cd $BASE_IMAGE" ENTER
    tmux send-keys -t $i "echo 'EMULATOR SETUP DONE' $((4+1))" ENTER
done