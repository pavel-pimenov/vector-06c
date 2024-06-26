	Title	STW.ASM	;
Start_PPA:
	DI		;
	XRA	A	;
	OUT	10h	;
	MVI	A,0C3h	;
	STA	0038h	;
	LXI	H,Key_Interrupt
	SHLD	0039h	;
	EI		;
	LXI	D,0604h	;
	LXI	H,2509h	;
	MVI	A,16h	;
	CALL	W_Open	;
	LXI	D,0106h	;
	MVI	A,70	;
	MVI	B,40	;
STLOOP1:		;
	INR	A	;
	CALL	Put_XY_Char
	INR	D	;
	DCR	B	;
	JNZ	STLOOP1	;
	CALL	W_Right_Scroll
	JMP	$-3	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;��������� ������ �������������� ����� � ����������� BC;;
W_INX_Puts:		;
	CALL	W_Puts	;
	INX	B	;
	RET		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����� ����� ��� ����� ����������� �������� � ����.	;;
W_Local_Puts:		;
	PUSH	H	;
	PUSH	D	;
	PUSH	PSW	;
	JMP	W_Puts_Done
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     ��������� ������ ������ ������� � ������� PPA	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
W_Puts:			;
	PUSH	H	;
	PUSH	D	;
	PUSH	PSW	;
	LDA	Ofset	;
	PUSH	PSW	;
	CALL	Str_Seek_Move
	POP	PSW	;
W_Puts_Done:		;
	ANI	07h	;
	SUI	02h	;
	LHLD	W_2Window;
	INR	H	;
	MOV	L,A	;
	CALL	Abs_DE	;
W_Puts_01:		;
	LDAX	B	;
	CPI	CR	;
	JZ	W_Puts_Quit
	CPI	9h	;
	JNZ	W_Puts_04	
W_Puts_02:
	XRA	A	
	CALL	Put_XY_Char	
	INR	D	
	MOV	A,D
	CMP	H
	JNC	W_Puts_Quit
	ADD	L	
	ANI	7h	
	JNZ	W_Puts_02	
	JMP	W_Puts_03	
W_Puts_04:
	CALL	Put_XY_Char
	INR	D	;
W_Puts_03		;
	INX	B	;
	MOV	A,D	;
	CMP	H	;
	JC	W_Puts_01
W_Puts_Quit:		;
	XCHG		;
	SHLD	End_Line;��������� ����� ������
	POP	PSW	;
	POP	D	;
	POP	H	;
	RET		;

	External Buf_Begin  ; ������ ������ ����.
	External W_Zg	    ; ������ ���������������.
	External W_Emul_Txt ; ������� �������� ������.

;;;;;;;; ������� �������������� ������� �������� ;;;;;;;;;
	External W_Put_Char	;����� ������� �����. � 'DE'
	External W_Get_Char	;������ ������� -//-
	External W_Open		;�������� ���� (DE),(HL),�-����
	External W_Close  	;�������� ����
	External W_Cls		;�������� ����
	External W_Up_Scroll	;��������� ���� �����
	External W_Down_Scroll	;����
	External W_Right_Scroll	;������ (�� 2 �������)
	External W_Left_Scroll	;�����  (�� 2 �������)
	External Put_XY_Char	;
	External Get_XY_Char	;
	External Cls_XY		;
	External Box_XY		;
	External Abs_DE		;
	External Inc_Copy	;
	External Dec_Copy	;
	External HL_DE_Window	;
	External HL_Sub_DE	;
	External Addr_Screen	;
;;;;;;;;;;;;;;; ����������� ���������� ����� ;;;;;;;;;;;;;
	External W_Cursor	;
	External W_1Window	;
	External W_2Window	;
	External W_Number	;
	External W_Buf_Seek	;
	External Beep_Key	; ��������� ������� ���� "������"
	External Input_Key	; ��������� ��� ������� �� ������
	External Key_Interrupt	; ���������� ����������.
	External Key_Reset	; ����� ����������.
	External Key_Wait	; �������� �������.
	External Flag_Color	; ���� ���������� ���������������
	External Color		; ��� �������� �����.
	External Stat_RUS_LAT	; ������ ���������� �� ��������
	External Stat_Small	; ---//----//----//--- ��������
	External Key_Seek	; ��������� ����������
	External Key_Kode	; ������������ ��� ����������
	External Key_Number	; ���������� ����� �������
	END

