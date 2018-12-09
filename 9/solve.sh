{
	delete scores
	delete nex
	delete prev
	delete current_marble
	t = 0
	current_marble[t] = 0
	nex[0] = 0
	prev[0] = 0
	players = $1
	for (i = 0; i <= players; i++) {
		scores[i] = 0
	}
	player = 0
	current = 0
	while (t++ <= $2 * 1) {
		if (NR == 1) {
			print_table(t - 1)
		}
		player = (player++ % players) + 1
		if (t % 23 == 0 && t > 0) {
			for (i = 1; i <= 8; i++) {
				current = prev[current]
			}
			before_removal = current
			removed = nex[before_removal]
			after_removed = nex[removed]
			nex[before_removal] = after_removed
			prev[after_removed] = before_removal
			delete prev[removed]
			delete nex[removed]
			scores[player] += t + removed
			current_marble[t] = current = after_removed
		} else {
			before_add = nex[current]
			after_add = nex[before_add]
			nex[before_add] = t
			nex[t] = after_add
			prev[t] = before_add
			prev[after_add] = t
			current_marble[t] = current = t
		}
	}
	find_score()
	print ""
}


function find_score(_scores, _max, _i)
{
	#asorti(scores, _scores, "@val_num_desc")
	_max = 0
	for (_i in scores) {
		_max = scores[_i] > _max ? scores[_i] : _max
	}
	printf "%10d ", _max
}

function print_table(_t, _i, _hold)
{
	find_score()
	printf "[%d] ", player
	delete _hold
	_i = 0
	while ((_i in _hold) == 0) {
		_hold[_i] = 1
		if (current_marble[_t] == _i) {
			system("tput cub1")
			system("tput bold")
			printf "(%2d)", _i
			system("tput sgr0")
		} else {
			printf "%2d ", _i
		}
		_i = nex[_i]
	}
	printf "\n"
}
