	Title	STDIO.ASM	;

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


