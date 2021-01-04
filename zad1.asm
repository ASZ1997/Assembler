;************************************************
;LEKCJA   3	- PAMI�� WEWN�TRZNA RAM
;PRZYK�AD 7	- ADRESOWANIE PO�REDNIE
;************************************************

B3R5	EQU	30H+5		;rejestr 5 z banku 3
WRITE_HEX EQU 8104h
LCD_CLR EQU 810Ch

	LJMP	START
	ORG	100H
START:

	LCALL	LCD_CLR

	MOV	R0,#30H		;do rejestru R0 z banku 0
				;wpisz liczb� 30H czyli
				;adres rej. R0 w banku 3
	MOV	R2,#8		;do rejestru R2 wpisz
				;liczb� rejestr�w = 8
	MOV 	A, #8		;warto��� pocz�tkowa
LOOP:
	MOV	@R0,A		;adresowanie po�rednie
				;(R0) <- A
	INC	R0		;zwi�ksz adres
	INC	A		;zwi�ksz liczb�
	DJNZ	R2,LOOP		;wykonaj dla 8 rejestr�w

	MOV	A,B3R5		;adresowanie bezpo��rednie
	LCALL	WRITE_HEX

	LJMP	$
