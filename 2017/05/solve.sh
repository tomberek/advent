@include "../utils.awk"
BEGIN {
}
{
    data[NR-1] = $1
    print NR-1 " " $1
}
END {
    cur = 0
    while(cur in data){
        #print cur " " data[cur]
        temp = data[cur]
        if(temp>=3){
            data[cur]--
        } else {
            data[cur]++
        }
        cur+=temp
        rounds++
    }
    print rounds
}
