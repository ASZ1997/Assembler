LCD_CLR      EQU   810Ch
WAIT_KEY     EQU   811Ch
WRITE_HEX    EQU   8104h
WRITE_DATA   EQU   8102h

       LJMP    START
       ORG     100H

START:
       LCALL   LCD_CLR
       MOV     R0,#0           
       MOV     R1,#0          
       MOV     R2,#0           
       MOV     R3,#0           
    TAKEKEY0:
       LCALL   WAIT_KEY
       MOV     R0,A
       SUBB    A,#9
       JZ      TAKEKEY0        
       DEC     A
       JZ      TAKEKEY0       
       DEC     A
       JZ      TAKEKEY0        
       DEC     A
       JZ      TAKEKEY0        
       DEC     A
       JZ      JMP_ZNAK_NAWIAS 
       DEC     A
       JZ      TAKEKEY0       
       MOV     A,R0
       ACALL   WRITE_BCD

    TAKEKEY1:
       LCALL   WAIT_KEY
       MOV     R1,A
       JZ      TAKEKEY1       
       DEC     A
       JZ      TAKEKEY1       
       DEC     A
       JZ      TAKEKEY1       
       DEC     A
       JZ      TAKEKEY1       
       DEC     A
       JZ      TAKEKEY1       
       DEC     A
       JZ      TAKEKEY1       
       DEC     A
       JZ      TAKEKEY1        
       DEC     A
       JZ      TAKEKEY1        
       DEC     A
       JZ      TAKEKEY1        
       DEC     A
       JZ      TAKEKEY1        
       DEC     A
       JZ      ZNAK_PLUS       
       DEC     A
       JZ      ZNAK_MINUS      
       DEC     A
       JZ      ZNAK_MNOZENIA  
       DEC     A
       JZ      ZNAK_DZIELENIA  
       DEC     A
       JZ      ZNAK_NAWIAS     
       DEC     A
       JMP     ZNAK_ROWNY      

    JMP_ZNAK_NAWIAS:
       JMP     ZNAK_NAWIAS

    TAKEKEY2:
       LCALL   WAIT_KEY
       MOV     R2,A
       SUBB    A,#9
       JZ      TAKEKEY2       
       DEC     A
       JZ      TAKEKEY2       
       DEC     A
       JZ      TAKEKEY2        
       DEC     A
       JZ      TAKEKEY2        
       DEC     A
       JZ      ZNAK_NAWIAS     
       DEC     A
       JZ      TAKEKEY2        
       MOV     A,R2
       ACALL   WRITE_BCD
       
       MOV     A,R1
       SUBB    A,#9
       JZ      DODAW
       DEC     A
       JZ      ODEJM
       DEC     A
       JZ      MNOZ
       DEC     A
       JZ      DZIEL
       DEC     A
       JZ      NAWIAS
       JMP     WYNIK

      DODAW:
       MOV     A,R0
       MOV     B,R2
       ADD     A,B
       MOV     R0,A
       JMP     TAKEKEY1
      ODEJM:
       MOV     A,R0
       MOV     B,R2
       SUBB    A,B
       MOV     R0,A
       JMP     TAKEKEY1
      MNOZ:
       MOV     A,R0
       MOV     B,R2
       MUL     AB
       MOV     R0,A
       JMP     TAKEKEY1
      DZIEL:
       MOV     A,R0
       MOV     B,R2
       DIV     AB
       MOV     R0,A
       JMP     TAKEKEY1
      NAWIAS:
       JMP     TAKEKEY1
      WYNIK:
       MOV     A,R0
       ACALL   WRITE_BCD
       SJMP    $

ZNAK_PLUS:
       MOV     A,#'+'
       LCALL   WRITE_DATA
       JMP     TAKEKEY2
ZNAK_MINUS:
       MOV     A,#'-'
       LCALL   WRITE_DATA
       JMP     TAKEKEY2
ZNAK_MNOZENIA:
       MOV     A,#'*'
       LCALL   WRITE_DATA
       JMP     TAKEKEY2
ZNAK_DZIELENIA:
       MOV     A,#'/'
       LCALL   WRITE_DATA
       JMP     TAKEKEY2
ZNAK_NAWIAS:
       MOV     A,R3
       JZ      ZNAK_NAWIAS_OTWORZ
       DEC     A
       JMP     ZNAK_NAWIAS_ZAMKNIJ
      ZNAK_NAWIAS_OTWORZ:
       MOV     A,#'('
       LCALL   WRITE_DATA
       MOV     R3,#1
       JMP     TAKEKEY2
      ZNAK_NAWIAS_ZAMKNIJ:
       MOV     A,#')'
       LCALL   WRITE_DATA
       MOV     R3,#0
       JMP     TAKEKEY2
ZNAK_ROWNY:
       MOV     A,#'='
       LCALL   WRITE_DATA
       JMP     WYNIK

WRITE_BCD:
       MOV     B,#100          
       DIV     AB
       JZ      ONLY_LOW         
       LCALL   WRITE_HEX       

ONLY_LOW:
       MOV     A,B             
       MOV     B,#10
       DIV     AB
       SWAP    A
       ORL     A,B            
       LCALL   WRITE_HEX       

RET
