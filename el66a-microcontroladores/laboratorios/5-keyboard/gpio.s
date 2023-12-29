; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 19/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; Definições de Valores
BIT0	EQU 2_0001
BIT1	EQU 2_0010
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definições dos Ports
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ_AHB_DATA_BITS_R  EQU    0x40060000
GPIO_PORTJ               	EQU    2_000000100000000
; PORT N
GPIO_PORTN_AHB_LOCK_R    	EQU    0x40064520
GPIO_PORTN_AHB_CR_R      	EQU    0x40064524
GPIO_PORTN_AHB_AMSEL_R   	EQU    0x40064528
GPIO_PORTN_AHB_PCTL_R    	EQU    0x4006452C
GPIO_PORTN_AHB_DIR_R     	EQU    0x40064400
GPIO_PORTN_AHB_AFSEL_R   	EQU    0x40064420
GPIO_PORTN_AHB_DEN_R     	EQU    0x4006451C
GPIO_PORTN_AHB_PUR_R     	EQU    0x40064510	
GPIO_PORTN_AHB_DATA_R    	EQU    0x400643FC
GPIO_PORTN_AHB_DATA_BITS_R  EQU    0x40064000
GPIO_PORTN               	EQU    2_001000000000000	
; PORT K
GPIO_PORTK_AHB_LOCK_R    	EQU    0x40061520
GPIO_PORTK_AHB_CR_R      	EQU    0x40061524
GPIO_PORTK_AHB_AMSEL_R   	EQU    0x40061528
GPIO_PORTK_AHB_PCTL_R    	EQU    0x4006152C
GPIO_PORTK_AHB_DIR_R     	EQU    0x40061400
GPIO_PORTK_AHB_AFSEL_R   	EQU    0x40061420
GPIO_PORTK_AHB_DEN_R     	EQU    0x4006151C
GPIO_PORTK_AHB_PUR_R     	EQU    0x40061510	
GPIO_PORTK_AHB_DATA_R    	EQU    0x400613FC
GPIO_PORTK_AHB_DATA_BITS_R  EQU    0x40061000
GPIO_PORTK               	EQU    2_000001000000000
;PORT A    
GPIO_PORTA_AHB_LOCK_R    	EQU    0x40058520
GPIO_PORTA_AHB_CR_R      	EQU    0x40058524
GPIO_PORTA_AHB_AMSEL_R   	EQU    0x40058528
GPIO_PORTA_AHB_PCTL_R    	EQU    0x4005852C
GPIO_PORTA_AHB_DIR_R     	EQU    0x40058400
GPIO_PORTA_AHB_AFSEL_R   	EQU    0x40058420
GPIO_PORTA_AHB_DEN_R     	EQU    0x4005851C
GPIO_PORTA_AHB_PUR_R     	EQU    0x40058510	
GPIO_PORTA_AHB_DATA_R    	EQU    0x400583FC
GPIO_PORTA_AHB_DATA_BITS_R  EQU    0x40058000
GPIO_PORTA               	EQU    2_000000000000001
; PORT D    
GPIO_PORTD_AHB_LOCK_R    	EQU    0x4005B520
GPIO_PORTD_AHB_CR_R      	EQU    0x4005B524
GPIO_PORTD_AHB_AMSEL_R   	EQU    0x4005B528
GPIO_PORTD_AHB_PCTL_R    	EQU    0x4005B52C
GPIO_PORTD_AHB_DIR_R     	EQU    0x4005B400
GPIO_PORTD_AHB_AFSEL_R   	EQU    0x4005B420
GPIO_PORTD_AHB_DEN_R     	EQU    0x4005B51C
GPIO_PORTD_AHB_PUR_R     	EQU    0x4005B510	
GPIO_PORTD_AHB_DATA_R    	EQU    0x4005B3FC
GPIO_PORTD_AHB_DATA_BITS_R  EQU    0x4005B000
GPIO_PORTD               	EQU    2_000000000001000
; PORT M
GPIO_PORTM_AHB_LOCK_R    	EQU    0x40063520
GPIO_PORTM_AHB_CR_R      	EQU    0x40063524
GPIO_PORTM_AHB_AMSEL_R   	EQU    0x40063528
GPIO_PORTM_AHB_PCTL_R    	EQU    0x4006352C
GPIO_PORTM_AHB_DIR_R     	EQU    0x40063400
GPIO_PORTM_AHB_AFSEL_R   	EQU    0x40063420
GPIO_PORTM_AHB_DEN_R     	EQU    0x4006351C
GPIO_PORTM_AHB_PUR_R     	EQU    0x40063510	
GPIO_PORTM_AHB_DATA_R    	EQU    0x400633FC
GPIO_PORTM_AHB_DATA_BITS_R  EQU    0x40063000
GPIO_PORTM               	EQU    2_000100000000000
	

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortK_Output			; Permite chamar PortN_Output de outro arquivo
		EXPORT PortM_Output			; Permite chamar PortN_Output de outro arquivo
        EXPORT PortM_OutputKeyboard
        EXPORT PortM_OutputRelay
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
        EXPORT PortD_Input        

GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; após isso verificar no PRGPIO se a porta está pronta para uso.
; enable clock to GPIOF at clock gating register
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endereço do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTK                 ;Seta o bit da porta K
            ORR     R1, #GPIO_PORTD                 ;Seta o bit da porta L, fazendo com OR
			ORR     R1, #GPIO_PORTM					;Seta o bit da porta M, fazendo com OR
			ORR 	R1, #GPIO_PORTJ                 ;Seta o bit da porta J, fazendo com OR 
            STR     R1, [R0]						;Move para a memória os bits das portas no endereço do RCGCGPIO
 
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;Lê da memória o conteúdo do endereço do registrador
			MOV     R2, #GPIO_PORTK                 ;Seta os bits correspondentes às portas para fazer a comparação
            ORR 	R2, #GPIO_PORTD
			ORR     R2, #GPIO_PORTM                 
			ORR 	R2, #GPIO_PORTJ
            TST     R1, R2							;Testa o R1 com R2 fazendo R1 & R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o laço. Senão continua executando
 
; 2. Destravar a porta somente se for o pino PD7
 
; 3. Limpar o AMSEL para desabilitar a analógica
            MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a função analógica
			LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta J
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da memória
            LDR     R0, =GPIO_PORTK_AHB_AMSEL_R     
            STR     R1, [R0]						
            LDR     R0, =GPIO_PORTM_AHB_AMSEL_R		
            STR     R1, [R0]	
            LDR     R0, =GPIO_PORTD_AHB_AMSEL_R		
            STR     R1, [R0]		            
 
; 4. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
			LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta J
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da memória
            LDR     R0, =GPIO_PORTK_AHB_PCTL_R		
            STR     R1, [R0]                        
            LDR     R0, =GPIO_PORTD_AHB_PCTL_R      
            STR     R1, [R0]           
            LDR     R0, =GPIO_PORTM_AHB_PCTL_R      
            STR     R1, [R0]
            
; 5. DIR para 0 se for entrada, 1 se for saída
			LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta J
			MOV     R1, #0x00						
            STR     R1, [R0]						
            LDR     R0, =GPIO_PORTK_AHB_DIR_R		
			MOV     R1, #0xFF						
            STR     R1, [R0]						
			; O certo era verificar os outros bits da PJ para não transformar entradas em saídas desnecessárias
            LDR     R0, =GPIO_PORTD_AHB_DIR_R		
            MOV     R1, #0x00               		;Entradas: D0 D1 D2 D3
            STR     R1, [R0]	            
            LDR     R0, =GPIO_PORTM_AHB_DIR_R		
            MOV     R1, #0xFF               		
            STR     R1, [R0]						
; 6. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem função alternativa
            MOV     R1, #0x00						;Colocar o valor 0 para não setar função alternativa
			LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R		;Carrega o endereço do AFSEL da porta J
            STR     R1, [R0]						
            LDR     R0, =GPIO_PORTK_AHB_AFSEL_R		
            STR     R1, [R0]	
            LDR     R0, =GPIO_PORTD_AHB_AFSEL_R		
            STR     R1, [R0]       
            LDR     R0, =GPIO_PORTM_AHB_AFSEL_R     
            STR     R1, [R0]
            
; 7. Setar os bits de DEN para habilitar I/O digital
			LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endereço do DEN
            LDR     R1, [R0]							;Ler da memória o registrador GPIO_PORTN_AHB_DEN_R
			MOV     R2, #BIT0
            ORR     R1, R2
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
	
            LDR     R0, =GPIO_PORTK_AHB_DEN_R			;Carrega o endereço do DEN
            LDR     R1, [R0]							;Ler da memória o registrador GPIO_PORTN_AHB_DEN_R
			MOV     R2, #0xFF
            ORR     R1, R2
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
            
            LDR     R0, =GPIO_PORTD_AHB_DEN_R			;Carrega o endereço do DEN
            LDR     R1, [R0]							;Ler da memória o registrador GPIO_PORTD_AHB_DEN_R
			MOV     R2, #0x0F
            ORR     R1, R2
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
           
 
            LDR     R0, =GPIO_PORTM_AHB_DEN_R			;Carrega o endereço do DEN
            LDR     R1, [R0]                            ;Ler da memória o registrador GPIO_PORTN_AHB_DEN_R
			MOV     R2, #0xFF                           
            ORR     R1, R2                              
            STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			
; 8. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endereço do PUR para a porta J
			MOV     R1, #BIT0							;Habilitar funcionalidade digital de resistor de pull-up 
            STR     R1, [R0]							;Escreve no registrador da memória do resistor de pull-up
            
            LDR     R0, =GPIO_PORTD_AHB_PUR_R			;Carrega o endereço do PUR para a porta 
            MOV     R1, #0x0F							;Habilitar funcionalidade digital de resistor de pull-up 
            STR     R1, [R0]							;Escreve no registrador da memória do resistor de pull-up

            BX      LR

; -------------------------------------------------------------------------------
; Função PortN_Output
; Parâmetro de entrada: R0
; Parâmetro de saída: Não tem
PortK_Output
	LDR	R1, =GPIO_PORTK_AHB_DATA_BITS_R		;Carrega o valor do offset do data register
	ADD R1, #0x03FC							;Soma ao offset o endereço do bit 1 para ser 
											;uma escrita amigável
	STR R0, [R1]                            ;Escreve no barramento de dados na porta N1 somente
	BX LR									;Retorno

PortM_OutputKeyboard
    PUSH {R1}
	LDR	R1, =GPIO_PORTM_AHB_DATA_BITS_R		;Carrega o valor do offset do data register
	ADD R1, #0x1E0															
	STR R0, [R1]                            ;Escreve no barramento de dados na porta N1 somente
    POP {R1}
	BX LR									;Retorno	
    
PortM_OutputRelay
    PUSH {R1}
	LDR	R1, =GPIO_PORTM_AHB_DATA_BITS_R		;Carrega o valor do offset do data register
	ADD R1, #0x200															
	STR R0, [R1]                            ;Escreve no barramento de dados na porta N1 somente
    POP {R1}
	BX LR									;Retorno	


PortM_Output
	LDR	R1, =GPIO_PORTM_AHB_DATA_BITS_R		;Carrega o valor do offset do data register
	ADD R1, #0x001C							;Soma ao offset o endereço do bit 1 para ser 
											;uma escrita amigável
	STR R0, [R1]                            ;Escreve no barramento de dados na porta N1 somente
	BX LR									;Retorno	

; -------------------------------------------------------------------------------
; Função PortJ_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
PortJ_Input
    
	LDR	R1, =GPIO_PORTJ_AHB_DATA_BITS_R		;Carrega o valor do offset do data register
	ADD R1, #0x0004							;Soma ao offset o endereço dos bit 0 e 1 para 
											;serem os únicos a serem lidos tem uma leitura amigável
	LDR R0, [R1]                            ;Lê no barramento de dados nos pinos J0 e J1 somente
	
    BX LR									;Retorno
    
PortD_Input
    PUSH {R1}
    
	LDR	R1, =GPIO_PORTD_AHB_DATA_BITS_R		
	ADD R1, #0x3C
    
	LDR R0, [R1]
    
    POP {R1}    
	BX LR									



    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo