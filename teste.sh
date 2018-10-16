#!/bin/bash
nasm -felf64 teste01.asm -o teste01.o;
ld -o teste01 teste01.o;
chmod u+x teste01