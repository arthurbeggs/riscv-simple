/* ********************************************************************** *
file: wav2oac.c
uso: wav2oac file <.wav .s>
Exemplo: wav2oac som
Converte um arquivo de áudio som.wav em arquivo som.s para carregar na memória 
de dados e tocar na DE1-SoC (o Rars não tem a funcionalidade)
Marcus Vinicius Lamar - 26/03/2019
2019-1
 * ********************************************************************** */

#include <stdio.h>
#include "wav.h"


int main(int argc, char** argv)
{
	FILE *aout;
	char name[30];
	int i;

	if(argc!=2)
	{
		printf("Uso: %s file <.wav .s>\nConverte um arquivo .wav para .s para incluir no segmento de dados\n",argv[0]);
		return(1);
	}

	sprintf(name,"%s.wav",argv[1]);
	
	int16_t *samples = NULL;
	wavread(name, &samples);
	int numsamples=header->datachunk_size>>1;
	
	printf("No. of channels: %d\n",     header->num_channels);
	printf("Sample rate:     %d\n",     header->sample_rate);
//	printf("Bit rate:        %dkbps\n", header->byte_rate*8 / 1000);
	printf("Bits per sample: %d\n",     header->bps);
	printf("Number of Samples: %d\n\n",   numsamples);
	
	sprintf(name,"%s.s",argv[1]);
	aout=fopen(name,"w");
	fprintf(aout,"%s: .word %d\n.half ",argv[1],numsamples);
	
	
	for (i=0;i < numsamples-1; i++)
	{
		fprintf(aout,"%d, ",samples[i]+32768);
//		if(header->num_channels==2)
//			fprintf(aout,"%d, ",samples[i+1]+32768);
	}
	fprintf(aout,"%d\n",samples[i]+32768);	

	fclose(aout);
	
  return 0;
}
