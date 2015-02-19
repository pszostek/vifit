#!/usr/bin/env bash

ARCH=auto

if [ "x$BENCH_ROOT" = "x" ]; then
    echo "Benchmarking root script was not sourced!"
    exit 1
fi

if [ "x$ARCH" = "x" ]; then
	echo "Architecture name not set!"
	exit 1
fi

CMD="./main_XEON -n 768000 -b 512 -i -150 -c -a 2"
nodes=$(numactl -H | grep nodes | awk '{print $2}')
if [ $nodes -eq 4 ]; then
	cod=1
else
	cod=0
fi
echo cod=$cod


function header() {
	echo 'opt,COD,turbo,a,c,p'
}
function vincenzo_conf() {
	echo $1'2,1,0,'$(taskset -c 0-55 ./main_XEON -n 768000 -b 512 -i -150 -c -a 2)
	echo $1'2,0,1,'$(taskset -c 0-55 ./main_XEON -n 768000 -b 512 -i -150 -p -a 2)
	echo $1'4,1,0,'$(taskset -c 0-55 ./main_XEON -n 768000 -b 512 -i -150 -c -a 4)
	echo $1'4,0,1,'$(taskset -c 0-55 ./main_XEON -n 768000 -b 512 -i -150 -p -a 4)
}


export GOMP_CPU_AFFINITY='0-55'
for iset in "avx2" "avx" "noVec" "sse"; do
	echo ${iset}
	echo turbo on
	$BENCH_ROOT/tools/enable_turbo >/dev/null || exit 1
	rm ParallelPdf_${iset}/vifit_${iset}.csv
	(cd ParallelPdf_${iset} && vincenzo_conf "${iset},${cod},1," >> vifit_${iset}.csv && cd .. )||\
	exit 1

	echo turbo off
	$BENCH_ROOT/tools/disable_turbo >/dev/null || exit 1
	(cd ParallelPdf_${iset} && vincenzo_conf "${iset},${cod},0," >> vifit_${iset}.csv && cd .. )||\
	exit 1
done

if [ cod -eq 1 ]; then
	result_file="results_cod_on.csv"
else
	result_file="results_cod_off.csv"
fi
rm $results_file
header > $results_file
for file in $(find -name vifit_\* ); do cat $file >> $results_file; done	
