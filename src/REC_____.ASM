	Title	RE.ASM	; Version 1.00
	Include	MACRO.PPA	; My Macro #define.
;;   Программа организации интерфейса с магнитофоном в фор-
;; мате "EDASM" /* (C)18.06.1993 Караганда */
;; ///////////// Пименов Павел Алексеевич. //////////////
NO_SINHRO	EQU	08h	; Без поиска синхробайта.
YES_SINHRO	EQU	0FFh	; С поиском синхробайта.
BUFER		EQU	1000h	;
	DI			;
	CALL	REC_SCAN	;
	CALL	GET_YES_SINHRO	;
	CALL	GET_PODBLOCK	;
	HLT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура чтения подблока информации с ленты	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_PODBLOCK:
	PUSH	B		;
	LXI	H,BUFER		;
	LXI	B,0023h		;
	MVI	A,YES_SINHRO	;
GET_POD_LOOP:
	CALL	GET_REC_BYTE	;
	MOV	M,A		;
	INX	H		;
	ADD	B		;
	MOV	B,A		;
	MVI	A,NO_SINHRO	;
	DCR	C		;
	JNZ	GET_POD_LOOP	;
	POP	B		;	
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   Процедура подстройки под рабочюю скорость формата	;;
;; ROM осуществляет поиск ракорда.			;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
REC_SCAN:
	CALL	REC_INS_1	;
REC_I_00:
	MOV	D,A		;
	ORA	A		;
	RAR			;
	MOV	E,A		;
	ADD	D		;
	MOV	H,A		;
	CALL	REC_INS_1	;
	CMP	H		;
	JC	REC_I_00	;
	ADD	D		;
	STA	GET_CONST	;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
REC_INS_1:
	PUSH	H		;
	PUSH	D		;
REC_LOOP_00:
	CALL	GET_INTERVAL	;
	MOV	B,A		;
	ORA	A		;
	RAR			;
	MOV	C,A		;
	LXI	H,0000h		;
	MVI	D,20h		;
REC_LOOP_01:
	CALL	GET_INTERVAL	;
	PUSH	D		;
	MVI	D,0		;
	MOV	E,A		;
	DAD	D		;
	POP	D		;
	MOV	E,A		;
	SUB	B		;
	JNC	REC_I_DONE	;
	MOV	A,B		;
	SUB	E		;
REC_I_DONE:
	CMP	C		;
	JNC	REC_LOOP_00	;
	DCR	D		;
	JNZ	REC_LOOP_01	;
	DAD	H		;
	MOV	A,H		;
	POP	D		;
	POP	H		;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_INTERVAL:
	PUSH	D		;
	CALL	GET_BIT		;
GET_I_WAIT:
	IN	01h		;
	ANI	10h		;
	CMP	E		;
	JZ	GET_I_WAIT	;
	MVI	D,0		;
GET_I_2_WAIT:
	IN	01h		;
	ANI	10h		;
	INR	D		;
	CMP	E		;
	JNZ	GET_I_2_WAIT	;
	MOV	A,D		;
	ADD	A		;
	ADD	A		;
	POP	D		;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура чтения состояния компаратора.		;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_BIT:
	LDA	GET_CONST	;
GET_BIT_LOOP:
	loop	A,GET_BIT_LOOP	;
	IN	01h		;
	ANI	10h		;
	MOV	E,A		;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;    Процедура чтения байта с магнитофона без СИНХРО.	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_NOT_SINHRO:
	MVI	A,NO_SINHRO	;
	JMP	GET_REC_BYTE	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура чтения байта с синхронизацией		;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_YES_SINHRO:
	MVI	A,YES_SINHRO	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура чтения байта с магнитофона.		;;
;; ВХОД:	А = 0FFh - с поиском синхробайта	;;
;;		A = 008h - без поиска синхробайта	;;
;; ВЫХОД:	А = прочитаный байт.			;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_REC_BYTE:
	PUSH	B		; сохраняем регистры.
	PUSH	D		;
	MVI	C,0		; сформируем заготовку.
	MOV	D,A		; сохраним параметр.
GET_REC_LOOP:
	IN	01h		;
	ANI	10h		; ожидаем перепада уровня
	MOV	E,A		; сигнала.
GET_REC_00:			; ( синхронизация по фазе )
	IN	01h		;
	ANI	10h		;
	CMP	E		;
	JZ	GET_REC_00	; цикл жидания.
	RLC			;
	RLC			;
	RLC			;
	RLC			;
	MOV	A,C		;
	RAL			;
	MOV	C,A		;
	LDA	GET_CONST	;прочитаем константу чтения
	CALL	WAIT_LOOP	;
	MOV	A,D		;
	ORA	A		;
	JP	GET_REC_NO_SINHRO;
	MOV	A,C		;
	CPI	0E6h		;
	JNZ	GET_REC_01	;
	XRA	A		;
	STA	GET_INVERSE	;
GET_REC_01:			;
	CPI	19h		;
	JNZ	GET_REC_LOOP	;
	MVI	A,0FFh		;
	STA	GET_INVERSE	;
	MVI	D,9		;
GET_REC_NO_SINHRO:		;
	DCR	D		;
	JNZ	GET_REC_LOOP	;
	LDA	GET_INVERSE	;
	XRA	C		;
	POP	D		;
	POP	B		;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура вывода байта на магнитную ленту.	;;
;; ВХОД:	А = Выводимый байт.			;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PUT_REC_BYTE:
	PUSH	D		; сохраним регистры
	PUSH	PSW		;
	MOV	D,A		;
	MVI	C,8		; счетчик битов.
PUT_REC_00:			;
	MOV	A,D		; сдвинем
	RLC			; текущий бит байта
	MOV	D,A		;
	MVI	A,1		; сделаем его инверсию
	XRA	D		;
	ANI	01h		; выделим
	OUT	00h		; и выдадим в порт
	CALL	PUT_REC_WAIT	; сделаем задержку.
	MVI	A,0		;
	XRA	D		; проделаем тоже самое но бе инврси
	ANI	01h		;
	OUT	00h		;
	CALL	PUT_REC_WAIT	;
	DCR	C		; биты кончились ???
	JNZ	PUT_REC_00	;
	POP	PSW		;
	POP	D		;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура организации задержки для процедуры	;;
;; вывода байта на магнитофон.				;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PUT_REC_WAIT:
	LDA	PUT_CONST	;
WAIT_LOOP:
	loop	A,WAIT_LOOP	;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_CONST:	DB	08h	;
PUT_CONST:	DB	08h	;
GET_INVERSE:	DB	00h	;
	END
