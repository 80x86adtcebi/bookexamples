        ; --------------------------------------------------------------------------
        ; Program içerisinde kullanılan yazmaçların karşılık geldiği değişkenler     
        ; akış diyagramında gösterilmiştir.
        ; --------------------------------------------------------------------------
MYDS	SEGMENT PARA 'VERI'
DIZI	DB 1, 2, 3, 4, 5
N	DW 5
S	DB ?
MYDS	ENDS

MYSS	SEGMENT PARA STACK 'YIGIN'
	DW 20 DUP(?)
MYSS	ENDS

MYCS	SEGMENT PARA 'KOD'
	ASSUME DS:MYDS, SS:MYSS, CS:MYCS
ANA	PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, MYDS
        MOV DS, AX
        MOV BX, 0			        ; BX yazmacı döngü koşulunun bozulup 
                                                ; bozulmadığını belirlemek için kullanılır.
                                                ; Başlangıç değeri 0’dır.
        XOR SI, SI			        ; SI, DIZI’nin indisini tutmaktadır.
                                                ; Sıfırlanarak dizinin ilk elemanını 
                                                ; gösterir hale gelir.
	MOV CX, N			        ; DIZI’nin eleman sayısı CX’e alınır.
        DEC CX				        ; Sondan bir önceki eleman için son elemanla
                                                ; karşılaştırma yapılacağından CX değeri 1
                                                ; azaltılır.
DON:	CMP BX, 0			        ; Kontrol yazmacı BX, 0 ile karşılaştırılır.
        JNE SON_IF			        ; 0’a eşit değilse SON_IF etiketine atlanır.
        CMP SI, CX			        ; 0’a eşitse SI ile CX karşılaştırılır.
        JGE SON_IF			        ; SI, CX’ten büyük eşitse SON_IF etiketine
                                                ; atlanır.
        MOV AL, DIZI[SI]		        ; DIZI’nin SI indisli elemanı AL’ye alınır.
        CMP AL, DIZI[SI+1]	                ; AL ile DIZI’nin SI+1 indisli elemanı
                                                ; karşılaştırılır.
        JLE ARTIR			        ; AL, DIZI’nin SI+1 indisli elemanından
                                                ; küçük eşitse ARTIR etiketine atlanır.
        MOV BX, 1			        ; Büyükse kontrol yazmacı BX’e, 1 atanır.
ARTIR:	INC SI				        ; İndis yazmacı DIZI byte tanımlı olduğu için
						; 1 arttırılır.
	JMP DON				        ; Döngü koşullarına (DON etiketine) atlanır.
SON_IF:	CMP BX, 0			        ; Döngüden çıkılmıştır. Döngüde 2 adet koşul
                                                ; olduğundan hangi koşulun bozulduğunu
						; anlamak için BX ile 0 karşılaştırılır.
	JNE SIRASIZ			        ; BX, 0 değilse, dizi sıralı olmayacağı için
						; SIRASIZ etiketine atlanır.
	MOV S, 1				; BX, 0’a eşitse dizi sıralıdır ve bunun için 								
                                                ; S değişkenine 1 yazılır.
	JMP SON				        ; Program sonuna atlanır.
SIRASIZ:MOV S, 0				; DIZI sırasız ise bu satıra gelinmiştir.
						; Bunun için S değişkenine 0 yazılır.
SON:	RETF
ANA	ENDP
MYCS	ENDS
	END ANA
