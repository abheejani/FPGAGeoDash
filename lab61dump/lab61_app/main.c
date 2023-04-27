/*
 * main.c
 *
 *  Created on: Mar 6, 2023
 *      Author: ThinkPad
 */

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x40; //make a pointer to access the PIO block
	volatile unsigned int *SW = (unsigned int*) 0x120;
	volatile unsigned int *RUN = (unsigned int*) 0x130;
	int accum = 0;

	*LED_PIO = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB
	}
	return 1; //never gets here

//	int doAcc = 0;
//
//	while ( (1+1) != 3)
//	{
//		if(*RUN == 1){ // if button hit, we want to actually start acc process
//			doAcc = 1;
//		}
//		while(*RUN == 0 && doAcc == 1) // when you take finger off, do the acc
//		{
//			accum += *SW;
//			*LED_PIO = accum;
//			doAcc = 0; // set the doacc to 0 beacuse we don't want to do anything until run pressed again
//		}
	//}
}
