;Írja ki a képernyőre (egymás alá) a nagybetű karaktereket.

DOSSEG                  ; A DOS specifikus szegmentálási beállítás.
.MODEL SMALL            ; Kis memória modell: a kód és az adatok egy szegmensben helyezkednek el.
.STACK                  ; A stack (verem) definiálása.

.CODE
    ; Fő eljárás
    main proc
        MOV CX, 26        ; Az angol ábécé 26 betűből áll, ezt a CX regiszterbe helyezzük.
        MOV DL, 'A'       ; A DL regiszterbe az 'A' karakter ASCII kódját töltjük, innen kezdjük a kiírást.

    print_letters:
        MOV AH, 2         ; A DOS 21h interrupt 02h funkcióját használjuk a karakterek kiírásához.
        INT 21h           ; A DL regiszterben lévő karaktert (az aktuális betűt) kiírjuk a képernyőre.
        CALL cr_lf        ; Az egyes karakterek után új sort írunk (CR és LF karakterekkel).
        INC DL            ; A következő betűre lépünk: növeljük a DL értékét, hogy a következő ASCII kódot kapjuk.
        LOOP print_letters; A CX regiszter számlálója alapján ismételjük a ciklust 26-szor (amíg CX 0 nem lesz).

        ; Program befejezése és visszatérés a DOS promptba
        MOV AH, 4Ch       ; A DOS 21h interrupt 4Ch funkciója: program befejezése.
        INT 21h           ; A program kilépése.
    main endp

    ; Egy karakter beolvasása a felhasználótól (nem használt a fő programban, de megvan)
    read_char proc
        PUSH AX           ; AX regiszter mentése, mivel az interrupt módosítja.
        MOV AH, 1         ; DOS 21h interrupt 01h funkció: egy karakter beolvasása.
        INT 21h           ; A beolvasott karakter az AL regiszterbe kerül.
        MOV DL, AL        ; Az AL regisztert DL-be helyezzük, a későbbi felhasználásra.
        POP AX            ; AX visszaállítása.
        RET               ; Visszatérés az eljárásból.
    read_char endp

    ; Egy karakter kiírása a képernyőre
    write_char proc
        PUSH AX           ; AX regiszter mentése.
        MOV AH, 2         ; DOS 21h interrupt 02h funkció: egy karakter kiírása a DL regiszterből.
        INT 21h           ; A DL-ben lévő karakter kiírása.
        POP AX            ; AX visszaállítása.
        RET               ; Visszatérés az eljárásból.
    write_char endp

    ; CR és LF karakterek definiálása
    CR EQU 13             ; Kocsivissza (Carriage Return, CR) karakter (ASCII kód: 13).
    LF EQU 10             ; Újsor (Line Feed, LF) karakter (ASCII kód: 10).

    ; Új sor (CR és LF) kiírása
    cr_lf proc
        PUSH DX           ; DX regiszter mentése, mivel a DL-t fogjuk módosítani.
        MOV DL, CR        ; A CR karakter betöltése a DL-be.
        CALL write_char   ; A CR karakter kiírása a képernyőre.
        MOV DL, LF        ; Az LF karakter betöltése a DL-be.
        CALL write_char   ; Az LF karakter kiírása a képernyőre, így új sorba kerülünk.
        POP DX            ; DX visszaállítása az eredeti értékre.
        RET               ; Visszatérés az eljárásból.
    cr_lf endp

END main                 ; A program végét jelzi.
