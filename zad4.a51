	LCD_CLR      EQU   810Ch
	WRITE_HEX    EQU   8104h
	WAIT_KEY     EQU   811Ch
	LCDWC        EQU   80h
	LCDRC        EQU   82h

	LJMP	START
	ORG	100H

START:
	LCALL LCD_CLR
	
	LCALL WAIT_KEY
	INC A
	MOV R2, A
	CLR A
	MOV DPTR, #START2
	
	LOOP_INC_DPTR:
		INC DPTR
		DJNZ R2, LOOP_INC_DPTR
	
	MOV	R2, #16

LOOP_WYPISZSIE:
	MOVX A, @DPTR
	LCALL WRITE_HEX

	;MOV A, ' '
	;LCALL WRITE

	INC	DPTR
	DJNZ R2, LOOP_WYPISZSIE		

	SJMP $

START2:
	MOV	R0, #LCDWC
	MOV	R1, #LCDRC

	MOV	A,#48H
	LCALL WRITE		

	INC	R0
	MOV	DPTR, #LITERA
	MOV	R3, #8		

LOOP:				
	CLR	A
	MOVC A,@A+DPTR	
	LCALL WRITE		
	INC	DPTR		
	DJNZ R3,LOOP		

	DEC	R0		

	MOV	A,#1
	LCALL WRITE

	MOV	A,#0FH
	LCALL WRITE

	MOV	A,#06H
	LCALL WRITE

	INC	R0
	MOV	DPTR, #TEXT

WRITE_TXT:			
	CLR	A
	MOVC	A,@A+DPTR	
	JZ	TEXT_END	
	LCALL	WRITE		
	INC	DPTR		
	SJMP	WRITE_TXT	

TEXT_END:
	SJMP	$		

WRITE:
	MOV	R2,A
	
BUSY:
	MOVX	A,@R1		
	JB	ACC.7,BUSY	
	MOV	A,R2		
	MOVX	@R0,A		
	RET

LITERA:
       DB      00000000B
       DB      00111000B
       DB      01000100B
       DB      01001000B
       DB      01010000B
       DB      00111100B
       DB      00000100B
       DB      00000000B
TEXT:
       DB      'Bedzin  '
       DB      'B',1,'dzin',0

	LJMP	START
	ORG	100H