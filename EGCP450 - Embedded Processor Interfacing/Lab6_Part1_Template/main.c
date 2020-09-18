#include <stdint.h>
#include "LCD.h"
#include "SysTick.h"

void main()
{
    uint32_t wait_1s = 3000000;

    LCD_Init();

    // A
    //LCD_OutChar(0x41);
    //SysTick_Wait(wait_1s);      // Wait 1s

    // B
    //LCD_OutChar(0x42);
    //SysTick_Wait(wait_1s);      // Wait 1s

    // C
    //LCD_OutChar(0x43);
    //SysTick_Wait(wait_1s);      // Wait 1s

    // Move cursor to the 2nd line
    //LCD_OutCmd(0xC0);

    // 1
    //LCD_OutChar(0x31);
// SysTick_Wait(wait_1s);      // Wait 1s

    // 2
    //LCD_OutChar(0x32);
    //SysTick_Wait(wait_1s);      // Wait 1s

    // 3
    //LCD_OutChar(0x33);
    //SysTick_Wait(wait_1s);

    LCD_OutString("Yeet");
    SysTick_Wait(wait_1s);

    LCD_OutUDec(0xFF);
    SysTick_Wait(wait_1s);

    LCD_OutCmd(0xC0);

    LCD_OutUHex(0xFF);
    SysTick_Wait(wait_1s);

    LCD_OutUFix(0xFF);

    while(1);                   // Main loop
}
