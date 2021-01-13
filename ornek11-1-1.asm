        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 11 1-1.ASM
        ; Örnek 11 1.ASM isimli program tarafından çağırılan yardımcı yordam
        ; Kod kesimleri birleştirilmiştir.
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE Code kesimleri birleşik - yardımcı yordam çağırma
        ; -----------------------------------------------------------------------
        ; BUYUK isimli yordam başka programlar tarafından da kullanılabilir.
        ; DIZI ise başka bir kesim de word tanımlı harici veridir.
        ; -----------------------------------------------------------------------
        EXTRN DIZI: WORD
        PUBLIC BUYUK
CDSEG   SEGMENT PARA PUBLIC 'CODE'              ; Kesim  birleştirilecek
        ASSUME CS: CDSEG
BUYUK   PROC FAR
        ;------------------------------------------------------------------------
        ; işlem bloğu başlıyor
        ; CX üzerinden dizinin eleman sayısı bu yordama aktarılıyor.
        ;------------------------------------------------------------------------
        XOR SI, SI                              ; SI dizi indisi olarak kullanılacak
        MOV AX, DIZI[SI]                        ; ilk elemanı en büyük kabul et
        SUB CX, 1                               ; geri kalan elemanlar üzerinden işlem yapılacak
L1:     ADD SI, 2                               ; DW tanımlı bir sonraki elaman 2 byte ileride
        CMP AX, DIZI[SI]
        JA DEVAM
        MOV AX, DIZI[SI]                        ; dizinin elemanı daha büyük
DEVAM:  LOOP L1                                 ; cevrimi tekrarla
        RET                                     ; çağıran noktaya geri don
BUYUK   ENDP
CDSEG   ENDS
        END
