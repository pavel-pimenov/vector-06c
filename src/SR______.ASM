;;	Модуль перекодировки TextAsm - PPA Text Editor
	LXI	D,1204h		;
S_T_Loop:			;
	DCR	E		;
	MVI	A,7		;
	CALL	W_Put_Char	;
	INR	A		;
	INR	D		;
	CALL	W_Put_Char	;
	DCR	E		;
	DCR	D		;
	INR	E		;
	JNZ	S_T_Loop	;	
	LXI	D,0203h		;
	LXI	B,S_T_Mess_Text_Asm
	PUSH	B		;
	CALL	W_DOP_INX	;
	POP	B		;
	LXI	D,1502h		;
	CALL	W_DOP_INX	;
	PUSH	B		;
	MVI	E,0		;
	CALL	W_DOP_INX	;
	POP	B		;
	LXI	D,0201h		;
	CALL	W_DOP_INX	;
	PUSH	B		;
	DCR	E		;
	CALL	W_DOP_INX	;
	POP	B		;
	PUSH	B		;
	INR	E		;
	INR	E		;
	CALL	W_DOP_INX	;
	POP	B		;
	PUSH	B		;
	LXI	D,1503h		;
	CALL	W_DOP_INX	;
	POP	B		;
	DCR	E		;
	DCR	E		;
	CALL	W_DOP_INX	;
S_T_Loop_2:			;
	CALL	MENU		;
	CPI	0Eh		;
	CZ	W_Close		;
	RZ			;
	MOV	B,A		;
	LXI	D,2915h		;
	LXI	H,3915h		;
	CALL	S_ARE_YOU	;
	JNZ	S_T_Loop_2	;
	MOV	A,B		;
	POP	D		;
	CALL	S_Code_Convert	;
	CALL	W_Close		;
	CALL	W_Close		;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Универсалиная процедура конвертации текстов.	;;
;; A:							;;
;;	0 - PPA Text Editor 	-> RETEX		;;
;;	1 - RETEX		-> PPA Text Editor	;;
;;	2 - PPA Text Editor	-> TEXTASM		;;
;;	3 - TEXTASM		-> PPA Text Editor	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
S_Code_Convert:
	CPI	2		;
	RC			;JC	S_PR_Code	;
	CPI	3		;
	LXI	B,6020h		; PPA - TextASM
	LXI	D,80FFh		;
	JZ	S_Code_Done	;
	LXI	B,80A0h		; TextASM - PPA
	MVI	D,0E0h		;
S_Code_Done:			;
;; Теперь можно приступать к перекодировке.
;; TextASM <--> PPA Text
;;	C0 <-> 60
;;	60 <-> E0
;;	E0 <-> C0
;;
	LXI	H,BTEXT + 1	;
S_PT_Loop:
	INX	H		;
	MOV	A,M		;
	CMP	E		; Stop_Byte
	RZ			; Уйти если конец текста
	CPI	60h		;
	JC	S_PT_Loop	;
	CPI	80h		;
	JNC	S_PT_Done	;
	ADD	B		;
	MOV	M,A		;
	JMP	S_PT_Loop	;
S_PT_Done:			;
	CPI	0C0h		;
	JC	S_PT_Loop	;
	CPI	0Eh		;
	JC	S_PT_2Done	;
	ADD	D		;
	MOV	M,A		;
	JMP	S_PT_Loop	;
S_PT_2Done:			;
	ADD	C		;
	MOV	M,A		;
	JMP	S_PT_Loop	;

S_T_Mess_Text_Asm:
	DB	"TextAsm",CR
S_T_Mess_RETEX:
	DB	"RETEX",CR
S_T_Mess_PPA_Text_Editor:
	DB	"PPA Text Editor",CR

