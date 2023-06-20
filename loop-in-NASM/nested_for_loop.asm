; Disassembly of file: nested_for_loop.o
; Tue Mar 21 14:45:10 2023
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
        mov     dword [rbp-8H], 2                       ; 0008 _ C7. 45, F8, 00000002
        jmp     ?_007                                   ; 000F _ EB, 52

?_001:  mov     dword [rbp-4H], 2                       ; 0011 _ C7. 45, FC, 00000002
        jmp     ?_003                                   ; 0018 _ EB, 11

?_002:  mov     eax, dword [rbp-8H]                     ; 001A _ 8B. 45, F8
        cdq                                             ; 001D _ 99
        idiv    dword [rbp-4H]                          ; 001E _ F7. 7D, FC
        mov     eax, edx                                ; 0021 _ 89. D0
        test    eax, eax                                ; 0023 _ 85. C0
        jz      ?_004                                   ; 0025 _ 74, 12
        add     dword [rbp-4H], 1                       ; 0027 _ 83. 45, FC, 01
?_003:  mov     eax, dword [rbp-8H]                     ; 002B _ 8B. 45, F8
        cdq                                             ; 002E _ 99
        idiv    dword [rbp-4H]                          ; 002F _ F7. 7D, FC
        cmp     dword [rbp-4H], eax                     ; 0032 _ 39. 45, FC
        jle     ?_002                                   ; 0035 _ 7E, E3
        jmp     ?_005                                   ; 0037 _ EB, 01

?_004:  nop                                             ; 0039 _ 90
?_005:  mov     eax, dword [rbp-8H]                     ; 003A _ 8B. 45, F8
        cdq                                             ; 003D _ 99
        idiv    dword [rbp-4H]                          ; 003E _ F7. 7D, FC
        cmp     dword [rbp-4H], eax                     ; 0041 _ 39. 45, FC
        jle     ?_006                                   ; 0044 _ 7E, 19
        mov     eax, dword [rbp-8H]                     ; 0046 _ 8B. 45, F8
        mov     esi, eax                                ; 0049 _ 89. C6
        lea     rax, [rel ?_008]                        ; 004B _ 48: 8D. 05, 00000000(rel)
        mov     rdi, rax                                ; 0052 _ 48: 89. C7
        mov     eax, 0                                  ; 0055 _ B8, 00000000
        call    printf                                  ; 005A _ E8, 00000000(PLT r)
?_006:  add     dword [rbp-8H], 1                       ; 005F _ 83. 45, F8, 01
?_007:  cmp     dword [rbp-8H], 99                      ; 0063 _ 83. 7D, F8, 63
        jle     ?_001                                   ; 0067 _ 7E, A8
        mov     eax, 0                                  ; 0069 _ B8, 00000000
        leave                                           ; 006E _ C9
        ret                                             ; 006F _ C3
; main End of function


SECTION .data   align=1 noexecute                       ; section number 2, data


SECTION .bss    align=1 noexecute                       ; section number 3, bss


SECTION .rodata align=1 noexecute                       ; section number 4, const

?_008:                                                  ; byte
        db 25H, 64H, 20H, 69H, 73H, 20H, 70H, 72H       ; 0000 _ %d is pr
        db 69H, 6DH, 65H, 0AH, 00H                      ; 0008 _ ime..


SECTION .note.gnu.property align=8 noexecute            ; section number 5, const

        db 04H, 00H, 00H, 00H, 20H, 00H, 00H, 00H       ; 0000 _ .... ...
        db 05H, 00H, 00H, 00H, 47H, 4EH, 55H, 00H       ; 0008 _ ....GNU.
        db 02H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0010 _ ........
        db 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0018 _ ........
        db 01H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H      ; 0020 _ ........
        db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H       ; 0028 _ ........


