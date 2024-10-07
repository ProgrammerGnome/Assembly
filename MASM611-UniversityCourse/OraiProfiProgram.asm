; DOS specifikus szegmentálás
DOSSEG 

; Kis memória modell, ahol a kód és az adatok egy szegmensben vannak
.MODEL SMALL 
.STACK ; Verem (stack) definiálása

.CODE

    main proc
        ; Eredetileg karakterek beolvasása, most kikommentezve:
        ;CALL read_char
        ;CALL read_decimal ; Decimális érték beolvasása

        CALL read_hexa    ; Hexadecimális érték beolvasása
        ;CALL read_binary  ; Bináris érték beolvasása (kikommentezve)

        CALL cr_lf        ; Új sor kiírása

        ; Eredetileg karakterek írása, most kikommentezve:
        ;CALL write_char   ; Karakter kiírása
        ;CALL write_binary ; Bináris érték kiírása (kikommentezve)
        ;CALL write_hexa   ; Hexadecimális érték kiírása (kikommentezve)
        CALL write_decimal ; Decimális érték kiírása

        ; Program befejezése és visszatérés a DOS promptba
        MOV AH,4Ch
        INT 21h
    main endp

    ; Egy karakter beolvasása a felhasználótól
    read_char proc
        PUSH AX           ; AX regiszter mentése
        MOV AH, 1         ; DOS 21h interrupt, 01h funkció: karakter beolvasása
        INT 21h           ; Beolvasott karakter az AL regiszterbe kerül
        MOV DL, AL        ; Az AL tartalmát átmásoljuk DL-be
        POP AX            ; AX visszaállítása
        RET               ; Visszatérés az eljárásból
    read_char endp

    ; Egy karakter kiírása a képernyőre
    write_char proc
        PUSH AX           ; AX regiszter mentése
        MOV AH, 2         ; DOS 21h interrupt, 02h funkció: egy karakter kiírása a DL-ből
        INT 21h           ; A DL-ben lévő karakter kiírása
        POP AX            ; AX visszaállítása
        RET               ; Visszatérés az eljárásból
    write_char endp

    ; CR (Carriage Return) és LF (Line Feed) karakterek definiálása
    CR EQU 13            ; Kocsivissza (ASCII 13)
    LF EQU 10            ; Újsor (ASCII 10)

    ; Új sor (CR és LF) kiírása
    cr_lf proc
        PUSH DX           ; DX regiszter mentése
        MOV DL, CR        ; Kocsivissza karakter betöltése a DL-be
        CALL write_char   ; A CR karakter kiírása
        MOV DL, LF        ; Újsor karakter betöltése a DL-be
        CALL write_char   ; Az LF karakter kiírása
        POP DX            ; DX visszaállítása
        RET               ; Visszatérés az eljárásból
    cr_lf endp

    ; Bináris szám kiírása
    write_binary proc
        PUSH BX           ; BX regiszter mentése
        PUSH CX           ; CX regiszter mentése
        PUSH DX           ; DX regiszter mentése
        MOV BL, DL        ; DL tartalmát (bináris érték) BL-be helyezzük
        MOV CX, 8         ; 8 bites bináris szám kiírása

    binary_digit:
        XOR DL, DL        ; DL nullázása
        RCL BL, 1         ; Bit eltolása balra, hogy a legmagasabb helyértékű bitet kinyerjük
        ADC DL, "0"       ; ASCII "0" vagy "1" létrehozása az aktuális bit alapján
        CALL write_char   ; Bit kiírása
        LOOP binary_digit ; Ismétlés amíg CX nullára nem csökken (8 bit kiírása)
        
        POP DX            ; DX visszaállítása
        POP CX            ; CX visszaállítása
        POP BX            ; BX visszaállítása
        RET               ; Visszatérés az eljárásból
    write_binary endp

    ; Hexadecimális szám kiírása
    write_hexa proc
        PUSH CX           ; CX regiszter mentése
        PUSH DX           ; DX regiszter mentése
        MOV DH, DL        ; DL tartalmát (hexadecimális szám) DH-ba másoljuk
        MOV CL, 4         ; 4 bites eltolást készítünk elő
        SHR DL, CL        ; Felső 4 bit levágása
        CALL write_hexa_digit ; Felső 4 bit kiírása
        MOV DL, DH        ; Az eredeti DL visszaállítása
        AND DL, 0Fh       ; Alsó 4 bit kiemelése
        CALL write_hexa_digit ; Alsó 4 bit kiírása
        POP DX            ; DX visszaállítása
        POP CX            ; CX visszaállítása
        RET               ; Visszatérés az eljárásból
    write_hexa endp

    ; Egy hexadecimális számjegy kiírása
    write_hexa_digit proc
        PUSH DX           ; DX regiszter mentése
        CMP DL, 10        ; Ellenőrzés: ha DL kisebb, mint 10, akkor decimális számjegy
        JB non_hexa_letter ; Ha kisebb, ugrás a decimális részhez
        ADD DL, "A"-"0"-10 ; Ha nagyobb, akkor 'A'-'F' közötti betű hozzáadása
    non_hexa_letter:
        ADD DL, "0"       ; Decimális számjegyek ASCII kódjának hozzáadása
        CALL write_char   ; Számjegy kiírása
        POP DX            ; DX visszaállítása
        RET               ; Visszatérés az eljárásból
    write_hexa_digit endp

    ; Decimális szám kiírása
    write_decimal proc
        PUSH AX           ; AX regiszter mentése
        PUSH CX           ; CX regiszter mentése
        PUSH DX           ; DX regiszter mentése
        PUSH SI           ; SI regiszter mentése
        XOR DH, DH        ; DH nullázása
        MOV AX, DX        ; DX-ben lévő számot AX-be helyezzük
        MOV SI, 10        ; Tízes számrendszer
        XOR CX, CX        ; CX nullázása (számjegyek számlálása)

    decimal_non_zero:
        XOR DX, DX        ; DX nullázása
        DIV SI            ; AX osztása 10-zel
        PUSH DX           ; Az osztás maradékát verembe helyezzük (egy számjegy)
        INC CX            ; CX számlálása
        OR AX, AX         ; Ellenőrzés, hogy van-e még számjegy
        JNE decimal_non_zero ; Ha AX nem nulla, folytatjuk
    decimal_loop:
        POP DX            ; A veremből a következő számjegy
        CALL write_hexa_digit ; Kiírjuk a számjegyet (decimális módon)
        LOOP decimal_loop ; Ismétlés, amíg CX nullára nem csökken
        POP SI            ; SI visszaállítása
        POP DX            ; DX visszaállítása
        POP CX            ; CX visszaállítása
        POP AX            ; AX visszaállítása
        RET               ; Visszatérés az eljárásból
    write_decimal endp

    ; Decimális szám beolvasása
    read_decimal proc
        PUSH AX           ; AX regiszter mentése
        PUSH BX           ; BX regiszter mentése
        MOV BL, 10        ; Tízes számrendszer beállítása
        XOR AX, AX        ; AX nullázása

    read_decimal_new:
        CALL read_char    ; Karakter beolvasása
        CMP DL, CR        ; Ellenőrzés: ha kocsivissza (CR), befejezzük a beolvasást
        JE read_decimal_end
        SUB DL, "0"       ; ASCII karakter átalakítása számjeggyé
        MUL BL            ; AX szorzása 10-zel
        ADD AL, DL        ; A beolvasott számjegy hozzáadása
        JMP read_decimal_new
    read_decimal_end:
        MOV DL, AL        ; Eredmény DL-be helyezése
        POP BX            ; BX visszaállítása
        POP AX            ; AX visszaállítása
        RET               ; Visszatérés az eljárásból
    read_decimal endp

    ; Hexadecimális szám beolvasása
    read_hexa proc
        PUSH AX           ; AX regiszter mentése
        PUSH BX           ; BX regiszter mentése
        MOV BL, 10h       ; Hexadecimális számrendszer beállítása
        XOR AX, AX        ; AX nullázása

    read_hexa_new:
        CALL read_char    ; Karakter beolvasása
        CMP DL, CR        ; Ellenőrzés: ha kocsivissza (CR), befejezzük a beolvasást
        JE read_hexa_end
        CALL upcase       ; Kisbetűk nagybetűsre alakítása
        SUB DL, "0"       ; ASCII karakter számjeggyé alakítása
        CMP DL, 9         ; Ellenőrzés: 0-9 közötti számjegy
        JBE read_hexa_decimal
        SUB DL,7          ; Ha 'A'-'F', átalakítjuk megfelelő hexadecimális értékre
    read_hexa_decimal:
        MUL BL            ; AX szorzása 16-tal
        ADD AL, DL        ; A beolvasott számjegy hozzáadása
        JMP read_hexa_new
    read_hexa_end:
        MOV DL, AL        ; Eredmény DL-be helyezése
        POP BX            ; BX visszaállítása
        POP AX            ; AX visszaállítása
        RET               ; Visszatérés az eljárásból
    read_hexa endp

    ; Kisbetűk nagybetűsre alakítása
    upcase proc
        CMP DL, "a"       ; Ha a karakter 'a'-nál kisebb, nincs teendő
        JB upcase_end
        CMP DL, "z"       ; Ha a karakter 'z'-nél nagyobb, nincs teendő
        JA upcase_end
        SUB DL, "a"-"A"   ; Kisbetű átalakítása nagybetűvé
    upcase_end:
        RET               ; Visszatérés az eljárásból
    upcase endp

    ; Bináris szám beolvasása
    read_binary proc
        PUSH AX           ; AX regiszter mentése
        XOR AX, AX        ; AX nullázása

    read_binary_new:
        CALL read_char    ; Karakter beolvasása
        CMP DL, CR        ; Ellenőrzés: ha kocsivissza (CR), befejezzük a beolvasást
        JE read_binary_end
        SUB DL, "0"       ; ASCII '0' vagy '1' számjeggyé alakítása
        SAL AL, 1         ; AX balra tolása (szorzás 2-vel)
        ADD AL, DL        ; A beolvasott bit hozzáadása
        JMP read_binary_new
    read_binary_end:
        MOV DL, AL        ; Eredmény DL-be helyezése
        POP AX            ; AX visszaállítása
        RET               ; Visszatérés az eljárásból
    read_binary endp

END main ; A program végét jelzi
