        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 10 3.ASM
        ; COM yapısındaki programda macro kullanımı
        ; Program ekranı temizledikten sonra bir mesaj yazacaktır
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE Ekrana mesaj yazma
CDSEG   SEGMENT  PARA 'CODE'
        ORG 100H        ; COM program 100H den başlar
        ASSUME CS:CDSEG, SS:CDSEG, DS:CDSEG
        ;------------------------------------------------------------------------
        ; INT 10H yardımıyla ekranı silmeyi sağlayan macro kodu
        ;------------------------------------------------------------------------
SIL     MACRO
        MOV CX, 0000H                   ; Ekranın sol üst köşesi satır/sütun adresi
        MOV DX, 184FH                   ; Ekranın sağ alt köşesi satır/sütun adresi
        MOV BH, 07H                     ; öznitelik değeri (attribute byte)
        MOV AX, 0600H                   ; AH = 06H pencereyi yukarı kaydırma
        INT 10H                         ; 10H numaralı kesmeyi çağır
        ENDM
        ;------------------------------------------------------------------------
        ; INT 21H yardımıyla ekrana mesaj yazdıran macro
        ;------------------------------------------------------------------------
YAZDIR  MACRO text
        LEA DX, text                    ; DX yazdırılacak mesajın başını göstermeli
        MOV AH, 09H                     ; AH = 09H Ekrana mesaj yazma 
        INT 21H                         ; 21H numaralı kesmeyi çağır
        ENDM
        ;------------------------------------------------------------------------
        ; Macro’ları kullanarak işlemi gerçekleştiren yordam
        ;------------------------------------------------------------------------
BASLA   PROC NEAR
        SIL                             ; SIL isimli macro’yu kullan
        YAZDIR MESAJ                    ; YAZDIR makrosunu MESAJ parametresi ile kullan.
        RET     
BASLA   ENDP
        ;------------------------------------------------------------------------
        ; Mesajın tanımlandığı alan
        ;------------------------------------------------------------------------
MESAJ   DB 'Ekran silindi ve bu mesaj yazildi...','$'
CDSEG   ENDS
        END BASLA                       ; programın başlangıç noktası
