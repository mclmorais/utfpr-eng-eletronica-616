#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[], char *envp[])
{
    int retval = fork();
    if (retval == 0)
        execve("./mqueue-send", argv, envp);
    else
        execve("./mqueue-recv", argv, envp);
}