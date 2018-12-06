function bitmap(filebmp,data,xstart,xend,ystart,yend,       row_size, width, height, total_size, row_pad,pad,i,j){
    #https://stackoverflow.com/questions/28834879/how-to-generate-2-pixel-bmp-image-with-awk
    # expects data values to be in RGB: r + g*256 + b*256*256
    row_size = int((24 * ( xend - xstart + 1) + 31)  / 32) * 4
    width = xend - xstart + 1
    height = yend - ystart + 1

    total_size = row_size * height # ( use abs if height is negative)
    total_size += 14 + 40

    row_pad = row_size - width*3
    pad = ""
    for(i=1;i<=row_pad;i++) pad = pad "\0"
    # BMP Header: 2+4+4+4=14 bytes
    ORS=""
    printf("%c%c",66,77)>filebmp;
    printf("%c",total_size % 256)>filebmp; total_size = int(total_size/256);
    printf("%c",total_size % 256)>filebmp; total_size = int(total_size/256);
    printf("%c",total_size % 256)>filebmp; total_size = int(total_size/256);
    printf("%c",total_size % 256)>filebmp; total_size = int(total_size/256);
    printf("%c%c%c%c",0,0,0,0)>filebmp;
    printf("%c%c%c%c",54,0,0,0)>filebmp;

    # DIB Header: 4+4+4+2+2+4+4+4+4+4+4=40 bytes
    printf("%c%c%c%c",40,0,0,0)>filebmp;
    printf("%c",width % 256)>filebmp; width = int(width/256);
    printf("%c",width % 256)>filebmp; width = int(width/256);
    printf("%c",width % 256)>filebmp; width = int(width/256);
    printf("%c",width % 256)>filebmp; width = int(width/256);
    printf("%c",height % 256)>filebmp; height = int(height/256);
    printf("%c",height % 256)>filebmp; height = int(height/256);
    printf("%c",height % 256)>filebmp; height = int(height/256);
    printf("%c",height % 256)>filebmp; height = int(height/256);
    printf("%c%c",1,0)>filebmp;
    printf("%c%c",24,0)>filebmp;
    printf("%c%c%c%c",0,0,0,0)>filebmp;
    printf("%c%c%c%c",0,0,0,0)>filebmp; # RGB size
    printf("%c%c%c%c",19,11,0,0)>filebmp; # Pixel/meter H
    printf("%c%c%c%c",19,11,0,0)>filebmp; # Pixel/meter W
    printf("%c%c%c%c",0,0,0,0)>filebmp;
    printf("%c%c%c%c",0,0,0,0)>filebmp;
    for (j=yend; j>=ystart; j--) {
        for (i=xstart; i<=xend; i++) {
            temp = data[i][j]
            printf("%c",temp % 256)>filebmp; temp = int(temp/256);
            printf("%c",temp % 256)>filebmp; temp = int(temp/256);
            printf("%c",temp % 256)>filebmp; temp = int(temp/256);
        }
        printf("%s",pad)>filebmp;
    }
    close(filebmp);
}
