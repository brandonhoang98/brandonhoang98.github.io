#include <stdint.h>
#include "DAC.h"
#include "SysTickInts.h"
#include "Piano.h"
#include "Sound.h"
#include "msp432p401r.h"

void WaitForInterrupt(void);  // low power mode

void main(void){
    
    Piano_init();
    Sound_init();

    while(1) {
        WaitForInterrupt();        
    }
}
