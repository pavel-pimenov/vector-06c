	Title	GR.ASM
;;___________________ (C) 17.11.1993 ____________________
;;	Программа рекламно-демонстрационного типa
;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PPA Soft Systems ~~~~~~~~
Start:				;
	DI			;
	XRA	A		;
	OUT	10h		;
	LXI	SP,100h		;
	CALL	Screen_Cls	;
	MVI	A,0C3h		;
	STA	0038h		;
	LXI	H,Interupt	;
	SHLD	0039h		;
	EI			;
	HLT			;
	DI			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Программа организует безконечный цикл эффекта	;;
;; мерцающих звезд.					;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Star:
	CALL	Sc_Regener	;
	LXI	H,3000h		;
Star_Loop:			;
	DCX	H		;
	MOV	A,H		;
	ORA	L		;
	JNZ	Star_Loop	;
	LXI	H,Number	;
	LXI	B,0800h		;
Star_00:			;
	MOV	A,M		;
	INR	M		;
	SUI	7h		;
	CZ	S_Exit		;
	INX	H		;
	INR	C		;
	DCR	B		;
	JNZ	Star_00		;
	JMP	Star		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
S_Exit:				;
	PUSH	B		;
	PUSH	H		;
	MOV	M,A		;
	LXI	D,Coord		;
	MOV	A,C		;
	ORA	A		;
	JZ	S_Ex_Done	;
S_Ex_00:			;
	DCR	C		;
	INX	D		;
	INX	D		;
	JNZ	S_Ex_00		;
S_Ex_Done:			;
	CALL	Rnd_Coord	;
	POP	H		;
	POP	B		;
	RET			;
;;___________________ Блок Подпрограм ___________________
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура регенерации изображения на  экране  в	;;
;; сответствии с содержащейся информации в рабочих бу-	;;
;; ферах.						;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Sc_Regener:
	MVI	A,8		;
	LXI	H,Coord		;
	LXI	B,Number	;
Sc_Loop:			;
	MOV	E,M		;
	INX	H		;
	MOV	D,M		;
	INX	H		;
	PUSH	PSW		;
	LDAX	B		;
	INX	B		;
	CALL	Put_Sprite	;
	POP	PSW		;
	DCR	A		;
	JNZ	Sc_loop		;
	RET			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Подпрограмма вывода спрайта с заданным номером	;;
;; в заданные координаты экрана.			;;
;; A  -  Номер спрайта.					;;
;; DE -  Координаты экрана.				;;
;;	Спрайты выводится в старшую экранную плоскость	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Put_Sprite:
	PUSH	PSW		;
	PUSH	H		;
	PUSH	B		;
	LXI	B,0009h		;
	LXI	H,Gr_Sprite_1	;
	CPI	4h		;
	JC	Put_Sprite_0	;
	MOV	C,A		;
	MVI	A,6		;
	SUB	C		;
	MVI	C,9		;
	CPI	0FFh		;
	JZ	Clear_Sprite	;
Put_Sprite_0:			;В HL получим адрес спрайта
	ORA	A		;
	JZ	Put_Sprite_Done	;
	DAD	B		;
	DCR	A		;
	JMP	Put_Sprite_0	;
Put_Sprite_Done:		;
	MOV	A,M		;
	STAX	D		;
	INX	D		;
	INX	H		;
	DCR	C		;
	JNZ	Put_Sprite_Done	;
Put_Exit:			;
	POP	B		;
	POP	H		;
	POP	PSW		;
	RET			;
Clear_Sprite:			;
	XRA	A		;
Clear_Loop:			;
	STAX	D		;
	INX	D		;
	DCR	B		;
	JNZ	Clear_Loop	;
	JMP	Put_Exit	;
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура генерации случайной координаты	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Rnd_Coord:			;
	ANI	7		;
	RLC			;
	RLC			;
	MOV	B,A		;
	CALL	Rnd		;
	MOV	A,H		;
	ANI	3		;
	ORA	B		;
	ORI	0E0h		;
	MOV	H,A		;
	MOV	A,L		;
	CPI	0F6h		;
	JC	R_C_Done	;
	RAR			;
R_C_Done:			;
	STAX	D		;
	INX	D		;
	MOV	A,H		;
	STAX	D		;
	INX	D		;
	RET			;
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Процедура генерации псевдослучайного числа	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Rnd:				;
	PUSH	B		;
	LHLD	Rnd_Buf		;
	LXI	B,600Fh		;
Rnd_Loop:			;
	MOV	A,H		;
	DAD	H		;
	ANA	B		;
	JPE	$+4		;
	INX	H		;
	DCR	C		;
	JNZ	Rnd_Loop	;
	SHLD	Rnd_Buf		;
	POP	B		;
	RET			;
;;_______________________________________________________
Key_Code:			;
	DB	00h		;
Color_Dump:			;
	DB	0,105,134,165,124,154,250,200
	DB	-1,-1,-1,-1,-1,-1,-1,-1
;;____ Ячейка для генерации псевдослучайного чияла.____
Rnd_Buf:			;
	DW	2345		;
;;_______ 8 Слов для определения восьми "звезд" _______
Coord:
	DW	0E000h		;
	DW	0E000h		;
	DW	0E000h		;
	DW	0E000h		;
	DW	0E000h		;
	DW	0E000h		;
	DW	0E000h		;
	DW	0E000h		;
;;_______ 8 Байт для определения "уровня" звезды _______
Number:
	DB	00h		;
	DB	02h		;
	DB	03h		;
	DB	03h		;
	DB	03h		;
	DB	00h		;
	DB	01h		;
	DB	00h		;

;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Interupt:		;
	PUSH	H	;
	PUSH	B	;
	PUSH	D	;
	PUSH	PSW	;
	MVI	A,88h	;
	OUT	0h	;
	LXI	H,Color_Dump + 15
	LXI	D,100Fh	;
Int_1:			;
	MOV	A,E	;
	OUT	2h	;
	MOV	A,M	;
	OUT	0Fh	;
	OUT	0Fh	;
	OUT	0Fh	;
	DCX	H	;
	OUT	0Fh	;
	DCR	E	;
	DCR	D	;
	JNZ	Int_1	;
	MVI	A,8Ah	;
	OUT	0h	;
	XRA	A	;
 	OUT	3h	;
	IN	2h	;
	STA	Key_Code;
	MVI	A,88h	;
	OUT	0h	;
	XRA	A	;
	OUT	2h	;
	INR	A	;
	OUT	3h	;
	POP	PSW	;
	POP	D	;
	POP	B	;
	POP	H	;
	EI		;
	RET		;

;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;	Процедура отчистки графического экрана
Screen_Cls:			;
	PUSH	PSW		;
	PUSH	H		;
	PUSH	D		;
	MVI	D,0		;
	LXI	H,8000h		;
Screen_Cls_Loop:		;
	MOV	M,D		;
	INX	H		;
	MOV	A,H		;
	ORA	L		;
	JNZ	Screen_Cls_Loop	;
	POP	D		;
	POP	H		;
	POP	PSW		;
	RET			;

;;___________________ Блок данных _______________________
;;	Представляет  собой  четыре  спрайта  необходимых
;; для  организации  эффекта  "мерцающей"  звезды, размер
;; спрайта 8 * 9
Gr_Sprite_1:
	DB	00000000b	;
	DB	00000000b	;
	DB	00000000b	;
	DB	00000000b	;
	DB	00010000b	;
	DB	00000000b	;
	DB	00000000b	;
	DB	00000000b	;
	DB	00000000b	;
Gr_Sprite_2:
	DB	00000000b	;
	DB	00000000b	;
	DB	00000000b	;
	DB	00010000b	;
	DB	00111000b	;
	DB	00010000b	;
	DB	00000000b	;
	DB	00000000b	;
	DB	00000000b	;
Gr_Sprite_3:
	DB	00000000b	;
	DB	00000000b	;
	DB	00010000b	;
	DB	00010000b	;
	DB	01111100b	;
	DB	00010000b	;
	DB	00010000b	;
	DB	00000000b	;
	DB	00000000b	;

Gr_Sprite_4:
	DB	00010000b	;
	DB	00010000b	;
	DB	00010000b	;
	DB	00111000b	;
	DB	11111110b	;
	DB	00111000b	;
	DB	00010000b	;
	DB	00010000b	;
	DB	00010000b	;

	END	Start		;
