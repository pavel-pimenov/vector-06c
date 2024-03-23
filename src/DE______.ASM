	Title	DE.ASM
	ORG	0000h
;;
;; ///////// 5.04.1993 ///////////////////////////////////
;; //  (C) 1993  Караганда  КптИ  ЭА-91-2  Пименов П.А	//
;; //							//
;; // ====== 52-81-95 ======== PPA Soft Systems ======	//
;; //	(C)1993	Copyright  by  Пименов Паша		//
;; ///////////////////////////////////////////////////////
;;
;; Глобальные описания находятся в конце файла.
;;
	Include	MAIN.PPA
;{
;	Include	MACRO.PPA	; Макоподстановки
;	Include	EQU.PPA		; Константы.
;	Include	EXT.PPA		; Выход на драйверы
;	Include DDR.PPA		; Дисковые константы.
;}
DE_START:
	LXI	SP,STACK_SEGMENT; Установим указатель стека
	CALL	START_PPA	; стартуем.
	JMP	TMP_DONE	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;================== US + Servise ======================;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FIND_SECTOR:
	DB 'P'	; Буфер для сектора.
FIND_HEAD:
	DB 'P'	; Буфер для стороны.
FIND_CUL:
	DB 'A'	; Буфер для трека.
FIND_FLAG:
	DB 00h	;  0 - НЕЛЬЗЯ ПРОИЗВОДИТЬ ПРОДОЛЖ. ПОИСКА
		; !0 - МОЖНО !!!.
FIND_POS:
	DB '_'	; Позиция указателя градусника.
FIND_COUNT:
	DB 'S'	; Счетчик секторов для градусника.
FIND_PTR:
	DB "OF"	; Указатель прерывания поиска.
F_COUNT_END:
	DB "T_"	; Сколько осталось до конца сектора.
FIND_BUF:
	DB 0  ; Стоповый байт.
	DB	"_(C)1993_COPYRIGHT_PIMENOV_PAVEL_"
;;;;;;; Буфер для поисковой последовательности

US_SERVISE:
	LXI	D,0D09h		;
	LXI	H,2A0Bh		;
	MVI	A,00010101b	;
	CALL	ACTIV		;
	LXI	D,0202h		;
	LXI	B,SOOB_20	;
	CALL	W_PUTSXY_Z	;
	DCR	E		;
	CALL	W_PUTSXY_Z	;
	DCR	E		;
	CALL	W_PUTSXY_Z	;
	CALL	Y_N_WRITE	;
	CALL	MENU		;
	CPI	0Eh		;
	CZ	DEACTI		;
	RZ			;
	ORA	A		;
	JZ	PAINT_SCREEN	; ===== выбор палитры =====
	DCR	A		;
	JNZ	FIND_BEGIN	; ===== начать поиск ======
FIND_DONE:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	    Блок обработки продолжения поиска.		;;
	LDA	FIND_FLAG	;
	ORA	A		;
	JZ	F_QUIT		;
	CALL	F_READ_STRING	;
	LDA	FIND_HEAD	;
	STA	HEAD		;
	LDA	FIND_SECTOR	;
	STA	SECTOR		;
	LDA	CULINDER	;
	MOV	B,A		;
	LDA	FIND_CUL	; Востановим состояние.
	CMP	B		;
	STA	CULINDER	;
	DI			;
	CNZ	SET_CULIND	; Перейти если было смещ.
	EI			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Основной цикл поиска строки.
FD_FIND_LOOP:
	CALL	IN_KEY		;
	CPI	0Eh		; Нажата "F4" ???
	JZ	F_F_INTERRUPT	; Прервать поиск программы.
	CALL	RE_PR_DISK	;
	DI			;
	CALL	DISK_READ	; Прочитаем сектор.
	EI			;
	LDA	FIND_POS	;
	MOV	D,A		;
	MVI	E,0		;
	MVI	A,081h		;
	CALL	ABS_DE		; установим "градусник"
	CALL	PUTCXY		;
	LHLD	F_COUNT_END	;
	XCHG			;
	LHLD	FIND_PTR	;
	INX	H		;
FD_LOOP_01:
	SHLD	FIND_PTR	; Сохраняем возможное
	LXI	B,FIND_BUF	; начало последовательности
;; Проведем поиск строки в считаном секторе.
FD_LOOP_02:
	DCX	D		;
	MOV	A,D		;
	ORA	E		;
	JZ	FD_LOOP_QUIT	;Выйти если кончился сектор
	LDAX	B		;
	ORA	A		;
	JZ	F_YES_FIND	;
	CMP	M		; Сравниваем с образцом.
	INX	H		;
	JNZ	FD_LOOP_01	;
	INX	B		;
	JMP	FD_LOOP_02	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FD_LOOP_QUIT:	
	LXI	H,0400h		;
	SHLD	F_COUNT_END	;
	LXI	H,BUF_DISK	;
	SHLD	FIND_PTR	;
	CALL	DISK_INC	;
;; Если флаг Carri сброшен то произошло переполнение.
	JNC	F_FIND_EXIT	;
	LDA	FIND_COUNT	;
	INR	A		;
	STA	FIND_COUNT	;
	CPI	20		;
	JC	FD_FIND_LOOP	;
	LDA	FIND_POS	;
	INR	A		;
	STA	FIND_POS	;
	XRA	A		;
	STA	FIND_COUNT	;
	JMP	FD_FIND_LOOP	;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Блoк обработки начала поиска строки по всему диску	;;
FIND_BEGIN:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;	Переходим к процедуре глобального поиска. ;;;;;;;;
	XRA	A		;
	STA	FIND_COUNT	;
	INR	A		;
	STA	FIND_POS	;
	CALL	F_READ_STRING	; Получим с консоли строку.
	DI			; ОНА ВОЗВРАТИТ 0x00
	CALL	SET_CULIND	;
	EI			;
	STA	CULINDER	;
	INR	A		;
	STA	SECTOR		;
	LDA	HEAD		;
	ORI	4		;
	STA	HEAD		;
F_FIND_LOOP:
	CALL	IN_KEY		;
	CPI	0Eh		; Нажата "F4" ???
	JZ	F_F_INTERRUPT	; Прервать поиск программы.
	CALL	RE_PR_DISK	;
	DI			;
	CALL	DISK_READ	; Прочитаем сектор.
	EI			;
	LDA	FIND_POS	;
	MOV	D,A		;
	MVI	E,0		;
	MVI	A,081h		;
	CALL	ABS_DE		; установим "градусник"
	CALL	PUTCXY		;
	LXI	D,0400h		;
	LXI	H,BUF_DISK	;
F_LOOP_01:
	SHLD	FIND_PTR	; Сохраняем возможное
	LXI	B,FIND_BUF	; начало последовательности
;; Проведем поиск строки в считаном секторе.
F_LOOP_02:
	DCX	D		;
	MOV	A,D		;
	ORA	E		;
	JZ	F_LOOP_QUIT	;Выйти если кончился сектор
	LDAX	B		;
	ORA	A		;
	JZ	F_YES_FIND	;
	CMP	M		; Сравниваем с образцом.
	INX	H		;
	JNZ	F_LOOP_01	;
	INX	B		;
	JMP	F_LOOP_02	;
F_YES_FIND:
	DCR	A		;
	STA	FIND_FLAG	; разрешим продолжать поиск
	LDA	CULINDER	;--+
	STA	FIND_CUL	;  !
	LDA	SECTOR		;  ! Перенесем указатель
	STA	FIND_SECTOR	;  ! текущего дампа в ра-
	LDA	HEAD		;  ! бочие ячейки.
	STA	FIND_HEAD	;--+
;; Сохраним указатель поиска для возможности продолжить.
	XCHG			;
	SHLD	F_COUNT_END	;
	LHLD	FIND_PTR	;
;; HL - Абсолютное смещение найденой строки.
	LXI	D,BUF_DISK	;
	CALL	NEG_DE		; Получим -BUF_DISK
	DAD	D		;
;; HL - Логическое Смещение в дампе найденной строки.
	LXI	D,0100h		;
	LXI	B,SOOB_FIND_END	;
	CALL	W_PUTSXY_Z	;
	LXI	D,1500h		;
	CALL	ABS_DE		;
	CALL	PUT_WORD_HEX	;
	CALL	KEY_DELAY	;
	JMP	F_QUIT		;

F_LOOP_QUIT:	
	CALL	DISK_INC	;
;; Если флаг Carri сброшен то произошло переполнение.
	JNC	F_FIND_EXIT	;
	LDA	FIND_COUNT	;
	INR	A		;
	STA	FIND_COUNT	;
	CPI	20		;
	JC	F_FIND_LOOP	;
	LDA	FIND_POS	;
	INR	A		;
	STA	FIND_POS	;
	XRA	A		;
	STA	FIND_COUNT	;
	JMP	F_FIND_LOOP	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;		Произведем прерывание поиска.		;;
F_F_INTERRUPT:
	XRA	A		;
	STA	FIND_FLAG	;
	LXI	D,1A09h		;
	LXI	H,2E09h		;
	MVI	A,00010110b	;
	CALL	ACTIV		;
	LXI	B,F_INTER_SOOB	;
	JMP	F_INT_EXIT	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;		   " Поиск закончился"			;;
F_FIND_EXIT:
	XRA	A		;
	STA	CULINDER	; Переход на нулевой трек.
	STA	FIND_FLAG	; НЕЛЬЗА ПРОДОЛЖ. ПОИСК
	INR	A		;
	DI			;
	CALL	SET_CULIND	;
	CALL	DISK_READ	;
	EI			;
	LXI	D,1A09h		;
	LXI	H,2B09h		;
	MVI	A,00010110b	;
	CALL	ACTIV		;
	LXI	B,F_END_SOOB	;
F_INT_EXIT:
	MVI	D,1Ch		;
	CALL	PUTSXY_Z	;
	MVI	A,80h		;
F_F_EX_00:
	HLT			;
	loop	A,F_F_EX_00	;
F_QUIT:
	CALL	DEACTI		;
	CALL	DEACTI		;
	CALL	DEACTI		;
	CALL	RE_DISK_POS	;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   Процедура организации запроса строки для поиска.	;;
F_READ_STRING:
	LXI	D,0F07h		;
	LXI	H,3808h		;
	MVI	A,00010110b	;
	CALL	ACTIV		;
	LDA	FIND_POS	;
	MVI	B,40		;
	MOV	D,A		;
	MVI	E,0		;
	DCR	A		;
	JZ	F_R_STR_DONE	;
	PUSH	D		;
	MVI	A,081h		;
F_DONE_LOOP:			; Прорисуем градусник.
	PUSH	D		;
	CALL	ABS_DE		;
	CALL	PUTCXY		;
	DCR	B		;
	POP	D		;
	loop	D,F_DONE_LOOP	;
	POP	D		;
	INR	D		;
F_R_STR_DONE:			;
	CALL	ABS_DE		;
	MVI	A,080h		;
F_R_LOOP:
	CALL	PUTCXY		;
	INR	D		;
	loop	B,F_R_LOOP	;
	INR	E		;
	LXI	B,SOOB_50	;
	LXI	D,0101h		;
	CALL	W_PUTSXY_Z	;
	LXI	B,FIND_BUF	;
	LXI	D,0801h		;
	PUSH	B		;
	CALL	W_PUTSXY_Z	;
	POP	B		;
F_R_SET_LOOP:
	LDAX	B		; Установим курсор на конец
	INX	B		;
	INR	D		;
	ORA	A		;
	JNZ	F_R_SET_LOOP	;
	DCX	B		; Коректируем указатель
	DCR	D		; и счетчик заполнения.
	XCHG			; устанавливаем курсор.
	SHLD	CURSOR		;
	XCHG			;
	CALL	CINV		;
F_R_KEY_LOOP:
	LXI	H,F_R_KEY_LOOP	;
	PUSH	H		;
	CALL	KEY_DELAY	;
	CPI	10h		;
	JNC	F_R_SYMBOLS	; Нажата символьная клавиша
	CPI	02h		; ==== Enter ====
	JZ	F_R_ENTER	;
	CPI	03h		; ==== Забой ====
	JZ	F_R_ZABOY	;
	CPI	04h		; ==== LEFT =====
	JZ	F_R_ZABOY	;
	CPI	0Eh		; ===== F4 ======
	POP	H		;
	POP	D		;
	CZ	DEACTI		;
	CZ	DEACTI		;
	RZ			;
	PUSH	D		;
	PCHL			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;		Обработка нажатия клавиши ВВОД		;;
F_R_ENTER:
	CALL	CINV		;
	XRA	A		; установим СТОП байт.
	STAX	B		;
	POP	H		;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;		Обработка нажатия клавиш забоя		;;
F_R_ZABOY:
	MOV	D,A		;
	LHLD	CURSOR		;
	MOV	A,H		;
	CPI	9		;
	RC			;
	DCX	B		;
	MOV	A,D		;
	CALL	CINV		;
	DCR	H		;
	SHLD	CURSOR		;
	MVI	A,20h		;
	XCHG			;
	CALL	ABS_DE		;
	CALL	PUTCXY		;
	CALL	CINV		;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Обработаем нажатие символьной клавиши		;;
F_R_SYMBOLS:
	MOV	D,A		;
	LHLD	CURSOR		;
	MOV	A,H		;
	CPI	41		;
	MOV	A,D		;
	RNC			;
	STAX	B		;
	INX	B		;
	CALL	CINV		;
	INR	H		;
	SHLD	CURSOR		;
	DCR	H		;
	XCHG			;
	CALL	ABS_DE		;
	CALL	PUTCXY		;
	CALL	CINV		;
	RET			;
;;
;; Найти:
;;
SOOB_50:
	DB	0EEh,0C1h,0CAh,0D4h,0C9h,':',000h
;;
;; Найдено по смещению:
;;
SOOB_FIND_END:
	DB	0EEh,0C1h,0CAh,0C4h,0C5h,0CEh,0CFh
	DB	020h,0D0h,0CFh,020h,0D3h,0CDh,0C5h
	DB	0DDh,0C5h,0CEh,0C9h,0C0h,":     ",000h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TMP_DONE:			;
	LXI	H,C_ALT_INV	;
	INX	H		;
	MVI	M,1h		;
	MVI	A,34h		;
	STA	DISK_MASKA	;
	EI			;
	HLT			;
	LDA	CULINDER	;
	DI			;
	CALL	SET_CULIND	;
	CALL	DISK_READ	;
	EI			;
	CALL	RE_DISK_POS	;
	LHLD	POSITION	;
	CALL	RE_PRINT_POS	;	

KEY_LOOP_IN:			;
	LXI	H,KEY_LOOP_IN	;
	PUSH	H		;
	CALL	IN_KEY		; возьмем  код    клавиши
	MOV	B,A		; сохраним   в   регистре
	LHLD	MIG_CURSOR	; читаем  счетчик миганий
	INX	H		; увеличиваем на  единицу
	SHLD	MIG_CURSOR	; ставим на  место  потом
	MOV	A,H		; проверим значение  кода
	SUI	5h		; если  превысело  предел
	JNZ	K_L_1		; инвертируем  курсор
	MOV	H,A		; иначе  просто переходим
	MOV	L,A		; на проверку и обработку
	SHLD	MIG_CURSOR	; кода  нажатой  клавиши.
	CALL	CINV		;
	LDA	ST_CURSOR	;
	CMA			;
	STA	ST_CURSOR	;
K_L_1:
	INR	B		;
	RZ			;
;;
;; Потушим курсор из основного окна редактора.
;;
	LDA	ST_CURSOR	;
	INR	A		;
	JNZ	K_L_2		; если горит потушить.
	STA	ST_CURSOR	;
	CALL	CINV		;
K_L_2:
	DCR	B		;
	IN	01h		;
	MOV	C,A		;
	ANI	01000000b	; маска клавиши "УС"
	MOV	A,B		;
	JZ	ALT_ADD_KEY	;
	MOV	A,C		;
	ANI	00100000b	; маска клавиши "УС"
	MOV	A,B		;
	JZ	CNTR_ADD_KEY	;
KEY_DONE:
	CPI	010h		;
	JNC	SUMBOLS_KEY	;
;;
;; Обработаем вариант нажатия на функциональную клавишу
;;
	CPI	04h		;===== ВЛЕВО =====
	JZ	LEFT_KEY	;
	CPI	05h		;==== ВВЕРХ ======
	JZ	UP_KEY		;
	CPI	06h		;==== ВПРАВО =====
	JZ	RIGHT_KEY	;
	CPI	07h		;===== ВНИЗ ======
	JZ	DOWN_KEY	;
	CPI	08h		;===== HOME ======
	JZ	HOME_KEY	;
	CPI	09h		;====== СТР ======
	JZ	STR_KEY		;
	CPI	0Dh		;====== F3 =======
	JZ	F3_KEY		;
	CPI	0Eh		;====== F4 =======
	JZ	US_QUIT		;
	CPI	03h		;===== ЗАБОЙ ======
	JZ	LEFT_KEY	;
	CPI	0Bh		;====== F1 ========
	JZ	FIND_BEGIN	;
	CPI	0Ch		;====== F2 ========
	JZ	FIND_DONE	;
	RET			;

;;
;; Обработаем нажатия символьной клавиши.
;;
SUMBOLS_KEY:
	MVI	A,0FFh		;
	STA	FATAL		; установим флаг изменений
	LDA	DE_MODE		;
	ORA	A		;
	JNZ	SUM_K_TEXT	;
;;
;;	Обработка кодового режима.
;;
	LDA	MODE_NIBL	;
	MOV	C,A		;
	MOV	A,B		;
	CPI	30h		; уходим если спец символ.
	RC			;
	CPI	3Ah		;
	JC	SUM_K_CIFRA	; обработати нажатие цифры
;;
;; нажата "буквенная" клавиша.
;;
	CPI	40h		;
	RC			; уходим если спец символ.
	ANI	01011111b	; сведем к прописным ЛАТ.
	CPI	47h		;
	RNC			; уходим если не HEX буква
;;
;; Нажата одна из букв: "A B C D E F"
;;	
	MOV	B,A		;
	ADI	9		;
SUM_K_CIFRA:
	ANI	00001111b	;
	MOV	B,A		;
	MOV	A,C		;
	ANI	11110000b	;
	JZ	SUM_K_H_NIBL	; переход если младший нибл
	MOV	A,B		;
	RLC			;
	RLC			;
	RLC			;
	RLC			;
	MOV	B,A		;
SUM_K_H_NIBL:
	MOV	A,C		;
;; C = A:
;; старший нибл: 11110000 }
;; младший нибл: 00001111 }
	LHLD	POSITION	;
	CMA			;
	ANA	M		;
	ORA	B		;
	MOV	M,A		;	
	MOV	B,A		;
	LHLD	CURSOR		;
	XCHG			;
	MOV	A,C		;
	ANI	11110000b	;
	JNZ	SUM_K_00	; если сторший нибл обойти.
	DCR	D		;
SUM_K_00:
	MOV	A,B		;
	CALL	W_PUT_HEX	;
	LHLD	POSITION	;
SUM_K_02:
	CALL	RE_PRINT_POS	;
	CALL	RIGHT_KEY	;
	RET			;
SUM_K_TEXT:
	LHLD	POSITION	;
	MOV	M,B		;
	MOV	A,B		;
	LHLD	CURSOR		;
	XCHG			;
	CALL	ABS_DE		;
	CALL	PUT_CHAR	;
	JMP	SUM_K_02	;
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Блок обработки регистрации нажатия клавиши "СС"	;;
;;   с  другими управляющими клавишами если клавиши не	;;
;;   поддерживается обработчиком управление пере дается	;;
;;   на до-обработку стандартным обработчиком.		;;

CNTR_ADD_KEY:
	CPI	06h	; ======= "СС"+ RIGHT_KEY ========
	JZ	CC_RIGHT_KEY;
	CPI	04h	; ======== "СС"+ LEFT_KEY ========
	JZ	CC_LEFT_KEY;
	CPI	07h	; ======== "СС"+ DOWN_KEY ========
	JZ	CC_DOWN_KEY;
	CPI	05h	; ========= "CC"+ UP_KEY =========
	JZ	CC_UP_KEY;
	JMP	KEY_DONE;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   Блок обработки регистрации нажатия "УС" совместно	;;
;; с  какой-то другой клавишой (код содержится в "A")	;;
;;							;;
ALT_ADD_KEY:
	LDA	KEY_NUM	;
	CPI	11h	; ==== "УС" + "1" ====
	JZ	US_HELP	;
	CPI	13h	; ==== "УС" + "3" ====
	JZ	US_GOTO	;
	CPI	15h	; ==== "УС" + "5" ====
	JZ	US_SERVISE;
	CPI	17h	; ==== "УС" + "7" ====
	JZ	US_QUIT	;
	RET		;

BUF_OF_VECTOR:	DW	0000h	; Буфер для вектора.
MIG_CURSOR:	DW	0000h	; счетчик миганий.
ST_CURSOR:	DB	0h	; статус курсора.
				; ( горит - не горит )
HEAD:		DB	00000100b; Байт указывающий на
				; номер головки.
SECTOR:		DB	01h	; определяет номер сектора.
CULINDER:	DB	04h	; номер цилиндра.
FATAL:		DB	00h	; флаг изменений.
DE_MODE:	DB	0h	; флаг режима "SUM-CODE"
MODE_NIBL:	DB	11110000b; указатель нибла.
		;;
		;; 11110000b - Старший нибл
		;; 00001111b - Младший нибл
		;;
POSITION:	DW	BUF_DISK; указатель на текущий
				; байт

;;
;; Начать поиск по диску - F1
;;
SOOB_20:
	DB	0EEh,0C1h,0DEh,0C1h,0D4h,0D8h
	DB	020h,0D0h,0CFh,0C9h,0D3h,0CBh
	DB	020h,0D0h,0CFh,020h,0C4h,0C9h
	DB	0D3h,0CBh,0D5h
	DB	' - F1',000h
;;
;; Продолжить поиск      - F2
;;
	DB	0F0h,0D2h,0CFh,0C4h,0CFh,0CCh
	DB	0D6h,0C9h,0D4h,0D8h,020h,0D0h
	DB	0CFh,0C9h,0D3h,0CBh
	DB	'      - F2',000h
;;
;; Изменение палитры экрана
;;
	DB	0E9h,0DAh,0CDh,0C5h,0CEh,0C5h
	DB	0CEh,0C9h,0C5h,020h,0D0h,0C1h
	DB	0CCh,0C9h,0D4h,0D2h,0D9h,020h
	DB	0DCh,0CBh,0D2h,0C1h,0CEh,0C1h
	DB	000h
;;
;; Диск обработан
;;
F_END_SOOB:
	DB	0E4h,0C9h,0D3h,0CBh,020h,0CFh
	DB	0C2h,0D2h,0C1h,0C2h,0CFh,0D4h
	DB	0C1h,0CEh,000h
;;
;; Прерывание поиска
;;
F_INTER_SOOB:
	DB	0F0h,0D2h,0C5h,0D2h,0D9h,0D7h,0C1h
	DB	0CEh,0C9h,0C5h,020h,0D0h,0CFh,0C9h
	DB	0D3h,0CBh,0C1h,000h

	Public	HEAD		;
	Public	SECTOR		;
	Public	CULINDER	;
	Public	FATAL		;
	Public	BUF_OF_VECTOR	;
	Public	POSITION	;
	Public	DE_MODE		;
	Public	MODE_NIBL	;

	External DISK_MASKA	;
	External RE_DISK_POS	;
	External RE_PR_DISK	;
	External SET_CULIND	;
	External DISK_READ	;

	External STR_KEY	;
	External CC_RIGHT_KEY	;
	External RIGHT_KEY	;
	External HOME_KEY	;
	External CC_LEFT_KEY	;
	External LEFT_KEY	;
	External F3_KEY		;
	External DOWN_KEY	;
	External CC_DOWN_KEY	;
	External UP_KEY		;
	External CC_UP_KEY	;

	External US_GOTO	;
	External US_QUIT	;
	External US_HELP	;

	External START_PPA	;
	External SCREEN_CLS	;
	External PUTSXY_Z	;
	External W_PUTSXY_Z	;
	External CINV		;
	External INV_LINE	;
	External CINV_ABS	;
	External C_ALT_INV	;
	External GOR_STREL	;
	External VER_STREL	;
	External DUMP_HEX	;
	External DUMP_TEXT	;
	External LINE_HEX	;
	External LINE_TEXT	;
	External W_PUT_HEX	;
	External PUT_HEX	;
	External PUT_NIBL	;
	External NEW_DUMP	;
	External LOAD_OFFSET	;
	External Y_N_WRITE	;
	External DA_NET		;
	External PTR_SET	;
	External MENU		;
	External PAINT_SCREEN	;
	External PUSK		;
	External DISK_COMMAND	;
	External DISK_INC	;

	External RE_PRINT_POS	;
	External PUT_CHAR	;
	External PUT_WORD_HEX	;
	External NEG_DE		;

	END


