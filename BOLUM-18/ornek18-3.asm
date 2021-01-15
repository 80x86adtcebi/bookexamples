        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 18 3.ASM
        ; 8255 kullanılarak, PortB yardımıyla ortak anotlu yedi parçalı gösterge-de
        ; sırasıyla 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 şeklinde ondalık başmakları 
        ; oluşturan assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE 8255 PortB ortak anotlu yedi parçalı göstergede uygulama-sı
STAK	SEGMENT PARA STACK 'STACK'
	DW 20 DUP(?)
STAK	ENDS

DATA	SEGMENT PARA 'DATA'
DIGITS	DB 0C0H,0F9H,0A4H,0B0H,99H,92H,82H,0F8H,80H,90H,88H
DATA	ENDS

CODE	SEGMENT PARA 'CODE'
	ASSUME CS:CODE, DS:DATA, SS:STAK
START 	PROC FAR
        ;------------------------------------------------------------------------
        ; DATASG ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------
	MOV AX, DATA
	MOV DS, AX
        ;------------------------------------------------------------------------
        ; 8255 kip 0, tüm portlar çıkış yönlü ayarlanır
        ;------------------------------------------------------------------------
	MOV AL, 80H
	OUT 66H, AL
	CALL CLEAR_DISP
ENDLESS:
	XOR BX, BX	                ; DIGITS dizisinin ilk elemanından itibaren
	MOV CX, 10	                ; tüm basamaklar için
TEKRAR:	
	MOV AL, DIGITS[BX]
	OUT 62H, AL	                ; PortB’ye basamak gösterge değeri gönderilir
	INC BX		                ; sonraki basamağa geçilir
	CALL DELAY	                ; yakılan değerin görülmesi için bekle 
	CALL CLEAR_DISP
	LOOP TEKRAR
	JMP ENDLESS	                ; sonsuz döngü 
START 	ENDP
        ;------------------------------------------------------------------------
        ; PortB’ye bağlı göstergeyi temizleyen altyordam
        ;------------------------------------------------------------------------
CLEAR_DISP PROC NEAR
	PUSH AX
	MOV AL, 0FFH
	OUT 62H, AL
	POP AX
	RET
CLEAR_DISP ENDP
        ;------------------------------------------------------------------------
        ; Bekleme sağlayan altyordam
        ;------------------------------------------------------------------------
DELAY 	PROC NEAR
	PUSH CX
	MOV CX, 0FFFFH
        
LOOP_DELAY:LOOP LOOP_DELAY
	POP CX
	RET
DELAY 	ENDP
CODE	ENDS
	END START
