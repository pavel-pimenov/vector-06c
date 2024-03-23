	Include		MACRO.PPA	;;
	External	W_ZG		;;

STOPBYTE	EQU 01AH ;идентифекатор "конец подсказки"
STACKSEG	EQU 100H ;указатель верхушки стека
CR		EQU 0Dh  ;
	JMP	PPASTART	;
DOWN:
	RET
UP:
	RET
PPASTART:
	DI			;
	MVI	A,0C3h		;
	STA	0038h		;
	LXI	SP,STACKSEG	;
	XRA	A		;
	OUT	10h		;
	LXI	H,KEY_INT	;
	SHLD	0039H		;
	LXI	H,76F3h		;
	SHLD	0000h		;
	LXI	H,0A000h	;
	MOV	B,L		;
	MVI	C,0E0h		;
PH_LOOP:			;
	MOV	M,B		;
	INX	H		;
	MOV	A,H		;
	CMP	C		;
	JNZ	PH_LOOP		;
	EI			;
	LXI	D,0100h		;
	LXI	H,3E0Fh		;
	CALL	BORT		;
	MVI	E,02h		;
	MVI	L,0Eh		;
	CALL	BORT		;
	MVI	A,9Ch		;
	CALL	PUTCXY		;
	MOV	E,H		;
	CALL	PUTCXY		;
	XCHG			;
	MVI	A,89h		;
	CALL	PUTCXY		;
	MVI	E,2h		;
	CALL	PUTCXY		;
	LXI	D,040Fh		;
	LXI	H,PH_SOOB1	;
	CALL	WPUTSZ		;
	CALL	RUN_STRING	;
	JMP	$-3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   Подпрограмма реализации эффекта "бегущая строка"	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RUN_SEEK:	DW PPA_RUN_LINE ; Указатель начала строки.
RUN_BIT:	DB 00h		; Kоличество сдвинутых битов
RUN_STRING:
	HLT
	CALL	BOX_SCROLL	;
	LDA	RUN_BIT		;
	ANI	0000011		;
	JZ	RUN_PUT_CHAR	; Необходимо вывести символ
	INR	A		;
	STA	RUN_BIT		;
	RET			;
RUN_PUT_CHAR:			;
	INR	A		;
	STA	RUN_BIT		;
	LHLD	RUN_SEEK	;
	MOV	A,M		;
	ORA	A		;
	JZ	RUN_END_LINE	; Конец бегущей строки.
	LXI	D,3B01h		;
	CALL	PUTCXY		;
	INX	H		;
	SHLD	RUN_SEEK	;
	RET			;
RUN_END_LINE:			;
	LXI	H,PPA_RUN_LINE	;
	SHLD	RUN_SEEK	;
	MVI	A,0E0h		;
RUN_E_LOOP:			;
	HLT			;
	CALL	BOX_SCROLL	;
	DCR	A		;
	JNZ	RUN_E_LOOP	;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Подпрограмма плавного сдвига строки		;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BOX_SCROLL:
	PUSH	B		;
	PUSH	D		;
	PUSH	H		;
	PUSH	PSW		;
	MVI	L,10h		;
	MVI	C,0Fh		;
B_S_LOOP:			;
	MVI	H,0BDh		;
	CALL	LINE_SCROLL	;
	MVI	H,0DDh		;
	CALL	LINE_SCROLL	;
	INR	L		;
	DCR	C		;
	JNZ	B_S_LOOP	;
	POP	PSW		;
	POP	H		;
	POP	D		;
	POP	B		;
	RET			;
;;;;;;;;;;;;;;;; Процедура сдвига линейки ;;;;;;;;;;;;;;;;
LINE_SCROLL:			;
	MVI	B,1Ch		;
	XRA	A		;
L_S_LOOP0:			;
	MOV	A,M		;
	RAL			;
	MOV	M,A		;
	DCR	H		;
	DCR	B		;
	JNZ	L_S_LOOP0	;
	RET			;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; процедура вывода строки	;;
WPUTSZ:				;
	MOV	A,M		;
	INX	H		;
	ORA	A		;
	RZ			;
	CALL	PUTCXY		;
	INR	D		;
	JMP	WPUTSZ		;
PH_SOOB1:
	DB	6,7," The help file for "
		0BDh,0BEh,0BFh
		" PPA Text Editor Version 2.00 ",7,8,0
;	DB	6,7," Present by Pimenov Pavel ",7,8,0
;	DB	6,7," Link 06.01.1994 y. ",7,8,0

LOOPKEY:	
	LXI	H,LOOPKEY
	PUSH	H
	LDA	KEYKOD
	CPI	10H
	RNC
	CPI	07H	;вниз
	JZ	DOWN	
	CPI	05H	;вверх
	JZ	UP	
	RET	
PPA_RUN_LINE:
       DB     0F7h,0D9h,020h,0D1h,0D7h,0CCh,0D1h,0C5h
       DB     0D4h,0C5h,0D3h,0D8h,020h,0D0h,0CFh,0CCh
       DB     0D8h,0DAh,0CFh,0D7h,0C1h,0D4h,0C5h,0CCh
       DB     0C5h,0CDh,020h,0D0h,0D2h,0CFh,0C7h,0D2h
       DB     0C1h,0CDh,0CDh,0D9h,020h,0BDh,0BEh,0BFh
       DB     020h,050h,050h,041h,020h,054h,065h,078h
       DB     074h,020h,045h,064h,069h,074h,06Fh,072h
       DB     020h,056h,065h,072h,073h,069h,0CFh,06Eh
       DB     020h,032h,02Eh,030h,030h,02Eh,020h,020h
       DB     0F1h,020h,020h,0C8h,0CFh,0D4h,0C5h,0CCh
       DB     020h,0C2h,0D9h,020h,0D0h,0CFh,0D0h,0D2h
       DB     0CFh,0D3h,0C9h,0D4h,0D8h,020h,0D7h,0C1h
       DB     0D3h,0D7h,0D3h,0C5h,020h,0DAh
       DB     0C1h,0CDh,0C5h,0DEh,0C1h,0CEh,0C9h,0D1h
       DB     020h,0C9h,020h,0D0h,0D2h,0C5h,0C4h,0CCh
       DB     0CFh,0D6h,0C5h,0CEh,0C9h,0D1h,020h,0CBh
       DB     0C1h,0D3h,0C1h,0C0h,0DDh,0C9h,0C5h,0D3h
       DB     0D1h,020h,0DCh,0D4h,0CFh,0CAh,020h,0D7h
       DB     0C5h,0D2h,0D3h,0C9h,0C9h,020h,0CEh,0C1h
       DB     0D0h,0D2h,0C1h,0D7h,0CCh,0D1h,0D4h,0D8h
       DB     020h,0D7h,020h,0CDh,0CFh,0CAh,020h,0C1h
       DB     0C4h,0D2h,0C5h,0D3h,02Ch,020h,0C1h,020h
       DB     0D1h,020h,0D3h,0CFh,020h,0D3h,0D7h,0CFh
       DB     0C5h,0CAh,020h,0D3h,0D4h,0D2h,0CFh,0CEh
       DB     0D9h,020h,0D0h,0CFh,0D3h,0D4h,0C1h,0D2h
       DB     0C1h,0C0h,0D3h,0D8h,020h,0D5h,0DEh,0C5h
       DB     0D3h,0D4h,0D8h,020h,0C9h,0C8h,020h,0D7h
       DB     020h,0D3h,0CCh,0C5h,0C4h,0D5h,0C0h,0DDh
       DB     0C9h,0C8h,020h,0D7h,0C5h,0D2h,0D3h,0C9h
       DB     0D1h,0C8h,02Eh,020h,0FAh,0C1h,0D2h,0C1h
       DB     0CEh,0C5h,0C5h,020h,0C2h,0CCh,0C1h,0C7h
       DB     0CFh,0C4h,0C1h,0D2h,0C5h,0CEh,02Eh,020h
;; PPA Soft ;;
       DB     020h,020h,020h,0EDh,0CFh,0CAh,020h,0C1h
       DB     0C4h,0D2h,0C5h,0D3h,03Ah,020h,0F2h,0C5h
       DB     0D3h,0D0h,0D5h,0C2h,0CCh,0C9h,0CBh,0C1h
       DB     020h,0EBh,0C1h,0DAh,0C1h,0C8h,0D3h,0D4h
       DB     0C1h,0CEh,020h,034h,037h,030h,030h,037h
       DB     035h,020h,020h,0C7h,02Eh,0EBh,0C1h,0D2h
       DB     0C1h,0C7h,0C1h,0CEh,0C4h,0C1h,020h,0D5h
       DB     0CCh,02Eh,020h,034h,030h,020h,0CCh,0C5h
       DB     0D4h,020h,0EBh,0C1h,0DAh,0C1h,0C8h,0D3h
       DB     0D4h,0C1h,0CEh,0C1h,020h,0C4h,02Eh,033h
       DB     039h,02Fh,033h,020h,0CBh,0D7h,02Eh,031h
       DB     020h,0F0h,0C9h,0CDh,0C5h,0CEh
       DB     0CFh,0D7h,020h,0F0h,0C1h,0D7h,0C5h,0CCh
       DB     020h,0E1h,0CCh,0C5h,0CBh,0D3h,0C5h,0C5h
       DB     0D7h,0C9h,0DEh,02Eh,0



;;//////// рабочие ячейки WINDOW.DRIWE //////////
WIND1:		DW	0	;; (DE) координаты окна
WIND2:		DW	3F0FH	;; (HL) ---//----//---
DOUBLE:         DB	98H,99H,8BH,8CH,8AH,9DH

;+--------------[ DRAW BOARD ]----------+
;*	вход:	DE,HL -> коорд.окна	*
;*		A -> флаг		*
;+--------------------------------------+
BORT:		PUSH	B	
		PUSH	D	
		PUSH	H	
		PUSH	PSW	
		LXI	B,DOUBLE
BORT01:		LDAX	B	
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
BORT02:		LDAX	B	
		INR	E	
		CALL	PUTCXY	
		MOV	A,E	
		CMP	L	
		JNZ	BORT02	
		POP	D	
		XCHG		
		PUSH	D	
		INR	L	
BORT03:	        LDAX	B	
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
CONT:		INR	D	
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
		JMP	MAIN_EXIT

;-----------[ MAIN HELP ]----------+
;*  глобальные вспомогат. подпрогр.*
;+---------------------------------+
HLSUBDE:	MOV	A,H	
		SUB	D	
		INR	A	
		MOV	B,A	
		MOV	A,L	
		SUB	E	
		INR	A	
		MOV	C,A	
		RET		

HLDEWIND:	LHLD	WIND1	
		XCHG		
		LHLD	WIND2	
		RET		


;+-----[ проуедура отчистки окна ]------+
;*	вход:	DE,HL -> WINDOW COORD	*
;+--------------------------------------+
HOME:		PUSH	B	
		PUSH	D	
		PUSH	H	
		PUSH	PSW	
		CALL	HLDEWIND	
HOMEDH:
		CALL	HLSUBDE	
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
HOM1:		MOV	A,H	
		RRC		
		JC	HOM2	
		XCHG		
		PUSH	D	
		MOV	E,L	
		CALL	STOLB	
		POP	D	
		XCHG		
		DCR	H	
HOM2:		MOV	A,H	
		SUB	D	
		RAR	
		INR	A	
		MOV	C,A	
		CALL	ADDRSC	
		XRA	A	
		PUSH	B	
		MOV	D,B	
		MOV	E,L	
HOM3:		MOV	M,A	
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
HOM5:		MOV	M,A	
		INR	L	
		DCR	B	
		JNZ	HOM5	
		MOV	B,D	
		MOV	L,E	
		DCR	H	
		DCR	C	
		JNZ	HOM5	
		JMP	MAIN_EXIT

;+--------[ STOLB ]---------+
STOLB:		PUSH	D	
		PUSH	B	
		MVI	A,' '	
ST1:		CALL	PUTCXY	
		INR	E	
		DCR	C	
		JNZ	ST1	
		POP	B	
		POP	D	
		RET		

;+---------[ WINDOW PUTCHAR ]-----------+
;*	вход:	DE -> координаты	*
;*		A  -> символ		*
;+--------------------------------------+
PUTCXY:   	PUSH	H	
		PUSH	D	
		PUSH	B	
		PUSH	PSW	
		MOV	B,A	
		CALL	ADDRSC	
		XCHG		
		MOV	A,H	
		RRC		
		MOV	A,B	
		MVI	B,16	
		PUSH	PSW
		PUSH	D		;определения начала знакогенератора
		MVI	H,0
		MOV	L,A	
		DAD	H	
		DAD	H	
		DAD	H	
		DAD	H	
		LXI	D,W_ZG		;указатель на знакогенератор
		DAD	D
		POP	D	
		POP	PSW
		XCHG		
		JC	SHET	
		MVI	C,0FH	
SCA:		MOV	A,M	
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
SCC:		DCX	D	
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
SHET:		MVI	C,0F0H	
SCA0:		MOV	A,M	
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
SCC0:		DCX	D	
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
NEXT:		POP	PSW	
		POP	B	
		POP	D	
		POP	H	
		RET		
;+--------[ вспомогательные процедуры ]---------+
;*       определение физических адресов		*
;+----------------------------------------------+
ADDRSC:		PUSH	PSW	
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



;;////////// рабочие ячейки KEYBOARD.DRIVE ////////
COLOR:		DW	0FF00h	
KEYKOD:		DB	255	;сод.код клавиши наж в данный момент

KEY_INT:	PUSH	B	; Произвожу полное сохранение
		PUSH	D	; состояния процессора в момент
		PUSH	H	; возникновения прерывания
		PUSH	PSW	;
		LHLD	COLOR	; Читаю два байта физических цветов
		LXI	D,100FH	; фона и переднего плана
KEY_00:		MOV	A,E	; H - цвет ПЕРДНЕГО ПЛАНА
		OUT	02	; L - цвет ФОНА
		ANI	06	; и переходим к распределению
		MOV	A,L	; етих байтов в соответствии
		JZ	KEY_01	; с математематическими цветами
		MOV	A,H	;
KEY_01:		OUT	0FH	; производим многократную запись
		DCR	E	; полученого кода в связи с малой
		OUT	0FH	; скоростью работы ОЗУ -К155РУ2-
		OUT	0FH	;
		OUT	0FH	;
		DCR	D	;
		OUT	0FH	;
		JNZ	KEY_00	;
KEY_DO0:	MVI	A,8AH	; Настраиваем системный порт на
		OUT	00	; сканирование клавиатуры
DONE01:		XRA	A	; выдаем на матрице запрос о наж-
		OUT	03	; атых клавишах
		IN	02	; 
		STA	KEYKOD	;
		MVI	A,88H	;
		OUT	00H	;
		MVI	A,0FFH	;скролинг
		OUT	03	;
		MVI	A,10H	;режим и бордюр
		OUT	02	;
MAIN_EXIT:
		POP	PSW	;
		POP	H	;
		POP	D	;
		POP	B	;
		EI		;
		RET		;
		END
