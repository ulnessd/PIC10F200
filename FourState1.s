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
    movlw 0b00000001
    movwf 0x17
    btfss 0x17,0 ;looking at bit 0 for negative or positive 
    call gp0clear
    btfsc 0x17,0
    call gp0set
    goto mainloop
    nop
    

gp0clear:
    btfss 0x17,1
    call gpA
    btfsc 0x17,1
    call gpB
    retlw 0
    nop

gp0set:
    btfss 0x17,1
    call gpC
    btfsc 0x17,1
    call gpD
    retlw 0
    nop    
    
gpA:
    movlw 5
    movwf 0x10
    retlw 0
    nop
    
gpB:
    movlw 10
    movwf 0x10
    retlw 0
    nop
    
gpC:
    movlw 15
    movwf 0x10
    retlw 0
    nop

gpD:
    movlw 20
    movwf 0x10
    retlw 0
    nop
    
END resetVect  
