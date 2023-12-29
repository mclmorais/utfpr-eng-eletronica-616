int primoAtual = 2;
int RAM[128];

int main()
{
    verifica_primos();
    if(primoAtual == 2)
    {
        primoAtual = 3;
        verifica_primos();
    }
    else if (primoAtual == 3)
    {
        primoAtual = 3;
        verifica_primos();
    }
    else
    {
        primoAtual = 5;
        verifica_primos();
    }


    for(int i = 0; i < 33; i++)
    {
        printf("%i", RAM[i]); //Em R3
    }
}

void verifica_primos()
{
    for (int i = 0; i < 33; i++)
    {
        int numeroAtual = RAM[i];

        while (numeroAtual > 0)
        {
            numeroAtual -= primoAtual;
        }

        //Se o número atual ficou exatamente zero,
        //significa que não é primo
        if (numeroAtual == 0)
            RAM[i] = 0;
    }
}