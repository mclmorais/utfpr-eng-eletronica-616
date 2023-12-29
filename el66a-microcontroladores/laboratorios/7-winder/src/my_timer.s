
		THUMB

RCGCTIMER 			EQU 0x400FE604
GPTMCTL_TIMER_0 	EQU 0x4003000C
GPTMCFG_TIMER_0		EQU 0x40030000
GPTMTAMR_TIMER_0	EQU 0x40030004
GPTMTAILR_TIMER_0   EQU 0x40030028
GPTMICR_TIMER_0		EQU 0x40030024
GPTMIMR_TIMER_0		EQU 0x40030018
NVIC_PRI4			EQU 0xE000E410
NVIC_EN0 			EQU 0xE000E100
PRTIMER				EQU 0x400FEA04
CONFIG_TIMER		EQU 0x20000418



; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		EXPORT CONFIG_TIMER
		; Se alguma variável for chamada em outro arquivo
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2
		
		; Se alguma função do arquivo for chamada em outro arquivo	
		EXPORT Timer_Init
		EXPORT Timer0A_Handler
		EXPORT Disable_timer
		; Se chamar alguma função externa
		IMPORT Gira_motor
; -------------------------------------------------------------------------------
; Funções timer	
Timer_Init
		MRS  R0, BASEPRI			;Copia valor do BASEPRI para R0
		ORR  R0, #0x00		  
		MSR  BASEPRI, R0			;Altera valor do BASEPRI
		
		MRS  R0, PRIMASK			;Copia valor do PRIMASK para R0
		BIC  R0, #0x01		  
		MSR  PRIMASK, R0			;Altera valor do PRIMASK
		
		LDR  R0, =RCGCTIMER
		LDR  R1, [R0]
		ORR  R1, #0x01
		STR  R1, [R0]
		
		LDR  R0, =PRTIMER
Espera_timer
		LDR  R1, [R0]
		MOV  R2, #0x01
		TST  R1, R2
		BEQ  Espera_timer

		LDR  R0, =GPTMCTL_TIMER_0		
		LDR  R1, [R0]
		BIC  R1, #0x01
		STR  R1, [R0]
		
		LDR  R0, =GPTMCFG_TIMER_0
		MOV  R1, #0x00
		STR  R1, [R0]
		
		LDR	 R0, =GPTMTAMR_TIMER_0
		LDR  R1, [R0]
		BIC  R1, #0x03
		ORR  R1, #0x02
		STR  R1, [R0]
		
		LDR  R0, =GPTMTAILR_TIMER_0
		MOV  R1, #0x0D40
		MOVT R1, #0x0003
		STR  R1, [R0]
		
		LDR  R0, =GPTMICR_TIMER_0
		LDR  R1, [R0]
		ORR  R1, #0x01
		STR  R1, [R0]
		
		LDR  R0, =GPTMIMR_TIMER_0
		LDR  R1, [R0]
		ORR  R1, #0x01
		STR  R1, [R0]
		
		LDR  R0, =NVIC_PRI4
		LDR  R1, [R0]
		MOV  R2, #0x0000
		MOVT R2, #0xE000
		BIC  R1, R2
		MOV  R2, #0x0000
		MOVT R2, #0x2000
		ORR  R1, R2
		STR  R1, [R0]
		
		LDR  R0, =NVIC_EN0
		LDR  R1, [R0]
		MOV  R2, #0x0000
		MOVT R2, #0x0008
		ORR  R1, R2
		STR  R1, [R0]
		
		LDR  R0, =GPTMCTL_TIMER_0	
		LDR  R1, [R0]
		ORR  R1, #0x01
		STR  R1, [R0]
		
		LDR  R0, =CONFIG_TIMER
		MOV  R1, #1
		STR  R1, [R0]
		
		BX   LR
		
Disable_timer
		PUSH {LR,R0,R1} 
		LDR  R0, =GPTMCTL_TIMER_0		
		LDR  R1, [R0]
		BIC  R1, #0x01
		STR  R1, [R0]
		POP  {LR,R0,R1}
		
		BX	  LR
		
		
Timer0A_Handler
        PUSH {LR,R0,R1} 
		LDR  R0, =GPTMICR_TIMER_0		
		LDR  R1, [R0]
		ORR  R1, #0x01
		STR  R1, [R0]
		BL   Gira_motor
		POP  {LR,R0,R1}
		
		BX	  LR
		
		NOP
		ALIGN 
		END
		