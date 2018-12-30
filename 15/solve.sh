#@load "json"
@load "rwarray"
@include "../utils.awk"
#@include "../color.awk"
BEGIN {
	FS=""
}
{
	for(i=1;i<=NF;i++){
		switch($i){
		case "G":
			#goblins[i][NR]=char_id++
			#goblins_loc[char_id] = i SUBSEP NR
			char_id++
			char["G"]["id"][NR][i]=char_id
			char["G"]["loc"][char_id] = NR SUBSEP i
			power[char_id]=3
			hitpoints[char_id]=200
			#goblins_loc[char_id] = i SUBSEP NR
			$i = "."
			break
		case "E":
			#elves[i][NR]=char_id++
			#elves_loc[char_id] = i SUBSEP NR
			char_id++
			char["E"]["id"][NR][i]=char_id
			char["E"]["loc"][char_id] = NR SUBSEP i
			power[char_id]=test
			hitpoints[char_id]=200
			$i = "."
			break
		case "#":
			walls[i][NR]=1
			break
		case ".":
			ground[i][NR]=1
			break
		default:
			print $i
			print "error"
			exit
		}
		data[NR][i]=$i
	}
		
}
function generate_turn_queue(data,turn_list,turn_id,i,j, char_id){
	delete turn_list
	turn_id=1
	goblin_id=0
	elf_id=0
	for(j=1;j<=max_y;j++){
		for(i=1;i<=max_x;i++){
			switch(data[j][i]){
			case "G":
				char_id =char["G"]["id"][j][i]
				if(char_id in hitpoints && hitpoints[char_id] > 0)
					turn_list[turn_id++] = char_id
				break
			case "E":
				char_id =char["E"]["id"][j][i]
				if(char_id in hitpoints && hitpoints[char_id] > 0)
					turn_list[turn_id++] = char_id
				break
			default:
				break
			}
		}
	}
}
function not_self(ch){
	if(ch=="G") return "E"
	if(ch=="E") return "G"
	print "error"
	exit
}
function targetq(data,x,y,type){
	return y in data && x in data[y] && data[y][x] == type
}
function adjacent(data,a_list,pos,type){
	split(pos,p,SUBSEP)
	x=p[2]
	y=p[1]
	if(targetq(data,x+1,y,type)) a_list[y SUBSEP x+1] = 1
	if(targetq(data,x-1,y,type)) a_list[y SUBSEP x-1] = 1
	if(targetq(data,x,y+1,type)) a_list[y+1 SUBSEP x] = 1
	if(targetq(data,x,y-1,type)) a_list[y-1 SUBSEP x] = 1
}
function prep_move(char_id,a_list,r_list){
	delete a_list
	delete r_list
	for(i in char[enemy]["loc"]){
		#print "ENEMY",enemy, char[enemy]["loc"][i]
		adjacent(data_out,r_list,char[enemy]["loc"][i],".")
	}
	adjacent(data_out,a_list,char[self]["loc"][char_id],enemy)
}

function h_cost_func(i,d){
	split(i,pos,SUBSEP)
	split(d,dpos,SUBSEP)
   	return abs(dpos[1]-pos[1]) + abs(dpos[2]-pos[2]) }

function b_star(pos, d_list, queue,closed,parent,f_cost,dist_cost){
	delete queue
	delete closed
	delete parent
	delete dist_cost
	delete f_cost

	dist_cost[pos]=0
	f_cost[pos]=0
	queue[pos] = f_cost[pos]
	#printa(d_list)
	#printa(queue)
	#print "...." pos
	while(length(queue)!=0){
		for( item in queue) break
		closed[item]=f_cost[item]
		delete queue[item]

		if (item in d_list){
			#print "reached", item
			#print ".", f_cost[item]
		}
		#print "item", item
		delete star
		adjacent(data_out,star,item,".")	
		#printa(star)
		#print "------", parent[4 SUBSEP 5], parent[parent[4 SUBSEP 5]]
		f = f_cost[item]+1
		for(i in star){
			if(i in closed && (i in f_cost && f > f_cost[i]) ){
				#print "closed", i
				continue
			}
			if((i in queue) ==0 && f > f_cost[i] ){
				#print "step to i", item, "->", i
				queue[i]=1
				parent[i]=item
				f_cost[i]=f
			} else {
				if(f < f_cost[i]){
					#print "beat the cost", item, "->", i
					parent[i]=item
					f_cost[i]=f
					delete closed[i]
					queue[i]=1
				} else if (f == f_cost[i]){
					#print "considering", item, "to ", i
					#print "tie with the path from", parent[i]
					#print item, parent[i]
					split(item,i_pos,SUBSEP)
					split(parent[i],p_pos,SUBSEP)
					if (i_pos[1] < p_pos[1]  || (i_pos[1] == p_pos[1] && i_pos[2] < p_pos[2])){
					#if( item < parent[i]){
						parent[i]=item
						f_cost[i]=f
					}
					#print "choosing", parent[i]
				}
			}
		}
	}
}
function race(char_id){
	if(char_id in char["G"]["loc"]){
		self="G"
		enemy="E"
	} else if(char_id in char["E"]["loc"]) {
		self = "E"
		enemy="G"
	} else {
		print "bad race"
		print ".",char_id
		exit
	}
	return self SUBSEP enemy
}
function turn(char_id, temp){
	#print "turn char", character
	temp = race(char_id)
	self = substr(temp,1,1)
	enemy = substr(temp,3,1)
	if((char_id in char[self]["loc"]) == 0 || char[self]["loc"][char_id] == ""){
		print "char_id error"
		print char_id, self, enemy
		printa(char["G"]["loc"])
		exit
	}
	mypos = char[self]["loc"][char_id]
	if(mypos=="") {
		print "error mypos"
		print char_id
		print self
		printa( char[self]["loc"])
		exit
	}
	#print "starting turn for:",self, mypos
	#print_map(data_out)
	if(length(char[enemy]["loc"]) == 0){
		return mypos
	}
	delete a_list
	delete r_list
	prep_move(char_id,a_list,r_list)
	if(length(a_list) == 0){
		delete queue
		delete mapping
		delete steps
		b_star(mypos,r_list,queue,mapping,steps)

		for(i in mapping){
			if( (i in r_list)==0)
			delete mapping[i]
		}
		asorti(mapping,mapping_s,"@val_num_asc")
		if(length(mapping)==0){
			#print char_id, "can't move"
			return mypos
		}
		#printa(steps)
		fewest = mapping[mapping_s[1]]
		for(i in mapping){
			if(mapping[i]!=fewest) delete mapping[i]
		}
		delete mapping_new
		for(i in mapping){
			split(i,pos,SUBSEP)
			#print(pos[1],"-",pos[2])
			mapping_new[i]=pos[1]*100 + pos[2] # Hack to do reading order
		}
		asorti(mapping_new,mapping_s,"@val_num_asc")
		#printa(mapping_s)
		target = mapping_s[1]
		#print "target", target
		while(steps[target] != mypos){
			target = steps[target]
			#printa(mapping)
			#print(length(mapping))
			#printf "path to self(%s): %s\n", mypos , target
		}
		#printf "%s moves from %s to %s\n", char_id, mypos, target 
		#for(i in mapping){
		#	split(i,pos,SUBSEP)
		#	data_out[pos[1]][pos[2]]=mapping[i] % 10
		#}
		#printa(mapping)
		#print mypos
		#print_map(data_out)
		#print "**** next"
		#render(data_out)
		return target
	}
	#printa(steps)
	
	#printf "%s staying put at %s\n", char_id, mypos 
	return mypos

}
function print_map(data){
	system("tput home")
	for(j=1;j<=max_y;j++){
		for(i=1;i<=max_x;i++){
			printf "%s", data[j][i]
		}
		print ""
	}
}
function render(data_out,pos,i){
	delete data_out
	for(j=1;j<=max_y;j++)
		for(i=1;i<=max_x;i++)
			data_out[j][i]=data[j][i]
	for(i in char["G"]["loc"]){
		split(char["G"]["loc"][i],pos,SUBSEP)
		data_out[pos[1]][pos[2]] = "G"
	}
	for(i in char["E"]["loc"]){
		split(char["E"]["loc"][i],pos,SUBSEP)
		data_out[pos[1]][pos[2]] = "E"
	}
}

END {
	system("clear")
	max_y=NF
	max_x=length($0)
	print "END"
	render(data_out)
	print_map(data_out)

	for(q=0;q<100;q++){
		#getline < "-"
		delete t_list
		render(data_out)
		print_map(data_out)
		#printa(data_out[1])
		generate_turn_queue(data_out,t_list)

		for(character_ind in t_list){
			# check if died
			if((t_list[character_ind] in hitpoints)==0 || hitpoints[t_list[character_ind]] <=0 ) continue
			render(data_out)
			#print "t_list"
			#printa(t_list)
			#render(data_out)
			#print_map(data_out)
			character = t_list[character_ind]
			#printa(t_list)
			#print "race character", character
			r=substr(race(character),1,1)
			e=substr(race(character),3,1)
			oldpos = char[r]["loc"][character]
			split(oldpos,oldposa,SUBSEP)
			movement = turn(character)
			if(length(movement) < 3){
				print "movement error"
				exit
			}
			char[r]["loc"][character] = movement
			split(movement,pos,SUBSEP)
			y = pos[1]
			x = pos[2]
			#print "oldpos:", oldposa[1]
			delete char[r]["id"][oldposa[1]][oldposa[2]]
			#print "length: ", (length(char[r]["id"][oldposa[1]]))
			if(length(char[r]["id"][oldposa[1]]) == 0){
				#print "vacating", oldposa[1]
				delete char[r]["id"][oldposa[1]]
			}
			char[r]["id"][y][x] = character

			attack(character,r,e,a_list,data_out)

		}

		if( length(char["E"]["loc"])==0  || length(char["G"]["loc"])==0 ){
			print "combat over"
			render(data_out)
			print_map(data_out)
			printa(hitpoints)
			for(h in hitpoints)
				sum+=hitpoints[h]
			print (q) * sum
			print q
			exit
		}
				
		render(data_out)
		print_map(data_out)
		#printa(hitpoints)
		print "after turn ^^^^:", q+1
    }
	print "done"
}
function attack(char_id,r,e,a_list,data_out  ,i, pos, e_pos, fewest, fewest_ind){
	if(hitpoints[char_id]<=0) return
	adjacent(data_out,a_list,char[r]["loc"][char_id],e)
	if(length(a_list)==0) return
	#printa(a_list)
	
	delete h_list
	for(i in a_list){
		split(i,pos,SUBSEP)
		e_id = char[e]["id"][pos[1]][pos[2]]
		if(hitpoints[e_id]>0)
			h_list[pos[1],pos[2]] = hitpoints[e_id]

	}
	if(length(h_list)==0) return
	#printa(h_list)
	asorti(h_list,h_list_s,"@val_num_asc")
	fewest_ind=1
	fewest = h_list[h_list_s[fewest_ind]]
	#print fewest
	for(i in h_list){
		if(h_list[i]!=fewest) delete h_list[i]
	}

	###
	delete h_list_new
	for(i in h_list){
		split(i,pos,SUBSEP)
		h_list_new[i]=pos[1]*100 + pos[2] # Hack to do reading order
	}
	#asorti(h_list_new,h_list_s,"@val_num_asc")
	######

	asorti(h_list_new,h_list_s,"@val_num_asc")
	selected_pos = h_list_s[1]
	#print selected_pos
	split(selected_pos,e_pos,SUBSEP)
	selected = char[e]["id"][e_pos[1]][e_pos[2]]
	#print selected
	
	new_hit = hitpoints[selected] - power[char_id]
	hitpoints[selected] = new_hit
	for(character in hitpoints){
		if(hitpoints[character]<=0){
			print character, "died"
			r=substr(race(character),1,1)
            print r, "has died", test
			split( char[r]["loc"][character],pos,SUBSEP)
			delete char[r]["id"][pos[1]][pos[2]]
			delete char[r]["loc"][character]
			delete hitpoints[character]
			data[pos[1],pos[2]]="."
			render(data_out)
			print_map(data_out)
		}
	}
	#printa(hitpoints)

	#render(data_out)
	#print_map(data_out)
}
function a_star(pos,d, queue){
	g_cost[pos]=0
	h_cost[pos] = h_cost_func(pos,d)
	f_cost[pos] = g_cost[pos] + h_cost[pos]
	queue[pos] = f_cost[pos]

	while(length(queue)!=0){
		asorti(queue,fs,"@val_num_asc")
		for(i in fs) print "queue", i, fs[i]
		closed[fs[1]]=1
		delete queue[fs[1]]
		if (fs[1]==d){
			print "reached", fs[1]
			print ".", f_cost[fs[1]]
			return f_cost[fs[1]]
		}
		print "fs:", fs[1]

		adjacent(data_out,star,pos,".")	
		for(i in star){
			if(i in closed){
				print "closed", i
				continue
			}
			g = g_cost[fs[1]]+1
			if((i in queue) ==0){
				print "step to i", i
				queue[i]=1
				parent[i]=fs[1]
				g_cost[i]=g
				h_cost[i]=h_cost_func(i,d)
				f_cost[i]=g_cost[i]+h_cost[i]
			} else {
				if(g < g_cost[i]){
					parent[i]=fs[1]
					g_cost[i]=g
					h_cost[i]=h_cost_func(i,d)
					f_cost[i]=g_cost[i]+h_cost[i]
				}
			}
		}

	}
}
