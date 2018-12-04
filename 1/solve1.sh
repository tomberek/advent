cat data | awk '{ sum+= $1 ; print $1 "\t" sum } END {print "sum=",sum}' 

