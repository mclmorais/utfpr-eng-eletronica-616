;Constantes
END_INICIAL EQU 0x20000040
END_POS 	EQU 0x2000004B
LAST_STATE 	EQU 0x20000050

;------------�rea de C�digo------------
;Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de c�digo

        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB   
        IMPORT  SysTick_Wait1ms
        IMPORT  LCD_PushChar
		IMPORT  LCD_PushString
		IMPORT  LCD_PushConfig
		IMPORT  LCD_Init
		EXPORT  Tabuada
		EXPORT  Init_Memo
			
Init_Memo							;Zera todos os endere�os de mem�ria entre END_INICIAL e END_POS
	PUSH {LR,R0,R1,R2,R3}
	LDR  R0, =END_INICIAL			;Posi��o inicial da mem�ria contendo os multiplicadores de cada tabuada
	LDR  R2, =LAST_STATE			;Posi��o contendo o valor lido do teclado anteriormente
loop_init
	MOV  R1, #0
	STRB R1, [R0], #1
	CMP  R0, R2
	BNE  loop_init
	POP  {LR,R0,R1,R2,R3}
	BX   LR

Load_End							;Salva em END_POS o endere�o do multiplicador da tabuada atual
	PUSH {LR,R0,R1,R2}
	LDR  R1, =END_INICIAL			;Seta R1 como o endere�o inicial dos multiplicadores
	MOV  R2, #1
	MUL  R0, R2						;Multiplica R0, valor lido do teclado, por 1
	ADD  R1, R0						;Adiciona a R1 o resultado da multiplica��o
	LDR  R0, =END_POS 
	STR  R1, [R0]					;Armazena em END_POS o endere�o do multiplicador da tabuada atual
	POP  {LR,R0,R1,R2}
	BX   LR
	
Add_One								;Soma um ao valor do multiplicador da tabuada atual
	PUSH   {LR,R0,R1,R2}
	LDR    R0, =END_POS
	LDR    R1, [R0]
	LDRB   R2, [R1]					;Pega valor do multiplicador da tabuada atual
	CMP    R2, #11					;Compara se esse valor j� � igual a 10
	ITT    LE
	ADDLE  R2, #1					;Soma 1 caso seja diferente
	STRBLE R2, [R1]					;Guarda na mem�ria 
	POP    {LR,R0,R1,R2}
	BX     LR

Print_Tabuada						;Realiza as contas e imprime na tela
	PUSH  {LR,R0,R1,R2,R3,R4,R5}
	BL    LCD_Init					;Limpa a tela
	LDR   R3, =END_POS
	LDR   R1, [R3]
	LDRB  R2, [R1]					;R2 = valor do multiplicador da tabuada atual
	MUL   R4, R0, R2				;R4 = valor pressionado do teclado x R2
	PUSH  {R0}
	MOV   R0, #5					;Passa R0 como parametro para LCD_PushString, chamando a sexta string
	BL	  LCD_PushString
	POP   {R0}
	PUSH  {R0}
	ADD   R0, #48					;Adiciona 48 ao valor pressionado do teclado
    PUSH  {R0}
	MOV   R0, #0x8D          		;COloca o cursor no final da 1a linha
	BL	  LCD_PushConfig
	POP   {R0}
	BL    LCD_PushChar				;Imprime valor do teclado
	POP   {R0}
	PUSH  {R0}
	MOV   R0, #0xC0          		;Coloca cursor na 1a posi��o da 2a linha
	BL	  LCD_PushConfig
	POP   {R0}
	ADD   R0, #48					;Adiciona 48 ao valor pressionado do teclado
	BL    LCD_PushChar				;Imprime valor do teclado
	MOV   R0, #"x"
	BL    LCD_PushChar				;Imprime x
	CMP   R2, #10					;Compara multiplicador da tabuada atual com 10
	ITT   EQ
	MOVEQ R0, #49					;Caso seja igual, imprime 1 e 0 
	BLEQ  LCD_PushChar				
	CMP   R2, #10
	ITE   EQ
	MOVEQ R0, #0
	MOVNE R0, R2					;Caso n�o seja, imprime o valor do multiplicador atual por convers�o decimal para ASCII 
	ADD   R0, #48
	BL    LCD_PushChar
	MOV   R0, #"="					;Imprime =
	BL    LCD_PushChar
	MOV   R3, #10					
	UDIV  R2, R4, R3				;Divide resultado da multiplica��o por 10, R2 recebe a parte inteira da divis�o
	MOV   R0, R2					
	ADD   R0, #48					;Soma 48 para convers�o decimal para ASCII 
	BL    LCD_PushChar				;Imprime parte decimal mais significativa
	MUL   R2, R3					;Parte inteira da divis�o � multiplicada por 10 e inserida em R2
	SUB   R4, R2					;R2 � subtraido do valor da multiplica��o 
	MOV   R0, R4					
	ADD   R0, #48					;Soma 48 para convers�o decimal para ASCII 
	BL    LCD_PushChar				;Imprime parte decimal  menos   significativa
	MOV   R0, #100
	BL    SysTick_Wait1ms
	POP   {LR,R0,R1,R2,R3,R4,R5}
	BX    LR
	
Tabuada
	PUSH {LR,R1,R2}
	LDR  R1, =LAST_STATE			;Salva em R1 o endere�o da mem�ria que possui o valor bot�o pressionado anteriormente
	LDR  R2, [R1]					;R2 recebe o valor do bot�o pressionado anteriormente
	CMP  R2, R0						;Compara se o ultimo bot�o pressionado � igual ao anterior
	BEQ  end_tabuada				;Caso seja, vai para o fim da fun��o, inalterando o multiplicadore da tabuada
	STR  R0, [R1]					;Caso n�o seja, armazenda no endere�o LAST_STATE o bot�o pressionado atualmente e incrementa o multiplicador 
	CMP  R0, #0xFF					;Caso nenhuma tecla seja pressionada (0xFF), vai para o fim da fun��o, valores dos multiplicadores n�o s�o alterados
	BEQ  end_tabuada					
	BL   Load_End					;Salva em END_POS o endere�o do multiplicador da tabuada atual
	BL   Print_Tabuada				;Realiza as contas e imprime na tela
	BL   Add_One					;Soma um ao valor do multiplicador da tabuada atual
end_tabuada
	POP  {LR,R1,R2}
	BX  LR
	
    NOP
    ALIGN
    END
    
    
    
    
    
   



    