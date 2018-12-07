# BEGIN rule(s)
{
	arr[1] = $2
	arr[2] = $8
	data[arr[1]] = data[arr[1]] arr[2]
	datab[arr[2]] = datab[arr[2]] arr[1]
	print arr[1] ":-:" data[arr[1]]
}

END {
	FS = ""
	$0 = alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	result_1 = go(top, datab, data)
	print ""
}

END {
	$0 = alphabet
	delete completed
	while (length(result) < 26) {
		for (i = 1; i <= 15; i++) {
			if (worker[i, "job"] != "") {
				worker[i, "time"]++
				if (worker[i, "time"] == ord(worker[i, "job"]) - 3) {
					completed[worker[i, "job"]] = 1
					result = result worker[i, "job"]
					worker[i, "job"] = ""
					worker[i, "time"] = 0
				}
			}
		}
		for (i = 1; i <= 15; i++) {
			if (worker[i, "job"] == "") {
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
		for (i = 1; i < 15; i++) {
			printf "%1s-%2d ", worker[i, "job"], worker[i, "time"]
		}
		printf "\t::\t%d\t%s\n", t, result
		t += 1
	}
}

END {
	print "step 1: " result_1
	print "step 2: " result
}


function filter_queue(completed, present, i, out)
{
	for (i = 1; i <= NF; i++) {
		if (completed[$i] == 0 && present[$i] == 0) {
			present[$i] = 1
			out = out $i
		}
	}
	return out
}

function go(_top, _datab, _data, _completed, _result)
{
	$0 = filter_queue(_completed)
	print $0
	print "read"
	_result = ""
	while ($0 != "") {
		printf "%s", _top
		_result = _result _top
		completed[_top] = 1
		$0 = filter_queue(completed)
		_top = ready(_datab, _data, completed)
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
		split(_datab[$_i], _preqs, "")
		for (_j in _preqs) {
			if (_completed[_preqs[_j]] != 1) {
				_all = 1
			}
		}
		if (_all != 1) {
			return $_i
		}
		_all = 0
	}
	return "!"
}
