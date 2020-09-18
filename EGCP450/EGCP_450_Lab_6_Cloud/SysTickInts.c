// SysTickInts.c
// Runs on MSP432
// Use the SysTick timer to request interrupts at a particular period.
// Daniel Valvano, Jonathan Valvano
// June 1, 2015

/* This example accompanies the books
   "Embedded Systems: Introduction to MSP432 Microcontrollers",
   ISBN: 978-1469998749, Jonathan Valvano, copyright (c) 2015
   Volume 1 Program 9.7

 Copyright 2015 by Jonathan W. Valvano, valvano@mail.utexas.edu
    You may use, edit, run or distribute this file
    as long as the above copyright notice remains
 THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
 OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
 VALVANO SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL,
 OR CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
 For more information about my classes, my research, and my books, see
 http://users.ece.utexas.edu/~valvano/
 */

#include <stdint.h>
#include "Sound.h"
#include "DAC.h"
#include "msp432p401r.h"
void DisableInterrupts(void); // Disable interrupts
void EnableInterrupts(void);  // Enable interrupts
long StartCritical (void);    // previous I bit, disable interrupts
void EndCritical(long sr);    // restore I bit to previous value
void WaitForInterrupt(void);  // low power mode

const uint8_t wave[32] = {
 8,9,11,12,13,14,14,15,15,15,14,
 14,13,12,11,9,8,7,5,4,3,2,
 2,1,1,1,2,2,3,4,5,7}; 

uint32_t index;
// **************SysTick_Init*********************
// Initialize SysTick periodic interrupts
// Input: interrupt period
//        Units of period are 333ns (assuming 3 MHz clock)
//        Maximum is 2^24-1
//        Minimum is determined by length of ISR
// Output: none
volatile uint32_t Counts;

void SysTick_Init(uint32_t period) {
	long sr = StartCritical();
    
    index = 0;
	Counts = 0;

	SysTick->CTRL = 0;                   // disable SysTick during setup
	SysTick->LOAD = period - 1;          // maximum reload value
	SysTick->VAL = 0;                    // any write to current clears it
	SCB->SHP[3] = (SCB->SHP[3]&0x00FFFFFF)|0x40000000;	// priority 2
	SysTick->CTRL = 0x00000007;          // enable SysTick with no interrupts

	EndCritical(sr);
}
void SysTick_Handler(void){
	//increment to next value of the wave
	if (Piano_in() == 0x00)
	{
	    Sound_play(0x00);
	}
	
	 index = (index + 1)&(0x0F);
	 uint32_t arrayI = wave[index];
     DAC_output(arrayI);
	
	
	
    
}
