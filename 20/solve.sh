#@load "json"
#@load "rwarray"
#@include "../utils.awk"
@include "../color.awk"
@include "../utils.awk"
BEGIN {
    data[0][0]="X"
    FS=""
    OFS=""
	set_cols(colors)
}
{
    $1 = ""
    process($0,0,0,0)
    exit
}
END {
    print_data(data)
    max = 0
    for(j in search){
        for(i in search[j]){
            if(max < search[j][i])
                max = search[j][i]
        }
    }
    for(j in search){
        for(i in search[j]){
            if(search[j][i] >=1000)
                max_count++
        }
    }
    print max
    print max_count
    print "end"
}
function store(search,y,x,dist){
    if((y in search)==0 || ( x in search[y])==0 ){
        search[y][x] = dist
    } else if (search[y][x] > dist){
        search[y][x] = dist
    }
}
function process(str,y,x, ly,lx,count,lcount){
    head = substr(str,1,1)
    rest = substr(str,2,length(str)-1)
    switch(head){
    case "E":
        count++
        x++
        data[y][x]="|"
        x++
        data[y][x]="."
        break;
    case "W":
        count++
        x--
        data[y][x]="|"
        x--
        data[y][x]="."
        break;
    case "S":
        count++
        y++
        data[y][x]="-"
        y++
        data[y][x]="."
        break;
    case "N":
        count++
        y--
        data[y][x]="-"
        y--
        data[y][x]="."
        break;
    case ")":
        return rest
    case "|":
        rest = process(rest,ly,lx,ly,lx,lcount,lcount)
        return rest
    case "(":
        rest = process(rest,y,x,y,x,count,count)
        break;
    case "$":
        return
    default:
        print "error"
        exit
    }
    store(search,y,x,count)
    return process(rest,y,x,ly,lx,count,lcount)
}

function print_data(data, j, i){
    miny=minx=-101
    maxy=maxx=105
    for(j=miny-1;j<=maxy+1;j++){
        for(i=minx-1;i<=maxx+1;i++){
            if (!( j in data)|| !(i in data[j])) {
                if( abs(j % 2) == 1 && abs(i % 2) == 1)
                    data[j][i]="#"
                else
                    data[j][i]="#"
            } else {
                
            }
        }
    }
    for(j=miny;j<=maxy;j++){
        for(i=minx;i<=maxx;i++){
			if(data[j][i] == "|" || data[j][i] == "-"){
				printf "%s",colors["red"]
				printf "%s",colors["bold"]
				printf "%s", data[j][i]
				printf "%s",colors["reset"]
            } else if(data[j][i] == "#"){
				printf "%s",colors["cyan"]
				printf "%s", "#"
                printf "%s",colors["reset"]
            } else if(data[j][i] == "."){
				printf "%s",colors["red"]
				printf "%s",colors["bold"]
				printf "%s", "."
				printf "%s",colors["reset"]
            }else
				printf "%s", data[j][i]
        }
        print ""
    }
}

