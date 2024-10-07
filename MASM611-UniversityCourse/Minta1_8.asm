;Írja ki a képernyőre (egymás alá) a szám karaktereket.

DOSSEG                  ; DOS specifikus szegmentálás beállítása.
.MODEL SMALL            ; Kis memória modell, ahol a kód és az adatok egy szegmensben vannak.
.STACK                  ; Verem definiálása a program számára.

.CODE
    ; Fő eljárás
    main proc
        MOV CX, 10          ; A CX regiszterbe 10 kerül, mivel 10 számjegy van (0-tól 9-ig).
        MOV DL, '0'         ; A DL regiszterbe a '0' számjegy ASCII kódja kerül, innen kezdjük a kiírást.

    print_numchar:
        MOV AH, 2           ; A DOS 21h interrupt 02h funkcióját használjuk a karakter kiírásához.
        INT 21h             ; A DL regiszterben lévő számjegyet kiírjuk a képernyőre.
        CALL cr_lf          ; Minden számjegy után új sort írunk ki.

        INC DL              ; A DL értékét növeljük, így a következő számjegy ASCII kódját kapjuk.
        LOOP print_numchar  ; A ciklus addig ismétlődik, amíg CX el nem éri a 0-t (10 számjegy kiírása).

        ; Program befejezése
        MOV AH, 4Ch         ; DOS 21h interrupt 4Ch funkció: program befejezése.
        INT 21h             ; Kilépés a programból.
    main endp

    ; Egy karakter kiírása a képernyőre
    write_char proc
        PUSH AX             ; AX regiszter mentése.
        MOV AH, 2           ; DOS 21h interrupt 02h funkció: egy karakter kiírása a DL regiszterből.
        INT 21h             ; A DL-ben lévő karakter kiírása.
        POP AX              ; AX visszaállítása az eredeti értékre.
        RET                 ; Visszatérés az eljárásból.
    write_char endp

    ; CR és LF karakterek definiálása
    CR EQU 13               ; Kocsivissza (Carriage Return) karakter (ASCII kód: 13).
    LF EQU 10               ; Újsor (Line Feed) karakter (ASCII kód: 10).

    ; Új sor (CR és LF) kiírása
    cr_lf proc
        PUSH DX             ; DX regiszter mentése, mivel a DL-t fogjuk módosítani.
        MOV DL, CR          ; A CR (kocsivissza) karakter betöltése a DL-be.
        CALL write_char     ; A CR karakter kiírása.
        MOV DL, LF          ; Az LF (újsor) karakter betöltése a DL-be.
        CALL write_char     ; Az LF karakter kiírása, így új sorba kerülünk.
        POP DX              ; DX visszaállítása az eredeti értékre.
        RET                 ; Visszatérés az eljárásból.
    cr_lf endp

END main                 ; A program végét jelzi.
