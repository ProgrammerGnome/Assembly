;Írja ki a képernyőre (egymás alá) a szám karakterek ASCII kódját.

DOSSEG                  ; DOS specifikus szegmentálási beállítás.
.MODEL SMALL            ; Kis memória modell, ahol a kód és az adatok egy szegmensen belül vannak.
.STACK                  ; Verem definiálása.

.CODE
    ; Fő eljárás
    main proc
        MOV CX, 10          ; A CX regiszterbe 10 kerül, mivel 10 számjegy van (0-tól 9-ig).
        MOV DL, '0'         ; A DL regiszterbe a '0' karakter ASCII kódja kerül, innen kezdjük a kiírást.

    print_ascii_codes:
        MOV AH, 2           ; A DOS 21h interrupt 02h funkcióját használjuk a karakter kiírásához.
        INT 21h             ; A DL regiszterben lévő karaktert (a számjegyet) kiírjuk a képernyőre.
        CALL cr_lf          ; Új sor kiírása a következő megjelenítéshez.

        ; A karakter ASCII kódját készítjük elő kiírásra
        MOV DH, 0           ; A DH nullázása biztosítja, hogy a DX regiszterben csak a DL értéke legyen.
        MOV AX, DX          ; A DL-ben lévő karakter ASCII kódját az AX-be másoljuk.
        CALL write_decimal  ; Az AX-ben lévő ASCII kódot kiírjuk decimális formátumban.
        CALL cr_lf          ; Új sor kiírása az ASCII kód után.

        INC DL              ; A DL értékét növeljük, így a következő számjegy ASCII kódját kapjuk.
        LOOP print_ascii_codes ; Ismételjük a ciklust, amíg a CX el nem éri a 0-t (10 számjegy).

        ; Program befejezése
        MOV AH, 4Ch         ; DOS 21h interrupt 4Ch funkció: program befejezése.
        INT 21h             ; Kilépés a programból.
    main endp

    ; Egy karakter beolvasása (nem használt a fő programban, de itt van)
    read_char proc
        PUSH AX             ; AX regiszter mentése.
        MOV AH, 1           ; DOS 21h interrupt 01h funkció: egy karakter beolvasása.
        INT 21h             ; A beolvasott karakter az AL regiszterbe kerül.
        MOV DL, AL          ; Az AL-t a DL-be másoljuk.
        POP AX              ; AX visszaállítása.
        RET                 ; Visszatérés az eljárásból.
    read_char endp

    ; Egy karakter kiírása a képernyőre
    write_char proc
        PUSH AX             ; AX regiszter mentése.
        MOV AH, 2           ; DOS 21h interrupt 02h funkció: egy karakter kiírása a DL regiszterből.
        INT 21h             ; A DL-ben lévő karakter kiírása.
        POP AX              ; AX visszaállítása.
        RET                 ; Visszatérés az eljárásból.
    write_char endp

    ; CR és LF karakterek definiálása
    CR EQU 13               ; Kocsivissza (Carriage Return) karakter (ASCII kód: 13).
    LF EQU 10               ; Újsor (Line Feed) karakter (ASCII kód: 10).

    ; Új sor (CR és LF) kiírása
    cr_lf proc
        PUSH DX             ; DX regiszter mentése, mivel a DL-t módosítjuk.
        MOV DL, CR          ; A CR (kocsivissza) karakter betöltése a DL-be.
        CALL write_char     ; A CR karakter kiírása.
        MOV DL, LF          ; Az LF (újsor) karakter betöltése a DL-be.
        CALL write_char     ; Az LF karakter kiírása, így új sorba kerülünk.
        POP DX              ; DX visszaállítása az eredeti értékre.
        RET                 ; Visszatérés az eljárásból.
    cr_lf endp

    ; Az ASCII kód kiírása decimális formában
    write_decimal proc
        PUSH AX             ; AX, CX, DX, SI regiszterek mentése, mivel a divízió használja őket.
        PUSH CX
        PUSH DX
        PUSH SI
        XOR DH, DH          ; DH nullázása.
        MOV AX, DX          ; A DX-ben lévő ASCII kód AX-be másolása a kiíráshoz.
        MOV SI, 10          ; Tízes osztásra való előkészítés (decimális számrendszer).
        XOR CX, CX          ; CX nullázása, a számjegyek számlálásához.
    decimal_non_zero:
        XOR DX, DX          ; DX nullázása (divíziós maradék).
        DIV SI              ; AX osztása 10-zel (tízes számrendszerre váltás).
        PUSH DX             ; Az osztás maradékát (egy számjegyet) a verembe helyezzük.
        INC CX              ; CX növelése, hogy számláljuk a számjegyeket.
        OR AX, AX           ; Ellenőrizzük, hogy van-e még további számjegy.
        JNE decimal_non_zero ; Ha nem nulla az AX, folytatjuk az osztást.
    decimal_loop:
        POP DX              ; A következő számjegy elővétele a veremből.
        CALL write_hexa_digit  ; Kiírjuk a számjegyet.
        LOOP decimal_loop   ; Addig ismételjük, amíg a CX el nem éri a nullát.
        POP SI              ; SI visszaállítása.
        POP DX              ; DX visszaállítása.
        POP CX              ; CX visszaállítása.
        POP AX              ; AX visszaállítása.
        RET                 ; Visszatérés az eljárásból.
    write_decimal endp

    ; Egy számjegy kiírása
    write_hexa_digit proc
        PUSH DX             ; DX mentése.
        CMP DL, 10          ; Ellenőrzés: ha a számjegy kisebb, mint 10, akkor decimális.
        JB non_hexa_letter  ; Ha kisebb, ugrás a decimális részhez.
        ADD DL, "A"-"0"-10  ; Ha betű (10 vagy nagyobb), akkor 'A'-tól kezdődő ASCII kódok hozzáadása.
    non_hexa_letter:
        ADD DL, "0"         ; Az értéket ASCII kóddá alakítjuk.
        CALL write_char     ; A karakter kiírása.
        POP DX              ; DX visszaállítása.
        RET                 ; Visszatérés az eljárásból.
    write_hexa_digit endp

END main                 ; A program végét jelzi.
