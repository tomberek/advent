#@load "json"
@load "rwarray"
@include "../utils.awk"
@include "../color.awk"
@include "../utils.awk"
BEGIN {
	inst["addr"] = 1
	inst["addi"] = 1
	inst["mulr"] = 1
	inst["muli"] = 1
	inst["banr"] = 1
	inst["bani"] = 1
	inst["borr"] = 1
	inst["bori"] = 1
	inst["setr"] = 1
	inst["seti"] = 1
	inst["gtir"] = 1
	inst["gtri"] = 1
	inst["gtrr"] = 1
	inst["eqir"] = 1
	inst["eqri"] = 1
	inst["eqrr"] = 1
	inst["addr"] = 1

	known["eqir"] = 5
	known["gtrr"] = 13
	known["gtri"] = 8
	known["eqrr"] = 4
	known["eqri"] = 9
	known["gtir"] = 10
	known["banr"] = 15
	known["setr"] = 6
	known["bani"] = 1
	known["seti"] = 3
	known["borr"] = 11
	known["addr"] = 12
	known["mulr"] = 14
	known["addi"] = 2
	known["muli"] = 0
	known["bori"] = 7

	knownI[5 ] = "eqir"
	knownI[13] = "gtrr"
	knownI[8 ] = "gtri"
	knownI[4 ] = "eqrr"
	knownI[9 ] = "eqri"
	knownI[10] = "gtir"
	knownI[15] = "banr"
	knownI[6 ] = "setr"
	knownI[1 ] = "bani"
	knownI[3 ] = "seti"
	knownI[11] = "borr"
	knownI[12] = "addr"
	knownI[14] = "mulr"
	knownI[2 ] = "addi"
	knownI[0 ] = "muli"
	knownI[7 ] = "bori"
	#FS="\\[|,|\\]"
	#FPAT=".* \[([0-9]+), ([0-9]+), ([0-9]+), ([0-9]+)\]"
	FPAT="([0-9]+)"
	OFS=" "
}

{
	#print $0
}
/Before/ {
	before = $1 " " $2 " " $3 " " $4
	r[0] = r0[0] = $1
	r[1] = r0[1] = $2
	r[2] = r0[2] = $3
	r[3] = r0[3] = $4
}
!/Before|After|^$/{
	oper = $0
}
/After/ {
	result = $1 " " $2 " " $3 " " $4
	res[0] = $1
	res[1] = $2
	res[2] = $3
	res[3] = $4
}
/^$/{ 
	FS=" "
	count = 0
	for(i in inst){
		r[0] = r0[0]
		r[1] = r0[1]
		r[2] = r0[2]
		r[3] = r0[3]
		$0 = oper
		@i()
		resultReal = join(r,0,3," ")

		if( result == resultReal && (i in known)==0 ){
			count+=1
			#print $1 "."
			operation[$1][i]++
		}
	}
	if( count >= 3){
		sum++
	}
	FPAT="([0-9]+)"
	#if(NR > 100) exit
	next
}
END {
	for(i in operation){
		printf "%s\t", i
		for (j in operation[i]){
			printf "%s-%s\t", j, operation[i][j]
		}
		print ""
	}
	print "sum", sum
}

function addr(){ r[$4] = r[$2] + r[$3] }
function addi(){ r[$4] = r[$2] + $3 }
function mulr(){ r[$4] = r[$2] * r[$3] }
function muli(){ r[$4] = r[$2] * $3 }
function banr(){ r[$4] = and(r[$2] , r[$3]) }
function bani(){ r[$4] = and(r[$2] , $3) }
function borr(){ r[$4] = or(r[$2] , r[$3]) }
function bori(){ r[$4] = or(r[$2] , $3) }
function setr(){ r[$4] = r[$2] }
function seti(){ r[$4] = $2 }
function gtir(){ r[$4] = $2 > r[$3] ? 1 : 0 }
function gtri(){ r[$4] = r[$2] > $3 ? 1 : 0 }
function gtrr(){ r[$4] = r[$2] > r[$3] ? 1 : 0 }
function eqir(){ r[$4] = $2 == r[$3] ? 1 : 0 }
function eqri(){ r[$4] = r[$2] == $3 ? 1 : 0 }
function eqrr(){ r[$4] = r[$2] == r[$3] ? 1 : 0 }
