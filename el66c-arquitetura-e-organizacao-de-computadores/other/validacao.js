


// short RAM[127];

// int main()
// {
//     for(int i = 0; i < 33; i++)
//         RAM[i] = i;

//     for(int i = 0; i < 33; i++)
//     {
//         int val = RAM[i];
//         int x = 0;
//         while(val > 0) {
//             val -= 2;
//         }
//         if(val == 0) {
//             RAM[]
//         } else {

//         }
//     }
// }

const main = () => {
    let RAM = [];
    for(let i = 0; i < 33; i++)
        RAM[i] = i;

    for(let i = 0; i <= 33; i++)
    {
        let val = RAM[i];

        if(val <= 0)
            goto proximo
        val -= 2
        jump if

        while(val > 0)
            val -= 2;
        if(val == 0)
            RAM[i] = 0;
    }
    for(let i = 0; i < 33; i++)
    {
        let val = RAM[i];
        while(val > 0)
            val -= 3;
        if(val == 0)
            RAM[i] = 0;
    }
    for(let i = 0; i < 33; i++)
    {
        let val = RAM[i];
        while(val > 0)
            val -= 5;
        if(val == 0)
            RAM[i] = 0;
    }
    console.log(RAM);
}

main();