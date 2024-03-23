;;					;;
;;	Include		MACRO.PPA	;;

;; The PPA Text Editor v 2.00 Special for System_Tehcnic.Ltd ;;

;;	Date 14.04.1994			;;
Debug	EQU	0	; 1 - защита установлена.
			; 0 - защина не установлена.
	JMP	PPASTART

W_Zg		EQU 0E000h	;начало знакогенератора
W_Emul_Txt	EQU 0E800h	;начало области эмуляции
Buf_Begin	EQU 0F000h	;начало буфера окон
Cursor_Zise	EQU 08h		; Размер курсора.

STR_CR		EQU 0F200h	;
STR		EQU 0F201h	; буфер строки.
BUF_ETALON	EQU 0F302h	;- буферы для работы системы
BUF_PODM	EQU BUF_ETALON+20 ;- поиска.
DUMP_GUT	EQU BUF_PODM+20   ;Буфер для работы с блками.
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
Cur_Flag	EQU 002Bh	; "DB" 2 Ячейки организации режима
Cur_Timer	EQU 002Ch	; "DW" мерцания курсора.
Box_Control_PTR	EQU 002Eh	; "DW" временая ячека Box_XY
OFSET		EQU 0030h	; "DB" смещене в основном окне.

STOPBYTE	EQU 0FFh	;идентифекатор "конец текста"
ESC		EQU 1Bh		;Код для ESC последовательностей
STACKSEG	EQU 100h	;указатель верхушки стека
TEXT_LIMIT	EQU 9FFFh	;конец текста
CR		EQU 0Dh		;

	Public	WJHEX		; 2 Процедуры вывода шестнадцеричного
	Public	JHEX		; числа сод в аккамуляторе.
	Public	SOOBF		; сообщение "Out of memory"
	Public	OFSET		; Смещение "окна" 
	Public	CCLEFT		; Переход к началу строки
	Public	CURHY		; 2 переменные указывают полодение
	Public	CURDY		; курсора по тексту.
	Public	MOVE		; Поцедура перемещения.
	Public	SINC		; 2 Процедуры перемещения по тексту
	Public	SDEC		; ---//----//-----//---
	Public	I_REMOVE	; 2 Процедуры копирования памяти
	Public	D_REMOVE	; из одной области в другую
	Public	WARNING		; Выдача сообщения.
	Public	SV_VARIAL	; Процедура изменения параметров.
	Public	W_DOP_INX	; Дополнительный вход для постр. меню
	Public	F_3EXIT		; ВЫХОД с корекцией указ DY
	Public	INCX		;-!
	Public	INCY		; !\ Процедуры управление м показаний
	Public	DECX		; !/ положения курсора в тексте.
	Public	DECY		;-!
	Public	RS_STR		; Рестарт буфера строки
	Public	US_OPEN		; Открытия окна Menu,F4-Esc
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
;;	Макроподстановка генерации кода
;; соответствующего руским буквам в PPA
;; системе.
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
;;подпрограммы вызывающие процедуру REGENER не должны засорять до этого стек
;;

PUT_CONST:	DB	33h	; Константа записи на магнитофон.
GET_CONST:	DB	4Bh	; Константа чтения с магнитофона.
;BUF2_TIME:	DW	0000h	; Ячейка определения частоты мигания.
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
;; блок проверки контрольных сумм╝
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
	JZ	P_KEY_DONE	; Маркер не установлен.
	LHLD	BUF2_TIME	; Увеличем програмный счетчик времени
	INX	H		;
	SHLD	BUF2_TIME	;
	MOV	A,H		;
	SUI	14		;
	JNZ	P_KEY_DONE	; Если время не вышло то не инвертир.
;; Настало время произвести инверсию слова "View"
;; для получения эффекта мигания.
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
	JZ	LOOPKEY		; Клавиша не нажата.		
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
	CC	PLAY		; ПИКАЕМ если меньше.
	RC			; и выходим	
	CPI	0Bh		; F1 - ???
	JZ	P_0DONE		;
	CPI	0Dh		; F3 - ???
	JZ	P_0DONE		;
	CPI	09h		;
	CNC	PLAY		;
	RNC			;
P_0DONE:
	IN	01H	; Берем статус из порта "С"
;; При нарушение в коде производится уничтожение системы.
PPA_PROTECT:
	STA	KORBUF	;
	MOV	C,A
	ANI	40H	;выделить сканкод "ус"
	MOV	A,B
	JZ	USADDX	;обработать ус+
	CPI	10H
	JNC	BYKVA
	MOV	A,C
	ANI	20H	;выделить сканкод "CC"
	MOV	A,B
	JZ	CCADDX	;обработать CC+...
	ORA	A
	JZ	BYKVA	;Табуляция
	CPI	07H	;вниз
	JZ	DON	
	CPI	05H	;вверх
	JZ	UP	
	CPI	06H	;вправо
	JZ	RIGHT	
	CPI	04H	;влево
	JZ	LEFT
KEYDONE:
	CPI	0CH	;F2-Delete
	JZ	DELETE
	CPI	0Bh	;F1-Begin Block
	JZ	BL_BEGIN
	CPI	0Dh	;F3-End Block
	JZ	BL_END
	CPI	03H	;забой
	JZ	ZABOY
	CPI	08H	;домой
	JZ	DOMOY
	CPI	2H	;Enter
	JZ	ENTER
	RET	

;%%%%%%%%%%%%% CC + клавиши %%%%%%%%%%%%%%%

CCADDX:
	LXI	H,Key_Reset
	PUSH	H
	CPI	05H	;CC+вверх
	JZ	CCUP
	CPI	07H	;CC+вниз
	JZ	CCDON
	CPI	04H	;CC+влево
	JZ	CCLEFT
	CPI	06H	;CC+впрово
	JZ	CCRIGHT
	CPI	0CH	;CC+F2 - удаление текущей строки
	JZ	CCDELETE
	JMP	KEYDONE	;иначе функции не изменились


F_S00:	Rus_DB	Чтение_Файла
	DB	CR
	Rus_DB	Запись_Файла
	DB	CR
	Rus_DB	Подгрузка
	DB	CR
F_S10:	Rus_DB	Файл
	DB	':',CR

S_SOOBHLP3:
	Rus_DB	Продолжить
	DB	" ?",CR

S_SOOBHLP2:
	DB	6,7,' '
	Rus_DB	управление
	DB	' ',6,7,' ',7,8
	DB	' ',7,8,CR

S_SOOBHLP:
	Rus_DB	Просмотр
	DB	CR

S_SOOB1:
	Rus_DB	Продолжить_поиск
	DB	CR


	Rus_DB	Закончить_поиск
	DB	CR

S_SOOB2:
	Rus_DB	Не_заменять
	DB	CR

	Rus_DB	Заменить
	DB	CR
	
ETALON:	Rus_DB	Найти
	DB	':',CR

PODMENA:
	Rus_DB	Замана
	DB	':',CR
I_SOOB1:
	Rus_DB	Размер_файла
	DB	':',CR

	Rus_DB	Свободно
	DB	':',CR

	DB	"H "
	Rus_DB	Байт
	DB	CR

PPAYESNO:	DB	6,7,' Yes/No ',7,8,0
F4ESC:		DB	6,7,' F4-Esc ',7,8,0


WARNGOTO:
	Rus_DB	Номер_строки
	DB	':',CR
SOOBL:	DB	'Home',CR
SOOBR:	DB	'End',CR
SOOBD:	DB	'Bottom',CR
SOOBV:	DB	'Top',CR


SV_TS2:	Rus_DB	 Вы_уверены
		DB	" ???",CR
;SV_TS1:	Rus_DB	Откуда
;	DB	CR
;	Rus_DB	Куда
;	DB	CR
;SV_TS0:	Rus_DB	Прописные
;	DB	CR
;	Rus_DB	Строчные
;	DB	CR
;	Rus_DB	Лат
;	DB	CR
;	Rus_DB	Рус
;	DB	CR
SV_SOOB3:
	Rus_DB	Текущее_значение
	DB	':',CR
SV_SOOB2:
	Rus_DB	Текст
	DB	CR
	Rus_DB	Фон
	DB	CR
SV_SOOB1:
	Rus_DB	Конвертер
	DB	CR
	Rus_DB	Выбор_палитры
	DB	CR
	Rus_DB	Выбор_констант
	DB	CR
;;;;;;;;;;;;;;;
;;
;; Процедура формирования дополнительного кода
;; в регистровой паре DE
;;
NEG_DE:	
		MOV	A,D		;
		CMA			; регистровую пару: DE
		MOV	D,A		; переводим в дополнительный
		MOV	A,E		; код для произвеения операции
		CMA			; вычитания
		MOV	E,A		;
		INX	D		;
		RET			;

;		INCLUDE	EDMAIN.ASM
;; 
;; Модуль содержит пакет подпрограмм написанных специально для
;; "PPA Editor" ,они активно йспользуыт подпрограммы оконного 
;; драйвера 
;; последняя модификация: 9.03.1994 г. Караганда
;;
;;
;; Процедура MENU обеспечивает создание в текущем окне меню по
;; средством перемещения инверсной полоски по всему окну и если
;; происходит переход за пределы окна то автоматически указатель
;; переходит на противоположную сторону окна. Процедура не имеет 
;; защиты от ситуации: в окне не помещается более двух альтерна- 
;; тивных строк ( меню вертикальное ) и других не коректных вызо-
;; вов.
;; Входные данные: нет
;; Выходные данные: A - возвращается позиция в которой произошло
;;			 нажатие клавиши "ВК" если была нажата кла-
;;			 виша "F4" то в А возвращается "0FFH"

MENU:		CALL	HL_DE_Window	; читаем координаты окна
		CALL	HL_Sub_DE		; вычисляем размеры окна
		MOV	A,B		; распределяем регистры
		DCR	B		;
		DCR	B		;
		MOV	D,B		;
		MOV	L,C		;
		MOV	E,L		;
		MVI	H,0		;
		DCR	L		;
		SHLD	W_Cursor		;
M_KEY_LOOP:	CALL	LINE_INV	; инвертиреум строку
		CALL	Key_Reset	; сбрасываем драйвер клавиатуры
		CALL	Key_Wait	; ожидаем нажатия
		CALL	LINE_INV	; гасим указатель
		LXI	H,M_KEY_LOOP	;
		PUSH	H		;
		CPI	05H		; клавиша вверх
		JZ	M_UP		;
		CPI	07H		; клавиша вниз
		JZ	M_DON		;
		CPI	02H		; "BK"
		JZ	M_EXIT		;
		CPI	0EH		; "F4"
		JZ	M_2EXIT		;
		RET			;
;; процедура обработки нажатия клавиши вверх		
M_UP:		LXI	H,W_Cursor	;
		INR	M		;
		MOV	A,M		;
		CMP	E		;
		RC			;
		MVI M,0			;
		RET			;
;; процедура обработки нажатия клавиши вниз
M_DON:		LXI	H,W_Cursor	;
		DCR	M		;
		MOV	A,M		;
		INR	A		;
		RNZ			;
		MOV	M,E		; если осуществляется корекция
		DCR	M		;
		RET			;

M_EXIT:		LDA	W_Cursor	; берем номер текущей строки
M_2EXIT:	LXI	H,001Ah		; курсор посылаем на... домой
		SHLD	W_Cursor	; у выходим из процедуры
		POP	H		; забираем слово из стека
		RET			;

LINE_INV:	LXI	H,W_Cursor+1	; устанавливаем указатель на
		MVI	M,1		; горизонтальную координату
LINE_I_DOP:	CALL	CINV		; и производим посимвольную
		INR	M		; инверсию всего окна
		DCR	B		;
		JNZ	LINE_I_DOP	;
		MOV	B,D		; востановим длину окна
		RET			; выход из подпрограммы

;+----------[ WINDOW PUTS ]------------+
;*	вход:	DE ->коорд.,BC -> указ.*
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
		SHLD	ENDLINE		;сохранить конец строки
		POP	PSW	
		POP	D	
		POP	H	
		RET		


;+--------[ DESJWRITE ]---------+
;* вход: HL -> указ.числа	*
;*	 DE -> координаты	*
;*	 B*2+1 -> число цифр	*
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
;* вход: A -> код		*
;*	 DE -> координаты	*
;* при относ коорд.DE преобр.	*
;* в абсолютные			*
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


;24.02.1993г. отладил процедуру MOVE работает но можно сделать
;лучше и быстрее ...ну ее на хрен надоело

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
		RNC		;переход если L>=H
		INR	L
MV3:		LDAX	B	
		CPI	9H
		JZ	MV0	;обработка табуляции
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
;;строкавый редактор производит редакцию строки в буфере STR
;;до того момента пока не нажата клавиша "вк"
;;клавишы управления :влево,вправо,зб,F2
;;входные данные: 
;;			а => длина (максимальная) до которой возможно
;;			     редактировать строку
;;			DE=> относительные координаты графики строки
;;			HL=> указатель на редактируемую строку
;;			     строка копируется в буфер STR
;
;;

EDLINE:		STA	MAXDLINNA
		CALL	COPYSDOP
		MOV	H,A		;сохраним число символов
		LXI	B,STR		;буфер строки
		XRA	A
		CALL	WPUTSDOP
		MOV	L,E
		MOV	A,D		;BC -указатель конца строки
		ADD	H
		MOV	H,A
		SHLD	W_Cursor		;установим локальный курсор
EDDO:		CALL	CINV
EDKEYLOOP:	CALL	Key_Wait
		CALL	CINV
		LXI	H,EDDO
		PUSH	H
		CPI	10H
		JNC	SYMBOLS		;нажата буква
		CPI	04H		;влево
		JZ	EDLEFT
		CPI	06H		;вправо
		JZ	EDRIGHT
		CPI	0CH		;F2-UDALENIE
		JZ	EDDELETE
		CPI	03H		;забой
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

;процедура вставки символа в стрку находящуЮся в буфере STR
EDINSERT:	LDA	MAXDLINNA
		PUSH	B
		LXI	B,STR
		CALL	MOVE
		LDAX	B
		CPI	CR
		POP	B
		CNZ	PLAY
		RNZ
		CALL	MOVEINS	;перенос с декрементом
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
		RZ		;конец строки выйти с флагом "Z" в руках
		CALL	MOVEDEL		;перенос с инкрементом
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
		ORA	A		;сброс флага
		RET
;$$$$$$$$$$$
;	BC ===> куда
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
;BC --> указатель строки симжолов куда нужно произвести вставку
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
		RZ			;выход начало строки
		DCX	B
		LXI	H,W_Cursor+1
		DCR	M
		INR	A		;сброс флага
		RET
;$$$$$$$$$$$
EDRIGHT:	LDAX	B
		CPI	CR
		RZ
		INX	B
		LXI	H,W_Cursor+1
		INR	M
		INR	A		;сброс флага
		RET

;		INCLUDE	SYMB.ASM
;; пакет процедур предназначен для обработки
;; нажатий на символьные клавиши и некоторые 
;; управляющие специально для PPA-Editor
;; сегодня: 06.12.1992 +++ 14:05 +++ воскресенье
;
BYKVA:		PUSH	PSW
		CALL	NARUSHENIE
		CALL	Key_Reset
		POP	PSW
		JNZ	BYKVA_NORM
;обработать вставку табуляции
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
		JZ	RIGERROR	;строка переполнена
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
				
;$$$$$$$$$$$$$ вставка символа $$$$$$$$$$$$
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

;%%%%%%%%%%%%% ус + клавиши %%%%%%%%%%%%%%%
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
		LDA	Key_Number		;читаем апаратный номер клавиши
		CPI	14H		;номер "4" ===== SEARCH =====
		JZ	SEARCH		;
		CPI	13H		;номер "3" ====== GOTO ======
		JZ	GOTOLINE	;
		CPI	12H		;номер "2" ====== File ======
		JZ	FILE		;
		CPI	0BH		; US + "F1" ====== Block ======
		JZ	BLOCK		;
		CPI	16H		;номер "6" ====== Info ======
		JZ	M_INFO		;
		CPI	15H		;номер "5