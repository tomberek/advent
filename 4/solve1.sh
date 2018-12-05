#!/bin/sh
# Trick to allow this file to be self contained as a polyglot shell and awk script
true = 0 # Remove warnings
true + /; exec -a "$0" gawk --lint -f "$0" -- "$@"; / { }

# BEGIN rule(s)

BEGIN {
}

# Rule(s)

match($0, /(.*)Guard \#([0-9]*) (.*)$/, arr) {
	new = arr[1] "Guard #" arr[2] " " arr[3]
	$0 = new
}

match($0, /Guard \#([0-9]*) /, arr) {
	cur = arr[1]
}

match($0, /\[.* \w{2}:(\w{2})\] f/, arr) {
	start2 = arr[1]
}

match($0, /\[.* \w{2}:(\w{2})\] w/, arr) {
	end = arr[1]
	guards[cur] += end - start2
	for (i = 0; i < start2; i++) {
		printf "%s", "."
	}
	for (i = start2; i < end; i++) {
		times[cur][i] += 1
		printf "%s", "#"
	}
	for (i = end; i < 61; i++) {
		printf "%s", "."
	}
	print "|" guards[cur] "|" cur "|" start2 "|" end
}

# END rule(s)

END {
	n = asorti(guards, guards_sorted, "@val_num_desc")
	for (i = 1; i <= 3; i++) {
		print "lazy: " guards_sorted[i] " - " guards[guards_sorted[i]] "- " i
	}
	max = 0
	lazy = guards_sorted[1]
	n = asorti(times[lazy], result, "@val_num_desc")
	print "laziest: " lazy "-" result[1] "-" times[lazy][result[1]]
	print 44 * 3203
	max = 0
	for (current in times) {
		for (t in times[current]) {
			temp = times[current][t]
			if (temp >= 15) {
				print "new max: " current "-" t "-" temp
				lazy = current
				max = temp
			}
		}
	}
	print 1601 * 32
	exit 
}

