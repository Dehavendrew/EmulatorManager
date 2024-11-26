MAX_TERMINALS=20
NUM_TERMINALS=1
SESSION=emulator_manager
USER=root
PASSWORD=root



while getopts "n:" flag;do
    if [ $flag == "n" ]; then
        NUM_TERMINALS=$OPTARG
    fi
done

if [ $NUM_TERMINALS -gt $MAX_TERMINALS ]; then
    echo "MAX Terminals exeeceded, clipping to $MAX_TERMINALS";
    NUM_TERMINALS=$MAX_TERMINALS;
fi

ARG1=${@:$OPTIND:1}

for ((i=0; i < NUM_TERMINALS ; i++)) ; do
    tmux send-keys -t $i "sudo chmod 777 /etc/network/interfaces" ENTER
    tmux send-keys -t $i "sudo ifdown ens4" ENTER
    tmux send-keys -t $i "echo source-directory /etc/network/interfaces.d > /etc/network/interfaces" ENTER
done
