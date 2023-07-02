;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.0 #12072 (MINGW64)
;--------------------------------------------------------
; PIC port for the 14-bit core
;--------------------------------------------------------
;	.file	"main.c"
	list	p=16f688
	radix dec
	include "p16f688.inc"
;--------------------------------------------------------
; config word(s)
;--------------------------------------------------------
	__config 0x3fc4
;--------------------------------------------------------
; external declarations
;--------------------------------------------------------
	extern	__divsint
	extern	__modsint
	extern	__mulint
	extern	_ADCON1
	extern	_ANSEL
	extern	_TRISC
	extern	_TRISA
	extern	_OPTION_REG
	extern	_ADCON0
	extern	_ADRESH
	extern	_CMCON0
	extern	_PORTC
	extern	_PORTA
	extern	_TMR0
	extern	_WPUbits
	extern	_OSCCONbits
	extern	_TRISAbits
	extern	_ADCON0bits
	extern	_INTCONbits
	extern	_PORTCbits
	extern	_PORTAbits
	extern	__sdcc_gsinit_startup
;--------------------------------------------------------
; global declarations
;--------------------------------------------------------
	global	_advanceMinute
	global	_advanceHour
	global	_getButton
	global	_I2Cread
	global	_I2Cwrite
	global	_I2Cstop
	global	_I2Cstart
	global	_main
	global	___TEMP_ADC
	global	_timeChanged
	global	_blink
	global	_tOFF
	global	_display
	global	_operatingState
	global	_readyToGo
	global	_rtc
	global	_initHardware
	global	_writeRtc
	global	_readRtc
	global	__delay_ms
	global	_buttonEvents
	global	_runClockEngine
	global	_runDisplayEngine
	global	_runBrightnessControl
	global	_runDisplayError

	global PSAVE
	global SSAVE
	global WSAVE
	global STK12
	global STK11
	global STK10
	global STK09
	global STK08
	global STK07
	global STK06
	global STK05
	global STK04
	global STK03
	global STK02
	global STK01
	global STK00

sharebank udata_ovr 0x0070
PSAVE	res 1
SSAVE	res 1
WSAVE	res 1
STK12	res 1
STK11	res 1
STK10	res 1
STK09	res 1
STK08	res 1
STK07	res 1
STK06	res 1
STK05	res 1
STK04	res 1
STK03	res 1
STK02	res 1
STK01	res 1
STK00	res 1

;--------------------------------------------------------
; global definitions
;--------------------------------------------------------
UD_main_0	udata
_rtc	res	7

UD_main_1	udata
_display	res	5

UD_main_2	udata
___TEMP_ADC	res	1

;--------------------------------------------------------
; absolute symbol definitions
;--------------------------------------------------------
;--------------------------------------------------------
; compiler-defined variables
;--------------------------------------------------------
UDL_main_0	udata
r0x103B	res	1
r0x103C	res	1
r0x103D	res	1
r0x103A	res	1
r0x102E	res	1
r0x102F	res	1
r0x1030	res	1
r0x1031	res	1
r0x1036	res	1
r0x1037	res	1
r0x1038	res	1
r0x1032	res	1
r0x1033	res	1
r0x1034	res	1
r0x1035	res	1
r0x102C	res	1
r0x102B	res	1
r0x102D	res	1
r0x1029	res	1
r0x102A	res	1
r0x1022	res	1
r0x1023	res	1
r0x1024	res	1
r0x1025	res	1
r0x1026	res	1
r0x1027	res	1
r0x1028	res	1
r0x1021	res	1
r0x101D	res	1
r0x101E	res	1
r0x101F	res	1
r0x1020	res	1
___sdcc_saved_fsr	res	1
_runDisplayEngine_displayBuf_65536_128	res	5
;--------------------------------------------------------
; initialized data
;--------------------------------------------------------

IDD_main_0	idata
_readyToGo
	db	0x00	;  0


IDD_main_1	idata
_operatingState
	db	0x00	; 0


IDD_main_2	idata
_tOFF
	db	0x20	; 32


IDD_main_3	idata
_blink
	db	0x00	;  0


IDD_main_4	idata
_timeChanged
	db	0x00	;  0


IDD_main_5	idata
_irqHandler_tickCounter_65536_11
	db	0x00	; 0


IDD_main_6	idata
_irqHandler_digit_65536_11
	db	0x00	; 0


IDD_main_7	idata
_buttonEvents_btSetCount_65536_115
	db	0x00	; 0


IDD_main_8	idata
_runDisplayEngine_sequentialCounter_65536_128
	db	0x00	; 0


IDD_main_9	idata
_runBrightnessControl_lighSenseCounter_65536_137
	db	0x00	; 0


IDD_main_10	idata
_runDisplayError_sequentialCounter_65536_141
	db	0x00	; 0

;--------------------------------------------------------
; initialized absolute data
;--------------------------------------------------------
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
;	udata_ovr
;--------------------------------------------------------
; reset vector 
;--------------------------------------------------------
STARTUP	code 0x0000
	nop
	pagesel __sdcc_gsinit_startup
	goto	__sdcc_gsinit_startup
;--------------------------------------------------------
; interrupt and initialization code
;--------------------------------------------------------
c_interrupt	code	0x0004
__sdcc_interrupt:
;***
;  pBlock Stats: dbName = I
;***
;3 compiler assigned registers:
;   r0x103B
;   r0x103C
;   r0x103D
;; Starting pCode block
_irqHandler:
; 0 exit points
;	.line	299; "main.c"	static void irqHandler(void) __interrupt 0 {
	MOVWF	WSAVE
	SWAPF	STATUS,W
	CLRF	STATUS
	MOVWF	SSAVE
	MOVF	PCLATH,W
	CLRF	PCLATH
	MOVWF	PSAVE
	MOVF	FSR,W
	BANKSEL	___sdcc_saved_fsr
	MOVWF	___sdcc_saved_fsr
;	.line	308; "main.c"	tickCounter++;
	BANKSEL	_irqHandler_tickCounter_65536_11
	INCF	_irqHandler_tickCounter_65536_11,F
;	.line	309; "main.c"	tickCounter &= 31;    // further division by 32 -> 4.096ms 
	MOVLW	0x1f
	ANDWF	_irqHandler_tickCounter_65536_11,F
;	.line	310; "main.c"	if (tickCounter == 0) {
	MOVF	_irqHandler_tickCounter_65536_11,W
	BTFSS	STATUS,2
	GOTO	_00141_DS_
;	.line	313; "main.c"	rowsOff();
	BANKSEL	_PORTCbits
	BCF	_PORTCbits,3
	BCF	_PORTCbits,5
	BCF	_PORTCbits,1
	BCF	_PORTCbits,2
	BCF	_PORTCbits,4
;	.line	315; "main.c"	j = display[digit];
	BANKSEL	_irqHandler_digit_65536_11
	MOVF	_irqHandler_digit_65536_11,W
	ADDLW	(_display + 0)
	BANKSEL	r0x103B
	MOVWF	r0x103B
	MOVLW	high (_display + 0)
	BTFSC	STATUS,0
	ADDLW	0x01
	MOVWF	r0x103C
	MOVF	r0x103B,W
	BANKSEL	FSR
	MOVWF	FSR
	BCF	STATUS,7
	BANKSEL	r0x103C
	BTFSC	r0x103C,0
	BSF	STATUS,7
	BANKSEL	INDF
	MOVF	INDF,W
	BANKSEL	r0x103D
	MOVWF	r0x103D
;	.line	316; "main.c"	for (i=0;i<8;i++) {
	CLRF	r0x103B
_00143_DS_:
;	.line	317; "main.c"	if ( j & 1) DOUT = 1;  else DOUT = 0;
	BANKSEL	r0x103D
	BTFSS	r0x103D,0
	GOTO	_00109_DS_
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,1
	GOTO	_00110_DS_
_00109_DS_:
	BANKSEL	_PORTAbits
	BCF	_PORTAbits,1
;;shiftRight_Left2ResultLit:5474: shCount=1, size=1, sign=0, same=1, offr=0
_00110_DS_:
;	.line	318; "main.c"	j>>=1;              
	BCF	STATUS,0
	BANKSEL	r0x103D
	RRF	r0x103D,F
;	.line	319; "main.c"	CLOCK=1;
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,2
;	.line	320; "main.c"	CLOCK=0;
	BCF	_PORTAbits,2
;	.line	316; "main.c"	for (i=0;i<8;i++) {
	BANKSEL	r0x103B
	INCF	r0x103B,F
;;unsigned compare: left < lit(0x8=8), size=1
	MOVLW	0x08
	SUBWF	r0x103B,W
	BTFSS	STATUS,0
	GOTO	_00143_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
;	.line	322; "main.c"	STROBE = 1;
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,0
;	.line	323; "main.c"	STROBE = 0;
	BCF	_PORTAbits,0
;;swapping arguments (AOP_TYPEs 1/3)
;;unsigned compare: left >= lit(0x5=5), size=1
;	.line	326; "main.c"	switch (digit) {
	MOVLW	0x05
	BANKSEL	_irqHandler_digit_65536_11
	SUBWF	_irqHandler_digit_65536_11,W
	BTFSC	STATUS,0
	GOTO	_00132_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
	MOVLW	HIGH(_00178_DS_)
	BANKSEL	PCLATH
	MOVWF	PCLATH
	MOVLW	_00178_DS_
	BANKSEL	_irqHandler_digit_65536_11
	ADDWF	_irqHandler_digit_65536_11,W
	BTFSS	STATUS,0
	GOTO	_00009_DS_
	BANKSEL	PCLATH
	INCF	PCLATH,F
_00009_DS_:
	MOVWF	PCL
_00178_DS_:
	GOTO	_00113_DS_
	GOTO	_00117_DS_
	GOTO	_00121_DS_
	GOTO	_00125_DS_
	GOTO	_00129_DS_
_00113_DS_:
;	.line	328; "main.c"	row1on();
	BANKSEL	_PORTCbits
	BSF	_PORTCbits,3
	BCF	_PORTCbits,5
	BCF	_PORTCbits,1
	BCF	_PORTCbits,2
	BCF	_PORTCbits,4
;	.line	329; "main.c"	break;
	GOTO	_00132_DS_
_00117_DS_:
;	.line	332; "main.c"	row2on(); 
	BANKSEL	_PORTCbits
	BCF	_PORTCbits,3
	BSF	_PORTCbits,5
	BCF	_PORTCbits,1
	BCF	_PORTCbits,2
	BCF	_PORTCbits,4
;	.line	333; "main.c"	break;
	GOTO	_00132_DS_
_00121_DS_:
;	.line	336; "main.c"	row3on();
	BANKSEL	_PORTCbits
	BCF	_PORTCbits,3
	BCF	_PORTCbits,5
	BSF	_PORTCbits,1
	BCF	_PORTCbits,2
	BCF	_PORTCbits,4
;	.line	337; "main.c"	break;
	GOTO	_00132_DS_
_00125_DS_:
;	.line	340; "main.c"	row4on(); 
	BANKSEL	_PORTCbits
	BCF	_PORTCbits,3
	BCF	_PORTCbits,5
	BCF	_PORTCbits,1
	BSF	_PORTCbits,2
	BCF	_PORTCbits,4
;	.line	341; "main.c"	break;
	GOTO	_00132_DS_
_00129_DS_:
;	.line	344; "main.c"	row5on(); 
	BANKSEL	_PORTCbits
	BCF	_PORTCbits,3
	BCF	_PORTCbits,5
	BCF	_PORTCbits,1
	BCF	_PORTCbits,2
	BSF	_PORTCbits,4
_00132_DS_:
;	.line	349; "main.c"	if (++digit > 4) {
	BANKSEL	_irqHandler_digit_65536_11
	INCF	_irqHandler_digit_65536_11,F
;;swapping arguments (AOP_TYPEs 1/3)
;;unsigned compare: left >= lit(0x5=5), size=1
	MOVLW	0x05
	SUBWF	_irqHandler_digit_65536_11,W
	BTFSS	STATUS,0
	GOTO	_00142_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
;	.line	350; "main.c"	digit = 0;
	CLRF	_irqHandler_digit_65536_11
;	.line	351; "main.c"	readyToGo = 1;                        // main tick every 20.48 ms 
	MOVLW	0x01
	BANKSEL	_readyToGo
	MOVWF	_readyToGo
	GOTO	_00142_DS_
_00141_DS_:
;	.line	353; "main.c"	} else if (tickCounter == tOFF ) {   // rudimentary PWM
	BANKSEL	_tOFF
	MOVF	_tOFF,W
	BANKSEL	_irqHandler_tickCounter_65536_11
	XORWF	_irqHandler_tickCounter_65536_11,W
	BTFSS	STATUS,2
	GOTO	_00142_DS_
;	.line	354; "main.c"	rowsOff();
	BANKSEL	_PORTCbits
	BCF	_PORTCbits,3
	BCF	_PORTCbits,5
	BCF	_PORTCbits,1
	BCF	_PORTCbits,2
	BCF	_PORTCbits,4
_00142_DS_:
;	.line	357; "main.c"	T0IF = 0;
	BANKSEL	_INTCONbits
	BCF	_INTCONbits,2
;	.line	358; "main.c"	}
	BANKSEL	___sdcc_saved_fsr
	MOVF	___sdcc_saved_fsr,W
	BANKSEL	FSR
	MOVWF	FSR
	MOVF	PSAVE,W
	MOVWF	PCLATH
	CLRF	STATUS
	SWAPF	SSAVE,W
	MOVWF	STATUS
	SWAPF	WSAVE,F
	SWAPF	WSAVE,W
END_OF_INTERRUPT:
	RETFIE	

;--------------------------------------------------------
; code
;--------------------------------------------------------
code_main	code
;***
;  pBlock Stats: dbName = M
;***
;has an exit
;functions called:
;   _initHardware
;   _readRtc
;   _runBrightnessControl
;   _readRtc
;   _runDisplayEngine
;   _buttonEvents
;   _runClockEngine
;   _writeRtc
;   _runDisplayError
;   _initHardware
;   _readRtc
;   _runBrightnessControl
;   _readRtc
;   _runDisplayEngine
;   _buttonEvents
;   _runClockEngine
;   _writeRtc
;   _runDisplayError
;1 compiler assigned register :
;   r0x103A
;; Starting pCode block
S_main__main	code
_main:
; 2 exit points
;	.line	369; "main.c"	initHardware();
	PAGESEL	_initHardware
	CALL	_initHardware
	PAGESEL	$
;	.line	371; "main.c"	if ( !readRtc() ) { // test RTC reading  at the beginning, initialize some values if failed
	PAGESEL	_readRtc
	CALL	_readRtc
	PAGESEL	$
	BANKSEL	r0x103A
	MOVWF	r0x103A
	MOVF	r0x103A,W
	BTFSS	STATUS,2
	GOTO	_00185_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	372; "main.c"	rtc.rawdata[0] = 0x00; // 00 Seconds
	BANKSEL	_rtc
	CLRF	(_rtc + 0)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	373; "main.c"	rtc.rawdata[1] = 0x23; // 23 Minutes
	MOVLW	0x23
;	.line	374; "main.c"	rtc.rawdata[2] = 0x23; // 23 Hours (in 24 hr format)
	MOVWF	(_rtc + 1)
	MOVWF	(_rtc + 2)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	375; "main.c"	rtc.rawdata[3] = 0x04; // 04 Day of week
	MOVLW	0x04
	MOVWF	(_rtc + 3)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	376; "main.c"	rtc.rawdata[4] = 0x23; // 23 Day of Month
	MOVLW	0x23
	MOVWF	(_rtc + 4)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	377; "main.c"	rtc.rawdata[5] = 0x04; // 04 Month (+ century=0)
	MOVLW	0x04
	MOVWF	(_rtc + 5)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	378; "main.c"	rtc.rawdata[6] = 0x23; // 23 Year
	MOVLW	0x23
	MOVWF	(_rtc + 6)
_00185_DS_:
;	.line	391; "main.c"	while (!readyToGo); // wait for 16ms flag
	BANKSEL	_readyToGo
	MOVF	_readyToGo,W
	BTFSC	STATUS,2
	GOTO	_00185_DS_
;	.line	392; "main.c"	readyToGo=0;        // reset go flag 
	CLRF	_readyToGo
;	.line	394; "main.c"	runBrightnessControl ();
	PAGESEL	_runBrightnessControl
	CALL	_runBrightnessControl
	PAGESEL	$
;	.line	402; "main.c"	if ( readRtc ( )  ) {
	PAGESEL	_readRtc
	CALL	_readRtc
	PAGESEL	$
	BANKSEL	r0x103A
	MOVWF	r0x103A
	MOVF	r0x103A,W
	BTFSC	STATUS,2
	GOTO	_00191_DS_
;	.line	403; "main.c"	runDisplayEngine();        
	PAGESEL	_runDisplayEngine
	CALL	_runDisplayEngine
	PAGESEL	$
;	.line	404; "main.c"	runClockEngine( buttonEvents () );
	PAGESEL	_buttonEvents
	CALL	_buttonEvents
	PAGESEL	$
	BANKSEL	r0x103A
	MOVWF	r0x103A
	PAGESEL	_runClockEngine
	CALL	_runClockEngine
	PAGESEL	$
;	.line	405; "main.c"	if (timeChanged) {    // TODO check for error during write to RTC
	BANKSEL	_timeChanged
	MOVF	_timeChanged,W
	BTFSC	STATUS,2
	GOTO	_00185_DS_
;	.line	406; "main.c"	writeRtc ( );
	PAGESEL	_writeRtc
	CALL	_writeRtc
	PAGESEL	$
;	.line	407; "main.c"	timeChanged = false;
	BANKSEL	_timeChanged
	CLRF	_timeChanged
	GOTO	_00185_DS_
_00191_DS_:
;	.line	410; "main.c"	runDisplayError();
	PAGESEL	_runDisplayError
	CALL	_runDisplayError
	PAGESEL	$
	GOTO	_00185_DS_
;	.line	422; "main.c"	} // main
	RETURN	
; exit point of _main

;***
;  pBlock Stats: dbName = C
;***
;; Starting pCode block
S_main__runDisplayError	code
_runDisplayError:
; 0 exit points
;	.line	835; "main.c"	if (sequentialCounter == 0) {
	BANKSEL	_runDisplayError_sequentialCounter_65536_141
	MOVF	_runDisplayError_sequentialCounter_65536_141,W
	BTFSS	STATUS,2
	GOTO	_00673_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	836; "main.c"	display[0] = 0x55;
	MOVLW	0x55
;	.line	837; "main.c"	display[1] = 0x55;
	BANKSEL	_display
	MOVWF	(_display + 0)
	MOVWF	(_display + 1)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	838; "main.c"	display[2] = 0xA5;
	MOVLW	0xa5
	MOVWF	(_display + 2)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	839; "main.c"	display[3] = 0xAA;
	MOVLW	0xaa
;	.line	840; "main.c"	display[4] = 0xAA;   
	MOVWF	(_display + 3)
	MOVWF	(_display + 4)
_00673_DS_:
;	.line	843; "main.c"	if (sequentialCounter == 10) {
	BANKSEL	_runDisplayError_sequentialCounter_65536_141
	MOVF	_runDisplayError_sequentialCounter_65536_141,W
	XORLW	0x0a
	BTFSS	STATUS,2
	GOTO	_00675_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	844; "main.c"	display[0] = 0xAA;
	MOVLW	0xaa
;	.line	845; "main.c"	display[1] = 0xAA;
	BANKSEL	_display
	MOVWF	(_display + 0)
	MOVWF	(_display + 1)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	846; "main.c"	display[2] = 0x5A;
	MOVLW	0x5a
	MOVWF	(_display + 2)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	847; "main.c"	display[3] = 0x55;
	MOVLW	0x55
;	.line	848; "main.c"	display[4] = 0x55;	   
	MOVWF	(_display + 3)
	MOVWF	(_display + 4)
_00675_DS_:
;	.line	851; "main.c"	sequentialCounter++; 
	BANKSEL	_runDisplayError_sequentialCounter_65536_141
	INCF	_runDisplayError_sequentialCounter_65536_141,F
;;swapping arguments (AOP_TYPEs 1/3)
;;unsigned compare: left >= lit(0x15=21), size=1
;	.line	852; "main.c"	if (sequentialCounter > 20 ) sequentialCounter = 0;  // ~200ms
	MOVLW	0x15
;	.line	853; "main.c"	}
	SUBWF	_runDisplayError_sequentialCounter_65536_141,W
	BTFSC	STATUS,0
	CLRF	_runDisplayError_sequentialCounter_65536_141
	RETURN	

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;4 compiler assigned registers:
;   r0x101D
;   r0x101E
;   r0x101F
;   r0x1020
;; Starting pCode block
S_main__runBrightnessControl	code
_runBrightnessControl:
; 2 exit points
;	.line	810; "main.c"	if (++lighSenseCounter == 49 )  {  // overflow @ every ~1 second (49 * 20.5ms)
	BANKSEL	_runBrightnessControl_lighSenseCounter_65536_137
	INCF	_runBrightnessControl_lighSenseCounter_65536_137,F
	MOVF	_runBrightnessControl_lighSenseCounter_65536_137,W
	XORLW	0x31
	BTFSS	STATUS,2
	GOTO	_00667_DS_
;	.line	811; "main.c"	lighSenseCounter = 0;
	CLRF	_runBrightnessControl_lighSenseCounter_65536_137
;	.line	812; "main.c"	if (GO_NOT_DONE==0) {   // New value available
	BANKSEL	_ADCON0bits
	BTFSC	_ADCON0bits,1
	GOTO	_00667_DS_
;	.line	814; "main.c"	adcValue = ADRESH;   // read ADC value 
	MOVF	_ADRESH,W
	BANKSEL	___TEMP_ADC
	MOVWF	___TEMP_ADC
	BANKSEL	r0x101D
	MOVWF	r0x101D
;	.line	815; "main.c"	GO_NOT_DONE = 1;     // start the next conversion    
	BANKSEL	_ADCON0bits
	BSF	_ADCON0bits,1
;;103	MOVF	r0x101D,W
;;unsigned compare: left < lit(0x37=55), size=1
;	.line	818; "main.c"	if (adcValue < VMIN) 
	MOVLW	0x37
	BANKSEL	r0x101D
	SUBWF	r0x101D,W
	BTFSC	STATUS,0
	GOTO	_00661_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
;	.line	819; "main.c"	adcValue = VMIN;
	MOVLW	0x37
	MOVWF	r0x101D
	GOTO	_00662_DS_
;;swapping arguments (AOP_TYPEs 1/2)
;;unsigned compare: left >= lit(0xB7=183), size=1
_00661_DS_:
;	.line	820; "main.c"	else if (adcValue > VMAX)
	MOVLW	0xb7
	BANKSEL	r0x101D
	SUBWF	r0x101D,W
	BTFSS	STATUS,0
	GOTO	_00662_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
;	.line	821; "main.c"	adcValue = VMAX;
	MOVLW	0xb6
	MOVWF	r0x101D
_00662_DS_:
;	.line	823; "main.c"	tOFF = 1 + ( (adcValue-VMIN) >> 2);
	BANKSEL	r0x101D
	MOVF	r0x101D,W
	MOVWF	r0x101E
	CLRF	r0x101F
	MOVLW	0xc9
	ADDWF	r0x101E,W
	MOVWF	r0x101D
	MOVLW	0xff
	MOVWF	r0x1020
	MOVLW	0x00
	BTFSC	STATUS,0
	INCFSZ	r0x101F,W
	ADDWF	r0x1020,F
;;shiftRight_Left2ResultLit:5474: shCount=1, size=2, sign=1, same=0, offr=0
	BCF	STATUS,0
	BTFSC	r0x1020,7
	BSF	STATUS,0
	RRF	r0x1020,W
	MOVWF	r0x101F
	RRF	r0x101D,W
	MOVWF	r0x101E
;;shiftRight_Left2ResultLit:5474: shCount=1, size=2, sign=1, same=1, offr=0
	BCF	STATUS,0
	BTFSC	r0x101F,7
	BSF	STATUS,0
	RRF	r0x101F,F
	RRF	r0x101E,F
	MOVF	r0x101E,W
	MOVWF	r0x101D
	INCF	r0x101D,W
	BANKSEL	_tOFF
	MOVWF	_tOFF
_00667_DS_:
;	.line	828; "main.c"	}
	RETURN	
; exit point of _runBrightnessControl

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;1 compiler assigned register :
;   r0x1021
;; Starting pCode block
S_main__runDisplayEngine	code
_runDisplayEngine:
; 2 exit points
;	.line	721; "main.c"	switch ( rtc.datetime.hours.units ) { // units of hours
	BANKSEL	_rtc
	MOVF	(_rtc + 2),W
	ANDLW	0x0f
	BANKSEL	r0x1021
	MOVWF	r0x1021
;;swapping arguments (AOP_TYPEs 1/2)
;;unsigned compare: left >= lit(0xA=10), size=1
	MOVLW	0x0a
	SUBWF	r0x1021,W
	BTFSC	STATUS,0
	GOTO	_00576_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
	MOVLW	HIGH(_00647_DS_)
	BANKSEL	PCLATH
	MOVWF	PCLATH
	MOVLW	_00647_DS_
	BANKSEL	r0x1021
	ADDWF	r0x1021,W
	BTFSS	STATUS,0
	GOTO	_00001_DS_
	BANKSEL	PCLATH
	INCF	PCLATH,F
_00001_DS_:
	MOVWF	PCL
_00647_DS_:
	GOTO	_00576_DS_
	GOTO	_00574_DS_
	GOTO	_00573_DS_
	GOTO	_00572_DS_
	GOTO	_00571_DS_
	GOTO	_00570_DS_
	GOTO	_00569_DS_
	GOTO	_00568_DS_
	GOTO	_00567_DS_
	GOTO	_00566_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00566_DS_:
;	.line	722; "main.c"	case 9: displayBuf[1] = 0b00000111; displayBuf[0] = 0b01110111; break;  
	MOVLW	0x07
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 1)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x77
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 0)
	GOTO	_00577_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00567_DS_:
;	.line	723; "main.c"	case 8: displayBuf[1] = 0b00000011; displayBuf[0] = 0b01110111; break;
	MOVLW	0x03
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 1)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x77
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 0)
	GOTO	_00577_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00568_DS_:
;	.line	724; "main.c"	case 7: displayBuf[1] = 0b00000001; displayBuf[0] = 0b01110111; break; 
	MOVLW	0x01
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 1)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x77
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 0)
	GOTO	_00577_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00569_DS_:
;	.line	725; "main.c"	case 6: displayBuf[1] = 0b00000000; displayBuf[0] = 0b01110111; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 1)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x77
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 0)
	GOTO	_00577_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00570_DS_:
;	.line	726; "main.c"	case 5: displayBuf[1] = 0b00000000; displayBuf[0] = 0b00110111; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 1)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x37
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 0)
	GOTO	_00577_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00571_DS_:
;	.line	727; "main.c"	case 4: displayBuf[1] = 0b00000000; displayBuf[0] = 0b00010111; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 1)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x17
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 0)
	GOTO	_00577_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00572_DS_:
;	.line	728; "main.c"	case 3: displayBuf[1] = 0b00000000; displayBuf[0] = 0b00000111; break; 
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 1)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x07
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 0)
	GOTO	_00577_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00573_DS_:
;	.line	729; "main.c"	case 2: displayBuf[1] = 0b00000000; displayBuf[0] = 0b00000011; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 1)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x03
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 0)
	GOTO	_00577_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00574_DS_:
;	.line	730; "main.c"	case 1: displayBuf[1] = 0b00000000; displayBuf[0] = 0b00000001; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 1)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x01
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 0)
	GOTO	_00577_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00576_DS_:
;	.line	732; "main.c"	default:displayBuf[1] = 0b00000000; displayBuf[0] = 0b00000000; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 1)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 0)
_00577_DS_:
;	.line	735; "main.c"	switch ( rtc.datetime.hours.tens ) { // tens of hours
	BANKSEL	_rtc
	MOVF	(_rtc + 2),W
	ANDLW	0x30
	BANKSEL	r0x1021
	MOVWF	r0x1021
	SWAPF	r0x1021,F
	MOVLW	0x0f
	ANDWF	r0x1021,F
;;swapping arguments (AOP_TYPEs 1/2)
;;unsigned compare: left >= lit(0x3=3), size=1
	MOVLW	0x03
	SUBWF	r0x1021,W
	BTFSC	STATUS,0
	GOTO	_00581_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
	MOVLW	HIGH(_00649_DS_)
	BANKSEL	PCLATH
	MOVWF	PCLATH
	MOVLW	_00649_DS_
	BANKSEL	r0x1021
	ADDWF	r0x1021,W
	BTFSS	STATUS,0
	GOTO	_00002_DS_
	BANKSEL	PCLATH
	INCF	PCLATH,F
_00002_DS_:
	MOVWF	PCL
_00649_DS_:
	GOTO	_00581_DS_
	GOTO	_00579_DS_
	GOTO	_00578_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00578_DS_:
;	.line	736; "main.c"	case 2: displayBuf[2] = 0b00001100; break;
	MOVLW	0x0c
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 2)
	GOTO	_00582_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00579_DS_:
;	.line	737; "main.c"	case 1: displayBuf[2] = 0b00001000; break;
	MOVLW	0x08
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 2)
	GOTO	_00582_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00581_DS_:
;	.line	739; "main.c"	default:displayBuf[2] = 0b00000000; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 2)
_00582_DS_:
;	.line	743; "main.c"	switch ( rtc.datetime.minutes.units ) { // units of minutes
	BANKSEL	_rtc
	MOVF	(_rtc + 1),W
	ANDLW	0x0f
	BANKSEL	r0x1021
	MOVWF	r0x1021
;;swapping arguments (AOP_TYPEs 1/2)
;;unsigned compare: left >= lit(0xA=10), size=1
	MOVLW	0x0a
	SUBWF	r0x1021,W
	BTFSC	STATUS,0
	GOTO	_00593_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
	MOVLW	HIGH(_00651_DS_)
	BANKSEL	PCLATH
	MOVWF	PCLATH
	MOVLW	_00651_DS_
	BANKSEL	r0x1021
	ADDWF	r0x1021,W
	BTFSS	STATUS,0
	GOTO	_00003_DS_
	BANKSEL	PCLATH
	INCF	PCLATH,F
_00003_DS_:
	MOVWF	PCL
_00651_DS_:
	GOTO	_00593_DS_
	GOTO	_00591_DS_
	GOTO	_00590_DS_
	GOTO	_00589_DS_
	GOTO	_00588_DS_
	GOTO	_00587_DS_
	GOTO	_00586_DS_
	GOTO	_00585_DS_
	GOTO	_00584_DS_
	GOTO	_00583_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00583_DS_:
;	.line	744; "main.c"	case 9: displayBuf[4] = 0b00000111; displayBuf[3] = 0b01110111; break;  
	MOVLW	0x07
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 4)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x77
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 3)
	GOTO	_00594_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00584_DS_:
;	.line	745; "main.c"	case 8: displayBuf[4] = 0b00000011; displayBuf[3] = 0b01110111; break;
	MOVLW	0x03
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 4)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x77
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 3)
	GOTO	_00594_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00585_DS_:
;	.line	746; "main.c"	case 7: displayBuf[4] = 0b00000001; displayBuf[3] = 0b01110111; break; 
	MOVLW	0x01
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 4)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x77
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 3)
	GOTO	_00594_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00586_DS_:
;	.line	747; "main.c"	case 6: displayBuf[4] = 0b00000000; displayBuf[3] = 0b01110111; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 4)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x77
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 3)
	GOTO	_00594_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00587_DS_:
;	.line	748; "main.c"	case 5: displayBuf[4] = 0b00000000; displayBuf[3] = 0b00110111; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 4)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x37
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 3)
	GOTO	_00594_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00588_DS_:
;	.line	749; "main.c"	case 4: displayBuf[4] = 0b00000000; displayBuf[3] = 0b00010111; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 4)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x17
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 3)
	GOTO	_00594_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00589_DS_:
;	.line	750; "main.c"	case 3: displayBuf[4] = 0b00000000; displayBuf[3] = 0b00000111; break; 
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 4)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x07
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 3)
	GOTO	_00594_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00590_DS_:
;	.line	751; "main.c"	case 2: displayBuf[4] = 0b00000000; displayBuf[3] = 0b00000011; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 4)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x03
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 3)
	GOTO	_00594_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00591_DS_:
;	.line	752; "main.c"	case 1: displayBuf[4] = 0b00000000; displayBuf[3] = 0b00000001; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 4)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVLW	0x01
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 3)
	GOTO	_00594_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
_00593_DS_:
;	.line	754; "main.c"	default:displayBuf[4] = 0b00000000; displayBuf[3] = 0b00000000; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 4)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 3)
_00594_DS_:
;	.line	758; "main.c"	switch ( rtc.datetime.minutes.tens ) { // tens of minutes
	BANKSEL	_rtc
	MOVF	(_rtc + 1),W
	ANDLW	0x70
	BANKSEL	r0x1021
	MOVWF	r0x1021
	SWAPF	r0x1021,F
	MOVLW	0x0f
	ANDWF	r0x1021,F
;;swapping arguments (AOP_TYPEs 1/2)
;;unsigned compare: left >= lit(0x6=6), size=1
	MOVLW	0x06
	SUBWF	r0x1021,W
	BTFSC	STATUS,0
	GOTO	_00601_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
	MOVLW	HIGH(_00653_DS_)
	BANKSEL	PCLATH
	MOVWF	PCLATH
	MOVLW	_00653_DS_
	BANKSEL	r0x1021
	ADDWF	r0x1021,W
	BTFSS	STATUS,0
	GOTO	_00004_DS_
	BANKSEL	PCLATH
	INCF	PCLATH,F
_00004_DS_:
	MOVWF	PCL
_00653_DS_:
	GOTO	_00601_DS_
	GOTO	_00599_DS_
	GOTO	_00598_DS_
	GOTO	_00597_DS_
	GOTO	_00596_DS_
	GOTO	_00595_DS_
_00595_DS_:
;	.line	759; "main.c"	case 5: displayBuf[2] |= 0b11010000; displayBuf[4] |= 0b11000000; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 2),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	MOVLW	0xd0
	IORWF	r0x1021,F
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVF	r0x1021,W
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 2)
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 4),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	MOVLW	0xc0
	IORWF	r0x1021,F
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVF	r0x1021,W
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 4)
	GOTO	_00602_DS_
_00596_DS_:
;	.line	760; "main.c"	case 4: displayBuf[2] |= 0b10110000; displayBuf[4] |= 0b10000000; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 2),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	MOVLW	0xb0
	IORWF	r0x1021,F
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVF	r0x1021,W
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 2)
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 4),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	BSF	r0x1021,7
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVF	r0x1021,W
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 4)
	GOTO	_00602_DS_
_00597_DS_:
;	.line	761; "main.c"	case 3: displayBuf[2] |= 0b11100000; displayBuf[4] |= 0b00000000; break; 
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 2),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	MOVLW	0xe0
	IORWF	r0x1021,F
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVF	r0x1021,W
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 2)
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 4),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 4)
	GOTO	_00602_DS_
_00598_DS_:
;	.line	762; "main.c"	case 2: displayBuf[2] |= 0b11000000; displayBuf[4] |= 0b00000000; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 2),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	MOVLW	0xc0
	IORWF	r0x1021,F
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVF	r0x1021,W
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 2)
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 4),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 4)
	GOTO	_00602_DS_
_00599_DS_:
;	.line	763; "main.c"	case 1: displayBuf[2] |= 0b10000000; displayBuf[4] |= 0b00000000; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 2),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	BSF	r0x1021,7
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVF	r0x1021,W
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 2)
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 4),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 4)
	GOTO	_00602_DS_
_00601_DS_:
;	.line	765; "main.c"	default:displayBuf[2] |= 0b00000000; displayBuf[4] |= 0b00000000; break;
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 2),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 2)
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 4),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 4)
;;swapping arguments (AOP_TYPEs 1/3)
;;unsigned compare: left >= lit(0xB=11), size=1
_00602_DS_:
;	.line	770; "main.c"	if ( sequentialCounter > 10)  { // Display mode	  
	MOVLW	0x0b
	BANKSEL	_runDisplayEngine_sequentialCounter_65536_128
	SUBWF	_runDisplayEngine_sequentialCounter_65536_128,W
	BTFSS	STATUS,0
	GOTO	_00609_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
;	.line	771; "main.c"	if ( operatingState == ST_SET_HOUR) {
	BANKSEL	_operatingState
	MOVF	_operatingState,W
	XORLW	0x01
	BTFSS	STATUS,2
	GOTO	_00606_DS_
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	772; "main.c"	displayBuf[0] = 0;     // blank upper row of segments
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 0)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	773; "main.c"	displayBuf[1] = 0; 
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 1)
;	.line	774; "main.c"	displayBuf[2] &= 0xf0;
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 2),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	MOVLW	0xf0
	ANDWF	r0x1021,F
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVF	r0x1021,W
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 2)
	GOTO	_00609_DS_
_00606_DS_:
;	.line	775; "main.c"	} else if ( operatingState == ST_SET_MINUTE){
	BANKSEL	_operatingState
	MOVF	_operatingState,W
	XORLW	0x02
	BTFSS	STATUS,2
	GOTO	_00609_DS_
;	.line	776; "main.c"	displayBuf[2] &= 0x0f;   // blank lower row of segments
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 2),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	MOVLW	0x0f
	ANDWF	r0x1021,F
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
	MOVF	r0x1021,W
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVWF	(_runDisplayEngine_displayBuf_65536_128 + 2)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	777; "main.c"	displayBuf[3] = 0; 
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 3)
;;/home/sdcc-builder/build/sdcc-build/orig/sdcc/src/pic14/gen.c:6828: size=0, offset=0, AOP_TYPE(res)=8
;	.line	778; "main.c"	displayBuf[4] = 0;  
	CLRF	(_runDisplayEngine_displayBuf_65536_128 + 4)
_00609_DS_:
;	.line	782; "main.c"	sequentialCounter++; 
	BANKSEL	_runDisplayEngine_sequentialCounter_65536_128
	INCF	_runDisplayEngine_sequentialCounter_65536_128,F
;;swapping arguments (AOP_TYPEs 1/3)
;;unsigned compare: left >= lit(0x15=21), size=1
;	.line	783; "main.c"	if (sequentialCounter > 20 ) sequentialCounter = 0;  // ~200ms
	MOVLW	0x15
;	.line	786; "main.c"	display[0] = displayBuf[0];
	SUBWF	_runDisplayEngine_sequentialCounter_65536_128,W
	BTFSC	STATUS,0
	CLRF	_runDisplayEngine_sequentialCounter_65536_128
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 0),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	BANKSEL	_display
	MOVWF	(_display + 0)
;	.line	787; "main.c"	display[1] = displayBuf[1];
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 1),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	BANKSEL	_display
	MOVWF	(_display + 1)
;	.line	788; "main.c"	display[2] = displayBuf[2];
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 2),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	BANKSEL	_display
	MOVWF	(_display + 2)
;	.line	789; "main.c"	display[3] = displayBuf[3];
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 3),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	BANKSEL	_display
	MOVWF	(_display + 3)
;	.line	790; "main.c"	display[4] = displayBuf[4];   
	BANKSEL	_runDisplayEngine_displayBuf_65536_128
	MOVF	(_runDisplayEngine_displayBuf_65536_128 + 4),W
	BANKSEL	r0x1021
	MOVWF	r0x1021
	BANKSEL	_display
	MOVWF	(_display + 4)
;	.line	792; "main.c"	}
	RETURN	
; exit point of _runDisplayEngine

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;functions called:
;   _advanceHour
;   _advanceMinute
;   _advanceHour
;   _advanceMinute
;1 compiler assigned register :
;   r0x1028
;; Starting pCode block
S_main__runClockEngine	code
_runClockEngine:
; 2 exit points
;	.line	689; "main.c"	void runClockEngine( t_buttonEvents btEvent ){
	BANKSEL	r0x1028
	MOVWF	r0x1028
;;swapping arguments (AOP_TYPEs 1/3)
;;unsigned compare: left >= lit(0x3=3), size=1
;	.line	691; "main.c"	switch ( operatingState ) {
	MOVLW	0x03
	BANKSEL	_operatingState
	SUBWF	_operatingState,W
	BTFSC	STATUS,0
	GOTO	_00534_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
	MOVLW	HIGH(_00561_DS_)
	BANKSEL	PCLATH
	MOVWF	PCLATH
	MOVLW	_00561_DS_
	BANKSEL	_operatingState
	ADDWF	_operatingState,W
	BTFSS	STATUS,0
	GOTO	_00005_DS_
	BANKSEL	PCLATH
	INCF	PCLATH,F
_00005_DS_:
	MOVWF	PCL
_00561_DS_:
	GOTO	_00520_DS_
	GOTO	_00523_DS_
	GOTO	_00528_DS_
_00520_DS_:
;	.line	693; "main.c"	if ( btEvent == EV_SET_LONG ) operatingState = ST_SET_HOUR;
	BANKSEL	r0x1028
	MOVF	r0x1028,W
	XORLW	0x02
	BTFSS	STATUS,2
	GOTO	_00534_DS_
	MOVLW	0x01
	BANKSEL	_operatingState
	MOVWF	_operatingState
;	.line	695; "main.c"	break;
	GOTO	_00534_DS_
_00523_DS_:
;	.line	698; "main.c"	if ( btEvent == EV_SET_LONG )  operatingState = ST_SET_MINUTE;	
	BANKSEL	r0x1028
	MOVF	r0x1028,W
	XORLW	0x02
	BTFSS	STATUS,2
	GOTO	_00525_DS_
	MOVLW	0x02
	BANKSEL	_operatingState
	MOVWF	_operatingState
_00525_DS_:
;	.line	699; "main.c"	if ( btEvent == EV_SET_PULSE ) advanceHour();	
	BANKSEL	r0x1028
	MOVF	r0x1028,W
	XORLW	0x01
	BTFSS	STATUS,2
	GOTO	_00534_DS_
	PAGESEL	_advanceHour
	CALL	_advanceHour
	PAGESEL	$
;	.line	701; "main.c"	break;
	GOTO	_00534_DS_
_00528_DS_:
;	.line	704; "main.c"	if ( btEvent == EV_SET_LONG )  operatingState = ST_SHOW_TIME;	
	BANKSEL	r0x1028
	MOVF	r0x1028,W
;	.line	705; "main.c"	if ( btEvent == EV_SET_PULSE ) advanceMinute();	
	XORLW	0x02
	BTFSS	STATUS,2
	GOTO	_00006_DS_
	BANKSEL	_operatingState
	CLRF	_operatingState
_00006_DS_:
	BANKSEL	r0x1028
	MOVF	r0x1028,W
	XORLW	0x01
	BTFSS	STATUS,2
	GOTO	_00534_DS_
	PAGESEL	_advanceMinute
	CALL	_advanceMinute
	PAGESEL	$
_00534_DS_:
;	.line	709; "main.c"	}
	RETURN	
; exit point of _runClockEngine

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;functions called:
;   __mulint
;   __modsint
;   __divsint
;   __modsint
;   __mulint
;   __modsint
;   __divsint
;   __modsint
;9 compiler assigned registers:
;   r0x1022
;   r0x1023
;   r0x1024
;   STK02
;   STK01
;   STK00
;   r0x1025
;   r0x1026
;   r0x1027
;; Starting pCode block
S_main__advanceMinute	code
_advanceMinute:
; 2 exit points
;	.line	673; "main.c"	uint8_t d = (1
	BANKSEL	_rtc
	MOVF	(_rtc + 1),W
	ANDLW	0x70
	BANKSEL	r0x1022
	MOVWF	r0x1022
	SWAPF	r0x1022,F
	MOVLW	0x0f
	ANDWF	r0x1022,F
;;102	MOVF	r0x1022,W
	CLRF	r0x1024
;;101	MOVF	r0x1023,W
	MOVF	r0x1022,W
	MOVWF	r0x1023
	MOVWF	STK02
	MOVLW	0x00
	MOVWF	STK01
	MOVLW	0x0a
	MOVWF	STK00
	MOVLW	0x00
	PAGESEL	__mulint
	CALL	__mulint
	PAGESEL	$
	BANKSEL	r0x1023
	MOVWF	r0x1023
	MOVF	STK00,W
	MOVWF	r0x1022
	INCF	r0x1022,F
	BTFSC	STATUS,2
	INCF	r0x1023,F
	BANKSEL	_rtc
	MOVF	(_rtc + 1),W
	ANDLW	0x0f
	BANKSEL	r0x1024
	MOVWF	r0x1024
	MOVWF	r0x1025
	CLRF	r0x1026
	MOVF	r0x1025,W
	ADDWF	r0x1022,F
	MOVLW	0x00
	BTFSC	STATUS,0
	INCFSZ	r0x1026,W
	ADDWF	r0x1023,F
	MOVLW	0x3c
	MOVWF	STK02
	MOVLW	0x00
	MOVWF	STK01
	MOVF	r0x1022,W
	MOVWF	STK00
	MOVF	r0x1023,W
	PAGESEL	__modsint
	CALL	__modsint
	PAGESEL	$
	BANKSEL	r0x1023
	MOVWF	r0x1023
	MOVF	STK00,W
	MOVWF	r0x1022
;	.line	677; "main.c"	rtc.datetime.minutes.tens = ( (uint8_t) d / 10 )  & 0b00000111;
	MOVWF	r0x1024
	MOVWF	r0x1022
	CLRF	r0x1023
	MOVLW	0x0a
	MOVWF	STK02
	MOVLW	0x00
	MOVWF	STK01
	MOVF	r0x1022,W
	MOVWF	STK00
	MOVLW	0x00
	PAGESEL	__divsint
	CALL	__divsint
	PAGESEL	$
	BANKSEL	r0x1025
	MOVWF	r0x1025
	MOVF	STK00,W
	MOVWF	r0x1024
	MOVWF	r0x1026
	MOVLW	0x07
	ANDWF	r0x1026,W
	MOVWF	r0x1024
	ANDLW	0x07
	MOVWF	r0x1027
	SWAPF	r0x1027,F
	MOVLW	0xf0
	ANDWF	r0x1027,F
	BANKSEL	_rtc
	MOVF	(_rtc + 1),W
	ANDLW	0x8f
	BANKSEL	r0x1027
	IORWF	r0x1027,W
	BANKSEL	_rtc
	MOVWF	(_rtc + 1)
;	.line	678; "main.c"	rtc.datetime.minutes.units = ( (uint8_t) d % 10 ) & 0b00001111;
	MOVLW	0x0a
	MOVWF	STK02
	MOVLW	0x00
	MOVWF	STK01
	BANKSEL	r0x1022
	MOVF	r0x1022,W
	MOVWF	STK00
	MOVF	r0x1023,W
	PAGESEL	__modsint
	CALL	__modsint
	PAGESEL	$
	BANKSEL	r0x1023
	MOVWF	r0x1023
	MOVF	STK00,W
	MOVWF	r0x1022
	MOVWF	r0x1024
	MOVLW	0x0f
	ANDWF	r0x1024,W
	MOVWF	r0x1022
	ANDLW	0x0f
	MOVWF	r0x1027
	BANKSEL	_rtc
	MOVF	(_rtc + 1),W
	ANDLW	0xf0
	BANKSEL	r0x1027
	IORWF	r0x1027,W
	BANKSEL	_rtc
	MOVWF	(_rtc + 1)
;	.line	679; "main.c"	rtc.datetime.hours.op12_24 = 0; // force 24 hour mode
	BCF	(_rtc+2),6
;	.line	680; "main.c"	timeChanged = true; // update rtc data
	MOVLW	0x01
	BANKSEL	_timeChanged
	MOVWF	_timeChanged
;	.line	682; "main.c"	}
	RETURN	
; exit point of _advanceMinute

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;functions called:
;   __mulint
;   __modsint
;   __divsint
;   __modsint
;   __mulint
;   __modsint
;   __divsint
;   __modsint
;9 compiler assigned registers:
;   r0x1022
;   r0x1023
;   r0x1024
;   STK02
;   STK01
;   STK00
;   r0x1025
;   r0x1026
;   r0x1027
;; Starting pCode block
S_main__advanceHour	code
_advanceHour:
; 2 exit points
;	.line	658; "main.c"	uint8_t d = ((1
	BANKSEL	_rtc
	MOVF	(_rtc + 2),W
	ANDLW	0x30
	BANKSEL	r0x1022
	MOVWF	r0x1022
	SWAPF	r0x1022,F
	MOVLW	0x0f
	ANDWF	r0x1022,F
;;100	MOVF	r0x1022,W
	CLRF	r0x1024
;;99	MOVF	r0x1023,W
	MOVF	r0x1022,W
	MOVWF	r0x1023
	MOVWF	STK02
	MOVLW	0x00
	MOVWF	STK01
	MOVLW	0x0a
	MOVWF	STK00
	MOVLW	0x00
	PAGESEL	__mulint
	CALL	__mulint
	PAGESEL	$
	BANKSEL	r0x1023
	MOVWF	r0x1023
	MOVF	STK00,W
	MOVWF	r0x1022
	INCF	r0x1022,F
	BTFSC	STATUS,2
	INCF	r0x1023,F
	BANKSEL	_rtc
	MOVF	(_rtc + 2),W
	ANDLW	0x0f
	BANKSEL	r0x1024
	MOVWF	r0x1024
	MOVWF	r0x1025
	CLRF	r0x1026
	MOVF	r0x1025,W
	ADDWF	r0x1022,F
	MOVLW	0x00
	BTFSC	STATUS,0
	INCFSZ	r0x1026,W
	ADDWF	r0x1023,F
	MOVLW	0x18
	MOVWF	STK02
	MOVLW	0x00
	MOVWF	STK01
	MOVF	r0x1022,W
	MOVWF	STK00
	MOVF	r0x1023,W
	PAGESEL	__modsint
	CALL	__modsint
	PAGESEL	$
	BANKSEL	r0x1023
	MOVWF	r0x1023
	MOVF	STK00,W
	MOVWF	r0x1022
;	.line	662; "main.c"	rtc.datetime.hours.tens = ( (uint8_t) d / 10 )  & 0b00000011;
	MOVWF	r0x1024
	MOVWF	r0x1022
	CLRF	r0x1023
	MOVLW	0x0a
	MOVWF	STK02
	MOVLW	0x00
	MOVWF	STK01
	MOVF	r0x1022,W
	MOVWF	STK00
	MOVLW	0x00
	PAGESEL	__divsint
	CALL	__divsint
	PAGESEL	$
	BANKSEL	r0x1025
	MOVWF	r0x1025
	MOVF	STK00,W
	MOVWF	r0x1024
	MOVWF	r0x1026
	MOVLW	0x03
	ANDWF	r0x1026,W
	MOVWF	r0x1024
	ANDLW	0x03
	MOVWF	r0x1027
	SWAPF	r0x1027,F
	MOVLW	0xf0
	ANDWF	r0x1027,F
	BANKSEL	_rtc
	MOVF	(_rtc + 2),W
	ANDLW	0xcf
	BANKSEL	r0x1027
	IORWF	r0x1027,W
	BANKSEL	_rtc
	MOVWF	(_rtc + 2)
;	.line	663; "main.c"	rtc.datetime.hours.units = ( (uint8_t) d % 10 ) & 0b00001111;
	MOVLW	0x0a
	MOVWF	STK02
	MOVLW	0x00
	MOVWF	STK01
	BANKSEL	r0x1022
	MOVF	r0x1022,W
	MOVWF	STK00
	MOVF	r0x1023,W
	PAGESEL	__modsint
	CALL	__modsint
	PAGESEL	$
	BANKSEL	r0x1023
	MOVWF	r0x1023
	MOVF	STK00,W
	MOVWF	r0x1022
	MOVWF	r0x1024
	MOVLW	0x0f
	ANDWF	r0x1024,W
	MOVWF	r0x1022
	ANDLW	0x0f
	MOVWF	r0x1027
	BANKSEL	_rtc
	MOVF	(_rtc + 2),W
	ANDLW	0xf0
	BANKSEL	r0x1027
	IORWF	r0x1027,W
	BANKSEL	_rtc
	MOVWF	(_rtc + 2)
;	.line	664; "main.c"	rtc.datetime.hours.op12_24 = 0; // force 24 hour mode
	BCF	(_rtc+2),6
;	.line	665; "main.c"	timeChanged = true; // update rtc data
	MOVLW	0x01
	BANKSEL	_timeChanged
	MOVWF	_timeChanged
;	.line	668; "main.c"	}
	RETURN	
; exit point of _advanceHour

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;functions called:
;   _getButton
;   _getButton
;2 compiler assigned registers:
;   r0x1029
;   r0x102A
;; Starting pCode block
S_main__buttonEvents	code
_buttonEvents:
; 2 exit points
;	.line	617; "main.c"	uint8_t btEvent = EV_NOCHANGE;
	BANKSEL	r0x1029
	CLRF	r0x1029
;	.line	618; "main.c"	uint8_t buttonNow = getButton();
	PAGESEL	_getButton
	CALL	_getButton
	PAGESEL	$
	BANKSEL	r0x102A
	MOVWF	r0x102A
;	.line	620; "main.c"	switch (buttonNow ) {
	MOVF	r0x102A,W
	BTFSC	STATUS,2
	GOTO	_00475_DS_
	MOVF	r0x102A,W
	XORLW	0x01
	BTFSS	STATUS,2
	GOTO	_00479_DS_
;;unsigned compare: left < lit(0x19=25), size=1
;	.line	623; "main.c"	if ( btSetCount < th_LONG_PRESS ) {
	MOVLW	0x19
	BANKSEL	_buttonEvents_btSetCount_65536_115
	SUBWF	_buttonEvents_btSetCount_65536_115,W
	BTFSC	STATUS,0
	GOTO	_00480_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
;	.line	624; "main.c"	btSetCount++;                         // will stop count at threshold
	INCF	_buttonEvents_btSetCount_65536_115,F
;;unsigned compare: left < lit(0x19=25), size=1
;	.line	625; "main.c"	if ( btSetCount >= th_LONG_PRESS ) { // and generate an unique long press event
	MOVLW	0x19
	SUBWF	_buttonEvents_btSetCount_65536_115,W
	BTFSS	STATUS,0
	GOTO	_00480_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
;	.line	626; "main.c"	btEvent  = EV_SET_LONG;
	MOVLW	0x02
	BANKSEL	r0x1029
	MOVWF	r0x1029
;	.line	629; "main.c"	break;
	GOTO	_00480_DS_
;;unsigned compare: left < lit(0x3=3), size=1
_00475_DS_:
;	.line	633; "main.c"	if ( btSetCount >= th_SHORT_PRESS && btSetCount < th_LONG_PRESS ) {
	MOVLW	0x03
	BANKSEL	_buttonEvents_btSetCount_65536_115
	SUBWF	_buttonEvents_btSetCount_65536_115,W
	BTFSS	STATUS,0
	GOTO	_00477_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
;;unsigned compare: left < lit(0x19=25), size=1
	MOVLW	0x19
	SUBWF	_buttonEvents_btSetCount_65536_115,W
	BTFSC	STATUS,0
	GOTO	_00477_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
;	.line	634; "main.c"	btEvent = EV_SET_PULSE;
	MOVLW	0x01
	BANKSEL	r0x1029
	MOVWF	r0x1029
_00477_DS_:
;	.line	637; "main.c"	btSetCount = 0;
	BANKSEL	_buttonEvents_btSetCount_65536_115
	CLRF	_buttonEvents_btSetCount_65536_115
;	.line	638; "main.c"	break;
	GOTO	_00480_DS_
_00479_DS_:
;	.line	641; "main.c"	btEvent = EV_NOCHANGE;
	BANKSEL	r0x1029
	CLRF	r0x1029
_00480_DS_:
;	.line	644; "main.c"	return btEvent;
	BANKSEL	r0x1029
	MOVF	r0x1029,W
;	.line	645; "main.c"	}
	RETURN	
; exit point of _buttonEvents

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;; Starting pCode block
S_main__getButton	code
_getButton:
; 2 exit points
;	.line	605; "main.c"	bool btSet = btnSetPress();
	BANKSEL	_PORTAbits
	BTFSC	_PORTAbits,3
	GOTO	_00463_DS_
;	.line	608; "main.c"	return BT_SET;  // 
	MOVLW	0x01
	GOTO	_00465_DS_
_00463_DS_:
;	.line	609; "main.c"	} else return BT_NONE;
	MOVLW	0x00
_00465_DS_:
;	.line	611; "main.c"	}
	RETURN	
; exit point of _getButton

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;4 compiler assigned registers:
;   r0x102B
;   STK00
;   r0x102C
;   r0x102D
;; Starting pCode block
S_main___delay_ms	code
__delay_ms:
; 2 exit points
;	.line	588; "main.c"	void _delay_ms(uint16_t td) {
	BANKSEL	r0x102B
	MOVWF	r0x102B
	MOVF	STK00,W
	MOVWF	r0x102C
_00451_DS_:
;	.line	591; "main.c"	while (--d) {
	MOVLW	0xff
	BANKSEL	r0x102C
	ADDWF	r0x102C,F
	BTFSS	STATUS,0
	DECF	r0x102B,F
	MOVF	r0x102B,W
	IORWF	r0x102C,W
	BTFSC	STATUS,2
	GOTO	_00457_DS_
;	.line	592; "main.c"	for (uint8_t i=100;i>0;i--)
	MOVLW	0x64
	MOVWF	r0x102D
_00455_DS_:
	BANKSEL	r0x102D
	MOVF	r0x102D,W
	BTFSC	STATUS,2
	GOTO	_00451_DS_
	nop
	
;	.line	592; "main.c"	for (uint8_t i=100;i>0;i--)
	BANKSEL	r0x102D
	DECF	r0x102D,F
	GOTO	_00455_DS_
_00457_DS_:
;	.line	595; "main.c"	}
	RETURN	
; exit point of __delay_ms

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;functions called:
;   _I2Cstart
;   _I2Cwrite
;   _I2Cwrite
;   _I2Cstart
;   _I2Cwrite
;   _I2Cread
;   _I2Cread
;   _I2Cstop
;   _I2Cstop
;   _I2Cstop
;   _I2Cstart
;   _I2Cwrite
;   _I2Cwrite
;   _I2Cstart
;   _I2Cwrite
;   _I2Cread
;   _I2Cread
;   _I2Cstop
;   _I2Cstop
;   _I2Cstop
;4 compiler assigned registers:
;   r0x1032
;   r0x1033
;   r0x1034
;   r0x1035
;; Starting pCode block
S_main__readRtc	code
_readRtc:
; 2 exit points
;	.line	571; "main.c"	I2Cstart();
	PAGESEL	_I2Cstart
	CALL	_I2Cstart
	PAGESEL	$
;	.line	572; "main.c"	if ( !I2Cwrite((uint8_t)(RTC_ADDRESS << 1)) ) {
	MOVLW	0xd0
	PAGESEL	_I2Cwrite
	CALL	_I2Cwrite
	PAGESEL	$
	BANKSEL	r0x1032
	MOVWF	r0x1032
	MOVF	r0x1032,W
	BTFSS	STATUS,2
	GOTO	_00441_DS_
;	.line	573; "main.c"	I2Cwrite( 0x00); // register address, 1st clock register
	MOVLW	0x00
	PAGESEL	_I2Cwrite
	CALL	_I2Cwrite
	PAGESEL	$
;	.line	574; "main.c"	I2Cstart();  // repeated start
	PAGESEL	_I2Cstart
	CALL	_I2Cstart
	PAGESEL	$
;	.line	575; "main.c"	I2Cwrite((uint8_t)(RTC_ADDRESS << 1)  | 1);
	MOVLW	0xd1
	PAGESEL	_I2Cwrite
	CALL	_I2Cwrite
	PAGESEL	$
;	.line	576; "main.c"	for ( i = 0 ; i < 6 ; i++) {
	BANKSEL	r0x1032
	CLRF	r0x1032
_00443_DS_:
;	.line	577; "main.c"	rtc.rawdata[i] = I2Cread ( sendACK );
	BANKSEL	r0x1032
	MOVF	r0x1032,W
	ADDLW	(_rtc + 0)
	MOVWF	r0x1033
	MOVLW	high (_rtc + 0)
	BTFSC	STATUS,0
	ADDLW	0x01
	MOVWF	r0x1034
	MOVLW	0x01
	PAGESEL	_I2Cread
	CALL	_I2Cread
	PAGESEL	$
	BANKSEL	r0x1035
	MOVWF	r0x1035
	MOVF	r0x1033,W
	BANKSEL	FSR
	MOVWF	FSR
	BCF	STATUS,7
	BANKSEL	r0x1034
	BTFSC	r0x1034,0
	BSF	STATUS,7
	MOVF	r0x1035,W
	BANKSEL	INDF
	MOVWF	INDF
;	.line	576; "main.c"	for ( i = 0 ; i < 6 ; i++) {
	BANKSEL	r0x1032
	INCF	r0x1032,F
;;unsigned compare: left < lit(0x6=6), size=1
	MOVLW	0x06
	SUBWF	r0x1032,W
	BTFSS	STATUS,0
	GOTO	_00443_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
;	.line	579; "main.c"	rtc.rawdata[i] = I2Cread ( sendNACK );       // NACK on last bit
	MOVF	r0x1032,W
	ADDLW	(_rtc + 0)
	MOVWF	r0x1032
	MOVLW	high (_rtc + 0)
	BTFSC	STATUS,0
	ADDLW	0x01
	MOVWF	r0x1033
	MOVLW	0x00
	PAGESEL	_I2Cread
	CALL	_I2Cread
	PAGESEL	$
	BANKSEL	r0x1034
	MOVWF	r0x1034
	MOVF	r0x1032,W
	BANKSEL	FSR
	MOVWF	FSR
	BCF	STATUS,7
	BANKSEL	r0x1033
	BTFSC	r0x1033,0
	BSF	STATUS,7
	MOVF	r0x1034,W
	BANKSEL	INDF
	MOVWF	INDF
;	.line	580; "main.c"	I2Cstop();
	PAGESEL	_I2Cstop
	CALL	_I2Cstop
	PAGESEL	$
;	.line	581; "main.c"	return true;
	MOVLW	0x01
	GOTO	_00445_DS_
_00441_DS_:
;	.line	583; "main.c"	I2Cstop(); I2Cstop();
	PAGESEL	_I2Cstop
	CALL	_I2Cstop
	PAGESEL	$
	PAGESEL	_I2Cstop
	CALL	_I2Cstop
	PAGESEL	$
;	.line	584; "main.c"	} return false;
	MOVLW	0x00
_00445_DS_:
;	.line	585; "main.c"	}
	RETURN	
; exit point of _readRtc

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;functions called:
;   _I2Cstart
;   _I2Cwrite
;   _I2Cwrite
;   _I2Cwrite
;   _I2Cstop
;   _I2Cstop
;   _I2Cstop
;   _I2Cstart
;   _I2Cwrite
;   _I2Cwrite
;   _I2Cwrite
;   _I2Cstop
;   _I2Cstop
;   _I2Cstop
;4 compiler assigned registers:
;   r0x1036
;   r0x1037
;   r0x1038
;   r0x1039
;; Starting pCode block
S_main__writeRtc	code
_writeRtc:
; 2 exit points
;	.line	555; "main.c"	I2Cstart();
	PAGESEL	_I2Cstart
	CALL	_I2Cstart
	PAGESEL	$
;	.line	556; "main.c"	if (!I2Cwrite((uint8_t)(RTC_ADDRESS << 1)) ) {
	MOVLW	0xd0
	PAGESEL	_I2Cwrite
	CALL	_I2Cwrite
	PAGESEL	$
	BANKSEL	r0x1036
	MOVWF	r0x1036
	MOVF	r0x1036,W
	BTFSS	STATUS,2
	GOTO	_00430_DS_
;	.line	557; "main.c"	I2Cwrite( 0x00 ); // register address, 1st clock register
	MOVLW	0x00
	PAGESEL	_I2Cwrite
	CALL	_I2Cwrite
	PAGESEL	$
;	.line	558; "main.c"	for ( i = 0 ; i < 7 ; i++)
	BANKSEL	r0x1036
	CLRF	r0x1036
_00432_DS_:
;	.line	559; "main.c"	I2Cwrite(rtc.rawdata[i]);
	BANKSEL	r0x1036
	MOVF	r0x1036,W
	ADDLW	(_rtc + 0)
	MOVWF	r0x1037
	MOVLW	high (_rtc + 0)
	BTFSC	STATUS,0
	ADDLW	0x01
	MOVWF	r0x1038
	MOVF	r0x1037,W
	BANKSEL	FSR
	MOVWF	FSR
	BCF	STATUS,7
	BANKSEL	r0x1038
	BTFSC	r0x1038,0
	BSF	STATUS,7
	BANKSEL	INDF
	MOVF	INDF,W
;;1	MOVWF	r0x1039
	PAGESEL	_I2Cwrite
	CALL	_I2Cwrite
	PAGESEL	$
;	.line	558; "main.c"	for ( i = 0 ; i < 7 ; i++)
	BANKSEL	r0x1036
	INCF	r0x1036,F
;;unsigned compare: left < lit(0x7=7), size=1
	MOVLW	0x07
	SUBWF	r0x1036,W
	BTFSS	STATUS,0
	GOTO	_00432_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
;	.line	560; "main.c"	I2Cstop();
	PAGESEL	_I2Cstop
	CALL	_I2Cstop
	PAGESEL	$
;	.line	561; "main.c"	return true;
	MOVLW	0x01
	GOTO	_00434_DS_
_00430_DS_:
;	.line	563; "main.c"	I2Cstop(); I2Cstop();
	PAGESEL	_I2Cstop
	CALL	_I2Cstop
	PAGESEL	$
	PAGESEL	_I2Cstop
	CALL	_I2Cstop
	PAGESEL	$
;	.line	564; "main.c"	} return false;
	MOVLW	0x00
_00434_DS_:
;	.line	565; "main.c"	}
	RETURN	
; exit point of _writeRtc

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;4 compiler assigned registers:
;   r0x102E
;   r0x102F
;   r0x1030
;   r0x1031
;; Starting pCode block
S_main__I2Cread	code
_I2Cread:
; 2 exit points
;	.line	524; "main.c"	uint8_t I2Cread(bool nack) {
	BANKSEL	r0x102E
	MOVWF	r0x102E
;	.line	527; "main.c"	d = 0;
	CLRF	r0x102F
;	.line	528; "main.c"	sdaHigh();             // release data line and
	BANKSEL	_TRISAbits
	BSF	_TRISAbits,4
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,4
;	.line	529; "main.c"	sclLow(); I2Cdelay();  // pull down clock line and wait to write a bit
	BANKSEL	_TRISAbits
	BCF	_TRISAbits,5
	BANKSEL	_PORTAbits
	BCF	_PORTAbits,5
	MOVLW	0x01
	BANKSEL	r0x1030
	MOVWF	r0x1030
_00388_DS_:
	BANKSEL	r0x1030
	MOVF	r0x1030,W
	BTFSC	STATUS,2
	GOTO	_00423_DS_
	nop
	
	BANKSEL	r0x1030
	DECF	r0x1030,F
	GOTO	_00388_DS_
_00423_DS_:
;	.line	531; "main.c"	sclHigh(); I2Cdelay(); // release clock line to read the data
	BANKSEL	r0x1030
	CLRF	r0x1030
_00344_DS_:
	BANKSEL	_TRISAbits
	BSF	_TRISAbits,5
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,5
	MOVLW	0x01
	BANKSEL	r0x1031
	MOVWF	r0x1031
_00391_DS_:
	BANKSEL	r0x1031
	MOVF	r0x1031,W
	BTFSC	STATUS,2
	GOTO	_00349_DS_
	nop
	
	BANKSEL	r0x1031
	DECF	r0x1031,F
	GOTO	_00391_DS_
_00349_DS_:
;	.line	532; "main.c"	d = d << 1;
	BANKSEL	r0x102F
	MOVF	r0x102F,W
	MOVWF	r0x1031
	BCF	STATUS,0
	RLF	r0x1031,W
;	.line	533; "main.c"	if (sdaGet() ) d |= 1; // read data bit, msb first
	MOVWF	r0x102F
;	.line	534; "main.c"	sclLow(); I2Cdelay();  // pull clock down to allow next bit
	BANKSEL	_PORTAbits
	BTFSS	_PORTAbits,4
	GOTO	_00007_DS_
	BANKSEL	r0x102F
	BSF	r0x102F,0
_00007_DS_:
	BANKSEL	_TRISAbits
	BCF	_TRISAbits,5
	BANKSEL	_PORTAbits
	BCF	_PORTAbits,5
	MOVLW	0x01
	BANKSEL	r0x1031
	MOVWF	r0x1031
_00394_DS_:
	BANKSEL	r0x1031
	MOVF	r0x1031,W
	BTFSC	STATUS,2
	GOTO	_00358_DS_
	nop
	
	BANKSEL	r0x1031
	DECF	r0x1031,F
	GOTO	_00394_DS_
_00358_DS_:
;	.line	530; "main.c"	for (i = 0; i < 8; i++)  {
	BANKSEL	r0x1030
	INCF	r0x1030,F
;;unsigned compare: left < lit(0x8=8), size=1
	MOVLW	0x08
	SUBWF	r0x1030,W
	BTFSS	STATUS,0
	GOTO	_00344_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
;	.line	537; "main.c"	if ( nack ) sdaLow(); else sdaHigh();
	MOVF	r0x102E,W
	BTFSC	STATUS,2
	GOTO	_00364_DS_
	BANKSEL	_TRISAbits
	BCF	_TRISAbits,4
	BANKSEL	_PORTAbits
	BCF	_PORTAbits,4
	GOTO	_00370_DS_
_00364_DS_:
	BANKSEL	_TRISAbits
	BSF	_TRISAbits,4
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,4
_00370_DS_:
;	.line	539; "main.c"	sclHigh(); I2Cdelay(); // Pulse clock
	BANKSEL	_TRISAbits
	BSF	_TRISAbits,5
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,5
	MOVLW	0x01
	BANKSEL	r0x102E
	MOVWF	r0x102E
_00399_DS_:
	BANKSEL	r0x102E
	MOVF	r0x102E,W
	BTFSC	STATUS,2
	GOTO	_00375_DS_
	nop
	
	BANKSEL	r0x102E
	DECF	r0x102E,F
	GOTO	_00399_DS_
_00375_DS_:
;	.line	540; "main.c"	sclLow(); I2Cdelay();  //
	BANKSEL	_TRISAbits
	BCF	_TRISAbits,5
	BANKSEL	_PORTAbits
	BCF	_PORTAbits,5
	MOVLW	0x01
	BANKSEL	r0x102E
	MOVWF	r0x102E
_00402_DS_:
	BANKSEL	r0x102E
	MOVF	r0x102E,W
	BTFSC	STATUS,2
	GOTO	_00382_DS_
	nop
	
	BANKSEL	r0x102E
	DECF	r0x102E,F
	GOTO	_00402_DS_
_00382_DS_:
;	.line	542; "main.c"	sdaHigh(); // release the data line
	BANKSEL	_TRISAbits
	BSF	_TRISAbits,4
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,4
;	.line	543; "main.c"	return d;
	BANKSEL	r0x102F
	MOVF	r0x102F,W
;	.line	544; "main.c"	}
	RETURN	
; exit point of _I2Cread

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;3 compiler assigned registers:
;   r0x102E
;   r0x102F
;   r0x1030
;; Starting pCode block
S_main__I2Cwrite	code
_I2Cwrite:
; 2 exit points
;	.line	503; "main.c"	bool I2Cwrite(uint8_t d) {
	BANKSEL	r0x102E
	MOVWF	r0x102E
;	.line	506; "main.c"	for (i = 0; i < 8; i++) {
	CLRF	r0x102F
_00309_DS_:
;	.line	507; "main.c"	if (d & 0x80)   // write data bit, msb first
	BANKSEL	r0x102E
	BTFSS	r0x102E,7
	GOTO	_00265_DS_
;	.line	508; "main.c"	sdaHigh();
	BANKSEL	_TRISAbits
	BSF	_TRISAbits,4
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,4
	GOTO	_00329_DS_
_00265_DS_:
;	.line	510; "main.c"	sdaLow();
	BANKSEL	_TRISAbits
	BCF	_TRISAbits,4
	BANKSEL	_PORTAbits
	BCF	_PORTAbits,4
_00329_DS_:
;	.line	511; "main.c"	I2Cdelay(); // give time to settle data
	MOVLW	0x01
	BANKSEL	r0x1030
	MOVWF	r0x1030
_00304_DS_:
	BANKSEL	r0x1030
	MOVF	r0x1030,W
	BTFSC	STATUS,2
	GOTO	_00273_DS_
	nop
	
	BANKSEL	r0x1030
	DECF	r0x1030,F
	GOTO	_00304_DS_
_00273_DS_:
;	.line	512; "main.c"	sclHigh(); I2Cdelay();  sclLow(); // pulse clock
	BANKSEL	_TRISAbits
	BSF	_TRISAbits,5
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,5
	MOVLW	0x01
	BANKSEL	r0x1030
	MOVWF	r0x1030
_00307_DS_:
	BANKSEL	r0x1030
	MOVF	r0x1030,W
	BTFSC	STATUS,2
	GOTO	_00280_DS_
	nop
	
	BANKSEL	r0x1030
	DECF	r0x1030,F
	GOTO	_00307_DS_
_00280_DS_:
	BANKSEL	_TRISAbits
	BCF	_TRISAbits,5
	BANKSEL	_PORTAbits
	BCF	_PORTAbits,5
;	.line	513; "main.c"	d = d << 1; // next bit
	BANKSEL	r0x102E
	MOVF	r0x102E,W
	MOVWF	r0x1030
	BCF	STATUS,0
	RLF	r0x1030,W
	MOVWF	r0x102E
;	.line	506; "main.c"	for (i = 0; i < 8; i++) {
	INCF	r0x102F,F
;;unsigned compare: left < lit(0x8=8), size=1
	MOVLW	0x08
	SUBWF	r0x102F,W
	BTFSS	STATUS,0
	GOTO	_00309_DS_
;;genSkipc:3307: created from rifx:0000000000BC9370
;	.line	516; "main.c"	sdaHigh(); I2Cdelay();  // release data line
	BANKSEL	_TRISAbits
	BSF	_TRISAbits,4
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,4
	MOVLW	0x01
	BANKSEL	r0x102E
	MOVWF	r0x102E
_00312_DS_:
	BANKSEL	r0x102E
	MOVF	r0x102E,W
	BTFSC	STATUS,2
	GOTO	_00291_DS_
	nop
	
	BANKSEL	r0x102E
	DECF	r0x102E,F
	GOTO	_00312_DS_
_00291_DS_:
;	.line	517; "main.c"	sclHigh(); I2Cdelay();  // release clock line
	BANKSEL	_TRISAbits
	BSF	_TRISAbits,5
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,5
	MOVLW	0x01
	BANKSEL	r0x102E
	MOVWF	r0x102E
_00315_DS_:
	BANKSEL	r0x102E
	MOVF	r0x102E,W
	BTFSC	STATUS,2
	GOTO	_00298_DS_
	nop
	
	BANKSEL	r0x102E
	DECF	r0x102E,F
	GOTO	_00315_DS_
_00298_DS_:
;	.line	518; "main.c"	nack = sdaGet();  // get nack bit
	BANKSEL	r0x102E
	CLRF	r0x102E
	BANKSEL	_PORTAbits
	BTFSS	_PORTAbits,4
	GOTO	_00008_DS_
	BANKSEL	r0x102E
	INCF	r0x102E,F
_00008_DS_:
	BANKSEL	r0x102E
	MOVF	r0x102E,W
	BTFSS	STATUS,2
	MOVLW	0x01
	MOVWF	r0x102F
;	.line	519; "main.c"	sclLow();// clock low
	BANKSEL	_TRISAbits
	BCF	_TRISAbits,5
	BANKSEL	_PORTAbits
	BCF	_PORTAbits,5
;	.line	520; "main.c"	return nack;
	BANKSEL	r0x102F
	MOVF	r0x102F,W
;	.line	521; "main.c"	}
	RETURN	
; exit point of _I2Cwrite

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;1 compiler assigned register :
;   r0x102E
;; Starting pCode block
S_main__I2Cstop	code
_I2Cstop:
; 2 exit points
;	.line	497; "main.c"	sdaLow();  I2Cdelay(); // sda = 0;  sda = 0;
	BANKSEL	_TRISAbits
	BCF	_TRISAbits,4
	BANKSEL	_PORTAbits
	BCF	_PORTAbits,4
	MOVLW	0x01
	BANKSEL	r0x102E
	MOVWF	r0x102E
_00254_DS_:
	BANKSEL	r0x102E
	MOVF	r0x102E,W
	BTFSC	STATUS,2
	GOTO	_00241_DS_
	nop
	
	BANKSEL	r0x102E
	DECF	r0x102E,F
	GOTO	_00254_DS_
_00241_DS_:
;	.line	498; "main.c"	sclHigh(); I2Cdelay(); // scl = 1;  scl = 1;
	BANKSEL	_TRISAbits
	BSF	_TRISAbits,5
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,5
	MOVLW	0x01
	BANKSEL	r0x102E
	MOVWF	r0x102E
_00257_DS_:
	BANKSEL	r0x102E
	MOVF	r0x102E,W
	BTFSC	STATUS,2
	GOTO	_00248_DS_
	nop
	
	BANKSEL	r0x102E
	DECF	r0x102E,F
	GOTO	_00257_DS_
_00248_DS_:
;	.line	499; "main.c"	sdaHigh();             // sda = 1;
	BANKSEL	_TRISAbits
	BSF	_TRISAbits,4
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,4
;	.line	500; "main.c"	}
	RETURN	
; exit point of _I2Cstop

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;1 compiler assigned register :
;   r0x102E
;; Starting pCode block
S_main__I2Cstart	code
_I2Cstart:
; 2 exit points
;	.line	489; "main.c"	sdaHigh(); I2Cdelay();
	BANKSEL	_TRISAbits
	BSF	_TRISAbits,4
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,4
	MOVLW	0x01
	BANKSEL	r0x102E
	MOVWF	r0x102E
_00225_DS_:
	BANKSEL	r0x102E
	MOVF	r0x102E,W
	BTFSC	STATUS,2
	GOTO	_00205_DS_
	nop
	
	BANKSEL	r0x102E
	DECF	r0x102E,F
	GOTO	_00225_DS_
_00205_DS_:
;	.line	490; "main.c"	sclHigh(); I2Cdelay(); // sda = 1;  scl = 1;
	BANKSEL	_TRISAbits
	BSF	_TRISAbits,5
	BANKSEL	_PORTAbits
	BSF	_PORTAbits,5
	MOVLW	0x01
	BANKSEL	r0x102E
	MOVWF	r0x102E
_00228_DS_:
	BANKSEL	r0x102E
	MOVF	r0x102E,W
	BTFSC	STATUS,2
	GOTO	_00212_DS_
	nop
	
	BANKSEL	r0x102E
	DECF	r0x102E,F
	GOTO	_00228_DS_
_00212_DS_:
;	.line	491; "main.c"	sdaLow();  I2Cdelay(); // sda = 0;
	BANKSEL	_TRISAbits
	BCF	_TRISAbits,4
	BANKSEL	_PORTAbits
	BCF	_PORTAbits,4
	MOVLW	0x01
	BANKSEL	r0x102E
	MOVWF	r0x102E
_00231_DS_:
	BANKSEL	r0x102E
	MOVF	r0x102E,W
	BTFSC	STATUS,2
	GOTO	_00219_DS_
	nop
	
	BANKSEL	r0x102E
	DECF	r0x102E,F
	GOTO	_00231_DS_
_00219_DS_:
;	.line	492; "main.c"	sclLow();
	BANKSEL	_TRISAbits
	BCF	_TRISAbits,5
	BANKSEL	_PORTAbits
	BCF	_PORTAbits,5
;	.line	493; "main.c"	}
	RETURN	
; exit point of _I2Cstart

;***
;  pBlock Stats: dbName = C
;***
;has an exit
;; Starting pCode block
S_main__initHardware	code
_initHardware:
; 2 exit points
;	.line	440; "main.c"	IRCF0 = 1 ;  // 8MHz -> IRCF[2..0] = 111 ( default 110 on startup )
	BANKSEL	_OSCCONbits
	BSF	_OSCCONbits,4
;	.line	443; "main.c"	CMCON0 = ( _CM2 | _CM1 | _CM0); // analog comparators off, pins as I/O 
	MOVLW	0x07
	BANKSEL	_CMCON0
	MOVWF	_CMCON0
;	.line	444; "main.c"	ANSEL = 0;
	BANKSEL	_ANSEL
	CLRF	_ANSEL
;	.line	448; "main.c"	TRISC=0b00000001; // RC0 as input (LDR), other pins as outputs (rows) 
	MOVLW	0x01
	MOVWF	_TRISC
;	.line	449; "main.c"	PORTC=0b00000000; // all digits unactive
	BANKSEL	_PORTC
	CLRF	_PORTC
;	.line	451; "main.c"	TRISA=0b11111000; // RA0,RA1,RA2 as outputs, other pins as inputs 
	MOVLW	0xf8
	BANKSEL	_TRISA
	MOVWF	_TRISA
;	.line	452; "main.c"	PORTA=0b00000000; // All low   
	BANKSEL	_PORTA
	CLRF	_PORTA
;	.line	453; "main.c"	WPUA4 = 1;  // pullups on i2c signals
	BANKSEL	_WPUbits
	BSF	_WPUbits,4
;	.line	454; "main.c"	WPUA5 = 1;
	BSF	_WPUbits,5
;	.line	458; "main.c"	ANSEL = (1<<4); // Configure analog/digital I/O (ANSEL)
	MOVLW	0x10
	MOVWF	_ANSEL
;	.line	459; "main.c"	ADCON0 = 0b00010000; // CHS[2..0] = 100 -> Channel AN4 (@pin RC0)
	MOVLW	0x10
	BANKSEL	_ADCON0
	MOVWF	_ADCON0
;	.line	460; "main.c"	ADCON1 = 0b01110000;	 //  ADCS1 [2..0] = x11 -> FRC Internal 500KHz oscillator
	MOVLW	0x70
	BANKSEL	_ADCON1
	MOVWF	_ADCON1
;	.line	461; "main.c"	ADON = 1;
	BANKSEL	_ADCON0bits
	BSF	_ADCON0bits,0
;	.line	462; "main.c"	GO_NOT_DONE = 1;   // Set GO/DONE bit to start conversions
	BSF	_ADCON0bits,1
;	.line	469; "main.c"	OPTION_REG = _PSA; 
	MOVLW	0x08
	BANKSEL	_OPTION_REG
	MOVWF	_OPTION_REG
;	.line	474; "main.c"	TMR0  = 0;  // clear timer 0 counter
	BANKSEL	_TMR0
	CLRF	_TMR0
;	.line	475; "main.c"	T0IF  = 0;  // clear any pending timer 0 flag
	BCF	_INTCONbits,2
;	.line	476; "main.c"	T0IE  = 1;  // enable timer 0 interrupts
	BSF	_INTCONbits,5
;	.line	477; "main.c"	GIE   = 1;  // enable global interrupts
	BSF	_INTCONbits,7
;	.line	480; "main.c"	}
	RETURN	
; exit point of _initHardware


;	code size estimation:
;	 1159+  419 =  1578 instructions ( 3994 byte)

	end
