#!/bin/sh
# Trick to allow this file to be self contained as a polyglot shell and awk script
true = 0 # Remove warnings
true + /; exec -a "$0" gawk --lint -f "$0" -- "$@"; / { }

# BEGIN rule(s)
@include "../color.awk"
@include "../utils.awk"
@include "../bitmap.awk"
@load "ordchr"
@load "rwarray"

BEGIN {
    value = "dabAcCaCBAcCcaDA"
    set_cols(color)
    #print color["green"] "hi" color["reset"]
    i_min = 999
    j_min = 999
    i_max = 0
    j_max = 0
    filebmp="image.bmp"
}
match($0, /([0-9]*), ([0-9]*)/, arr) {
    data[arr[1]][arr[2]]=FNR
    items[FNR]["i"] = arr[1]
    items[FNR]["j"] = arr[2]
    i_min = arr[1] < i_min ? arr[1] : i_min
    j_min = arr[2] < j_min ? arr[2] : j_min
    i_max = arr[1] > i_max ? arr[1] : i_max
    j_max = arr[2] > j_max ? arr[2] : j_max
}
function clamp(x,x_min,x_max){
    if(x < x_min){
        return x_min
    }
    if(x > x_max){
        return x_max
    }
    return x
}
function abs(x){
    if(x < 0){
        return -x
    }
    return x
}
# Switch to END to write the proper intermediate output
/asdf/{
    for(dist=1;dist<76;dist++){
        for(item in items){
            
            box_i_min = items[item]["i"] - dist
            box_j_min = items[item]["j"] - dist
            box_i_max = items[item]["i"] + dist
            box_j_max = items[item]["j"] + dist

            box_i_min = clamp(box_i_min,i_min,i_max)
            box_j_min = clamp(box_j_min,j_min,j_max)
            box_i_max = clamp(box_i_max,i_min,i_max)
            box_j_max = clamp(box_j_max,j_min,j_max)

            for(i_mark=box_i_min-1; i_mark<= box_i_max+1; i_mark++){
                for(j_mark=box_j_min-1; j_mark<= box_j_max+1; j_mark++){
                    manhattan = abs(i_mark - items[item]["i"]) + abs(j_mark - items[item]["j"])

                    if(manhattan != dist) continue

                    # if unmarked
                    if(data[i_mark][j_mark] == 0) {
                        data[i_mark][j_mark] = item
                        distances[i_mark][j_mark] = manhattan

                    # if tied
                    } else if ( dist == distances[i_mark][j_mark] ) {
                        data[i_mark][j_mark] = -1
                    }
                }
            }
        }
        print dist
    }
    writea("datafield",data)
    writea("distfield",distances)
}
END {

    reada("datafield",data)
    reada("distfield",distances)

    for (j=j_min; j<=j_max; j++) {
        for (i=i_min; i<=i_max; i++) {
            if( i in data && j in data[i] && data[i][j] != 0) {
                count[data[i][j]] +=1
            } else {
            }
        }
    }

    n = asorti(count,count_sorted,"@val_num_desc")
    printf "\n%d %d\n", count_sorted[1], count[count_sorted[1]]

    sum_count=0
    for (j = j_min ; j <= j_max ; j++) {
        for (i = i_min ; i <= i_max ; i++) {
            sum=0
            for (item in items) {
                sum = sum + abs(items[item]["i"] - i) + abs(items[item]["j"] - j )
                if(sum > 10000) break
            }
            if(sum < 10000){
                sum_count+=1
                data[i][j]=2*3*5*2
            }
        }
    }

    c[0]=color["red"]
    c[1]=color["green"]
    c[2]=color["yellow"]
    c[3]=color["blue"]
    c[4]=color["magenta"]
    c[5]=color["cyan"]
    c[6]=color["white"]
    c[7]=color["bold"]
    
    sum = 0
    for (j=j_min; j<=j_max; j++) {
        for (i=i_min; i<=i_max; i++) {
            if( i in data && j in data[i] && data[i][j] != 0) {
                c_p = int(data[i][j] / 7)
                printf "%s", c[c_p]
                printf "%s", data[i][j]  % 7
                printf "%s", color["reset"]
                sum+=1

                temp = int(data[i][j])
                r = -1 + 256 / 5 * (temp % 5 + 1)
                g = -1 + 256 / 7 * (temp % 7 + 1)
                b = -1 + 256 / 3 * (temp % 3 + 1)
                data[i][j]=int(r + 256 * g + 256 * 256 * b)

            } else {
                printf "%s", " "
            }
        }
    }
    bitmap(filebmp,data,i_min,i_max,j_min,j_max)
    
    ORS="\n"
    print ""
    printf("%d %d %d %d\n",item,  count[item], items[item]["i"], items[item]["j"])
    printf("%d %d\n",count_sorted[1], count[count_sorted[1]])
    printf("%d %d %d\n", sum, i_max-i_min+1, j_max-j_min+1)
    printf("sum_count: %d", sum_count)

}
