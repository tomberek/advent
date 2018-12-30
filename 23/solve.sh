#@load "json"
@load "rwarray"
@include "../utils.awk"
@include "../color.awk"
@include "../utils.awk"
BEGIN {
    FPAT="(-?[0-9]+)"
    SUBSEP=","
    minx=99999999999999
    max=0
    miny=99999999999999
    maxy=0
    minz=99999999999999
    maxz=0
    OFS=":::"
}
{
    data[$2,$1,$3]=$4
    if($2<miny) miny=$2
    if($2>maxy) maxy=$2
    if($1<minx) minx=$1
    if($1>maxx) maxx=$1
    if($3<minz) minz=$3
    if($3>maxz) maxz=$3
}
END {
    #asorti(data,ind,"@val_num_desc")
    #pos = ind[1]
    #range = data[pos]
    #count=0
    #for(i in data){
    #    if( manhattan(pos,i) <= range){
    #        count++
    #    }
    #}
    #print pos,range
    #print count
    


    print count_in_range(43804862,47350438,19685812)
    print 43804862+47350438+19685812
    exit
    print "***** Part 2 *****"
    asorti(data,ind,"@val_num_asc")
    print(ind[1])
    print(data[ind[1]])

    ceny = int((maxy-miny)/2)
    cenx = int((maxx-minx)/2)
    cenz = int((maxx-minz)/2)

    step = 80 * 1000 * 1000
    step = 64 * 1024 * 1024
    resolution = step
    step = int(step/2)

    delete results
    delete resultsb
    search(results,resultsb,resolution,step,880,miny,maxy,minx,maxx,minz,maxz)

    asorti(resultsb,resultsb_s,"@val_num_desc")
    print(resultsb[resultsb_s[1]])
    best = resultsb[resultsb_s[1]]
    print "orig length:",(length(results))

    for(i in results){
        printf "%s, %s to %s\n",i,results[i],resultsb[i]
    }
    for(i in results){
        if(results[i] < best)
            delete results[i]
    }
    print "new length:",(length(results))

    while(iter++ < 30 ){
        resolution = int((resolution)/2)
        step = int((step) / 2)
        if(step == 0){
            print "step is zero"
            iter = 60
            resolution = 2
            step = 1
        }
        delete results2
        delete results2b
        for(i in results){
            split(i,arr,SUBSEP)
            miny=arr[1]-resolution
            maxy=arr[1]+resolution
            minx=arr[2]-resolution
            maxx=arr[2]+resolution
            minz=arr[3]-resolution
            maxz=arr[3]+resolution
            search(results2,results2b,0,step,best,miny,maxy,minx,maxx,minz,maxz)
        }
        asorti(results2b,results2_s,"@val_num_desc")
        print(results2b[results2_s[1]])
        best = results2b[results2_s[1]]
        print "orig length:",(length(results2)),best
        for(i in results2){
            if(results2[i] < best || results2[i] < 983)
                delete results2[i]
        }
        print "new length:",(length(results2))

        delete results
        for(i in results2){
            results[i]=results2[i]
            printf "%s, %s to %s\n",i,results[i],results2b[i]
        }
        print(length(results))
        print "iter",iter
        print "resolution",resolution
        print "step",step
        print "best",best
        writea("results.data",results)
        config["resolution"] = resolution
        config["step"] = step
        writea("config.data",config)
    }
    print "exit"
    exit
}
function count_in_range(j,i,z, n, man ,count){
    count = 0
    for(n in data){
        man = manhattan(n,j SUBSEP i SUBSEP z)
        if(man <= data[n]){
            count++
        }
    }
    return count
}
function search(results_best,results_worst,resolution,step,limit,miny,maxy,minx,maxx,minz,maxz, i,j,z,count){
    for(j=miny-resolution;j<maxy+resolution;j=j+step){
        for(i=minx-resolution;i<maxx+resolution;i=i+step){
            for(z=minz-resolution;z<maxz+resolution;z=z+step){
                count=0
                countb=0
                for(n in data){
                    man = manhattan(n,j SUBSEP i SUBSEP z)
                    if(man <= int( 3 * step) + data[n]){
                        count++
                    }
                    if(man <= data[n]){
                        countb++
                    }
                }
                # count is the best possible in resolution
                # countb is the min possible in resolution
                if(count > limit){
                    results_best[j SUBSEP i SUBSEP z]=count
                    results_worst[j SUBSEP i SUBSEP z]=countb
                }
            }
        }
    }
}
function manhattan(pos,pos1, arr,arr1, temp){
    split(pos,arr,SUBSEP)
    split(pos1,arr1,SUBSEP)
    temp = abs(arr1[1]-arr[1]) + abs(arr1[2]-arr[2]) + abs(arr1[3]-arr[3])
    return temp
}
