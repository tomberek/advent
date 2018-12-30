@include "../utils.awk"
BEGIN {
    FS=""
    c=0;s=0
    count=0
}
/#/ {
exit
}
{ print NR "-1: " $0
}

/!/ && (a<1){
    a=2
};
a-- >=1 {
    next
}

{ print NR "-2: " $0 " " b}

(b==0) && /</{
    print "found <"
    b=1
    next
}
(b==1) && /[^>]/ {
    print "skipping " $0
    count++
    next
}
(b==1) && />/ {
  print "found >"
  b=0
  next
}

(b==0) { print NR "-3 " $0
  out=out $0
}

(b==0) && /{/{
    c++
}

(b==0) && /}/{
    s=s+c
    c--
}
END{
print out
print "Input score: " s
print count
}
