        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 20 5.ASM
        ; 8254 CNTR0, CNTR1 ve CNTR2 kullanarak 1kHz frekansında %75 görev
        ; oranında PWM işareti üreten assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE 8254 PWM işareti 1kHZ %75 görev oranı
STAK	SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK	ENDS

CODE	SEGMENT PARA 'CODE'
        ASSUME CS:CODE, SS:STAK
START 	PROC FAR		                ; ana yordam
	MOV AL, 01010100B
	OUT 0AFH, AL		                ; CNTR1, 8bit, kip 2, binary
	MOV AL, 240
	OUT 0ABH, AL		                ; CNTR1 sayma değeri 240, 1kHz frekans
	MOV AL, 00010000B
	OUT 0AFH, AL		                ; CNTR0, 8 bit, kip 0, binary
        ;------------------------------------------------------------------------
        ; CNTR0 sayma değeri 180
        ; CNTR1 ve CNTR2 arasında 750us faz farkı
        ;------------------------------------------------------------------------
	MOV AL, 180
	OUT 0A9H, AL
	MOV AL, 11100010B
	OUT 0AFH, AL		                ; CNTR0 readback status
KNTROL:	IN AL, 0A9H		                ; CNTR0 durum yazmacını oku
	TEST AL, 80H
	JZ KNTROL		                ; OUT0 1 olunca CNTR2’yi başlat
	MOV AL, 10010100B
	OUT 0AFH, AL		                ; CNTR2, 8bit, kip 2, binary
	MOV AL, 240
	OUT 0ADH, AL		                ; CNTR2 sayma değeri 240, 1kHz frekans
        
ENDLESS:	
        JMP ENDLESS		                ; sonsuz döngü
START	ENDP
CODE	ENDS
        END START
