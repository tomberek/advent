#@load "json"
@load "rwarray"
@include "../utils.awk"
@include "../color.awk"
BEGIN {
    set_cols(color)
	FS=""
	UP="^"
	DOWN="v"
	LEFT="<"
	RIGHT=">"
	L = 0
	S = 1
	R = 2
}

function make_car(x,y,dir){
	car_i++
	carx[car_i] = x
	cary[car_i] = y
	loc[x][y]=car_i
	direction[car_i] = dir
	turn[car_i] = L
}
{
	for(i=0;i<length($0);i++){
		data[i][NR-1] = $(i+1)

		# What if on a curve?
		switch(data[i][NR-1]){
		case ">":
			data[i][NR-1] = "-"
			make_car(i,NR-1,$(i+1))
			break;
		case "<":
			data[i][NR-1] = "-"
			make_car(i,NR-1,$(i+1))
			break;
		case "^":
			data[i][NR-1] = "|"
			make_car(i,NR-1,$(i+1))
			break;
		case "v":
			data[i][NR-1] = "|"
			make_car(i,NR-1,$(i+1))
			break;
		}
	}
	if(i > max_i) max_i = i
}
END{
#writea("trackdata",data)
}

function move_cars(x,y,i,car,t,temp,temp_i){
    sx = x
    sy = y
    temp_i = 0
    delete temp
    #asorti(carx,carxi,"@val_num_asc")
    #asorti(cary,caryi,"@val_num_asc")
    #for(y in caryi){
        #for(x in carxi){
            #if( (x,y)
        #}
    #}
	for(y=0;y<NR;y++){
		for(x=0;x<max_i;x++){
			if(((x in loc) == 0) || (y in loc[x]) ==0 ) continue
            temp_i++
			temp[temp_i]= loc[x][y]
            tempx[temp_i] = x
            tempy[temp_i] = y
        }
    }
    for(ind=1;ind<=temp_i;ind++){
            i = ind
            if((temp[i] in carx) == 0) continue
            x = tempx[i]
            y = tempy[i]
            sx = x
            sy = y
			car = temp[i]
			t = car
			crash_q = move_car(car,data[tempx[car]][tempy[car]])
			delete loc[sx][sy]
            if(crash_q == 0){
                loc[carx[t]][cary[t]] = t
            } else {
                print "move_cars end"
                printa(carx)
            }
    }

#	for(car in carx){
#		move_car(car,data[carx[car]][cary[car]])
#	}
}

function move_intersection(car_i){

	switch(direction[car_i]){
	case ">":
		carx[car_i] += 1
		if(turn[car_i] == L) direction[car_i] = UP
		if(turn[car_i] == S) direction[car_i] = RIGHT
		if(turn[car_i] == R) direction[car_i] = DOWN
		break;
	case "<":
		carx[car_i] -= 1
		if(turn[car_i] == L) direction[car_i] = DOWN
		if(turn[car_i] == S) direction[car_i] = LEFT
		if(turn[car_i] == R) direction[car_i] = UP
		break;
	case "^":
		cary[car_i] -= 1
		if(turn[car_i] == L) direction[car_i] = LEFT
		if(turn[car_i] == S) direction[car_i] = UP
		if(turn[car_i] == R) direction[car_i] = RIGHT
		break;
	case "v":
		cary[car_i] += 1
		if(turn[car_i] == L) direction[car_i] = RIGHT
		if(turn[car_i] == S) direction[car_i] = DOWN
		if(turn[car_i] == R) direction[car_i] = LEFT
		break;
	}
	turn[car_i] = (turn[car_i] +1) % 3
}
function check_crash(car_i, i){
	for(i in carx){
		if(i == car_i) continue
		if(carx[car_i] == carx[i] && cary[car_i] == cary[i] ){
			 #render(data,carx,cary,direction,layout)
			 #print_cars(layout)
			 printa(carx)

             delete turn[car_i]
             delete turn[i]
             delete direction[car_i]
             delete direction[i]
             #delete loc[carx[car_i]][cary[car_i]]
			 #data[carx[car_i]][cary[car_i]] = "X"
			 #layout[carx[car_i]][cary[car_i]] = "X"
			 print carx[car_i] "," cary[car_i]
			 print carx[i], cary[i]
             delete carx[car_i]
             delete cary[car_i]
             delete carx[i]
             delete cary[i]
			 print car_i, i
			 print i
             if(length(carx) <= 1) {
                printa(carx)
                printa(cary)
                print "last one"
                done = 1
             }
			 printa(carx)
			 print "crash", "iter ", iter
             return 1
		}

	}
    return 0
}
function move_car(car_i,track){
    #print "moving", carx[car_i], cary[car_i]
	switch(direction[car_i]){
	case ">":
		track=data[carx[car_i]+1][cary[car_i]]
		break;
	case "<":
		track=data[carx[car_i]-1][cary[car_i]]
		break;
	case "^":
		track=data[carx[car_i]][cary[car_i]-1]
		break;
	case "v":
		track=data[carx[car_i]][cary[car_i]+1]
		break;
	}
	switch(track){
	case "-":
		if(direction[car_i]==LEFT)
			carx[car_i] -= 1
		if(direction[car_i]==RIGHT)
			carx[car_i] += 1
		break;
	case "|":
		if(direction[car_i]==UP)
			cary[car_i] -= 1
		if(direction[car_i]==DOWN)
			cary[car_i] += 1
		break;
	case "/":
		switch (direction[car_i]){
		case "^":
			cary[car_i] -= 1
			direction[car_i] = RIGHT
			break;
		case "v":
			cary[car_i] += 1
			direction[car_i] = LEFT
			break;
		case "<":
			carx[car_i] -= 1
			direction[car_i] = DOWN
			break;
		case ">":
			carx[car_i] += 1
			direction[car_i] = UP
			break;
		}
		break;
	case "\\":
		switch(direction[car_i]){
		case "^":
			cary[car_i] -= 1
			direction[car_i] = LEFT
			break;
		case "v":
			cary[car_i] += 1
			direction[car_i] = RIGHT
			break;
		case "<":
			carx[car_i] -= 1
			direction[car_i] = UP
			break;
		case ">":
			carx[car_i] += 1
			direction[car_i] = DOWN
			break;
		}
		break;
	case "+":
		move_intersection(car_i)
		break;
	}
	return check_crash(car_i)
}


function print_cars(data,x,y){
    buffer=""
    screen_height=NR
    screen_height=70
	for(y=0;y<screen_height;y++){
        #system("tput cup " 0 " " y)
		for(x=0;x<max_i;x++){
			if(x in data && y in data[x]){
                switch(data[x][y]){
                case "<":
                case ">":
                case "v":
                case "^":
                    buffer = buffer sprintf("%s%s%s%s",color["bold"],color["green"],data[x][y],color["reset"])
                    break
                case " ":
                    buffer = buffer sprintf(" ")
                    break
                default:
                    buffer = buffer sprintf("%s%s%s", color["yellow"],data[x][y],color["reset"])
                }
            }
			else
				printf "error"
		}
        #print length(buffer)
        #print "hi"
        buffer = buffer "\n"
        #exit
		#print ""
	}
    #printf "%s", buffer
    system("tput cup " 0 0)
    printf "%s",buffer
    fflush("/dev/stdout")
}
function render(data,carx,cary,direction,layout, x, y ,i){
	delete layout
	for(y=0;y<NR;y++){
		for(x=0;x<max_i;x++){
			if(x in data && y in data[x])
				layout[x][y]=data[x][y]
		}
	}
	for (i in carx){
		layout[carx[i]][cary[i]]=direction[i]
	}

}
END {
	#printa(data)
	for(i=0;i<100000;i++){
        iter = i
        for(p in carx){
            if(carx[p]==""){
                #render(data,carx,cary,direction,layout)
                #print_cars(layout)
                printa(carx)
                print "error", "p, i: " p, i
                exit
            }

        }
		if( i % 1000 < -1){
            print i, "length: " length(carx)
			render(data,carx,cary,direction,layout)
			print_cars(layout)
			#writea("datafield." i,layout)

		}
		move_cars()

        #render(data,carx,cary,direction,layout)
        #print_cars(layout)
        #getline go < "-"
        #system("sleep 0.1")

        if(done ==1){
            render(data,carx,cary,direction,layout)
            print_cars(layout)
            printa(carx)
            printa(cary)
            print "exit"
            exit
        }
	}
	print "exit"
	exit
}

