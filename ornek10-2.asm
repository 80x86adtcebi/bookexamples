        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 10 2.ASM
        ; Toplama isimli yardımcı yordamın çağırılması
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE yardımcı yordam çağırma
STSEG   SEGMENT PARA STACK 'STACK'
        DW 12 DUP(0)
STSEG   ENDS

DTSEG   SEGMENT PARA 'DATA'
        ;------------------------------------------------------------------------
        ; Kullanılacak değişkenler tanımlanır.
        ;------------------------------------------------------------------------
SAYI1   DB 12H
SAYI2   DB 78H
SONUC   DW 0H
DTSEG   ENDS

CDSEG   SEGMENT PARA 'CODE'
        ASSUME CS:CDSEG, SS:STSEG, DS:DTSEG
BASLA   PROC FAR
        ;------------------------------------------------------------------------
        ; Dönüş için gerekli olan değerler yığında saklanıyor
        ;------------------------------------------------------------------------
        PUSH DS
        XOR AX, AX
        PUSH AX
        ;------------------------------------------------------------------------
        ; DATASG ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------
        MOV AX, DTSEG
        MOV DS, AX
        ;------------------------------------------------------------------------
        ; işlem bloğu başlıyor 
        ;------------------------------------------------------------------------
        MOV BH, SAYI1                   ; Değerler BH ve BL Yazmaçları üzerinden
        MOV BL, SAYI2                   ; çağırılacak olan yardımcı yordama aktarılır
        CALL TOPLAMA                    ; yordam çağırılır
        MOV SONUC, AX                   ; toplama işleminin sonucunu AX yazmacında 
        RET
BASLA   ENDP
CDSEG   ENDS
        END BASLA                       ; programın başlangıç noktası
