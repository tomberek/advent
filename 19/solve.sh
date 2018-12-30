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
    FPAT="([a-z]*)|([0-9]+)"
	OFS=" "
    inst_p = 0
}
/#ip /{
    FS=" "
    $0 = $0
    inst_reg = $2
    FPAT="([a-z]*)|([0-9]+)"
}
! /#ip /{ 
    program[inst_p]=$0
    inst_p++
}
END{
    i = 1
    n = 10551408
    sum = 0
    while (i <= n){  
        if (n % i==0){
            print i
            sum += i
        }
        i = i + 1
    }
    print sum
    exit
	FS=" "

    print "#ip", inst_reg
    for( i in program) {
        print i, program[i]
    }
	r[0] = r0[0] = 0
	r[1] = r0[1] = 0
	r[2] = r0[2] = 0
	r[3] = r0[3] = 0
	r[4] = r0[4] = 0
	r[5] = r0[5] = 0

    #printa(r)
    #printa(program)

    count=0
    mod = 100
    while( count < 2000000000000 && r[inst_reg] in program ){
        $0=program[r[inst_reg]]
        i = $1
        @i()
        r[inst_reg] += 1
        if(count % mod == 0){
            print "count",count
            printa(r)
            print r[inst_reg]
            print program[r[inst_reg]]
            getline amt < "-"
            if (amt != "") mod = amt
        }
        if(0 && count % 10000 == 0 ){
            #print "count",count
            if(count > 10000 && r[3]>r[2]){
                count +=10000
                count -= 1
                r[2] += 1250
            }
            #printa(r)

        }
        count++
    }
    print count
    printa(r)
    print "exit"
}

function seti(){ 
    #r[$3] = r[inst_reg]
    r[$4] = $2
    #r[inst_reg] = r[$3]
}
function setr(){
    #r[$3] = r[inst_reg]
    r[$4] = r[$2]
    #r[inst_reg] = r[$3]
}
#function seti(){ r[$4] = $2 }

function addr(){ r[$4] = r[$2] + r[$3] }
function addi(){ r[$4] = r[$2] + $3 }
function mulr(){ r[$4] = r[$2] * r[$3] }
function muli(){ r[$4] = r[$2] * $3 }
function banr(){ r[$4] = and(r[$2] , r[$3]) }
function bani(){ r[$4] = and(r[$2] , $3) }
function borr(){ r[$4] = or(r[$2] , r[$3]) }
function bori(){ r[$4] = or(r[$2] , $3) }
function gtir(){ r[$4] = $2 > r[$3] ? 1 : 0 }
function gtri(){ r[$4] = r[$2] > $3 ? 1 : 0 }
function gtrr(){ r[$4] = r[$2] > r[$3] ? 1 : 0 }
function eqir(){ r[$4] = $2 == r[$3] ? 1 : 0 }
function eqri(){ r[$4] = r[$2] == $3 ? 1 : 0 }
function eqrr(){ r[$4] = r[$2] == r[$3] ? 1 : 0 }
