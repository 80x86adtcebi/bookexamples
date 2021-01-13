        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 10 2-1.ASM
        ; Toplama isimli yardımcı yordamın içinde bulunduğu program
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE yardımcı procedure çağırma
        PUBLIC  TOPLAMA
CODES   SEGMENT PARA 'CODE'
        ASSUME CS:CODES
TOPLAMA PROC FAR
        ;--------------------------------------------------------------------------
        ; işlem bloğu başlıyor
        ;------------------------------------------------------------------------
        XOR AX, AX                      ; AX yazmacını sıfırla
        ADD AL, BL                      ; AL üzerinde toplamaya başla
        ADD AL, BH
        ADC AH, 0                       ; CF oluşması durumunda bunu AH’ya aktar
        RET                             ; çağırıldığın yere don
TOPLAMA ENDP
CODES   ENDS
        END
                
