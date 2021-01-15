        ; --------------------------------------------------------------------------
        ; COM tipi programda veri kesiminin kod kesiminden önce yerleştirildiği ve   
        ; JMP kodu ile ana yordama atlandığı yapı kullanılmıştır.
        ; --------------------------------------------------------------------------
CODESG	SEGMENT PARA 'KOD'
	ORG 100H
	ASSUME DS:CODESG, SS:CODESG, CS:CODESG
BASLA:	JMP SICAKLIK
N	DW 365
DIZI    DB 365 DUP(?)
ESIK	DB -20
SONUC	DB ?
SICAKLIKPROC NEAR
        XOR SI, SI			        ; DIZI indis yazmacı SI sıfırlanır.
        MOV CX, N			        ; DIZI’nin boyutu N, CX yazmacına atılır.
        MOV AL, ESIK			        ; ESIK değişkeni değeri AL içerisine konur.
DON:	CMP SI, CX			        ; SI ile CX karşılaştırılır.
	JAE YANLIS			        ; SI, CX değerine küçük eşitse YANLIS
                                                ; etiketine atlanır.
        CMP AL, DIZI[SI]		        ; SI, CX değerinden büyükse AL ile DIZI’nin
                                                ; SI indisindeki eleman karşılaştırılır.
        JG DOGRU				; AL, DIZI’nin SI indisli elemanından
                                                ; büyükse DOGRU etiketine atlanır.
        INC SI				        ; DIZI byte tanımlı olduğu için SI
                                                ; 1 arttırılır.
        JMP DON				        ; Çevrim koşuluna gitmek için DON etiketine
                                                ; atlanır.
YANLIS:	MOV SONUC, 0			        ; SONUC değişkenine 0 değeri atanarak
	JMP SON				        ; SON etiketine atlanır. Yani ESIK değerin
						; altında bir değer bulunamamıştır.
DOGRU:	MOV SONUC, 1			        ; SONUC değişkenine 1 değeri atanır. Yani
						; ESIK değerin altında bir değer 
                                                ; bulunmuştur.
SON:	RET
SICAKLIK ENDP
CODESG	ENDS
	END BASLA
