        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 9 1.ASM
        ; 16 bit tanımlı ASAYISI ve BSAYISI isimli değişkenleri toplayarak elde
        ; edilen sonucu TOPLAM isimli 32 bit’lik değişkene yerleştiren EXE prog-ram
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE 16 BITLIK POZITIF IKI SAYININ TOPLANMASI
STACKSG SEGMENT PARA STACK 'STACK'
        DW 10 DUP(?)
STACKSG ENDS

DATASG  SEGMENT PARA 'DATA'
ASAYISI DW  1234H		          ; Giriş/Çıkış değerlerinin veri alanı üzerinde ilk
BSAYISI DW  0ABCDH		          ; değer ataması yapılmaktadır.
TOPLAM  DD  0H			          ; TOPLAM değişkeninin ilk değeri sıfır yapılır
DATASG  ENDS

CODESG  SEGMENT PARA 'CODE'
        ASSUME CS:CODESG, DS:DATASG, SS:STACKSG
ANA     PROC FAR
        ;------------------------------------------------------------------------
        ; Dönüş için gerekli olan değerler yığında saklanıyor
        ;------------------------------------------------------------------------
        PUSH DS
        SUB  AX, AX
        PUSH AX
        ;------------------------------------------------------------------------
        ; DATASG ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------
        MOV AX, DATASG
        MOV DS, AX
        ;------------------------------------------------------------------------
        ; Toplama işleminin gerçekleştirildiği kod bloğu
        ;------------------------------------------------------------------------
        LEA SI, TOPLAM        ; SI TOPLAM değişkenin başladığı adresi belirler
        MOV AX, ASAYISI       ; AX yazmacı ASAYISI’nın değerini tutar
        MOV BX, BSAYISI       ; BX yazmacı BSAYISI’nın değerini tutar
        ADD AX, BX            ; toplamın sonucu AX yazmacında bulunur
        MOV [SI], AX          ; sonuç TOPLAM’ın en az anlamlı word’ünde
                              ; oluşan eldeyi yüksek anlamlı word’e yaz
        ADC WORD PTR [SI+2], 0
        RET
ANA     ENDP
CODESG  ENDS
        END ANA               ; Programın başlangıç noktası 
