; program to read in an ASCII character via UART, store the character, 
    ;and output whether it is upper case or lower case
    
    ; Note: set baud rate in putty to 3550
    
; PIC10F200 Configuration Bit Settings

; Assembly source line config statements

; CONFIG
  CONFIG  WDTE = OFF            ; Watchdog Timer (WDT disabled)
  CONFIG  CP = OFF              ; Code Protect (Code protection off)
  CONFIG  MCLRE = OFF           ; Master Clear Enable (GP3/MCLR pin fuction is digital I/O, MCLR internally tied to VDD)

// config statements should precede project file includes.
#include <xc.inc>
  

PSECT resetVect, class=CODE, delta=2
resetVect:
    PAGESEL main
    goto main
    
    
PSECT code, delta=2

main:
    movlw 0b00001110 ; first four zeros are irrelevent. 
		     ; last four GP3, GP2, GP1, GP0
		     ; 1 will set to input, 0 will set to output
		     ; GP3 is input only.
		     
		     ;use GP0 for data
		     ;use GP1 for clock
		     ;use GP2 for displaying

    tris 6 ;the 6 sets tris to the value stored in W
    nop
    movlw 0b11011111 ;the zero here will set GP2 to IO rather than external clock
    option ; the contents of the working register is moved to OPTION register 
    nop


mainloop:
    bcf GP0
    movlw 9 ; counter for read loop
    movwf 0x16
    movlw 9 ; counter for oscilloscope display loop
    movwf 0x15
    clrf 0x17 ; memory address for storing ASCII character
pollingloop:    
    btfsc GP1 ; waiting for signal from computer. Signal is active low
    goto pollingloop
    nop
    nop
    nop
readloop:    
    btfsc GP1
    bsf 0x17,0
    btfss GP1
    bcf 0x17,0
    rrf 0x17,1 ; this shifts the bits through memory
    movlw 4 ; this delay corresponds to a baud rate of about 3550
    call delay
    decfsz 0x16 
    goto readloop
display:
    btfss 0x17,0
    bcf GP0
    btfsc 0x17,0
    bsf GP0
    rrf 0x17,1 ; this shifts through the contents of 0x17 bit by bit
    movlw 4
    call delay
    decfsz 0x15
    goto display
upperlower:
    bcf GP0
    btfsc 0x17,6 ; bit to key in on for upper versus lower case
    bsf GP0
    movlw 58
    call delay
    goto mainloop
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
