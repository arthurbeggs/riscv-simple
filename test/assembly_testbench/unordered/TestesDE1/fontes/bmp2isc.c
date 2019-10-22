/* ********************************************************************** *
file: bmp2isc.c
uso: bmp2isc file <.bmp .s>
Exemplo: bmp2isc display
Converte imagem display.bmp em arquivo display.s para carregar no segmento de
dados Marcus Vinicius Lamar - 27/03/2019 2019-1
* ********************************************************************** */

#include <float.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

static unsigned char *texels; // Sempre ensinamos a voc�s a n�o usar vari�veis globais...
static int width, height;

void readBmp(char *filename) {
    FILE *fd;
    fd = fopen(filename, "rb");
    if (fd == NULL) {
        printf("Error: fopen failed\n");
        return;
    }

    unsigned char header[54];

    // Read header
    fread(header, sizeof(unsigned char), 54, fd);

    // Capture dimensions
    width = *(int *)&header[18];
    height = *(int *)&header[22];

    int padding = 0;

    // Calculate padding
    while ((width * 3 + padding) % 4 != 0) {
        padding++;
    }

    // Compute new width, which includes padding
    int widthnew = width * 3 + padding;

    // Allocate memory to store image data (non-padded)
    texels = (unsigned char *)malloc(width * height * 3 * sizeof(unsigned char));
    if (texels == NULL) {
        printf("Error: Malloc failed\n");
        return;
    }

    // Allocate temporary memory to read widthnew size of data
    unsigned char *data = (unsigned char *)malloc(widthnew * sizeof(unsigned int));

    // Read row by row of data and remove padded data.
    int i, j;
    for (i = 0; i < height; i++) {
        // Read widthnew length of data
        fread(data, sizeof(unsigned char), widthnew, fd);

        // Retain width length of data, and swizzle RB component.
        // BMP stores in BGR format, my usecase needs RGB format
        for (j = 0; j < width * 3; j += 3) {
            int index = (i * width * 3) + (j);
            texels[index + 0] = data[j + 2];
            texels[index + 1] = data[j + 1];
            texels[index + 2] = data[j + 0];
        }
    }

    free(data);
    fclose(fd);
}

int main(int argc, char **argv) {

    // FILE *aout, *aoutbin;
    FILE *aouts; /* the bitmap file 24 bits */
    char name[30];
    int i, j, k, index;
    unsigned char r, g, b;

    if (argc != 2) {
        printf("Uso: %s file <.bmp .s>\nConverte um arquivo .bmp com 24 "
               "bits/pixel para .s para uso no segmento de dados\n",
               argv[0]);
        exit(1);
    }

    sprintf(name, "%s.bmp", argv[1]);
    readBmp(name);

    printf("size:%d x %d\n", width, height);

    /*    printf("\nMatrix = \n");
        for(i=0;i<10;i++)
        {
            for(j=0;j<10;j++)
            {
                index = (i * width * 3) + (j);
                printf("%02X%02X%02X\t",texels[index],texels[index+1],texels[index+2]);
            }
            printf("\n");
        }*/

    //    sprintf(name,"%s.mif",argv[1]);
    //   aout=fopen(name,"w");

    //    sprintf(name,"%s.bin",argv[1]);
    //    aoutbin=fopen(name,"wb");

    sprintf(name, "%s.s", argv[1]);
    aouts = fopen(name, "w");

    //   fprintf(aout,"DEPTH = %d;\nWIDTH = 32;\nADDRESS_RADIX =
    //   HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n",(width>>2)*height);

    fprintf(aouts, "%s: .word %d, %d\n.byte ", argv[1], width, height);

    int cont = 0;
    unsigned int hexi;
    unsigned char hex, rq, bq, gq;

    for (i = 0; i < height; i++) {
        //       fprintf(aout,"%05X : ",cont);
        for (j = 0; j < width; j++) {
            hexi = 0;
            //for (k = 0; k < 4; k++) {
                index = ((height - 1 - i) * width + (j /*  + k */)) * 3;
                r = texels[index + 0];
                g = texels[index + 1];
                b = texels[index + 2];

                rq = (unsigned char)round(7.0 * (float)r / (255.0));
                gq = (unsigned char)round(7.0 * (float)g / (255.0));
                bq = (unsigned char)round(3.0 * (float)b / (255.0));
                hex = bq << 6 | gq << 3 | rq;
                hexi = hexi | (unsigned int)(hex << (/* k * */ 8));
                /* if(cont<10) */ //printf("HEX=%d %d %d : %02X : %08X\n",bq,gq,rq,hex,hexi);

                if (hex == 0) {
                    //    fprintf(aout,"00");
                    fprintf(aouts, "0");
                } else {
                    //    fprintf(aout,"%02X",hex);
                    fprintf(aouts, "%d", hex);
                }

                if ((j/*  + k */) == width - 1) {
                    // fprintf(aout,";\n");
                    fprintf(aouts, ",\n");
                } else {
                    // if(k==3) fprintf(aout," ");
                    fprintf(aouts, ",");
                }
                //            fwrite(&hex,1,sizeof(unsigned char),aoutbin);
            //}

            //          fprintf(aout,"%08X",hexi);

            /*          if((j+k)==width)
                          fprintf(aout,";\n");
                      else
                          fprintf(aout," ");
            */
           /*  cont++; */
        }
    }
    //    fprintf(aout,"\nEND;\n");
    fprintf(aouts, "\n\n");
    //    fclose(aout);
    fclose(aouts);
    //    fclose(aoutbin);

    return (0);
}
