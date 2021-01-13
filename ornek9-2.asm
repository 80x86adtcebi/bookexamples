; -----------------------------------------------------------------------
; PROGRAM :Örnek 9-2.ASM
; 32 Bit olarak tanımlanmış olan ASAYISI ve BSAYISI isimli değişkenleri
; toplayarak elde edilen sonucu TOPLAM isimli 64 bit’lik değişkene
; yerleştiren EXE tipinde program
; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE 32 BITLIK POZITIF IKI SAYININ TOPLANMASI
STACKSG SEGMENT PARA STACK 'STACK'
        DW 10 DUP(?)
STACKSG ENDS
DATASG  SEGMENT PARA 'DATA'
ASAYISI DD      12345678H
BSAYISI DD      9ABCDEF0H
TOPLAM  DQ      0H
DATASG  ENDS
CODESG  SEGMENT PARA 'CODE'
        ASSUME CS:CODESG, DS:DATASG, SS:STACKSG
ANA     PROC FAR
;------------------------------------------------------------------------
; Dönüş için gerekli olan değerler yığında saklanıyor
;------------------------------------------------------------------------
        PUSH DS
        SUB  AX, AX
        PUSH AX
;------------------------------------------------------------------------
; DATASG ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
;------------------------------------------------------------------------
        MOV AX, DATASG
        MOV DS, AX
;------------------------------------------------------------------------
; Toplama işleminin gerçekleştirildiği kod bloğu
;------------------------------------------------------------------------
        LEA SI, ASAYISI	 ; Sayılarla bir seferde 64 bit toplama yapılma-dığı
        LEA DI, BSAYISI  ; için 16 bit’lik parçalar halinde okunacaktır
        LEA BX, TOPLAM   ; Bu nedenle sayılara SI/DI/BX Yazmaçları
                         ; yardımıyla erişilecektir.
        MOV AX, [SI]     ; AX yazmacına ASAYISI’nın düşük anlamlı word’ü
        MOV DX, [DI]     ; DX yazmacına BSAYISI’nın düşük anlamlı word’ü
        ADD AX, DX
        MOV [BX], AX     ; Elde edilen TOPLAM’ın düşük anlamlı word’üne
        MOV AX, [SI+2]   ; AX yazmacına ASAYISI’nın yüksek anlamlı word’ü
        MOV DX, [DI+2]   ; DX yazmacına BSAYISI’nın yüksek anlamlı word’ü
        ADC AX, DX       ; Eldeyi de işleme dâhil ediyoruz ve sonucu
        MOV [BX+2], AX   ; TOPLAM değişkenine yazıyoruz
        ADC WORD PTR [BX+4], 0
                         ; iki sayının 32 bit toplamında elde oluşmuş ise
                         ; bu değeri TOPLAM değişkeninin yüksek anlamlı
                         ; DWord alanına aktarabilmek için eldeli toplama
                         ; işlemi yapıyoruz.
        RET
ANA     ENDP
CODESG  ENDS
        END     ANA      ; programın başlangıç noktası
