@include "../utils.awk"
BEGIN {
    max = 0
}
{
    reg[NR]=$1
    if($2 == "inc")
        mod[NR]=1
    else
        mod[NR]=-1
    amt[NR]=$3
    delte $1
    $1=""
    $2=""
    $3=""
    
    $0=ltrim($0)
    print $0
    cond_reg[NR]=$2
    cond[NR]=$3
    value[NR]=$4

    if((cond_reg[NR] in data) == 0) data[cond_reg[NR]] = 0
    switch(cond[NR]){
    case ">":
        if(data[cond_reg[NR]] > value[NR])
            data[reg[NR]] += amt[NR] * mod[NR] 
        break
    case "<":
        if(data[cond_reg[NR]] < value[NR])
            data[reg[NR]] += amt[NR] * mod[NR] 
        break
    case ">=":
        if(data[cond_reg[NR]] >= value[NR])
            data[reg[NR]] += amt[NR] * mod[NR] 
        break
    case "<=":
        if(data[cond_reg[NR]] <= value[NR])
            data[reg[NR]] += amt[NR] * mod[NR] 
        break
    case "==":
        if(data[cond_reg[NR]] == value[NR])
            data[reg[NR]] += amt[NR] * mod[NR] 
        break
    case "!=":
        if(data[cond_reg[NR]] != value[NR])
            data[reg[NR]] += amt[NR] * mod[NR] 
        break
    default:
        print "error"
        exit
    }
    if(data[cond_reg[NR]] > max) max = data[cond_reg[NR]]
}
END {
    printa(data)
    asort(data,data_s,"@val_num_desc")
    print data_s[1]
    print max
}
