        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 22 3.ASM
        ; 8259 ve 8255 kullanarak kesme tabanlı tuş tarama takımı okuyan
        ; assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE 8259 ve 8255 ile kesme tabanlı tuş tarama takımı okuma
STAK	SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK	ENDS

DATA	SEGMENT PARA 'DATA'
TUS	DB 0FFH
DATA	ENDS

CODE	SEGMENT PARA 'CODE'
        ASSUME CS:CODE, DS:DATA, SS:STAK
        ; -----------------------------------------------------------------------
        ; 8255 GrupA kip 1 giriş için kesme servis programı
        ; -----------------------------------------------------------------------
NEWINT	PROC FAR
        IN AL, 78H	                ; tuş değerini okur
        AND AL, 0FH	                ; okunan low nibble maskelenir
        MOV TUS, AL	                ; okunan değer TUS değişkeninde
        IRET
NEWINT	ENDP

START 	PROC FAR
        ;------------------------------------------------------------------------
        ; DATA ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------
        MOV AX, DATA
        MOV DS, AX
        ;------------------------------------------------------------------------
        ; 30H kesme vektör numarasının NEWINT’e bağlanması
        ;------------------------------------------------------------------------
        XOR AX, AX
        MOV ES, AX
        MOV AL, 30H
        MOV AH, 4
        MUL AH
        MOV BX, AX
        LEA AX, NEWINT
        MOV WORD PTR ES:[BX], AX
        MOV AX, CS
        MOV WORD PTR ES:[BX+2], AX
        ;------------------------------------------------------------------------
        ; 8255 ayarları
        ;------------------------------------------------------------------------
        MOV AL, 09H
        OUT 7EH, AL	                ; GrupA kip 1 giriş
        MOV AL, 0B8H	                ; BSR kipte INTRA aktif
        OUT 7EH, AL 
        ;------------------------------------------------------------------------
        ; 8259 ayarları
        ;------------------------------------------------------------------------
        MOV AL, 13H
        OUT 60H, AL	                ; kenar tetikleme IR, tek 8259
        MOV AL, 30H
        OUT 62H, AL	                ; IR0 kesme tipi 30H
        MOV AL, 03H
        OUT 62H, AL	                ; AEOI, 8086
        STI	                        ; IF<-1, INTR kesmeleri aktif
        
ENDLESS:	
        JMP ENDLESS	                ; sonsuz döngü
START 	ENDP
CODE	ENDS
        END START
