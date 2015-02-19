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

export GOMP_CPU_AFFINITY='0-55'
for iset in "avx2" "avx" "noVec" "sse"; do
	$BENCH_ROOT/tools/enable_turbo || exit 1
	(cd ParallelPdf_${iset} && taskset -c '0-55' $CMD > ./vifit_${iset}_turboon && cd .. )||\
	exit 1

	$BENCH_ROOT/tools/disable_turbo || exit 1
	(cd ParallelPdf_${iset} && taskset -c '0-55' $CMD > ./vifit_${iset}_turbooff && cd .. )||\
	exit 1
done
		
