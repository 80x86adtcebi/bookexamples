        ; --------------------------------------------------------------------------
        ; JMP komutları ile atlanılan yerler akış diyagramında noktalı yuvarlaklarla 
        ; gösterilmektedir.
        ; --------------------------------------------------------------------------
        ; KULLANILAN DEĞİŞKENLERİN TANIMLANMASI 
        ; --------------------------------------------------------------------------
DATASG	SEGMENT PARA 'VERI'
A	DB 4
B	DB 5
C	DB 3
TIP	DB ?
DATASG	ENDS

STACKSG	SEGMENT PARA STACK 'YIGIN'
	DW 12 DUP(?)
STACKSG	ENDS

CODESG	SEGMENT PARA 'KOD'
	ASSUME DS:DATASG, SS:STACKSG, CS:CODESG
ANA	PROC FAR
        ;------------------------------------------------------------------------
        ; Dönüş için gerekli olan değerler yığında saklanıyor
        ;------------------------------------------------------------------------
        PUSH DS
        XOR AX, AX
        PUSH AX
        ;------------------------------------------------------------------------
        ; DATASG ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------				
        MOV AX, DATASG
        MOV DS, AX
        MOV AL, A			        ; Sırasıyla a, b, c üçgen kenarları Al, BL,
        MOV BL, B			        ; CL byte tipindeki yazmaçlara 
        MOV CL, C			        ; yerleştirilir.
        CMP AL, BL			        ; AL ile BL yazmaç değerleri karşılaştırılır
        JE J1				        ; AL, BL’ye eşitle J1 etiketine atlanır.
        CMP BL, CL			        ; AL, BL’ye eşit değilse BL ile CL yazmaç 
                                                ; değerleri karşılaştırılır.
        JE J2				        ; BL, CL’ye eşitse J2 etiketine atlanır.
        CMP AL, CL			        ; BL, CL’ye eşit değilse AL ile CL yazmaç
                                                ; değerleri karşılaştırılır.
        JE J2				        ; AL, CL’ye eşitse J2 etiketine atlanır.
        MOV TIP, 3			        ; AL, CL’ye eşit değilse üçgen çeşitkenardır
        JMP SON				        ; Tip bulunmuştur, program sonuna atlanır.
J1:	CMP AL, CL			        ; AL, BL’ye eşit olmadığı için buraya
						; gelindi. Burada AL ile CL karşılaştırılır.
	JNE J2				        ; AL, CL’ye eşit değilse J2 etiketine 
                                                ; atlanır.
	MOV TIP, 1			        ; AL, CL’ye eşitse üçgen eşkenardır.
	JMP SON				        ; Tip bulunmuştur, program sonuna atlanır.
J2:	MOV TIP, 2			        ; Diğer durumlarda ise üçgen ikizkenardır.
SON:	RETF
ANA	ENDP
CODESG	ENDS
	END ANA
