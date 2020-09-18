/*
 * DAC.c
 *
 *  Created on: Oct 23, 2019
 *      Author: ee-student
 */
#include "DAC.h"
#include "msp432p401r.h"

void DAC_init(void) {
    DisableInterrupts();
    P6->SEL0 = 0x00;
    P6->SEL1 = 0x00;
    P6->DIR |= 0x0F;
    P6->IES &= ~0x03;
    P6->IFG &= ~0x03;
    P6->IE |= 0x03;

    NVIC->IP[10] = (NVIC->IP[10]&0xFFFFFF00)|0x00000040;
    NVIC->ISER[1] = 0x00000100;

    EnableInterrupts();
}

DAC_output(unsigned long data) {
    P6->OUT = (P6->OUT & ~0x0F) | (data & 0x0F);
}


