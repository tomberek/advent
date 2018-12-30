@include "../utils.awk"
BEGIN {
	pi = atan2(0,-1)
	x["ne"]= 1 + cos(60 / 180 * pi)
	x["se"]= 1 + cos(60 / 180 * pi)
	x["s"]=  0
	x["sw"]=-1 - cos(60 / 180 * pi)
	x["nw"]=-1 - cos(60 / 180 * pi)
	x["n"]=  0

	y["ne"]=  sin(60 / 180 *  pi)
	y["se"]= - sin(60 / 180 * pi)
	y["s"]=  -2 *  sin(60 / 180 * pi)
	y["sw"]= - sin(60 / 180 * pi)
	y["nw"]= sin(60 / 180 * pi)
	y["n"]=  2* sin(60 / 180 * pi)

	a30 = 30 / 180 * pi
	a60 = 60 / 180 * pi
	a90 = 90 / 180 * pi
	a120 = 120 / 180 * pi
	a150 = 150 / 180 * pi
	a180 = 180 / 180 * pi
	a210 = 210 / 180 * pi
	a240 = 240 / 180 * pi
	a270 = 270 / 180 * pi
	a300 = 300 / 180 * pi
	a330 = 330 / 180 * pi
	a360 = 360 / 180 * pi
	FS=","
}
{
	walkx=0
	walky=0
	max_walk = 0
	for(i=1;i<=NF;i++){
		walkx+=x[$i]
		walky+=y[$i]
		temp = dist(walkx,walky)
		if (temp > max_walk) {
			max_walk=temp
		}
	}
	print "max walk", max_walk
}
function dist(walkx,walky){

	#print "Next line:", $0
	posx=0
	posy=0
	ex=0
	ey=0
	walk = 0

	ex = walkx - posx
	ey = walky - posy
	#printa(x)
	#printa(y)

	while( abs(ex) + abs(ey) > 0.2){
		#print "error", abs(ex) + abs(ey) > "/dev/stderr"
		#print walkx, walky > "/dev/stderr"
		#print "pos:", posx, posy > "/dev/stderr"
		#print "error xy:", ex, ey > "/dev/stderr"
		#print atan2(ey,ex) > "/dev/stderr"

		walk++
		angle = (atan2(ey,ex) + 2*pi) %  (2 * pi)
		#print "angle", angle > "/dev/stderr"
		if(angle <= a60 && angle >= 0){
			posx += x["ne"]
			posy += y["ne"]
		} else if (angle <= a120 && angle > a60){
			posx += x["n"]
			posy += y["n"]
		} else if (angle <= a180 && angle > a120){
			posx += x["nw"]
			posy += y["nw"]
		} else if (angle <= a240 && angle > a180){
			posx += x["sw"]
			posy += y["sw"]
		} else if (angle <= a300 && angle > a240){
			posx += x["s"]
			posy += y["s"]
		} else if (angle <= a360 && angle > a300){
			posx += x["se"]
			posy += y["se"]
		} else {
			print "error"
			exit
		}
		ex = walkx - posx
		ey = walky - posy
	}
	return walk
	#print "****" > "/dev/stderr"
}
END {
}
