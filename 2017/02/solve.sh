@include "../utils.awk"
#@include "../bitmap.awk"
BEGIN {
    print "hi"
    FS="\t"
}
# For every line
{
    for (i=1;i<=NF-1;i++){
        for (j=i+1;j<=NF;j++){
            temp = $i/$j
            temp1 = $j/$i
            if( temp == int(temp)){
                sum += temp
            }
            if(temp1 == int(temp1)) {
                sum += temp1
            }
        }
    }
}
END {
    print sum
    print "done"
}

