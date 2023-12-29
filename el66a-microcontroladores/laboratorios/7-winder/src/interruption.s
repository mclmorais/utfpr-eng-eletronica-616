	THUMB
; -------------------------------------------------------------------------------
; Area definição de constantes
GPIOIM_PORTJ	EQU	0x40060410
GPIOIS_PORTJ	EQU 0x40060404
GPIOIBE_PORTJ	EQU 0x40060408
GPIOIEV_PORTJ   EQU 0x4006040C
GPIORIS_PORTJ	EQU 0x40060414
GPIOICR_PORTJ	EQU 0x4006041C
NVIC_PRI12		EQU 0xE000E430
NVIC_EN1		EQU 0xE000E104

; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
	AREA  DATA, ALIGN=2
	IMPORT	DATA_ROTATIONS
	IMPORT  DATA_READY
	IMPORT  CONFIG_TIMER

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
	AREA    |.text|, CODE, READONLY, ALIGN=2
	EXPORT  GPIOPortJ_Handler
	EXPORT  Interruption_init
	
	IMPORT	EnableInterrupts
	IMPORT	Disable_timer
	
; -------------------------------------------------------------------------------
; Funções interrupções
Interruption_init
	PUSH {LR}
	LDR R0, =GPIOIM_PORTJ
	LDR R1, [R0]
	BIC R1, #0x01
	STR R1, [R0]
	
	LDR R0, =GPIOIS_PORTJ
	LDR R1, [R0]
	BIC R1, #0x01
	STR R1, [R0]
	
	LDR R0, =GPIOIBE_PORTJ
	LDR R1, [R0]
	BIC R1, #0x01
	STR R1, [R0]
	
	LDR R0, =GPIOIEV_PORTJ
	LDR R1, [R0]
	BIC R1, #0x01
	STR R1, [R0]
	
	LDR R0, =GPIORIS_PORTJ
	LDR R1, [R0]
	BIC R1, #0x01
	STR R1, [R0]
	
	LDR R0, =GPIOIM_PORTJ
	LDR R1, [R0]
	ORR R1, #0x01
	STR R1, [R0]
	
	LDR  R0, =NVIC_PRI12
	LDR  R1, [R0]
	MOV  R2, #0x0000
	MOVT R2, #0xE000
	BIC  R1, R2
	STR  R1, [R0]
	
	LDR  R0, =NVIC_EN1
	LDR  R1, [R0]
	MOV  R2, #0x0000
	MOVT R2, #0x0008
	ORR  R1, R2
	STR  R1, [R0]
	
	BL   EnableInterrupts
	POP  {LR}
	BX	 LR
	
GPIOPortJ_Handler
	PUSH {LR}
	LDR  R0, =GPIOICR_PORTJ
	MOV  R1, #0x01
	STR  R1, [R0]
	LDR  R0, =DATA_ROTATIONS
	MOV  R1, #0
	STR  R1, [R0]
	LDR  R0, =DATA_READY
	MOV  R1, #2
	STR  R1, [R0]
	LDR  R0, =CONFIG_TIMER
	MOV  R1, #0
	STR  R1, [R0]
	BL   Disable_timer
	POP  {LR}
	BX   LR
	
	NOP
	ALIGN 
	END