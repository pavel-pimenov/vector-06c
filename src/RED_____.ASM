;;					;;
;;	Include		MACRO.PPA	;;

;; The PPA Text Editor v 2.00 Special for System_Tehcnic.Ltd ;;

;;	Date 14.04.1994			;;
Debug	EQU	0	; 1 - ������ �����������.
			; 0 - ������ �� �����������.
	JMP	PPASTART

W_Zg		EQU 0E000h	;������ ���������������
W_Emul_Txt	EQU 0E800h	;������ ������� ��������
Buf_Begin	EQU 0F000h	;������ ������ ����
Cursor_Zise	EQU 08h		; ������ �������.

STR_CR		EQU 0F200h	;
STR		EQU 0F201h	; ����� ������.
BUF_ETALON	EQU 0F302h	;- ������ ��� ������ �������
BUF_PODM	EQU BUF_ETALON+20 ;- ������.
DUMP_GUT	EQU BUF_PODM+20   ;����� ��� ������ � ������.
DUMP_END_GUT	EQU 0FFFFh	;
DUMP_ZISE	EQU DUMP_END_GUT - DUMP_GUT;

BUF2_TIME	EQU 0003h	;
DL_ETALON	EQU 0005h	;
DL_PODM		EQU 0006h	;
CURHY		EQU 0007h	;
CURDY		EQU 0009h	;
CURHX		EQU 000Ch	;
CURDX		EQU 000Dh	;
DLINNA		EQU 000Fh	;
FLAGLINE	EQU 0010h	;
F_SL_BUF	EQU 0011h	;
KORBUF		EQU 0011h	;
ENDLINE		EQU 0014h	;
MAXDLINNA	EQU 0016h	;
F_FLAG		EQU 0017h	;
GET_INVERSE	EQU 0018h	;
STACK_BUFER	EQU 0019h	;
TMP_BUFER	EQU 001Bh	;
BL_B_FLAG	EQU 001Dh	;
BL_D_FLAG	EQU 001Eh	;
BL_F1_POS	EQU 001Fh	;
BL_DUMP_ZISE	EQU 0021h	;
BL_CURDY	EQU 0023h	;
BL_CURHY	EQU 0026h	;
W_1Window	EQU 0028h	;
W_Number	EQU 002Ah	;
Cur_Flag	EQU 002Bh	; "DB" 2 ������ ����������� ������
Cur_Timer	EQU 002Ch	; "DW" �������� �������.
Box_Control_PTR	EQU 002Eh	; "DW" �������� ����� Box_XY
OFSET		EQU 0030h	; "DB" ������� � �������� ����.

STOPBYTE	EQU 0FFh	;������������� "����� ������"
ESC		EQU 1Bh		;��� ��� ESC �������������������
STACKSEG	EQU 100h	;��������� �������� �����
TEXT_LIMIT	EQU 9FFFh	;����� ������
CR		EQU 0Dh		;

	Public	WJHEX		; 2 ��������� ������ ����������������
	Public	JHEX		; ����� ��� � ������������.
	Public	SOOBF		; ��������� "Out of memory"
	Public	OFSET		; �������� "����" 
	Public	CCLEFT		; ������� � ������ ������
	Public	CURHY		; 2 ���������� ��������� ���������
	Public	CURDY		; ������� �� ������.
	Public	MOVE		; �������� �����������.
	Public	SINC		; 2 ��������� ����������� �� ������
	Public	SDEC		; ---//----//-----//---
	Public	I_REMOVE	; 2 ��������� ����������� ������
	Public	D_REMOVE	; �� ����� ������� � ������
	Public	WARNING		; ������ ���������.
	Public	SV_VARIAL	; ��������� ��������� ����������.
	Public	W_DOP_INX	; �������������� ���� ��� �����. ����
	Public	F_3EXIT		; ����� � ��������� ���� DY
	Public	INCX		;-!
	Public	INCY		; !\ ��������� ���������� � ���������
	Public	DECX		; !/ ��������� ������� � ������.
	Public	DECY		;-!
	Public	RS_STR		; ������� ������ ������
	Public	US_OPEN		; �������� ���� Menu,F4-Esc
	Public	DEL_TEXT	;
	Public	S_ARE_YOU	;
	Public	F_INPUT_NAME	;
	Public	F_F_ASCII	;
	Public	PPASTART	;
	Public	F_F_ASCII	;
	Public	BTEXT		;
	Public	MENU		;
	Public	TEXT_LIMIT	;
	Public	ENDTEXT		;
	Public	POS		;
	Public	WPUTSDOP	;
	Public	WPUTS1		;
	Public	NULL_POS	;
	Public	PRSCREEN	;
	Public	COPYS		;
	Public	DLINNA		;
	Public	PRINT_POS	;
	Public	DOMOY		;
	Public	UP		;
	Public	DON		;
	Public	NEG_DE		;

LOOP	macro	REG,ADRESS	;
		DCR	REG	;
		JNZ	ADRESS	;
	endm			;
;;
;;	���������������� ��������� ����
;; ���������������� ������ ������ � PPA
;; �������.
Rus_DB	Macro	String		;
	IrpC	Chr,String	;
	IfE	'&Chr&'-'_'	;
	DB	' '		;
	Else			;
	DB	"&Chr&"+80h	;
	EndIf			;
	Endm			;
	Endm			;


;;
;;������������ ���������� ��������� REGENER �� ������ �������� �� ����� ����
;;

PUT_CONST:	DB	33h	; ��������� ������ �� ����������.
GET_CONST:	DB	4Bh	; ��������� ������ � �����������.
;BUF2_TIME:	DW	0000h	; ������ ����������� ������� �������.
Restart:
	LXI	SP,STACKSEG
	LDA	Cur_Flag;
	ORA	A	;
	CZ	CINV	;
	CALL	W_Close	;
	CALL	W_Close	;
	CALL	W_Close	;
	CALL	RESTORE_EDIT
	CALL	CCLEFT	;
	JMP	NOESOPROS
EDITING:
	CALL	RS_STR
	INR	A
	STA	OFSET
	CALL	DOMOY
	CALL	DON
	CALL	UP
;; ���� �������� ����������� ���ͮ
	LXI	H,PPASTART
	LXI	B,0FF00h
	MOV	E,C
	MOV	D,C
ED_LOOP:
	MOV	A,C
	ADD	M
	MOV	C,A
	INX	H
	DCR	B
	JNZ	ED_LOOP
	MOV	A,C
	CPI	00h
If	Debug
	JNZ	2563h	;
EndIf
	INX	D	;
	INX	D	;
	XCHG		;
	INX	H	;
	MOV	A,M	;
	INX	H	;
	ORA	M	;
If	Debug
	JNZ	0666h	;
EndIf
NOESOPROS:
	LDA	Cur_Flag	;
	ORA	A		;
	CZ	CINV		;
LOOPKEY:	
	CALL	Input_Key
	MOV	B,A		;
	LDA	BL_B_FLAG	;
	ORA	A		;
	JZ	P_KEY_DONE	; ������ �� ����������.
	LHLD	BUF2_TIME	; �������� ���������� ������� �������
	INX	H		;
	SHLD	BUF2_TIME	;
	MOV	A,H		;
	SUI	14		;
	JNZ	P_KEY_DONE	; ���� ����� �� ����� �� �� ��������.
;; ������� ����� ���������� �������� ����� "View"
;; ��� ��������� ������� �������.
	STA	BUF2_TIME + 1	;
	LHLD	W_Cursor	;
	PUSH	B		;
	PUSH	H		;
	LXI	H,W_Cursor	;
	MVI	B,9		;
	MVI	M,1Bh		;
	INX	H		;
	MVI	M,10h		;
	CALL	LINE_I_DOP	;
	POP	H		;
	POP	B		;
	SHLD	W_Cursor	;
P_KEY_DONE:
	LHLD	Cur_Timer	;
	INX	H		;
	SHLD	Cur_Timer	;
	MOV	A,H		;
	SUI	7		;
	JNZ	P_KEY2_DONE	;
	STA	Cur_Timer + 1	;
	LDA	Cur_Flag	;
	CMA			;
	STA	Cur_Flag	;
	CALL	CINV		;
P_KEY2_DONE:			;
	INR	B		;
	JZ	LOOPKEY		; ������� �� ������.		
	DCR	B		;
KONTR_PPA:
	LDA	Cur_Flag	;
	ORA	A		;
	CZ	CINV		;
	LXI	H,NOESOPROS	;
	PUSH	H		;
	LDA	BL_B_FLAG	;
	ORA	A		;
	JZ	P_0DONE		;
	MOV	A,B		;
	CPI	04h		;
	CC	PLAY		; ������ ���� ������.
	RC			; � �������	
	CPI	0Bh		; F1 - ???
	JZ	P_0DONE		;
	CPI	0Dh		; F3 - ???
	JZ	P_0DONE		;
	CPI	09h		;
	CNC	PLAY		;
	RNC			;
P_0DONE:
	IN	01H	; ����� ������ �� ����� "�"
;; ��� ��������� � ���� ������������ ����������� �������.
PPA_PROTECT:
	STA	KORBUF	;
	MOV	C,A
	ANI	40H	;�������� ������� "��"
	MOV	A,B
	JZ	USADDX	;���������� ��+
	CPI	10H
	JNC	BYKVA
	MOV	A,C
	ANI	20H	;�������� ������� "CC"
	MOV	A,B
	JZ	CCADDX	;���������� CC+...
	ORA	A
	JZ	BYKVA	;���������
	CPI	07H	;����
	JZ	DON	
	CPI	05H	;�����
	JZ	UP	
	CPI	06H	;������
	JZ	RIGHT	
	CPI	04H	;�����
	JZ	LEFT
KEYDONE:
	CPI	0CH	;F2-Delete
	JZ	DELETE
	CPI	0Bh	;F1-Begin Block
	JZ	BL_BEGIN
	CPI	0Dh	;F3-End Block
	JZ	BL_END
	CPI	03H	;�����
	JZ	ZABOY
	CPI	08H	;�����
	JZ	DOMOY
	CPI	2H	;Enter
	JZ	ENTER
	RET	

;%%%%%%%%%%%%% CC + ������� %%%%%%%%%%%%%%%

CCADDX:
	LXI	H,Key_Reset
	PUSH	H
	CPI	05H	;CC+�����
	JZ	CCUP
	CPI	07H	;CC+����
	JZ	CCDON
	CPI	04H	;CC+�����
	JZ	CCLEFT
	CPI	06H	;CC+������
	JZ	CCRIGHT
	CPI	0CH	;CC+F2 - �������� ������� ������
	JZ	CCDELETE
	JMP	KEYDONE	;����� ������� �� ����������


F_S00:	Rus_DB	������_�����
	DB	CR
	Rus_DB	������_�����
	DB	CR
	Rus_DB	���������
	DB	CR
F_S10:	Rus_DB	����
	DB	':',CR

S_SOOBHLP3:
	Rus_DB	����������
	DB	" ?",CR

S_SOOBHLP2:
	DB	6,7,' '
	Rus_DB	����������
	DB	' ',6,7,' ',7,8
	DB	' ',7,8,CR

S_SOOBHLP:
	Rus_DB	��������
	DB	CR

S_SOOB1:
	Rus_DB	����������_�����
	DB	CR


	Rus_DB	���������_�����
	DB	CR

S_SOOB2:
	Rus_DB	��_��������
	DB	CR

	Rus_DB	��������
	DB	CR
	
ETALON:	Rus_DB	�����
	DB	':',CR

PODMENA:
	Rus_DB	������
	DB	':',CR
I_SOOB1:
	Rus_DB	������_�����
	DB	':',CR

	Rus_DB	��������
	DB	':',CR

	DB	"H "
	Rus_DB	����
	DB	CR

PPAYESNO:	DB	6,7,' Yes/No ',7,8,0
F4ESC:		DB	6,7,' F4-Esc ',7,8,0


WARNGOTO:
	Rus_DB	�����_������
	DB	':',CR
SOOBL:	DB	'Home',CR
SOOBR:	DB	'End',CR
SOOBD:	DB	'Bottom',CR
SOOBV:	DB	'Top',CR


SV_TS2:	Rus_DB	 ��_�������
		DB	" ???",CR
;SV_TS1:	Rus_DB	������
;	DB	CR
;	Rus_DB	����
;	DB	CR
;SV_TS0:	Rus_DB	���������
;	DB	CR
;	Rus_DB	��������
;	DB	CR
;	Rus_DB	���
;	DB	CR
;	Rus_DB	���
;	DB	CR
SV_SOOB3:
	Rus_DB	�������_��������
	DB	':',CR
SV_SOOB2:
	Rus_DB	�����
	DB	CR
	Rus_DB	���
	DB	CR
SV_SOOB1:
	Rus_DB	���������
	DB	CR
	Rus_DB	�����_�������
	DB	CR
	Rus_DB	�����_��������
	DB	CR
;;;;;;;;;;;;;;;
;;
;; ��������� ������������ ��������������� ����
;; � ����������� ���� DE
;;
NEG_DE:	
		MOV	A,D		;
		CMA			; ����������� ����: DE
		MOV	D,A		; ��������� � ��������������
		MOV	A,E		; ��� ��� ����������� ��������
		CMA			; ���������
		MOV	E,A		;
		INX	D		;
		RET			;

;		INCLUDE	EDMAIN.ASM
;; 
;; ������ �������� ����� ����������� ���������� ���������� ���
;; "PPA Editor" ,��� ������� ���������� ������������ �������� 
;; �������� 
;; ��������� �����������: 9.03.1994 �. ���������
;;
;;
;; ��������� MENU ������������ �������� � ������� ���� ���� ��
;; ��������� ����������� ��������� ������� �� ����� ���� � ����
;; ���������� ������� �� ������� ���� �� ������������� ���������
;; ��������� �� ��������������� ������� ����. ��������� �� ����� 
;; ������ �� ��������: � ���� �� ���������� ����� ���� ��������- 
;; ������ ����� ( ���� ������������ ) � ������ �� ��������� ����-
;; ���.
;; ������� ������: ���
;; �������� ������: A - ������������ ������� � ������� ���������
;;			 ������� ������� "��" ���� ���� ������ ���-
;;			 ���� "F4" �� � � ������������ "0FFH"

MENU:		CALL	HL_DE_Window	; ������ ���������� ����
		CALL	HL_Sub_DE		; ��������� ������� ����
		MOV	A,B		; ������������ ��������
		DCR	B		;
		DCR	B		;
		MOV	D,B		;
		MOV	L,C		;
		MOV	E,L		;
		MVI	H,0		;
		DCR	L		;
		SHLD	W_Cursor		;
M_KEY_LOOP:	CALL	LINE_INV	; ����������� ������
		CALL	Key_Reset	; ���������� ������� ����������
		CALL	Key_Wait	; ������� �������
		CALL	LINE_INV	; ����� ���������
		LXI	H,M_KEY_LOOP	;
		PUSH	H		;
		CPI	05H		; ������� �����
		JZ	M_UP		;
		CPI	07H		; ������� ����
		JZ	M_DON		;
		CPI	02H		; "BK"
		JZ	M_EXIT		;
		CPI	0EH		; "F4"
		JZ	M_2EXIT		;
		RET			;
;; ��������� ��������� ������� ������� �����		
M_UP:		LXI	H,W_Cursor	;
		INR	M		;
		MOV	A,M		;
		CMP	E		;
		RC			;
		MVI M,0			;
		RET			;
;; ��������� ��������� ������� ������� ����
M_DON:		LXI	H,W_Cursor	;
		DCR	M		;
		MOV	A,M		;
		INR	A		;
		RNZ			;
		MOV	M,E		; ���� �������������� ��������
		DCR	M		;
		RET			;

M_EXIT:		LDA	W_Cursor	; ����� ����� ������� ������
M_2EXIT:	LXI	H,001Ah		; ������ �������� ��... �����
		SHLD	W_Cursor	; � ������� �� ���������
		POP	H		; �������� ����� �� �����
		RET			;

LINE_INV:	LXI	H,W_Cursor+1	; ������������� ��������� ��
		MVI	M,1		; �������������� ����������
LINE_I_DOP:	CALL	CINV		; � ���������� ������������
		INR	M		; �������� ����� ����
		DCR	B		;
		JNZ	LINE_I_DOP	;
		MOV	B,D		; ���������� ����� ����
		RET			; ����� �� ������������

;+----------[ WINDOW PUTS ]------------+
;*	����:	DE ->�����.,BC -> ����.*
;+-------------------------------------+
W_DOP_INX:
	CALL	WPUTSDOP
	INX	B
	RET

WPUTSDOP:	PUSH	H
		PUSH	D
		PUSH	PSW
		JMP	WDOP
WPUTS1:		PUSH	H	
		PUSH	D	
		PUSH	PSW	
		LDA	OFSET
		PUSH	PSW	
		CALL	MOVE	
		POP	PSW
WDOP:		ANI	7H
		SUI	2H
		LHLD	W_2Window	
		INR	H
		MOV	L,A	
		CALL	Abs_DE	
WP01:		LDAX	B	
		CPI	CR	
		JZ	WPQ	
		CPI	9H
		JNZ	WP04	
WP02:		XRA	A	
		CALL	Put_XY_Char	
		INR	D	
		MOV	A,D
		CMP	H
		JNC	WPQ	
		ADD	L	
		ANI	7H	
		JNZ	WP02	
		JMP	WP03	
WP04:		CALL	Put_XY_Char	
		INR	D	
WP03:		INX	B	
		MOV	A,D	
		CMP	H
		JC	WP01	
WPQ:		XCHG
		SHLD	ENDLINE		;��������� ����� ������
		POP	PSW	
		POP	D	
		POP	H	
		RET		


;+--------[ DESJWRITE ]---------+
;* ����: HL -> ����.�����	*
;*	 DE -> ����������	*
;*	 B*2+1 -> ����� ����	*
;+------------------------------+
JDES:		PUSH	B	
		PUSH	D	
		PUSH	H	
		PUSH	PSW	
		MVI	C,0FH	
JD0:		MOV	A,M	
		CALL	JPUT	
		INX	H	
		MOV	A,M	
		RRC		
		RRC		
		RRC		
		RRC		
		CALL	JPUT	
		DCR	B	
		JNZ	JD0	
		MOV	A,M	
		CALL	JPUT	
		POP	PSW	
		POP	H	
		POP	D	
		POP	B	
		RET		
JPUT:		ANA	C	
		ADI	30H	
		CALL	Put_XY_Char	
		INR	D	
		RET		


;+---------[ HEXJWRITE ]--------+
;* ����: A -> ���		*
;*	 DE -> ����������	*
;* ��� ����� �����.DE ������.	*
;* � ����������			*
;+------------------------------+
WJHEX:		PUSH	B	
		CALL	Abs_DE	
		POP	B	
JHEX:		PUSH	B	
		MOV	B,A	
		RRC		
		RRC		
		RRC		
		RRC		
		CALL	PR	
		MOV	A,B	
		CALL	PR	
		MOV	A,B	
		POP	B	
		RET		
PR:		ANI	0FH	
		CPI	0AH	
		JC	PR0	
		ADI	7	
PR0:		ADI	30H	
		CALL	Put_XY_Char	
		INR	D	
		RET		


;24.02.1993�. ������� ��������� MOVE �������� �� ����� �������
;����� � ������� ...�� �� �� ���� �������

MOVE:		ORA	A	; 24.2.93
		RZ		; --//--
		MOV	H,A
		MVI	L,0
		LDAX	B
		CPI	9H
		JNZ	MV2
		DCX	B
		JMP	MV0
MV2:		MOV	A,L
		CMP	H
		RNC		;������� ���� L>=H
		INR	L
MV3:		LDAX	B	
		CPI	9H
		JZ	MV0	;��������� ���������
		CPI	CR
		RZ
		INX	B
		JMP	MV2
MV0:		MOV	A,H
		CMP	L
		RC
		MOV	A,L	
		INR	L
		ANI	7	
		JNZ	MV0
		INX	B
		MOV	A,H
		CMP	L
		RC
		LDAX	B
		CPI	09H
		JZ	MV0
		JMP	MV3+1

;		INCLUDE	EDLINE.ASM
;$$$$$$$$$$$$$$ Stat_SmallL EDITOR LINE $$$$$$$$$$$$[ 17.11.1992 ]
;;
;;��������� �������� ���������� �������� ������ � ������ STR
;;�� ���� ������� ���� �� ������ ������� "��"
;;������� ���������� :�����,������,��,F2
;;������� ������: 
;;			� => ����� (������������) �� ������� ��������
;;			     ������������� ������
;;			DE=> ������������� ���������� ������� ������
;;			HL=> ��������� �� ������������� ������
;;			     ������ ���������� � ����� STR
;
;;

EDLINE:		STA	MAXDLINNA
		CALL	COPYSDOP
		MOV	H,A		;�������� ����� ��������
		LXI	B,STR		;����� ������
		XRA	A
		CALL	WPUTSDOP
		MOV	L,E
		MOV	A,D		;BC -��������� ����� ������
		ADD	H
		MOV	H,A
		SHLD	W_Cursor		;��������� ��������� ������
EDDO:		CALL	CINV
EDKEYLOOP:	CALL	Key_Wait
		CALL	CINV
		LXI	H,EDDO
		PUSH	H
		CPI	10H
		JNC	SYMBOLS		;������ �����
		CPI	04H		;�����
		JZ	EDLEFT
		CPI	06H		;������
		JZ	EDRIGHT
		CPI	0CH		;F2-UDALENIE
		JZ	EDDELETE
		CPI	03H		;�����
		JZ	EDZABOY
		CPI	0EH		;F4-ESC
		POP	H
		RZ
		CPI	02H		;BK
		RZ
		PUSH	H
		RET

SYMBOLS:	CALL	EDINSERT
		CZ	EDRIGHT
		RET

EDZABOY:	CALL	EDLEFT
		CNZ	EDDELETE
		RET

;��������� ������� ������� � ����� ����������� � ������ STR
EDINSERT:	LDA	MAXDLINNA
		PUSH	B
		LXI	B,STR
		CALL	MOVE
		LDAX	B
		CPI	CR
		POP	B
		CNZ	PLAY
		RNZ
		CALL	MOVEINS	;������� � �����������
		LDA	Key_Kode
		STAX	B
		PUSH	B
		LXI	B,STR
		XRA	A
		CALL	WPUTSDOP
		POP	B
		RET

EDDELETE:	LDAX	B
		CPI	CR
		RZ		;����� ������ ����� � ������ "Z" � �����
		CALL	MOVEDEL		;������� � �����������
		LHLD	ENDLINE
		DCR	H
		PUSH	B
		LXI	B,STR
		XRA	A
		CALL	WPUTSDOP		
		POP	B
		MVI	A,' '
		XCHG
		CALL	Put_XY_Char
		XCHG
		ORA	A		;����� �����
		RET
;$$$$$$$$$$$
;	BC ===> ����
;
MOVEDEL:	MOV	H,B
		MOV	L,C
MODE0:		INX	H
		MOV	A,M
		DCX	H
		MOV	M,A
		INX	H
		CPI	CR
		JNZ	MODE0
		RET
;$$$$$$$$$$$
;BC --> ��������� ������ �������� ���� ����� ���������� �������
MOVEINS:	MOV	H,B
		MOV	L,C
		PUSH	D
		MVI	D,0
MOINS0:		MOV	A,M
		INR	D
		CPI	CR
		INX	H
		JNZ	MOINS0
MOINS1:		DCX	H
		MOV	A,M
		INX	H
		MOV	M,A
		DCX	H
		DCR	D
		JNZ	MOINS1
		POP	D
		RET
;$$$$$$$$$$$
EDLEFT:		DCX	B
		LDAX	B
		CPI	CR
		INX	B
		RZ			;����� ������ ������
		DCX	B
		LXI	H,W_Cursor+1
		DCR	M
		INR	A		;����� �����
		RET
;$$$$$$$$$$$
EDRIGHT:	LDAX	B
		CPI	CR
		RZ
		INX	B
		LXI	H,W_Cursor+1
		INR	M
		INR	A		;����� �����
		RET

;		INCLUDE	SYMB.ASM
;; ����� �������� ������������ ��� ���������
;; ������� �� ���������� ������� � ��������� 
;; ����������� ���������� ��� PPA-Editor
;; �������: 06.12.1992 +++ 14:05 +++ �����������
;
BYKVA:		PUSH	PSW
		CALL	NARUSHENIE
		CALL	Key_Reset
		POP	PSW
		JNZ	BYKVA_NORM
;���������� ������� ���������
		MVI	D,09H
		MVI	A,246
		CALL	INSERTS_DOP
		JZ	RIGERROR
		CALL	BYKVA_HLP
BYKVA_00:	CALL	RIGHT
		ORA	A
		RZ
		DCR	A
		RZ
		JMP	BYKVA_00
		
BYKVA_NORM:	CALL	INSERTS
		JZ	RIGERROR	;������ �����������
		CALL	BYKVA_HLP
		CALL	RIGHT
		RET
;#####################################
BYKVA_HLP:	LHLD	W_Cursor
		MVI	H,0
		XCHG
		LXI	B,STR
		CALL	WPUTS1
		RET
				
;$$$$$$$$$$$$$ ������� ������� $$$$$$$$$$$$
INSERTS:	MOV	D,A
		MVI	A,254
INSERTS_DOP:	LXI	B,STR
		CALL	MOVE
		LDAX	B
		SUI	CR
		JZ	INS_00
		XRA	A
		RET
INS_00:		MVI	E,1
		CALL	INS_INS
		DCR	E
		CNZ	MOVEDEL
		MOV	A,D
		STAX	B
		ORA	A
		RET

;%%%%%%%%%%%%% �� + ������� %%%%%%%%%%%%%%%
USADDX:		CALL	REGENER		;
		LXI	H,EDITING + 1	;
		LXI	B,0FF00h	;
US_LOOP1:
		MOV	A,C		;
		ADD	M		;
		MOV	C,A		;
		INX	H		;
		DCR	B		;
		JNZ	US_LOOP1	;
		MOV	A,C		;
		CPI	00h		;
If	Debug
		CNZ	PPA_KILLER	;
EndIf
		LDA	Key_Number		;������ ��������� ����� �������
		CPI	14H		;����� "4" ===== SEARCH =====
		JZ	SEARCH		;
		CPI	13H		;����� "3" ====== GOTO ======
		JZ	GOTOLINE	;
		CPI	12H		;����� "2" ====== File ======
		JZ	FILE		;
		CPI	0BH		; US + "F1" ====== Block ======
		JZ	BLOCK		;
		CPI	16H		;����� "6" ====== Info ======
		JZ	M_INFO		;
		CPI	15H		;����� "5