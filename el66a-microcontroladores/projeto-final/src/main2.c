// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Inicializa periféricos e faz um loop de polling
// e atualização do funcionamento do motor.
// Marcelo Fernandes e Bruno Colombo

#include "main.h"

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	Keyboard_Init();
	Timer_Init();

	char ic_code[] = "74LS00`";
	int pos = Verify_mem(ic_code);

	if (pos > -1)
	{
		GPIO_config(pos);
	}

	return 0;
}
