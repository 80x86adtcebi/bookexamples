        ; -----------------------------------------------------------------------
        ; Büyük Tansiyon > Küçük Tansiyon olacaktır. 
        ; BYK 	: Büyük tansiyon değerleri
        ; KCK 	: Küçük tansiyon değerleri 
        ; GUN	: Farkın en fazla olduğu gün 
        ; -----------------------------------------------------------------------
MYSTACK SEGMENT PARA STACK 'STACK'
	DW 32 DUP (?)
MYSTACK	ENDS

MYDATA	SEGMENT PARA 'DATA'
BYK	DB 12,13,14,15,15,16,13,12,10,9
KCK	DB 5 , 6, 7, 8, 9, 3, 2, 5, 5,6
GUN 	DW 0
ELEMAN 	DW 10
MYDATA 	ENDS

MYCODE	SEGMENT PARA 'CODE'
	ASSUME CS:MYCODE, SS:MYSTACK, DS:MYDATA 
MAIN	PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, MYDATA 	
        MOV DS, AX
        MOV CX, ELEMAN	                        ; tekrar sayısı CX yazmacına konur
        XOR SI, SI		                ; dizi indisi olacak 
        XOR BX, BX		                ; tansiyon arasındaki en büyük farkı tutar
L1:	MOV AL, BYK[SI]	                        ; Büyük tansiyon değeri AL’de
        SUB AL, KCK[SI]	                        ; Küçük tansiyon değeri BL’de
        CMP AL, BL 
        JB SONRAKI 		                ; sayılar işaretsiz 
        MOV BL, AL		                ; fark daha büyük ise BL'ye koy
        MOV GUN, SI		                ; indisi GUN olarak sakla
SONRAKI:INC SI			                ; dizi byte, artım tek olmalı
        LOOP L1
        RET 
MAIN	ENDP
MYCODE	ENDS
	END MAIN
