        ; --------------------------------------------------------------------------
        ; Toplam işlemi double word büyüklüğüne taşabileceğinden gerekli kontroller 
        ; yapılmıştır.
        ; --------------------------------------------------------------------------
MY_SS	SEGMENT PARA STACK 'STACK'
	DW 20 DUP(?)
MY_SS	ENDS

MY_DS	SEGMENT PARA 'DATA'
DIZI	DW 7FFFH,7AB2H,70ABH,7111H,71FAH,7232H,7AF8H,78C6H,753DH,70E0H
N	DW 10
TEK_TOP	DD 0
CIFT_TOP DD 0
TEK_SAY	DW 0
CIFT_SAY DW 0
TEK_ORT	DW ?
CIFT_ORT DW ?
MY_DS	ENDS

MY_CS	SEGMENT PARA 'CODE'
	ASSUME DS:MY_DS, SS:MY_SS, CS:MY_CS
ANA     PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, MY_DS
        MOV DS, AX
        MOV CX, N					; DIZI’nin eleman sayısı CX’e konur
        LEA SI, DIZI					; DIZI’nin adresi SI’ya alınır.
DON:	MOV AX, [SI]					; SI adresindeki bir word değeri AX
							; yazmacı içerisine alınır.
	TEST AX, 0001H				        ; Sayının tek mi çift mi olup 
                                                        ; olmadığını kontrol etmek için
                                                        ; sayı, 1 ile mantıksal AND’lenir.
                                                        ; Sonuç bayraklarda oluşur. ZF, 0
                                                        ; ise sayı çift, 1 ise tektir.
	JZ C_LABEL 					; TEST işlemi sonucunda Zero Flag
							; (ZF), 0 ise C_LABEL etiketine 
                                                        ; atlanır.
        ADD WORD PTR [TEK_TOP], AX		        ; 2 word sayının toplamı doubleword
                                                        ; olabileceği için AX ile DD
                                                        ; tanımlı TEK_TOP değişkeninin
                                                        ; düşük anlamlı word’ü toplanır.
	ADC WORD PTR [TEK_TOP+2], 0	                ; Toplam sonucunda elde oluşmuşsa, 										
                                                        ; o da TEK_TOP değişkeninin yüksek
							; anlamlı word ile toplanır.	
	INC TEK_SAY					; TEK_SAY değişkeni 1 arttırılır.
	JMP ARTIR					; ARTIR etiketine atlanır.
C_LABEL:ADD WORD PTR [CIFT_TOP], AX	                ; AX çift ise bu satıra gelinmiştir
							; DD tanımlı CIFT_TOP değişkeninin 
							; düşük anlamlı word’ü ile AX 
                                                        ; değeri toplanır.
	ADC WORD PTR [CIFT_TOP+2], 0	                ; Toplam sonucunda elde oluşmuşsa, 										; o da CIFT_TOP değişkeni-nin yüksek
							; anlamlı word ile toplanır.				
        INC CIFT_SAY					; CIFT_SAY değişkeni 1 arttırılır.
ARTIR:	ADD SI, 2					; DIZI word tanımlı olduğu için SI
							; 2 arttırıldı.
	LOOP DON					; Çevrim işlemleri CX kez 
                                                        ; tekrarlanır.
	MOV DX, WORD PTR [CIFT_TOP+2]	                ; 32-bit bölme işlemi için CIFT_TOP
							; değişkeninin yüksek anlamlı kısmı
							; DX içerisine alınır.
        MOV AX, WORD PTR [CIFT_TOP]	                ; Düşük anlamlı kısım ise AX
                                                        ; içerisine alınır.
        DIV CIFT_SAY					: DX:AX / CIFT_SAY -> Bölüm: AX, 
                                                        ; Kalan: DX işlemi gerçekleştirilir
        MOV CIFT_ORT, AX				; AX’e oluşan çift sayıların
                                                        ; ortalaması CIFT_ORT içerisine
                                                        ; atılır.
        MOV DX, WORD PTR [TEK_TOP+2]	                ; ÇİFT SAYILAR İÇİN YAPILAN
        MOV AX, WORD PTR [TEK_TOP]		        ; İŞLEMLER TEK SAYILAR İÇİN DE
        DIV TEK_SAY					; YAPILARAK TEK_ORT DEĞERİ 
        MOV TEK_ORT, AX				        ; BULUNUR.
RETF
ANA	ENDP
MY_CS	ENDS
        END ANA
