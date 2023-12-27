; Program to demomstrate indirect access to memory - both write and read
    
    
    
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
    nop
    nop
mainloop:
    movlw 0x10 ; This assigns the starting address in the sequence
    movwf FSR ; starting address is moved to FSR - that is, the first pointer is to 0x10
    movlw 5 ;Base ten number used in our example
    movwf 0x17 ; Holding resigister for incremented in steps of 5
    clrf INDF ; precautionary clearing of INDF
storeloop:
    movwf INDF ; This moves the contents of the working register to 0x10, 0x11, etc
    addwf 0x17,0 ; This is used for our example of loading steps of 5
    incf FSR, 1 ; this progresses the FSR to point to the next address 0x10 -> 0x11, etc
    btfss FSR, 2 ; This checks to see if we have reached the end of the string of addressed - 4 for this example
    goto storeloop
    nop
    movlw 0x10 ; This resets to the first address - 0x10 for this example
    movwf FSR ; starting address is moved to FSR - that is, the first pointer is to 0x10
readloop:
    movf INDF,0 ; This moves the contents of the register pointed to over to the working register
    incf FSR, 1 ; This moves the next pointer  0x10 -> 0x11, etc
    btfss FSR, 2; This checks to see if we have reached the end of the string of addressed - 4 for this example
    goto readloop
    goto mainloop
    nop; neccessary to go back to mainloop

END resetVect  


