# Assembly and C linking
## This repository demonstrate how to linking C and Assembly (NASM 8086 x64) program, and I  excercised [8086 instruction set](https://www.javatpoint.com/instruction-set-of-8086).

#### [FOLDER] example-for-linking:
I wrote a for loop in Assembly, the maximum parameter of which is required to run it must be specified in a short C program.

#### [FOLDER] loop-in-NASM:
This program presented while, do while, for and nested for loop in NASM.

#### [FILE] ValentinesDay_finish.asm:
This program whit rich comments (english) demonstrated basic introduction in NASM.

## This code create on Linux, and the run following this steps:

Compile Assembly program:

	nasm -f elf64 -o assembly.o assembly.asm
Compile C program:

	gcc -c -o main.o main.c
Linking Assembly and C object file:

	gcc -o app_name main.o assembly.o -no-pie
Run the code:

	./app_name
