        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 10 1.ASM
        ; Kesim  içindeki yordamı çağıran EXE tipinde program
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE Sayinin kuvvetini hesaplar
STACKSG SEGMENT PARA STACK 'STACK'
        DW 10 DUP(?)
STACKSG ENDS

DATASG  SEGMENT PARA 'DATA'
        ;------------------------------------------------------------------------
        ; Kullanacağımız değişkenler 
        ;------------------------------------------------------------------------
SAYI    DW 2
UST     DW 10
SONUC   DW 0
DATASG  ENDS

CODESG  SEGMENT PARA 'CODE'
        ASSUME CS:CODESG, DS:DATASG, SS:STACKSG
ANA     PROC FAR
        ;------------------------------------------------------------------------
        ; Dönüş için gerekli olan değerler yığında saklanıyor
        ;------------------------------------------------------------------------
        PUSH DS
        SUB AX, AX
        PUSH AX
        ;--------------------------------------------------------------------------
        ; DATASG ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------
        MOV AX, DATASG
        MOV DS, AX
        ;------------------------------------------------------------------------
        ; işleminin gerçekleştirildiği kod bloğu
        ;------------------------------------------------------------------------
        MOV CX, UST	                ; UST ve SAYI parametreleri yazmaçlarda
        MOV BX, SAYI
        CALL USTAL                      ; Yordam çağırma
        MOV SONUC, AX                   ; İşlemin sonucu AX yazmacı üzerinden aktarılıyor
        RET                             ; dön
ANA     ENDP
        ;------------------------------------------------------------------------
        ; üst alma işlemini gerçekleştiren yordam 
        ;------------------------------------------------------------------------
USTAL   PROC NEAR
        MOV AX, 1
L1:     MUL BX                          ; çarpma işlemi AX üzerinden yapılıyor
        LOOP L1
        RET                             ; çağırıldığın noktaya dön
USTAL   ENDP
CODESG  ENDS
        END ANA                         ; programın başlangıç noktası 
