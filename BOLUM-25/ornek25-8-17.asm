        ; --------------------------------------------------------------------------
        ; Akış diyagramı yüksek seviye elementlerle hazırlandığı için SQROOT 
        ; yordamı çağırıldığında içerisine parametre olarak verilen dizi[i] değerinin
        ; otomatik olarak yığına atıldığı ve SQROOT yordamının geri dönüşünü AX
        ; yazmacı üzerinden yaptığı akış diyagramını tasarlarken bilinmektedir.
        ; Aşağıda verilen program bu bilgiler ışığında yazılmıştır.
        ; --------------------------------------------------------------------------
        EXTRN SQROOT:FAR	                ; Kullanılacak olan harici yordamı tanımla 
MYSS	SEGMENT PARA STACK 'STACK'
	DW 12 DUP (?)
MYSS	ENDS

MYDS 	SEGMENT PARA 'DATA'
DIZI 	DW 16, 2, 4, 8, 9
KOK 	DW 5 DUP (?)
ELEMAN 	DW 5
MYDS	ENDS

MYCD	SEGMENT PARA 'CODE'
	ASSUME CS:MYCD, SS:MYSS, DS:MYDS
MAIN  	PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, MYDS
        MOV DS, AX
        MOV CX, ELEMAN	                        ; Çevrim sayısını ayarla 
        XOR SI, SI		                ; Her iki dizi içinde SI indis olacak 
L1:	PUSH DIZI[SI]		                ; parametreyi yığına koy/çağırılan kaldıracak
        CALL SQROOT		                ; yordamı çağır
        MOV KOK[SI], AX	                        ; karekök değerini yeni diziye koy 
        ADD SI, 2			        ; diziler word bir sonraki eleman iki ileride 
        LOOP L1
        RET 
MAIN 	ENDP
MYCD	ENDS
	END 	MAIN
