echo 'opt,COD,turbo,a,c,p' > results.csv
echo $1'2,1,0,'$(taskset -c 0-55 ./main_XEON -n 768000 -b 512 -i -150 -c -a 2) >> results.csv
echo $1'2,0,1,'$(taskset -c 0-55 ./main_XEON -n 768000 -b 512 -i -150 -p -a 2) >> results.csv
echo $1'4,1,0,'$(taskset -c 0-55 ./main_XEON -n 768000 -b 512 -i -150 -c -a 4) >> results.csv
echo $1'4,0,1,'$(taskset -c 0-55 ./main_XEON -n 768000 -b 512 -i -150 -p -a 4) >> results.csv

