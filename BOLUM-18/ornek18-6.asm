        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 18 6.ASM
        ; 8255 kullanarak basılan butona göre LED söndüren 
        ; assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE buton ve LED uygulaması
STAK	SEGMENT PARA STACK 'STACK'
	DW 20 DUP(?)
STAK	ENDS

CODE	SEGMENT PARA 'CODE'
	ASSUME CS:CODE, SS:STAK
START 	PROC FAR	                ; ana yordam
	MOV AL, 81H	                ; PCL giriş, PCH çıkış
	OUT 66H, AL	                ; olarak ayarlanır
	MOV AL, 0FFH	                ; LED’ler varsayılan 
	OUT 64H, AL	                ; olarak yanıyor
ENDLESS:	
        IN AL, 64H	                ; PC okunur
	OR AL, 0F0H	                ; PCH maskelenerek 1 yapılır
	CMP AL, 0FFH	                ; butonlar basılı değilken lojik 1 verir
	JZ ENDLESS	                ; hiçbir butona basılmamış
	MOV CL, 4	                ; basılan buton karşılığı
	SHL AL, CL	                ; 4 birim sola öteleme ile PCH’ye taşınır
	OUT 64H, AL	                ; LED’lerde basılı buton karşılığı söndürülür
	JMP ENDLESS	                ; sonsuz döngü
START 	ENDP
CODE	ENDS
        END START
