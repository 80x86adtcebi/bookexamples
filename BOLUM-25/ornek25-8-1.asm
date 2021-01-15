        ; --------------------------------------------------------------------------
        ; Döngü işlemi CX yazmacı değeri kadar tekrarlanacağından çevrim başlama-dan 
        ; CX yazmacı içerisine ilgili değer yazılmıştır.
        ; --------------------------------------------------------------------------
CSEG 	SEGMENT PARA 'KOD'
        ORG 100H
        ASSUME CS:CSEG, DS:CSEG, SS:CSEG
MAIN	PROC NEAR
        MOV CX, N		        ; Döngünün N kere dönmesi için N, CX içine atılır.
        MOV SI, X		        ; X değeri SI içerisinde tutulur.
        MOV BX, 1		        ; İlk eleman 1 olduğu için toplam sonucunu tuta-
                                        ; cak BX yazmacına 1 değeri atanır.
        MOV AX, SI
        MOV DI, 1		        ; Çevrim değişkeni DI olacak şekilde ayarlanır.
        MOV DX, 0		        ; 16-bit’lik bölme için DX yazmacı sıfırlanır.
L1:	PUSH AX			        ; AX yazmacının değeri tekrar kullanılacağı için 
                                        ; ve bölme işlemi (DIV) sonucu AX üzerinde 
                                        ; oluşacağı için bu yazmaç yığında saklanır.
	DIV DI			        ; DX:AX / DI -> Bölüm: AX, Kalan: DX, yani 
					; istenilen değer AX üzerinde oluşur.
        ADD BX, AX		        ; Bölme işlemi sonucu BX ile toplanır.
        POP AX			        ; AX yazmacının bölmeden önceki halinin SI
                                        ; ile çağrılması için yığından alınır.
        MUL SI			        ; AX * SI -> DX:AX ikilisinde oluşur. x ve n 
                                        ; değerleri için verilen kısıtlardan ötürü
                                        ; DX değeri her durumda 0 olur.
        INC DI			        ; Çevrim indisi arttırılır.
        LOOP L1			        ; İşlem CX kere tekrar edilir.
        MOV SONUC, BX		        ; BX yazmacında oluşan değer, SONUC de-ğişkenine
                                        ; alınır.
        RET
MAIN	ENDP
SONUC   DW ?
N 	DW 6
X	DW 5
CSEG	ENDS
	END MAIN
