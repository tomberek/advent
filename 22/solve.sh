#@load "json"
@load "rwarray"
@include "../utils.awk"
@include "../color.awk"
@include "../utils.awk"
@include "./testing.awk"
BEGIN {
    depth = 510
	targetx = xmax=10
	targety = ymax=10
    depth = 11394
	targetx = xmax=7
	targety = ymax=701
    delete geo_index
    geo_index[0][0]=0
    geo_index[targety][targetx]=0
}
END {
	for(j=0;j<=ymax;j++){
		for(i=0;i<=xmax;i++){
			geo(j,i)
		}
	}
    #printa(geo_index)
    print_data(geo_index)
    score_data(geo_index)
    get_neighbors( 0 SUBSEP 0 SUBSEP TORCH,result)
    printa(result)
    dijstra(0,0,0,targety,targetx,0)
    #writea("dij.data",data)
    #writea("value.data",value)
    #writea("color.data",color)
    #writea("yellow.data",yellow)
    print "value,",value[targety,targetx,0]
    #print_data(geo_index)
    print "done"
}

BEGIN{
    SUBSEP=","
    RED=0
    YELLOW=1
    GREEN=2
}
function dijstra(y,x,z,ty,tx,tz, min, arr, temp, count, i, target_str){
    color[y,x,z]=YELLOW
    yellow[y,x,z] = 0
    push(0,y SUBSEP x SUBSEP z)
    value[y,x,z] = 0
    color[ty,tx,tz]= RED

    while(count < 90000000 && ((ty,tx,tz) in color) && color[ty,tx,tz] != GREEN){
        count++
        min = 9999999999
        best = ""
        #for(i in yellow){
        #    split(i,arr,SUBSEP)
        #    if(arr[3]==tx)
        #        temp2=0
        #    else
        #        temp2=7
        #    temp = value[i] + abs(arr[1]-ty) + abs(arr[2]-tx) + temp2
        #    if (temp < min){
        #        best = i
        #        min = temp
        #    }
        #}
        target_str = pop()
        #target_str = best #yellow_ind[1]
        color[target_str] = GREEN
        delete yellow[target_str]
        if(count % 10 <= 4 ){
            print count
            print "visit",target_str, value[target_str]
        }
        tell_neighbors(target_str)
  }
  print "done"
  print count
  print "visit",target_str, value[target_str]
}
BEGIN {
    ROCKY = 0 # CLIMB or TORCH
    WET = 1 # CLIMB or NEITHER
    NARROW = 2 # TORCH or NEITHER

    TORCH = 0
    CLIMB = 1
    NEITHER = 2
}
function get_neighbors(pos, result, pos_a, y,x,z, temp, ind , arr, n){
    split(pos,pos_a,SUBSEP)
    y = pos_a[1]
    x = pos_a[2]
    z = pos_a[3]

    ind = 0
    delete result
    temp[1] = y+1 SUBSEP x SUBSEP erosion(y+1,x) % 3
    temp[2] = y SUBSEP x+1 SUBSEP erosion(y,x+1) % 3
    if(y != 0)
        temp[3] = y-1 SUBSEP x SUBSEP erosion(y-1,x) % 3
    if(x != 0)
        temp[4] = y SUBSEP x-1 SUBSEP erosion(y,x-1) % 3
    switch (z){
    case 0: #TORCH:
        for (n in temp){
            split(temp[n],arr,SUBSEP)
            if(arr[3] == ROCKY || arr[3] == NARROW){
                result[ind++] = arr[1] SUBSEP arr[2] SUBSEP z SUBSEP 1
            }
        }
        break
    case 1: #(CLIMB):
        for (n in temp){
            split(temp[n],arr,SUBSEP)
            if(arr[3] == ROCKY || arr[3] == WET){
                result[ind++] = arr[1] SUBSEP arr[2] SUBSEP z SUBSEP 1
            }
        }
        break
    case 2: # (NEITHER):
        for (n in temp){
            split(temp[n],arr,SUBSEP)
            if(arr[3] == WET || arr[3] == NARROW){
                result[ind++] = arr[1] SUBSEP arr[2] SUBSEP z SUBSEP 1
            }
        }
        break
    }
    switch(erosion(y,x) %3){
    case 0: #ROCKY
        if(z==CLIMB)
            result[ind++] = y SUBSEP x SUBSEP TORCH SUBSEP 7
        else
            result[ind++] = y SUBSEP x SUBSEP CLIMB SUBSEP 7
        break
    case 1: #WET
        if(z==CLIMB)
            result[ind++] = y SUBSEP x SUBSEP NEITHER SUBSEP 7
        else
            result[ind++] = y SUBSEP x SUBSEP CLIMB SUBSEP 7
        break
    case 2: #NARROW
        if(z==TORCH)
            result[ind++] = y SUBSEP x SUBSEP NEITHER SUBSEP 7
        else
            result[ind++] = y SUBSEP x SUBSEP TORCH SUBSEP 7
        break
    }
}
function tell_neighbors(pos, node, n, neighbors){
    # Get neighbors, and cost
    get_neighbors(pos,neighbors)
    n = value[pos]
    for(info in neighbors){
        split(neighbors[info],node_array,SUBSEP)
        nodey = node_array[1]
        nodex = node_array[2]
        nodez = node_array[3]
        node = nodey SUBSEP nodex SUBSEP nodez
        cost = node_array[4]

        #print "node",node,"\t\t", n + cost
        switch(color[node]){
        case 0: # RED:
            color[node]=YELLOW
            yellow[node] = n + cost
            push(n+cost,node)
            value[node] = n +  cost
            continue
        case 1: # YELLOW:
            if(node in yellow && n + cost < value[node]){
                yellow[node] = n + cost
                push(n+cost,node)
                value[node] = n +  cost
            }
            continue
        case 2: # GREEN:
            if(node in yellow && n + cost < value[node]){
                yellow[node] = n + cost
                push(n+cost,node)
                value[node] = n +  cost
            }
            continue
        default:
            print "error"
            exit
        }
    }
}


function geo(y,x){
    if(!(y in geo_index) || !(x in geo_index[y])){
        if( x==0 && y==0 ){
            geo_index[0][0] = 0
        } else if( x==targetx && y==targety ){
            geo_index[targetx][targety] = 0
        } else if (y==0){
            geo_index[y][x] = x * 16807
        } else if (x==0){
            geo_index[y][x] = y * 48271
        } else {
            temp = erosion(y-1,x) * erosion(y,x-1)
            geo_index[y][x] = temp
        }
    } else return geo_index[y][x]
    return geo_index[y][x]
}
function erosion(y,x){
    if(y == targety && x == targetx) return 0
    return abs((geo(y,x) + depth) % 20183)
}
function score_data(geo_index, score, j, i){
    score = 0 
	for(j=0;j<=ymax;j++){
		for(i=0;i<=xmax;i++){
			switch (erosion(j,i) % 3){
			case 0: #  ROCKY
                score +=0
				break;
			case 1: # WET
                score +=1
				break;
			case 2: # NARROW
                score +=2
				break;
			}
		}
	}
    print "score: ",score
}
function print_data(geo_index, j, i){
    xmax2=xmax*2
    ymax2=ymax/50
	for(j=0;j<=ymax2;j++){
		print ""
		for(i=0;i<=xmax2;i++){
			switch (erosion(j,i) % 3){
			case 0:
				printf "%s","."
				break;
			case 1:
				printf "%s","="
				break;
			case 2:
				printf "%s","|"
				break;
			}
		}
	}
}
