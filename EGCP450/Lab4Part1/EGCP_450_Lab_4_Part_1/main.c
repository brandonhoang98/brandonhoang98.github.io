#include <stdint.h>
#include "SysTick.h"
#include "msp432p401r.h"

struct State {
    uint32_t Out;
    uint32_t Time;
    const struct State *Next[4];
    uint32_t OutW;
};
typedef const struct State State_t;
#define goS &FSM[0]
#define waitS &FSM[1]
#define goW &FSM[2]
#define waitW &FSM[3]
#define walk &FSM[4]
#define walk1 &FSM[5]
#define walk2 &FSM[6]
#define walk3 &FSM[7]
#define walk4 &FSM[8]
#define walk5 &FSM[9]
#define walk6 &FSM[10]
#define walk7 &FSM[11]
#define walk8 &FSM[12]
#define walk9 &FSM[13]
#define walkUp &FSM[14]
#define goS1 &FSM[15]
#define goS2 &FSM[16]
#define waitS1 &FSM[17]
#define waitS2 &FSM[18]
#define goW1 &FSM[19]
#define goW2 &FSM[20
#define waitW1 &FSM[21]
#define waitW2 &FSM[22]

State_t FSM[23] = {
                  {0x21, 100, {goS, waitS, goS, waitS, goS1, waitS1, goS1, waitS1}, 0x01},
                  {0x22, 50, {goW, goW, goW, goW, goW1, goW1, goW1, goW1}, 0x01},
                  {0x0C, 100, {goW, goW, waitW, waitW, goW1, goW1, waitW1, waitW1}, 0x01},
                  {0x14, 50, {goS, goS, goS, goS, goS1, goS1, goS1, goS1}, 0x01},
                  {0x24, 100, {walk1, walk1, walk1, walk1, walk1, walk1, walk1, walk1}, 0x02},
                  {0x24, 10, {walk2, walk2, walk2, walk2, walk2, walk2, walk2, walk2}, 0x01},
                  {0x24, 10, {walk3, walk3, walk3, walk3, walk3, walk3, walk3, walk3}, 0x00},
                  {0x24, 10, {walk4, walk4, walk4, walk4, walk4, walk4, walk4, walk4}, 0x01},
                  {0x24, 10, {walk5, walk5, walk5, walk5, walk5, walk5, walk5, walk5}, 0x00},
                  {0x24, 10, {walk6, walk6, walk6, walk6, walk6, walk6, walk6, walk6}, 0x01},
                  {0x24, 10, {walk7, walk7, walk7, walk7, walk7, walk7, walk7, walk7}, 0x00},
                  {0x24, 10, {walk8, walk8, walk8, walk8, walk8, walk8, walk8, walk8}, 0x01},
                  {0x24, 10, {walk9, walk9, walk9, walk9, walk9, walk9, walk9, walk9}, 0x00},
                  {0x24, 10, {walkUp, walkUp, walkUp, walkUp, walkUp, walkUp, walkUp, walkUp}, 0x01},
                  {0x24, 10, {goS, goW, goS, goS, goS, goS, goS, goS}, 0x00},
				{0x21, 100, {goS, waitS, goS, waitS, goS2, waitS1, goS2, waitS1}, 0x01},
					{0x21, 100, {waitS2, waitS2, waitS2, waitS2, waitS2, waitS2, waitS2, waitS2}, 0x01},
					{0x22, 50, { goW, goW, goW, goW, goW2, goW2, goW2, goW2}, 0x01},
					{0x22, 50, { walk, walk, walk, walk, walk, walk, walk}, 0x01},
					{0x0C, 100 {goW, goW, waitW, waitW, goW2, goW2, waitW1, waitW1}, 0x01},
					{0x0C, 100, {waitW2, waitW2, waitW2, waitW2, waitW2, waitW2, waitW2, waitW2}, 0x01},
					{0x14, 50, { goS, goS, goS, goS, goS2, goS2, goS2, goS2}, 0x01},
					{0x14, 50, { walk, walk ,walk ,walk ,walk ,walk ,walk ,walk}, 0x01}
};
void main(void){
    State_t *Pt; //state pointer
    uint8_t Input;
    SysTick_Init();
    P2->SEL0 &= ~0x03;
    P2->SEL1 &= ~0x03;
    P2->DIR |= 0x03;
    P4->SEL0 &= ~0x3F;
    P4->SEL1 &= ~0x3F;
    P4->DIR |= 0x3F;
    P5->SEL0 &= ~0x07;
    P5->SEL1 &= ~0x07;
    P5->DIR &= ~0x07;
    Pt = goS;
    uint32_t Button;
    uint32_t WalkSet;
    while(1)
    {
        SysTick_Init();
        P4->OUT = (P4->OUT&~0x3F)|(Pt->Out);
        P2->OUT = (P2->OUT&~0x03)|(Pt->OutW);
        SysTick_Wait10ms(Pt->Time);
        Input = (P5->IN&0x07);
        Pt = Pt->Next[Input]; 

    }
}

