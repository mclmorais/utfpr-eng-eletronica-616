;------------�rea de C�digo------------
;Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de c�digo

ROW_SIZE EQU 4

        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
            
        IMPORT  SysTick_Wait1ms
        IMPORT  Convert_BitsToDecimal
        
        EXPORT  Keyboard_Poll
        IMPORT  PortM_OutputKeyboard
        IMPORT  PortD_Input
                
keyboardArray = 1, 2, 3, 'A',\
                4, 5, 6, 'B',\
                7, 8, 9, 'C',\
                '*', 0, '#', 'D'

columnArray   = 2_01110000, 2_01101000, 2_01011000, 2_00111000
               
        ALIGN
 ;------------Keyboard_Poll------------
; Checa se alguma tecla foi pressionada.
; R0 itera entre colunas, 
Keyboard_Poll
    PUSH    {R1, R2, R3, R4, R5, R6, R7, R8, LR}
    MOV     R5, #0                  ;Coloca o iterador de colunas em 0
    LDR     R1, =columnArray        ;Coloca o endere�o do column array em R1
    MOV     R7, #ROW_SIZE           ;Coloca o tamanho da linha do teclado em R4
    MOV     R8, #0                  ;Zera a flag de detec��o
    
keyboard_poll_loop
    LDR     R1, =columnArray        ;Coloca o endere�o do vetor de colunas em R1
    ADD     R1, R5                  ;Avan�a o endere�o original at� o offset calculado
    LDRB    R0, [R1]                ;Pega o byte correspondente do vetor
    BL      PortM_OutputKeyboard    ;Escreve na porta para ativar a coluna escolhida
    
    MOV     R0, #10
    BL      SysTick_Wait1ms         ;Espera 10ms antes de checar as entradas
    
    MOV     R0, #0x0F               ;Checa as entradas
    BL      PortD_Input
    
    CMP     R0, #0x0F
    BEQ     keyboard_undetected     ;Pula esta etapa se nada foi detectado:
    MOV     R8, #1                  ;Seta flag que detectou um pressionamento
    BL      Convert_BitsToDecimal   ;Converte o valor lido nas portas para um decimal
    SUB     R0, #1                  ;Converte em zero-indexed
    MUL     R0, R0, R7              ;Avan�a linhas
    ADD     R0, R5                  ;Avan�a colunas
    B       keyboard_getChar        ;Para detec��o se algo foi detectado
    
keyboard_undetected
    ADD     R5, #1                  ;colunas++
    
    CMP     R5, #4                  ;Desiste se viu todas as colunas
    BGE     keyboard_poll_no_result
    B       keyboard_poll_loop

keyboard_poll_no_result
    MOV     R0, #0xFF               ;Coloca 0xFF se nada foi detectado
    
keyboard_poll_exit    
    POP     {R1, R2, R3, R4, R5, R6, R7, R8, LR}
    BX      LR
keyboard_getChar
    LDR     R1, =keyboardArray          ;Endere�o do vetor de caracteres do teclado          
    ADD     R1, R0                      ;Coloca o valor calculado como offset de bytes no endere�o
    LDRB    R0, [R1]                    ;Coloca o byte escolhido em R0
    B keyboard_poll_exit
    
    
    
    ALIGN
    END
 