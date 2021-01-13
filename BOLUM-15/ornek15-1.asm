	        TITLE Combine Turbo Pascal and Assembly
	        Public Move_Cursor	
Code	        SEGMENT BYTE PUBLIC
Move_Cursor	PROC FAR
                ASSUME CS: CODE
                PUSH BP
                MOV BS, SP
                MOV AX, [BP+8]
                MOV BX, [BP+6]
                MOV DH, AL
                MOV DL, BL	
                XOR BX, BX
                MOV AH, 2	
                INT 10H
                POP BP 
                RET 4
Move_Cursor	ENDP
Code	        ENDS
	        END
