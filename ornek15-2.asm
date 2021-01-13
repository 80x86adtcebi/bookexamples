	TITLE Pascal and Assembly programların birlikte kullanılması 
	PUBLIC CheckRange
	EXTRN RangeError: NEAR
DATA	SEGMENT WORD PUBLIC 
	EXTRN Buffer: WORD, Count: WORD
DATA	ENDS
CODE	SEGMENT BYTE PUBLIC
	ASSUME CS: CODE, DS: Buffer
CheckRange	PROC NEAR
	PUSH BP
	MOV BP, SP
	MOV AX, [BP+6]
	MOV DX, [BP+4]
	XOR BX, BX
	MOV CX, Count
	JCXZ SD4
SD1:	CMP Buffer[BX], AX
	JL SD2
	CMP Buffer[BX], DX
	JLE SD3
SD2:	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH Buffer[BX]
	CALL RangeError
	POP DX
	POP CX
	POP BX
	POP AX
SD3:	ADD BX, 2
	LOOP SD1
SD4:	POP BP	
	RET 4
CheckRange 	ENDP
CODE	ENDS
	END
