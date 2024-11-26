if [ $1 -ne 0 ]; then
    echo -e "\e[31mFailed\e[0m Test $2: $3"
    exit 1
else
    echo -e "\e[32mPassed\e[0m Test $2: $3"
    exit 0
fi