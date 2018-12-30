#@load "json"
@load "rwarray"
@include "../utils.awk"
@include "../color.awk"
@include "../utils.awk"
BEGIN {
	set_cols(colors)
	#FPAT="([0-9])+"
	FS=""
}
{
	for(i=1;i<=NF;i++){
		data[NR,i]=$i
	}
}
	
END{
	reada("data",data)

	for(i= 569 + 35714265 * 28 +1 ;i<=1000000000;i++){
		step(data,new_data)
		copyto(new_data,data)

		if(i > 55199999999999){
			storage=""
			for( j in data ) {
				storage = storage data[j]
			}
			if (storage in history){
				print storage
				print history[storage], i
				print_data(data)
				#writea("data",data)
				exit
			} else {
				history[storage] = i
			}
		}
		#print_data(data)
		print i
		print(score(data))
	}
	#print(score(data))
}
function score(data, i, wooded,lumber){
	wooded=0
	lumber=0
	for( i in data){
		switch(data[i]){
		case "|":
			wooded++
			break
		case "#":
			lumber++
			break
		}
	}
	return wooded * lumber
}
function copyto(src,dst, i){
	delete dst
	for(i in src){
		dst[i]=src[i]
	}
}

function step(data, new_data, temp, i){
	delete new_data
	for( i in data ){
		switch(data[i]){
		case ".":
			temp =  count(i,"|")
			if(temp >= 3)
				new_data[i] = "|"
			else
				new_data[i] = data[i]
			break
		case "|":
			temp =  count(i,"#")
			if(temp >= 3)
				new_data[i] = "#"
			else
				new_data[i] = data[i]
			break
		case "#":
			temp =  count(i,"#")
			temp2 =  count(i,"|")
			if(temp >= 1 && temp2 >=1)
				new_data[i] = "#"
			else
				new_data[i] = "."
			break
		}
	}
}

function count(pos,thing,    sum, i, positions){
	adjacent(pos,positions)
	sum = 0
	for( i in positions ) {
		if( i in data && data[i] == thing) sum++
	}
	return sum
}
function adjacent(pos,positions){
	delete positions
	split(pos,posa,SUBSEP)
	y = posa[1]
	x = posa[2]
	positions[y+1,x+1] = 1
	positions[y+1,x] = 1
	positions[y+1,x-1] = 1
	positions[y,x+1] = 1
	#positions[y,x] = 1
	positions[y,x-1] = 1
	positions[y-1,x+1] = 1
	positions[y-1,x] = 1
	positions[y-1,x-1] = 1
}
function print_data(data, j, i){
	for(j=1;j<=NR;j++){
		for(i=1;i<=NF;i++){
			printf "%s",data[j,i]
		}
		print ""
	}
}
