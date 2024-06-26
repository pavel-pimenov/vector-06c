��������� �� �������
Key01:
	OUT	03	; ������ ���� : "������� ����"
	IN	02	; � �������� ���� �� ��������
	INR	A	; ������ ������� ����������
	JNZ	Key010	;
	MOV	A,E	;
	ADD	D	;
	MOV	E,A	;
	MOV	A,B	;
	RLC		;
	MOV	B,A	;
	DCR	C	;
	JNZ	Key01	;
EXIT1:
	CALL	HLP	; ���������� ��������� ����������
	MVI	A,0FFh	; ������ � �������� ����������
	STA	Key_Kode	; � ����� �� ������� �������
	JMP	Key_Main_Exit;
Key010:
	DCR	A	;
Key00:
	RAR		;
	INR	E	;
	JC	Key00	;
	DCR	E	;
	CALL	HLP	;
	LXI	H,Key_Number;
	MOV	M,E	; ��������� ����� �������
	INX	H	; DONEM-LABEL
	PUSH	H	; ������ �������� ��������� � �����
	IN	01H	; ������ ������ ����������� ������
	LXI	B,1020H	; BC - ������� ���������
	ANA	C	; �������� ������� "��"
	MOV	D,A	; ��������� � �������� MPU
	MOV	A,E	; ��������� ����� �������
	CMP	B	; ������� � ����� == 10H ===
	JNC	DONE03	; ������� ���� ����� ������ 10H
;; ���������� ��������� ������� ������ ��������� ����������
;; ������� ��������� ������:
;;
	CPI	03H	; ����� ������� ������ 10H
	RNZ		; �.�. ������ ������� ���������
	MOV	A,D	; ���������� ( ������ ��� ����� ��
	ORA	A	; ����� ���������� �������� �������)
	MOV	A,E	; ����� ���������� ��������� ������
	RNZ		; ������� "��" � ����������� ��
	MVI	A,5FH	; ������� ������� "��"
	RET		;

DONE03:
	CMP	C	; ������� � ����� == 20H ==
	JNC	DONE05	; ������� ���� ������ ��� �����
;; ���������� ������� ������� ������ � ��������
;; �� 10H-20H - ����� � ���� �����
	MOV	A,D	; ������� ������ ������� "��"
	ORA	A	; ���� ��� 0 �� ������ ������
	MOV	A,E	; ����� �� ������
	JZ	Key02	; 
	ADD	B	;
Key02:
	ADD	B	;
	MOV	L,A	;
	MOV	A,E	;
	CPI	1CH	;
	MOV	A,L	;
	RC		;
	XRA	B	;
	RET		;
;;
;; ���������� ������� ������� �������� ������
;;
DONE05:
	CPI	3FH	; ���� ��� ������ �� �����.
	MOV	A,C	; ��� 20H
	RZ		;
	MOV	A,D	;
	ORA	A	;
	LDA	Stat_Small	; ������ ������ ������ ���������
	JNZ	D_5_OBH	;
	CMA		;
D_5_OBH:
	ORA	A	; ��������� �� ��������� 0
	MOV	A,E	; ���� = 0 �� ��������� �����
	JZ	Key04	; ����� �������� �����
	ADD	C	;
Key04:
	ADD	C	;
	MOV	E,A	;
	LDA	Stat_RUS_LAT	;
	ORA	A	;
	MOV	A,E	;
	RZ		;
	ADI	80H	; �������� �� ������ �����
	XRA	C	;
	RET		;
Key_Number:	DB	00h	;����� �������
DONEM:
	LXI	H,Key_Main_Exit;	
	PUSH	H	;
	MOV	C,A	;
	LDA	Key_Kode;
	CMP	C	;
	LXI	H,KOOL	;
	JNZ	M22	;
	MOV	A,M	;
AL1:
	CPI	30	;
	JZ	M24	;
M23:
	INR	M	;
	RET		;
M22:
	MVI	M,0	;
	MVI	A,30	;����.��������
	STA	AL1+1	;
	INX	H	;DREB
	MOV	A,M	;
	DCR	A	;
	JNZ	M23	;
	DCR	M	;
	DCX	H	;
	JMP	DONE10	;
M24:
	MVI	M,0	;
	MVI	A,2	;CONST AUTO
	STA	AL1+1	;
DONE10:
	MOV	A,C	;
	DCX	H	;
	MOV	M,A	;
	DCX	H	;
	DCR	B	;
	CMP	B	;
	JNZ	M31	;
	MOV	A,M	;Stat_Small
	CMA		;
	MOV	M,A	;
M31:
	LXI	H,Key_Seek	;
	MOV	A,M	;
	CPI	4	; ������ ������ ����������.
	CALL	Beep_Key;
	RZ		;
	INR	M	;
	MOV	C,A	;
	MVI	B,0	;
	DAD	B	;
	LDA	Key_Kode;
	MOV	M,A	;
	RET		;
Key_Main_Exit:
	POP	PSW	;
	POP	H	;
	POP	D	;
	POP	B	;
	EI		;
	RET		;
;;;;;;;;;;;;;;;; ��������������� ��������� ;;;;;;;;;;;;;;;
HLP:
	MVI	A,88h	;
	OUT	00h	;
	LDA	Stat_RUS_LAT	;
	OUT	01h	;
	MVI	A,0FFh	;��������
	OUT	03h	;
	MVI	A,10h	;����� � ������
	OUT	02h	;
	RET		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	��������� ������ ������ �� ��������� ��������	;;
;; ���������� "����" (���� �����������)			;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Beep_Key:
	PUSH	PSW	;
	MVI	B,4	;
	MVI	E,30H	;
	LDA	Stat_RUS_LAT;
	MOV	C,A	;
BEEP0: 	INR	A	;
	ANI	1	;
	ORA	C	;
	OUT	1	;
	PUSH	D	;
BEEP:	DCR	E	;
	JNZ	BEEP	;
	POP	D	;
	DCR	B	;
	JNZ	BEEP0	;
	POP	PSW	;
	RET		;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	��������  �������  ������� ������� � ����������	;;
;; ��������� ASCII ��� � �������� "�"			;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Key_Wait:
	CALL	Input_Key		;
	INR	A		;
	JZ	Key_Wait	;
	DCR	A		;
	RET			;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     ��������� ������ ���� ������� �� �������� ������	;;
;; ���� ����� ���� �� ������������ 0xFF			;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Input_Key:
	PUSH	B	;
	PUSH	D	;
	PUSH	H	;
	LXI	H,Key_Seek;
	MVI	C,255	;
	DI		;
	DCR	M	;
	JZ	INQ	;
	MOV	B,M	;
	INX	H	;
	MOV	C,M	;
	EI		;
	MOV	D,H	;
	MOV	E,L	;
IN0:			;
	INX	H	;
	MOV	A,M	;
	STAX	D	;
	INX	D	;
	DCR	B	;
	JNZ	IN0	;
	DCR	M	;
INQ:			;
	EI		;
	INR	M	;
	MOV	A,C	;
	POP	H	;
	POP	D	;
	POP	B	;
	RET		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	�������� ������������ ����� ����������		;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Key_Reset:
	MVI	A,1	; ��������� ���������� �� �����.
	STA	Key_Seek;
	RET		;


BTEXT:
	DB	CR,CR,CR
TEXT_END:
	DB	STOPBYTE

VERSION:
	DB	6,7,' ',0F7h,0C5h,0D2h,0D3h,0C9h,0D1h,' 2.50 ',7,8,CR
	DB	6,7,' ',0F0h,0C9h,0CDh,0C5h,0CEh,0CFh,0D7h,' '
	DB	0F0h,0C1h,0D7h,0C5h,0CCh,' ',0D0h,0D2h,0C5h,0C4h,0D3h
	DB	0D4h,0C1h,0D7h,0CCh,0D1h,0C5h,0D4h,' ',7,8,CR
POD1:	DB	6,7,' 00000/000 Mode:Edit ',7,8,CR
	DB	6,7,' Text1 :noname  .txt ',7,8,CR
	DB	15,'1-Insert',15,' 2-File ',15,' 3-Goto '
	DB	15,'4-Search',15,'5-Servis',15,' 6-Info '
	DB	15,'7-Delete',15,CR
	DB	'Message:',CR
	DB	6,7,7,8,CR


;��������� 06.01.94�
AVT:	DB	31,0EAH,0C0H,0D1H,0C0H,0C6H,0C0H,0CDH
	DB	0C3H,0C0H,31,2Fh,'7',2Dh,2Fh,'2',2Dh
	DB	'83',0C6h,31
;+-------[ INVERS ]-----+
;* ����������� ����� �� *
;* (HL) -������:(D)	*
;* 	-������:(�)	*
;+----------------------+
INV:		PUSH	B	
		MOV	B,D	
		MOV	C,E	
		CALL	IV2	
		MOV	A,H	
		ADI	20H	
		MOV	H,A	
		CALL	IV2	
		POP	B	
		RET		

IV2:		PUSH	H	
IV1:		PUSH	H	
IV0:		MOV	A,M	
		CMA		
		MOV	M,A	
		INR	L	
		DCR	E	
		JNZ	IV0	
		POP	H	
		MOV	E,C	
		INR	H	
		DCR	D	
		JNZ	IV1	
		MOV	D,B	
		POP	H	
		RET		

;;;;;;;;
PPASTART:
;;
;;   ������������ �������� ����������� ����� �����
;;
		DI			;
		XRA	A		;
		OUT	10h		;
		MOV	H,A		;
		MOV	L,A		;
PPA_LOOP:				;
		MOV	M,A		;
		INR	L		;
		JNZ	PPA_LOOP	;
		INR	H		; HL=100h -> SP
		SPHL			;
		ADI	0C3h		;
		STA	0038h		;
		STA	0000h		;
		LXI	D,1900h		;
		PUSH	D		;
		POP	B		;
PPA_CONTR_LOOP:
		MOV	A,M		;
		ADD	B		;
		MOV	B,A		;
		INX	H		;
		MOV	A,C		;
		SUB	M		;
		MOV	C,A		;
		DCX	D		;
		INX	H		;
		MOV	A,D		;
		ORA	E		;
		JNZ	PPA_CONTR_LOOP	;
		PUSH	B		;
		POP	H		;
VZLOM_CONTR:
		NOP			;
		NOP			;
		NOP			;
		SHLD	0003h		;
		LXI	H,IM_ZG		;
		LXI	B,800h		;
		LXI	D,W_Zg		;
		CALL	I_REMOVE	;
		LXI	H,Key_Interrupt	;
		SHLD	0039h		;
		EI			;
;;;;;;;;;;; ���� ���������� �������� ;;;;
		LXI	D,0	;
		LXI	H,3F1Eh	;
		CALL	Cls_XY	;
		LXI	D,102h	
		LXI	H,3E1Fh
		CALL	Box_XY	
		DCR	L	
		CALL	Box_XY	
		MVI	D,3	
		DCR	L	
		XCHG		
		MVI	B,27	
		CALL	STL2	
		MVI	A,9CH	
		LXI	D,11EH
		CALL	Put_XY_Char	
		MVI	D,3EH	
		MVI	A,89H	
		CALL	Put_XY_Char	
		LXI	D,2902H
		LXI	B,VERSION
		CALL	W_DOP_PUTS
		MVI	D,05h
		CALL	W_DOP_PUTS
		LXI	D,51EH	
		CALL	W_DOP_PUTS	
		MVI	D,21H	
		CALL	W_DOP_PUTS	
		LXI	H,3F1FH	
		SHLD	W_2Window	
		LXI	H,EDITING
		PUSH	H
		LXI	H,0	
		SHLD	W_1Window	
		MOV	D,H	
		MOV	E,L	
		CALL	INFO	
		PUSH	B	
		LXI	D,51FH	
		CALL	W_DOP_PUTS	
		POP	B	
		MVI	D,36H	
		CALL	W_DOP_PUTS	
		LXI	H,AVT0	
		PUSH	H	
		LXI	H,AVT+20
		LXI	B,1715H	
BL8:		LXI	D,71FH	
		CALL	SPPAR	
		MOV	A,M	
		INR	A	
		CALL	Put_XY_Char	
		DCX	H	
		XTHL		
		MVI	D,20H	
		CALL	SPPAL	
		MOV	A,M	
		INR	A	
		MVI	D,37H	
		CALL	Put_XY_Char	
		INX	H	
		XTHL		
		DCR	C	
		JNZ	BL8	
		POP	H	
		LXI	H,203H	
		SHLD	W_1Window	
		LXI	H,3D1DH	
		SHLD	W_2Window	
		LXI	H,Restart
		SHLD	0001h
		RET		
;+-------[ INFO ]-------+
;* ������ '������'	*
;+----------------------+
INFO:		CALL	W_DOP_PUTS	
		INR	E
		MVI	D,1	
		CALL	W_DOP_PUTS	
		LXI	H,0A000H
		LXI	D,2008H	
		CALL	INV	
		RET
;;; �������������� ��������� ;;;
W_DOP_PUTS:
	CALL	WPUTS1
	INX	B
	RET
;PPA-EDITOR
AVT0:		DB	31,'Sgd',31,'OO@',31,'Sdws',31
		DB	'Dchsnq',31
;+------[ SPPAR ]-------+
;* �������� �� (DE) (B)	*
;* ����. ������ � ����� *
;+----------------------+
SPPAR:		PUSH	D	
		PUSH	B	
		PUSH	PSW	
		MOV	A,D	
		ADD	B	
		DCR	A	
		MOV	D,A	
SP0:		DCR	D	
		CALL	Get_XY_Char	
		INR	D	
		CALL	Put_XY_Char	
		DCR	D	
		DCR	B	
		JNZ	SP0	
		POP	PSW	
		POP	B	
		POP	D	
		RET		
;+-----[ SPPAL ]--------+
SPPAL:		PUSH	D	
		PUSH	B	
		PUSH	PSW	
SL0:		INR	D	
		CALL	Get_XY_Char	
		DCR	D	
		CALL	Put_XY_Char	
		INR	D	
		DCR	B	
		JNZ	SL0	
		POP	PSW	
		POP	B	
		POP	D	
		RET		
IM_ZG:
	END
