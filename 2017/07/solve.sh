@include "../utils.awk"
BEGIN {
    FPAT= "([^ ,()->]+|[0-9]+)"
}
{
    weight[$1]=$2

    for(i=3;i<=NF;i++){
        data[$1][i-2]=$i
        parent[$i]=$1
    }
    kids[$i]=NF-2
}
END {
    cur = "bxlur"
    while(cur in parent){
        cur = parent[cur]
    }
    print cur
}
function calcWeights(_cur,_i,temp,seen,sum,store_cur){
    sum = 0
    delete seen
    store_cur = _cur
    print _cur
    if(_cur in data){
        for(_i in data[_cur]){
            temp = calcWeights(data[_cur][_i])
            seen[temp]=1
            sum += temp
            print temp
        }
    }
    sum += weight[store_cur]
    sums[_cur]=sum
    if(length(seen) > 1){
        print length(seen)
        printa(seen)
        printa(data[_cur])
        for(_i in data[_cur]){
            print sums[data[_cur][_i]]
            print weight[data[_cur][_i]]
        }
        print store_cur
        print "hi"
        exit
    }
    return sum
}
END {
    calcWeights("mkxke")
    print parent["deuwm"]
    sums["deuwm"]
}
