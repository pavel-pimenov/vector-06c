	Title	RE.ASM	; Version 1.00
	Include	MACRO.PPA	; My Macro #define.
;; ///////////// ������� ����� ����������. //////////////

	External	F_INPUT_NAME	;
	External	F_F_ASCII	;
	External	PPASTART	;
	External	F_F_ASCII	;
	External	BTEXT		;
	External	MENU		;
	External	TEXT_LIMIT	;
	External	ENDTEXT		;
	External	WPUTS1		;
	External	WPUTSDOP	;
	External	NULL_POS	;
	External	PRSCREEN	;
	External	COPYS		;
	External	DLINNA		;
	External	PRINT_POS	;
	External	DOMOY		;
	External	UP		;
	External	DON		;

;;///////////// KD.ASM - ������� ���������� //////////////

	External BEEP	; ������.
	External INKEY	; ����� ��� �� ������
	External KEYRESET; ����� ����������
	External KEYDELAU; ������� �������.

	External FLAGC	; ���� ���������������
	External COLOR	; ��� �������� �������
	External RUSLAT	; ������ �� ��������
;;;	External SMALL	; ������ �� ��������
	External KEYKOD; ������������ ��� ������
	External SEEK	; ��������� ����������

;;//////// WD.ASM - ������� �������� ���������� //////////

;========= �������� ������� ��������� ==========
	External GETC	;������ ������� -//-
	External ACTIV	;�������� ���� (DE),(HL),�-����
	External DEACTI  ;�������� ����
	External BORT	;���������� �����
	External HOME	;�������� ����
	External SCROL1	;��������� ���� �����
	External SCROL2	;--//-- ����
	External SCROL3	;--//-- ������ (�� 2 �������)
	External SCROL4	;--//-- ����� --//--
;;
;========== �������������� ������� ��������� ==========
;��������� ���� ������� �� ���������� ���������� ����������
;;
	External PUTCXY	
	External GETCXY	
	External RAMKA	;���� ���������� �� �����
	External TEN	;
	External CLS	
	External SCRN	
	External SCRV	
	External SCRP	
	External SCRL	
;;	External ABS_DE
	External LIIR
	External LDIR
;;	External HL_DE_WIND
;;	External HL_SUB_DE
	External NEG_DE	
	External ADDREM
	External ADDRSC	

;______________ ������� ������ ________________
	External CURSOR
	External WIND1
	External WIND2
	External NUM
;;	External BUF_SEK
	External FLAGW

	END

