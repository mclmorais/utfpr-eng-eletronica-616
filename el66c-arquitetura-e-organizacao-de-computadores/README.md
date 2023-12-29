
# Laboratório AOC - ISA S1C17 em VHDL

## Considerações da ISA implementadas:

* Várias partes da ISA lidam com tamanhos diferentes de barramento:
  
  * Instruções: 16 bits
  * Registradores: 24 bits
  * Memória de dados: 32 bits (não implementada aqui)

* A arquitetura é do tipo RISC, com as instruções principais de tamanho fixo e
* executadas em um ciclo (considerando pipeline)

* A arquitetura não possui um número fixo de bits para decoding da instrução.

* O pipeline implementado neste modelo não possui precauções contra _hazards_; 
por isso, todas as instruções que precisarem de dados de instruções sendo executadas imediatamente antes devem ser preenchidas com nops para que o dado 
possa se propagar corretamente.

## Código Atual

### Registradores

**R0**: Contem número primo a ser testado

**R1**: 



## Instruções Implementadas

### 1. add %rd, %rs

```
15                                      0
[ 0 0 1 1 1 0 | D D D | 1 0 0 0 | S S S ]  
  OPCODE        RD                RS

[ IL IE C V Z N ] (X : modifica flag)
  –  –  X X X X
```

### 2. sub %rd, %rs

```
15                                      0
[ 0 0 1 1 1 0 | D D D | 1 0 1 0 | S S S ]  
  OPCODE        RD                RS

[ IL IE C V Z N ] (X : modifica flag)
  –  –  X – X X
```

### 3. ld %rd, sign7
O valor imediato de 7 bits sign7 é carregado no registrador rd após ter seu
sinal extendido para 16 bits.
```
15                                      0
[ 1 0 0 1 1 0 | D D D | S S S S   S S S ]  
  OPCODE        RD      SIGN7

[ IL IE C V Z N ] (X : modifica flag)
  –  –  – – – –
```

### 4. ld.a %rd, %rs
O conteúdo do registrador rs é transferido para o registrador rd.
```
15                                      0
[ 0 0 1 0 1 0 | D D D | 0 0 1 1 | S S S ]  
  OPCODE        RD                RS

[ IL IE C V Z N ] (X : modifica flag)
  –  –  – – – –
```

### 5. jpa %rb
O conteúdo do registrador rb é colocado no PC e o programa pula para este
endereço. O LSB do registrador é ignorado e considerado como 0.
```
15                                      0
[ 0 0 0 0 0 0 | 0 1 0   1 0 0 1 | B B B ]  
  OPCODE                          RB

[ IL IE C V Z N ] (X : modifica flag)
  –  –  – – – –
```

### 6. nop
Nenhuma operação é feita exceto incremento do PC.
```
15                                      0
[ 0 0 0 0 0 0   0 0 0   0 0 0 0   0 0 0 ]  
  OPCODE                          

[ IL IE C V Z N ] (X : modifica flag)
  –  –  – – – –
```

### 7. cmp.a
Subtrai o conteúdo do registrador rs do registrador rd, e seta/limpa as flags C e Z de acordo com os resultados. Não muda o conteúdo de rd em sua execução.
```
15                                      0
[ 0 0 1 1 0 1 | D D D | 1 0 0 0 | S S S ]  
  OPCODE        RD                RS  

[ IL IE C V Z N ] (X : modifica flag)
  –  –  X X X X
  
```

### 7. jplt
Pula para o endereço relativo em SIGN7 se 
a flag de carry for 1 (ou seja, a comparação
detectou que rd < rs na comparação anterior)

```
15                                      0
[ 0 0 0 0 1 0   0 0 0 | S S S S   S S S ]  
  OPCODE                SIGN7

[ IL IE C V Z N ] (X : modifica flag)
  –  –  - - - -
```

## Código Executado

Na ROM atual, o seguinte código é executado:
```
nop
ld %r3, 0x00
ld %r4, 0x00
ld %r5, 0x01
ld %r6, 0x30
add %r4, %r3
add %r3, %r5 (r3 + 1)
nop
nop
cmp %r3, %r6 (r3, 30)
nop
nop
jplt -9
nop
nop
ld %r5, r4
```