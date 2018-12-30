#@load "json"
#@load "rwarray"
BEGIN {
	#print "hi"
	#print power_level(122,79,57)
	#print power_level(217,196,39)
	#print power_level(101,153,71)
	serial = 6548
	SUBSEP = ","
	delete data
	size = 1
}
function power_evel(size){
	delete full
	temp = 0
	x = y = 1
	for(xd=0;xd<size;xd++)
		for(yd=0;yd<size;yd++)
			temp += data[x+xd][y+yd]

	square = temp
	full[1, 1]= square
	y=1
	max = 0
	loc = ""
	for(x=2;x<=300-size+1;x++){
		full_temp = full[x-1,y]
		for(yd=0;yd<size;yd++)
			full_temp -= data[x-1][y+yd]
		for(yd=0;yd<size;yd++)
			full_temp += data[x+size-1][y+yd]
		full[x, y] = full_temp
		if (full_temp > max) {
			max = full_temp
			loc = x " " y
		}
	}
	for(x=1;x<=300-size+1;x++){
		for(y=2;y<=300-size+1;y++){
			full_temp = full[x,y-1]
			for(xd=0;xd<size;xd++)
				full_temp -= data[x+xd][y-1]
			for(xd=0;xd<size;xd++)
				full_temp += data[x+xd][y+size-1]
			full[x, y] = full_temp
			if (full_temp > max) {
				max = full_temp
				loc = x " " y
			}
		}
	}
	return max
}
{
	for(x=1;x<=300;x++){
		for(y=1;y<=300;y++){
			data[x][y] = power_level(x,y,serial)
		}
	}
	#writea("datafield",data)
	#reada("datafield",data)
	#FS=""
	size=16
	max_x = max_y = 3

	for(size=$1;size<=$1;size++){
		power_evel(size)
		printf "%3d %10d %s", size, max, loc
		full[size]=loc
		print ""
	}
	next
	asorti(full,full_i,"@ind_num_desc")
	print full_i[1]
	print full[full_i[1]]
	split(full_i[1],out,",")
	max_x = out[1]
	max_y = out[2]
	print max_x " " max_y
	for(x=max_x;x<max_x+size;x++){
		for(y=max_y;y<max_y+size;y++){
			printf "%3d ", data[x][y]
		}
		print ""
	}
	print "****"
}


function power_level(x,y,serial){
	rack = x + 10
	power = rack * y
	power += serial
	power *= rack
	return int(power % 1000 / 100) - 5
}
