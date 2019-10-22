
/**************************************************

file: demo_tx.c
purpose: simple demo that transmits characters to
the serial port and print them on the screen,
exit the program by pressing Ctrl-C

compile with the command: gcc demo_tx.c rs232.c -Wall -Wextra -o2 -o test_tx

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
  unsigned char i;
  int cport_nr=7,        /* usar o número da COM - 1 */
      bdrate=115200; 

  char mode[]={'8','N','2',0};

  if(RS232_OpenComport(cport_nr, bdrate, mode))
  {
    printf("Can not open comport\n");
    return(0);
  }

  while(1)
  {
    RS232_SendByte(cport_nr,i);

    printf("sent: %d\n", i);

#ifdef _WIN32
    Sleep(1000000);
#else
    usleep(1000);  /* sleep for 1 Second */
#endif

    i++;
	getchar();

//    i %= 2;
  }

  return(0);
}

