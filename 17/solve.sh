#@load "json"
@load "rwarray"
@include "../utils.awk"
@include "../color.awk"
@include "../utils.awk"
BEGIN {
	set_cols(colors)
	print "hi"
	FPAT="([0-9])+"
	x_min = 1000
	x_max = 0
	y_min = 1000
	y_max = 0

}

{ x = y = xr = yr = "" }
match($0,/x=([0-9]*)/,arr){
	x=arr[1]
}
match($0,/y=([0-9]*)/,arr){
	y=arr[1]
}
match($0,/x=[0-9]*\.\.([0-9]*)/,arr){
	xr=arr[1]
}
match($0,/y=[0-9]*\.\.([0-9]*)/,arr){
	yr=arr[1]
}
{
	#printf "%s,%s,%s,%s\n",x, xr, y,yr
	if(xr == "") xr = x
	if(yr == "") yr = y
	if(x < x_min) x_min = x
	if(y < y_min) y_min = y
	if(x > x_max) x_max = xr
	if(y > y_max) y_max = yr


	for(i=x;i<=xr;i++){
		for(j=y;j<=yr;j++){
			data[j][i] = "#"
		}
	}

}
END {
	x_min -=2
	orig_y_min = y_min
	y_min = 0
	x_max +=2
	y_max +=0
	data[0][500]="+"
	for(i=x_min;i<=x_max;i++){
		for(j=y_min;j<=y_max;j++){
			if(j in data && i in data[j]){
			} else {
				data[j][i] = "."
			}
		}
	}

	print y,xl,xr
	spigots[0,500] = 1
	spigot = 0 SUBSEP 500

	prev_score = 0
	prev_moving = 0
	for(steps=1;steps<= 5000 ;steps++){
		for(spigot in spigots){
			if(spigot in spigots){
				#print "spigot:",spigot,length(spigots)
				split(spigot,posa,SUBSEP)
				spigoty=pos[1]
				spigotx=pos[2]
				step(posa[1],posa[2],data)
			}
		}
		if(steps % 1 == 0) {
			new_score = score_map(data)
			system("tput home")
			if(abs(prev_moving - moving) < 15){
				moving = prev_moving
			}else {
				prev_moving = moving
			}
			print_map(data,moving+30)
			print "steps:", steps -1, moving, prev_moving
			print "new_score", new_score
			if(new_score == prev_score){
				print "score stable"
				flag = 1
			} else
				prev_score = new_score
		}
		if(length(spigots)==0) exit
		if(flag == 1) break

	}
	print "final score:",score_map(data)
	print_map_total(data)
	print "final score:",score_map(data)
	print scored
}
function score_map(data, j,i, score){
	score = 0
	scored = 0
	for(j=orig_y_min;j<=y_max;j++){
		for(i=x_min;i<=x_max;i++){
			switch(data[j][i]){
				case "~":
					scored++
				case "|":
					score++
			}
		}
	}
	return score
}
function step(yi,xi,data, x,y, i){
	delete exits
	y = scan_down(yi,xi,"#~",data)
	if (y == -1) return
	if(y >= y_max) return
	xl = scan_left(y,xi,"#~",data)
	xr = scan_right(y,xi,"#~",data)
	if(length(exits) == 0){
		#print "stable", xl, xr
		stabilize_water(y,xl,xr,data)
	} else {
		#delete spigots[spigot]
		for(i in exits) spigot=i
		#for(i in spigots){
			#split(i,pos,SUBSEP)
			#step(pos[1],pos[2],data)
		#}
	}
}
function stabilize_water(y,xl,xr,data,   i){
	if(xl>xr) {
		print "error stabilize"
		print steps
		print y,xl,xr
		print_map(data,y)
		exit
	}
	for(i=xl;i<=xr;i++){
		data[y][i]="~"
	}
}
function scan_right(y,x,stuff,data){
	while(x<700){
		x++
		if(!(y in data && x in data[y]))
			break
		if(index(stuff,data[y][x]) !=0)
			break
		if(data[y][x]==".") moving = y
		data[y][x]="|"
		if(data[y+1][x] != "#" && data[y+1][x] != "~" ){
			exits[x]=1
			spigots[y,x]=1
			#data[y][x]="+"
			break
		}
	}
	return x-1
}
function scan_left(y,x,stuff,data){
	while(x>300){
		x--
		if(!(y in data && x in data[y]))
			break
		if(index(stuff,data[y][x]) != 0)
			break
		if(data[y][x]==".") moving = y
		data[y][x]="|"
		if(data[y+1][x] != "#" && data[y+1][x] != "~" ){
			exits[x]=1
			spigots[y,x]=1
			#data[y][x]="+"
			break
		}
	}
	return x+1
}
function scan_down(y,x,stuff,data){
	while(y<2000){
		y++
		if(!(y in data && x in data[y]))
			break
		if(0 && data[y][x]=="~" && spigoty == y+1){
			data[y+1][x]="|"
		}
		if(0 && (y+1 in data && x in data[y+1])){
			if(data[y][x]!="|" && data[y+1][x]=="|"){
				print "problem"
				data[y][x]="|"
				print_map(data, y)
				delete spigots[spigot]
				return -1
			}
		}
		if(index(stuff,data[y][x]) !=0)
			break
		if(data[y][x]==".") moving = y
		data[y][x]="|"
	}
	#print y-1
	return y-1
}
function print_map(data, temp_y_max, j,i){
	#system("tput home")
	#temp_y_max = 1700
	temp_y_min = temp_y_max -80
	for(j=temp_y_min;j<=temp_y_max;j++){
	#for(j=y_min;j<=y_max;j++){
		for(i=x_min;i<=x_max;i++){
			if(data[j][i] == "~"){
				printf "%s",colors["blue"]
				printf "%s", data[j][i]
				printf "%s",colors["reset"]
			} else
			if(data[j][i] == "|"){
				printf "%s",colors["green"]
				printf "%s", data[j][i]
				printf "%s",colors["reset"]
			}else{
				printf "%s", data[j][i]
			}
		}
		printf "%s", j
		print ""
	}
	#print x_min,x_max,y_min,y_max
}



function print_map_total(data, temp_y_max, j,i){
	#system("tput home")
	#temp_y_max = 1700
	for(j=y_min;j<=y_max;j++){
		for(i=x_min;i<=x_max;i++){
			printf "%s", data[j][i]
		}
		printf "%s", j
		print ""
	}
	#print x_min,x_max,y_min,y_max
}



# vim: set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab : #
