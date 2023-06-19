; Syntax: NASM
; Instruction set: 8086, x64

default rel

extern printf
extern my_variable

section .data
    my_variable: dd 0

SECTION .text
    global for_2

for_2:  push    rbp                                     
        mov     rbp, rsp                             
        sub     rsp, 16                                 
        mov     dword [rbp-4H], 0                       
        jmp     ?_002                                   

?_001:  mov     eax, dword [rbp-4H]                     
        mov     esi, eax                               
        lea     rax, [rel ?_003]                      
        mov     rdi, rax                                
        mov     eax, 0                                  
        call    printf                                  
        add     dword [rbp-4H], 1                       
?_002:  mov     eax, [my_variable]
        cmp     dword [rbp-4H], eax                    
        jle     ?_001                                   
        mov     eax, 0                                  
        leave                                           
        ret                                             

?_003:                                                  
        db 25H, 64H, 00H