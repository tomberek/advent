@include "../utils.awk"
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
BEGIN {
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
    r[0] = 0
    r[1] = 0    
    r[2] = 0
    r[3] = 0
}
{
    i = knownI[$1]
    print i
    @i()

}
END {
    printa(r)
}
