#@load "json"
@load "rwarray"
@include "../utils.awk"
@include "../color.awk"
@include "../utils.awk"
BEGIN {
    FS=","
    OFS=","
    SUBSEP=","
}
{
    data[$1,$2,$3,$4]= NR
}
END {


    group = 0
    while(1){
        if(length(data) == 0 ) break
        group++
        for(n in data) break
        grouping[group][n] = group
        delete data[n]

        flag = 1
        while(flag == 1){
            flag = 0
            for(i in data){
                for(j in grouping[group]){
                    if(manhattan(i,j) <= 3){
                        grouping[group][i] = group
                        delete data[i]
                        flag = 1
                    }
                }
            }
        }



    }

    #printa(grouping)
    print group
    print "exit"
}
function manhattan(pos,pos1, arr,arr1, temp){
    split(pos,arr,SUBSEP)
    split(pos1,arr1,SUBSEP)
    temp = abs(arr1[1]-arr[1]) + abs(arr1[2]-arr[2]) + abs(arr1[3]-arr[3]) + abs(arr1[4]-arr[4])
    return temp
}
