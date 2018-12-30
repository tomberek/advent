@include "../utils.awk"
BEGIN {
FS="\t"
OFS="\t"
}
{
    count = 0

    while( ($0 in seen) == 0 ){
        seen[$0] = count
        split($0,data,"\t")
        asorti(data,data_i,"@val_num_desc")

        cur = data_i[1]
        redist = $(data_i[1])
        $cur=0
        while(redist > 0){
            cur = cur % NF + 1
            $cur += 1
            redist--
        }
        count++
    }
    print count " " seen[$0] " " count " " count-seen[$0]
}
END {

    
}
