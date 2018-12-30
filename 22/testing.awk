BEGIN {
    push(1,"a")
    push(0,"b")
    push(2,"c")
    push(3,"d")
    print(pop())
    print(pop())
    print(pop())
    print(pop())
}
function push(thing, stuff, i){
    i = cnt++
    while (i > 0) {
        p = int((i - 1) / 2)
        if (heap[p] <= thing)
            break;
        heap[i] = heap[p]
        heapd[i]=heapd[p]
        i = p
    }
    heap[i] = thing
    heapd[i]=stuff
}
function pop(res, i){
#$1 == "pop" && cnt {
    i = 0
    res = heap[i]
    resd = heapd[i]
    #print heap[i]
    heap[i] = heap[--cnt]
    heapd[i] = heapd[cnt]

    while (heap[i] > heap[i * 2 + 1] ||
           heap[i] > heap[i * 2 + 2]) {
        if (cnt < i * 2 + 1)
            break;
        if (cnt < i * 2 + 2 ||
            heap[i * 2 + 1] < heap[i * 2 + 2]) {
            tmp = heap[i]
            heap[i] = heap[i*2+1]
            heap[i*2+1] = tmp

            tmp = heapd[i]
            heapd[i] = heapd[i*2+1]
            heapd[i*2+1] = tmp

            i = i * 2 + 1
        } else {
            tmp = heap[i]
            heap[i] = heap[i*2+2]
            heap[i*2+2] = tmp

            tmp = heapd[i]
            heapd[i] = heapd[i*2+2]
            heapd[i*2+2] = tmp

            i = i * 2 + 2
        }
    }
    return resd
}
