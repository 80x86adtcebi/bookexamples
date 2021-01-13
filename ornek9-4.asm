        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 9 4.ASM
        ; 16 Bit’lik bir sayının on altılık tabandaki ifadesindeki hanelerinin
        ; tersten yazılmasını sağlayan EXE tipinde program
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE HEX Digitleri tersyüz etme
SSEG    SEGMENT PARA STACK 'STACK'
        DW 12 DUP(0)
SSEG    ENDS

DSEG    SEGMENT PARA 'DATA'
        ;------------------------------------------------------------------------
        ; Dizi elemanları ve eleman sayısı tanımlanmıştır.
        ;------------------------------------------------------------------------
ELEMAN  DW 10
DIZI    DW 1234H,2345H,3456H,4567H,5678H,6789H,789AH,89ABH,9ABCH,0ABCDH
DSEG    ENDS

CSEG    SEGMENT PARA 'CODE'
ENDIAN  PROC   FAR
        ASSUME CS:CSEG,SS:SSEG,DS:DSEG
        ;------------------------------------------------------------------------
        ; Dönüş için gerekli olan değerler yığında saklanıyor
        ;------------------------------------------------------------------------
        PUSH DS
        SUB AX, AX
        PUSH AX
        ;------------------------------------------------------------------------
        ; DSEG ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar 
        ;------------------------------------------------------------------------
        MOV AX, DSEG
        MOV DS, AX
        ;------------------------------------------------------------------------
        ; Kontrol işleminin gerçekleştirildiği kod bloğu
        ;------------------------------------------------------------------------
       MOV CX, 10                       ; Eleman sayısı CX’e yerleştirildi
       LEA SI, DIZI                     ; Elemanlara erişmek için SI indis olacak
CEVRIM:MOV AX, [SI]                     ; Sayı üzerindeki işlemi hızlı yapabilmek için
                                        ; AX yazmacı üzerinden yapıyoruz
       XCHG AL, AH                      ; Düşük ve yüksek anlamlı byte’ları değiştir
       PUSH CX                          ; Tekrar sayısını belirleyen CX yazmaç değerini 
                                        ; yığında sakla
       MOV CL, 4                        ; döndürme işleminin tekrar sayısı CL de
       ROR AL, CL                       ; AL ve AH değerlerini kendi içlerinde CL ile 
       ROR AH, CL                       ; belirlenen değer kadar (4) sağa döndür
       MOV [SI], AX                     ; AX üzerinde oluşan yeni değeri yerine koy
       ADD  SI,2                        ; SI’yı sonraki word’ü gösterecek biçimde ayarla
       POP CX                           ; Yığında saklanan değeri alarak işleme devam et
       LOOP CEVRIM                      ; işlemi CX de belirlenen sayı kadar tekrarla
       RET                              ; dön
ENDIAN ENDP
CSEG   ENDS
       END ENDIAN                       ; programın başlangıç noktası
