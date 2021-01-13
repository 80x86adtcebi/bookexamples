        ; -----------------------------------------------------------------------
        ; PROGRAM :Örnek 10 4.ASM
        ; COM yapısındaki programda macro kullanımı
        ; Program ekranı temizledikten sonra bir mesaj yazacaktır
        ; Macro’lar harici bir dosyadan alınarak kullanılacaktır.
        ; ------------------------------------------------------------------------
        PAGE 60,80
        TITLE Ekrana mesaj yazma
        ;------------------------------------------------------------------------
        ; Kullanılacak Macro’lar ORNEK.MAC isimli dosyadan alınmaktadır
        ;------------------------------------------------------------------------
        INCLUDE Ornek.mac
CDSEG   SEGMENT  PARA 'CODE'
        ORG 100H        ; COM program 100H den başlar
        ASSUME CS:CDSEG, SS:CDSEG, DS:CDSEG
        ;------------------------------------------------------------------------
        ; Macro’ları kullanarak işlemi gerçekleştiren yordam
        ;------------------------------------------------------------------------
BASLA   PROC NEAR
        SIL                             ; SIL isimli macro’yu kullan
        YAZDIR MESAJ                    ; YAZDIR makrosunu MESAJ parametresi ile kullan
        RET
BASLA   ENDP
        ;------------------------------------------------------------------------
        ; Mesaj tanımı 
        ;------------------------------------------------------------------------
MESAJ   DB 'Macro’lar Ornek.mac Dosyasından alındı','$'
CDSEG   ENDS
        END BASLA               ; programın başlangıç noktası
