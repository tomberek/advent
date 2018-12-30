function printh(thehash, temp, i,is,b){
    temp = ""
    asorti(thehash,is,"@ind_num_asc")
    for(b in is){
        i = is[b]
        temp = temp tohex(thehash[i])
        #temp = temp int(thehash[i] / 16) (thehash[i] %16)
    }
    return temp
}
function loadstr(str,out, temp, i, l){
    delete out
    l = length(str)
    for(i=1;i<=l;i++){
        temp = ord(substr(str,i,1))
        if (temp < 0) {
            temp +=256
        }
        out[i] = temp
    }
    out[l+1]=17
    out[l+2]=31
    out[l+3]=73
    out[l+4]=47
    out[l+5]=23
}
function compact(list, thehash, i, j, value, temp){
    delete thehash
    for(i=1;i<=16;i++){
        temp = 0
        for(j=1;j<=16;j++){
            value = ord(substr(list,((i-1)*16+j),1))
            if(value < 0 ) value +=256
            temp = xor(temp,value)
        }
        thehash[i]=temp
    }
}
function hash64(list,revs, i){
    skip=0
    cur=0
    for(i=0;i<64;i++){
        list = hash(list,revs)
    }
    return list
}
function hash(list,revs,size, len,i,pre,post,count ) {
    size=length(list)
    total_length=length(revs)
    count = 0
    while(count++<total_length){
        len = revs[count]

        pre = substr(list,1,cur)
        post = substr(list,cur+1,size-cur)
        list = post pre
        for(i=1;i<=length(list);i++){
            temp = ord(substr(list,i,1))
            if(temp < 0) temp += 256
        }
        pre = substr(list,1,len)
        post = substr(list,len+1,size)
        temp = ""
        for (i=1;i<=len;i++){
            temp = substr(pre,i,1) temp
        }
        list = temp post
        for(i=1;i<=length(list);i++){
            temp = ord(substr(list,i,1))
            if(temp < 0) temp += 256
        }

        pre = substr(list,size-cur+1,size)
        post = substr(list,1,size-cur)
        list = pre post
        for(i=1;i<=length(list);i++){
            temp = ord(substr(list,i,1))
            if(temp < 0) temp += 256
        }
        cur = (cur + revs[count] + skip  ) % size
        skip++
    }
    return list

}
function tohex(num,l,r){
    l = int(num/16)
    r = int(num%16)
    if (l > 9) l = chr(ord("a") + l - 10)
    if (r > 9) r= chr(ord("a") + r - 10)
    return l r

}
