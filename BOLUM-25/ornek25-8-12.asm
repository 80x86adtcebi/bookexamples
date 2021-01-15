        ; --------------------------------------------------------------------------
        ; MAIN yordam içerisinde SAY harici yordamı çağırılmıştır.
        ; --------------------------------------------------------------------------
	EXTRN SAY:FAR
MYSS	SEGMENT PARA STACK 'S'
	DW 20 DUP(?)
MYSS    ENDS

MYDS    SEGMENT PARA 'DATA'
DIZI	DW 12, 12, 12, 12, 12, 12, 13, 14, 15, 16, 17
N 	DW 11
ARANAN	DB 12
SONUC	DW ?
MYDS	ENDS

MYCS	SEGMENT PARA PUBLIC 'CODE'
	ASSUME CS:MYCS, DS:MYDS, SS:MYSS
MAIN	PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, MYDS
        MOV DS, AX
        XOR AX, AX				        ; AH yazmacının 0’lanması için AX
                                                        ; yazmacı sıfırlanır. Çünkü XOR AX, AX
                                                        ; kodunun performansı XOR AH, AH komutu
                                                        ; performansından daha iyidir.
        MOV AL, ARANAN			                ; ARANAN değişkeninin değeri AL
                                                        ; yazmacına konulur.
        PUSH AX					        ; AX yığına atılır.
        LEA AX, DIZI				        ; DIZI’nin adresi AX yazmacına alınır.
        PUSH AX					        ; AX üzerinden DIZI’nin adresi yığına 
                                                        ; atılır.
        PUSH N					        ; DIZI’nin eleman sayısı (N) yığına
                                                        ; atılır.
        CALL SAY					; SAY yordamı çağırılır.
        MOV SONUC, AX				        ; SAY yordamından AX üzerinden 
                                                        ; döndürülen değer SONUC değişkenine
                                                        ; yerleştirilir.
	RETF
MAIN	ENDP
MYCS	ENDS
	END MAIN
	
        ; --------------------------------------------------------------------------
        ; SAY harici yordamı içerisinde sayma işlemi gerçekleştirilmektedir.
        ; --------------------------------------------------------------------------
	PUBLIC SAY
MYCS	SEGMENT PARA PUBLIC 'CODE'
	ASSUME CS:MYCS
SAY	PROC FAR
        PUSH CX					        ; Harici yordamda kullanılan yazmaçlar 
        PUSH DI					        ; CX, DI ve BP yığına atılır.
        PUSH BP
        MOV BP, SP				        ; Stack Pointer ile Base Pointer’ın 
                                                        ; aynı yeri göstermesi sağlanır.
        MOV CX, [BP+10]			                ; Yığına en son atılan değer olan
                                                        ; dizinin eleman sayısı yığından CX
                                                        ; yazmacına alınır.
        MOV DI, [BP+12]			                ; DIZI’nin adresi DI yazmacına alınır.
        MOV BX, [BP+14]			                ; Aranan sayı BX yazmacına alınır.
        XOR AX, AX				        ; AX değeri sıfırlanır.
L1:	CMP BX, [DI]				        ; BX ile DI yazmacının gösterdiği
                                                        ; yerdeki word değer karşılaştırılır.
        JNE ATLA					; BX, DI adresindeki bir word değere
                                                        ; eşit değilse ATLA etiketine gidilir.
        INC AX					        ; BX, DI adresindeki bir word değere
                                                        ; eşitse AX yazmacının değeri 1 artar.
ATLA:	ADD DI, 2				        ; DIZI word tanımlı olduğu için DI
                                                        ; yazmacı 2 arttırılır.
        LOOP L1					        ; Çevrim işlemleri CX kez yapılır.
        POP BP					        ; Başlangıçta yığına atılan yazmaçlar
        POP DI					        ; atıldıkları sıraların tersiyle
        POP CX					        ; yığından alınırlar.
        RETF 6					        ; MAIN yordam tarafından yığına atılan
                                                        ; aranan sayı, dizinin adresi ve dizinin
                                                        ; eleman sayısı değerlerini yığından
                                                        ; kaldırmak için RETF 6 komutu 
                                                        ; kullanılır.
SAY	ENDP
MYCS	ENDS
	END
