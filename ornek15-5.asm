section .data
section .text
global Topla
Topla:
	PUSH EBP
	PUSH EDI
	PUSH ECX
	MOV EBP, ESP
	MOV  EDI, [EBP+16] 	; Dizinin adresine erisilir.
	MOV  ECX, [EBP+20] 	; Dizinin boyutu olan n degerine erisilir.
	XOR EAX, EAX
L1:	ADD EAX, [EDI]
	ADD EDI, 4			; Dizi integer (4 byte) tanimli oldugu icin bir sonraki
	LOOP L1			; elemana erisim icin 4 eklenir.
	POP ECX
	POP EDI
	POP EBP
	RET
