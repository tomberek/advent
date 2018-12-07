# BEGIN rule(s)
{
	data[$2] = ($2 in data) ? data[$2] " " $8 : $8
	data[$2] = ($2 in data) ? data[$2] " " $8 : $8
	datab[$8] = ($8 in datab) ? datab[$8] " " $2 : $2
	print $2 ":-:" data[$2]
}

END {
	$0 = alphabet = "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
	result_1 = go(datab, data)
	print ""
}

END {
	$0 = alphabet
	result = ""
	t = 0
	while (length(result) < 26) {
		for (i = 1; i <= 5; i++) {
			if ((i, "job") in worker && worker[i, "job"] != "") {
				worker[i, "time"]++
				if (worker[i, "time"] == ord(worker[i, "job"]) - 3) {
					completed[worker[i, "job"]] = 1
					result = result worker[i, "job"]
					delete worker[i SUBSEP "job"]
					worker[i, "time"] = 0
				}
			}
		}
		for (i = 1; i <= 5; i++) {
			if ((i, "job") in worker == 0) {
				possible = ready(datab, data, completed)
				if (possible != "!") {
					worker[i, "job"] = possible
					worker[i, "time"] = 1
					in_progress[worker[i, "job"]] = 1
					$0 = filter_queue(in_progress)
					$0 = filter_queue(completed)
				}
			}
		}
		for (i = 1; i <= 5; i++) {
			temp_job = (i, "job") in worker ? worker[i, "job"] : " "
			temp_time = (i, "time") in worker ? worker[i, "time"] : " "
			printf "%1s-%2d ", temp_job, temp_time
		}
		printf "\t::\t%d\t%s\n", t, result
		t += 1
	}
}

END {
	print "step 1: " result_1
	print "step 2: " result
}


function filter_queue(_completed, _present, _i, _out)
{
	_out = ""
	for (_i = 1; _i <= NF; _i++) {
		if (($_i in _completed) == 0 && ($_i in _present) == 0) {
			_present[$_i] = 1
			_out = _out $_i " "
		}
	}
	return _out
}

function go(_datab, _data, _completed, _result)
{
	$0 = filter_queue(_completed)
	print "read"
	_result = ""
	_top = $1
	while ($0 != "") {
		printf "%s", _top
		_result = _result _top
		_completed[_top] = 1
		$0 = filter_queue(_completed)
		_top = ready(_datab, _data, _completed)
	}
	return _result
}

function ord(str, c)
{
	if (("a" in _ord_) == 0) {
		for (ind = 0; ind <= 255; ind++) {
			temp = sprintf("%c", ind)
			_ord_[temp] = ind
		}
	}
	return _ord_[substr(str, 1, 1)]
}

function ready(_datab, _data, _completed, _i, _j, _temp, _all, _preqs)
{
	for (_i = 1; _i <= NF; _i++) {
		_all = 0
		split(($_i in datab) ? _datab[$_i] : "", _preqs, " ")
		for (_j in _preqs) {
			if ((_preqs[_j] in _completed) == 0) {
				_all = 1
			}
		}
		if (_all != 1) {
			return $_i
		}
	}
	return "!"
}
