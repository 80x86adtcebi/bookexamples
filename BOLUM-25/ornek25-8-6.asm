        ; --------------------------------------------------------------------------
        ; Tüm öğrenciler dersten başarılı, başarısız veya bütünleme olarak 
        ; gruplanabileceğinden bu değişkenlerin tipleri word olarak tanımlanmış-tır.
        ; --------------------------------------------------------------------------
MYDS	SEGMENT PARA 'DATA'
DIZI	DB 280 DUP(?)
N       DW 280
BASARISIZ DW 0
BASARILI DW 0
BUT	DW 0
TOPNOT	DW 0
ESIK	DB 40
MYDS	ENDS

MYSS	SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
MYSS	ENDS

MYCS	SEGMENT PARA 'CODE'
	ASSUME DS:MYDS, SS:MYSS, CS:MYCS
CAN	PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, MYDS
        MOV DS, AX
        XOR SI, SI			        ; DIZI’nin indis yazmacı 0’lanır.
        MOV CX, N			        ; DIZI’nin eleman sayısı CX’e yerleştirilir.
L1:	MOV AL, DIZI[SI]		        ; DIZI’nin SI indisli elemanı, AL yazmacına 
                                                ; alınır.
        CMP AL, ESIK			        ; AL, ESIK değişkeni ile karşılaştırılır.
        JAE ESIKUSTU			        ; AL, ESIK değerinden büyük eşitse ESIKUSTU
                                                ; etiketine atlanır.
        INC BASARISIZ			        ; AL, ESIK değerinden küçükse BASARISIZ
                                                ; değişkeni değeri 1 arttırılır.
        JMP D1				        ; Başarısız notu olan bir öğrenci bulunduğu 
                                                ; için, bu not ortalamaya katılmayacağından
						; toplama işlemine gerek olmadığı için 
                                                ; atlanarak D1 etiketine gidilir.
ESIKUSTU:
        CBW		                        ; Öğrencinin, AL içerisindeki notu ESIK 
                                                ; değerin üstünde ise AL, AX’e genişletilir.
        ADD TOPNOT, AX		                ; Böylece word tanımlı TOPNOT değişkeni ile
                                                ; tip uyumsuzluğu olmadan toplanabilir.
D1:	INC SI				        ; Yeni nota erişmek için SI, 1 arttırılır.
        LOOP L1				        ; İşlemin N kez tekrarlanması sağlanır.
        MOV CX, N			        ; Öğrenci sayısı (N), CX içerisine alınır.
        SUB CX, BASARISIZ		        ; Başarısızların sayısı CX’ten çıkarılır.
        XOR DX, DX			        ; 16-bit’lik bölme işlemi öncesi DX 0’lanır.
        MOV AX, TOPNOT		                ; Başarısız öğrenciler hariç diğer 
                                                ; öğrencilerin notları AX’e yerleştirilir.
        DIV CX				        ; DX:AX / CX işlemi sonucunda Bölüm: AX, 
                                                ; Kalan: DX üzerinde oluşur. Yani
                                                ; başarısızlar hariç diğer öğrencilerin
                                                ; notlarının ortalaması AX yazmacındadır.
                                                ; Notlar 0-100 arasında olduğu için AH’nın
                                                ; değeri 0 olmalıdır. Yani ortalama AL
                                                ; içerisindedir.
        XOR SI, SI			        ; DIZI indisi SI, tekrar 0’lanır.
        MOV CX, N			        ; N öğrenci sayısı CX içerisine atılır.
L2:	MOV AH, DIZI[SI]		        ; DIZI’nin SI indisli elemanı (sırası SI
						; olan öğrencinin notu), AH’ya atılır.
        CMP AL, AH			        ; AL (eşik üstü öğrencilerin not ortalaması)
						; ile AH karşılaştırılır.
        JBE GECTI			        ; AL, AH’dan küçük eşitse GECTI etiketine
						; atlanır.
        CMP AH, ESIK			        ; AL, AH’dan büyükse, AH ile ESIK değeri
						; karşılaştırılır.
        JB KALDI				; AH, ESIK değerinden küçükse KALDI
						; etiketine atlanır.
        INC BUT				        ; AH, ESIK değerinden büyük eşitse, BUT
						; değişkeni değeri 1 arttırılır.
        JMP KALDI			        ; KALDI etiketine atlanır.
GECTI:	INC BASARILI			        ; BASARILI değişkeni 1 arttırılır.
KALDI:	INC SI				        ; İndis yazmacı SI değeri 1 arttırılır.
        LOOP L2				        ; N kere çevrim işlemleri tekrarlanır.
        RETF
CAN	ENDP
MYCS	ENDS
        END CAN
