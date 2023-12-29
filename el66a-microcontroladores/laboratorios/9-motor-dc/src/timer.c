#include "timer.h"

volatile uint32_t timer_counter = 0;
volatile uint32_t pwm_counter = 0;
volatile uint8_t pwm_bit = 0;
volatile uint32_t keyboard_counter = 0;
volatile uint32_t smooth_counter = 0;

// -----------------------------------------------------------------------------
// Fun��o Timer_Init
//--------------------------------
// Inicializa Timer 0 no modo A (32 bits) e com interrup��o a cada 200 us.
// -----------------------------------------------------------------------------
void Timer_Init(void)
{
    SYSCTL_RCGCTIMER_R |= SYSCTL_RCGCTIMER_R0;

    while ((SYSCTL_RCGCTIMER_R & SYSCTL_RCGCTIMER_R0) != SYSCTL_RCGCTIMER_R0)
    {
    };

    TIMER0_CTL_R &= ~0x01;

    TIMER0_CFG_R = 0x00;

    TIMER0_TAMR_R &= ~0x03;
    TIMER0_TAMR_R |= 0x02;

    //TIMER0_TAILR_R  = 0x00013880; //= 1ms * 80e6hz

    TIMER0_TAILR_R = 0x00003E80; //=200us * 80e6hz

    TIMER0_ICR_R |= 0x01;

    TIMER0_IMR_R |= 0x01;

    NVIC_PRI4_R &= ~0xE0000000;

    NVIC_EN0_R |= 0x80000;

    TIMER0_CTL_R |= 0x01;
}

// -----------------------------------------------------------------------------
// Fun��o Timer0A_Handler
//--------------------------------
// Interrup��o gerada pelo Timer 0
// -----------------------------------------------------------------------------
void Timer0A_Handler(void)
{
    TIMER0_ICR_R |= 0x01;

    //Incrementa pwm_counter e coloca pra zero se passar de 10 (2ms/500hz)
    if (++pwm_counter >= 10)
        pwm_counter = 0;

    //Aumenta contagem do contador de teclado (verificado na thread)
    keyboard_counter++;

    //Manda dados para o motor
    Motor_Control();
}
