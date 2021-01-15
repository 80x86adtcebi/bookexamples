        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 19 3.ASM
        ; 8251 kullanarak alınan ASCII karakterleri veri kesiminde 
        ; tanımlanmış olan RECEIVED isimli beş elemanlı dizide round robin
        ; mantığında saklayan assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE 8251 seri veri alma
STAK	SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK	ENDS

DATA	SEGMENT PARA 'DATA'
RECEIVED        DB 5 DUP (0)
DATA	ENDS

CODE	SEGMENT PARA 'CODE'
        ASSUME CS:CODE, DS:DATA, SS:STAK
START 	PROC FAR		; ana yordam
        ;------------------------------------------------------------------------
        ; DATA ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------
	MOV AX, DATA
	MOV DS, AX
	XOR SI, SI
	MOV DX, 020Ah
	MOV AL, 01001101B
	OUT DX, AL		                ; kip yazmaç erişimi
	MOV AL, 40H
	OUT DX, AL		                ; kontrol yazmacı ile 8251 reset’leme
	MOV AL, 11111101B	                ; 2 stop, çift eşlik, 8 bit
	OUT DX, AL
	MOV AL, 00010100B	                ; veri alma aktif, hata bit’lerini temizle
	OUT DX, AL
        
ENDLESS:
        MOV DX, 020AH		                ; durum yazmacı adresi
TEKRAR:	IN AL, DX			        ; durum yazmacını oku
	AND AL, 02H		                ; RxRDY bit’ini kontrol et
	JZ TEKRAR		                ; RxRDY 1 olmadığı sürece tekrarla
	MOV DX, 0208H		                ; veri yazmacı adresi
	IN AL, DX
	MOV RECEIVED[SI], AL
	INC SI
	CMP SI, 5
	JNE DEVAM
	XOR SI, SI
DEVAM:	JMP ENDLESS		                ; sonsuz döngü
START 	ENDP
CODE	ENDS
        END START
