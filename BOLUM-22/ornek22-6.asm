        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 22 6.ASM
        ; 8259 yardımıyla analog işareti 200HZ’de örnekleyen ve örnekleme 
        ; frekansını hassas bir şekilde kesme tabanlı olarak 8254 kullanımıyla 
        ; gerçekleştiren assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE 8259, 8254, ADC0808 ile kesme tabanlı örnekleme
STAK	SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK	ENDS

CODE	SEGMENT PARA 'CODE'
        ASSUME CS:CODE, SS:STAK
        ; -----------------------------------------------------------------------
        ; 8254’un her çevriminde tetiklenen kesmeye ilişkin KSP
        ; -----------------------------------------------------------------------
NEWINT	PROC FAR
        OUT 68H, AL	                        ; boş yazma ile ADC dönüşümü başlatır
        IRET
NEWINT	ENDP
        ; -----------------------------------------------------------------------
        ; ADC dönüşümünün bitmesiyle tetiklenen kesmeye ilişkin KSP
        ; -----------------------------------------------------------------------
NEWINT2	PROC FAR
        IN AL, 68H	                        ; ADC dönüşüm sonucu okunur
        IRET
NEWINT2	ENDP
START 	PROC FAR
        ; -----------------------------------------------------------------------
        ; 0A0H kesme vektör numarasının NEWINT’e bağlanması
        ; -----------------------------------------------------------------------
        XOR AX, AX
        MOV ES, AX
        MOV AL, 0A0H
        MOV AH, 4
        MUL AH
        MOV BX, AX
        LEA AX, NEWINT
        MOV WORD PTR ES:[BX], AX
        MOV AX, CS
        MOV WORD PTR ES:[BX+2], AX 
        ; -----------------------------------------------------------------------
        ; 0A1H kesme vektör numarasının NEWINT2’ye bağlanması
        ; -----------------------------------------------------------------------
        MOV AL, 0A1H
        MOV AH, 4
        MUL AH
        MOV BX, AX
        LEA AX, NEWINT2
        MOV WORD PTR ES:[BX], AX
        MOV AX, CS
        MOV WORD PTR ES:[BX+2], AX 
        ; -----------------------------------------------------------------------
        ; 8254’ün koşullandırılması
        ; -----------------------------------------------------------------------
        MOV AL, 34H	                        ; 34H=0011 0100B, CNTR0, 16bit, kip 2, binary
        OUT 7EH, AL
        MOV AX, 5
        OUT 78H, AL
        MOV AL, AH
        OUT 78H, AL	                        ; CNTR0 sayma değeri 5, 1000/5=200Hz
        ; -----------------------------------------------------------------------
        ; 8259’un koşullandırılması
        ; -----------------------------------------------------------------------
        MOV AL, 13H
        OUT 60H, AL
        MOV AL, 0A0H	                        ; IR0 0A0H tipinde kesme isteği tetikler
        OUT 62H, AL
        MOV AL, 03H
        OUT 62H, AL
        STI	                                ; IF<-1, INTR kesmeleri aktif
        CALL FAR PTR DELAY                      ; arayüzlerin hazır olmasını bekle
        
ENDLESS:	
        JMP ENDLESS	                        ; sonsuz döngü
START 	ENDP
        ; -----------------------------------------------------------------------
        ; Bekleme sağlayan altyordam
        ; -----------------------------------------------------------------------
DELAY 	PROC FAR
	PUSH CX
	MOV CX, 0F00H
L1:	LOOP L1
	POP CX
	RET
DELAY 	ENDP
CODE	ENDS
        END START
