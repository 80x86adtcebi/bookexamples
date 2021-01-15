        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 20 3.ASM
        ; 8254’te iki sayıcı kullanarak 2 MHz saat işaretinden 1sn periyotlu 
        ; pulse üreten assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE 8254 iki sayıcı birlikte kullanım ile pulse üretme
STAK	SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK	ENDS

CODE	SEGMENT PARA 'CODE'
        ASSUME CS:CODE, SS:STAK
START 	PROC FAR		                ; ana yordam
	MOV AL, 00110101B
	OUT 0AFH, AL		                ; CNTR0, 16 bit, kip 2, BCD
	MOV AL, 01110101B
	OUT 0AFH, AL		                ; CNTR1, 16 bit, kip 2, BCD
	XOR AL, AL
	OUT 0A9H, AL
	OUT 0ABH, AL
	MOV AL, 20H		                ; CNTR0 sayma değeri 2000
	OUT 0A9H, AL
	MOV AL, 10H
	OUT 0ABH, AL		                ; CNTR1 sayma değeri 1000
        
ENDLESS:	
        JMP ENDLESS		                ; sonsuz döngü
START	ENDP
CODE	ENDS
        END START
