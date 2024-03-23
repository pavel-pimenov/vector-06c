;;
;; ///////// 5.04.1993 ///////////////////////////////////
;; //  (C) 1993  Караганда  КптИ  ЭА-91-2  Пименов П.А	//
;; //							//
;; // ====== 52-81-95 ======== PPA Soft Systems ======	//
;; //		Copyright  by  Пименов Паша		//
;; ///////////////////////////////////////////////////////
;;
	Include	MACRO.PPA	; Макоподстановки
	Include	EXT.PPA		; Выход на драйверы

	Public	START_PPA	;
	External BUF_OF_VECTOR	; буфер для вектора.

	External SCREEN_CLS	; фирменая отчистка
	External PUTSXY_Z	; вывод строки
	External GOR_STREL	; горизонтальная стрелка
	External VER_STREL	; вертикальная стрелка
	External CINV_ABS	; абсолютная инверсия

;;
;;	Стартовая процедура производит инициализацию всех
;; внутренних драйверов и буферов ,а также формирует осн-
;; овное  окно редактора. В последующем не используется и
;; может быть затерта или использоватся в качестве буфера.
;;
PPA_COPYRIGHT_DE:
  DB "(C) 1992 KARAGANDA PRESENT BY PIMENOV PAVEL",0Dh,0Ah
  DB 09h,"     PPA DISK EDITOR",'$'
START_PPA:			;
	LXI	D,PPA_COPYRIGHT_DE;
	int	9		;
	MVI	A,50		;
ST_PPA_LOOP20:
	HLT			;
	loop	A,ST_PPA_LOOP20	;
	DI			;
	LHLD	0039h		;
	SHLD	BUF_OF_VECTOR	;
	XRA	A		;
	OUT	10h		;
	CALL	SCREEN_CLS	;
	LXI	H,KEY_INT	;
	SHLD	0039h		; Установим вектор прерыва
	EI			;
	LXI	H,W_EMUL_TXT	; -ния на свой драйвер.
	LXI	B,400h		; и отчистим область эму-
ST_PPA_00:			; ляции текстового экрана.
	MVI	M,' '		;
	INX	H		;
	DCX	B		;
	MOV	A,B		;
	ORA	C		;
	JNZ	ST_PPA_00	;
	LXI	D,0000h		;
	LXI	H,3F02h		;
	MVI	A,00001000B	;
	CALL	BORT		;
	MVI	E,0Dh		;
	MVI	L,0Fh		;
	CALL	BORT		;
	LXI	D,0302h		;
	CALL	DOUBLE_STOLB	;
	MVI	D,3Ch		;
	CALL	DOUBLE_STOLB	;
	MVI	B,08h		;
	MVI	E,0Ch		;
	CALL	VER_STREL	;
;;
;; Установим координаты текущего окна редактора.
;;
	LXI	D,0304h		;
	MVI	A,97h		;
	CALL	PUTCXY		;
ST_PPA_03:
	MVI	A,94h		;
	INR	D		;
	CALL	PUTCXY		;
	MOV	A,D		;
	CPI	3Bh		;
	JNZ	ST_PPA_03	;
	INR	D		;
	MVI	A,86h		;
	CALL	PUTCXY		;
	LXI	D,0A04h		;
	MVI	A,91h		;
	CALL	PUTCXY		;
	MVI	E,0Dh		;
	MVI	A,0A1h		;
	CALL	PUTCXY		;
	LXI	H,0405h		;
	SHLD	WIND1		;
	LXI	H,3B0Ch		;
	SHLD	WIND2		;
	LXI	H,0807h		;
	SHLD	CURSOR		;
	LXI	D,020Fh		;
	LXI	B,COPY_RIGHT	;
	CALL	PUTSXY_Z	;
	MVI	D,25h		;
	CALL	PUTSXY_Z	;
	LXI	D,0C0Dh		;
	CALL	PUTSXY_Z	;
	LXI	D,0602h		;
	CALL	PUTSXY_Z	;
	LXI	D,0601h		;
	CALL	PUTSXY_Z	;
	DCR	D		;
	MVI	B,36h		;
ST_PPA_10:
	CALL	CINV_ABS	;
	INR	D		;
	DCR	B		;
	JNZ	ST_PPA_10	;
	LXI	D,0C04h		;
	MVI	B,2Fh		;
	CALL	GOR_STREL	;
	LXI	H,0F800h	;
	SHLD	COLOR		;
	XRA	A		;
	STA	FLAGC		;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура рисует перегородки в основном окне	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DOUBLE_STOLB:
	PUSH	D		;
	MVI	A,9Ah		;
	CALL	PUTCXY		;
	MVI	A,8Ah		;
	MVI	B,0Ah		;
D_L_00:
	INR	E		;
	CALL	PUTCXY		;
	DCR	B		;
	JNZ	D_L_00		;
	INR	E		;
	MVI	A,9Bh		;
	CALL	PUTCXY		;
	POP	D		;
	RET			;

COPY_RIGHT:
;;
;; "Пименов Паша представляет"
;;
	DB	6,7,20h
	DB	0F0h,0C9h,0CDh,0C5h,0CEh,0CFh,0D7h
	DB	020h,0F0h,0C1h,0DBh,0C1h,020h,0D0h
	DB	0D2h,0C5h,0C4h,0D3h,0D4h,0C1h,0D7h
	DB	0CCh,0D1h,0C5h,0D4h,020h,7,8,0

	DB	6,7,020h
	DB	0BDh,0BEh,0BFh," PPA Disk Editor "
	DB	7,8,0
;;
;; "<- Диск A: 00/0/1: [0000] = 00h = '*' ->"
;;
	DB	6,7," "
	DB	0E4h,0C9h,0D3h,0CBh
	DB	" A: 00/0/1 "
	DB	7,8,09Dh,09Dh,09Dh,09Dh,6,7
	DB	" [0000] = 00 = '*' "
	DB	7,8,0
;;
;; "(C) Караганда-1993 Версия 1.00 от 26 сентября"
;;
	DB	6,7," (C) "
	DB	0EBh,0C1h,0D2h,0C1h,0C7h,0C1h
	DB	0CEh,0C4h,0C1h,"-1993  "
	DB	0F7h,0C5h,0D2h,0D3h,0C9h,0D1h
	DB	" 1.00 "
	DB	0CFh,0D4h
	DB	" 26 "
	DB	0D3h,0C5h,0CEh,0D4h,0D1h
	DB	0C2h,0D2h,0D1h," "
;	DB	0EBh,0C1h,0D2h,0C1h,0C7h
;	DB	0C1h,0CEh,0C4h,0C1h,"-1993 "
	DB	7,8,0
;;
;; " Версия 1.00 "
;;		
;	DB	6,7,20h
;	DB	0F7h,0C5h,0D2h,0D3h,0C9h,0D1h
;	DB	" 1.00 "
;	DB	7,8,0
;;
;; Поле панелек управления редактором.
;;
	DB	"1 - ",0F0h,0CFh,0CDh,0CFh
	DB	0DDh,0D8h,020h,15,15
	DB	" 3- ",0F0h,0C5h,0D2h,0C5h
	DB	0C8h,0CFh,0C4h,020h,15,15
	DB	" 5 - ",0F3h,0C5h,0D2h,0D7h
	DB	0C9h,0D3h,020h,15,15
	DB	" 7 - ",0F7h,0D9h,0C8h,0CFh
	DB	0C4h,0
START_END:
	END

