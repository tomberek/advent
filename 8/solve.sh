@include "../utils.awk"
@include "../bitmap.awk"
# BEGIN rule(s)
match($0, /.*/,arr) {
}

function process_node( j,  my_id , temp_sum, val){
    j = 0
    starts[id] = i
    children[id] = $(i++)
    meta[id] = $(i++)
	my_id = id++

	for (j = 1; j <= children[my_id]; j++){
        children_array[my_id][j] = id
		process_node()

	}
	for (j = 1; j <= meta[my_id]; j++) {
		metadata[my_id][j] = $i
        sum += $(i++)
	}
    if (children[my_id] == 0){
        for (j in metadata[my_id]){
            value[my_id] += metadata[my_id][j]
        }
    } else if (my_id in metadata) {
        for (j in metadata[my_id]){
            #print j " - " metadata[my_id][j] " : " my_id  " count: " meta[my_id]
            child_i = metadata[my_id][j]
            child_i2 = children_array[my_id][child_i]
            value[my_id] += value[child_i2]
        }
    }
    ends[my_id] = i
    print my_id "-" children[my_id] "," meta[my_id] ":" metadata[my_id][1] "-" metadata[my_id][meta[my_id]] " value: " value[my_id] " loc:" starts[my_id] "-" ends[my_id]
}
END {
    id = 1
    i = 1
    level_num=1
    level_ind=1
	process_node()
    print sum
}
END {
    i = 1
    $0 = "1"
    number = 0
    x = 1
    y = 1
    while ($0 != ""){
        if (number++ > 1000) break
        print_node($1)
        printed[$1]=1
        if ($1 in children_array) {
        x = starts[$1]
            for (ch in children_array[$1]){
                print_node(children_array[$1][ch])
                printed[children_array[$1][ch]]=1
                $(NF+1) = children_array[$1][ch]
            }
        }
        $1 = ""
        $0 = $0
        y++
    }
    close("output")
    print intput[2][10]
    #bitmap("out.bmp",intput,0,15986,0,256)
    print "exit"
    
}
function print_node(i){
    if(i in printed) return
    
    #for(j = 1; j <= starts[i] - 1; j++){
        #printf " " > "output"
        #intput[x++][y] = 0
    #}
    #printf "%02d", i % 100 > "output"
    c = i % 200 + 56
    intput[x++][y] = c * 256 * 256 + 255 * 256 + c
    intput[x++][y] = c * 256 * 256 + 255 * 256 + c
    #for(j = 1; j <= children[i]; j++){
    #    printf "-" > "output"
    #    intput[x++][y] = 255 * 256 * 256 + 255 * 256 + 255
    #}
    for(j = 1; j <= ends[i] - starts[i] - 1 ; j++){
        #printf "-" > "output"
        c = int(j /(ends[i] - starts[i] - 1) * 255 ) 
        intput[x++][y] = c *  256 * 256 + c * 256 + c
    }
}
