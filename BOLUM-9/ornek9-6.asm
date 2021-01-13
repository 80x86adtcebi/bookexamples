        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 9 6.ASM
        ; INT 21H - fonksiyon 9H ile ekrana mesaj yazmayı sağlayan
        ; COM yapısında bir program
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE Ekrana mesaj yazma
CDSEG   SEGMENT  PARA 'CODE'
        ORG 100H                        ; COM program 100H den başlar
        ASSUME CS:CDSEG, SS:CDSEG, DS:CDSEG
        ;------------------------------------------------------------------------
        ; işleminin gerçekleştirildiği yordam
        ;------------------------------------------------------------------------
YAZDIR  PROC NEAR
        LEA DX, MESAJ                   ; DX yazdırılacak mesajın başını göstermeli
        MOV AH, 09H                     ; AH, fonksiyon numarasını tutar
        INT 21H                         ; 21H numaralı kesmeyi çağır
        RET                             ; dön
YAZDIR  ENDP
        ;------------------------------------------------------------------------
        ; Değişkenleri tanımladığımız alan
        ;------------------------------------------------------------------------
MESAJ   DB 'COM yapisinda bir program calisti','$'
CDSEG   ENDS
        END YAZDIR                      ; programın başlangıç noktası
