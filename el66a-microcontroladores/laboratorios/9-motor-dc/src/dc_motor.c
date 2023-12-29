// dc_motor.c
// Desenvolvido para a placa EK-TM4C1294XL
// Recebe e armazena dados do teclado que alteram o funcionamento do motor DC.
// Marcelo Fernandes e Bruno Colombo

#define LIB_LCD 2

#include <stdint.h>
#include "dc_motor.h"

//Armazena a velocidade do motor (0-100, % de PWM)
volatile int32_t motor_speed = 0;

//Armazena a direção do motor (0-1, Horário/Anti-Horário)
volatile uint32_t motor_direction = 0;

//Guarda a direção anterior do motor quando
//um pedido de troca de direção é efetuado.
volatile uint32_t motor_old_direction = 0;

//Controla se o modo "smooth" está ativo
volatile uint8_t smooth_mode = 1;

//Armazena a velocidade "smooth" do motor,
//que muda lentamente até alcançar a velocidade real do motor
volatile int32_t smooth_speed = 0;

//Armazena informação se é necessária uma troca de direção smooth
//(+Velocidade Atual -> 0 -> -Velocidade Atual)
volatile uint8_t smooth_swap = 0;

// -----------------------------------------------------------------------------
// Função Motor_Process
//--------------------------------
// Baseado no input recebido, armazena dados e inicia condições referentes
// ao funcionamento do motor.
// Após, a tela é atualizada para refletir as mudanças.
// Caso modo "smooth" esteja ativo, armazena informações extras
// para possibilitar transição suave.
//--------------------------------
// Entrada: input --> dado recebido de uma interface externa
// -----------------------------------------------------------------------------
void Motor_Process(int input)
{

    //Para o motor
    if (input == 0)
    {
        if (smooth_mode)
            smooth_speed = motor_speed;

        motor_speed = 0;

        Motor_DisplayStopped();

        return;
    }
    //Altera velocidade do motor dependendo do número escolhido
    else if (input >= 1 && input <= 7)
    {
        if (smooth_mode)
            smooth_speed = motor_speed;

        motor_speed = 30 + (input * 10);

        Motor_DisplayRunning();

        return;
    }
    //Altera direção para horário
    else if (input == '*')
    {
        if (smooth_mode)
        {
            if (motor_old_direction == 0)
                return;
            smooth_speed = motor_speed;
            smooth_swap = 1;
            motor_old_direction = motor_direction;
        }

        motor_direction = 0;

        Motor_DisplayRunning();

        return;
    }
    //Altera direção para anti-horário
    else if (input == '#')
    {
        if (smooth_mode)
        {
            if (motor_old_direction == 1)
                return;
            smooth_speed = motor_speed;
            smooth_swap = 1;

            motor_old_direction = motor_direction;
        }

        motor_direction = 1;

        Motor_DisplayRunning();
        return;
    }
    //Alterna modo "smooth"
    else if (input == 'A')
    {
        smooth_mode = !smooth_mode;
        smooth_speed = motor_speed;
        smooth_swap = 0;
        Motor_DisplayRunning();
    }
}

// -----------------------------------------------------------------------------
// Função Motor_Control
//--------------------------------
//Manda dados para o motor de acordo com valores atuais.
// -----------------------------------------------------------------------------
void Motor_Control(void)
{

    //Se está no modo smooth e se já passaram 40ms
    if (smooth_mode && (++smooth_counter >= 200))
    {
        smooth_counter = 0;

        //Se está fazedo uma transição suave, aproxima iterativamente o valor
        //de smooth_speed a 0. Após isso, Aproxima a velocidade suave ao valor
        //atual de velocidade.
        if (smooth_swap)
        {
            if (smooth_speed <= 0 || motor_speed <= 0)
            {
                smooth_swap = 0;
                motor_old_direction = motor_direction;
                return;
            }

            smooth_speed -= 10;
        }
        else
        {
            if (smooth_speed - motor_speed > 0)
                smooth_speed -= 10;
            else if (smooth_speed - motor_speed < 0)
                smooth_speed += 10;
        }
    }

    //Coloca o bit PWM como 0 ou 1 dependendo se a contagem
    //for maior do que a velocidade atual do motor desejada
    if (smooth_mode)
        pwm_bit = (pwm_counter >= (smooth_speed / 10));
    else
        pwm_bit = (pwm_counter >= (motor_speed / 10));

    uint8_t motor_output = 0x00;

    //Se motor não estiver parado ou se estiver no modo smooth e este ainda
    //não alcançou a velocidade final, envia dados não-zerados para o motor
    if (motor_speed || (smooth_mode && smooth_speed))
    {
        uint8_t direction;

        //Caso seja necessário inverter a direção suavemente, mantém a direção
        //antiga até velocidade smooth zerar
        if (smooth_swap)
            direction = motor_old_direction;
        else
            direction = motor_direction;

        //Coloca 1 no pino 1 ou 2 dependendo da direção
        motor_output |= 1 << (1 + direction);

        //Coloca PWM no pino 2 ou 1 dependendo da direção
        if (pwm_bit)
            motor_output |= 1 << (2 - direction);
    }

    PortF_Output_Dc_Motor(motor_output);
}

uint8_t motor_strings[][17] =
    {
        {"MOTOR PARADO    "},
        {"VELOCIDADE: XXX%"},
        {"ROTACAO: X      "},
        {"                "}};

// -----------------------------------------------------------------------------
// Função Motor_DisplayStopped
//--------------------------------
// Manda para o LCD mensagem informando que o motor está parado.
//--------------------------------
// Entrada: input --> dado recebido de uma interface externa
// -----------------------------------------------------------------------------
void Motor_DisplayStopped(void)
{
    LCD_PositionCursor(0, 0);
    LCD_PushCustomString(0, ((uint32_t)motor_strings));

    LCD_PositionCursor(1, 0);
    LCD_PushCustomString(3, ((uint32_t)motor_strings));
}

// -----------------------------------------------------------------------------
// Função Motor_DisplayRunning
//--------------------------------
// Manda para o LCD informações sobre velocidade, direção de rotação e se
// o modo smooth está ativado.
//--------------------------------
// Entrada: input --> dado recebido de uma interface externa
// -----------------------------------------------------------------------------
void Motor_DisplayRunning(void)
{

    //Só atualiza velocidade na tela se esta for maior que 0
    if (motor_speed > 0)
    {
        LCD_PositionCursor(0, 0);
        LCD_PushCustomString(1, ((uint32_t)motor_strings));

        LCD_PositionCursor(0, 12);

        //Se o 3o dígito (motor_speed/100) for 1, manda '1';
        //senão manda um espaço vazio
        LCD_PushChar(((motor_speed / 100) == 1) ? '1' : ' ');

        //Manda o 2o dígito ((motor_speed / 10) % 10) em ascii (+48)
        LCD_PushChar(((motor_speed / 10) % 10) + 48);

        //Manda o 3o dígito (motor_speed % 10) em ascii (+48)
        LCD_PushChar((motor_speed % 10) + 48);
    }

    LCD_PositionCursor(1, 0);
    LCD_PushCustomString(2, ((uint32_t)motor_strings));

    LCD_PositionCursor(1, 15);
    LCD_PushChar((smooth_mode) ? 'S' : ' ');

    //Escolhe entre o caractere "->" ou o próximo "<-" se motor_direction for 1
    LCD_PositionCursor(1, 9);
    LCD_PushChar(0x7E + motor_direction);
}
