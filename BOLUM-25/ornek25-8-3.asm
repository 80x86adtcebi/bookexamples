        ; --------------------------------------------------------------------------
        ; İlk dizide doğum tarihi, ikinci dizide ise yaş bilgisi tutulduğundan; ilki
        ; word tanımlı olmalıyken, ikincisi byte tanımlı olabilmektedir.
        ; --------------------------------------------------------------------------
ALLSG 	SEGMENT PARA 'CODE'
	ORG 100H
	ASSUME CS:ALLSG, DS:ALLSG, SS:ALLSG
ATLA:	JMP ARRAYS
A1	DW 5
D1	DW 1989, 2002, 1996, 2003, 1971
B1	DW 7
D2	DB 21, 63, 42, 29, 54, 35, 32
D3 	DW 12 DUP(?)
ARRAYS	PROC NEAR
        LEA DI, D1			        ; D1 dizisinin adresi DI yazmacına alınır.
        LEA SI, D2			        ; D2 dizisinin adresi SI yazmacına alınır.
        XOR BX, BX			        ; XOR işlemi BX yazmacını sıfırlamak için
                                                ; kullanılır. BX, D3 dizisinin indisi olarak
                                                ; kullanılacaktır. 
        MOV CX, A1			        ; D1 dizisi üzerinde A1 kere işlem yapılacağı
                                                ; için L1 Çevriminin çevrim değişkeni A1
                                                ; olarak ayarlanır.
L1:	MOV AX, [DI]			        ; DI adresinde bulunan bir word boyutundaki
                                                ; değer AX yazmacına alınır.
        MOV D3[BX], AX		                ; D3 dizisinin BX adresine (indisine), AX
                                                ; yazmacının değeri atanır.
        ADD DI, 2			        ; D1 word tanımlı olduğu için, D1 dizisinin
                                                ; adresini gösteren DI yazmacı ikişer olarak
                                                ; arttırılır.
        ADD BX, 2			        ; Aynı şekilde D3 dizisinin indisini tutan
                                                ; BX yazmacı da, dizi word tanımlı olduğu
                                                ; için 2 arttırılır.
        LOOP L1				        ; A1 kez L1 döngüsünün işlemi 
                                                ; gerçekleştirilir.
                                                ; D1 dizisinin A1 elemanı, D3 dizisinin ilk
                                                ; A1 elemanına yerleştirilmiştir. 
        MOV CX, B1			        ; D2 dizisinin eleman sayısı olan B1 değeri 
                                                ; CX içerisine yerleştirilir. 
L2:	MOV AL, [SI]			        ; D2 dizisinin SI adresinden 1 byte alınıp
                                                ; AL yazmacının içerisine konulur.
	CBW					; D2 dizisi byte, d3 dizisi ise word 
                                                ; tanımlıdır. D2 dizisinin AL’ye alınan
                                                ; elemanları CBW kodu ile AX’e genişletilir.
	MOV D3[BX], AX		                ; Böylece D2 dizisinin elemanları d3 
                                                ; dizisine BX indisinin en son kaldığı yerden
                                                ; itibaren yerleştirilir.
        ADD BX, 2			        ; D3 dizisi word tanımlı olduğu için BX
                                                ; 2 arttırılır.
        INC SI				        ; D2 dizisi byte tanımlı olduğu için SI 
						; 1 arttırılır.
        LOOP L2				        ; B1 elemanlı D2 dizisinin tüm elemanları D3
						; dizisine yerleştirilinceye kadar çevrim B1
						; kez çalışır.
	RET
ARRAYS	ENDP
ALLSG	ENDS
	END ATLA
