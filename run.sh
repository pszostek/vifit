#!/usr/bin/env bash

CMD="./main_XEON -n 768000 -b 512 -i -150 -c -a 2"
TOOLS="../../tools"

export GOMP_CPU_AFFINITY='0-55'
for iset in "avx2" "avx" "noVec" "sse"; do
	$TOOLS/enable_turbo || exit 1
	(cd ParallelPdf_${iset} && taskset -c '0-55' $CMD > ./vifit_${iset}_turboon && cd .. )||\
	exit 1

	$TOOLS/disable_turbo || exit 1
	(cd ParallelPdf_${iset} && taskset -c '0-55' $CMD > ./vifit_${iset}_turbooff && cd .. )||\
	exit 1
done
		
