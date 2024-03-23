==== F4 =====
	JZ	DA_N_F4_EXIT	;
	CPI	02h		; ==== Enter ====
	JZ	DA_N_EXIT	;
	CPI	04h		;
	JZ	DA_N_DONE	;
	CPI	06h		;
	JNZ	DA_N_LOOP	;
DA_N_DONE:
	CALL	INV_LINE	;
	MOV	A,C		;
	ORA	C		;
	CMA			;
	MOV	C,A		;
	JZ	DA_N_02		;
	MVI	D,14		;
	JMP	DA_N_03		;
DA_N_F4_EXIT:
	MVI	C,0h		; Флаг 'НЕТ'
DA_N_EXIT:
	MOV	A,C		;
	RET			;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура осуществляет чтение данных в рабочий	;;
;; буфер из текущего сектора.				;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISK_READ:
	PUSH	B		; Сохраним регистры.
	PUSH	D		;
	PUSH	H		;
	PUSH	PSW		;
	LDA	SECTOR		; прочитаем текущий сектор
	OUT	DS_SECTOR	; передать контролеру.
	LDA	DISK_MASKA	; прочитать маску
	ANI	11111011b	; и установить ее в соот-
	MOV	B,A		; ствии с текущей стороной
	LDA	HEAD		;
	ORA	B		;
	STA	DISK_MASKA	;
	LXI	D,BUF_DISK	;
	MVI	A,10000100b	;
	DI			;
	CALL	PUSK		;
	OUT	DS_COM		;
	CALL	READ_SEC	;
	EI			;
	POP	PSW		;
	POP	H		;
	POP	D		;
	POP	B		;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура осуществляет сброс содержимого буфера	;;
;; в текущий сектор ( буфер должен начинатся с граници	;;
;; блока - младший байт адреса = 00h			;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISK_SAVE:
	PUSH	B		; Сохраним регистры.
	PUSH	D		;
	PUSH	H		;
	PUSH	PSW		;
	LDA	SECTOR		; прочитаем текущий сектор
	OUT	DS_SECTOR	; передать контролеру.
	LDA	DISK_MASKA	; прочитать маску
	ANI	11111011b	; и установить ее в соот-
	MOV	B,A		; ствии с текущей стороной
	LDA	HEAD		;
	ORA	B		;
	STA	DISK_MASKA	;
	LXI	D,BUF_DISK	;
	MVI	A,10100101b	;
	DI			;
	CALL	PUSK		;
	OUT	DS_COM		;
	CALL	SAVE_SEC	;
	EI			;
	POP	PSW		;
	POP	H		;
	POP	D		;
	POP	B		;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   Процедура выполнения команды в частности использу-	;;
;; ется при шаганиях по диску.				;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISK_COMMAND:
	OUT	DS_COM		;
	CALL	DS_WAIT		;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;		Процедура записи сектора.		;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SAVE_SEC:
	LXI	B,0204H		;константы
S_S_LOOP_10:			;
	IN	DS_STATUS	;
	RRC			;
	JNC	S_S_LOOP_10	;
SAV_00:				;
	IN	DS_STATUS	;прочитать статус контролера
	ANA	B		;
	JZ	SAV_00		;
	LDAX	D		;
	OUT	DS_DATA		;
	INR	E		;
	JNZ	SAV_00		;
	INR	D		;
	DCR	C		;
	JNZ	SAV_00		;
	RET			;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   Процедура чтения информации поступаемой от контр.	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
READ_SEC:
	LXI	H,R_S_LOOP	;
R_S_1_LOOP:
	IN	DS_STATUS	; Дождемся готовности
	RRC			; принимать данные.
	JNC	R_S_1_LOOP	;
R_S_LOOP:			;
	IN	DS_STATUS	; прочитать статус контролера
	RRC			;
	RNC			; сектор прочтан ??? 
	RRC			; если да то уход
	JNC	R_S_LOOP	; ожидаем готовности данных
	IN	DS_DATA		; берем данные
	STAX	D		; сохраняем в буфере
	INX	D		;
	PCHL			;

;;========================================================
;;процедура установки головы накопителя на указаную дорожку
;;Вход:	А - номер дорожки
;;
SET_CULIND:
	PUSH	PSW		;
	PUSH	PSW		; сохраняем регистр PSW
	CALL	PUSK		; запускаем двигатель на
	MVI	A,00000000B	; текущем накопителе и
	CALL	DISK_COMMAND	;
	POP	PSW		; востанавливаем нужную
	CALL	PUSK		; нам дорожку и производим
	OUT	DS_DATA		; перемещение головы
	MVI	A,00011000B	; 
	CALL	DISK_COMMAND	;
	POP	PSW		;
	RET			; возврат из процедуры
;;========================================================
DS_WAIT:
	PUSH	PSW		;процедура ожидания готовности
DS_WAIT_00:			;
	IN	DS_STATUS	;контролера НГМД
	RRC			;
	JC	DS_WAIT_00	;занято идет исполнение команды
	POP	PSW		;
	RET			;
;;========================================================
PUSK:
	PUSH	PSW		; процедура запуска двигателя
PUSK_00:			;
	LDA	DISK_MASKA	; по заданой маске
	OUT	DS_MOTOR	; в порт управления
	IN	DS_STATUS	;
	RLC			;
	JC	PUSK_00		; если не готов то повторить
	POP	PSW		; востановим флаги
	RET			; возврат
;;
DISK_MASKA:
	DB	00H	;маска выбора рабочего накопителя
			; D2 - бит отвечает за "сторону"
			; диска (при обмене) если этот
			; бит = 1 то выбераются четные
			; дорожки ( по утилите DD.COM )
			; если = 0 то не четные


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	 Обработаем нажатия символьной клавиши.		;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;;	Процедура обработки перемещения по байтам в	;;
;; право (клавиша СТР)					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
STR_KEY:
	LDA	DE_MODE		;
	ORA	A		;
	CZ	RIGHT_KEY	;
	CALL	RIGHT_KEY	;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура обработки перемещение в конец дампа	;;
;;  "СС" + ВПРАВО.					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CC_RIGHT_KEY:
	MVI	A,11110000b	;
	STA	MODE_NIBL	;
	LHLD	CURSOR		;
	LDA	DE_MODE		;
	ORA	A		;
	MVI	H,17h		;
	JNZ	C_R_K_0		;
	MVI	H,35h		;
C_R_K_0:			;
	SHLD	CURSOR		;
	LHLD	POSITION	;
	MOV	A,L		;
	ORI	00001111b	;
	MOV	L,A		;
	SHLD	POSITION	;
	CALL	RE_PRINT_POS	;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура обработки нажатия клавиши "вправо"	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RIGHT_KEY:
	LDA	DE_MODE		; читаем режим редактора
	ORA	A		; если 0 - HEX
	JNZ	R_K_SUMBOLS	; иначе - TEXT
;;
;; Обработаем режим с шестнадцатеричным перемещением
;;	
	LHLD	CURSOR		; прочитаем курсор.
	XCHG			; поместим в DE
	MOV	A,D		; проверка за выход за
	CPI	36h		; пределы окна
	JC	R_K_30		;
	CALL	DOWN_KEY	;
	CALL	CC_LEFT_KEY	;
	RET			;
R_K_30:
	INR	D		;
	LDA	MODE_NIBL	;
	CPI	11110000b	;старший нибл ???
	CMA			;
	STA	MODE_NIBL	;
	JZ	R_K_0		;если ДА то переходим на
	INR	D		;младший иначе перемещаемся
	LHLD	POSITION	;на ближайщий нибл.
	INX	H		;
	SHLD	POSITION	;
	CALL	RE_PRINT_POS	;
R_K_0:				;
	XCHG			;
	SHLD	CURSOR		;
	RET			;
R_K_SUMBOLS:			;
	LHLD	CURSOR		;
	MOV	A,H		;
	CPI	17h		;
	JC	R_K_S_30	;
	CALL	DOWN_KEY	;
	CALL	CC_LEFT_KEY	;
	RET			;
R_K_S_30:
	INR	H		;
	SHLD	CURSOR		;
	LHLD	POSITION	;
	INX	H		;
	SHLD	POSITION	;
	CALL	RE_PRINT_POS	;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	  Процедура побайтового перемещения влево	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
HOME_KEY:
	LDA	DE_MODE		;
	ORA	A		;
	CZ	LEFT_KEY	;
	CALL	LEFT_KEY	;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;    Процедура перехода в начало строки "СС+ВЛЕВО"	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CC_LEFT_KEY:
	MVI	A,11110000b	;
	STA	MODE_NIBL	;
	LHLD	CURSOR		;
	MVI	H,08h		;
	SHLD	CURSOR		;
	LHLD	POSITION	;
	MOV	A,L		;
	ANI	11110000b	;
	MOV	L,A		;
	SHLD	POSITION	;
	CALL	RE_PRINT_POS	;
	RET			;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;    Процедура обработки нажатия на клавишу "ВЛЕВО"	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LEFT_KEY:
	LDA	DE_MODE		;
	ORA	A		;
	JNZ	L_K_SUMBOLS	;
;;
;; Обработаем кодовый режим.
;;
	LHLD	CURSOR		;
	XCHG			;
	MOV	A,D		;
	CPI	9h		;
	RC			;
	DCR	D		;
	LDA	MODE_NIBL	;
	CPI	11110000b	;
	CMA			;
	STA	MODE_NIBL	;
	JNZ	R_K_0		; L_K_0 === R_K_0
	DCR	D		;
	LHLD	POSITION	;
	DCX	H		;
	SHLD	POSITION	;
	CALL	RE_PRINT_POS	;
	JMP	R_K_0		;
L_K_SUMBOLS:			;
	LHLD	CURSOR		;
	MOV	A,H		;
	CPI	09h		;
	RC			;
	DCR	H		;
	SHLD	CURSOR		;
	LHLD	POSITION	;
	DCX	H		;
	SHLD	POSITION	;	
	CALL	RE_PRINT_POS	;
	RET			;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура осуществляет "умное" перемещение кур-	;;
;; сора  и  должна выполнятся при переключениях экрана	;;
;; с текстового в кодовый режим и наоборот это связано	;;
;; с  разным  шагом перемещения курсора в этих режимах	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CUR_RESTART:
	CALL	LOAD_OFFSET	;
	PUSH	H		;
	CALL	CC_LEFT_KEY	; переместимся на начало
	POP	H		;
	MOV	A,L		;
	ANI	00001111b	;
CU_R_00:
	RZ			;
	PUSH	PSW		;
	CALL	STR_KEY		; перейдем где были.
	POP	PSW		;
	DCR	A		;
	JMP	CU_R_00		;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура обработки нажатия клавиши "F3"	;;
;;     ( производит смену режима "СИМВОЛ - КОД")	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
F3_KEY:
	LDA	DE_MODE		;
	CMA			;
	STA	DE_MODE		;
	ORA	A		;
	JNZ	F3_K_SUMBOLS	; перейти на текст.
;;
;; Обработаем переключение в кодовый режим.
;;
	LHLD	WIND2		;
	MOV	D,H		;
	MVI	H,3Bh		;
	SHLD	WIND2		;
	MOV	H,D		;
	LXI	D,0B05h		;
	CALL	CLS		;
	CALL	NEW_DUMP	;
	CALL	DUMP_HEX	;
	CALL	CUR_RESTART	;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Блок перехода в символьный режим редактирования
;;
F3_K_SUMBOLS:			;
	LHLD	WIND2		;
	MOV	D,H		;
	MVI	H,1Bh		;
	SHLD	WIND2		;
	MOV	H,D		;
	LXI	D,0B05h		;
	CALL	CLS		;
	CALL	NEW_DUMP	;
	CALL	DUMP_TEXT	;
	CALL	CUR_RESTART	;	
	RET			;
;;
;; Записать сектор на диск ?
;;
SOOB_00:
	DB	0FAh,0C1h,0D0h,0C9h,0D3h,0C1h
	DB	0D4h,0D8h,020h,0D3h,0C5h,0CBh
	DB	0D4h,0CFh,0D2h,020h,0CEh,0C1h
	DB	020h,0C4h,0C9h,0D3h,0CBh
	DB	' ?',000h
SOOB_YN:
;;
;;  Да  Нет
;;
	DB	0E4h,0C1h,020h,020h,020h,020h
	DB	0EEh,0C5h,0D4h,000h

SOOB_10:
;;
;; Дорожка [    ]
;;
	DB	0E4h,0CFh,0D2h,0CFh,0D6h,0CBh
	DB	0C1h,'  [    ] ( 00h - 4Fh )',000h
;;
;; Сектор  [   ]
;;
	DB	0F3h,0C5h,0CBh,0D4h,0CFh,0D2h
	DB	'   [   ]  ( 0 - 5 )',000h
;;
;; Сторона [   ]
;;
	DB	0F3h,0D4h,0CFh,0D2h,0CFh,0CEh
	DB	0C1h,'  [   ]  ( 0 - 1 )',000h

SOOB_HLP:
       DB     05Fh,05Fh,05Fh,05Fh,05Fh,020h,0EBh,0CCh
       DB     0C1h,0D7h,0C9h,0DBh,0C9h,020h,0D5h,0D0h
       DB     0D2h,0C1h,0D7h,0CCh,0C5h,0CEh,0C9h,0D1h
       DB     03Ah,05Fh,05Fh,05Fh,05Fh,05Fh,05Fh,05Fh
       DB     05Fh,05Fh,05Fh,05Fh,05Fh,05Fh,05Fh,05Fh
       DB     05Fh,05Fh,05Fh,05Fh,05Fh,05Fh,05Fh,05Fh
       DB     05Fh,000h
       DB     020h,0F3h,0D4h,0D2h,0C5h
       DB     0CCh,0CBh,0C9h,020h,02Dh,020h,0F5h,0D0h
       DB     0D2h,0C1h,0D7h,0CCh,0C5h,0CEh,0C9h,0C5h
       DB     020h,0CBh,0D5h,0D2h,0D3h,0CFh,0D2h,0CFh
       DB     0CDh,02Eh,00h
       DB     020h,046h,033h,020h,02Dh
       DB     020h,0F0h,0C5h,0D2h,0C5h,0CBh,0CCh,0C0h
       DB     0DEh,0C5h,0CEh,0C9h,0C5h,020h,0D2h,0C5h
       DB     0D6h,0C9h,0CDh,0C1h,020h,0D2h,0C5h,0C4h
       DB     0C1h,0CBh,0D4h,0CFh,0D2h,0C1h,020h,048h
       DB     045h,058h,020h,02Dh,020h,041h,053h,043h
       DB     049h,049h,02Eh,000h
       DB     020h,046h,035h
       DB     020h,02Dh,020h,0F0h,0C5h,0D2h,0C5h,0CBh
       DB     0CCh,0C0h,0DEh,0C5h,0CEh,0C9h,0C5h,020h
       DB     0D2h,0C5h,0C7h,0C9h,0D3h,0D4h,0D2h,0C1h
       DB     020h,0CBh,0CCh,0C1h,0D7h,0C9h,0C1h,0D4h
       DB     0D5h,0D2h,0D9h,020h,020h,028h,0EEh,0F2h
       DB     02Fh,0F7h,0F2h,029h,02Eh,00h
       DB     020h
       DB     0F3h,0F3h,020h,02Bh,020h,0F7h,0D7h,0C5h
       DB     0D2h,0C8h,020h,028h,0F7h,0CEh,0C9h,0DAh
       DB     029h,020h,020h,02Dh,020h,020h,022h,0FBh
       DB     0C1h,0C7h,0C1h,0CEh,0C9h,0C5h,022h,020h
       DB     020h,0D0h,0CFh,020h,020h,020h,0D3h,0C5h
       DB     0CBh,0D4h,0CFh,0D2h,0C1h,0CDh,02Eh,000h

       DB     020h,0F3h,0F3h,020h,02Bh,020h,0F7h
       DB     0CCh,0C5h,0D7h,0CFh,020h,028h,0F7h,0D0h
       DB     0D2h,0C1h,0D7h,0CFh,029h,020h,02Dh,020h
       DB     020h,0EEh,0C1h,0DEh,0C1h,0CCh,0CFh,020h
       DB     020h,028h,0CBh,0CFh,0CEh,0C5h,0C3h,029h
       DB     020h,020h,0D3h,0D4h,0D2h,0CFh,0CBh,0C9h
       DB     02Eh,00h
       DB     020h,0F5h,0F3h,020h,02Bh
       DB     020h,03Ch,0C3h,0C9h,0C6h,0D2h,0C1h,03Eh
       DB     020h,02Dh,020h,020h,0F7h,0D9h,0C2h,0CFh
       DB     0D2h,020h,020h,020h,022h,0D0h,0C1h,0CEh
       DB     0C5h,0CCh,0D8h,0CBh,0C9h,022h,020h,0D3h
       DB     020h,020h,0C6h,0D5h,0CEh,0CBh,0C3h,0C9h
       DB     0C5h,0CAh,02Eh,00h
       DB     05Fh,05Fh,05Fh
       DB     05Fh,05Fh,05Fh,05Fh,05Fh,05Fh,05Fh,05Fh
       DB     05Fh,05Fh,05Fh,05Fh,05Fh,05Fh,05Fh,05Fh
       DB     05Fh,05Fh,05Fh,05Fh,05Fh,05Fh,05Fh,020h
       DB     050h,050h,041h,020h,053h,06Fh,066h,074h
       DB     020h,053h,079h,073h,074h,065h,06Dh,073h
       DB     020h,05Fh,05Fh,05Fh,05Fh,05Fh,000h

;;
;; Выйти из редактора ?
;;
SOOB_30:
	DB	0F7h,0D9h,0CAh,0D4h,0C9h,020h
	DB	0C9h,0DAh,020h,0D2h,0C5h,0C4h
	DB	0C1h,0CBh,0D4h,0CFh,0D2h,0C1h
	DB	' ?',000h
;;
;; Цвет переднего плана
;;
SOOB_40:
	DB	0E3h,0D7h,0C5h,0D4h,020h,0D0h
	DB	0C5h,0D2h,0C5h,0C4h,0CEh,0C5h
	DB	0C7h,0CFh,020h,0D0h,0CCh,0C1h
	DB	0CEh,0C1h,'  [    ]',000h
;;
;; Цвет заднего плана
;;
	DB	0E3h,0D7h,0C5h,0D4h,020h,0DAh
	DB	0C1h,0C4h,0CEh,0C5h,0C7h,0CFh
	DB	020h,0D0h,0CCh,0C1h,0CEh,0C1h
	DB	'    [    ]',000h

	END
