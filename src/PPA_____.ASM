	ORG	0000h
;;
;; //////// 15.04.1993 ///////////////////////////////////
;; //  (C) 1993  Караганда  КптИ  ЭА-91-2  Пименов П.А	//
;; //							//
;; // ====== 52-81-95 ======== PPA Soft Systems ======	//
;; //		Copyright  by  Пименов Паша		//
;; ////// "Шел дождь на остановки" ///////////////////////
;;
	Include	MACRO.PPA	; Макоподстановки
	External	W_ZG	;

	XRA	A		;
	DI			;
	LXI	SP,100h		;
	OUT	10H		;
	CALL	SCREEN_CLS	;
	LXI	H,KEY_INT	;
	MVI	A,0C3h		;
	STA	38h		;
	SHLD	39h		;
	EI			;
	HLT			;
	DI			;
	LXI	D,0101h		;
	LXI	H,3E0Fh		;
	LXI	B,INTEG		;
	CALL	BORT		;
	LXI	B,DOUBLE	;
	LXI	D,0302h		;
	LXI	H,3C07h		;
	CALL	BORT		;
	MVI	B,36h		;
	INR	D		;
	INR	D		;
	CALL	GOR_STREL	;
	LXI	B,INTEG		;
	LXI	D,030Bh		;
	LXI	H,160Eh		;
	CALL	BORT		;
	MVI	A,1		;
	CALL	TEN		;
	LXI	D,1A09h		;
	LXI	H,3B0Eh		;
	LXI	B,INTEG		;
	CALL	BORT		;
	MVI	A,3		;
	CALL	TEN		;
	LXI	D,0702h		;
	LXI	B,PPA_00	;
	CALL	PUTSXY_Z	;
	LXI	D,0806h		;
	CALL	PUTSXY_Z	;
	DCR	E		;
	CALL	PUTSXY_Z	;
	DCR	E		;
	CALL	PUTSXY_Z	;
	DCR	E		;
	MVI	H,30h		;
	MVI	A,'~'		;
BEG_00:
	CALL	PUTCXY		;
	INR	D		;
	DCR	H		;
	JNZ	BEG_00		;
	LXI	D,1D0Dh		;
	CALL	PUTSXY_Z	;
	DCR	E		;
	CALL	PUTSXY_Z	;
	DCR	E		;
	CALL	PUTSXY_Z	;
	DCR	E		;
	MVI	H,1Bh		;
	MVI	A,'~'		;
BEG_02:
	CALL	PUTCXY		;
	INR	D		;
	DCR	H		;
	JNZ	BEG_02		;
	LXI	D,050Fh		;
	CALL	PUTSXY_Z	;
	LXI	D,070Dh		;
	CALL	PUTSXY_Z	;
	DCR	E		;
	CALL	PUTSXY_Z	;
	EI			;
	XRA	A		;
BEG_06_LOOP:
	HLT			;
	DCR	A		;
	JNZ	BEG_06_LOOP	;
BEG_05_LOOP:
	LDA	KEY_KOD		;
	INR	A		;
	JZ	BEG_05_LOOP	;
	MVI	B,1Ah		;
BEG_LOOP:
	LXI	D,0403h		;
	LXI	H,3B06h		;
	CALL	SCROL4		;
	LXI	D,1C0Ah		;
	LXI	H,390Dh		;
	CALL	SCROL3		;
	DCR	B		;
	JNZ	BEG_LOOP	;
	CALL	SCREEN_CLS	;
	DI			;
	LXI	SP,000		;
	JMP	107		;
	RET			;
PPA_00:
	DB	" (C)(R)13.10.1992 ",0BDh,0BEh,0BFh
	DB	" PPA Soft Systems Laboratory ",0
PPA_01:
       DB     0E5h,0D3h,0CCh
       DB     0C9h,020h,020h,020h,0D7h,0D9h,020h,020h,0C8h
       DB     0CFh,0D4h,0C9h,0D4h,0C5h,020h,020h,0D0h,0CFh
       DB     0CCh,0D5h,0DEh,0C9h,0D4h,0D8h,020h,020h,0C4h
       DB     0CFh,0D3h,0D4h,0D5h,0D0h,020h,020h,0CBh,020h,020h
       DB     0CFh,0C2h,0DBh,0C9h,0D2h,0CEh,0CFh,0CAh
       DB     00h
       DB     0C2h,0C9h,0C2h,0CCh,0C9h,0CFh
       DB     0D4h,0C5h,0CBh,0C5h,020h,020h,020h,0D0h
       DB     0D2h,0C9h,0CBh,0CCh,0C1h,0C4h,0CEh,0D9h
       DB     0C8h,02Ch,020h,020h,0D3h,0C9h,0D3h,0D4h
       DB     0C5h,0CDh,0CEh,0D9h,0C8h,020h,020h,020h
       DB     0C9h,020h,020h,0C9h,0C7h,0D2h,0CFh,0D7h
       DB     0D9h,0C8h,00h
       DB     0D0h,0D2h,0CFh,0C7h
       DB     0D2h,0C1h,0CDh,0CDh,020h,0C4h,0CCh,0D1h
       DB     020h,0F0h,0FCh,0F7h,0EDh,020h,020h,022h
       DB     0F7h,0C5h,0CBh,0D4h,0CFh,0D2h,020h,030h
       DB     036h,0E3h,022h,02Ch,020h,020h,0D4h,0CFh
       DB     020h,020h,0DAh,0D7h,0CFh,0CEh,0C9h,0D4h
       DB     0C5h,02Eh,02Eh,02Eh,00h
PPA_02:
       DB     05Fh,05Fh,05Fh,05Fh,05Fh,05Fh,020h,0EEh
       DB     0C1h,0DBh,0D9h,020h,0D4h,0C5h,0CCh,0C5h
       DB     0C6h,0CFh,0CEh,0D9h,03Ah,05Fh,05Fh,05Fh
       DB     05Fh,05Fh,05Fh,00h
       DB     020h,035h,032h,02Dh
       DB     038h,031h,02Dh,039h,035h,020h,020h,020h
       DB     0F0h,0C9h,0CDh,0C5h,0CEh,0CFh,0D7h,020h
       DB     0F0h,0C1h,0D7h,0C5h,0CCh,00h
       DB     020h,037h
       DB     035h,02Dh,035h,038h,02Dh,039h,033h,020h
       DB     020h,020h,0E7h,0CFh,0CCh,0D5h,0CEh,0CFh
       DB     0D7h,020h,0E1h,0CEh,0C4h,0D2h,0C5h,0CAh
       DB     00h
PPA_03:
	DB	6,7,20h
       DB     0EBh,0C1h,0D2h,0C1h,0C7h,0C1h,0CEh,0C4h
       DB     0C1h,020h,031h,039h,039h,032h,020h,0DAh
       DB     0C1h,0D3h,0D4h,0C1h,0D7h,0CBh,0D5h,020h
       DB     0D2h,0C1h,0DAh,0D2h,0C1h,0C2h,0CFh,0D4h
       DB     0C1h,0CCh,020h,020h,0F0h,0C9h,0CDh,0C5h
       DB     0CEh,0CFh,0D7h,020h,0F0h,0C1h,0DBh,0C1h
       DB     20h,7,8,00h
PPA_04:
	DB	"Good luck !!!",0
	DB	"See you soon.",0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	    Исхдный текст сервисных процедур.		;;
;;++++++++++++++++++++++++++++++++++++++++++++++++++++++;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура получения дополнительного кода для	;;
;; регистровой пары: DE					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NEG_DE:			;
	MOV	A,D	;
	CMA		;
	MOV	D,A	;
	MOV	A,E	;
	CMA		;
	MOV	E,A	;
	INX	D	;
	RET		;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     Процедура вывода ASCIIZ строки в абс. координаты	;;
;; DE - координаты.					;;
;; BC - указатель на строку символв.			;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PUTSXY_Z:
	PUSH	D		;
	PUSH	PSW		;
PUTS_LOOP:
	LDAX	B		;
	INX	B		;
	ORA	A		;
	JZ	PUTS_EXIT	;
	CALL	PUTCXY		;
	INR	D		;
	JMP	PUTS_LOOP	;
PUTS_EXIT:
	POP	PSW		;
	POP	D		;
	RET			;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура фирменой отчистки экрана.		;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SCREEN_CLS:
	IN	3		;
	MOV	L,A		;
	LXI	B,0		;
SCRECLS0:
	MVI	H,0A0H		;
SCRECLS:
	MOV	M,B		;
	INR	H		;
	MOV	A,H		;
	CPI	0E0H		;
	JNZ	SCRECLS		;
	MOV	A,L		;
	DCR	L		;
	OUT	3		;
	INR	C		;
	JNZ	SCRECLS0	;
	RET			;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура рисует вертикальную стрелку		;;
;; DE - координаты стрелки.				;;
;; B  - размер стрелки.					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
VER_STREL:
	PUSH	D	;
	PUSH	PSW	;
	MVI	A,3	;
	CALL	PUTCXY	;
	DCR	B	;
	DCR	B	;
	INR	A	;
ST0:
	DCR	E	;
	CALL	PUTCXY	;
	DCR	B	;
	JNZ	ST0	;
	DCR	E	;
	INR	A	;
	CALL	PUTCXY	;
	POP	PSW	;
	POP	D	;
	RET		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура рисует горизонтальную стрелку		;;
;; DE - координаты.					;;
;; B  - размер.						;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GOR_STREL:
	PUSH	D	;
	PUSH	PSW	;
	MVI	A,6	;
	CALL	PUTCXY	;
	INR	A	;
	DCR	B	;
	DCR	B	;
PA0:
	INR	D	;
	CALL	PUTCXY	;
	DCR	B	;
	JNZ	PA0	;
	INR	A	;
	INR	D	;
	CALL	PUTCXY	;
	POP	PSW	;
	POP	D	;
	RET		;
;;;;;;;;;;;;;;;;;;;;;;;;;
;; Караганда  т. 52-81-95 	/* PPA Soft Systems */
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Пакет  предназнечен  для склейки с другими про-	;;
;; цессами  которым  требуется  работать  с клавиатурой	;;
;; кроме  этого  драйвер производит начальную установку	;;
;; режима  экрана  ( 512 * 256  - 2 цвета дновременно )	;;
;; адреса экранной области: 0A000h - 0DFFFh.		;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	Public	KEY_INT	; обработчик прерывания.
	Public	COLOR	; код текущего цвета.
	Public	KEY_KOD	; динамический код клавиатуры
	
;;////////// рабочие ячейки KEYBOARD.DRIVE ////////
COLOR:	DW	0FF00H	
KEY_KOD: DB	255	;сод.код клавиши наж в данный момент

;; ================ 21:55 "Good luck "================

KEY_INT:
	PUSH	B	; Произвожу полное сохранение
	PUSH	D	; состояния процессора в момент
	PUSH	H	; возникновения прерывания
	PUSH	PSW	;
	LHLD	COLOR	; Читаю два байта физических цветов
	LXI	D,100FH	; фона и переднего плана
KEY_00:
	MOV	A,E	; H - цвет ПЕРДНЕГО ПЛАНА
	OUT	02	; L - цвет ФОНА
	ANI	06	; и переходим к распределению
	MOV	A,L	; етих байтов в соответствии
	JZ	KEY_01	; с математематическими цветами
	MOV	A,H	;
KEY_01:
	OUT	0FH	; производим многократную запись
	DCR	E	; полученого кода в связи с малой
	OUT	0FH	; скоростью работы ОЗУ -К155РУ2-
	OUT	0FH	;
	OUT	0FH	;
	DCR	D	;
	OUT	0FH	;
	JNZ	KEY_00	;
	MVI	A,8AH	; Настраиваем системный порт на
	OUT	00	; сканирование клавиатуры
	XRA	A	; выдаем на матрице запрос о наж-
	OUT	03	; атых клавишах
	IN	02	; 
	STA	KEY_KOD	;
	MVI	A,88h	;
	OUT	00h	;
	MVI	A,0FFh	;
	OUT	03h	;
	MVI	A,10h	;
	OUT	02h	;
	POP	PSW	;
	POP	H	;
	POP	D	;
	POP	B	;
	EI		;
	RET		;
;;	/* 31.03.1993 PPA Systems Utilites */
;;
;;
;;	+----[ 13.10.1992 ]-------------[ караганда ]---+
;;	!  автор:	Пименов П.А.			!
;;	!	"Драйвер оконного интерфейса"		!
;;	! обеспечивает вывод символьной информации в	!
;;	! так называемые "окна" реализованы следующие	!
;;	! операции:	вывод одиночного символа	!
;;	!		организация всплывающих окон	!
;;	!		отчистка окон (областей экрана)	!
;;	!		чтение символа в зад. позиции	!
;;	! координаты:	оконные	(относительные)		!
;;	!		экранные (абсол`тные)		!
;;	!________ распределение рон процессора__________!
;;	!	DE  ->  коорд. вывода символа либо указ.!
;;	!		лев. нижнего угла окна (области)!
;;	!		D -> горизонтальная координата	!
;;	!		E -> вертикальная --//-- (Y)	!
;;	!	HL  ->	коорд.прав. верхн. угла окна 	!
;;	!	BC  ->	указатель на строку симжолов	!
;;	!	A   ->	флаг окна			!
;;	!	+---+---+---+---+---+---+---+---+	!
;;	!	! 7 ! 6 ! 5 ! 4 ! 3 ! 2 ! 1 ! 0 !	!
;;	!	+---+---+---+---+---+---+---+---+	!
;;	!	опицание битов флага:			!
;;	!		(D0-D1):  вид "тени"		!
;;	!			00 -> отсутствует	!
;;	!			01-11 -> 1-3 типы	!
;;	!		(D2-D3):  вид "рамки"		!
;;	!			00 -> отсутствует	!
;;	!			01 -> одинарная		!
;;	!			10 -> двойная		!
;;	!			11 -> тоже одинарная	!
;;	!		   (D4):  паритет окна		!
;;	!			0  -> без востановления	!
;;	!			1  -> с востановлением	!
;;	+------[ OBJ: 06D0H ]----------[ End remark ]---+



DOUBLE:         DB	098h,099h,08Bh,08Ch,08Ah,09Dh
INTEG:		DB	090h,0AAh,08Fh,0A9h,083h,094h

;+--------[ тень ]------+
;* вход:  DE,HL -WINDOW *
;+----------------------+
TEN:
	PUSH	H	;
	PUSH	D	;
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
	RET		;
;
;+--------------[ DRAW BOARD ]----------+
;*	вход:	DE,HL -> коорд.окна	*
;*		A -> флаг		*
;+--------------------------------------+
BORT:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
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
;*  глобальные вспомогат. подпрогр.*
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

;+-----[ проуедура отчистки окна ]------+
;*	вход:	DE,HL -> WINDOW COORD	*
;+--------------------------------------+
CLS:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
	CALL	HL_SUB_DE	
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
	CALL	ADDRSC	
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
	JMP	NEXT

;+--------[ STOLB ]---------+
STOLB:
	PUSH	D	
	PUSH	B	
	MVI	A,' '	
ST1:
	CALL	PUTCXY	
	INR	E	
	DCR	C	
	JNZ	ST1	
	POP	B	
	POP	D	
	RET		

;+--------[ SCROLL WINDOW ]---------+
;*    процедуры скролинга окон 	    *
;+----------------------------------+
;ъъъъъъъъъъъъъъ  вправо ъъъъъъъъъъъъъ
SCROL3:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
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
;ъъъъъъъъъъъъъъ влево ъъъъъъъъъъъъъ
SCROL4:
	PUSH	B	
	PUSH	D	
	PUSH	H	
	PUSH	PSW	
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



	END

