RCGCTIMER   EQU    0x400FE604
GPTMCTL0    EQU    0x4003000C
GPTMCFG0    EQU    0x40030000
GPTMTAMR0   EQU    0x40030004
GPTMTAILR0  EQU    0x40030028      
    
    
        AREA    |.text|, CODE, READONLY, ALIGN=2
            
            
Timer_Init
    LDR     R0, =RCGCTIMER
    MOV     R1, R0
    ORR     R1, #0x01 ;Timer 0
    STR     R1, [R0]
    
    LDR     R0, =GPTMCTL0
    MOV     R1, R0
    BIC     R1, R1, #0x01
    STR     R1, [R0]
    
    LDR     R0, =GPTMCFG0
    MOV     R1, R0
    BIC     R1, R1, #0x07
    STR     R1, [R0]

    LDR     R0, =GPTMTAMR0
    MOV     R1, R0
    ORR     R1, #0x01
    BIC     R1, R1, #0x02
    STR     R1, [R0]
    
    LDR     R0, =GPTMTAILR0
    MOV     R1, #0xB400
    MOVT    R1, #04C4
    STR     R1, [R0]
    
    
    
    
    
    