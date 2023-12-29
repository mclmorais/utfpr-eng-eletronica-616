// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Inicializa periféricos e faz um loop de polling 
// e atualização do funcionamento do motor.
// Marcelo Fernandes e Bruno Colombo

#include <stdint.h>
#include "globals.h"
#include "lcd.h"
#include "dc_motor.h"
#include "utils.h"
#include "keyboard.h"
#include "timer.h"

void PLL_Init(void);
void SysTick_Init(void);
void GPIO_Init(void);
uint32_t PortJ_Input(void);
void PortN_Output(uint32_t leds);



int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
    LCD_Init();
	Keyboard_Init();
    Timer_Init();
    
    Motor_Process(0);

	while(1) 
	{
		//Se passaram 500*200us = 100ms, faz polling do teclado
		//e manda processar dado lido para o motor
		if(keyboard_counter >= 500) {
			Motor_Process(Keyboard_Poll());
            keyboard_counter = 0;
        }
	}
}

