#@load "json"
#@load "rwarray"
@include "../utils.awk"

BEGIN {
}
BEGINFILE{
    delete data
    delete rules
    print "FILE"
}

FNR == 1 {
    split($3,data,"")
}
FNR >2 && $0 {
    rules[$1]=$3
	
}
BEGIN {
    split("...##...##...##...##...##...##...##...##...##...##...##...##...##...##...##...##...##...##...##...##...##...##...##...##...##...##.",data,"")
    for(i in data){
        data[i+ 50000000000 - 1 - 30] = data[i]
        delete data[i]
    }
    printa(data)
    printf "%15d", score(data)
    print ""


    delete data
    delete data_i
}
ENDFILE {

    if (FNR != NR){
    len = length(data)
    print len
    for(i=0;i<len;i++){
        data[i]=data[i+1]
    }
    delete data[len]
    print length(data)
    #iter = 20
    iter = 50000000000
    #printf "   0    0 "
    #print_row(data)

    for(i=1;i<=iter;i++){
        on_iter = i
        run(data)
        if (i % 1000 == 0 ) {
            asorti(data,data_i,"@ind_num_asc")
            printf "%5d %15d %15d ",data_i[1], i, score(data)
            print_row(data)
        }
        #exit
    }
    printf "%5d %15d %15d ",data_i[1], i-1, score(data)
    print_row(data)
}
    
}
function score(data, i, s){
    s = 0
    for(i in data){
        if(data[i]=="#"){
            s+=i
        }
    }
    return s
}
function run(data, i, data_new, len){
    delete data_new
    asorti(data,data_i,"@ind_num_asc")
    len = length(data)

    if(data[data_i[1]] == "#"){
        data[data_i[1]-1]="."
        data[data_i[1]-2]="."
    } else if(data[data_i[2]] == "#"){
        data[data_i[1]-1]="."
    } else if (data[data_i[3]] == "."){
        delete data[data_i[1]]
    }
    if(data[data_i[len]] == "#"){
       print "hi"
       data[data_i[len] + 1]="."
       data[data_i[len] + 2]="."
    } else if(data[data_i[len-1]] == "#"){
       data[data_i[len]+1]="."
   } else if (data[data_i[len-2]] == "."){
        delete data[data_i[len]]
    }


    len = length(data)
    copy_array(data_new,data,data_i[1],len)

    for(i in data){
        temp = ""
        for(j=-2;j<=2;j++){
            if (i+j in data) {
                temp = temp data[i+j]
            } else {
                temp = temp "."
            }
        }
        if(temp in rules){
            #print temp " -> " rules[temp]
            data_new[i] = rules[temp]
        } else {
            data_new[i] = data[i]
        }
    }
    len = length(data_new)

    fail = 0
    for(j in data){
        if((j+1) in data_new && data[j] != data_new[j+1]){
            fail = 1
            break
        }

    }
    if(fail == 0) {
        print_row(data)
        print_row(data_new)
        print on_iter
        exit
    }
    asorti(data_new,data_i,"@ind_num_asc")
    copy_array(data,data_new,data_i[1],len)
    
}


function print_row(data, i ,xmin, xmax, data_i){
    asorti(data,data_i,"@ind_num_asc")
    xmin = data_i[1]
    xmax = data_i[length(data_i)]
    for(i in data){
        printf "%s", data[i]
    }
    print ""
}
