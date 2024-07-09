MAX_TERMINALS=20
NUM_TERMINALS=1
SESSION=emulator_manager
USER=root
PASSWORD=root

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
    tmux send-keys -t $i "$USER" ENTER
done

sleep 0.5

for ((i=0; i < NUM_TERMINALS ; i++)) ; do
    tmux send-keys -t $i "$PASSWORD" ENTER
done