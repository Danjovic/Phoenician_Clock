

/***
 *    $$$$$$$\  $$\                           $$\           $$\                     
 *    $$  __$$\ $$ |                          \__|          \__|                    
 *    $$ |  $$ |$$$$$$$\   $$$$$$\  $$$$$$$\  $$\  $$$$$$$\ $$\  $$$$$$\  $$$$$$$\  
 *    $$$$$$$  |$$  __$$\ $$  __$$\ $$  __$$\ $$ |$$  _____|$$ | \____$$\ $$  __$$\ 
 *    $$  ____/ $$ |  $$ |$$ /  $$ |$$ |  $$ |$$ |$$ /      $$ | $$$$$$$ |$$ |  $$ |
 *    $$ |      $$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |$$ |      $$ |$$  __$$ |$$ |  $$ |
 *    $$ |      $$ |  $$ |\$$$$$$  |$$ |  $$ |$$ |\$$$$$$$\ $$ |\$$$$$$$ |$$ |  $$ |
 *    \__|      \__|  \__| \______/ \__|  \__|\__| \_______|\__| \_______|\__|  \__|
 *                                                                                  
 *                                                                                  
 *                                                                                  
 *     $$$$$$\  $$\                     $$\                                         
 *    $$  __$$\ $$ |                    $$ |                                        
 *    $$ /  \__|$$ | $$$$$$\   $$$$$$$\ $$ |  $$\                                   
 *    $$ |      $$ |$$  __$$\ $$  _____|$$ | $$  |                                  
 *    $$ |      $$ |$$ /  $$ |$$ /      $$$$$$  /                                   
 *    $$ |  $$\ $$ |$$ |  $$ |$$ |      $$  _$$<                                    
 *    \$$$$$$  |$$ |\$$$$$$  |\$$$$$$$\ $$ | \$$\                                   
 *     \______/ \__| \______/  \_______|\__|  \__|                                  
 *                                                                                  
 *                                                                                  
 *                                                                                  
 */


//         _               _   
//    _ __(_)_ _  ___ _  _| |_ 
//   | '_ \ | ' \/ _ \ || |  _|
//   | .__/_|_||_\___/\_,_|\__|
//   |_|                       

/*
   PIC16F688
                 +--___--+ 
           +5V --|1    14|-- GND                          
       SCL RA5 --|2    13|-- RA0 STROBE   |    
       SDA RA4 --|3    12|-- RA1 DOUT     | shif register
 (set) BT1 RA3 --|4    11|-- RA2 CLOCK    |   
       RR2 RC5 --|5    10|-- RC0 LDR (analog ch#4)
       RR5 RC4 --|6     9|-- RC1 RR3                  
       RR1 RC3 --|7     8|-- RC2 RR4     
                 +-------+  
*/

/*
   Display organization:
 
    40 LEDS: 
      20 on top row -> hours         20..17 16...9 8....1
      20 on bottowm row -> minutes   40..37 36..29 28..21
	  less significative bit on the right
 
   segment |disp[2]|    disp[1]    |     disp[0]   |  segment
     20    |3.2.1.0|7.6.5.4.3.2.1.0|7.6.5.4.3.2.1.0|  1
     40    |7.6.5.4|7.6.5.4.3.2.1.0|7.6.5.4.3.2.1.0|  21
           |disp[2]|    disp[4]    |     disp[3]   |
	  
   
	
   Display variable with 5 bytes 
   Element     bit  7  6  5  4  3  2  1  0 
   display[0] LED:  8  6  5  4  3  2  1  0
   display[1] LED: 16 15 14 13 12 11 10  9    
   display[2] LED: 40 39 38 37 20 19 18 17  -> Attention!
   display[3] LED: 28 27 26 25 24 23 22 21  
   display[4] LED: 36 45 34 33 32 31 30 29  

*/




//    _ _ _                 _        
//   | (_) |__ _ _ __ _ _ _(_)___ ___
//   | | | '_ \ '_/ _` | '_| / -_|_-<
//   |_|_|_.__/_| \__,_|_| |_\___/__/
//                                   


#include <pic16f688.h>
#include <stdint.h>
#include <stdbool.h>

// Fuse setting 
uint16_t __at _CONFIG configWord = _INTRC_OSC_NOCLKOUT & _CPD_OFF &  _CP_OFF &  _MCLRE_OFF & _WDT_OFF & _PWRTE_ON; // watchdog off



//       _      __ _      _ _   _             
//    __| |___ / _(_)_ _ (_) |_(_)___ _ _  ___
//   / _` / -_)  _| | ' \| |  _| / _ \ ' \(_-<
//   \__,_\___|_| |_|_||_|_|\__|_\___/_||_/__/
//                                            

#define LO 0
#define HI 1
#define OUT 0
#define INP 1
#define OFF 0
#define ON  1

// I2C Stuff
#define SDA  RA4
#define SCL  RA5
#define sendACK     true
#define sendNACK    false
#define RTC_ADDRESS 0x68

#define DIR_SDA TRISA4
#define DIR_SCL TRISA5

// Shift Register Stuff
#define STROBE RA0
#define DOUT   RA1
#define CLOCK  RA2

// Display Columns
#define RR1 RC3
#define RR2 RC5
#define RR3 RC1
#define RR4 RC2
#define RR5 RC4

// Buttons Stuff
#define btnSET RA3
#define th_SHORT_PRESS 3    // time thresholds
#define th_LONG_PRESS 25   // in units of 20ms

//
//    _ __  __ _ __ _ _ ___ ___
//   | '  \/ _` / _| '_/ _ (_-<
//   |_|_|_\__,_\__|_| \___/__/
//

// I2C related
#define sclHigh()   do { DIR_SCL = INP;  SCL = 1; } while (0)
#define sclLow()    do { DIR_SCL = OUT;  SCL = 0; } while (0)
#define sdaHigh()   do { DIR_SDA = INP;  SDA = 1; } while (0)
#define sdaLow()    do { DIR_SDA = OUT;  SDA = 0; } while (0)
#define sdaGet()    SDA 
#define I2Cdelay()  do {for (uint8_t i=1;i>0;i--) __asm__ ("nop\n\t"); } while (0)

// Button Related
#define btnSetPress()  (btnSET ==0)  

// Display Related
#define rowsOff() do { RR1 = OFF; RR2 = OFF; RR3 = OFF; RR4 = OFF; RR5 = OFF; } while (0)
#define row1on()  do { RR1 = ON ; RR2 = OFF; RR3 = OFF; RR4 = OFF; RR5 = OFF; } while (0)
#define row2on()  do { RR1 = OFF; RR2 = ON ; RR3 = OFF; RR4 = OFF; RR5 = OFF; } while (0)
#define row3on()  do { RR1 = OFF; RR2 = OFF; RR3 = ON ; RR4 = OFF; RR5 = OFF; } while (0)
#define row4on()  do { RR1 = OFF; RR2 = OFF; RR3 = OFF; RR4 = ON ; RR5 = OFF; } while (0)
#define row5on()  do { RR1 = OFF; RR2 = OFF; RR3 = OFF; RR4 = OFF; RR5 = ON ; } while (0)  

                     


//               _               _
//    __ _  _ __| |_ ___ _ __   | |_ _  _ _ __  ___ ___
//   / _| || (_-<  _/ _ \ '  \  |  _| || | '_ \/ -_|_-<
//   \__|\_,_/__/\__\___/_|_|_|  \__|\_, | .__/\___/__/
//                                   |__/|_|

typedef struct {
  unsigned units : 4;
  unsigned tens  : 3;
  unsigned       : 1;
} t_seconds;

typedef struct {
  unsigned units : 4;
  unsigned tens  : 3;
  unsigned       : 1;
} t_minutes;

typedef struct {
  unsigned units   : 4 ;
  unsigned tens    : 2 ;
  unsigned op12_24 : 1 ;
  unsigned         : 1 ;
} t_hours;

typedef struct {
  unsigned dow     : 3 ;  // day of week
  unsigned         : 5 ;
} t_wkDays;

typedef struct {
  unsigned units : 4;
  unsigned tens  : 2;
  unsigned       : 2;
} t_dates;

typedef struct {
  unsigned units   : 4 ;
  unsigned tens    : 1 ;
  unsigned         : 2 ;
  unsigned century : 1 ;
} t_monthsCty;

typedef struct {
  unsigned units : 4;
  unsigned tens  : 4;
} t_years;


typedef struct {
  t_seconds    seconds ;
  t_seconds    minutes ;
  t_hours        hours ;
  t_wkDays       wkDay ;
  t_dates         date ;
  t_monthsCty monthCty ;
  t_years         year ;
} t_timeAndDate;

typedef union  {
  uint8_t rawdata[7];
  t_timeAndDate datetime;
} t_ds3231records;


typedef enum   {
  ST_SHOW_TIME,
  ST_SET_HOUR,
  ST_SET_MINUTE
} t_operatingStates;

typedef enum   {
  BT_NONE,
  BT_SET,
  BT_BOTH
} t_buttonStates;


typedef enum   {
  EV_NOCHANGE,
  EV_SET_PULSE,
  EV_SET_LONG,
  EV_RELEASE
} t_buttonEvents;


//                   _            _
//    __ ___ _ _  __| |_ __ _ _ _| |_ ___
//   / _/ _ \ ' \(_-<  _/ _` | ' \  _(_-<
//   \__\___/_||_/__/\__\__,_|_||_\__/__/
//



//                 _      _    _        
//   __ ____ _ _ _(_)__ _| |__| |___ ___
//   \ V / _` | '_| / _` | '_ \ / -_|_-<
//    \_/\__,_|_| |_\__,_|_.__/_\___/__/
//                                      

t_ds3231records rtc;
volatile bool readyToGo = false;
t_operatingStates operatingState = ST_SHOW_TIME;

uint8_t display[5] ; 
volatile uint8_t tOFF = 32;
volatile bool blink = 0;

bool timeChanged = false;


uint8_t __TEMP_ADC;   // TODO REMOVE!!



//                 _       _
//    _ __ _ _ ___| |_ ___| |_ _  _ _ __  ___ ___
//   | '_ \ '_/ _ \  _/ _ \  _| || | '_ \/ -_|_-<
//   | .__/_| \___/\__\___/\__|\_, | .__/\___/__/
//   |_|                       |__/|_|

void _delay_ms(uint16_t ms);
inline void initHardware(void);

bool writeRtc (void); // t_ds3231records *t);
bool readRtc (void); // t_ds3231records *t);

void runClockEngine( t_buttonEvents btEvent );
void runDisplayEngine( void );
void runBrightnessControl ( void );
void runDisplayError( void );
t_buttonEvents buttonEvents (void) ;

//    _     _                         _      
//   (_)_ _| |_ ___ _ _ _ _ _  _ _ __| |_ ___
//   | | ' \  _/ -_) '_| '_| || | '_ \  _(_-<
//   |_|_||_\__\___|_| |_|  \_,_| .__/\__/__/
//                              |_|          
	
static void irqHandler(void) __interrupt 0 {
	// gets here every TMR0 
	static uint8_t tickCounter=0;
	static uint8_t digit=0;
    uint8_t i,j;


	// gets here every TMR0 int (every 256 ticks -> 128us) 
  
    tickCounter++;
    tickCounter &= 31;    // further division by 32 -> 4.096ms 
	if (tickCounter == 0) {
    
    
        rowsOff();
        // update column data
        j = display[digit];
        for (i=0;i<8;i++) {
            if ( j & 1) DOUT = 1;  else DOUT = 0;
            j>>=1;              
            CLOCK=1;
            CLOCK=0;
        }
        STROBE = 1;
        STROBE = 0;
     
       	// activate current row
        switch (digit) {
			case 0: // 
				row1on();
				break;
			   
			case 1: // 
				row2on(); 
				break;

			case 2: // 
				row3on();
				break;

			case 3: // 
				row4on(); 
				break;

			case 4: // 
				row5on(); 
				break;

        } // end switch
        
        if (++digit > 4) {
			digit = 0;
            readyToGo = 1;                        // main tick every 20.48 ms 
	    }
    } else if (tickCounter == tOFF ) {   // rudimentary PWM
		rowsOff();
    }	

	T0IF = 0;
}

//               _      
//    _ __  __ _(_)_ _  
//   | '  \/ _` | | ' \ 
//   |_|_|_\__,_|_|_||_|
//                      


void main (void)
{
    initHardware();

	if ( !readRtc() ) { // test RTC reading  at the beginning, initialize some values if failed
           rtc.rawdata[0] = 0x00; // 00 Seconds
           rtc.rawdata[1] = 0x23; // 23 Minutes
           rtc.rawdata[2] = 0x23; // 23 Hours (in 24 hr format)
           rtc.rawdata[3] = 0x04; // 04 Day of week
           rtc.rawdata[4] = 0x23; // 23 Day of Month
           rtc.rawdata[5] = 0x04; // 04 Month (+ century=0)
           rtc.rawdata[6] = 0x23; // 23 Year
		}

   
  
   
   
   
   
   
   

    for (;;) { 
		while (!readyToGo); // wait for 16ms flag
		readyToGo=0;        // reset go flag 
   
        runBrightnessControl ();
     //   display[0] = tOFF;
        
     //   display[3] = __TEMP_ADC;
        
    
  

        if ( readRtc ( )  ) {
            runDisplayEngine();        
            runClockEngine( buttonEvents () );
            if (timeChanged) {    // TODO check for error during write to RTC
                writeRtc ( );
                timeChanged = false;
            }  
        } else { 
            runDisplayError();
        } 
        
       
        
    } // for (;;)
    
  
    
    
    

} // main




//     __              _   _             
//    / _|_  _ _ _  __| |_(_)___ _ _  ___
//   |  _| || | ' \/ _|  _| / _ \ ' \(_-<
//   |_|  \_,_|_||_\__|\__|_\___/_||_/__/
//                                       

// ******************************************************************************************************************
//
// Hardware Initialization
//
inline void initHardware(void) {

   // Initialize clock
   IRCF0 = 1 ;  // 8MHz -> IRCF[2..0] = 111 ( default 110 on startup )
   
   // Initialize I/O ports
   CMCON0 = ( _CM2 | _CM1 | _CM0); // analog comparators off, pins as I/O 
   ANSEL = 0;

   
      
   TRISC=0b00000001; // RC0 as input (LDR), other pins as outputs (rows) 
   PORTC=0b00000000; // all digits unactive
    
   TRISA=0b11111000; // RA0,RA1,RA2 as outputs, other pins as inputs 
   PORTA=0b00000000; // All low   
   WPUA4 = 1;  // pullups on i2c signals
   WPUA5 = 1;
   

   // Initialize A/D converter
   ANSEL = (1<<4); // Configure analog/digital I/O (ANSEL)
   ADCON0 = 0b00010000; // CHS[2..0] = 100 -> Channel AN4 (@pin RC0)
   ADCON1 = 0b01110000;	 //  ADCS1 [2..0] = x11 -> FRC Internal 500KHz oscillator
   ADON = 1;
   GO_NOT_DONE = 1;   // Set GO/DONE bit to start conversions

   // Program Timer 0 interrupt every 256 instruction cycles 
   // IRQ occours at each 8000000/4/256 = 7812.5Hz
   // Display refresh at 7812.5Hz / 32 = 244.1Hz PWM
   // main program runs at 244.1/5 = 48.8Hz => ~20.5ms
   
   OPTION_REG = _PSA; 
   // _PSA       1 = Prescaler is assigned to the WDT (timer 0-> 1:1)
   //  _T0CS     0 = Internal instruction cycle clock 
   //  _NOT_RAPU 0 = PORTA pull-ups enabled by port latch values
 
	TMR0  = 0;  // clear timer 0 counter
	T0IF  = 0;  // clear any pending timer 0 flag
    T0IE  = 1;  // enable timer 0 interrupts
    GIE   = 1;  // enable global interrupts
 

}


// ******************************************************************************************************************
//
// Soft I2C
//

void I2Cstart() {
  sdaHigh(); I2Cdelay();
  sclHigh(); I2Cdelay(); // sda = 1;  scl = 1;
  sdaLow();  I2Cdelay(); // sda = 0;
  sclLow();
}
//

void I2Cstop() {
  sdaLow();  I2Cdelay(); // sda = 0;  sda = 0;
  sclHigh(); I2Cdelay(); // scl = 1;  scl = 1;
  sdaHigh();             // sda = 1;
}
//

bool I2Cwrite(uint8_t d) {
  uint8_t i;
  bool nack;
  for (i = 0; i < 8; i++) {
    if (d & 0x80)   // write data bit, msb first
      sdaHigh();
    else 
      sdaLow();
    I2Cdelay(); // give time to settle data
    sclHigh(); I2Cdelay();  sclLow(); // pulse clock
    d = d << 1; // next bit
  }
  // now get the ack
  sdaHigh(); I2Cdelay();  // release data line
  sclHigh(); I2Cdelay();  // release clock line
  nack = sdaGet();  // get nack bit
  sclLow();// clock low
  return nack;
}
//

uint8_t I2Cread(bool nack) {
  uint8_t i, d;

  d = 0;
  sdaHigh();             // release data line and
  sclLow(); I2Cdelay();  // pull down clock line and wait to write a bit
  for (i = 0; i < 8; i++)  {
    sclHigh(); I2Cdelay(); // release clock line to read the data
    d = d << 1;
    if (sdaGet() ) d |= 1; // read data bit, msb first
    sclLow(); I2Cdelay();  // pull clock down to allow next bit
  }
  // give ACK / NACK
  if ( nack ) sdaLow(); else sdaHigh();

  sclHigh(); I2Cdelay(); // Pulse clock
  sclLow(); I2Cdelay();  //

  sdaHigh(); // release the data line
  return d;
}
//

// ******************************************************************************************************************
//
// RTC chip handling
//

// write time data on clock Chip using I2C
bool writeRtc ( void) {
  uint8_t i;
  I2Cstart();
  if (!I2Cwrite((uint8_t)(RTC_ADDRESS << 1)) ) {
    I2Cwrite( 0x00 ); // register address, 1st clock register
    for ( i = 0 ; i < 7 ; i++)
      I2Cwrite(rtc.rawdata[i]);
    I2Cstop();
    return true;
  } else {
    I2Cstop(); I2Cstop();
  } return false;
}
//

// read time data from clock Chip using I2C
bool readRtc ( void ) {
  uint8_t i;
  I2Cstart();
  if ( !I2Cwrite((uint8_t)(RTC_ADDRESS << 1)) ) {
    I2Cwrite( 0x00); // register address, 1st clock register
    I2Cstart();  // repeated start
    I2Cwrite((uint8_t)(RTC_ADDRESS << 1)  | 1);
    for ( i = 0 ; i < 6 ; i++) {
      rtc.rawdata[i] = I2Cread ( sendACK );
    }
    rtc.rawdata[i] = I2Cread ( sendNACK );       // NACK on last bit
    I2Cstop();
    return true;
  } else {
    I2Cstop(); I2Cstop();
  } return false;
}
//

void _delay_ms(uint16_t td) {
   uint16_t d = td;
   
   while (--d) {
     for (uint8_t i=100;i>0;i--)
     __asm__ ("nop\n\t");   
   }
}
 

// ******************************************************************************************************************
//
// Button handling
//
// Read Button press
t_buttonStates getButton (void) {

  bool btSet = btnSetPress();
  
  if ( btSet ) {    // SET press?
     return BT_SET;  // 
  } else return BT_NONE;
  
}
//

// Get button events - pulse, long press
t_buttonEvents buttonEvents (void) {
  static uint8_t btSetCount = 0;
  uint8_t btEvent = EV_NOCHANGE;
  uint8_t buttonNow = getButton();

  switch (buttonNow ) {

    case BT_SET:
      if ( btSetCount < th_LONG_PRESS ) {
        btSetCount++;                         // will stop count at threshold
        if ( btSetCount >= th_LONG_PRESS ) { // and generate an unique long press event
          btEvent  = EV_SET_LONG;
        }
      }
      break;


    case BT_NONE:
      if ( btSetCount >= th_SHORT_PRESS && btSetCount < th_LONG_PRESS ) {
        btEvent = EV_SET_PULSE;
      }

      btSetCount = 0;
      break;

    default:
      btEvent = EV_NOCHANGE;
      break;
  }
  return btEvent;
}
//



// ******************************************************************************************************************
//
// Date and Time calculation and handling stuff
//

// advance current hour
void advanceHour (void) {
	
  uint8_t d = ((1
                + 10 * (uint8_t)rtc.datetime.hours.tens
                + (uint8_t)rtc.datetime.hours.units )   ) % 24;

  rtc.datetime.hours.tens = ( (uint8_t) d / 10 )  & 0b00000011;
  rtc.datetime.hours.units = ( (uint8_t) d % 10 ) & 0b00001111;
  rtc.datetime.hours.op12_24 = 0; // force 24 hour mode
  timeChanged = true; // update rtc data
  //writeRtc();

}
//

// advance current minute
void advanceMinute (void) {
  uint8_t d = (1
               + 10 * (uint8_t)rtc.datetime.minutes.tens
               + (uint8_t)rtc.datetime.minutes.units ) % 60;

  rtc.datetime.minutes.tens = ( (uint8_t) d / 10 )  & 0b00000111;
  rtc.datetime.minutes.units = ( (uint8_t) d % 10 ) & 0b00001111;
  rtc.datetime.hours.op12_24 = 0; // force 24 hour mode
  timeChanged = true; // update rtc data
  //writeRtc();
}
//




// clock engine
void runClockEngine( t_buttonEvents btEvent ){

   switch ( operatingState ) {
    case ST_SHOW_TIME:
		if ( btEvent == EV_SET_LONG ) operatingState = ST_SET_HOUR;

	break;
	
    case ST_SET_HOUR:
		if ( btEvent == EV_SET_LONG )  operatingState = ST_SET_MINUTE;	
		if ( btEvent == EV_SET_PULSE ) advanceHour();	

	break;
	
    case ST_SET_MINUTE:
		if ( btEvent == EV_SET_LONG )  operatingState = ST_SHOW_TIME;	
		if ( btEvent == EV_SET_PULSE ) advanceMinute();	
	break;
	
   }
}




// Display engine
void runDisplayEngine( void ) {
  static uint8_t sequentialCounter = 0;
  uint8_t displayBuf[5];
  
  // fulfill display data with phoenician numerals
 
  switch ( rtc.datetime.hours.units ) { // units of hours
     case 9: displayBuf[1] = 0b00000111; displayBuf[0] = 0b01110111; break;  
     case 8: displayBuf[1] = 0b00000011; displayBuf[0] = 0b01110111; break;
     case 7: displayBuf[1] = 0b00000001; displayBuf[0] = 0b01110111; break; 
     case 6: displayBuf[1] = 0b00000000; displayBuf[0] = 0b01110111; break;
     case 5: displayBuf[1] = 0b00000000; displayBuf[0] = 0b00110111; break;
     case 4: displayBuf[1] = 0b00000000; displayBuf[0] = 0b00010111; break;
     case 3: displayBuf[1] = 0b00000000; displayBuf[0] = 0b00000111; break; 
     case 2: displayBuf[1] = 0b00000000; displayBuf[0] = 0b00000011; break;
     case 1: displayBuf[1] = 0b00000000; displayBuf[0] = 0b00000001; break;
     case 0:                                                         
	 default:displayBuf[1] = 0b00000000; displayBuf[0] = 0b00000000; break;
  }
	  
  switch ( rtc.datetime.hours.tens ) { // tens of hours
     case 2: displayBuf[2] = 0b00001100; break;
     case 1: displayBuf[2] = 0b00001000; break;
     case 0: 
	 default:displayBuf[2] = 0b00000000; break;
  }	  
  
  
  switch ( rtc.datetime.minutes.units ) { // units of minutes
     case 9: displayBuf[4] = 0b00000111; displayBuf[3] = 0b01110111; break;  
     case 8: displayBuf[4] = 0b00000011; displayBuf[3] = 0b01110111; break;
     case 7: displayBuf[4] = 0b00000001; displayBuf[3] = 0b01110111; break; 
     case 6: displayBuf[4] = 0b00000000; displayBuf[3] = 0b01110111; break;
     case 5: displayBuf[4] = 0b00000000; displayBuf[3] = 0b00110111; break;
     case 4: displayBuf[4] = 0b00000000; displayBuf[3] = 0b00010111; break;
     case 3: displayBuf[4] = 0b00000000; displayBuf[3] = 0b00000111; break; 
     case 2: displayBuf[4] = 0b00000000; displayBuf[3] = 0b00000011; break;
     case 1: displayBuf[4] = 0b00000000; displayBuf[3] = 0b00000001; break;
     case 0:                                                         
	 default:displayBuf[4] = 0b00000000; displayBuf[3] = 0b00000000; break;
  }  
  
  
  switch ( rtc.datetime.minutes.tens ) { // tens of minutes
     case 5: displayBuf[2] |= 0b11010000; displayBuf[4] |= 0b11000000; break;
     case 4: displayBuf[2] |= 0b10110000; displayBuf[4] |= 0b10000000; break;
     case 3: displayBuf[2] |= 0b11100000; displayBuf[4] |= 0b00000000; break; 
     case 2: displayBuf[2] |= 0b11000000; displayBuf[4] |= 0b00000000; break;
     case 1: displayBuf[2] |= 0b10000000; displayBuf[4] |= 0b00000000; break;
     case 0:                                                         
	 default:displayBuf[2] |= 0b00000000; displayBuf[4] |= 0b00000000; break;
  }	  
	  
	  
  // blank upper or lower segments when in time setup mopdes 
  if ( sequentialCounter > 10)  { // Display mode	  
	  if ( operatingState == ST_SET_HOUR) {
		  displayBuf[0] = 0;     // blank upper row of segments
		  displayBuf[1] = 0; 
		  displayBuf[2] &= 0xf0;
	  } else if ( operatingState == ST_SET_MINUTE){
		  displayBuf[2] &= 0x0f;   // blank lower row of segments
		  displayBuf[3] = 0; 
		  displayBuf[4] = 0;  
	  }
  }         
    
  sequentialCounter++; 
  if (sequentialCounter > 20 ) sequentialCounter = 0;  // ~200ms
 
  // update displays     
   display[0] = displayBuf[0];
   display[1] = displayBuf[1];
   display[2] = displayBuf[2];
   display[3] = displayBuf[3];
   display[4] = displayBuf[4];   

}
//


// Adjust brightness according with light read from LDR 
// https://tinyurl.com/2db6tud4
// (64+128)=256*(r2)/(r2+(1/(1/1000+1/r1))); 64=256*(r2)/(r2+(1/(1/1000000+1/r1))) on wolfram alpha
// typical LDR changes resistance from 1M to 1k from dark to brigh room
// voltage divider normalizes calculated normalize voltage reading in 8 bit values 
// from ADC from 64 to 192 on a 128 bit range.
void runBrightnessControl ( void ) {
	uint8_t adcValue;
	static uint8_t lighSenseCounter=0;

	#define VMIN 55 // 46
    #define VMAX 182 //46+127
	#define PWMSTEPS  32
    
	if (++lighSenseCounter == 49 )  {  // overflow @ every ~1 second (49 * 20.5ms)
		lighSenseCounter = 0;
		if (GO_NOT_DONE==0) {   // New value available

		   adcValue = ADRESH;   // read ADC value 
		   GO_NOT_DONE = 1;     // start the next conversion    
       
           __TEMP_ADC = adcValue;
           if (adcValue < VMIN) 
                adcValue = VMIN;
           else if (adcValue > VMAX)
                adcValue = VMAX;
 
           tOFF = 1 + ( (adcValue-VMIN) >> 2);
           // tOFF = linear_table[(adcValue-VMIN >> 2)] ;
           // uint8_t linear_table[32] = { }  // 32 values           
		}
	}
}



void runDisplayError( void ) {
   static uint8_t sequentialCounter = 0;
   
   if (sequentialCounter == 0) {
      display[0] = 0x55;
      display[1] = 0x55;
      display[2] = 0xA5;
      display[3] = 0xAA;
      display[4] = 0xAA;   
   }
  
     if (sequentialCounter == 10) {
      display[0] = 0xAA;
      display[1] = 0xAA;
      display[2] = 0x5A;
      display[3] = 0x55;
      display[4] = 0x55;	   
   }
  
   sequentialCounter++; 
   if (sequentialCounter > 20 ) sequentialCounter = 0;  // ~200ms
}
