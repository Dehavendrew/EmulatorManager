#!/bin/bash

PANES=$(tmux list-panes | wc -l)

for ((i=0; i < PANES ; i++)) ; do
    tmux send-keys -t $i "clear" ENTER
    tmux send-keys -t $i "clear" ENTER
    tmux send-keys -t $i "clear" ENTER
done