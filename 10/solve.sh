match($0, /position=<([^,]*),([^>]*)> velocity=<([^,]*),([^>]*)>/, arr) {
	x[NR] = int(arr[1])
	y[NR] = int(arr[2])
	xv[NR] = int(arr[3])
	yv[NR] = int(arr[4])
}

END {
	count = 0
	success = ""
	while (count++ < 11000 && success == "") {
		step()
		print_if_small(count)
	}
}


function print_if_small(_count, _ymax, _xmax, _xmin, _ymin, data, _xs, _ys, n)
{
	asorti(x, _xs, "@val_num_desc")
	_xmax = x[_xs[1]]
	_xmin = x[_xs[NR]]
	asorti(y, _ys, "@val_num_desc")
	_ymax = y[_ys[1]]
	_ymin = y[_ys[NR]]
	if (_xmax - _xmin > 120 || _ymax - _ymin > 100) {
		return 0
	}
	for (n = 1; n <= NR; n++) {
		data[x[n]][y[n]] = n
	}
	print _count
	for (y_i = _ymin; y_i <= _ymax; y_i++) {
		for (x_i = _xmin; x_i <= _xmax; x_i++) {
			if ((x_i in data) && (y_i in data[x_i])) {
				printf "#"
			} else {
				printf "."
			}
		}
		printf "\n"
	}
	print "Press Enter to continue"
	getline success < "-"
}

function step(_n)
{
	for (_n = 1; _n <= NR; _n++) {
		x[_n] += xv[_n]
		y[_n] += yv[_n]
	}
}
