        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 21 2.ASM
        ; DAC0830 kullanarak 1Hz frekansında testere dişi analog dalga
        ; üreten assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE DAC0830 testere dişi
STAK	SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK	ENDS

CODE	SEGMENT PARA 'CODE'
        ASSUME CS:CODE, SS:STAK
START 	PROC FAR	; ana yordam
	MOV DX, 1000H
	MOV AL, 00H
        
ENDLESS:	
        OUT DX, AL	                        ; AL değerine karşılık DAC
	CALL DELAY
	INC AL	                                ; AL 250’den sonra tekrar 0’a döner
	CMP AL, 250
	JB ENDLESS
	XOR AL, AL
	JMP ENDLESS	                        ; sonsuz döngü
START 	ENDP
        ; -----------------------------------------------------------------------
        ; 4 ms bekleme sağlayan altyordam
        ; -----------------------------------------------------------------------
DELAY 	PROC NEAR
	PUSH CX
	MOV CX, 0100H
L1:	LOOP L1
	POP CX
	RET
DELAY 	ENDP
CODE	ENDS
        END START
