@include "../10/hash.awk"
@include "../utils.awk"
@load "rwarray"
/asdf/{
    list=""
    for(i=0;i<256;i++){
        list = list chr(i)
    }

	for(i=0;i<128;i++){
		thestr = "jzgqcdpd-" i
		loadstr(thestr,rev)
		v = hash64(list,rev)
		compact(v,thehash)
		out = printh(thehash)
	   	out = tobits(out)
		print out
		data=data out

		split(out,tempa,"")
		for(j=0;j<128;j++)
			mydata[i][j]=tempa[j+1]
	}
	for(i=1;i<=length(data);i++){
		if(substr(data,i,1) == "1") count ++
	}
	print count
	writea("datafield",mydata)

}
BEGIN {
	reada("datafield",mydata)
	for(i=0;i<128;i++){
		for(j=0;j<128;j++){
			queue[i,j]=1
		}
	}

	while(length(queue)!=0){
		print "************"
		for(i in queue) break
		delete queue[i]
		split(i,pos,SUBSEP)
		res = visit(pos[1],pos[2])
		if(res == 1) count++
		#if(count >1000) exit
	}
	print count
	print "exit"
}
function visit(x, y){
	print("visit",x,y)
	print(length(queue))
	if(mydata[x][y] == 0) return 0
	delete queue[x SUBSEP y]
	print(length(queue))
	if(safe(x+1,y)) visit(x+1,y)
	#if(safe(x+1,y+1)) visit(x+1,y+1)
	#if(safe(x+1,y-1)) visit(x+1,y-1)
	#if(safe(x-1,y+1)) visit(x-1,y+1)
	#if(safe(x-1,y-1)) visit(x-1,y-1)
	if(safe(x-1,y)) visit(x-1,y)
	if(safe(x,y+1)) visit(x,y+1)
	if(safe(x,y-1)) visit(x,y-1)
	return 1
}
function safe(x,y){
	return x in mydata && y in mydata[x] && mydata[x][y] == 1 && (x,y) in queue
}
	

function tobits(hash,i ,temp, out){
	out = ""
	for(i=1;i<=32;i=i+2){
		temp = strtonum("0x" substr(hash,i,1) substr(hash,i+1,1))
		base = 128
		for(j=1;j<=8;j++){
			out = out int(temp / base)
			temp = temp - base * int(temp / base)
			base = base / 2
		}
	}
	return out
}

