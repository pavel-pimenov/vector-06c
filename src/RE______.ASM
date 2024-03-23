	Title	RE.ASM	; Version 1.00
	Include	MACRO.PPA	; My Macro #define.
;; ///////////// Пименов Павел Алексеевич. //////////////

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

;;///////////// KD.ASM - Драйвер клавиатуры //////////////

	External BEEP	; Щелчек.
	External INKEY	; взять код из буфера
	External KEYRESET; сброс клавиатуры
	External KEYDELAU; Ожидает нажатия.

	External FLAGC	; флаг цветогенератора
	External COLOR	; код цветовой палитры
	External RUSLAT	; статус по алфавиту
;;;	External SMALL	; статус по регистру
	External KEYKOD; динамический код клавиш
	External SEEK	; указатель заполнения

;;//////// WD.ASM - Драйвер оконного интерфейса //////////

;========= основная таблица переходов ==========
	External GETC	;чтение символа -//-
	External ACTIV	;открытие окна (DE),(HL),а-флаг
	External DEACTI  ;закрытие окна
	External BORT	;нарисовать рамку
	External HOME	;отчистка окна
	External SCROL1	;скроллинг окна вверх
	External SCROL2	;--//-- вниз
	External SCROL3	;--//-- вправо (на 2 символа)
	External SCROL4	;--//-- влево --//--
;;
;========== дополнительная таблица переходов ==========
;реализует теже функции но используют абсолютные координаты
;;
	External PUTCXY	
	External GETCXY	
	External RAMKA	;флаг передовать не нужно
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

;______________ рабочие ячейки ________________
	External CURSOR
	External WIND1
	External WIND2
	External NUM
;;	External BUF_SEK
	External FLAGW

	END

