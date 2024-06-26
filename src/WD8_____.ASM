	Title	WD8.ASM
;;;;;;;;;;;; (C) 11.02.1994 PPA Soft Systems ;;;;;;;;;;;;;
;;	������ ����������� ������� ��������� ������	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	External Buf_Begin  ; ������ ������ ����.
	External W_Zg	    ; ������ ���������������.
	External W_Emul_Txt ; ������� �������� ������.

;;;;;;;;;;; ����� ������ � ��������� �������� ;;;;;;;;;;;;;
	Public W_Put_Char	;����� ������� �����. � 'DE'
	Public W_Get_Char	;������ ������� -//-
	Public W_Open		;�������� ���� (DE),(HL),�-����
	Public W_Close  	;�������� ����
	Public W_Cls		;�������� ����
	Public W_Up_Scroll	;��������� ���� �����
	Public W_Down_Scroll	;����
	Public W_Right_Scroll	;������ (�� 2 �������)
	Public W_Left_Scroll	;�����  (�� 2 �������)
;;;;;;;;;;;; �������������� ������� ��������� ;;;;;;;;;;;;;
	Public	Put_XY_Char	;
	Public	Get_XY_Char	;
	Public	Cls_XY		;
	Public	Box_XY		;
	Public	Down_Scroll	;
	Public	Up_Scroll	;
	Public	Right_Scroll	;
	Public	Left_Scroll	;
	Public	Abs_DE		;
	Public	Inc_Move	;
	Public	Dec_Move	;
	Public	HL_DE_Window	;
	Public	HL_Sub_DE	;
	Public	Addr_Screen	;

;______________ ������� ������ ________________
	Public	W_Cursor
	Public	W_1Window
	Public	W_2Window
	Public	W_Number
	Public	W_Buf_Seek
;;;;;;;;;;;;;;; ���� ������� ����� ��������� ;;;;;;;;;;;;;;
W_Cursor:	DW	0000h
;;     ������ ������������� ��������� ���������� ������� �
;; ������ �������� ���� � ��� �������� ����� ���� ��� ���-
;; �������� � ������ � ����������� �������������� ��� ���-
;; ����� ����.
W_1Window:	DW	00h	;; (DE) ���������� ����
W_2Window:	DW	3F0Fh	;; (HL) ---//----//---
;;	������ ������ ������ ���������� ���������� ������-
;; �������� ����, ������� ����� ����������� �������������-
;; ��� ��� ��������� �������� � �������� ����� ����
W_Number:	DB	00h
;;	�������� ���������� �������� �� ������ ������ ����.
W_Buf_Seek:	DW	Buf_Begin	;
;;	������������ ������ ���������� �������� ����������
;; ������ ����.
Two_Box:        DB	098h,099h,08Bh,08Ch,08Ah,09Dh
One_Box:	DB	090h,0AAh,08Fh,0A9h,083h,094h
;;     ����� ������ ����������� ��� ������ ��������� �����
;; ����� ����������� ����.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	��������� �������� ������ ��������� ����.	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
W_Open:
	PUSH	B	; �������� ��� ��������
	PUSH	D	; ����������
	PUSH	H	;
	PUSH	PSW	;
	DCR	D	; ������������� ������� ����.
	DCR	E	;
	INR	H	;
	INR	L	;
	ANI	03h	;
	JNZ	W_Yes_Ten;
;;;;;; ���������� ������� ���������� ���� ��� ����� ;;;;;;
	CALL	W_Backup;
	CALL	Cls_XY	;
	CALL	Ramka	;
	JMP	W_O_Termint; ��������� �������� ��������.
;;;;;;;;;;;; ���������� �������� ���� � ����� ;;;;;;;;;;;;
W_Yes_Ten:		;
	DCR	E	;
	INR	H	;
	CALL	W_Backup;
	INR	E	;
	DCR	H	;
	CALL	Cls_XY	;
	CALL	Ramka	;
	POP	PSW	;
	CALL	W_Ten	;
	PUSH	PSW	;
W_O_Termint:		;
	POP	PSW	;
	INR	E	;
	INR	D	;
	DCR	H	;
	DCR	L	;
	SHLD	W_2Window;
	XCHG		;
	SHLD	W_1Window;
	LXI	H,0	;
	SHLD	W_Cursor;
	POP	H	;
	POP	D	;
	POP	B	;
	RET		;
;;;;;;;;;; ��������������� ��������� ������ ���� ;;;;;;;;;
W_Ten:	PUSH	H	;
	PUSH	D	;
	ANI	00000011b;
	ADD	A	;
	ADI	7	;
	MOV	B,A	;
	INR	H	;
	DCR	L	;
	DCR	E	;
W_Ten1:	MOV	A,B	;
	INR	D	;
	CALL	Put_XY_Char;
	MOV	A,D	;
	CMP	H	;
	JNZ	W_Ten1	;
	INR	B	;
W_Ten3:	MOV	A,B	;
	INR	E	;
	CALL	Put_XY_Char;
	MOV	A,E	;
	CMP	L	;
	JNZ	W_Ten3	;
	POP	D	;
	POP	H	;
	RET		;
;;;;;;; ��������� ���������� ���������� ��� ����� ;;;;;;;
W_Backup:	
	PUSH	D	;
	PUSH	H	;
	PUSH	H	; ����������� ����� �������� ����.
	LXI	H,W_Number;
	INR	M	;
	POP	H	;
	CALL	HL_Sub_DE;
	PUSH	B	;
	PUSH	D	;
	XRA	A	;
	MOV	A,B	;
	RAR		;
	LHLD	W_Buf_Seek;
;; ����  "����������"  �����������  ��������  ������� �
;; ����� ���� ���� ������� ��� ���������:
;;	(?)	 	- �����e ����������� ��� �����.
;;	(W_Cursor)	- ���������� ������� � ����.
;;	(W_2Window)	- ���������� �������� ���� ����.
;;	(W_1Window)	- ���������� ������� ���� ����.
;;	(Dx_Dy)		- ������� ����.
;;	(Load_PTR)	- ��������� ������ �������������.

W_Backup_Loop:		;
	PUSH	PSW	; �������� ���� ������� � ������
	CALL	W_Open_Help2; ����.
	PUSH	D	;
	MOV	A,D	;
	ADD	B	;
	DCR	A	; �������� ������� � ������� ����
	MOV	D,A	;
	CALL	W_Open_Help2;
	POP	D	;
	INR	D	;
	DCR	B	;
	DCR	B	;
	POP	PSW	; ���������� ���� �� ����������
	DCR	A	; ������.
	JNZ	W_Backup_Loop;
	DCR	B	;
;;	MOV	A,B	;
;;	ORA	A	;
	CNZ	W_Open_Help2;
	POP	D	;
	POP	B	;
;; DE - ���������� ������ ������� ���� ����.
;; BC - ������� ����.
	PUSH	D		;
	XCHG			;
	LHLD	W_Cursor	;
	CALL	W_Open_Help1	;
	LHLD	W_2Window	;
	CALL	W_Open_Help1	;
	LHLD	W_1Window	;
	CALL	W_Open_Help1	;
	MOV	H,B		;
	MOV	L,C		;
	CALL	W_Open_Help1	;
	XCHG			;
	POP	D	;
	MOV	M,E	;
	INX	H	;
	MOV	M,D	;
	INX	H	;
	SHLD	W_Buf_Seek;
	POP	H	;
	POP	D	;
	RET		;
;;;;;;;; ���������� ��������� ��������������� ����� ;;;;;;;
W_Open_Help1:		;
	MOV	A,L	;
	STAX	D	;
	INX	D	;
	MOV	A,H	;
	STAX	D	;
	INX	D	;
	RET		;
;;;;;;;;;;;; ���������� "������������" ������ ;;;;;;;;;;;;
;; DE - ���������� ���������� �������.
;; BC - ������� ������������ ����
W_Open_Help2:		;
	PUSH	B	;
	PUSH	D	;
W_O_Help2_1:		;
	CALL	W_Get_CharXY;
	MOV	M,A	;
	INX	H	;
	INR	E	;
	DCR	C	;
	JNZ	W_O_Help1;
	POP	D	;
	POP	B	;
	RET		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;		��������� �������� ����			;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
W_Close:
	PUSH	B	;
	PUSH	D	;
	PUSH	H	;
	PUSH	PSW	;
	LHLD	W_Buf_Seek;
	DCX	H	;
	MOV	D,M	;
	DCX	H	;
	MOV	E,M	;
	DCX	H	;
	MOV	B,M	;
	DCX	H	;
	MOV	C,M	;
;; DE - ���� ��������������?
;; BC - ������ ����������������� �����.
	MOV	A,E	;
	ADD	C	;
	DCR	A	;
	MOV	E,A	;
	DCX	H	;
	PUSH	D	;
	XCHG		;
	CALL	W_Close_Help1	;
	SHLD	W_1Window	;
	CALL	W_Close_Help1	;
	SHLD	W_2Window	;
	CALL	W_Close_Help1	;
	SHLD	W_Cursor	;
	XCHG		;
	DCX	H	;
	POP	D	;
	XRA	A	;
	MOV	A,B	;
	RAR		;
	PUSH	PSW	;
	ADD	D	;
	MOV	D,A	;
	POP	PSW	;
	SHLD	BUF1	;
	LXI	H,100H	;
	JNC	DE2	;
	INR	L	;
DE2:
	PUSH	H	;
	LHLD	BUF1	;
	JNC	DE1	;
	CALL	DEH2	;
	INR	D	;
DE1:
	CALL	DEH2	;
	XTHL		;
	MOV	A,D	;
	SUB	L	;
	SUB	H	;
	MOV	D,A	;
	INR	H	;
	XTHL		;
	CALL	DEH2	;
	XTHL		;
	MOV	A,D	;
	ADD	L	;
	ADD	H	;
	MOV	D,A	;
	INR	H	;
	MOV	A,H	;
	CMP	B	;
	XTHL		;
	JC	DE1	;
	INX	H	;
	SHLD	W_Buf_Seek	;
	POP	PSW	;
	JMP	W_Main_Exit;
;
;============= CLOSE  HELP ==============
DEH2:
	PUSH	B	;
	PUSH	D	;
DH21:
	MOV	A,M	;
	CALL	Put_XY_Char	;
	DCX	H	;
	DCR	E	;
	DCR	C	;
	JNZ	DH21	;
	POP	D	;
	POP	B	;
	RET		;
;;;;
W_Close_Help1:
	LDAX	D	;
	MOV	H,A	;
	DCX	D	;
	LDAX	D	;
	MOV	L,A	;
	DCX	D	;
	RET		;
;
;+--------------[ DRAW BOARD ]----------+
;*	����:	DE,HL -> �����.����	*
;*		A -> ����		*
;+--------------------------------------+
Box_XY:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	ANI	4	
	LXI	B,Two_Box
	JZ	BORT01	
	LXI	B,One_Box	
BORT01:
	LDAX	B	
	CALL	Put_XY_Char	
	PUSH	D	
	MOV	E,L	
	INX	B	
	LDAX	B	
	CALL	Put_XY_Char	
	XCHG		
	INX	B	
	LDAX	B	
	CALL	Put_XY_Char	
	XTHL		
	MOV	E,L	
	INX	B	
	LDAX	B	
	CALL	Put_XY_Char	
	XTHL		
	DCR	L	
	PUSH	D	
	INX	B	
BORT02:
	LDAX	B	
	INR	E	
	CALL	Put_XY_Char	
	MOV	A,E	
	CMP	L	
	JNZ	BORT02	
	POP	D	
	XCHG		
	PUSH	D	
	INR	L	
BORT03:
	LDAX	B	
	CALL	Put_XY_Char	
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
	CALL	Put_XY_Char	
	PUSH	D	
	MOV	E,L	
	CALL	Put_XY_Char	
	POP	D	
	XCHG		
	CALL	Put_XY_Char	
	PUSH	D	
	MOV	E,L	
	CALL	Put_XY_Char	
	POP	D	
	XCHG		
	MOV	A,D	
	CMP	H	
	JC	CONT	
	JMP	W_Main_Exit

;-----------[ MAIN HELP ]----------+
;*  ���������� ���������. ��������.*
;+---------------------------------+
HL_Sub_DE:
	MOV	A,H	
	SUB	D	
	INR	A	
	MOV	B,A	
	MOV	A,L	
	SUB	E	
	INR	A	
	MOV	C,A	
	RET		

HL_DE_Window:
	LHLD	W_1Window	
	XCHG		
	LHLD	W_2Window	
	RET		

;+------[ SCROLLING HELP ]-------+
;*		--//--		 *
;+-------------------------------+
SCHELP:
	MOV	A,H	
	SUB	D	
	RRC		
	ANI	1FH	
	MOV	C,A	
	INR	C	
	MOV	A,D	
	XRA	H	
	ANI	1	
	JZ	SCS3	
	MOV	A,D	
	ANI	1	
	JZ	SCS3	
	INR	C	
SCS3:
	MOV	A,L	
	SUB	E	
	RLC		
	RLC		
	RLC		
	RLC		
	MOV	B,A	
	RET		
SCH1:
	PUSH	B	
	PUSH	D	
	PUSH	H	
SH10:
	CALL	Dec_Move	
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
	CALL	Dec_Move	
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
	CALL	Inc_Move	
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
	CALL	Inc_Move	
	INR	H	
	INR	D	
	DCR	C	
	JNZ	SH21	
	RET		

;+----------[ W_Cursor ABSOLUTE ]---------+
;*	����:	DE -> �������.�����.	*
;*	�����:	DE -> �����`���� �����.	*
;+--------------------------------------+

Abs_DE:
	PUSH	PSW	
	PUSH	H	
	LHLD	W_1Window	
	MOV	A,D	
	ADD	H	
	MOV	D,A	
	MOV	A,E	
	ADD	L	
	MOV	E,A	
	POP	H	
	POP	PSW	
	RET

;+-----[ ��������� �������� ���� ]------+
;*	����:	DE,HL -> WINDOW COORD	*
;+--------------------------------------+
Cls_XY:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	JMP	W_ClsDH	
W_Cls:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	CALL	HL_DE_Window	
W_ClsDH:
	CALL	HL_Sub_DE	
	PUSH	B	
	PUSH	D	
	PUSH	H	
	CALL	ADDREM	
HOM7:
	PUSH	H	
	PUSH	B	
HOM6:
	MVI	M,' '	
	INX	H	
	DCR	B	
	JNZ	HOM6	
	POP	B	
	POP	H	
	LXI	D,40H	
	DAD	D	
	DCR	C	
	JNZ	HOM7	
	POP	H	
	POP	D	
	POP	B	
	MOV	A,C	
	ANI	0FH	
	RLC		
	RLC		
	RLC		
	RLC		
	MOV	B,A	
	MOV	A,D	
	RRC		
	JNC	HOM1	
	CALL	STOLB	
	INR	D	
HOM1:
	MOV	A,H	
	RRC		
	JC	HOM2	
	XCHG		
	PUSH	D	
	MOV	E,L	
	CALL	STOLB	
	POP	D	
	XCHG		
	DCR	H	
HOM2:
	MOV	A,H	
	SUB	D	
	RAR	
	INR	A	
	MOV	C,A	
	CALL	Addr_Screen	
	XRA	A	
	PUSH	B	
	MOV	D,B	
	MOV	E,L	
HOM3:
	MOV	M,A	
	INR	L	
	DCR	B	
	JNZ	HOM3	
	MOV	B,D	
	MOV	L,E	
	INR	H	
	DCR	C	
	JNZ	HOM3	
	DCR	H	
	POP	B	
	MOV	A,H	
	ADI	20H	
	MOV	H,A	
	XRA	A	
HOM5:
	MOV	M,A	
	INR	L	
	DCR	B	
	JNZ	HOM5	
	MOV	B,D	
	MOV	L,E	
	DCR	H	
	DCR	C	
	JNZ	HOM5	
	JMP	W_Main_Exit

;+--------[ STOLB ]---------+
STOLB:
	PUSH	D	
	PUSH	B	
	MVI	A,' '	
ST1:
	CALL	Put_XY_Char	
	INR	E	
	DCR	C	
	JNZ	ST1	
	POP	B	
	POP	D	
	RET		

;+--------[ SCROLL WINDOW ]---------+
;*    ��������� ��������� ���� 	    *
;+----------------------------------+
if	scroll_status	; �������� �� ���������
;��������������  ������ �������������
Right_Scroll:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	JMP	SC3P	
W_Right_Scroll:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	CALL	HL_DE_Window	
SC3P:
	CALL	HL_Sub_DE	
	CALL	SCREM3	
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
	CALL	Addr_Screen	
	DCX	H	
	MOV	D,H	
	MOV	E,L	
	DCR	H	
	CALL	SCH1	
	POP	H	
	POP	D	
	MOV	H,D	
	INR	H	
	CALL	Cls_XY
	JMP	W_Main_Exit
;�������������� ����� �������������
Left_Scroll:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	JMP	SC4L	
W_Left_Scroll:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	CALL	HL_DE_Window	
SC4L:
	CALL	HL_Sub_DE	
	CALL	SCREM4	
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
	CALL	Addr_Screen	
	MOV	D,H	
	MOV	E,L	
	INR	H	
	CALL	SCH2	
	POP	H	
	POP	D	
	MOV	D,H	
	DCR	D	
	CALL	Cls_XY	
	JMP	W_Main_Exit

SCREM4:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	DCR	B	
	DCR	B	
	CALL	ADDREM	
SEM41:
	MOV	D,H	
	MOV	E,L	
	INX	H	
	INX	H	
	CALL	Inc_Move	
	LXI	H,40H	
	DAD	D	
	DCR	C	
	JNZ	SEM41	
	POP	H	
	POP	D	
	POP	B	
	RET		

SCREM3:
	PUSH	H	
	PUSH	D	
	PUSH	B	
	XCHG		
	DCR	B	
	DCR	B	
	CALL	ADDREM	
SCE31:
	MOV	D,H	
	MOV	E,L	
	DCX	D	
	DCX	D	
	XCHG		
	CALL	Dec_Move	
	XCHG		
	LXI	D,0FFC0H
	DAD	D	
	DCR	C	
	JNZ	SCE31	
	POP	B	
	POP	D	
	POP	H	
	RET		
endif
;������������� ���� ��������������
Down_Scroll:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	JMP	SCN0	
W_Down_Scroll:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	CALL	HL_DE_Window	
SCN0:
	MOV	A,E	
	CMP	L	
	JZ	QS2	
	PUSH	H	
	PUSH	D	
	CALL	HL_Sub_DE	
	CALL	ADDREM
SCE21:
	LXI	D,40H	
	XCHG		
	DAD	D	
	CALL	Inc_Move	
	DCR	C	
	JNZ	SCE21	
	POP	D	
	POP	H	
	PUSH	H	
	PUSH	D	
	CALL	SCHELP	
	CALL	Addr_Screen
	MOV	D,H	
	MOV	A,L	
	ADI	16	
	MOV	E,A	
	XCHG		
	CALL	SCH2	
	POP	D	
	POP	H	
	MOV	E,L	
QS2:
	CALL	Cls_XY
	JMP	W_Main_Exit

;�������������� ����� ��������������
Up_Scroll:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	JMP	SCV0	
W_Up_Scroll:
        PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	CALL	HL_DE_Window	
SCV0:
	MOV	A,L	
	CMP	E	
	JZ	SCQ1	
	PUSH	H	
	PUSH	D	
	CALL	HL_Sub_DE	
	XCHG		
	CALL	ADDREM
SCE1:
	LXI	D,0FFC0H
	XCHG		
	DAD	D	
	CALL	Dec_Move	
	DCR	C	
	JNZ	SCE1	
	POP	D	
	POP	H	
	PUSH	D	
	PUSH	H	
	CALL	SCHELP	
	XCHG		
	CALL	Addr_Screen	
	MOV	D,H	
	MOV	A,L	
	ADI	16	
	MOV	E,A	
	DCX	H	
	DCX	D	
	CALL	SCH1	
	POP	H	
	POP	D	
	MOV	L,E	
SCQ1:
	CALL	Cls_XY	
	JMP	W_Main_Exit

;+-----------[ WINDOW W_Get_Char ]------------+
;*	����:	DE -> �����.		*
;*	�����:	A  -> ������		*
;+--------------------------------------+
W_Get_Char:
	PUSH	H	
	CALL	Abs_DE	
	JMP	GE1	
Get_XY_Char:
	PUSH	H	
GE1:
	CALL	ADDREM
	MOV	A,M	
	POP	H	
	RET		

;+---------[ WINDOW PUTCHAR ]-----------+
;*	����:	DE -> ����������	*
;*		A  -> ������		*
;+--------------------------------------+
W_Put_Char:
	PUSH	D	
	CALL	Abs_DE	
	CALL	Put_XY_Char	
	POP	D	
	RET		
Put_XY_Char:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	CALL	ADDREM
	MOV	M,A	
	MOV	B,A	
	CALL	Addr_Screen	
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
	LXI	D,W_Zg		;��������� �� ��������������
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
W_Main_Exit:
NEXT:
	POP	PSW	
	POP	H	
	POP	D	
	POP	B	
	RET
		
;+--------[ ��������������� ��������� ]---------+

;___________ MOVE PROCEDURE ___________
Inc_Move:
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

Dec_Move:
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
	LXI	B,W_Emul_Txt	;��������� �� ������� ��������
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
Addr_Screen:
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

