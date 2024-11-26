TOTAL_TESTS=0
TEST_PASSED=0

NUMPLAYERS=2
BRINGDOWN=false
BRINGUP=false
RESETMACHINE=false
TESTPATH=template
FIRSTTIME=false
HOLD=false
TESTS=true
BASEPATH=/home/drew/EmulatorMachine

cd $BASEPATH

while getopts "k:u:n:f:r:h:t:" flag;do
    if [ $flag == "k" ]; then
        BRINGDOWN=$OPTARG
    fi
    if [ $flag == "u" ]; then
        BRINGUP=$OPTARG
    fi
    if [ $flag == "n" ]; then
        NUMPLAYERS=$OPTARG
    fi
    if [ $flag == "f" ]; then
        TESTPATH=$OPTARG
    fi
    if [ $flag == "r" ]; then
        RESETMACHINE=$OPTARG
    fi
    if [ $flag == "h" ]; then
        HOLD=$OPTARG
    fi
    if [ $flag == "t" ]; then
        TESTS=$OPTARG
    fi
done

if [[ -n "$TMUX" ]]; then

    ### Setup runners ###
    clear
    echo -e "\e[35mINSIDE RUNNER\e[0m"
    cd ConsoleScripts

    machine_num=0
    tail -n +2 "$TESTPATH/runnerlist.csv" | while read LINE; 
    do
        arrLine=(${LINE//,/ })
        name=${arrLine[0]} 
        machinetype=${arrLine[1]} 
        subtype=${arrLine[2]}
        hostname=${arrLine[3]}


        if [ "$machinetype" == "vm" ]; then
            if test -e "../Images/$name"; then
                if($RESETMACHINE); then
                    ./hard_reset_terminals.sh -n 1 -o "$machine_num" -b "$name" -i "$subtype"
                    ../MachineScripts/waitoutput.sh -t "$machine_num" -n 2 "EMULATOR SETUP DONE 5"
                    echo -e "Player $machine_num \e[34mHARD RESET\e[0m"
                fi
            else
                ./setup_terminals.sh -n 1 -o "$machine_num" -b "$name" -i "$subtype"
                ../MachineScripts/waitoutput.sh -t "$machine_num" -n 2 "EMULATOR SETUP DONE 5"
                FIRSTTIME=true
                echo -e "Player $machine_num \e[34mSETUP\e[0m"
            fi;
            machine_num=$((machine_num+1))
        fi

    done

    ### Start runners ###

    if($BRINGUP); then
        #Boot emulators

        machine_num=0
        tail -n +2 "$TESTPATH/runnerlist.csv" | while read LINE; 
        do
            arrLine=(${LINE//,/ })
            name=${arrLine[0]} 
            machinetype=${arrLine[1]} 
            subtype=${arrLine[2]}
            hostname=${arrLine[3]}
            ./boot_terminals.sh -n 1 -o "$machine_num" -b "$name" -i "$subtype"
            machine_num=$((machine_num+1))
        done

        cd ../MachineScripts
        #Wait until booted and login & mount
        for ((i=0; i < NUMPLAYERS ; i++))
        do
            ./waitoutput.sh -t $i "phoenix-amd64 login"
            echo -e "Player $i \e[34mBOOTED\e[0m"
        done
        ./login.sh -n $NUMPLAYERS
        sleep 0.5
        ./mount.sh -n $NUMPLAYERS
        sleep 1
    else
        cd ../MachineScripts
        ./sendncmd.sh -n $NUMPLAYERS "sudo -v"
    fi

    ### Setup the runners if required ###

    if($RESETMACHINE) || ($FIRSTTIME); then
        machine_num=0
        tail -n +2 "$TESTPATH/runnerlist.csv" | while read LINE; 
        do
            arrLine=(${LINE//,/ })
            name=${arrLine[0]} 
            machinetype=${arrLine[1]} 
            subtype=${arrLine[2]}
            hostname=${arrLine[3]}
            $TESTPATH/runners/$name/setup.sh
            machine_num=$((machine_num+1))
        done
    fi

    ### Hold if required ###
    if($HOLD); then
        /bin/bash
    fi

    ### Run Tests ###
    if($TESTS); then
        test_num=0
        passed_tests=0
        while read LINE; 
        do
            test_num=$((test_num+1))
            arrLine=(${LINE//,/ })
            name=${arrLine[0]} 
            blocking=${arrLine[1]} 
            desc=${arrLine[2]}
            $TESTPATH/tests/$name $test_num
            if [ $? == 0 ]; then
                passed_tests=$((passed_tests+1))
            else
                if($blocking); then
                    break
                fi
            fi
        done < "$TESTPATH/testlist.csv"
        echo "Passed $passed_tests/$test_num tests"
        sleep 1.3
    fi


    ### Shutdown the runner if required ###
    if($BRINGDOWN); then
        # shutdown and wait proper shutdown
        ./shutdown.sh -n $NUMPLAYERS
        for ((i=0; i < NUMPLAYERS ; i++))
        do
            ./waitoutput.sh -t $i "reboot: Power down"
            echo -e "Player $i \e[34mDOWN\e[0m"
        done
    fi


    ./sendncmd.sh -n $NUMPLAYERS "clear"
    cd ../ConsoleScripts
    ./deteact_terminals.sh
else
    cd ConsoleScripts
    if [ $(tmux list-sessions | grep -c "emulator_manager") == 0 ]; then
        ./launch_terminals_detached.sh -n "$NUMPLAYERS"
        BRINGUP=true
    fi
    ./sendcmd.sh $NUMPLAYERS "../RunnerScripts/runner.sh -u $BRINGUP -k $BRINGDOWN -f $TESTPATH -n $NUMPLAYERS -r $RESETMACHINE -h $HOLD -t $TESTS"
    ./attach_terminals.sh
    tmux capture-pane -pt $NUMPLAYERS -S -10
    if($BRINGDOWN); then
        ./kill_terminals.sh
    fi
fi
