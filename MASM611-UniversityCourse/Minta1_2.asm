;Olvasson be két bináris számot, végezze el az AND műveltet, majd az eredményt írja ki a képernyőre.

DOSSEG                  ; A DOS specifikus szegmentálási beállítás.
.MODEL SMALL            ; Kis memória modell, ahol a kód és az adatok egy szegmensben vannak.
.STACK 100h             ; 256 bájtos verem lefoglalása.
.DATA
    num1 DB ?           ; Az első beolvasott bináris szám tárolása.
    num2 DB ?           ; A második beolvasott bináris szám tárolása.
    result DB ?         ; Az AND művelet eredményének tárolása.
    
.CODE
    main proc
        MOV AX, @DATA   ; Az adatszegmens (DS) beállítása.
        MOV DS, AX      ; A DS regiszter mostantól az adatszegmensre mutat.

        ; Első bináris szám beolvasása
        CALL read_binary    ; Hívás a bináris szám beolvasó eljárásra.
        MOV num1, DL        ; Az első számot elmentjük a num1 változóba.

        ; Második bináris szám beolvasása
        CALL read_binary    ; Hívás a második bináris szám beolvasó eljárásra.
        MOV num2, DL        ; A második számot elmentjük a num2 változóba.

        ; AND művelet végrehajtása
        MOV AL, num1        ; Az első számot betöltjük az AL regiszterbe.
        MOV BL, num2        ; A második számot betöltjük a BL regiszterbe.
        AND AL, BL          ; Logikai AND művelet az AL és BL regiszterek tartalma között.
        MOV result, AL      ; Az eredményt elmentjük a result változóba.

        ; Eredmény kiírása bináris formátumban
        MOV DL, result      ; Az eredményt a DL regiszterbe helyezzük.
        CALL write_binary   ; Kiírjuk bináris formátumban.

        ; Új sor kiírása a tisztább megjelenés érdekében
        CALL cr_lf          ; Új sor (CR és LF karakterek) kiírása.

        ; Program befejezése
        MOV AH, 4Ch         ; DOS kilépési funkció.
        INT 21h             ; Visszatérés a DOS promptba.
    main endp

    ; Egy karakter beolvasása a felhasználótól
    read_char proc
        PUSH AX            ; Az AX regiszter értékének megőrzése.
        MOV AH, 1          ; DOS 21h interrupt, 01h funkció: egy karakter beolvasása.
        INT 21h            ; Karakter beolvasása az AL regiszterbe.
        MOV DL, AL         ; Az AL tartalmát a DL regiszterbe helyezzük.
        POP AX             ; Az eredeti AX visszaállítása.
        RET                ; Visszatérés az eljárásból.
    read_char endp

    ; Egy karakter kiírása a képernyőre
    write_char proc
        PUSH AX            ; Az AX regiszter értékének megőrzése.
        MOV AH, 2          ; DOS 21h interrupt, 02h funkció: egy karakter kiírása a DL-ből.
        INT 21h            ; A DL-ben lévő karakter kiírása.
        POP AX             ; Az eredeti AX visszaállítása.
        RET                ; Visszatérés az eljárásból.
    write_char endp

    ; CR és LF karakterek definiálása
    CR EQU 13              ; Kocsivissza (Carriage Return, CR) karakter.
    LF EQU 10              ; Újsor (Line Feed, LF) karakter.

    ; Új sor (CR és LF) kiírása
    cr_lf proc
        PUSH DX            ; A DX regiszter értékének megőrzése.
        MOV DL, CR         ; A kocsivissza (CR) karakter betöltése a DL regiszterbe.
        CALL write_char    ; CR karakter kiírása.
        MOV DL, LF         ; Az újsor (LF) karakter betöltése a DL regiszterbe.
        CALL write_char    ; LF karakter kiírása.
        POP DX             ; Az eredeti DX visszaállítása.
        RET                ; Visszatérés az eljárásból.
    cr_lf endp

    ; Bináris szám beolvasása a felhasználótól
    read_binary proc
        PUSH AX            ; Az AX regiszter értékének megőrzése.
        PUSH BX            ; A BX regiszter értékének megőrzése.
        XOR AX, AX         ; Az AX regisztert nullázzuk a beolvasott szám tárolására.
        MOV BL, 2          ; A 2-es számrendszer használata.
    read_binary_loop:
        CALL read_char     ; Egy karakter beolvasása.
        CMP DL, CR         ; Ellenőrizni, hogy a beolvasott karakter-e a kocsivissza (CR).
        JE read_binary_end ; Ha CR, akkor kilépünk a beolvasási ciklusból.
        SUB DL, "0"        ; A karakter ASCII értékéből kivonjuk a '0' értéket, hogy bináris számot kapjunk.
        SHL AX, 1          ; Az AX regiszter tartalmának eltolása balra (szorzás kettővel).
        OR AL, DL          ; Az AL regiszterbe hozzáadjuk a beolvasott bitet.
        JMP read_binary_loop ; Visszatérés a ciklus elejére a következő bithez.
    read_binary_end:
        MOV DL, AL         ; A beolvasott bináris szám a DL regiszterbe kerül.
        POP BX             ; A BX regiszter visszaállítása.
        POP AX             ; Az AX regiszter visszaállítása.
        RET                ; Visszatérés az eljárásból.
    read_binary endp

    ; Bináris szám kiírása a képernyőre
    write_binary proc
        PUSH AX            ; Az AX regiszter értékének megőrzése.
        PUSH BX            ; A BX regiszter értékének megőrzése.
        PUSH CX            ; A CX regiszter értékének megőrzése.
        PUSH DX            ; A DX regiszter értékének megőrzése.
        MOV CX, 8          ; 8 bitet kell kiírni (egy bájt).
        MOV BL, DL         ; A DL-ben lévő bináris számot betöltjük a BL regiszterbe.
    binary_digit_loop:
        MOV DX, 0          ; A DX regisztert nullázzuk.
        SHL BL, 1          ; A BL tartalmát balra tolva az első bitet vizsgáljuk.
        JC add_one         ; Ha a carry flag beáll, akkor egyet kell hozzáadni.
        JMP next_digit     ; Ha nincs carry, lépünk a következő bitre.
    add_one:
        INC DX             ; Növeljük a DX-et, hogy az 1-est jelöljük.
    next_digit:
        ADD DL, "0"        ; A DX értékét ASCII karakterré alakítjuk.
        CALL write_char    ; A bit kiírása a képernyőre.
        LOOP binary_digit_loop ; Visszatérés a ciklus elejére a következő bithez.
        POP DX             ; A DX regiszter visszaállítása.
        POP CX             ; A CX regiszter visszaállítása.
        POP BX             ; A BX regiszter visszaállítása.
        POP AX             ; Az AX regiszter visszaállítása.
        RET                ; Visszatérés az eljárásból.
    write_binary endp

END main                 ; A program vége.
