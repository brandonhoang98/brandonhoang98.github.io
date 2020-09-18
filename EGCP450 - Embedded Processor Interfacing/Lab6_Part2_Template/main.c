#include <stdint.h>
#include "SysTickInts.h"
#include "LCD.h"
#include "msp432p401r.h"
#include "ADC14.h"

uint32_t ADC_conversion(uint32_t input);

void main() {
    ADC0_InitSWTriggerCh0();
    LCD_Init();
    SysTick_Init(75000);

    while (1)
    {
        if (SysTick_MailFlag() == 1)
        {
            LCD_OutCmd(0x80);
            uint32_t output = SysTick_Mailbox();
            SysTick_ResetFlag();
            uint32_t final = ADC_conversion(output);
            LCD_OutUFix(final);
        }
    }
}

uint32_t ADC_conversion(uint32_t input)
{
    float factor = 6.5532;
    uint32_t output = input / factor;
    return output;
}

