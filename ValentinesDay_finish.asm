; Assembly program for Valentine's Day

; Syntax: NASM (for Netwide Assembler)
; Instruction set: 8086, x64

default rel     ;for string variables

;LEA+MOV, TEST+JNZ, CALL+JMP (generally pairs)

global main:
    mov rbp, rsp; for correct debugging function

extern __stack_chk_fail                                 ; load external C function
extern putchar                                          ; (eg. #include in C/C++)
extern puts                                             ; 
extern strcmp                                           ; 
extern __isoc99_scanf                                   ; 
extern printf                                           ; 


SECTION .text   align=1 execute                         ; section number: 1, code

; Function begin
main:   
        push    rbp                                     ; base pointer REG. -> top of the stack
        mov     rbp, rsp                                ; 
        sub     rsp, 32                                 ; - 32 byte (in stack pointer REG.)
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        mov     rax, qword [fs:abs 28H]                 ; "28H" RAM adress (qword, 8 byte data) -> arithmetic REG.
        mov     qword [rbp-8H], rax                     ; arithmetic REG.'s data -> base pointer REG.: -8 byte
        xor     eax, eax                                ; values: 0 (false)
        lea     rax, [rel ?_005]                        ; ?_005 RAM offset (string) load to arithm. REG.
        mov     rdi, rax                                ; rdi: string mov. destination REG.
        mov     eax, 0                                  ; clear accumulator REG.
        call    printf                                  ; call printf C function
        lea     rax, [rbp-12H]                          ; (base pointer REG. -12 byte) load to arithm.REG. 
        mov     rsi, rax                                ; rsi: string mov. instruction REG.
        lea     rax, [rel ?_006]                        ; ?_006 RAM offset (string) load to arithm. REG.
        mov     rdi, rax                                ; 
        mov     eax, 0                                  ; clear accumulator REG.
        call    __isoc99_scanf                          ; call scanf C function
        lea     rax, [rbp-12H]                          ; (base pointer REG. -12 byte) load to arithm. REG.
        lea     rdx, [rel ?_007]                        ; ?_007 RAM offset (string) load to I/O REG.
        mov     rsi, rdx                                ; 
        mov     rdi, rax                                ; 
        call    strcmp                                  ; call strcmp C function
        test    eax, eax                                ; if eax = 0 (false):
        jnz     ?_001                                   ; ..........jump to ?_001 RAM offset (instruction)
        lea     rax, [rel ?_008]                        ; ?_008 RAM offset (string) load to arithm. REG.
        mov     rdi, rax                                ; 
        call    puts                                    ; call puts C function for print
        jmp     ?_003                                   ; jump to ?_003 RAM offset (instruction)

?_001:  lea     rax, [rbp-12H]                          ; 
        lea     rdx, [rel ?_009]                        ; ?_009 RAM offset (string) load to I/O REG.
        mov     rsi, rdx                                ; 
        mov     rdi, rax                                ; 
        call    strcmp                                  ; call strcmp C function
        test    eax, eax                                ; if eax = 0 (false):
        jnz     ?_002                                   ; ..........jump to ?_002 RAM offset (instruction)
        lea     rax, [rel ?_010]                        ; ?_010 RAM offset (string) load to arithm. REG.
        mov     rdi, rax                                ; 
        call    puts                                    ; call puts C function for print
        jmp     ?_003                                   ; jump to RAM offset (instruction)

?_002:  mov     edi, 10                                 ; 
        call    putchar                                 ; 
?_003:  mov     eax, 0                                  ; 
        mov     rdx, qword [rbp-8H]                     ; base pointer REG.'s qword data (8 byte) -> I/O REG.
; Note: Address is not rip-relative
; Note: Absolute memory address without relocation
        sub     rdx, qword [fs:abs 28H]                 ; "28H" RAM addr. data (qword, 8byte) remove from I/O REG.
        jz      ?_004                                   ; jump ?_004 RAM offset (instruction)
        call    __stack_chk_fail                        ; if back step not successed -> check 'stack overflow' :'D
?_004:  leave                                           ; 
        ret                                             ; RETURN to main program
; main End of function


?_005:                                                  ; byte
        db 56H, 61H, 6EH, 20H, 62H, 61H, 72H, 61H       ; Van bara
        db 74H, 6FH, 64H, 3FH, 20H, 28H, 76H, 61H       ; tod? (va
        db 6EH, 2FH, 6EH, 69H, 6EH, 63H, 73H, 29H       ; n/nincs)
        db 20H, 00H                                     ; .

?_006:                                                  ; byte
        db 25H, 73H, 00H                                ; %s.

?_007:                                                  ; byte
        db 6EH, 69H, 6EH, 63H, 73H, 00H                 ; nincs.

?_008:                                                  ; byte
        db 53H, 7AH, 65H, 72H, 65H, 74H, 6EH, 65H       ; Szeretne
        db 6BH, 20H, 76H, 65H, 6CH, 65H, 64H, 20H       ; k veled 
        db 69H, 73H, 6DH, 65H, 72H, 6BH, 65H, 64H       ; ismerked
        db 6EH, 69H, 00H                                ; ni.

?_009:                                                  ; byte
        db 76H, 61H, 6EH, 00H                           ; van.

?_010:                                                  ; byte
        db 74H, 65H, 20H, 6BH, 75H, 72H, 76H, 61H       ; te kurva
        db 00H                                          ; .
