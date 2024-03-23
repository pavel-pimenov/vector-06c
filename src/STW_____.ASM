	Title	STW.ASM	;
Start_PPA:
	DI		;
	XRA	A	;
	OUT	10h	;
	MVI	A,0C3h	;
	STA	0038h	;
	LXI	H,Key_Interrupt
	SHLD	0039h	;
	EI		;
	LXI	D,0604h	;
	LXI	H,2509h	;
	MVI	A,16h	;
	CALL	W_Open	;
	LXI	D,0106h	;
	MVI	A,70	;
	MVI	B,40	;
STLOOP1:		;
	INR	A	;
	CALL	Put_XY_Char
	INR	D	;
	DCR	B	;
	JNZ	STLOOP1	;
	CALL	W_Right_Scroll
	JMP	$-3	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Процедура вывода информационных строк с инкрементом BC;;
W_INX_Puts:		;
	CALL	W_Puts	;
	INX	B	;
	RET		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Точка входа без учета глобального смещения в окне.	;;
W_Local_Puts:		;
	PUSH	H	;
	PUSH	D	;
	PUSH	PSW	;
	JMP	W_Puts_Done
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     Процедура вывода строки символа в формате PPA	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
W_Puts:			;
	PUSH	H	;
	PUSH	D	;
	PUSH	PSW	;
	LDA	Ofset	;
	PUSH	PSW	;
	CALL	Str_Seek_Move
	POP	PSW	;
W_Puts_Done:		;
	ANI	07h	;
	SUI	02h	;
	LHLD	W_2Window;
	INR	H	;
	MOV	L,A	;
	CALL	Abs_DE	;
W_Puts_01:		;
	LDAX	B	;
	CPI	CR	;
	JZ	W_Puts_Quit
	CPI	9h	;
	JNZ	W_Puts_04	
W_Puts_02:
	XRA	A	
	CALL	Put_XY_Char	
	INR	D	
	MOV	A,D
	CMP	H
	JNC	W_Puts_Quit
	ADD	L	
	ANI	7h	
	JNZ	W_Puts_02	
	JMP	W_Puts_03	
W_Puts_04:
	CALL	Put_XY_Char
	INR	D	;
W_Puts_03		;
	INX	B	;
	MOV	A,D	;
	CMP	H	;
	JC	W_Puts_01
W_Puts_Quit:		;
	XCHG		;
	SHLD	End_Line;сохранить конец строки
	POP	PSW	;
	POP	D	;
	POP	H	;
	RET		;

	External Buf_Begin  ; начало буфера окон.
	External W_Zg	    ; начало знакогенератора.
	External W_Emul_Txt ; область эмуляции экрана.

;;;;;;;; Функции поддерживаемые оконной системой ;;;;;;;;;
	External W_Put_Char	;вывод символа коорд. в 'DE'
	External W_Get_Char	;чтение символа -//-
	External W_Open		;открытие окна (DE),(HL),а-флаг
	External W_Close  	;закрытие окна
	External W_Cls		;отчистка окна
	External W_Up_Scroll	;скроллинг окна вверх
	External W_Down_Scroll	;вниз
	External W_Right_Scroll	;вправо (на 2 символа)
	External W_Left_Scroll	;влево  (на 2 символа)
	External Put_XY_Char	;
	External Get_XY_Char	;
	External Cls_XY		;
	External Box_XY		;
	External Abs_DE		;
	External Inc_Copy	;
	External Dec_Copy	;
	External HL_DE_Window	;
	External HL_Sub_DE	;
	External Addr_Screen	;
;;;;;;;;;;;;;;; Определение глобальных ячеек ;;;;;;;;;;;;;
	External W_Cursor	;
	External W_1Window	;
	External W_2Window	;
	External W_Number	;
	External W_Buf_Seek	;
	External Beep_Key	; генерация сигнала типа "щелчек"
	External Input_Key	; прочитать код клавиши из буфера
	External Key_Interrupt	; обработчик прерывания.
	External Key_Reset	; сброс клавиатуры.
	External Key_Wait	; Ожидания нажатия.
	External Flag_Color	; флаг активности цветогенератора
	External Color		; код текущего цвета.
	External Stat_RUS_LAT	; статус клавиатуры по алфавиту
	External Stat_Small	; ---//----//----//--- регистру
	External Key_Seek	; указатель заполнения
	External Key_Kode	; динамический код клавиатуры
	External Key_Number	; физический номер клавиши
	END

