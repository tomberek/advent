function abs(x){
	if(x<0){
		return -1 * x
	}
	else{
		return x
	}
}
BEGIN {
	FPAT="([0-9]+)"
	max_scanner = 0
}
NR == FNR{
	for(ind=1;ind<=NF;ind++){
		sizes[$1]=$2
		scanner[$1]=0
		if ( $1 > max_scanner) max_scanner = $1
	}
}
END {
    steps = input_steps
	score = 1
	while(score != 0 && steps < input_steps + 999900000 ){
		steps++
		score = trial(steps)
		if(steps % 1000 == 0) print(": ", steps)
		if (score == 0){
			print("delay:", steps)
			exit
		}
	}
}
function trial(steps, sum){
	sum = 0
	start = 0
	advance(steps,sizes,scanner)
	while(start <= max_scanner){
		value = steps % (sizes[start] *2 -2 )
		value2 = sizes[start] -1 - abs( value - sizes[start] + 1)
		if(value2 == 0){
			#print "caught at: " start
			sum += start * sizes[start]
			return sum+1
		}
		#printf "%s", steps
		#printa(scanner)
		steps++
		start++
		advance(steps,sizes,scanner)
	}
	print("score:", sum)
	return sum
}
function advance(steps, sizes, scanner, i){
	for(i in scanner){
		steps_new = (steps ) % (sizes[i] * 2 - 2)
		scanner[i] = sizes[i] - 1 - abs( steps_new - sizes[i] + 1 )
	}
}
# vim: set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab : #
