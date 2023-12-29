# Projeto Final

## Extração de imagens

Comando utilizado: 

```
$ ./ffmpeg.exe -i GPR1.mp4 -vf "select=not(mod(n\,50))" -vsync vfr img_%04d.png
```