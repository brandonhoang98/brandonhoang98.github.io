/*
 * Piano.c
 *
 *  Created on: Oct 28, 2019
 *      Author: ee-student
 */
#include "Piano.h"
#include "Sound.h"
#include "msp432p401r.h"
const uint32_t C = 358;
const uint32_t D = 319;
const uint32_t E = 284;

void Piano_init(void){
    P5->SEL0 = 0x00;
    P5->SEL1 = 0x00;
    P5->DIR &= ~0x07;

}

void PORT5_IRQHandler(){
    P5->IFG &= ~0x07;
    uint32_t input = Piano_in();
    if (input == 0x01)
    {
        Sound_play(C);
    }
    else if (input == 0x02)
    {
        Sound_play(D);
    }
    else if (input == 0x04)
    {
        Sound_play(E);
    }
    else
    {
    }
    P5->IE |= 0x07;
    
}

long Piano_in(void){
    uint32_t output = P5->IN&0x07;
    return output;
}

