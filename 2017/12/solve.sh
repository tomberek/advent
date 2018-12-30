BEGIN {
	print "start"
	FPAT="([0-9]+)"
}
{
	for(ind=2;ind<=NF;ind++){
		data[$ind] = $1
		datar[$1] = datar[$1] sep[$1] $ind ; sep[$1]=SUBSEP
	}
}

function connected(i,visited, q, queue){
	delete visited
	split(datar[i],q,SUBSEP)
	for(i in q) queue[q[i]] = 1
	while ( length(queue) != 0 ){
		for (i in queue){
			if (i in visited){
				delete queue[i]
				break
			}
			split(datar[i],q,SUBSEP)
			for(j in q) {
				if ((q[j] in visited) == 0 )
					queue[q[j]] = 1
			}
			
			delete queue[i]
			visited[i] = 1
		}
	}
}
END {
	groups = 0
	while(length(datar) != 0 ) {
		for(ind in datar) break
		connected(ind,visit)
		for(ind in visit)
			delete datar[ind]
		print length(visit), "-" length(datar)
		groups++

	}
	print groups
}

# vim: set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab : #
