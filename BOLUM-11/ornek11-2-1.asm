        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 11 2-1.ASM
        ; Örnek 11 2.ASM ile veri kesimleri birleştiriliştir.
        ; ------------------------------------------------------------------------
        PAGE 60,80
        TITLE Veri kesimleri birleşik
        ; ------------------------------------------------------------------------
        ; ALTPRRG ve I_WORD Örnek 11 2.ASM tarafından kullanılacaktır.
        ; B_WORD, Örnek 11 2.ASM içinde tanımlıdır
        ; ------------------------------------------------------------------------
        PUBLIC ALTPRG, I_WORD
        EXTRN B_WORD: WORD
        ; ------------------------------------------------------------------------
        ; Veri kesimi PUBLIC tanımlanmıştır. Ayrıca BYTE tanımı ile tüm alanın
        ; etkin kullanılması amaçlanmıştır.
        ; ------------------------------------------------------------------------
DTSEG   SEGMENT  BYTE PUBLIC 'DATA'
B_BYTE1 DB ?
B_BYTE2 DB ?
I_WORD  DW 01234H
DTSEG   ENDS

CODESG  SEGMENT  PARA 'CODE'
        ASSUME CS:CODESG, DS:DTSEG
ALTPRG  PROC FAR
        ;------------------------------------------------------------------------
        ; işlem bloğu başlıyor
        ;------------------------------------------------------------------------
        MOV AX, B_WORD                  ; Örnek 11 2.ASM içindeki B_WORD değerini al
        MOV B_BYTE1, AL                 ; Kendi veri kesiminde tanımlı değişkenlere koy
        MOV B_BYTE2, AH
        RET                             ; çağıran noktaya geri dön
ALTPRG  ENDP
CODESG  ENDS
        END
