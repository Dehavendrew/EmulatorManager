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

    INDX=$(($i + 10))
    IP_ADDR="192.168.2.$INDX"
    NETMASK="255.255.255.0"
    GATEWAY="192.168.2.1"

    tmux send-keys -t $i "sudo chmod 777 /etc/network/interfaces" ENTER
    INET_PROFILE="auto ens4"
    tmux send-keys -t $i "echo $INET_PROFILE >> /etc/network/interfaces" ENTER
    INET_PROFILE="iface ens4 inet static"
    tmux send-keys -t $i "echo $INET_PROFILE >> /etc/network/interfaces" ENTER
    INET_PROFILE="address $IP_ADDR"
    tmux send-keys -t $i "echo $INET_PROFILE >> /etc/network/interfaces" ENTER
    INET_PROFILE="netmask $NETMASK"
    tmux send-keys -t $i "echo $INET_PROFILE >> /etc/network/interfaces" ENTER
    # INET_PROFILE="gateway $GATEWAY"
    # tmux send-keys -t $i "echo $INET_PROFILE >> /etc/network/interfaces" ENTER
    tmux send-keys -t $i "sudo cat /etc/network/interfaces" ENTER
    tmux send-keys -t $i "sudo ifup ens4" ENTER
done
