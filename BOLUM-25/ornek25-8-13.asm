        ; -----------------------------------------------------------------------
        ; İkili arama (Binary Search) 
        ; -----------------------------------------------------------------------
MYSEG	SEGMENT PARA 'CODE'
	ORG 100H 
	ASSUME CS:MYSEG,SS:MYSEG, DS:MYSEG
BILGI:	JMP MAIN 
DIZI	DW -21, -8, -3, -1, 0 , 4, 14, 21, 45, 67
ELEMAN	DW 10 
SAYI 	DW 45
ADRES	DW 0FFFFH	                        ; Aranan sayının dizide olmadığı var sayılarak
						; adres değişkeni 0FFFFH yapılmıştır. 
MAIN  	PROC NEAR
        XOR SI, SI	                        ; dizinin ilk elemanının göreli adresi
        MOV DI, ELEMAN	                        ; Word tanımlı dizinin son elemanını takip eden 
                                                ; bellek gözünün adresi 2 * eleman kadar uzakta 
                                                ; olacaktır. Dizi 0. adresten başladığı için 
        SHL DI, 1	                        ; son eleman da 2 * elaman -2 adresinde yer alır.
        SUB DI, 2	                        ; dizinin son elemanının göreli adresi
        MOV AX, SAYI 	                        ; aranacak olan sayı AX’e konur.
KONT:   CMP SI, DI	                        ; dizinin ilk elemanının göreli adresi, son elemanın 			
        JG SON		                        ; göreli adresinden büyük ise işlem sonlanır 
        MOV BX, SI	                        ; dizinin ortasına denk gelen adresin bulunması için
        ADD BX, DI	                        ; baş ve son adres toplanıp 2’ye bölünüyor. 
        SHR BX, 1	
        AND BX, 0FEH	
        CMP AX, DIZI[BX]                        ; ortadaki elemanı ile aranan sayıyı karşılaşır.
        JE BULDU 	                        ; aranan sayı bulundu 
        JG SAGDA		                ; AX büyük ise, sayı dizinin ortası ile sonu arasında
        MOV DI, BX	                        ; değil ise başı ile ortası arasında olacaktır.
        SUB DI, 2	                        ; DI←BX yaparak dizinin ortasını sonu kabul et 
                                                ; karşılaştırmayı zaten orta eleman ile yaptığımız
                                                ; için ondan önceki elamanı kullanacağız 
        JMP KONT
SAGDA:	MOV SI, BX	                        ; SI←BX yaparak dizinin başını ortası kabul et 				
        ADD SI, 2	                        ; karşılaştırmayı zaten orta eleman ile yaptığımız
						; için ondan sonraki elamanı kullanacağız 
	JMP KONT
BULDU:	MOV ADRES, BX	                        ; BX yazmacında saklanan adres değerini belleğe koy
        MOV SI, DI	                        ; kont isimli çevrinden (while) düzgün çıkmak için
                                                ; koşul ifadesini çevrinden çıkacak şekilde ayarla 
        ADD SI, 2	                        ; Word dizi olduğu için indisi 2 arttır 
        JMP KONT		                ; çevrim koşulunu kontrol etmek üzere dallan 
SON:	RET 
MAIN	ENDP
MYSEG	ENDS
	END BILGI
