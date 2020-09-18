
       .thumb

       .text
       .align  2
P4IN	.field 0x40004C21,32
P5IN	.field 0x40004C40,32

P4OUT	.field 0x40004C23,32
P5OUT	.field 0x40004C42,32

P4DIR	.field 0x40004C25,32
P5DIR	.field 0x40004C44,32


P4DS	.field 0x40004C29,32
P5DS	.field 0x40004C48,32

P4SEL0 	.field 0x40004C2B,32
P5SEL0 	.field 0x40004C4A,32

P4SEL1	.field 0x40004C2D,32
P5SEL1  .field 0x40004C4C,32
SYSTICK_STCSR	.field	0xE000E010, 32
SYSTICK_STRVR	.field	0XE000E014, 32
SYSTICK_STCVR	.field	0xE000E018, 32
Systick_cons	.field	0x00FFFFFF, 32

DELAY200MS	.field 75000, 32
;RED       .equ 0x01
;GREEN     .equ 0x02
;BLUE      .equ 0x04


      .global main
      .thumbfunc main

main: .asmfunc
    BL  Port4_Init                  ; initialize P1.1 and P1.4 and make them inputs (P1.1 and P1.4 built-in buttons)
    BL	Port5_Init


loop
	 BL SysTick_Init
	BL SysTick_Wait200ms
    BL  Port5_Input                 ; read both of the switches on Port 1
    CMP R0, #0x01                   ; R0 == 0x02?
    BEQ sw2pressed                  ; if so, switch 2 pressed
    CMP R0, #0x00                   ; R0 == 0x12?
    BEQ nopressed                   ; if so, neither switch pressed
                                    ; if none of the above, unexpected return value

    B   loop

sw2pressed
	LDR R1, P4OUT
	LDRB R0, [R1]
    EOR R0, #0x01
    BL  Port4_Output                ; turn the red LED on
    B   loop
nopressed

    BIC R0, #0x01
    BL  Port4_Output                 ; turn all of the LEDs off
    B   loop
    .endasmfunc

Port4_Init: .asmfunc
	LDR R1, P4SEL0
	MOV R0, #0x00
	STRB R0, [R1]
	LDR R1, P4SEL1
	MOV R0, #0x00
	STRB R0, [R1]
	LDR R1, P4DIR
	MOV R0, #0x01
	STRB R0, [R1]
	LDR R1, P4OUT
	ORR R0, #0x00
	STRB R0, [R1]
	BX LR
	.endasmfunc
Port5_Init: .asmfunc
	LDR R1, P5SEL0
	MOV R0, #0x00
	STRB R0, [R1]
	LDR R1, P5SEL1
	MOV R0, #0x00
	STRB R0, [R1]
	LDR R1, P5DIR
	MOV R0, #0x00
	STRB R0, [R1]
	LDR R1, P5OUT
	ORR R0, #0x00
	STRB R0, [R1]
	BX LR
	.endasmfunc

Port5_Input: .asmfunc
	LDR R1, P5IN
	LDRB R0, [R1]
	AND R0, R0, #0x01
	BX LR
	.endasmfunc

Port4_Output: .asmfunc
	LDR R1, P4OUT
	STRB R0, [R1]
	BX LR
	.endasmfunc
;-----------SysTick_Init----------------
SysTick_Init: .asmfunc
	LDR R1, SYSTICK_STCSR
	MOV R0, #0
	STR R0, [R1]

	LDR R1, SYSTICK_STRVR
	LDR R0, Systick_cons
	STR R0, [R1]

	LDR R1, SYSTICK_STCVR
	MOV R0, #0
	STR R0, [R1]

	LDR R1, SYSTICK_STCSR
	MOV R0, #0x00000005
	STR R0, [R1]
	BX 	LR
	.endasmfunc

;-----------SysTick_Wait------------
SysTick_Wait: .asmfunc
	LDR R1, SYSTICK_STRVR
	SUB R0, R0, #1
	STR R0, [R1]
	LDR R1, SYSTICK_STCVR
	MOV R2, #0
	STR R0, [R1]
	LDR R1, SYSTICK_STCSR
SysTick_Wait_loop
	LDR R3, [R1]
	ANDS R3, R3, #0x00010000
	BEQ SysTick_Wait_loop
	BX LR
	.endasmfunc


SysTick_Wait200ms: .asmfunc
	PUSH {R4, LR}
	MOVS R4, R0
	BEQ SysTick_Wait200ms_done
SysTick_Wait200ms_loop
	LDR R0, DELAY200MS
	BL 	SysTick_Wait
	SUBS	R4, R4, #1
	BHI		SysTick_Wait200ms_loop
SysTick_Wait200ms_done
	POP {R4, LR}
	BX 	LR

	.endasmfunc
    .end

