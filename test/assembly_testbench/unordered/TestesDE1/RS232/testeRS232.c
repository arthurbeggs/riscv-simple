
/**************************************************

file: testeRS232.c
Le um número (0 a 255) do teclado, envia e recebe um byte correspondente ao dobro do valor

compile com: gcc testeRS232.c rs232.c -Wall -Wextra -o2 -o testeRS232

**************************************************/

#include <stdlib.h>
#include <stdio.h>

#ifdef _WIN32
#include <Windows.h>
#else
#include <unistd.h>
#endif

#include "rs232.h"



int main()
{
  int i, n;
  int cport_nr=7,        /* usar o número da COM - 1 */
      bdrate=115200;

  unsigned char buf[4096],num;

  char mode[]={'8','N','2',0};


  if(RS232_OpenComport(cport_nr, bdrate, mode))
  {
    printf("Can not open comport\n");
    return(0);
  }


	while(1){
		// Envia um byte digitado
		printf("Digite Num:");
		scanf("%d",&num);
		RS232_SendByte(cport_nr,num);
		printf("Enviado: %d\n", num);

		Sleep(100);	
	
		// recebe n bytes no buffer (maximo 4096)
		n = RS232_PollComport(cport_nr, buf, 4096);
	
		if(n!=1)
			printf("Ops! %d\n",n);
		else
			printf("2*num: %d\n",buf[0]);

	}

  return(0);
}

