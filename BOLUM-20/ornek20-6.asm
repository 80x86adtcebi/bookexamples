        ; -----------------------------------------------------------------------
        ; PROGRAM :Örnek 20 6.ASM
        ; 8254 sayıcı uygulaması ile tekrarlı olarak
        ; 100 sayınca uyarı veren assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE 8254 kip 2 sayıcı
STAK	SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK	ENDS

CODE	SEGMENT PARA 'CODE'
        ASSUME CS:CODE, SS:STAK
START 	PROC FAR		                ; ana yordam
	MOV AL, 00010100B
	OUT 0AFH, AL		                ; CNTR0, 8bit, kip 2, binary
	MOV AL, 99
	OUT 0A9H, AL		                ; CNTR0 sayma değeri 99
        
ENDLESS:	
        JMP ENDLESS		                ; sonsuz döngü
START	ENDP
CODE	ENDS
        END START      
