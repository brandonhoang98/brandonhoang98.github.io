#include <stdint.h>
#include "Sound.h"
#include "msp432p401r.h"
#include "SysTickInts.h"
#include "DAC.h"

//struct Note {
//    float amplitude;
//    float pitch;
//   uint32_t time;
//};

//typedef const struct Note Note_t;
void DisableInterrupts(void); // Disable interrupts
void EnableInterrupts(void);  // Enable interrupts

void Sound_init(void) {
    DisableInterrupts();
	DAC_init();
	SysTick_Init(0);
    P5->IES &= ~0x07;
    P5->IFG &= ~0x07;
    P5->IE |= 0x07;
	NVIC->IP[9] = (NVIC->IP[9]&0x00FFFFFF)|0x40000000;
	NVIC->ISER[1] = 0x00000080;

	EnableInterrupts();
}

void Sound_play(uint32_t input) {
	SysTick->LOAD = input - 1;
	SysTick->VAL = 0;                    // any write to current clears it
}
