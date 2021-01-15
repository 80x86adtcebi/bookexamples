        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 20 4.ASM
        ; 8254 kullanarak 440 Hz nota üreten
        ; assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE 8254 440 Hz nota üretme
STAK	SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK	ENDS
CODE	SEGMENT PARA 'CODE'
        ASSUME CS:CODE, SS:STAK
START 	PROC FAR		; ana yordam
	MOV AL, 00110110B
	OUT 0AFH, AL		; CNTR0 16 bit, kip 3, binary
	MOV AX, 550
	OUT 0A9H, AL
	MOV AL, AH
	OUT 0A9H, AL		; CNTR0 sayma değeri 550
        
ENDLESS:	
        JMP ENDLESS		; sonsuz döngü
START 	ENDP
CODE	ENDS
        END START
