#!/usr/bin/env python

import sys, re

filename = sys.argv[1]

f = open(filename)
contents = f.read()
f.close()


results = re.findall('Real Time \(s\) = ([\d\.]+)', contents)
speedup = [str(float(results[0])/float(x)) for x in results]


#results = [float(x) for x in results]
print(",".join(results) + ",," + ",".join(speedup) )




