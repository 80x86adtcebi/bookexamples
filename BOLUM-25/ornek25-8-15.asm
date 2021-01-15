        ; --------------------------------------------------------------------------
        ; Bir sayının en düşük anlamlı bit’inin ne olduğunu tespit etmek için akış
        ; diyagramında genel bir yapı tercih edilmişken program yazılırken assembly 
        ; kodlarının kabiliyetleri kullanılarak öteleme ve CF ile toplama işlemleri 
        ; ile daha kısa ve efektif bir program yazılmıştır.
        ; --------------------------------------------------------------------------
MYCODE	SEGMENT PARA 'CODE'
	ORG 100H
	ASSUME CS:MYCODE, SS:MYCODE, DS:MYCODE
MAIN	PROC NEAR
        XOR DI,DI		                ; DI en	fazla 1 barındıran elemanın indisini tutar
        XOR SI,SI		                ; SI işlenecek elemanın adresini tutar.
        XOR DX,DX		                ; DL elemanın ikili gösterimdeki 1 sayısını tutar
                                                ; DH ise en fazla 1’in kaç defa geçtiğini tutar
        MOV CX,ELEMAN
L2:	MOV AX,DIZI[SI]
        PUSH CX		                        ; Dış cevrimin tekrar sayısı bozulmasın diye saklanır 
        MOV CX,16		                ; dizi word olduğu için öteleme işlemi 16 tekrarlı 
        XOR DL,DL		                ; 1’leri saymak için sayısı sıfırla 
L1:	SHR AX,1 
        ADC DL,0		                ; öteleme sonucunda CF’deki değerleri topla 
        LOOP L1		                        ; eleman içindeki 1'lerin sayısı DL’de bulundu 
        CMP DH,DL		                ; DH ≥ DL ise değişen bir şey yok  
        JGE NEXT 	
        MOV DH,DL		                ; DL, şu ana kadar bulunmuşlardan daha büyük 
        MOV DI,SI		                ; indisi ayarla 
NEXT:	POP CX		                        ; Dış çevrimin saklanan değerini yığından al 
        ADD SI,2		                ; dizi word olduğu için artım çift 
        LOOP L2
        MOV YER,DI	                        ; sonucu belleğe yaz
        RET
MAIN	ENDP
ELEMAN	DW 10
DIZI 	DW 88H,45H,71H,77H,63H,0AAH,56H,12H,92H,0BFH
YER	DW ?	
MYCODE	ENDS
	END MAIN
