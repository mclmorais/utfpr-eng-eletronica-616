        --Carrega Constantes
        1 =>  "1001101010000001", --ld  r5 1
        2 =>  "1001100010100001", --ld  r1 33
        --Carrega R2 (comeCa em 0) no endereco R2 (comeca em 0)
        4 =>  "0010010100010010", --ld  [r2] r2
        --R2++
        5 =>  "0011100101000101", --add r2 r5
        --Volta para loop em 4 enquanto r2 < r1
        6 =>  "0011010101000001", --cmp r2 r1
        9 =>  "0000100001111001", --jrlt -3
        --Carrega 2 (primo atual) em R0
        12 => "1001100000000010", --ld  r0 2
        --Carrega 0 (iterador) em R2
        13 => "1001100100000000", --ld  r2 0

        --COMECO DO FOR
        --Pula loop se i >= 33 (fica se i < 33)
        16 => "0011010101000001", --cmp r2 r1
        19 => "0000011000100010", --jpgt FIM FOR
        --Carrega RAM[i] em R4
        22 => "0010001000010010", --ld r4 [r2]

        --COMECO DO WHILE
        25 => "0011011001000101", --cmp r4 r7

        28 => "0000100000001010", --brle FIM WHILE (+10)

        31 => "0011101001010000", --sub r4 r0

        34 =>  "1001101100011001", --ld  r6, 25

        37 => "0000000101001110", --jpa COMECO WHILE
        --FIM DO WHILE

        --COMECO ZERA RAM SE NAO PRIMO
        40 => "0011011001000111", --cmp r4 r7

        43 => "0000111100000100", --jrne PULA PROXIMA (+4)
        46 => "0010011110010010", --ld [r2] r7 (RAM[i] = 0)
        --FIM ZERA RAM SE NAO PRIMO

        --i++
        49 => "0011100101000101", --add r2 r5

        51 =>  "1001101100010000", --ld  r6, 16

        54 => "0000000101001110", --jpa COMECO FOR

        --FIM DO FOR