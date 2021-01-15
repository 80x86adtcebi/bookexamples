        ; --------------------------------------------------------------------------
        ; COM tipi programda veri kesiminin kod kesiminden sonra yerleştirildiği
        ; model kullanılmıştır.
        ; --------------------------------------------------------------------------
MYS	SEGMENT PARA 'KOD'
	ORG 100H
	ASSUME CS:MYS, DS:MYS, SS:MYS
KAYNAK_BUL PROC NEAR
	XOR BX, BX				; KUYRUK dizisinin indisi olarak 
                                                ; kullanılacak BX yazmacı 0’lanır.
        MOV AL, K_ESIK			        ; K_ESIK değeri AL yazmacına konur.
        MOV AH, B_ESIK			        ; B_ESIK değeri AH yazmacına konur.
DON:	CMP KUYRUK[BX], AL		        ; KUYRUK dizisinin BX indisli elemanı
                                                ; ile AL karşılaştırılır.
        JB SONRAKI				; KUYRUK[BX], AL’den küçükse SONRAKI
                                                ; etiketine atlanır.
        CMP KUYRUK[BX], AH		        ; KUYRUK[BX], AL’den büyük eşitse
                                                ; KUYRUK dizisinin BX indisli elemanı
                                                ; ile AH karşılaştırılır.
        JBE BULUNDU				; KUYRUK[BX], AH’den küçük eşitse
                                                ; BULUNDU etiketine atlanır.
SONRAKI:INC BX					; KUYRUK[BX], AH’den büyükse BX
                                                ; yazmacının değeri 1 arttırılır.
        JMP DON					; Çevrim koşuluna gitmek için DON
                                                ; etiketine atlanır.
BULUNDU:MOV INDIS, BL				; Kuyruğa sonradan giren kişinin sırası 
                                                ; BL, INDIS değişkeni içerisine atılır.
SON:	RET
KAYNAK_BUL ENDP
KUYRUK	DB 14, 11, 54, 62, 11, 3, 8, 63, 81, 5, 16
K_ESIK	DB 15
B_ESIK	DB 50
INDIS	DB ?
MYS	ENDS
	END KAYNAK_BUL
