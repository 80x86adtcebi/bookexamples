        ; ----------------------------------------------------------------------
        ; PROGRAM : Örnek 9 3.ASM
        ; 10 elemanlı bir dizideki tek ve çift sayıların adedini bulan program
        ; Bu programda SHIFT metodu kullanılır
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE Tek Çift / SHIFT kullanarak
SSEG    SEGMENT  PARA STACK 'STACK'
        DW 12 DUP(0)
SSEG    ENDS

DSEG    SEGMENT  PARA 'DATA'
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
        MOV CX, ELEMAN                  ; Çevrim değişkenine eleman sayısı konur
        MOV SI, 0                       ; DIZI, sıfırıncı indisli elemandan başlar
CEVRIM: MOV AX, DIZI[SI]                ; Elemanlar sırası ile AX yazmacına aktarılır
        SHR AX, 1                       ; Sağa doğru öteleme ile en az anlamlı bit CF’ye
        ADC TEK_S, 0                    ; CF, 1 ise tektir ve tek sayı adedine eklenir
        ADD SI, 2                       ; DIZI word tanımlı olduğu için bir sonraki dizi
                                        ; elemanı 2 byte ileride olacak, 
        LOOP CEVRIM                     ; işlemi dizinin son elemanına gelinceye kadar
                                        ; tekrarlamayı sağlayan çevrim komutu
        MOV AX, ELEMAN                  ; sonuç olarak tek sayı olan eleman sayısını 
                                        ; biliyoruz. Bunu ELEMAN sayısından çıkartalım
        SUB AX, TEK_S                   ; böylece kalanların çift olduğunu bulduk
        MOV CIFT_S, AX                  ; bulunan değeri çift sayı adedi olarak atanır
        RET
TC      ENDP
CSEG    ENDS
        END TC                          ; programın başlangıç noktası
