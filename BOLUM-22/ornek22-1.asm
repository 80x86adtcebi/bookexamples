        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 22 1.ASM
        ; DIV0 kesmesi karşılayıp sonuçta 0FFFFH dönen, 
        ; kesme servis programını vektör tablosuna yerleştiren 
        ; örnek assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE DIV0 interrupt handler
STACKSG SEGMENT PARA STACK 'STACK'
        DW 12 DUP(?)
STACKSG ENDS

DATASG	SEGMENT PARA 'DATA'
DIZI1	DW 1,2,3,4,5,6,7
DIZI2	DW 1,0,3,4,5,6,7
ELEMAN	DW 7
OLDOF	DW 0
OLDSG	DW 0
DATASG 	ENDS

CODESG	SEGMENT PARA 'CODE'
        ASSUME CS:CODESG, DS:DATASG, SS:STACKSG
        ; -----------------------------------------------------------------------
        ; DIV0 kesme servis programı
        ; -----------------------------------------------------------------------
NEWINT	PROC FAR
	PUSH BP
	MOV BP, SP
	MOV AX, [BP+2]	; AX <- ana yordam dönüş IP
	ADD AX, 2
        ; -----------------------------------------------------------------------
        ; DIV0 kesmesini DIV komutu oluşturdu
        ; DIV komutu 2 byte yer kaplar
        ; DIV0 kesmesi dönüşünde DIV komutunu geçmek için 
        ; IP bir sonraki komutu işaret eder
        ; -----------------------------------------------------------------------
        MOV [BP+2], AX
        MOV AX, 0FFFFH	; DIV0’dan AX <- 0FFFFH dönülür
        POP BP
        IRET
NEWINT	ENDP
BASLA	PROC FAR
        ;------------------------------------------------------------------------
        ; Dönüş için gerekli olan değerler yığında saklanıyor
        ;------------------------------------------------------------------------
        PUSH DS
        XOR AX, AX
        PUSH AX
        ;------------------------------------------------------------------------
        ; DATASG ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------
        MOV AX, DATASG
        MOV DS, AX
        XOR AX, AX
        MOV ES, AX
        ;------------------------------------------------------------------------
        ; Vektör tablosundaki mevcut DIV0 CS ve IP değerleri saklanır
        ;------------------------------------------------------------------------
        MOV AX, WORD PTR ES:[0]
        MOV OLDOF, AX
        MOV AX, WORD PTR ES:[2]
        MOV OLDSG, AX
        ;------------------------------------------------------------------------
        ; 00H kesme vektör numarasının NEWINT’e bağlanması
        ;------------------------------------------------------------------------
        LEA AX, NEWINT	; DIV0 için yeni KSP ofseti
        MOV WORD PTR ES:[0], AX
        MOV AX, CS	; DIV0 için yeni KSP segmenti
        MOV WORD PTR ES:[2], AX
        ;------------------------------------------------------------------------
        ; dizi1 ve dizi2’nin karşılıklı elemanları bölünür
        ; SI=1 iken 2/0 durumda AX=0FFFFH değerini alır
        ;------------------------------------------------------------------------
        XOR SI, SI
        MOV CX, ELEMAN
TEKRAR:	XOR DX, DX
        MOV AX, DIZI1[SI]
        MOV BX, DIZI2[SI]
        DIV BX
        ADD SI, 2
        LOOP TEKRAR
        ;------------------------------------------------------------------------
        ; Program sonlandırılmadan önce orijinal DIV0 KSP adresleri geri yazılır
        ;------------------------------------------------------------------------
        XOR AX, AX
        MOV ES, AX
        MOV AX, OLDOF
        MOV WORD PTR ES:[0], AX
        MOV AX, OLDSG
        MOV WORD PTR ES:[2], AX
        RETF
BASLA	ENDP
CODESG	ENDS
        END BASLA
