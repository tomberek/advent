#@load "json"
@load "rwarray"
@include "../utils.awk"
@include "../color.awk"
BEGIN {
	list[0]=3
	list[1]=7
	i = 2
	alice = 0
	bob = 1
	input= 640441
	#input= 51589
	input2 = "59414"
	input2 = "01245"
	input2 = "92510"
	input2 = "51589"
	input2 = "640441"
	input3 = "5" SUBSEP "1" SUBSEP "5" SUBSEP "8" SUBSEP "9"
	len = length(input2)
	split(input2,tempa,"")

	extra = 10

	llen = length(list)
	while( llen < 100000 * input + extra) {
		alice = (alice + list[alice] + 1) % llen
		bob = (bob + list[bob] + 1) % llen

		temp =list[alice] + list[bob]
		if (temp < 10){
			list[i++] = int(temp)
			llen += 1
		}else {
			split(temp,arr,"")
			list[i++] = int(arr[1])
			list[i++] = int(arr[2])
			llen += 2
		}

		if(steps % 10000000 == 100 ) {
			len2 = length(list)
			t = join(list,0,len2,SUBSEP)
			out = index(t,input2) -1
			print substr(t,out-5,20)
			print out
			print "*******"
			#print t
			print steps
			print llen
			if (out > 0 ) {
				print "found"
				exit
			}
		}
		steps++
	}
	print "done"
	for(i=input;i<input+10;i++){
		printf "%s", list[i]
	}
	print ""
}

{
}
END {
    print "exit"
}

# vim: set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab : #
