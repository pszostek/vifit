#!/usr/bin/env bash

function isCod() {
    pushd $TOOLS
    if [ $(python -c "import cpuTopology as c; print c.isCodOn()") == "True" ]; then
        popd
        return 1
    else
        popd
        return 0
    fi
}


function header() {
	echo 'opt,COD,turbo,a,c,p'
}


function vincenzo_conf() {
	echo $1'2,1,0,'$(taskset -c 0-55 ./main_XEON -n 768000 -b 512 -i -150 -c -a 2)
	echo $1'2,0,1,'$(taskset -c 0-55 ./main_XEON -n 768000 -b 512 -i -150 -p -a 2)
	echo $1'4,1,0,'$(taskset -c 0-55 ./main_XEON -n 768000 -b 512 -i -150 -c -a 4)
	echo $1'4,0,1,'$(taskset -c 0-55 ./main_XEON -n 768000 -b 512 -i -150 -p -a 4)
}


CMD="./main_XEON -n 768000 -b 512 -i -150 -c -a 2"
export GOMP_CPU_AFFINITY="0-$(($(cat /proc/cpuinfo  | grep processor | wc -l)-1))"

if [ -d ../tools ]; then
    export TOOLS=../tools
elif [ -d ../../tools ]; then
    export TOOLS=../../tools
fi

isCod
if [ $? -eq 1 ]; then
	results_file="results_cod_on.csv"
    cod=1
else
	results_file="results_cod_off.csv"
    cod=0
fi

rm $results_file

for iset in "avx2" "avx" "noVec" "sse"; do
	echo ${iset}
	echo turbo on
	$TOOLS/enable_turbo >/dev/null || exit 1
	rm ParallelPdf_${iset}/vifit_${iset}.csv
	(cd ParallelPdf_${iset} && vincenzo_conf "${iset},${cod},1," >> vifit_${iset}.csv && cd .. )||\
	exit 1

	echo turbo off
	$TOOLS/disable_turbo >/dev/null || exit 1
	(cd ParallelPdf_${iset} && vincenzo_conf "${iset},${cod},0," >> vifit_${iset}.csv && cd .. )||\
	exit 1
done

header > $results_file
for file in $(find -name vifit_\* ); do
    cat $file >> $results_file;
done	
