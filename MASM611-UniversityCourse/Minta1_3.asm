;Alakítsa át a Read_hexa szubrutint úgy, hogy csak a tizenhatos számrendszernek megfelelő karaktereket fogadja el.

DOSSEG                  ; DOS specifikus szegmentálás beállítása.
.MODEL SMALL            ; Kis memória modell, ahol a kód és az adatok ugyanazon a szegmensen belül helyezkednek el.
.STACK 100h             ; 256 bájtos verem lefoglalása.

.DATA
    ; Az adat szegmens üres, mivel nincs statikus adat, amit deklarálnánk.

.CODE
    main proc
        ; Beolvassuk a hexadecimális számot a felhasználótól.
        CALL read_hexa
        
        ; Új sort írunk ki a képernyő tisztasága érdekében.
        CALL cr_lf
        
        ; Kiírjuk a beolvasott számot tízes számrendszerben.
        CALL write_decimal

        ; Kilépés a programból.
        MOV AH, 4Ch       ; DOS kilépési kód.
        INT 21h           ; Kilépés a DOS promptba.
    main endp

    ; Egy karakter beolvasása a felhasználótól.
    read_char proc
        PUSH AX           ; AX regiszter értékének mentése.
        MOV AH, 1         ; DOS 21h interrupt, 01h funkció: egy karakter beolvasása.
        INT 21h           ; A karakter beolvasása az AL regiszterbe.
        MOV DL, AL        ; Az AL tartalmát DL-be helyezzük.
        POP AX            ; AX visszaállítása.
        RET               ; Visszatérés az eljárásból.
    read_char endp

    ; Egy karakter kiírása a képernyőre.
    write_char proc
        PUSH AX           ; AX regiszter értékének mentése.
        MOV AH, 2         ; DOS 21h interrupt, 02h funkció: egy karakter kiírása a DL-ből.
        INT 21h           ; A karakter kiírása a képernyőre.
        POP AX            ; AX visszaállítása.
        RET               ; Visszatérés az eljárásból.
    write_char endp

    ; CR és LF karakterek definiálása.
    CR EQU 13             ; Kocsivissza (Carriage Return) karakter.
    LF EQU 10             ; Újsor (Line Feed) karakter.

    ; Új sor (CR és LF) kiírása.
    cr_lf proc
        PUSH DX           ; DX regiszter értékének mentése.
        MOV DL, CR        ; Kocsivissza karakter betöltése a DL-be.
        CALL write_char   ; CR karakter kiírása.
        MOV DL, LF        ; Újsor karakter betöltése a DL-be.
        CALL write_char   ; LF karakter kiírása.
        POP DX            ; DX visszaállítása.
        RET               ; Visszatérés az eljárásból.
    cr_lf endp

    ; Tízes számrendszerű érték kiírása.
    write_decimal proc
        PUSH AX           ; AX, CX, DX és SI regiszterek mentése.
        PUSH CX
        PUSH DX
        PUSH SI
        XOR DH, DH        ; DH nullázása.
        MOV AX, DX        ; Az eredmény AX-be helyezése.
        MOV SI, 10        ; Tízes számrendszer beállítása.
        XOR CX, CX        ; CX nullázása (számjegyek számának számlálása).
    decimal_non_zero:
        XOR DX, DX        ; DX nullázása.
        DIV SI            ; AX osztása 10-zel.
        PUSH DX           ; Az osztás maradékát (egy számjegy) betoljuk a verembe.
        INC CX            ; Számjegyszámláló növelése.
        OR AX, AX         ; AX tesztelése, hogy van-e még számjegy.
        JNE decimal_non_zero ; Ha nem nulla, folytatjuk az osztást.
    decimal_loop:
        POP DX            ; A következő számjegy elővétele a veremből.
        CALL write_hexa_digit ; Kiírjuk a számjegyet.
        LOOP decimal_loop ; Minden számjegyet kiírunk, amíg a CX nullára nem csökken.
        POP SI            ; SI visszaállítása.
        POP DX            ; DX visszaállítása.
        POP CX            ; CX visszaállítása.
        POP AX            ; AX visszaállítása.
        RET               ; Visszatérés az eljárásból.
    write_decimal endp

    ; Hexadecimális számjegy kiírása.
    write_hexa_digit proc
        PUSH DX           ; DX regiszter mentése.
        CMP DL, 10        ; DL összehasonlítása 10-zel (számjegy vagy betű).
        JB non_hexa_letter ; Ha kisebb, akkor számjegy.
        ADD DL, "A"-"0"-10 ; Betűk esetén a megfelelő 'A'-tól induló karakterkódot hozzáadjuk.
    non_hexa_letter:
        ADD DL, "0"       ; A számjegyeket ASCII kóddá alakítjuk.
        CALL write_char   ; Kiírjuk a karaktert.
        POP DX            ; DX visszaállítása.
        RET               ; Visszatérés az eljárásból.
    write_hexa_digit endp

    ; Hexadecimális szám beolvasása a felhasználótól.
    read_hexa proc
        PUSH AX           ; AX és BX regiszterek mentése.
        PUSH BX
        MOV BL, 16        ; A BL-be 16 kerül, mivel hexadecimális számrendszerrel dolgozunk.
        XOR AX, AX        ; AX nullázása (itt fogjuk tárolni a beolvasott hexadecimális számot).
    read_hexa_new:
        CALL read_char    ; Egy karakter beolvasása.
        CMP DL, CR        ; Ellenőrzés: ha CR (Enter), akkor befejezzük a beolvasást.
        JE read_hexa_end
        CALL upcase       ; Kisbetűk átalakítása nagybetűkké.
        CMP DL, '0'       ; Ellenőrzés, hogy '0' és '9' közötti számjegy-e.
        JB read_hexa_skip ; Ha kisebb, mint '0', érvénytelen karakter.
        CMP DL, '9'
        JA read_hexa_check_alpha ; Ha nagyobb, mint '9', további ellenőrzés szükséges.
    read_hexa_process_digit:
        SUB DL, '0'       ; Az ASCII karaktert számjeggyé alakítjuk ('0'-tól kivonunk).
        JMP read_hexa_calculate ; Ugrás a számolásra.
    read_hexa_check_alpha:
        CMP DL, 'A'       ; Ellenőrzés, hogy 'A' és 'F' közötti betű-e.
        JB read_hexa_skip ; Ha kisebb, mint 'A', érvénytelen karakter.
        CMP DL, 'F'
        JA read_hexa_skip ; Ha nagyobb, mint 'F', érvénytelen karakter.
        SUB DL, 'A'-10    ; Ha betű ('A'-'F'), az értéknek megfelelő számjeggyé alakítjuk ('A' az 10, 'F' a 15).
    read_hexa_calculate:
        MUL BL            ; Szorozzuk meg az eddig beolvasott értéket 16-tal.
        ADD AL, DL        ; Az új számjegyet hozzáadjuk az AL regiszterhez.
        JMP read_hexa_new ; Folytatjuk a következő karakter beolvasásával.
    read_hexa_skip:
        JMP read_hexa_new ; Ha érvénytelen karaktert olvasunk be, folytatjuk a következővel.
    read_hexa_end:
        MOV DL, AL        ; A végeredmény az AL regiszterben van, amit a DL-be helyezünk a további feldolgozáshoz.
        POP BX            ; BX visszaállítása.
        POP AX            ; AX visszaállítása.
        RET               ; Visszatérés az eljárásból.
    read_hexa endp

    ; Kisbetűk nagybetűssé alakítása.
    upcase proc
        CMP DL, 'a'       ; Ellenőrizzük, hogy kisbetű-e ('a'-nál nagyobb-e).
        JB upcase_end     ; Ha kisebb, mint 'a', nincs átalakítás.
        CMP DL, 'z'       ; Ellenőrizzük, hogy kisbetű-e ('z'-nél kisebb-e).
        JA upcase_end     ; Ha nagyobb, mint 'z', nincs átalakítás.
        SUB DL, 'a' - 'A' ; Kisbetű átalakítása nagybetűvé ('a'-tól 'A'-ig terjedő különbség kivonása).
    upcase_end:
        RET               ; Visszatérés az eljárásból.
    upcase endp

END main                 ; A program vége.
