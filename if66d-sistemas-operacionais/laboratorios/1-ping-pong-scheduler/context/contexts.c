#include <stdio.h>
//#include <printf.h>
#include <stdlib.h>
#include <ucontext.h>

//#define STACKSIZE 32768		/* tamanho de pilha das threads */
#define STACKSIZE 4096    /* tamanho de pilha das threads */
#define _XOPEN_SOURCE 600 /* para compilar no MacOS */

ucontext_t ContextPing, ContextPong, ContextMain;

/*****************************************************/
void UARTprintf(const char *pcString, ...);
int flag;
int memPC = 0;

////-D DEBUG -D gcc CFLAGS =-g -Wall -I. -mcpu=cortex-m4 -mfloat-abi=hard
////-D DEBUG -D gcc CFLAGS =-g -Wall -I. -mcpu=cortex-m4 -mfloat-abi=hard
void BodyPing_old (void * arg)
{
  int i ;

  UARTprintf ("PING  %s iniciada\n", (char *) arg) ;

  for (i=0; i<6; i++)
  {
     UARTprintf ("PING  %s %d\n", (char *) arg, i) ;
     swap_context_asm (&ContextPing, &ContextPong);
  }
  UARTprintf ("%s FIM\n", (char *) arg) ;

  swap_context_asm (&ContextPing, &ContextMain) ;
}

/*****************************************************/

void BodyPong_old (void * arg)
{
  int i ;

  UARTprintf ("PONG  %s iniciada\n", (char *) arg) ;

  for (i=0; i<6; i++)
  {
     UARTprintf ("PONG  %s %d\n", (char *) arg, i) ;
     swap_context_asm (&ContextPong, &ContextPing);
  }
  UARTprintf ("%s FIM\n", (char *) arg) ;

  swap_context_asm (&ContextPong, &ContextMain) ;
}

/*****************************************************/

//int main (int argc, char *argv[])
void teste_contexto(void)
{ 
    char *stack;

    UARTprintf("Main INICIO\n");

    asm("push {r3}");
    asm("pop  {r3}");

    stack = malloc(10);
    if (stack)
    {
        ContextPing.uc_stack.ss_sp = stack;
        ContextPing.uc_stack.ss_size = STACKSIZE;
        ContextPing.uc_stack.ss_flags = 0;
        ContextPing.uc_link = 0;
    }
    else
    {
        perror("Erro na criacao da pilha: ");
    }

    makecontext(&ContextPing, (int)(*BodyPing_old), 1, "    Ping");

    get_context_asm(&ContextPong);

    stack = malloc(STACKSIZE);
    if (stack)
    {
        ContextPong.uc_stack.ss_sp = stack;
        ContextPong.uc_stack.ss_size = STACKSIZE;
        ContextPong.uc_stack.ss_flags = 0;
        ContextPong.uc_link = 0;
    }
    else
    {
        perror("Erro na criacao da pilha: ");
    }

    makecontext(&ContextPong, (int)(*BodyPong_old), 1, "        Pong");

    swap_context_asm(&ContextMain, &ContextPing);
    swap_context_asm(&ContextMain, &ContextPong);

    UARTprintf("Main FIM\n");

    return;
}
