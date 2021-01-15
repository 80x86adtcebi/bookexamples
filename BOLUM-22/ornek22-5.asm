        ; -----------------------------------------------------------------------
        ; PROGRAM :Örnek 22 5.ASM
        ; 8259, ADC0804, karşılaştırıcı yardımıyla analog gerilim değerlerinden 
        ; faydalanarak kesme tabanlı tuş tarama assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE 8259, ADC0804, karşılaştırıcı ile kesme tabanlı tuş tarama
STAK	SEGMENT PARA STACK 'STACK'
	DW 20 DUP(?)
STAK	ENDS

DATA	SEGMENT PARA 'DATA'
MYDAT	DB 20 DUP(0)
DATA	ENDS

CODE	SEGMENT PARA 'CODE'
	ASSUME CS:CODE, DS:DATA, SS:STAK
        ; -----------------------------------------------------------------------
        ; ADC dönüşümü bitince çağrılacak olan KSP
        ; -----------------------------------------------------------------------
NEWINT	PROC FAR
        PUSH BP
        MOV BP, SP
        IN AL, 79H	                        ; ADC dönüşüm sonucu okunur
        MOV BL, 1
        CMP AL, 0BFH	                        ; SW1’e basıldıysa ADC sonucu 0BFH’dan büyük
        JA BUTTON_READ
        MOV BL, 2
        CMP AL, 6AH	                        ; SW2’e basıldıysa ADC sonucu 6AH’dan büyük
        JA BUTTON_READ
        MOV BL, 3
        CMP AL, 4AH	                        ; SW3’e basıldıysa ADC sonucu 4AH’dan büyük
        JA BUTTON_READ
        MOV BL,4 	                        ; SW4’e basıldıysa ADC sonucu 4AH’dan küçük
BUTTON_READ:
        POP BP
        IRET
NEWINT	ENDP
        ; -----------------------------------------------------------------------
        ; Herhangi bir tuşa basıldığında tetiklenecek KSP
        ; -----------------------------------------------------------------------
NEWINT2 PROC FAR
        PUSH BP
        MOV BP, SP
        OUT 79H, AL	                        ; ADC’ye boş yazma yaparak dönüşüm başlatır
        POP BP
        IRET
NEWINT2 ENDP
START 	PROC FAR
        ;------------------------------------------------------------------------
        ; DATA ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------
        MOV AX, DATA
        MOV DS, AX
        ;------------------------------------------------------------------------
        ; 40H kesme vektör numarasının NEWINT’e bağlanması
        ;------------------------------------------------------------------------
        XOR AX, AX
        MOV ES, AX
        MOV AL, 40H
        MOV AH, 4
        MUL AH
        MOV BX, AX
        LEA AX, NEWINT
        MOV WORD PTR ES:[BX], AX
        MOV AX, CS
        MOV WORD PTR ES:[BX+2], AX 
        ;------------------------------------------------------------------------
        ; 47H kesme vektör numarasının NEWINT2’ye bağlanması
        ;------------------------------------------------------------------------
        XOR AX, AX
        MOV ES, AX
        MOV AL, 47H
        MOV AH, 4
        MUL AH
        MOV BX, AX
        LEA AX, NEWINT2
        MOV WORD PTR ES:[BX], AX
        MOV AX, CS
        MOV WORD PTR ES:[BX+2], AX 
        ;------------------------------------------------------------------------
        ; 8259’un koşullandırılması
        ;------------------------------------------------------------------------
        MOV AL, 13H
        OUT 60H, AL
        MOV AL, 40H
        OUT 62H, AL
        MOV AL, 03H
        OUT 62H, AL
        CALL FAR PTR DELAY	                ; 8259 ve ADC0804 hazır olması için bekleme
        STI	                                ; IF<-1, INTR kesmeleri aktif
        
ENDLESS:	
        JMP ENDLESS	                        ; sonsuz döngü
START	ENDP
        ; -----------------------------------------------------------------------
        ; Bekleme sağlayan altyordam
        ; -----------------------------------------------------------------------
DELAY 	PROC FAR
	PUSH CX
	MOV CX, 000FH
L1:	LOOP L1
	POP CX
	RET
DELAY 	ENDP
CODE	ENDS
	END START
