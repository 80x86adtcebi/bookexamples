        ; -----------------------------------------------------------------------
        ; PROGRAM :Örnek 11 1.ASM
        ; Kullanılacak harici bir yordam ile dizi içindeki en büyük elemanı 
        ; bulma. kod kesimleri birleştiriliştir.
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE Code kesimleri birleşik - yardımcı yordam çağırma
        ; -----------------------------------------------------------------------
        ; BUYUK harici bir yordamdır. FAR olarak tanımlanmıştır.
        ; DIZI ise başka bir program tarafından kullanılacaktır.
        ; -----------------------------------------------------------------------
        EXTRN BUYUK:FAR
        PUBLIC DIZI
STSEG   SEGMENT  PARA STACK 'STACK'
        DW 12 DUP(0)
STSEG   ENDS

DTSEG   SEGMENT  PARA 'DATA'
        ;------------------------------------------------------------------------
        ; kullanılacak değişkenler tanımlanır.
        ;------------------------------------------------------------------------
DIZI    DW 12,1,5,64,21,65,127,512,0,1024
ELEMAN  DW 10
BYK_EL  DW ?
DTSEG   ENDS

CDSEG   SEGMENT  PARA PUBLIC 'CODE'             ; Kesim  birleştirilecek
        ASSUME CS:CDSEG,SS:STSEG,DS:DTSEG
BASLA   PROC FAR
        ;------------------------------------------------------------------------
        ; Dönüş için gerekli olan değerler yığında saklanıyor
        ;------------------------------------------------------------------------
        PUSH DS
        XOR AX,AX
        PUSH AX
        ;------------------------------------------------------------------------
        ; DTSEG ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------
        MOV AX, DTSEG
        MOV DS,AX
        ;------------------------------------------------------------------------
        ; işlem bloğu başlıyor
        ;------------------------------------------------------------------------
        MOV CX, ELEMAN                          ; Eleman sayısını CX ile BUYUK isimli yordama ak-tar
        CALL BUYUK                              ; BUYUK isimli yordamı çağırılır
        MOV BYK_EL,AX                           ; En büyük değer AX yazmacı üzerinden geri döner
        RET                                     ; DOS’a dön
BASLA   ENDP
CDSEG   ENDS
        END BASLA                               ; programın başlangıç noktası
