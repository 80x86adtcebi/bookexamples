        ; --------------------------------------------------------------------------
        ; Elemanlar işaretli olabileceği için karşılaştırma işlemleri uygun kodlarla 
        ; gerçekleştirilmiştir.
        ; --------------------------------------------------------------------------
MY_SS	SEGMENT PARA STACK 'STACK'
	DW 20 DUP(?)
MY_SS	ENDS

MY_DS	SEGMENT PARA 'DATA'
N1	DW 7
N2	DW 6
D1	DB 7, 12, 64, 98, 104, 105, 125
D2	DB -70, -10, 9, 17, 68, 90
DSON	DB 13 DUP(?)
MY_DS	ENDS

MY_CS	SEGMENT PARA 'CODE'
	ASSUME DS:MY_DS, SS:MY_SS, CS:MY_CS
MAIN	PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, MY_DS
        MOV DS, AX
        XOR BX, BX			                ; İndis değişkenleri BX, SI, DI sıfırlanır.
        XOR SI, SI
        XOR DI, DI
DON:	CMP SI, N1			                ; SI ile D1 dizisinin boyutu olan N1 değeri
                                                        ; karşılaştırılır.
        JAE ATLA				        ; SI, N1 değerinden küçük eşitse ATLA
                                                        ; etiketine gidilir. Yani D1 dizisi
                                                        ; elemanları önce bitmişse ATLA’ya gidilir.
        CMP DI, N2			                ; SI, N1 değerinde büyükse DI ile D2
                                                        ; dizisinin boyutu olan N2 karşılaştırılır.
        JAE ATLA				        ; DI, N2 değerinden küçük eşitse ATLA
                                                        ; etiketine gidilir. Yani D2 dizisi
                                                        ; elemanları önce bitmişse ATLA’ya gidilir.
        MOV AL, D1[SI]		                        ; D1’in SI indisli elemanı AL’ye alınır.
        MOV AH, D2[DI] 		                        ; D2’in DI indisli elemanı AH’ye alınır.
        CMP AL, AH			                ; AL ile AH karşılaştırılır.
        JL JD1				                ; AL, AH’den küçük ise JD1 etiketine atlanır.
        MOV DSON[BX], AH		                ; AL, AH’den büyük eşitse AH yazmacı değeri
                                                        ; DSON dizisinin BX indisli elemanına konur.
        INC DI				                ; D2 dizisi byte tanımlı olduğu için DI
                                                        ; 1 arttırılır.
        JMP ORTAK			                ; ORTAK ETİKETİNE ATLANIR.
JD1:	MOV DSON[BX], AL		                ; AL yazmacı değeri DSON dizisinin BX indisli 
							; elemanına konur.
	INC SI				                ; D1 dizisi byte tanımlı olduğu için SI
							; 1 arttırılır.
ORTAK:	INC BX				                ; DSON dizisi byte tanımlı olduğu için BX
							; 1 arttırılır.
	JMP DON				                ; DON etiketine atlanarak çevrim sağlanır.
ATLA:	CMP DI, N2			                ; Çevrimden hangi koşul bozularak çıkıldığı
							; anlaşılmaya çalışılır. DI ile N2
							; karşılaştırılır.
	JE LD2				                ; DI ile N2 eşitse LD2 etiketine atlanır.
	MOV CX, N2			                ; DI ile N2 eşit değilse D1 dizisi önce
                                                        ; bitmiştir ve D2 dizisinin kalan elemanları 
                                                        ; DSON içerisine konulmalıdır. Bunun için N2 
                                                        ; değeri CX içerisine atılır. 
        SUB CX, DI			                ; D2’nin DSON içerisine şuana kadar kaç 
                                                        ; elemanı atıldıysa, N2’den bu değer
                                                        ; çıkarılmalıdır. Bunun için CX’ten DI
                                                        ; çıkarılır.
L1:	MOV AL, D2[DI]		                        ; D2’nin DI indisli elemanı AL’ye konur.
        MOV DSON[BX], AL		                ; AL, DSON dizisinin BX indisine konur.
        INC BX				                ; BX 1 arttırılır.
        INC DI				                ; DI 1 arttırılır.
        LOOP L1				                ; L1 çevrimi işlemleri CX-DI kez yapılır.
        JMP SON				                ; SON etiketine atlanır.
LD2:	MOV CX, N1			                ; DI ile N2 eşitse D2 dizisi önce bitmiştir
                                                        ; ve D1 dizisinin kalan elemanları DSON 
                                                        ; içerisine konulmalıdır. Bunun için N1 
                                                        ; değeri CX içerisine atılır.
        SUB CX, SI			                ; D1’nin DSON içerisine şuana kadar kaç 
                                                        ; elemanı atıldıysa, N1’den bu değer
                                                        ; çıkarılmalıdır. Bunun için CX’ten SI
                                                        ; çıkarılır.
L2:	MOV AL, D1[SI]		                        ; D1’nin SI indisli elemanı AL’ye konur.
        MOV DSON[BX], AL		                ; AL, DSON dizisinin BX indisine konur.
        INC BX				                ; BX 1 arttırılır.
        INC SI				                ; SI 1 arttırılır.
        LOOP L2
SON:	RETF
MAIN	ENDP
MY_CS	ENDS
	END MAIN
