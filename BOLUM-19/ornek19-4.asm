        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 19 4.ASM
        ; 8251 kullanarak gelen seri ASCII karakterin bir fazlasını
        ; gönderen assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE 8251 seri veri alma ve gönderme
STAK	SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK	ENDS

CODE	SEGMENT PARA 'CODE'
        ASSUME CS:CODE, SS:STAK
START 	PROC FAR		                ; ana yordam
	MOV DX, 020Ah
	MOV AL, 01001101B
	OUT DX, AL		                ; kip yazmaç erişimi
	MOV AL, 40H
	OUT DX, AL		                ; kontrol yazmacı ile 8251 reset’leme
	MOV AL, 01001101B
	OUT DX, AL		                ; kip: 1 stop, parity yok, 
                                                ; 8 veri bit’i, 1 çarpan
	MOV AL, 00010101B
	OUT DX, AL		                ; kontrol: veri alma ve gönderme aktif,
				                ; hata bit’lerini temizle
                                                
ENDLESS:	
        MOV DX, 020AH		                ; durum yazmaç adresi
TEKRAR:	IN AL, DX		                ; durum yazmacını oku
	AND AL, 02H		                ; RxRDY bit’ini kontrol et
	JZ TEKRAR		                ; RxRDY 1 olmadığı sürece tekrarla
	MOV DX, 0208H		                ; veri yazmacı
	IN AL, DX		                ; alınan veriyi oku
	INC AL		                        ; AL<-alınan verinin ASCII değer 
                                                ; olarak bir fazlası
	MOV BL, AL
	MOV DX, 020AH		                ; durum yazmaç adresi
        
TEKRAR2:	
        IN AL, DX		                ; durum yazmacını oku
	AND AL, 01H		                ; TxRDY bit’ini kontrol et
	JZ TEKRAR2		                ; TxRDY 1 olmadığı sürece tekrarla
	MOV DX, 0208H		                ; veri yazmacı
	MOV AL, BL
	OUT DX, AL		                ; seri olarak alınan karakterin 
                                                ; bir fazlasını gönder
	JMP ENDLESS		                ; sonsuz döngü
START	ENDP
CODE	ENDS
        END START
