        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 19 2.ASM
        ; 8251 kullanarak sürekli ‘A’ gönderen 
        ; assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE 8251 seri veri gönderme
STAK	SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK	ENDS

CODE	SEGMENT PARA 'CODE'
        ASSUME CS:CODE, SS:STAK
START 	PROC FAR		                ; ana yordam
	MOV DX, 020Ah
	MOV AL, 01001101B
	OUT DX, AL		                ; kip yazmacına erişim
	MOV AL, 40H
	OUT DX, AL		                ; kontrol yazmacı ile 8251 reset’leme
	MOV AL, 01001101B	                ; mod:1 stop bit’i, parity kullanmadan,
                                                ; 8 bit veri, 1 çarpan
	OUT DX, AL
	MOV AL, 00010001B	                ; kontrol: veri gönderme aktif, 
                                                ; hata bit’lerini temizle
	OUT DX, AL
        
ENDLESS:	
        MOV DX, 020AH		                ; durum yazmacı adresi
TEKRAR:	IN AL, DX		                ; durum yazmacını oku
	AND AL, 01H		                ; TxRDY’yi kontrol et
	JZ TEKRAR		                ; TxRDY 1 olmadığı sürece tekrarla
	MOV DX, 0208H		                ; veri yazmacı adresi
	MOV AL, 41H
	OUT DX, AL		                ; 8251 ile ‘A’ karakteri gönderimi
	JMP ENDLESS		                ; sonsuz döngü
START 	ENDP
CODE	ENDS
        END START
