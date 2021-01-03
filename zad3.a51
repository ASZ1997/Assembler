       LJMP    START
       ORG     100H
        WAIT_KEY EQU 811Ch
START:

       MOV     R0,#80h      ;adres wpisu instrukcji
       MOV     R1,#82h      ;adres odczytu stanu

       MOV     A,#48H          ;ustaw adres generatora
       LCALL   WRITE           ;znak¢w dla znaku 1

       INC     R0              ;adres wpisu danych
       MOV     DPTR,#LITERA1    ;adres definicji litery
       MOV     R3,#8           ;licznik bajt¢w definicji

LOOP:                          ;wpisz definicj© litery
                               ;do generatora znak¢w LCD
       CLR     A
       MOVC    A,@A+DPTR       ;odczyt kolejnego bajtu
       LCALL   WRITE           ;zapis do generatora zn.
       INC     DPTR            ;modyfikacja adresu
       DJNZ    R3,LOOP         ;przepisanie 8 bajt¢w

       MOV     DPTR,#LITERA2    ;adres definicji litery
       MOV     R3,#16           ;licznik bajt¢w definicji

LOOP1:                          ;wpisz definicj© litery
                               ;do generatora znak¢w LCD
       CLR     A
       MOVC    A,@A+DPTR       ;odczyt kolejnego bajtu
       LCALL   WRITE           ;zapis do generatora zn.
       INC     DPTR            ;modyfikacja adresu
       DJNZ    R3,LOOP1        ;przepisanie 8 bajt¢w

       DEC     R0

       MOV     A,#1            ;kasuj dane wy˜wietlacza
       LCALL   WRITE

       MOV     A,#0FH          ;wˆ¥cz wy˜wietlacz,kursor
       LCALL   WRITE           ;i mruganie kursora

       MOV     A,#06H          ;ustaw kierunek przesuwu
       LCALL   WRITE           ;kursora

       INC     R0              ;adres wpisu danych
       MOV     DPTR,#TEXT      ;adres tekstu do
                               ;wy˜wietlenia na LCD

WRITE_TXT:                     ;wpisz tekst na LCD
       CLR     A
       MOVC    A,@A+DPTR       ;pobranie znaku tekstu
       JZ      TEXT_END        ;bajt=0 - koniec tekstu
       LCALL   WRITE           ;wpis na wy˜wietlacz
       INC     DPTR            ;modyfikacja adresu
       SJMP    WRITE_TXT       ;wpisz kolejny znak

TEXT_END:
        DEC R0                   ;adres wpisu instrukcji
        MOV DPTR,#KEY_CODE        ;adres tabeli kodowania
                                 ;klawiszy

LOOP2:   ;p©tla reakcji na klawisze

        LCALL WAIT_KEY ;pobierz klawisz

         MOV R2,A  ;zapami©taj klawisz
         MOVC A,@A+DPTR ;przekoduj klawisze
                           ;na instrukcje
         ACALL WRITE  ;wysˆanie instrukcji
         SJMP LOOP2

WRITE_DAT:                ;wpisz znak na LCD
         MOV A,R2         ;odtw¢rz klawisz
         ADD A,#30H      ;modyfikuj jako znak
         INC R0         ;adres wpisu danych
         ACALL WRITE    ;wpisanie znaku na LCD
         DEC R0                  ;adres wpisu instrukcji
         SJMP LOOP2

;**************************************
;Podprogram wpisu danych lub instrukcji
;na wy˜wietlacz LCD
;Zakˆada prawidˆowe adresy w R0 i R1

WRITE:
       MOV     R2,A            ;przechowanie danych
BUSY:
       MOVX    A,@R1           ;odczytanie stanu
       JB      ACC.7,BUSY      ;oczekiwanie na BUSY=0
       MOV     A,R2            ;odtworzenie danych
       MOVX    @R0,A           ;wysˆanie danych
       RET
;**************************************
;Tabela bajt¢w definiuj¥cych litery 
LITERA1:
 DB 00010100B
 DB 00011000B
 DB 00110000B
 DB 01010000B
 DB 00010000B
 DB 00010010B
 DB 00001100B
 DB 00000000B

LITERA2:
       DB      00000010B
       DB      00000100B
       DB      00001110B
       DB      00010000B
       DB      00001110B
       DB      00000001B
       DB      00011110B
       DB      00000000B

;**************************************
TEXT:
 DB 'Asia  '
 DB 'Sz',1,'wcz',2,'k',0
 
KEY_CODE:
 DB 0,0,0  ;0,1,2
 DB 0,0,0  ;3,4,5
 DB 0,0,0  ;6,7,8
 DB 0,18H,1CH  ;9,<,>
 DB 0,0,0  ;^,v,Esc
 DB 0   ;Enter

