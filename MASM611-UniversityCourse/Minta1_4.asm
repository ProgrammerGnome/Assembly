;Alakítsa át a Read_char szubrutint úgy, hogy az ESC (27 kód) leütésére kilépjen a programból.

DOSSEG                  ; DOS specifikus szegmentálás beállítása.
.MODEL SMALL            ; Kis memória modell, ahol a kód és az adatok egy szegmensben vannak.
.STACK                  ; A stack (verem) használata a program számára.

.CODE
    ; A fő program eljárása
    main proc
        CALL read_char      ; Karakter beolvasása a felhasználótól.

        CALL cr_lf          ; Új sor kiírása a képernyő tisztasága érdekében.

        CALL write_char     ; A beolvasott karakter kiírása a képernyőre.

        MOV AH, 4Ch         ; Kilépés a DOS-ba a 4Ch interrupt kóddal.
        INT 21h             ; A DOS kilépési rutin meghívása.
    main endp

    ; Karakter beolvasása a felhasználótól
    read_char proc
        PUSH AX             ; AX regiszter mentése, mivel az interrupt módosítani fogja.
        MOV AH, 1           ; DOS 21h interrupt, 01h funkció: egy karakter beolvasása.
        INT 21h             ; A karakter beolvasása az AL regiszterbe kerül.
        MOV DL, AL          ; Az AL regiszterben lévő beolvasott karaktert DL-be helyezzük.
        CMP AL, 27          ; Ellenőrzés: ha az AL regiszterben lévő karakter 27 (ESC), akkor...
        JE exit_program     ; ...ugrás a program kilépési rutinjába.
        POP AX              ; AX visszaállítása az eredeti értékre.
        RET                 ; Visszatérés az eljárásból.
    
    ; Program kilépési rutinja
    exit_program:
        MOV AH, 4Ch         ; DOS 21h interrupt, 4Ch funkció: program kilépése.
        INT 21h             ; A program befejezése és visszatérés a DOS promptba.
        ; Megjegyzés: a verem tartalma nem lesz visszaállítva, mert a program kilép.
    read_char endp

    ; Karakter kiírása a képernyőre
    write_char proc
        PUSH AX             ; AX regiszter mentése, mivel az interrupt módosítani fogja.
        MOV AH, 2           ; DOS 21h interrupt, 02h funkció: egy karakter kiírása a DL-ből.
        INT 21h             ; A DL-ben lévő karakter kiírása a képernyőre.
        POP AX              ; AX visszaállítása az eredeti értékre.
        RET                 ; Visszatérés az eljárásból.
    write_char endp

    ; CR (Carriage Return) és LF (Line Feed) karakterek definiálása.
    CR EQU 13               ; Kocsivissza (CR) karakter (13-as kód, ASCII).
    LF EQU 10               ; Újsor (LF) karakter (10-es kód, ASCII).

    ; Új sor (CR és LF) kiírása
    cr_lf proc
        PUSH DX             ; DX regiszter mentése.
        MOV DL, CR          ; A CR (kocsivissza) karakter betöltése a DL-be.
        CALL write_char     ; A CR karakter kiírása.
        MOV DL, LF          ; Az LF (újsor) karakter betöltése a DL-be.
        CALL write_char     ; Az LF karakter kiírása.
        POP DX              ; DX visszaállítása az eredeti értékre.
        RET                 ; Visszatérés az eljárásból.
    cr_lf endp

END main                  ; A program végét jelzi.
