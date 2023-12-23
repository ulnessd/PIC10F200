;Here is a program to practice various arithmetic operations:
    ;multiplication, comparison, modulo
    
    
PROCESSOR 10F200

; PIC10F200 Configuration Bit Settings

; Assembly source line config statements

; CONFIG
  CONFIG  WDTE = OFF            ; Watchdog Timer (WDT disabled)
  CONFIG  CP = OFF              ; Code Protect (Code protection off)
  CONFIG  MCLRE = OFF           ; Master Clear Enable (GP3/MCLR pin fuction is digital I/O, MCLR internally tied to VDD)

; config statements should precede project file includes.
#include <xc.inc>


PSECT resetVect, class=CODE, delta=2
resetVect:
    PAGESEL main
    goto main
    
    
PSECT code, delta=2
main: ; up to mainloop is boilerplate that I automatically put into my programs
    
    movlw 0b00001110 ; first four zeros are irrelevent. 
		     ; last four GP3, GP2, GP1, GP0
		     ; 1 will set to input, 0 will set to output
		     ; GP3 is input only.
		     
		     ;use GP0 for output blinker
		     ;use GP1 for clock
		     ;use GP2 for reading data

    tris 6 ;the 6 sets tris to the value stored in W
    nop
    movlw 0b11011111 ;the zero here will set GP2 to IO rather than external clock
    option ; the contents of the working register is moved to OPTION register 
    nop

mainloop:
    movlw 6 ; example value number 1
    movwf 0x10 ; example value number 1 stored here
    movwf 0x15 ; this will be used as a counter so 0x10 doesn't change
    movlw 107 ; example value number 2
    movwf 0x11 ; example value number 2 stored here
    clrw ; precautionary clearing of the working register
multiply:
    addwf 0x11,0 ; this adds example value number 2 to the working register
    decfsz 0x15 ; counter is decremented example value number 1 times
    goto multiply
    movwf 0x12 ; the final result is stored here; 
    
compare: 
    movf 0x10,0 ; loads example value number 1 into the working register
    subwf 0x11,0 ; subtracts example value number 1 from 2
    movwf 0x17
    btfss 0x17,7 ;looking at bit 7 for negative or positive 
    call ispositive
    btfsc 0x17,7 ;looking at bit 7 for negative or positive 
    call isnegative
        
    
modulo:
    movf 0x11,0 ; this is example number 2 moved to the working register
    movwf 0x14 ; example value 2 is put 0x14 as a dummy register 
    movf 0x10,0; example number 1 is moved to working register
removeinteger: ; this loops subtracts value 1 from 2 repetitively until the result is negative
    subwf 0x14,1 
    btfss 0x14,7
    goto removeinteger
    nop
findresidue:
    addwf 0x14,1; the above loop goes one step too far to example number 1 is added back once
    
    goto mainloop

ispositive:
    movlw 'P'
    movwf 0x13
    retlw 0
    nop ; needed to get the program counter to return to the correct spot

isnegative:
    movlw 'N'
    movwf 0x13
    retlw 0
    nop ; needed to get the program counter to return to the correct spot    
    
END resetVect  
