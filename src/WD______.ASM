OV	A,M	
	ANA	C	
	MOV	M,A
	LDAX	D	
	ANI	0F0H	
	ORA	M	
	MOV	M,A	
	INR	L	
	INX	D	
	DCR	B	
	JNZ	SCA	
	MVI	B,16	
	MOV	A,H	
	ADI	20H	
	MOV	H,A	
SCC:
	DCX	D	
	DCR	L	
	MOV	A,M	
	ANA	C	
	MOV	M,A	
	LDAX	D	
	ANA	C	
	RLC		
	RLC		
	RLC		
	RLC		
	ORA	M	
	MOV	M,A	
	DCR	B	
	JNZ	SCC	
	JMP	NEXT	
SHET:
	MVI	C,0F0H	
SCA0:
	MOV	A,M	
	ANA	C	
	MOV	M,A	
	LDAX	D	
	ANA	C	
	RRC		
	RRC		
	RRC		
	RRC		
	ORA	M	
	MOV	M,A	
	INR	L	
	INX	D	
	DCR	B	
	JNZ	SCA0	
	MVI	B,16	
	MOV	A,H	
	ADI	20H	
	MOV	H,A	
SCC0:
	DCX	D	
	DCR	L	
	MOV	A,M	
	ANA	C	
	MOV	M,A	
	LDAX	D	
	ANI	0FH	
	ORA	M	
	MOV	M,A	
	DCR	B	
	JNZ	SCC0	
MAIN_EXIT:
NEXT:
	POP	PSW	
	POP	H	
	POP	D	
	POP	B	
	RET
		
;+--------[ вспомогательные процедуры ]---------+

;___________ MOVE PROCEDURE ___________
LIIR:
	PUSH	B
	PUSH	D	
	PUSH	H	
LI1:
	MOV	A,M	
	STAX	D	
	INX	D	
	INX	H	
	DCR	B	
	JNZ	LI1	
	POP	H	
	POP	D	
	POP	B	
	RET		

LDIR:
	PUSH	B	
	PUSH	D	
	PUSH	H	
LD1:
	MOV	A,M	
	STAX	D	
	DCX	H	
	DCX	D	
	DCR	B	
	JNZ	LD1	
	POP	H	
	POP	D	
	POP	B	
	RET		

;=============== ADDDR EMUL =====================
ADDREM:
	PUSH	B
	LXI	B,W_EMUL_TXT	;указатель на область эмуляции
	MVI	H,0	
	MOV	L,E	
	DAD	H	
	DAD	H	
	DAD	H	
	DAD	H	
	DAD	H	
	DAD	H	
	DAD	B	
	MVI	B,0	
	MOV	C,D	
	DAD	B	
	POP	B	
	RET		
;______________ ADDDR SCREEN _______________
ADDRSC:
	PUSH	PSW	
	MOV	A,E	
	ANI	0FH	
	RLC		
	RLC		
	RLC		
	RLC		
	MOV	L,A	
	MOV	A,D	
	RAR		
	ORI	0A0H	
	MOV	H,A	
	POP	PSW	
	RET		
	END

