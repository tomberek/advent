#@include "../utils.awk"

function print_table(_t,   _i){
	#find_score()
	printf "[%d] ", player
	for(_i=1; _i<=NF; _i++){
		if (current_marble[_t]==_i-1) {
			printf "(%2d) ", $(_i)
		} else {
			printf " %2d  ", $(_i)
		}
	}
	printf "\n"
}
function find_score(_scores){
	asorti(scores,_scores,"@val_num_desc");
	printf "%6d ", scores[_scores[1]]
	print ""
}

function insert(_i,_marble,    _temp){
	for(_temp = NF-1; _temp >= _i; _temp--){
		$(_temp+2) = $(_temp+1)
	}
	$(_i+1) = _marble
	$1 = $1
}
function remove(_i,  _temp){
	for(_temp = _i; _temp <= NF-1; _temp++){
		$(_temp) = $(_temp+1)
	}
	$NF=""
	$0 = $0
}

function next_spot(_i){
	if (t==1) return 1
	return (_i + 1 ) % (NF ) + 1
}
BEGIN {
	t=0
	current_marble[t] = 0
	delete scores
	marble = 0
	players = 9
	player = 0
	$0 = "0"
	while ( t <= 25  ){
		print_table(t)
		t++
		player = (player++ % players) + 1

		if(t>1 && (t) % 23 == 0) {
			scores[player] += t
			spot = ((current_marble[t-1] -7 + NF) % NF) 
			#print "removed marble is: " spot+1 " " NF " " NF-spot "-" $(spot+1)
			scores[player] += $(spot+1)
			#if(NF-spot == 2)  print_table(t)
			remove(spot+1)
			#if(NF-spot == 2)  print_table(t)
			current_marble[t]=spot % (NF )
			#print ""
			#find_score()
		} else {
			temp = next_spot(current_marble[t-1])
			insert(temp,t)
			current_marble[t] = temp
		}
	}
	find_score()
}

#NR == FNR	&& match($0, /(\w)?.*/, arr) {
NR == FNR {
	next
}

{
	#print "input2"
}

END {
	print "end"
}

