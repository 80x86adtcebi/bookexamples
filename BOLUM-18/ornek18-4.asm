        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 18 4.ASM
        ; 8255 kullanarak PortB ve PortC yardımıyla dört adet ortak anotlu yedi 
        ; parçalı göstergede 1234 sayısını süren assembly program
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE dört adet OA 7 parçalı göstergede 1234 sürme
STAK	SEGMENT PARA STACK 'STACK'
	DW 20 DUP(?)
STAK	ENDS

DATA	SEGMENT PARA 'DATA'
DIGITS	DB 0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H,80H,90H
DISPLAY DW 1234H
DATA	ENDS

CODE	SEGMENT PARA 'CODE'
	ASSUME CS:CODE, DS:DATA, SS:STAK
START 	PROC FAR
        ;------------------------------------------------------------------------
        ; DATA ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------
	MOV AX, DATA
	MOV DS, AX
        ;------------------------------------------------------------------------
        ; 8255 kip 0, PortA, PortB, PortC çıkış
        ;------------------------------------------------------------------------
	MOV AL, 80H
	OUT 66H, AL
	CALL CLEAR_DISP
ENDLESS:		
        MOV AL, 08H	                ; OA3’ü için 
	MOV DI, DISPLAY
	MOV CX, 4	                ; 4 basamak için döngü
        
DIGIT_COUNT: 	
        OUT 64H, AL	                ; sıradaki OA ucu aktif
	MOV SI, DI
	AND SI, 0FH	                ; en düşük anlamlı 4 bit’ini maskele
	PUSH CX
	MOV CX, 4
	SHR DI, CL	                ; sıradaki basamak en düşük anlamlı 4 bit’e
	POP CX
	CALL DISPLAY_DIGIT
	CALL CLEAR_DISP
	SHR AL, 1	                ; sıradaki OA seçimi
	LOOP DIGIT_COUNT
	JMP ENDLESS	                ; sonsuz döngü
START 	ENDP
        ;------------------------------------------------------------------------
        ; PortB’den gösterge değeri sağlayan altyordam
        ;------------------------------------------------------------------------
DISPLAY_DIGIT   PROC NEAR
	PUSH AX
	MOV AL, DIGITS[SI]
	OUT 62H, AL
	CALL DELAY
	POP AX
DISPLAY_DIGIT 	ENDP
        ;------------------------------------------------------------------------
        ; Bekleme sağlayan altyordam
        ;------------------------------------------------------------------------
DELAY 	PROC NEAR
	PUSH CX
	MOV CX, 0FH
        
LOOP_DELAY: 
        LOOP LOOP_DELAY
	POP CX
	RET
DELAY   ENDP
        ;------------------------------------------------------------------------
        ; PortB’ye bağlı göstergeleri temizleyen altyordam
        ;------------------------------------------------------------------------
CLEAR_DISP      PROC NEAR
	PUSH AX
	MOV AL, 0FFH
	OUT 62H, AL
	POP AX
	RET
CLEAR_DISP      ENDP
CODE	ENDS
	END START
