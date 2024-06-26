;;	/* 31.03.1993 PPA Systems Utilites */
;========= �������� ������� ��������� ==========
	Public	W_PUTCXY ;����� ������� �����. � 'DE'
	Public	ACTIV	;�������� ���� (DE),(HL),�-����
	Public	BORT	;���������� �����
	Public	SCROL3	;--//-- ������ (�� 2 �������)
	Public	SCROL4	;--//-- ����� --//--
	Public	PUTCXY	
	Public	ABS_DE
	Public	LIIR
	Public	LDIR
	Public	HL_DE_WIND
	Public	HL_SUB_DE
	Public	ADDRSC	

;______________ ������� ������ ________________
	Public	CURSOR
	Public	WIND1
	Public	WIND2
	Public	NUM
	Public	BUF_SEK
	Public	FLAGW
;;
;;      �������� �������������� �������� ������� ���������
;; ������.  ���������  ���������  ��������  ��  ����������
;; ( Intel 8080 )  �  �������������  ���  ��������� ������
;; ����������    ��������   (  �������  ���������  ������,
;; ���������������� ������� ,� �.�.)
;;
;;  ��������� ����������� : 31.03.1993  �.���������
;;
;;	+----[ 13.10.1992 ]-------------[ ��������� ]---+
;;	!  �����:	������� �.�.			!
;;	!	"������� �������� ����������"		!
;;	! ������������ ����� ���������� ���������� �	!
;;	! ��� ���������� "����" ����������� ���������	!
;;	! ��������:	����� ���������� �������	!
;;	!		����������� ����������� ����	!
;;	!		�������� ���� (�������� ������)	!
;;	!		������ ������� � ���. �������	!
;;	! ����������:	�������	(�������������)		!
;;	!		�������� (�����`����)		!
;;	!________ ������������� ��� ����������__________!
;;	!	DE  ->  �����. ������ ������� ���� ����.!
;;	!		���. ������� ���� ���� (�������)!
;;	!		D -> �������������� ����������	!
;;	!		E -> ������������ --//-- (Y)	!
;;	!	HL  ->	�����.����. �����. ���� ���� 	!
;;	!	BC  ->	��������� �� ������ ��������	!
;;	!	A   ->	���� ����			!
;;	!	+---+---+---+---+---+---+---+---+	!
;;	!	! 7 ! 6 ! 5 ! 4 ! 3 ! 2 ! 1 ! 0 !	!
;;	!	+---+---+---+---+---+---+---+---+	!
;;	!	�������� ����� �����:			!
;;	!		(D0-D1):  ��� "����"		!
;;	!			00 -> �����������	!
;;	!			01-11 -> 1-3 ����	!
;;	!		(D2-D3):  ��� "�����"		!
;;	!			00 -> �����������	!
;;	!			01 -> ���������		!
;;	!			10 -> �������		!
;;	!			11 -> ���� ���������	!
;;	!		   (D4):  ������� ����		!
;;	!			0  -> ��� �������������	!
;;	!			1  -> � ��������������	!
;;	+------[ OBJ: 06D0H ]----------[ End remark ]---+


;;============== ������� ������ WINDOW.DRIWE =============
CURSOR:		DW	000AH
;;
;;     ������ ������������� ��������� ���������� ������� �
;; ������ �������� ���� � ��� �������� ����� ���� ��� ���-
;; �������� � ������ � ����������� �������������� ��� ���-
;; ����� ����.
;;

WIND1:		DW	0	;; (DE) ���������� ����
WIND2:		DW	3F0FH	;; (HL) ---//----//---
;;
;;	������ ������ ������ ���������� ���������� ������-
;; �������� ����, ������� ����� ����������� �������������-
;; ��� ��� ��������� �������� � �������� ����� ����
;;

NUM:		DB	0
;;
;;	�������� ���������� �������� �� ������ ������ ����.
;;

BUF_SEK:	DW	BUF_BEGIN	;
;;
;;	������������ ������ ���������� �������� ����������
;; ������ ����.
;;

FLAGW:		DB	0
;;
;;	������� ���� �������� ���� � ������� ��� ����� ��-
;; ���� � ���� �������� ��������� ����.
;;
BUF1:		DW	0000h
;;
;;	��������������� ������� ������ ������ ������������
;; ����������� �������� � �������� ����.
;;

DOUBLE:         DB	098h,099h,08Bh,08Ch,08Ah,09Dh
INTEG:		DB	090h,0AAh,08Fh,0A9h,083h,094h
;;
;;     ����� ������ ����������� ��� ������ ��������� �����
;; ����� ����������� ����.
;;

;+-------------[ OPEN WINDOW ]----------+
;*	����:	DE -> �.� ����		*
;*		HL -> �.� ����		*
;*		A  -> ���� ����		*
;*	�����:	A  ->   = 0  - �������	*
;*			<> 0 - ������	*
;+--------------------------------------+
ACTIV:
	PUSH	B	; �������� ��� ��������
	PUSH	D	; ����������
	PUSH	H	;
	PUSH	PSW	;
	LDA	FLAGW	; ��������� ����������
	STA	BUF1	; ���� ���� � ��������
	POP	PSW	; �� ��������� ������
	STA	FLAGW	; ������������� ����� ����
	MOV	A,H	; ���������� �������� ��
	SUB	D	; ����������� �������
	JC	WSQ1	; ������
	MOV	B,A	;
	MOV	A,L	;
	SUB	E	;
	JC	WSQ1	;
	MOV	C,A	;
	LDA	FLAGW	;
	ANI	0FH	;
	JNZ	OP1	;
	MOV	A,B	;
	CPI	3FH	;
	JC	OP2	;
	MVI	B,3FH	;
	MVI	D,0	;
	MVI	H,3FH	;
OP2:
	MOV	A,C	;
	CPI	0FH	;
	JC	SLED1	;
	MVI	C,0FH	;
	MVI	E,0	;
	MVI	L,0FH	;
SLED1:
	CALL	WSAVE	;������ ����
	CALL	CLS	;
	JMP	DALHE	;
OP1:
	CPI	04H	;
	JC	OP3	;������� ���� ��� �����
	ANI	03H	;
	JNZ	OP3	;
	MOV	A,B	;
	CPI	3DH	;
	JC	OP4	;
	MVI	B,3DH	;
	MVI	D,01H	;
	MVI	H,3EH	;
OP4:
	MOV	A,C	;
	CPI	0DH	;
	JC	SLED2	;
	MVI	C,0DH	;
	MVI	E,01H	;
	MVI	L,0EH	;
SLED2:
	DCR	D	;
	DCR	E	;
	INR	H	;
	INR	L	;
	CALL	WSAVE	;
	CALL	CLS	;
	CALL	RAMKA	;
	DCR	H	;
	DCR	L	;
	INR	D	;
	INR	E	;
	JMP	DALHE	;
OP3:
	MOV	A,B	;
	CPI	3CH	;
	JC	OP5	;
	MVI	B,3CH	;
	MVI	D,01H	;
	MVI	H,3DH	;
OP5:
	MOV	A,C	;
	CPI	0CH	;
	JC	SLED3	;
	MVI	C,0CH	;
	MVI	E,02H	;
	MVI	L,0EH	;
SLED3:
	DCR	D	;
	DCR	E	;
	DCR	E	;
	INR	H	;
	INR	H	;
	INR	L	;
	CALL	WSAVE	;
	INR	E	;
	DCR	H	;
	CALL	CLS	;
	CALL	RAMKA	;
	CALL	TEN	;
	INR	E	;
	INR	D	;
	DCR	H	;
	DCR	L	;
DALHE:
	SHLD	WIND2	;
	XCHG		;
	SHLD	WIND1	;
	LXI	H,0	;
	SHLD	CURSOR	;
	XRA	A	;
WSQ1:
	POP	H	;
	POP	D	;
	POP	B	;
	EI		;
	RET		;
;+--------[ ���� ]------+
;* ����:  DE,HL -WINDOW *
;+----------------------+
TEN:
	PUSH	H	;
	PUSH	D	;
	LDA	FLAGW	;
	ANI	3	;
	ADD	A	;
	ADI	7	;
	MOV	B,A	;
	INR	H	;
	DCR	L	;
	DCR	E	;
TE1:
	MOV	A,B	;
	INR	D	;
	CALL	PUTCXY	;
	MOV	A,D	;
	CMP	H	;
	JNZ	TE1	;
	INR	B	;
TE3:	MOV	A,B	;
	INR	E	;
	CALL	PUTCXY	;
	MOV	A,E	;
	CMP	L	;
	JNZ	TE3	;
	POP	D	;
	POP	H	;
WSAVE:
	RET		;
;
;+--------------[ DRAW BOARD ]----------+
;*	����:	DE,HL -> �����.����	*
;*		A -> ����		*
;+--------------------------------------+
BORT:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	ANI	4	
	LXI	B,DOUBLE
	JZ	BORT01	
	LXI	B,INTEG	
BORT01:
	LDAX	B	
	CALL	PUTCXY	
	PUSH	D	
	MOV	E,L	
	INX	B	
	LDAX	B	
	CALL	PUTCXY	
	XCHG		
	INX	B	
	LDAX	B	
	CALL	PUTCXY	
	XTHL		
	MOV	E,L	
	INX	B	
	LDAX	B	
	CALL	PUTCXY	
	XTHL		
	DCR	L	
	PUSH	D	
	INX	B	
BORT02:
	LDAX	B	
	INR	E	
	CALL	PUTCXY	
	MOV	A,E	
	CMP	L	
	JNZ	BORT02	
	POP	D	
	XCHG		
	PUSH	D	
	INR	L	
BORT03:
	LDAX	B	
	CALL	PUTCXY	
	DCR	E	
	MOV	A,E	
	CMP	L	
	JNC	BORT03	
	POP	D	
	POP	PSW	
	INX	B	
	INR	E	
	DCR	L	
CONT:
	INR	D	
	DCR	H	
	LDAX	B	
	CALL	PUTCXY	
	PUSH	D	
	MOV	E,L	
	CALL	PUTCXY	
	POP	D	
	XCHG		
	CALL	PUTCXY	
	PUSH	D	
	MOV	E,L	
	CALL	PUTCXY	
	POP	D	
	XCHG		
	MOV	A,D	
	CMP	H	
	JC	CONT	
	JMP	NEXT

;-----------[ MAIN HELP ]----------+
;*  ���������� ���������. ��������.*
;+---------------------------------+
HL_SUB_DE:
	MOV	A,H	
	SUB	D	
	INR	A	
	MOV	B,A	
	MOV	A,L	
	SUB	E	
	INR	A	
	MOV	C,A	
	RET		

HL_DE_WIND:
	LHLD	WIND1	
	XCHG		
	LHLD	WIND2	
	RET		

;+------[ SCROLLING HELP ]-------+
;*		--//--		 *
;+-------------------------------+

SCH1:
	PUSH	B	
	PUSH	D	
	PUSH	H	
SH10:
	CALL	LDIR	
	DCR	H	
	DCR	D	
	DCR	C	
	JNZ	SH10	
	POP	H	
	POP	D	
	POP	B	
	MOV	A,H	
	ADI	20H	
	MOV	H,A	
	MOV	A,D	
	ADI	20H	
	MOV	D,A	
SH11:
	CALL	LDIR	
	DCR	H	
	DCR	D	
	DCR	C	
	JNZ	SH11	
	RET		
SCH2:
	PUSH	B	
	PUSH	D	
	PUSH	H	
SH20:
	CALL	LIIR	
	INR	H	
	INR	D	
	DCR	C	
	JNZ	SH20	
	POP	H	
	POP	D	
	POP	B	
	MOV	A,H	
	ADI	20H	
	MOV	H,A	
	MOV	A,D	
	ADI	20H	
	MOV	D,A	
SH21:
	CALL	LIIR	
	INR	H	
	INR	D	
	DCR	C	
	JNZ	SH21	
	RET		

;+----------[ CURSOR ABSOLUTE ]---------+
;*	����:	DE -> �������.�����.	*
;*	�����:	DE -> �����`���� �����.	*
;+--------------------------------------+

ABS_DE:
	PUSH	PSW	
	PUSH	H	
	LHLD	WIND1	
	MOV	A,D	
	ADD	H	
	MOV	D,A	
	MOV	A,E	
	ADD	L	
	MOV	E,A	
	POP	H	
	POP	PSW	
	RET


;+--------[ SCROLL WINDOW ]---------+
;*    ��������� ��������� ���� 	    *
;+----------------------------------+
;��������������  ������ �������������
SCROL3:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	CALL	HL_DE_WIND	
SC3P:
	CALL	HL_SUB_DE	
	MOV	A,C	
	MOV	C,B	
	PUSH	D	
	PUSH	H	
	ANI	0FH	
	RLC		
	RLC		
	RLC		
	RLC		
	MOV	B,A	
	MOV	A,C	
	RAR		
	DCR	A	
	MOV	C,A	
	XCHG		
	INR	E	
	CALL	ADDRSC	
	DCX	H	
	MOV	D,H	
	MOV	E,L	
	DCR	H	
	CALL	SCH1	
	POP	H	
	POP	D	
	MOV	H,D	
	INR	H	
	CALL	CLS
	JMP	NEXT
;�������������� ����� �������������
SCROL4:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	CALL	HL_DE_WIND	
SC4L:
	CALL	HL_SUB_DE	
	PUSH	D	
	PUSH	H	
	MOV	A,C	
	MOV	C,B	
	ANI	0FH	
	RLC		
	RLC		
	RLC		
	RLC		
	MOV	B,A	
	MOV	A,C	
	RAR		
	DCR	A	
	MOV	C,A	
	CALL	ADDRSC	
	MOV	D,H	
	MOV	E,L	
	INR	H	
	CALL	SCH2	
	POP	H	
	POP	D	
	MOV	D,H	
	DCR	D	
	CALL	CLS	
	JMP	NEXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
W_PUTCXY:
	PUSH	D	
	CALL	ABS_DE	
	CALL	PUTCXY	
	POP	D	
	RET		

PUTCXY:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	MOV	B,A	
	CALL	ADDRSC	
	XCHG		
	MOV	A,H	
	RRC		
	MOV	A,B	
	MVI	B,16	
	PUSH	PSW
	PUSH	D		;����������� ������ ���������������
	MVI	H,0
	MOV	L,A	
	DAD	H	
	DAD	H	
	DAD	H	
	DAD	H	
	LXI	D,W_ZG		;��������� �� ��������������
	DAD	D
	POP	D	
	POP	PSW
	XCHG		
	JC	SHET	
	MVI	C,0FH	
SCA:
	MOV	A,M	
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
NEXT:
	POP	PSW	
	POP	H	
	POP	D	
	POP	B	
	RET
		

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

