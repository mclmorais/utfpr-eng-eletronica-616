	THUMB
; -------------------------------------------------------------------------------
; Area definição de constantes
PASSO_COMPLETO_1 EQU 0x20000404
PASSO_COMPLETO_4 EQU 0x20000407
ESTADO_SEQUENCIA EQU 0x20000408
MEIO_PASSO_1	 EQU 0x2000040C
MEIO_PASSO_8	 EQU 0x20000413
DATA_STEPS		 EQU 0x20000414
LED_STATE 		 EQU 0x20000422 
; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
	AREA  DATA, ALIGN=2
	IMPORT	DATA_ROTATIONS
	IMPORT	DATA_DIRECTION
	IMPORT	DATA_SPEED
	IMPORT  DATA_READY

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
	AREA    |.text|, CODE, READONLY, ALIGN=2
	EXPORT	Init_sequence_passo_completo
	EXPORT  Init_sequence_meio_passo
	EXPORT  Init_passo
	EXPORT  Gira_motor
	EXPORT  Pisca_led
		
	IMPORT  PortF_Output
	IMPORT  PortN_Output
        
; -------------------------------------------------------------------------------
; Funções motor
Init_sequence_passo_completo   ;Inicia na memória os estados das portas para sequencia passo completo
	PUSH {LR,R0,R1}
	LDR  R0, =PASSO_COMPLETO_1
	MOV  R1, #2_1000
	STRB R1, [R0], #1
	MOV  R1, #2_0100
	STRB R1, [R0], #1
	MOV  R1, #2_0010
	STRB R1, [R0], #1
	MOV  R1, #2_0001
	STRB R1, [R0]
	POP  {LR,R0,R1}
	
	BX LR
	
Init_sequence_meio_passo		;Inicia na memória os estados das portas para sequencia meio passo
	PUSH {LR,R0,R1}
	LDR  R0, =MEIO_PASSO_1
	MOV  R1, #2_1000
	STRB R1, [R0], #1
	MOV  R1, #2_1100
	STRB R1, [R0], #1
	MOV  R1, #2_0100
	STRB R1, [R0], #1
	MOV  R1, #2_0110
	STRB R1, [R0], #1
	MOV  R1, #2_0010
	STRB R1, [R0], #1
	MOV  R1, #2_0011
	STRB R1, [R0], #1
	MOV  R1, #2_0001
	STRB R1, [R0], #1
	MOV  R1, #2_1001
	STRB R1, [R0], #1
	POP  {LR,R0,R1}
	
	BX LR
	
Init_passo_completo				;Para passo completo, inicia numero de passos para uma volta completa e o estado inicial das portas
	PUSH {LR,R0,R1}
	LDR  R0, =DATA_STEPS
	MOV  R1, #2048
	STR  R1, [R0]
	LDR  R0, =DATA_DIRECTION
	LDR  R0, [R0]
	CMP  R0, #0
	BNE  b_anti_horario_completo
	LDR  R0, =PASSO_COMPLETO_1
	LDR  R1, =ESTADO_SEQUENCIA
	STR  R0, [R1]
	B	 fim_init_passo_completo
b_anti_horario_completo
	LDR  R0, =PASSO_COMPLETO_4
	LDR  R1, =ESTADO_SEQUENCIA
	STR  R0, [R1]
fim_init_passo_completo
	POP  {LR,R0,R1}
	
	BX LR
	
Init_meio_passo					;Para meio passo, inicia numero de passos para uma volta completa e o estado inicial das portas
	PUSH {LR,R0,R1}
	LDR  R0, =DATA_STEPS
	MOV  R1, #4096
	STR  R1, [R0]
	LDR  R0, =DATA_DIRECTION
	LDR  R0, [R0]
	CMP  R0, #0
	BNE  b_anti_horario_meio
	LDR  R0, =MEIO_PASSO_1
	LDR  R1, =ESTADO_SEQUENCIA
	STR  R0, [R1]
	B	 fim_init_meio_passo
b_anti_horario_meio
	LDR  R0, =MEIO_PASSO_8
	LDR  R1, =ESTADO_SEQUENCIA
	STR  R0, [R1]
fim_init_meio_passo
	POP  {LR,R0,R1}
	
	BX LR
	
Init_passo						;Seleciona qual das duas funções acima executar
	PUSH {LR,R0,R1}
	LDR  R0, =DATA_SPEED
	LDR  R0, [R0]
	CMP  R0, #0
	PUSH {R0}
	BLEQ Init_passo_completo
	POP	 {R0}
	CMP  R0, #0
	BLNE Init_meio_passo
	POP  {LR,R0,R1}
	
	BX LR
	
Exec_passo_completo_horario		;Executa passo completo no sentido horario
	PUSH  {LR,R0,R1,R2}
	LDR   R1, =ESTADO_SEQUENCIA
	LDR   R1, [R1]
	LDRB  R0, [R1]
	BL    PortF_Output
	LDR   R0, =PASSO_COMPLETO_4
	CMP   R1, R0
	ITTTT NE
	ADDNE R1, #1
	LDRNE R2, =ESTADO_SEQUENCIA
	STRNE R1, [R2]
	BNE   fim_passo_completo_horario
	LDR   R1, =ESTADO_SEQUENCIA
	LDR   R1, [R1]
	LDR   R0, =PASSO_COMPLETO_4
	CMP   R1, R0
	ITTT  EQ
	LDREQ R1, =PASSO_COMPLETO_1
	LDREQ R0, =ESTADO_SEQUENCIA
	STREQ R1, [R0]
fim_passo_completo_horario	
	POP   {LR,R0,R1,R2}
	
	BX LR
	
Exec_passo_completo_anti_horario	;Executa passo completo no sentido anti-horario
	PUSH  {LR,R0,R1,R2}
	LDR   R1, =ESTADO_SEQUENCIA
	LDR   R1, [R1]
	LDRB  R0, [R1]
	BL    PortF_Output
	LDR   R0, =PASSO_COMPLETO_1
	CMP   R1, R0
	ITTTT NE
	SUBNE R1, #1
	LDRNE R2, =ESTADO_SEQUENCIA
	STRNE R1, [R2]
	BNE   fim_passo_completo_anti_horario	
	LDR   R1, =ESTADO_SEQUENCIA
	LDR   R1, [R1]
	LDR   R0, =PASSO_COMPLETO_1
	CMP   R1, R0
	ITTT  EQ
	LDREQ R1, =PASSO_COMPLETO_4
	LDREQ R0, =ESTADO_SEQUENCIA
	STREQ R1, [R0]
fim_passo_completo_anti_horario	
	POP   {LR,R0,R1,R2}
	
	BX LR
	
Exec_meio_passo_horario				;Executa meio passo no sentido horario
	PUSH  {LR,R0,R1,R2}
	LDR   R1, =ESTADO_SEQUENCIA
	LDR   R1, [R1]
	LDRB  R0, [R1]
	BL    PortF_Output
	LDR   R0, =MEIO_PASSO_8
	CMP   R1, R0
	ITTTT NE
	ADDNE R1, #1
	LDRNE R2, =ESTADO_SEQUENCIA
	STRNE R1, [R2]
	BNE   fim_meio_passo_horario
	LDR   R1, =ESTADO_SEQUENCIA
	LDR   R1, [R1]
	LDR   R0, =MEIO_PASSO_8
	CMP   R1, R0
	ITTT  EQ
	LDREQ R1, =MEIO_PASSO_1
	LDREQ R0, =ESTADO_SEQUENCIA
	STREQ R1, [R0]
fim_meio_passo_horario	
	POP   {LR,R0,R1,R2}
	
	BX LR
	
Exec_meio_passo_anti_horario		;Executa meio passo no sentido anti-horario
	PUSH  {LR,R0,R1,R2}
	LDR   R1, =ESTADO_SEQUENCIA
	LDR   R1, [R1]
	LDRB  R0, [R1]
	BL    PortF_Output
	LDR   R0, =MEIO_PASSO_1
	CMP   R1, R0
	ITTTT NE
	SUBNE R1, #1
	LDRNE R2, =ESTADO_SEQUENCIA
	STRNE R1, [R2]
	BNE   fim_meio_passo_anti_horario	
	LDR   R1, =ESTADO_SEQUENCIA
	LDR   R1, [R1]
	LDR   R0, =MEIO_PASSO_1
	CMP   R1, R0
	ITTT  EQ
	LDREQ R1, =MEIO_PASSO_8
	LDREQ R0, =ESTADO_SEQUENCIA
	STREQ R1, [R0]
fim_meio_passo_anti_horario	
	POP   {LR,R0,R1,R2}
	
	BX LR
	
Gira_motor							;Decrementa numero de passos e voltas, escolhe quais das funções de execução de giro devem ser reali
	PUSH {LR}						;É chamada pelo função Timer0A_Handler
	LDR	 R0, =DATA_ROTATIONS
	LDR  R0, [R0]
	CMP  R0, #0
	ITTTT EQ
	LDREQ R0, =DATA_READY
	MOVEQ R1, #2
	STREQ R1, [R0]
	BEQ	  retorno_gira_motor
	LDR  R0, =DATA_STEPS
	LDR  R0, [R0]
	CMP  R0, #0
	BEQ  fim_gira_motor
	LDR  R0, =DATA_SPEED
	LDR  R0, [R0]
	CMP  R0, #0
	BNE  b_meio_passo
	LDR  R0, =DATA_DIRECTION
	LDR  R0, [R0]
	CMP  R0, #0
	PUSH {R0}
	BLEQ Exec_passo_completo_horario
	POP  {R0}
	CMP  R0, #0
	BLNE Exec_passo_completo_anti_horario
	B	 fim_gira_motor
b_meio_passo
	LDR  R0, =DATA_DIRECTION
	LDR  R0, [R0]
	CMP  R0, #0
	PUSH {R0}
	BLEQ Exec_meio_passo_horario
	POP  {R0}
	CMP  R0, #0
	BLNE Exec_meio_passo_anti_horario
fim_gira_motor
	LDR   R0, =DATA_STEPS
	LDR   R1, [R0]
	CMP   R1, #0
	ITT	  NE
	SUBNE R1, #1
	STRNE R1, [R0]
	BNE   retorno_gira_motor
	LDR	  R0, =DATA_ROTATIONS
	LDR   R1, [R0]
	SUB   R1, #1
	STR   R1, [R0]
	BL    Init_passo
retorno_gira_motor
	POP   {LR}
	
	BX LR

Pisca_led
	PUSH  {LR}
	LDR   R1, =LED_STATE
	LDR   R0, [R1]
	CMP   R0, #2_0
	ITE   EQ
	MOVEQ R0, #2_1
	MOVNE R0, #2_0
	STR   R0, [R1]
	BL	  PortN_Output
	POP	  {LR}
	
	BX	  LR
	
	NOP
	ALIGN 
	END