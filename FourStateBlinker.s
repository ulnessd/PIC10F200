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
    btfss GP1 ; This will send the system to the two stats in which gp1 is clear
    call gp1clear ; calls the function that will set GP2
    btfsc GP1 ; This will send the system to the two stats in which gp1 is set
    call gp1set ; calls the function that will set GP2
    nop ; probably not neccessary
    
blink:
    bsf GP0
    movf 0x17,0 ; moves the blink rate stored in 0x17 to working register
    call delay
    bcf GP0
    movf 0x17,0 ; moves the blink rate stored in 0x17 to working register
    call delay
    goto mainloop
    nop
    

gp1clear:
    btfss GP2 ; this is the path when GP1 is clear and GP2 is clear
    call gpA ; this calls the 0-0 blink rate function
    btfsc GP2 ; this is the path when GP1 is clear and GP2 is set
    call gpB ; this calls the 0-1 blink rate function
    retlw 0
    nop

gp1set:
    btfss GP2 ; this is the path when GP1 is set and GP2 is clear
    call gpC ; this calls the 1-0 blink rate function
    btfsc GP2 ; this is the path when GP1 is set and GP2 is set
    call gpD ; this calls the 1-1 blink rate function
    retlw 0
    nop    
    
gpA:		;0-0 blink rate function
    movlw 25 ; 9.8 Hz 153600/25^3
    movwf 0x17
    retlw 0
    nop
    
gpB:		;0-1 blink rate function
    movlw 35 ; 3.6 Hz 153600/35^3
    movwf 0x17
    retlw 0
    nop
    
gpC:		;1-0 blink rate function
    movlw 50 ; 1.2 Hz 153600/50^3
    movwf 0x17
    retlw 0
    nop

gpD:		;1-1 blink rate function
    movlw 65 ; 0.56 Hz 153600/65^3
    movwf 0x17
    retlw 0
    nop

delay: ; this is a three-layer nested loop. wouldn't need 3 but it is what I had 
	; from other programs
    movwf 0x12
out_out_loop:
    movwf 0x11
outer_loop:
    movwf 0x10
delay_loop:
    decfsz 0x10, 1
    goto delay_loop
    decfsz 0x11, 1
    goto outer_loop
    decfsz 0x12, 1
    goto out_out_loop
    retlw 0 ; the return sets the working register to zero. 
    nop    
END resetVect 
