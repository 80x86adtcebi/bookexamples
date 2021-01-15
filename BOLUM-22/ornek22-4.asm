        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 22 4.ASM
        ; 8259 ve 8251 veri alma ve gönderme kesmeleri yardımıyla alınan karakter 
        ; sayısı 5 olunca topluca bu 5 karakteri ASCII karşılıklarına 1 
        ; ekleyerek gönderen assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE 8259 ve 8251 kullanarak kesme tabanlı veri alma gönderme
STAK	SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
STAK	ENDS

DATA	SEGMENT PARA 'DATA'
MYDAT	DB 5 DUP(0)
DATASAY DW 0
DATASENDSAY DW 0
ALLSENT DB 1
DATA	ENDS

CODE	SEGMENT PARA 'CODE'
        ASSUME CS:CODE, DS:DATA, SS:STAK
        ; -----------------------------------------------------------------------
        ; 8251 seri veri alma KSP
        ; -----------------------------------------------------------------------
NEWINT	PROC FAR
        IN AL, 7CH	                        ; gelen karakteri oku
        INC AL	                                ; ASCII bir fazlasını sakla
        MOV SI, DATASAY
        MOV MYDAT[SI], AL
        INC SI
        CMP SI, 5
        JNE DEVAM	                        ; 5 karakter biriktirilmiş mi
        XOR SI, SI	                        ; alma indisini sıfırla
        MOV ALLSENT, 0
        MOV AL, MYDAT[0]
        OUT 7CH, AL	                        ; 5 karakterden ilkini gönder
	INC DATASENDSAY
DEVAM:	MOV DATASAY, SI
	IRET
NEWINT	ENDP
        ; -----------------------------------------------------------------------
        ; 8255 seri veri gönderme KSP
        ; -----------------------------------------------------------------------
NEWINT2	PROC FAR
        CMP ALLSENT, 1	                        ; 5 karakterin gönderimi bitti mi
        JE DEVAM2
        MOV DI, DATASENDSAY
        MOV AL, MYDAT[DI]
        OUT 7CH, AL	                        ; sıradaki karakteri gönder
        INC DI	                                ; bir sonraki karakter indisi
        CMP DI, 5
        JNE DEVAM2
        MOV ALLSENT, 1	                        ; 5 karakterin gönderimi bitti
        XOR DI, DI	                        ; gönderme indisini sıfırla
DEVAM2:	MOV DATASENDSAY, DI
	IRET
NEWINT2	ENDP

START PROC FAR
        ;------------------------------------------------------------------------
        ; DATA ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------
        MOV AX, DATA
        MOV DS, AX
        ;------------------------------------------------------------------------
        ; 78H kesme vektör numarasının NEWINT’e bağlanması
        ;------------------------------------------------------------------------
        XOR AX, AX
        MOV ES, AX
        MOV AL, 78H
        MOV AH, 4
        MUL AH
        MOV BX, AX
        LEA AX, NEWINT
        MOV WORD PTR ES:[BX], AX
        MOV AX, CS
        MOV WORD PTR ES:[BX+2], AX 
        ;------------------------------------------------------------------------
        ; 79H kesme vektör numarasının NEWINT2’ye bağlanması
        ;------------------------------------------------------------------------
        MOV AL, 79H
        MOV AH, 4
        MUL AH
        MOV BX, AX
        LEA AX, NEWINT2
        MOV WORD PTR ES:[BX], AX
        MOV AX, CS
        MOV WORD PTR ES:[BX+2], AX 
        ;------------------------------------------------------------------------
        ; 8251’in koşullandırılması
        ;------------------------------------------------------------------------
        MOV AL, 01001101B
        OUT 7EH, AL
        MOV AL, 40H
        OUT 7EH, AL
        MOV AL, 01001101B
        OUT 7EH, AL
        MOV AL, 15H
        OUT 7EH, AL
        ;------------------------------------------------------------------------
        ; 8259’un koşullandırılması
        ;------------------------------------------------------------------------
        MOV AL, 13H
        OUT 60H, AL
        MOV AL, 78H	                                ; IR0 78H tipinde kesme sağlar
        OUT 62H, AL
        MOV AL, 03H
        OUT 62H, AL
        STI	                                        ; IF<-1, INTR kesmeleri aktif
        
ENDLESS:	
        JMP ENDLESS	                                ; sonsuz döngü
START 	ENDP
CODE	ENDS
        END START
