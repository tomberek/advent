
@load "ordchr"
@load "rwarray"
#@load "/nix/store/bn25s9fbvdyxfgl8c22xnr35jfzyf1n6-gawkextlib-unstable/lib/json.so"
function printa(source, level,count, i, j, source_i){
    printf "%s%s\n", level, "{"
    level = level "\t"
    asorti(source,source_i,"@ind_num_asc")
    for (j in source_i) {
        i = source_i[j]
        if (typeof(source[i]) == "array") {
            printf "%s%s :\n", level, i
            count += printa(source[i], level)
        } else {
            #dest[i] = source[i]
		    printf "%s%s :\t%s\n", level, i, source[i]
            count++
        }
    }
    level = substr(level,1,length(level)-1)
    printf "%s%s\n", level, "}"
    return count
}
function copy_array(dest, source,   i, count)
{
    delete dest
    for (i in source) {
        if (typeof(source[i]) == "array") {
            count += copy_array(dest[i], source[i])
        } else {
            dest[i] = source[i]
            count++
        }
    }
    return count
}
function join(_array, _start, _end, _sep,    _result, _i)
{
    if (_sep == "")
       _sep = " "
    else if (_sep == SUBSEP) # magic value
       _sep = ""
    _result = _array[_start]
    for (_i = _start + 1; _i <= _end; _i++)
        _result = _result _sep _array[_i]
    return _result
}
function rewind(    _i)
{
    # shift remaining arguments up
    for (_i = ARGC; _i > ARGIND; _i--)
        ARGV[_i] = ARGV[_i-1]

    # make sure gawk knows to keep going
    ARGC++

    # make current file next to get done
    ARGV[ARGIND+1] = FILENAME

    # do it
    nextfile
}

function readfile(file,     tmp, save_rs)
{
    save_rs = RS
    RS = "^$"
    getline tmp < file
    close(file)
    RS = save_rs

    return tmp
}

function abs(x){
    if(x < 0){
        return -x
    }
    return x
}
function round(x,   ival, aval, fraction)
{
   ival = int(x)    # integer part, int() truncates

   # see if fractional part
   if (ival == x)   # no fraction
      return ival   # ensure no decimals

   if (x < 0) {
      aval = -x     # absolute value
      ival = int(aval)
      fraction = aval - ival
      if (fraction >= .5)
         return int(x) - 1   # -2.5 --> -3
      else
         return int(x)       # -2.3 --> -2
   } else {
      fraction = x - ival
      if (fraction >= .5)
         return ival + 1
      else
         return ival
   }
}
function clamp(x,x_min,x_max){
    if(x < x_min){
        return x_min
    }
    if(x > x_max){
        return x_max
    }
    return x
}

function get_arrow(){
	printf "%s", "> "
	# GET ARROW INPUT
	cmd = "export escape_char=$(printf \"\\u1b\") ; read -rsn1 mode ; if [[ $mode == $escape_char ]]; then read -rsn2 mode ; fi ; case $mode in 'q') echo QUITTING ; exit ;; '[A') echo UP ;; '[B') echo DN ;; '[D') echo LEFT ;; '[C') echo RIGHT ;; *) >&2 echo 'ERR bad input' ;; esac"
	cmd | getline temp
	print temp
	close(cmd)
	return temp
	
	#while(0){
		#input = get_arrow()
		#switch(input){
		#case "RIGHT":
			#max_x+=1
			#break
		#case "LEFT":
			#max_x-=1
			#break
		#case "DN":
			#max_y+=1
			#break
		##case "UP":
			#max_y-=1
			#break
		#}
    #}
}

