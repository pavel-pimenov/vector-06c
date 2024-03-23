	Title	STDIO.ASM	;

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


