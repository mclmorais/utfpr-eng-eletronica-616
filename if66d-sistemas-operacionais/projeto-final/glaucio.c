#include "utils.h"
void SysTick_Wait1us(int time_in_us)
{
  SysCtlDelay(time_in_us * 40);
}
void SysTick_Wait1ms(int time_in_ms)
{
  SysCtlDelay(time_in_ms * 40000);
}

/* reverse:  reverse string s in place */
static void reverse( char s[] )
{
  int i, j ;
  char c ;

  for ( i = 0, j = strlen(s)-1 ; i < j ; i++, j-- )
  {
    c = s[i] ;
    s[i] = s[j] ;
    s[j] = c ;
  }
}

/* itoa:  convert n to characters in s */
void itoa(int n, char s[])
{
  int i, sign;

  if ((sign = n) < 0) /* record sign */
  {
    n = -n; /* make n positive */
  }

  i = 0;
  do
  {                        /* generate digits in reverse order */
    s[i++] = n % 10 + '0'; /* get next digit */
  } while ((n /= 10) > 0); /* delete it */

  if (sign < 0)
  {
    s[i++] = '-';
  }

  s[i] = '\0';

  reverse(s);
}
