        ; -----------------------------------------------------------------------
        ; PROGRAM : Örnek 23 1.ASM
        ; 8237 kullanarak bellek – bellek DMA veri transferi yapan
        ; assembly program 
        ; -----------------------------------------------------------------------
        PAGE 60,80
        TITLE bellek - bellek DMA veri transferi

CLEAR_FF EQU 98H	;F/L CLEAR VALUE	1001 1000B
CH0_A	EQU 80H	        ;CHANNEL 0 ADDRESS	1000 0000B
CH1_A	EQU 84H	        ;CHANNEL 1 ADDRESS	1000 0100B
CH1_C	EQU 86H	        ;CHANNEL 1 COUNT	1000 0110B
MODE	EQU 96H	        ;MODE			1001 0110B
CR	EQU 90H	        ;COMMAND REGISTER	1001 0000B
MASKS	EQU 9EH	        ;MASKS			1001 1110B
REQ	EQU 92H	        ;REQUEST REGISTER	1001 0010B
STATUS	EQU 90H	        ;STATUS REGISTER	1001 0000B

STAK	SEGMENT PARA STACK 'STACK'
	DW 20 DUP(?)
STAK	ENDS 

DATA	SEGMENT PARA 'DATA'
DMA_SEG	DW 1000H
DMA_SRC	DW 0000H
DMA_DEST DW 4000H
DMA_CNT	DW 4000H
DATA	ENDS

CODE	SEGMENT PARA 'CODE'
	ASSUME CS:CODE, SS:STAK
START 	PROC FAR
        ;------------------------------------------------------------------------
        ; Dönüş için gerekli olan değerler yığında saklanıyor
        ;------------------------------------------------------------------------
        PUSH DS
        XOR AX, AX
        PUSH AX
        ;------------------------------------------------------------------------
        ; DATA ismiyle tanımlı kesim alanına erişebilmek için gerekli tanımlar
        ;------------------------------------------------------------------------
        MOV AX, DATA
        MOV DS, AX
        MOV ES, DMA_SEG 	                ; DMA kaynak segment değeri ES’de
        MOV SI, DMA_SRC	                        ; DMA kaynak işaretçi değeri SI’da
        MOV DI, DMA_DEST	                ; DMA hedef işaretçi değeri DI’da
        MOV CL, 4
        MOV AL, 0
        OUT CLEAR_FF, AL	                ; İlk/son iki duraklıyı sıfırla
        MOV AX, ES		                ; DMA kaynak segment değeri
        SHL AX, CL		                ; AX <-- AX*16
        ADD AX, SI		                ; AX <-- ES*16+SI, kaynak adresi
        OUT CH0_A, AL		                ; Kanal0 adres LSB
        MOV AL, AH
        OUT CH0_A, AL		                ; Kanal0 adres MSB
        MOV AX, ES		                ; DMA hedef segment değeri
        SHL AX, CL		                ; AX <-- AX*16
        ADD AX, DI		                ; AX <-- ES*16+DI, hedef adresi
        OUT CH1_A, AL		                ; Kanal1 adres LSB
        MOV AL, AH
        OUT CH1_A, AL		                ; Kanal1 adres MSB
        MOV AX, DMA_CNT	                        ; Kelime adedi
        DEC AX			                ; Kelime adedini bir azalt
        OUT CH1_C, AL		                ; Kanal1 kelime sayaç LSB
        MOV AL, AH
        OUT CH1_C, AL		                ; Kanal1 kelime sayaç MSB
        ;------------------------------------------------------------------------
        ; Kip yazmacı : Kanal0, blok kip, adres artımlı, okuma yönlü
        ;------------------------------------------------------------------------
        MOV AL, 88H
        OUT MODE, AL
        MOV AL,1			        ; Kontrol yazmacı : bellek-bellek transfer
        OUT CR, AL
        MOV AL, 0EH		                ; Maske yazmacı : kanal0 maskesini aç
        OUT MASKS, AL
        ;------------------------------------------------------------------------
        ; İstek yazmacı : kanal0 isteği set, DMA transferi başlat
        ;------------------------------------------------------------------------
        MOV AL, 4 
        OUT REQ, AL
        RETF
START 	ENDP
CODE	ENDS
        END START
