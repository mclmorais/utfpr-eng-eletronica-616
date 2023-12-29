#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main (int argc, char *argv[], char *envp[])
{
    int retval = fork(); //Cria um processo filho que vai receber as mensagens.
    printf("Retval: %i\n", retval);
    printf("msg: %s\n", *envp);
    if(retval > 0)
        execve ("./mqueue-send", argv, envp) ; //O processo pai envia mensagens.
    else	
        execve ("./mqueue-recv", argv, envp) ; //O processo filho recebe mensagens.
}	