#!/bin/bash

bash ./clear_terminals.sh

PANES=$(tmux list-panes | wc -l)

for ((i=0; i < PANES ; i++)) ; do
    sleep 0.05
    tmux send-keys -t $i "echo $i" ENTER
done

for ((i=0; i < PANES ; i++)) ; do
    sleep 0.05
    tmux send-keys -t $i "clear" ENTER
done