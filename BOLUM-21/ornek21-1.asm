        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 21 1.ASM
        ; ADC0804 kullanarak ADC dönüşümü başlatan, INTR ucu ile arayüz 
        ; oluşturup dönüşüm bitmesini kontrol eden, dönüşüm bitince ADC’yi 
        ; okuyan assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE ADC0804 polling ile ADC okuma
STAK	SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK	ENDS
CODE	SEGMENT PARA 'CODE'
        ASSUME CS:CODE, SS:STAK
START 	PROC FAR	                ; ana yordam

ENDLESS:	
        MOV DX,0200H
	MOV AL,00H
	OUT DX, AL	                ; ADC0804’e boş yazma, dönüşüm başlatır
	MOV DX, 0400H
        
INTR_KONTROL:
	IN AL, DX	                ; INTR’yi oku
	TEST AL, 80H
	JNZ INTR_KONTROL	        ; INTR 0 ise dönüşüm bitmiştir
	MOV DX, 0200H
	IN AL, DX	                ; ADC0804 dönüşüm sonucunu oku
	CALL DELAY	                ; bir sonraki ADC dönüşümü öncesi delay
	JMP ENDLESS	                ; sonsuz döngü
START 	ENDP
        ; -----------------------------------------------------------------------
        ; Bekleme sağlayan altyordam
        ; -----------------------------------------------------------------------
DELAY 	PROC NEAR
	PUSH CX
	MOV CX, 0FH
L1:	LOOP L1
	POP CX
	RET
DELAY 	ENDP
CODE	ENDS
        END START
