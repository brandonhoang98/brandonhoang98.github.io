/*
 * Piano.c
 *
 *  Created on: Oct 28, 2019
 *      Author: ee-student
 */
#include "Piano.h"
#include "Sound.h"
#include "msp432p401r.h"
const uint32_t A = 71;
const uint32_t B = 63;
const uint32_t C = 60;

void Piano_init(void){
    P5->SEL0 = 0x00;
    P5->SEL1 = 0x00;
    P5->DIR &= ~0x07;

}

void PORT5_IRQHandler(){
    P5->IFG &= ~0x07;
    uint32_t input = Piano_In();
    if (input == 0x01)
    {
        Sound_play(A);
    }
    else if (input == 0x02)
    {
        Sound_play(B);
    }
    else if (input == 0x04)
    {
        Sound_play(C);
    }
    else
    {
    }
    
}

uint32_t Piano_In(void){
    uint32_t output = P4->IN&0x07;
    return output;
}

