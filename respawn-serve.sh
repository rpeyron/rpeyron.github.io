while true
do
    ./serve.sh  2>&1 | tee serve.log
	sleep 1
done