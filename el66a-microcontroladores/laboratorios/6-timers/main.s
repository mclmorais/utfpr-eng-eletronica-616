; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 15/03/2018
; Este programa deve esperar o usu�rio pressionar uma chave.
; Caso o usu�rio pressione uma chave, um LED deve piscar a cada 1 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Defini��es de Valores
BIT0	    EQU 2_0001
BIT1	    EQU 2_0010


   

; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
			
; Se alguma vari�vel for chamada em outro arquivo
;EXPORT  <var> [DATA,SIZE=<tam>]            ; Permite chamar a vari�vel <var> a 
                                            ; partir de outro arquivo
;<var>	SPACE <tam>                         ; Declara uma vari�vel de nome <var>
                                            ; de <tam> bytes a partir da primeira 
                                            ; posi��o da RAM		

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms
		IMPORT  SysTick_Wait1us			
		IMPORT  GPIO_Init
        IMPORT  PortJ_Input
		IMPORT  PortK_Output
        IMPORT  PortM_Output
            
        IMPORT  LCD_Init
		IMPORT  LCD_PushConfig
        IMPORT  LCD_PushString


; -------------------------------------------------------------------------------
; Fun��o main()
Start  		
	BL PLL_Init          		;Altera o clock do microcontrolador para 80MHz
	BL SysTick_Init      		;Inicializa o SysTick
	BL GPIO_Init         		;Inicializa os pinos de GPIO
    BL LCD_Init          		;Inicializa o LCD
	
	BL Display_UTFPR            
	MOV R12, #1					;Seta a flag de chave como solta (1)

	
MainLoop
	BL 	PortJ_Input				;L� o estado da chave SW0 e coloca em R0
	CMP R0, R12			 		;Se a chave est� numa posi��o diferente da anterior, muda o display
								;Se a chave est� na mesma posi��o do loop anterior, n�o faz nada
	BEQ MainLoop
	
button_Pressed
	CMP R0, #0                  ;Se a chave est� pressionada (0), coloca texto de equipe na tela
	BNE button_Unpressed
	BL Display_Equipe
	MOV R12, #0					;Ser� trocado por debounce
	MOV  R0, #300
	BL   SysTick_Wait1ms
	B MainLoop
button_Unpressed                ;Se a chave n�o est� apertada, coloca o texto da UTFPR
	BL Display_UTFPR
	MOV R12, #1
	MOV  R0, #300             	;Ser� trocado por debounce
	BL   SysTick_Wait1ms
	B MainLoop




;------------Display_UTFPR------------
; Entrada: Nenhum
; Sa�da: Nenhum
; Modifica: -- (apenas mudan�as tempor�rias)
Display_UTFPR
	PUSH {R0, LR}
	
	MOV R0, #0x80              	;Coloca cursor na 1a posi��o da 1a linha
	BL	LCD_PushConfig
	
	MOV	R0, #0                  ;Manda string [0] para o display
    BL  LCD_PushString
	
	MOV R0, #0xC0               ;Coloca cursor na 1a posi��o da 2a linha
	BL	LCD_PushConfig
	
	MOV	R0, #1                  ;Manda string [1] para o display
    BL  LCD_PushString

	POP {R0, LR}
	BX	LR
	
;------------Display_Equipe------------
; Entrada: Nenhum
; Sa�da: Nenhum
; Modifica: -- (apenas mudan�as tempor�rias)
Display_Equipe
	PUSH {R0, LR}
	
	MOV R0, #0x80          		;Coloca cursor na 1a posi��o da 1a linha
	BL	LCD_PushConfig     		 
									
	MOV	R0, #2             		;Manda string [2] para o display
    BL  LCD_PushString     		 
									
	MOV R0, #0xC0          		;Coloca cursor na 1a posi��o da 2a linha
	BL	LCD_PushConfig     		 
									
	MOV	R0, #3             		;Manda string [3] para o display
    BL  LCD_PushString
	
	POP {R0, LR}
	BX	LR

    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo