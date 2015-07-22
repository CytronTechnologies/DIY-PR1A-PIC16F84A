;===============================================================================================
;
;	Author					: Cytron Technologies
;   Project					: DIY Project
;	Project Descrription	: PR1 (LED Blinking)
;	Date					: 25 May 2009
;
;===============================================================================================


;===============================================================================================
;	Project Description
;===============================================================================================
;   This file is a basic code template for assembly code generation   
;   on the PICmicro PIC16F84A. This file contains the basic code      
;   building blocks to build upon.                                      
;                                                                     
;   If interrupts are not used all code presented between the ORG     
;   0x004 directive and the label main can be removed. In addition    
;   the variable assignments for 'w_temp' and 'status_temp' can       
;   be removed.                                                                              
;                                                                     
;   Refer to the MPASM User's Guide for additional information on     
;   features of the assembler (Document DS33014).                     
;                                                                     
;   Refer to the respective PICmicro data sheet for additional        
;   information on the instruction set.                               
;                                                                     
;   Template file assembled with MPLAB V8.30.00 and MPASM V5.30.01.   
;                                                                    
;==============================================================================================
                                                                     
                                                                                                                                                                               
;==============================================================================================
;                                                                     
;    Files required:                                                  
;                                                                     
;==============================================================================================                                                                                                                                          
;                                                                     
;    Notes:                                                           
;     1. For beginner, the parts that you need to edit are: BANK, TRIS, PORT, DELAY                                                                 
;     2. All the general I/O pin only can use as input or output with the prior setting at TRIS.                                                                 
;     3. Let say in this case, we use pin 1,2 and 3 (RA2, RA3, RA4) as input and pin 10,11,12 (RB4, RB5, RB6) as output. So, we must 
;        set TRISA,2 TRISA,3 TRISA,4 to '1' and TRISB,4 TRISB,5 TRISB,6 to '0'(in assembly, set '1' we use BSF, set '0' we use BCF
;        which we can write in this way: 
;										 BSF 	TRISA,2                                                      
;                                        BSF	TRISA,3
;									     BSF	TRISA,4  
;
; 										 BCF	TRISB,4
;										 BCF	TRISB,5
;										 BCF    TRISB,6
;
;     4. But, pls remember that before you can change TRISA, you need to switch from BANK0 to BANK1, then switch back to BANK0 after
;        setting the TRISA.BANK0 is used to control the actual operation of the PIC.For example to tell the PIC which bits of Port 
;        are input and which are output.BANK1 is used to manipulated the data. 
;     5. Bare in mind that in programming, we read the input; and write the output. 
;     6. In assembly, to read we use BTFSC or BTFSS; while to write we use MOVLW, MOVWF, CLF, BSF or BCF. (and other type of 
;        insrtuction that you can refer to PIC datasheet)   
;     7. DELAY is a kind of method that we used to use it to delay our PIC for some operation.
;	  8. We already prepare the DELAY subroutine, you just CALL DELAY when you need it.
;     9. You also can change the delay time by changing the value in DELAY subroutine. (the maximum value is 255)          
;
;=============================================================================================


	list      p=16F84A            ; list directive to define processor
	#include <p16F84A.inc>        ; processor specific variable definitions

	__CONFIG   0X3FF2

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The lables following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.


;============================================================================================ 
; VARIABLE DEFINITION
;============================================================================================

D1			EQU		0X20	;FOR DELAY
D2			EQU		0X21	;FOR DELAY
D3			EQU		0X22	;FOR DELAY



;===========================================================================================
; WRITE YOUR PROGRAM HERE
;===========================================================================================
	
		ORG     0x000             ; processor reset vector
  		goto    main              ; go to beginning of program

main

; initialize of your PIC, setting the general I/O in TRIS		

		BSF		STATUS,5				;SWITCH TO BANK1 ;BIT 5 OF STATUS REGISTER IS SET TO 1
		CLRF	TRISB					;SET PORTB AS OUTPUT
		BSF		TRISA,2					;SET RA2 AS INPUT ;RA2=1
		BSF		TRISA,3					;SET RA3 AS INPUT ;RA3=1
		BSF		TRISA,4					;SET RA4 AS INPUT ;RA4=1
		BCF		STATUS,5				;SWITCH TO BANK0 ;BIT 5 OF STATUS REGISTER IS SET TO 0

		CLRF	PORTB					;SET ALL 8 PIN IN PORTB TO LOW(0)

;the main program begin here

START

		BTFSS		PORTA,2				;check signal at pushbutton1, if press then goto following line, else skip the following line
		GOTO		ONE					;button1 pressed, program execute the operation in subroutine ONE	
		BTFSS		PORTA,3				;check signal at pushbutton2, if press then goto following line, else skip the following line
		CALL		TWO					;button2 pressed, program execute the operation in subroutine TWO
		BTFSS		PORTA,4				;check signal at pushbutton3, if press then goto following line, else skip the following line
		CALL		THREE				;button3 pressed, program execute the operation in subroutine THREE
		GOTO		START				;no any button being pressed, program keep looping to check the pushbuttons' signal 

ONE	
		BSF			PORTB,6				;RB6 is set to high(1)
		CALL		DELAY				;DELAY
		BCF			PORTB,6				;RB6 is set to low(0)
		BSF			PORTB,5				;RB5 is set to high(1)
		CALL		DELAY				;DELAY
		BCF			PORTB,5				;RB5 is set to low(0)
		BSF			PORTB,4				;RB4 is set to high(1)
		CALL		DELAY				;DELAY
		BCF			PORTB,4				;RB4 is set to low(0)
		BTFSS		PORTA,3             ;check signal at pushbutton2, if press then goto following line, else skip the following line
		GOTO		TWO					;pushbutton2 pressed, program execute the operation in subroutine TWO
		BTFSS		PORTA,4				;check signal at pushbutton3, if press then goto following line, else skip the following line
		GOTO		THREE				;pushbutton3 pressed, program execute the operation in subroutine THREE
		GOTO		ONE					;no any button being pressed, program keep looping in ONE subroutine
TWO	
		MOVLW		B'11111111'
		MOVWF		PORTB				;Set all 8 pin in PORTB to high(1)
		CALL		DELAY				;DELAY
		CLRF		PORTB				;Set all 8 pin in PORTB to low(0)
		CALL		DELAY				;DELAY
		BTFSS		PORTA,4				;check signal at pushbutton3, if press then goto following line, else skip the following line
		GOTO		THREE				;pushbutton3 pressed, program execute the operation in subroutine THREE
		BTFSS		PORTA,2				;check signal at pushbutton1, if press then goto following line, else skip the following line
		GOTO		ONE					;pushbutton1 pressed, program execute the operation in subroutine ONE	
		GOTO		TWO					;no any button being pressed, program keep looping in TWO subroutine
		
THREE
		BSF			PORTB,6				;RB6 is set to high(1)
		BSF			PORTB,4				;RB4 is set to high(1)
		CALL		DELAY				;DELAY
		CLRF		PORTB				;Set all 8 pin in PORTB to low(0)
		BSF			PORTB,5				;RB5 is set to high(1)
		CALL		DELAY				;DELAY
		BTFSS		PORTA,2				;check signal at pushbutton1, if press then goto following line, else skip the following line
		GOTO		ONE					;pushbutton1 pressed, program execute the operation in subroutine ONE	
		BTFSS		PORTA,3				;check signal at pushbutton2, if press then goto following line, else skip the following line
		GOTO		TWO					;pushbutton2 pressed, program execute the operation in subroutine TWO
		GOTO		THREE				;no any button being pressed, program keep looping in THREE subroutine	
		
		
		


;================================================================================================
; DELAY SUBROUTINE
;================================================================================================

DELAY		MOVLW	D'200'			;PAUSE FOR ABOUT 76mS (u can change the 200, 150, 1 value to obtain different delay timing)
			MOVWF	D3
			MOVLW	D'150'
			MOVWF	D2
			MOVLW	D'1'
			MOVWF	D1
			DECFSZ	D1
			GOTO	$-1
			DECFSZ	D2
			GOTO	$-5
			DECFSZ	D3
			GOTO	$-9
			RETURN


	    	END                     ; directive 'end of program'

