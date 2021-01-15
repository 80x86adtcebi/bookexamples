        ; --------------------------------------------------------------------------
        ; ANA yordam kodu içerisinde harici yordam olarak ALAN_BUL kullanılmaktadır.
        ; --------------------------------------------------------------------------
	EXTRN ALAN_BUL:FAR
MYSS	SEGMENT PARA STACK 'S'
	DW 20 DUP(?)
MYSS	ENDS
MYDS	SEGMENT PARA 'D'
KEN	DW 6, 8, 5, 9, 4, 8, 2, 2, 3
N	DW 3
ENBYKALAN DW 0
MYDS	ENDS

MYCS	SEGMENT PARA 'K'
	ASSUME CS:MYCS, DS:MYDS, SS:MYSS
ANA	PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, MYDS
        MOV DS, AX
        MOV CX, N				        ; Dizinin eleman sayısı CX içerisine 
                                                        ; alınır.
        XOR SI, SI				        ; KEN dizisi indisi SI sıfırlanır.
L1:	PUSH KEN[SI]				        ; İlk kenar yığına atılır.
        PUSH KEN[SI+2]			                ; İkinci kenar yığına atılır.
        PUSH KEN[SI+4]			                ; Üçüncü kenar yığına atılır.
        CALL ALAN_BUL				        ; ALAN_BUL yordamı çağırılır.
        CMP AX, ENBYKALAN			        ; ALAN_BUL yordamından dönen sonuç AX
                                                        ; yazmacı içerisindedir. Yani yığına
                                                        ; konulan 3 kenarın oluşturduğu üçgenin
                                                        ; alanının karesi AX’tedir.
                                                        ; AX, ENBYKALAN değişkeni ile
                                                        ; karşılaştırılır.
        JBE KUCUK				        ; AX, ENBYKALAN değişkeninden küçük
                                                        ; eşitse KUCUK etiketine atlanır.
        MOV ENBYKALAN, AX			        ; AX, ENBYKALAN değişkeninden büyükse
                                                        ; AX’in değeri ENBYKALAN değişkeninin
                                                        ; içerisine yerleştirilir.
KUCUK:	ADD SI, 6				        ; KEN dizisi içerisinde word tanımlı 3
                                                        ; kenar ardışıl olarak tutulmakta
							; olduğundan bir sonraki üçgenin 
                                                        ; kenarlarına ulaşmak için 3 kenar 
                                                        ; sonraya yani 6 sonraya atlanır. 
                                                        ; Bunun için SI’ya eklenir.
        LOOP L1					        ; L1 çevrim işlemleri N kez tekrarlanır.
        RETF
ANA	ENDP
MYCS	ENDS
	END ANA
        
        ; --------------------------------------------------------------------------
        ; ALAN_BUL harici yordamında sadece kod kesimi tanımlanmıştır.
        ; --------------------------------------------------------------------------
	PUBLIC ALAN_BUL
MYCODE	SEGMENT PARA 'KOD'
	ASSUME CS:MYCODE
ALAN_BUL PROC FAR
        ; --------------------------------------------------------------------------
        ; İşlem sırasında kullanacağımız yazmaçların daha önce sahip olduğu 
        ; değerleri kayıp etmemesi için yığında saklamalıyız. Benzer şekilde yığın
        ; kullanarak parametre aktaracağımız için BP’nin de saklanması gerekir. 
        ; --------------------------------------------------------------------------
        PUSH BX					        ; Harici yordamda kullanılan yazmaçlar
        PUSH CX					        ; BX, CX, DI ve BP yığına atılır.
        PUSH DI
        PUSH BP
        MOV BP, SP				        ; Stack Pointer ile Base Pointer’ın 
                                                        ; aynı yeri göstermesi sağlanır.
        XOR AX, AX				        ; Kenar değerleri AX içerisinde
                                                        ; toplanacağından AX değeri sıfırlanır.
        ADD AX, [BP+12]			                ; Yığına ilk atılan değerle AX toplanır.
        ADD AX, [BP+14]			                ; İkinci atılan değerle de AX toplanır.
        ADD AX, [BP+16]			                ; Üçüncü atılan değerle de AX toplanır.
        SHR AX, 1				        ; AX içerisinde olan 3 kenarın toplamı
                                                        ; 2’ye bölünerek u değeri bulunur.
        MOV BX, AX				        ; u değeri BX içerisine yerleştirilir.
        SUB BX, [BP+12]			                ; u’dan ilk kenar çıkarılır. (u-a)
        MOV CX, AX				        ; u değeri CX içerisine yerleştirilir.
        SUB CX, [BP+14]			                ; u’dan ikinci kenar çıkarılır. (u-b)
        MOV DI, AX				        ; u değeri DI içerisine yerleştirilir.
        SUB DI, [BP+16]			                ; u’dan üçüncü kenar çıkarılır. (u-c)
        MUL BX					        ; AX’de olan u ile BX’de olan (u-a) 
                                                        ; çarpılır ve sonuç AX’de oluşur.
                                                        ; AX * BX -> DX:AX, verilen değerler ile
                                                        ; DX’in bu işlem sonunda her daim 0
                                                        ; olacağı görülebilmektedir. 
        MUL CX					        ; AX’de olan u(u-a) ile CX’de olan 
                                                        ; (u-b) çarpılır ve sonuç AX’de oluşur.
        MUL DI					        ; AX’de olan u(u-a)(u-b) ile DI’da olan
                                                        ; (u-c) çarpılır ve sonuç AX’de oluşur.
                                                        ; AX’de u(u-a)(u-b)(u-c) değeri, yani
                                                        ; u’lu alan formülü gereği kenarları
                                                        ; verilen üçgenin alanının karesi AX
                                                        ; içerisinde oluşur.
        POP BP					        ; Başlangıçta yığına atılan yazmaçlar
        POP DI					        ; atıldıkları sıraların tersiyle
        POP CX					        ; yığından alınırlar.
        POP BX
        RETF 6					        ; ANA YORDAMIN YIĞINA ATTIĞI 3 KENAR 
							; DEĞERİ REFT 6 KOMUTU İLE YIĞINDAN
							; KALDIRILIR. 
ALAN_BUL ENDP
MYCODE	ENDS
	END
