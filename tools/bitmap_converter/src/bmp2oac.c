///////////////////////////////////////////////////////////////////////////////
//                        Conversor de Bitmaps 24 bits                       //
//                                                                           //
// <arquivo>.mif é utilizado para inicializar a memória da FPGA              //
// <arquivo>.bin é uitlizado para inicializar a memória do simulador RARS    //
///////////////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <float.h>

#define MAN_MSG "\
%s - Conversor de Bitmaps 24 bits\n\
  Uso: %s <arquivo sem a extensão .bmp>\n\n\
  Saídas:\n\
     <arquivo>.mif: Arquivo de inicialização de memória da FPGA\n\
     <arquivo>.bin: Arquivo de inicialização de memória do simulador RARS\n\
"

static unsigned char *texels;
static int width, height;

void readBmp(char *filename){
    FILE *fd;
    fd = fopen(filename, "rb");
    if (fd == NULL){
        printf("Error: fopen failed\n");
        return;
    }

    unsigned char header[54];

    fread(header, sizeof(unsigned char), 54, fd);

    // Capture dimensions
    width = *(int*)&header[18];
    height = *(int*)&header[22];

    int padding = 0;

    // Calculate padding
    while ((width * 3 + padding) % 4 != 0){
        padding++;
    }

    // Compute new width, which includes padding
    int widthnew = width * 3 + padding;

    // Allocate memory to store image data (non-padded)
    texels = (unsigned char *)malloc(width * height * 3 * sizeof(unsigned char));
    if (texels == NULL){
        printf("Error: Malloc failed\n");
        return;
    }

    // Allocate temporary memory to read widthnew size of data
    unsigned char* data = (unsigned char *)malloc(widthnew * sizeof (unsigned int));

    // Read row by row of data and remove padded data.
    int i,j;
    for (i = 0; i<height; i++){
        // Read widthnew length of data
        fread(data, sizeof(unsigned char), widthnew, fd);

        // Retain width length of data, and swizzle RB component.
        // BMP stores in BGR format, my usecase needs RGB format
        for (j = 0; j < width * 3; j += 3){
            int index = (i * width * 3) + (j);
            texels[index + 0] = data[j + 2];
            texels[index + 1] = data[j + 1];
            texels[index + 2] = data[j + 0];
        }
    }

    free(data);
    fclose(fd);
}

int main(int argc, char** argv){
	FILE *aout, *aoutbin; /* the bitmap file 24 bits */
	char name[150];
    int i,j,index;
    unsigned char r,g,b;

    if(argc!=2){
        printf(MAN_MSG, argv[0], argv[0]);
        exit(1);
    }

    sprintf(name,"%s.bmp",argv[1]);
    readBmp(name);

	printf("size:%d x %d\n",width,height);

    sprintf(name,"%s.mif",argv[1]);
    aout=fopen(name,"w");

    sprintf(name,"%s.bin",argv[1]);
    aoutbin=fopen(name,"wb");

    fprintf(aout,"DEPTH = %d;\nWIDTH = 32;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n",width*height/4);

    int cont=0;
    unsigned char hex,rq,bq,gq;
    char endianess_correction = 3;

    for(i=0;i<height;i++){
        fprintf(aout,"%05X : ",cont/4);
        for(j=0;j<width;j++){
            index = ((height-1-i)*width + j + endianess_correction)*3;
            r=texels[index + 0];
            g=texels[index + 1];
            b=texels[index + 2];

            rq=(unsigned char)round(7.0*(float)r/(255.0));
            gq=(unsigned char)round(7.0*(float)g/(255.0));
            bq=(unsigned char)round(3.0*(float)b/(255.0));
            hex= bq<<6 | gq<<3 | rq;

            if(endianess_correction == -3) endianess_correction = 3;
            else endianess_correction -= 2;

            if(hex==0)  fprintf(aout,"00");
            else        fprintf(aout,"%02X",hex);

            if(j==width-1)          fprintf(aout,";\n");
            else if (j % 4 == 3)    fprintf(aout," ");

            fwrite(&hex,1,sizeof(unsigned char),aoutbin);
            cont++;
        }
    }
    fprintf(aout,"\nEND;\n");
    fclose(aout);
    fclose(aoutbin);

	return(0);
}

