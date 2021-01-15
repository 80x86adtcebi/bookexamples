        ; --------------------------------------------------------------------------
        ; SWAP işlemi için XCHG komutu kullanılmıştır.
        ; --------------------------------------------------------------------------
CODESG 	SEGMENT PARA 'KOD'
        ORG 100H
        ASSUME CS:CODESG, DS:CODESG, SS:CODESG
BASLA:	JMP EBOB
SONUC	DW ?
A 	DW 28
B	DW 32
EBOB	PROC NEAR
        MOV AX, A
        MOV BX, B
        CMP AX, BX		        ; A ile B değerlerinden büyük olanının 
                                        ; karşılaştırma işleminin ilk operandı olması
                                        ; gerekir. Bunun için A ile B, AX ve BX yazmaçları
                                        ; üzerinden karşılaştırılır. A ve B’den büyük 
                                        ; olan AX’in içerisine küçük olan BX’in içerisine
                                        ; konulur.
	JAE L1			        ; AX, BX’den büyük eşitse istenilen kombinas-yon
                                        ; oluşmuştur. İşleme atlanır.
	XCHG AX, BX		        ; AX, BX’den büyük değilse bu iki yazmacın
					; içerisindeki değerler yer değiştirilir.
L1:	MOV DX, 0		        ; 16-bit’lik bölme işlemi yapılacağı için DX
					; yazmacı sıfırlanır.
	DIV BX			        ; DX:AX / BX -> Bölüm: AX, Kalan: DX
					;    32 / 28 -> Bölüm: 1,  Kalan: 4
	CMP DX, 0		        ; Bölme işlemi sonucu kalan 0 ise EBOB, BX 
                                        ; yazmacı üzerinde oluşmuştur. 
        JE L2			        ; O sebeple (kalan 0 ise) L2 etiketine atla-nır.
        MOV AX, BX		        ; Kalan 0 değilse BX, AX’e, DX de BX’e alı-nır.
        MOV BX, DX
        JMP L1			        ; Koşullu döngünün başına atlanır.
L2:	MOV SONUC, BX		        ; BX üzerinde oluşan EBOB değeri SONUC
					; değişkenine alınır.
	RET
EBOB	ENDP
CODESG	ENDS
	END BASLA
