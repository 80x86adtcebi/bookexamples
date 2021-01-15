        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 22 2.ASM
        ; NMI kesmesi kullanarak buton sayma
        ; assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE NMI kesmesi kullanarak buton sayma
STAK	SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK	ENDS
CODE	SEGMENT PARA 'CODE'
	ASSUME CS:CODE, SS:STAK
        ; -----------------------------------------------------------------------
        ; NMI kesmesi için KSP
        ; -----------------------------------------------------------------------
NEWINT	PROC FAR
        ; -----------------------------------------------------------------------
        ; NMI yükselen kenar tetiklemeli
        ; Her butona basıldığında NMI kesmesi oluşur
        ; Her NMI kesmesinde AX = AX+1
        ; -----------------------------------------------------------------------
	INC AX 
	IRET
NEWINT	ENDP

START 	PROC FAR
        XOR AX, AX
        MOV ES, AX
        MOV AL, 2H
        MOV AH, 4
        MUL AH
        MOV BX, AX
        ; -----------------------------------------------------------------------
        ; 02H kesme vektör numarasının NEWINT’e bağlanması
        ; -----------------------------------------------------------------------
        LEA AX, NEWINT
        MOV WORD PTR ES:[BX], AX
        MOV AX, CS
        MOV WORD PTR ES:[BX+2], AX 
        XOR AX, AX	                ; butona kaç kere basıldığı AX’te
        
ENDLESS:	
        JMP ENDLESS	                ; sonsuz döngü
START 	ENDP
CODE	ENDS
        END START
