.MODEL SMALL
.STACK
.CODE
    main proc
        CALL read_decimal
        MOV AL, DL
        CALL cr_lf
        CALL read_decimal
        MOV BL, DL
        CALL cr_lf
        XOR DX, DX
        MOV CX, 8
    Cycle:
        SHL AL,1
        RCL DH,1
        SHL DL,1
        CMP DH, BL
        JB Next
        SUB DH, BL
        INC DL
    Next:
        LOOP Cycle
    Stop:
        CALL write_decimal
        CALL cr_lf
        MOV DL, DH
        CALL write_decimal
        MOV AH,4Ch
        INT 21h
    main endp
END main
