        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 11 2.ASM
        ; Örnek 11 2-1.ASM ile veri kesimleri birleştirilmiştir.
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE Veri kesimleri birleşik
        ; -----------------------------------------------------------------------
        ; ALTPRRG ve I_WORD Örnek 11 2-1.ASM içinde tanımlıdır.
        ; B_WORD ise Örnek 11 2-1.ASM içindeki ALTPRG isimli yordam erişecektir.
        ; -----------------------------------------------------------------------
        EXTRN ALTPRG:FAR, I_WORD:WORD
        PUBLIC B_WORD
STSEG   SEGMENT  PARA STACK 'STACK'
        DW 12 DUP(0)
STSEG   ENDS

        ; -----------------------------------------------------------------------
        ; Veri kesimi PUBLIC tanımlanmıştır. Ayrıca BYTE tanımı ile tüm alanın
        ; etkin kullanılması amaçlanmıştır.
        ; -----------------------------------------------------------------------
DTSEG   SEGMENT  BYTE PUBLIC 'DATA'
I_BYTE1 DB ?
I_BYTE2 DB ?
B_WORD  DW 0ABCDH
DTSEG   ENDS

CDSEG   SEGMENT  PARA 'CODE'
        ASSUME CS:CDSEG,SS:STSEG,DS:DTSEG
BASLA   PROC FAR
        ;------------------------------------------------------------------------
        ; Dönüş için gerekli olan değerler yığında saklanıyor
        ;------------------------------------------------------------------------
        PUSH DS
        XOR AX, AX
        PUSH AX
        ;------------------------------------------------------------------------
        ; DTSEG ismiyle tanımlı veri kesimine erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------
        MOV AX, DTSEG
        MOV DS, AX
        ;------------------------------------------------------------------------
        ; işlem bloğu başlıyor
        ;------------------------------------------------------------------------
        MOV AX, I_WORD                          ; Örnek 11 2-1.ASM içindeki değeri al
        MOV I_BYTE1, AL                         ; Parçalayarak kendi içinde tanımlı değişkenlere
        MOV I_BYTE2, AH                         ; yerleştir
        CALL ALTPRG                             ; harici yordamı çağır
        RET                                     ; DOS’a dön
BASLA   ENDP
CDSEG   ENDS
        END BASLA                               ; programın başlangıç noktası

