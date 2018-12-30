@include "../utils.awk"
#@include "../bitmap.awk"
BEGIN {
    print "hi"
    FS="\t"
    OFS="\t"
}

function bits2str(bits,        data, mask)
{
    if (bits == 0)
        return "0"

    mask = 1
    for (; bits != 0; bits = rshift(bits, 1))
        data = (and(bits, mask) ? "1" : "0") data

    while ((length(data) % 4) != 0)
        data = "0" data

    return data
}

function neighbor(x,y, i,j,sum)
{
    sum = 0
    for (i=-1;i<=1;i++)
        for (j=-1;j<=1;j++)
            sum += data[x+i][y+j]
    if (sum > 265149){
        print sum
        exit
    }
    return sum
}

END {
    delete data
    x = 0
    y = 0
    steps = 1;
    step_total = 1;
    count = 0
    dir = 0
    data[0][0]=1
    for (i=1;i<265149;i++){
        #data[x][y]=i
        data[x][y]=neighbor(x,y)
        switch (dir) {
        case 0:
            x++;
            break;
        case 1:
            y++;
            break;
        case 2:
            x--;
            break;
        case 3:
            y--;
            break;
        }
        steps--

        # 1 1 2 2 3 3 4 4 
        if (steps == 0){
            dir = (dir + 1) % 4
            count++
            if(count == 2){
                step_total++
                count = 0
            }
            steps = step_total
        }
    }
}
END {
    print x " " y
    print abs(x)+abs(y)
}
END{
    size=length(data)/2
    for(j=size;j>=-size;j--){
        for(i=-size;i<=size;i++)
            printf "%s\t", data[i][j]
        printf "\n"
    }
}

