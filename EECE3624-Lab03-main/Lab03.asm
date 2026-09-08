/**************************************************************************
 *     File: Lab03.asm
 * Lab Name: Lab 03 In Progress
 *   Author: Allyanna Westcott
 *  Created: 09/07/2026
 *
 * This program simulates reading sensor data and doing operations on them.
 * It uses memory locations for sensors and result writes.
 * We hope to learn more about branching in assembly.

 * THIS PROGRAM WILL BE EDITED IN LAB. THIS COMMENT IS HERE TO DEMONSTRATE
 * ABILITY TO EDIT THE PROGRAM DESCRIPTION FIELD.
 *************************************************************************/

/************************************************************************
 * NOTE!  To populate the sensor data to memory, follow these steps!
 * 1) Set breakpoint on 1st instruction RJMP
 * 2) Set the stimulus file
 *    - Debug->Set Stimufile.  Select Lab03.stim
 *    - This only needs to be done ONCE (will save in project file)
 *    - Should be in your Project file from the Repo, but do once to be sure.
 * 3) Execute stimulus file
 *    - Debug->Execute Stimufile
 *    - This needs to be run EVERY TIME you restart a debug session.  :-(
 * 4) single step code
 * 5) Check that data IRAM at 0x0100 has changed "61 97"
 * 
 * Sensor1 Located at 0x0100 (preset to 0x61)
 * Sensor2 Located at 0x0101 (preset to 0x97)
 * 
 * NOTE:  For testing, you can modify these after loading them
 * to make sure all of your branches work properly
 ***********************************************************************/
.equ THRESHOLD = 0x90	; Create a constant
.def Sensor1 = R20		; Define a nickname for R20
.def Sensor2 = R21		; Define a nickname for R21

.org 0x0000 ; next instruction will be written to address 0x0000
            ; (the location of the reset vector)
RJMP main	; set reset vector to point to the main code entry point

main:       ; jump here on reset

; initialize the stack (RAMEND = 0x10FF by default for the ATmega128A)
	LDI R16, HIGH(RAMEND)
	OUT SPH, R16
	LDI R16, low(RAMEND)
	OUT SPL, R16

    ;----------------------------------
    ; student-written code begins here    

LDS R20, 0x0100
LDS R21, 0x0101

LDI YH, high(0x0110)	; setting Y pointer
LDI YL, low(0x0110)

CPI Sensor1, THRESHOLD

BRSH storeFourSix	; if Sensor >=THRESHOLD, go to storeFourSix
LDI R16, 0x50		; if Sensor < THRESHOLD, Execute this.
RJMP storeSensor1

storeFourSix:
LDI R16, 0x46			; if Sensor >=THRESHOLD, Execute this. Y at 0111 after instruction
storeSensor1:

ST Y+, R16			; Y = 0x0111 after instruction
ST Y+, Sensor1		; Y at 0x0112 after instruction

CPI Sensor2, THRESHOLD

BRLT storei			; if Sensor <THRESHOLD, go to storei
LDI R16, 's'		; if Sensor >= THRESHOLD, Execute this. 
RJMP finishIorS

storei:
LDI R16, 'i'		; if Sensor < THRESHOLD, Execute this.
finishIorS:

ST Y+, R16			; Y at 0113 after instruction
CP Sensor1, Sensor2

BRNE storeOneOneFive
LDI R16, 0x6C		; Executes if Sensor1 and Sensor2 are equal, stores 0d108 = 0x6C
RJMP end

storeOneOneFive:		; Branch here if Sensor1 and Sensor2 not equal
LDI R16, 0x73		; stores 0d115 = 0x73

end:
ST Y, R16
nop
