; ----------------------------------------------------------------------
; PROGRAM : Örnek 9 3.ASM
; 10 elemanlı bir dizideki tek ve çift sayıların adedini bulan program
; Bu programda TEST komutu kullanılmıştır.
; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE Tek Çift / TEST kullanarak
SSEG    SEGMENT PARA STACK 'STACK'
        DW 12 DUP(0)
SSEG    ENDS
DSEG    SEGMENT PARA 'DATA'
;------------------------------------------------------------------------
; Değişken tanımları
;------------------------------------------------------------------------
DIZI    DW 10,21,43,71,199,67,88,234,0,467
ELEMAN  DW 10
TEK_S   DW 0
CIFT_S  DW 0
DSEG    ENDS
CSEG    SEGMENT PARA 'CODE'
TC      PROC    FAR
        ASSUME CS:CSEG, SS:SSEG, DS:DSEG
;------------------------------------------------------------------------
; Dönüş için gerekli olan değerler yığında saklanıyor
;------------------------------------------------------------------------
        PUSH DS
        XOR AX, AX
        PUSH AX
;------------------------------------------------------------------------
; DSEG ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
;------------------------------------------------------------------------
        MOV AX, DSEG
        MOV DS, AX
;------------------------------------------------------------------------
; Kontrol işleminin gerçekleştirildiği kod bloğu
;------------------------------------------------------------------------
        MOV CX, ELEMAN   ; Çevrim değişkenine eleman sayısı konur
        LEA SI, DIZI     ; DIZI’nin başlangıç adresi SI yazmacında
CEVRIM: TEST WORD PTR [SI], 0001H
                         ; TEST komutu işlenenleri bozmaz
        JZ CIFT          ; Sonuç sıfır ise sayı çifttir ilgili satıra git
TEK:    INC TEK_S        ; sayı tekdir, tek sayı adedini arttır
CIFT:   ADD SI, 2        ; bir sonraki elemana erişmek için SI arttırılır
                         ; DIZI word tanımlı olduğu için bir sonraki dizi
                         ; elemanı 2 byte ileride olacaktır. 
        LOOP CEVRIM      ; işlemi dizinin son elemanına gelinceye kadar
                         ; tekrarlamayı sağlayan çevrim komutu
        MOV AX, ELEMAN   ; çevrim sonucunda sadece tek olan kaç tane ele-man
                         ; olduğunu biliyoruz. ELEMAN sayısından çıkartır
        SUB AX, TEK_S    ; böylece kalanların çift olduğunu bulabiliriz
        MOV CIFT_S, AX   ; bulduğumuz değeri tanımlı değişkene yaz
        RET
TC      ENDP
CSEG    ENDS
        END TC           ; programın başlangıç noktası
