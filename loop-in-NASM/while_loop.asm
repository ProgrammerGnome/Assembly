; Disassembly of file: while_loop.o
; Tue Mar 21 14:37:33 2023
; Type: ELF64
; Syntax: NASM
; Instruction set: 8086, x64

default rel

global main: function

extern printf                                           ; near


SECTION .text   align=1 execute                         ; section number 1, code

main:   ; Function begin
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        sub     rsp, 16                                 ; 0004 _ 48: 83. EC, 10
        mov     dword [rbp-4H], 0                       ; 0008 _ C7. 45, FC, 00000000
        jmp     ?_002                                   ; 000F _ EB, 1D

?_001:  add     dword [rbp-4H], 1                       ; 0011 _ 83. 45, FC, 01
        mov     eax, dword [rbp-4H]                     ; 0015 _ 8B. 45, FC
        mov     esi, eax                                ; 0018 _ 89. C6
        lea     rax, [rel ?_003]                        ; 001A _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0021 _ 48: 89. C7
        mov     eax, 0                                  ; 0024 _ B8, 00000000
        call    printf                                  ; 0029 _ E8, 00000000(PLT r)
?_002:  cmp     dword [rbp-4H], 10                      ; 002E _ 83. 7D, FC, 0A
        jnz     ?_001                                   ; 0032 _ 75, DD
        mov     eax, 0                                  ; 0034 _ B8, 00000000
        leave                                           ; 0039 _ C9
        ret                                             ; 003A _ C3
; main End of function


SECTION .data   align=1 noexecute                       ; section number 2, data


SECTION .bss    align=1 noexecute                       ; section number 3, bss


SECTION .rodata align=1 noexecute                       ; section number 4, const

?_003:                                                  ; byte
        db 25H, 64H, 00H                                ; 0000 _ %d.


SECTION .note.gnu.property align=8 noexecute            ; section number 5, const

        db 04H, 00H, 00H, 00H, 20H, 00H, 00H, 00H       ; 0000 _ .... ...
        db 05H, 00H, 00H, 00H, 47H, 4EH, 55H, 00H       ; 0008 _ ....GNU.
        db 02H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0010 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0018 _ ........
        db 01H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0020 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ ........


