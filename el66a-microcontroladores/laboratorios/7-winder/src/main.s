; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 15/03/2018
; Este programa deve esperar o usuário pressionar uma chave.
; Caso o usuário pressione uma chave, um LED deve piscar a cada 1 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Definições de Valores
		
; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
			
; Se alguma variável for chamada em outro arquivo
;EXPORT  <var> [DATA,SIZE=<tam>]            ; Permite chamar a variável <var> a 
                                            ; partir de outro arquivo
		IMPORT DATA_READY
		IMPORT CONFIG_TIMER
		IMPORT STATE_FLAG
;<var>	SPACE <tam>                         ; Declara uma variável de nome <var>
                                            ; de <tam> bytes a partir da primeira 
                                            ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms
		IMPORT  SysTick_Wait1us			
		IMPORT  GPIO_Init
        IMPORT  PortJ_Input
		IMPORT  PortK_Output
        IMPORT  PortM_Output
		IMPORT  PortF_Output
		IMPORT  PortN_Output
            
        IMPORT  LCD_Init
		IMPORT  LCD_PushConfig
        IMPORT  LCD_PushString
		IMPORT  LCD_PushChar
            
        IMPORT 	Keyboard_Poll
			
		IMPORT 	Winder_Init      
        IMPORT 	Winder_Query

		IMPORT	Init_sequence_passo_completo
		IMPORT  Init_sequence_meio_passo
		IMPORT  Init_passo
		IMPORT  Pisca_led
			
		IMPORT 	Timer_Init
		
		IMPORT 	Interruption_init

; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init          		;Altera o clock do microcontrolador para 80MHz
	BL SysTick_Init      		;Inicializa o SysTick
	BL GPIO_Init         		;Inicializa os pinos de GPIO
    BL LCD_Init          		;Inicializa o LCD
	BL Winder_Init 
	BL Init_sequence_passo_completo
	BL Init_sequence_meio_passo
	BL Interruption_init
	
MainLoop
	MOV   R0, #50
	BL    SysTick_Wait1ms
    BL 	  Winder_Query
	
	LDR   R0, =STATE_FLAG
	LDR   R1, [R0]
	CMP   R1, #4
	BLEQ  Pisca_led
	
	LDR  R0, =DATA_READY
	LDR  R1, [R0]
	CMP  R1, #1
	BNE  fim_main
	LDR  R0, =CONFIG_TIMER
	LDR  R1, [R0]
	CMP  R1, #1
	BEQ  fim_main
	BL	 Init_passo
	BL	 Timer_Init
	
fim_main
	B  	MainLoop
	
	NOP
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo