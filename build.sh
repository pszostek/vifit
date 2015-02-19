#!/usr/bin/env bash
for i in 'avx2','-mavx2' "avx","-mavx" "noVec","-fno-tree-vectorize" "sse","-msse4.2"; do
	OLDIFS="$IFS"
	IFS=","
	set ${i}
	iset=$1
	flag=$2
	echo $flag $iset
	IFS=$OLDIFS
	#cd ParallelPdf_${iset} && make clean && ARCHFLAGS="$flag" make ; cd ..
	cd ParallelPdf_${iset} && ARCHFLAGS="$flag" make ; cd ..
done
		
