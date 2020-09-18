/*
 * DAC.c
 *
 *  Created on: Oct 23, 2019
 *      Author: ee-student
 */
#include "DAC.h"
#include "msp432p401r.h"


void DAC_init() {

    P4->SEL0 = 0x00;
    P4->SEL1 = 0x00;
    P4->DIR |= 0x0F;

}

void DAC_output(unsigned long data) {
    P4->OUT = (P4->OUT & ~0x0F) | (data & 0x0F);
}


