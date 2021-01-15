        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 18 7.ASM
        ; 8255 kullanarak, PortA ile 7 parçalı gösterge, PortB ile tuş tarama
        ; takımı sürerek, basılman tuş karşılığını 7 parçalı göstergede
        ; yakan assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE tuş tarama takımı ve 7 parçalı gösterge
STAK	SEGMENT PARA STACK 'STACK'
	DW 20 DUP(?)
STAK	ENDS

DATA	SEGMENT PARA 'DATA'
DIGITS	DB 4FH, 7DH, 67H, 40H, 5BH, 6DH, 7FH, 3FH, 06H, 66H, 07H, 49H
DATA	ENDS

CODE	SEGMENT PARA 'CODE'
	ASSUME CS:CODE, DS:DATA, SS:STAK
START 	PROC FAR                                ; ana yordam
        ;------------------------------------------------------------------------
        ; Dönüş için gerekli olan değerler yığında saklanıyor
        ;------------------------------------------------------------------------
	PUSH DS
	XOR AX, AX
	PUSH AX
        ;------------------------------------------------------------------------
        ; DATA ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------
	MOV AX, DATA
	MOV DS, AX
	MOV AL, 81H	                        ; PortA, PortB, PortCH output
	OUT 0AFH, AL	                        ; PortCL input yönlü
	MOV AL, 00H
	OUT 0ABH, AL	                        ; tuş tarama takımında hiçbir sütun aktif değil
	OUT 0A9H, AL	                        ; 7 parçalı göstergede tüm parçalar sönük
        
ENDLESS:	
        MOV DX,00H
	MOV CL, 3	                        ; tuş tarama takımında üç sütun için tekrarla
	MOV BL, 08H	                        ; BL’nin 3. Bit’i 1, diğer bit’leri 0
SUTUN:	SHR BL, 1	                        ; ilk geçişte BL’nin 2. Bit’i, ikinci geçişte 
                                                ; 1. bit’i, üçüncü geçişte 0. Bit’i 1, 
                                                ; diğer bit’leri 0
	MOV AL, BL
	OUT 0ABH, AL	                        ; ilk geçişte 1 no’lu sütun, ikinci geçişte 
                                                ; 2 no’lu sütun, üçüncü geçişte 3 no’lu sütun 
                                                ; aktif edilir
	IN AL, 0ADH	                        ; satırları oku
	AND AL, 0FH	                        ; PortCL bit’lerini koru, 
                                                ; PortCH bit’lerini maske ile 0’la
	CMP AL, 00H	                        ; aktif sütundan herhangi bir tuşa 
	JE DEVAM1	                        ; basılmamışsa sonuç 0, bir sonraki sütuna geç
	PUSH AX		                        ; basılmışsa satır değerlerini yığına sakla
        
TUSBASILI:	
        IN AL, 0ADH
	AND AL, 0FH
	CMP AL, 00H
	JNE TUSBASILI	                        ; basılı tuş bırakılana kadar bekle
	POP AX
	MOV DH, AL	                        ; okunan satır değeri DH’ta
	MOV CH, CL
	DEC CH
	MOV AL, 4
	MUL CH		                        ; AX<-aktif olan sütunun ilk tuşu baştan 
				                ; kaçıncı sırada
	MOV DL, 0
DEVAM3:	SHR DH,1		                ; DH’taki 1 değeri kaçıncı bitte
	CMP DH, 00H
	JE DEVAM2	                        ; DH<-0, DL<-basılı tuşun satır numarası
	INC DL
	JMP DEVAM3
DEVAM2:	ADD AX, DX	                        ; AX <- basılan tuş indisi 
	MOV SI, AX
	MOV AL, DIGITS[SI]
                                                ; AL<-basılan tuşa karşılık 7 parçalı gösterge verisi
	OUT 0A9H, AL	                        ; tuş değeri 7 parçalı göstergede yakılır
DEVAM1:	LOOP SUTUN	                        ; bir sonraki sütun
	JMP ENDLESS	                        ; sonsuz döngüde tekrarla
	RETF
START 	ENDP
CODE	ENDS
        END START
