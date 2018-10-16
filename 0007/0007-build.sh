#!/bin/bash
nasm -felf64 0007-strlen.asm -o 0007-strlen.o;
ld -o 0007-strlen 0007-strlen.o;
chmod u+x 0007-strlen