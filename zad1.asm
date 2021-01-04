;************************************************
;LEKCJA   3	- PAMI ∆ WEWN TRZNA RAM
;PRZYKùAD 7	- ADRESOWANIE POåREDNIE
;************************************************

B3R5	EQU	30H+5		;rejestr 5 z banku 3
WRITE_HEX EQU 8104h
LCD_CLR EQU 810Ch

	LJMP	START
	ORG	100H
START:

	LCALL	LCD_CLR

	MOV	R0,#30H		;do rejestru R0 z banku 0
				;wpisz liczbÍ 30H czyli
				;adres rej. R0 w banku 3
	MOV	R2,#8		;do rejestru R2 wpisz
				;liczbÍ rejestrÛw = 8
	MOV 	A, #8		;wartoòúÊ poczπtkowa
LOOP:
	MOV	@R0,A		;adresowanie poòrednie
				;(R0) <- A
	INC	R0		;zwiÍksz adres
	INC	A		;zwiÍksz liczbÍ
	DJNZ	R2,LOOP		;wykonaj dla 8 rejestrÛw

	MOV	A,B3R5		;adresowanie bezpoòúrednie
	LCALL	WRITE_HEX

	LJMP	$
