TITLE Program Template           (Template.asm)

; Program Description:
; Author: Samuel Reeder
; DueDate: 4/4/2016
; Revisions: 1.0

INCLUDE Irvine32.inc

CHAR_VALUE = 'X' ; Set Global Constant value

.data
	;string variables
	myName     BYTE      "Samuel Reeder",0
	class      BYTE      "CS2810 Spring Semester 2016",0
	assingment BYTE      "Assembler Assingment #3",0
	userPrompt BYTE      "Please enter an MP3 header in hex format: ", 0
	
	;variable to store the header hex number
	header     DWORD	 0	 

	;MPEG combinations
	mpeg2	   BYTE		 "MPEG Version: 2.0",0
	mpeg25	   BYTE		 "MPEG Version: 2.5",0
	mpeg1	   BYTE		 "MPEG Version: 1.0",0
	mpegRes	   BYTE		 "MPEG Version: Reserved",0
	versionFlag  DWORD	 ? ;layer flag: tracks the layer of the header 0 = 2.5, 1 = reserved, 2 = 2, 3 = 1
	;Layer Combinations
	lres       BYTE      "Reserved",0
	l1         BYTE      "Layer 1",0
	l2         BYTE      "Layer 2",0
	l3         BYTE      "Layer 3",0
	;Sampling rates
	s0V1         BYTE      "Sampling Rate: 44100 HZ",0
	s0V2         BYTE      "Sampling Rate: 22050 HZ",0
	s0V25        BYTE      "Sampling Rate: 11025 HZ",0
	s1V1         BYTE      "Sampling Rate: 48000 HZ",0
	s1V2         BYTE      "Sampling Rate: 24000 HZ",0
	s1V25        BYTE      "Sampling Rate: 12000 HZ",0
	s2V1         BYTE      "Sampling Rate: 32000 HZ",0
	s2V2         BYTE      "Sampling Rate: 16000 HZ",0
	s2V25        BYTE      "Sampling Rate: 8000 HZ",0
	sRes         BYTE      "Sampling Rate: Reserved",0
	
	
.code
main PROC
	;seting back and forground color
	MOV eax, blue + (green*16)
	CALL SetTextColor
	;Clearing the screen
	CALL Clrscr

    ;Calling the procedures that creat the assingment header
	CALL ClassName
	CALL AssignmentName
	CALL MyNameString

	;Calling the procedure that prompts the user to enter an MP3 header
	CALL MyPrompt

	;Calling the display procedures
	CALL DisplayVersion
	CALL DisplayLayer
	CALL DisplayRate
	
	exit
main ENDP
;AAAAAAAAAAABBCCDEEEEFFGHIIJJKLMM
DisplayRate  PROC
;-------------------------
;Description: This procedure will display the MPEG sampling rate from the header the user provides 
;Recives:    Header data
;Return:     Nothing
;Conditions: Nothing
;-------------------------
;isolate the sampling rate bits
MOV eax, header
AND eax, 00000000000000000000110000000000b
SHR eax, 10

;this section will preform logical comparisons to determine the sampling rate and then print it. First it will check the layer flag to find the layer.
;once that has been determined it will check the isolated bits for the sampling rate and print it.

;these CMPs will check the version flag and then point to the approporiate label 
MOV ecx, versionFlag
CMP ecx, 00b 
JZ version25

CMP ecx, 10b
JZ version2

CMP ecx, 11b
JZ version1

MOV edx, OFFSET sRes
JMP DisplayString

;these layers check the isolated bits for thier sample rate based on the layer
version1:
	CMP eax, 00b
	JZ DispSamp1and1 ;Corseponds to version1 bits 00

	CMP eax, 01b
	JZ DispSamp2and1 ;coresponds to version1 bits 01

	CMP eax, 10b  
	JZ DispSamp3and1 ;coresponds to version1 bits 10
version2:
	CMP eax, 00b
	JZ DispSamp1and2 ;coresponds to version2 bits 00

	CMP eax, 01b
	JZ DispSamp2and2 ;coresponds to version2 bits 01

	CMP eax, 10b
	JZ DispSamp3and2 ;coresponds to version2 bits 10
version25:
	CMP eax, 00b
	JZ DispSamp1and3 ;coresponds to version2.5 bits 00

	CMP eax, 01b
	JZ DispSamp2and3 ;coresponds to version2.5 bits 01

	CMP eax, 10b
 	JZ DispSamp3and3 ;coresponds to version2.5 bits 10

;these layers print the sampling rate based on the version

;Version 1
DispSamp1and1:
	MOV edx, OFFSET s0V1
	JMP DisplayString
DispSamp2and1:
	MOV edx, OFFSET s1V1
	JMP DisplayString
DispSamp3and1:
	MOV edx, OFFSET s2V1
	JMP DisplayString

;Version 2
DispSamp1and2:
	MOV edx, OFFSET s0V2
	JMP DisplayString
DispSamp2and2:
	MOV edx, OFFSET s1V2
	JMP DisplayString
DispSamp3and2:
	MOV edx, OFFSET s2V2
	JMP DisplayString

;Version 2.5
DispSamp1and3:
	MOV edx, OFFSET s0V25
	JMP DisplayString
DispSamp2and3:
	MOV edx, OFFSET s1V25
	JMP DisplayString
DispSamp3and3:
	MOV edx, OFFSET s2V25
	JMP DisplayString

;display string label
DisplayString:
	CALL WriteString
	CALL Crlf

ret
DisplayRate ENDP

DisplayLayer PROC
;-------------------------
;Description: This procedure will display the MPEG layer from the header the user provides 
;Recives:    Header data
;Return:     Nothing
;Conditions: Nothing
;-------------------------
;isolate the layer bits
MOV eax, header
AND eax, 00000000000001100000000000000000b
SHR eax, 17

;The next section witll preform logical Comparisons to determine the layer and then print it.
CMP eax, 00b
JZ DispLres

CMP eax, 01b
MOV ebx, 3
JZ DispL3

CMP eax, 10b
JZ DispL2

MOV edx, OFFSET l1
JMP DisplayString

CALL Crlf

DispLres:
	MOV edx, OFFSET lres
	JMP DisplayString

DispL3:
	MOV edx, OFFSET l3
	JMP DisplayString

DispL2:
	MOV edx, OFFSET l2
	JMP DisplayString

DisplayString:
	CALL WriteString
	CALL Crlf
	
ret
DisplayLayer ENDP

DisplayVersion PROC
;-------------------------
;Description: This procedure will display the MPEG version from the header the user provides 
;Recives:    Header data
;Return:     Nothing
;Conditions: Nothing
;-------------------------
;isolate the version bits
MOV eax, header
AND eax, 00000000000110000000000000000000b
SHR eax,19

;The next section witll preform logical Comparisons to determine the version and then print it. It will also set the version flag variable for use in the
;DisplayRate procedure
CMP eax, 00b
JZ DispMpeg25

CMP eax, 01b
JZ DispMpegRes

CMP eax, 10b
JZ DispMpeg2

MOV edx, OFFSET mpeg1
MOV ecx, 3
MOV versionFlag, ecx
JMP DisplayString
CALL Crlf

;this section hold all of the lables that do the actual printing of the version
DispMpeg25:
	MOV edx, OFFSET mpeg25
	MOV ecx, 0
	MOV versionFlag, ecx
	JMP DisplayString

DispMpegRes:
	MOV edx, OFFSET mpegRes
    MOV ecx, 1
	MOV versionFlag, ecx
	JMP DisplayString

DispMpeg2:
	MOV edx, OFFSET mpeg2
	MOV ecx, 2
	MOV versionFlag, ecx
	JMP DisplayString

	DisplayString:
		CALL WriteString
		CALL Crlf
ret
DisplayVersion ENDP

MyNameString PROC
;-------------------------
;Description: This procedure will use the Gotyxy and WriteStrin function to write my name
;Recives:    Nothing
;Return:     Nothing
;Conditions: None
;-------------------------
;this block will set the texgt stored in the myName variable at the postion 3,6
	MOV dh, 4
	MOV dl, 0
	CALL Gotoxy
	MOV edx, OFFSET myName
	CALL WriteString
ret
MyNameString ENDP

ClassName PROC
;-------------------------
;Description: This procedure will use the Gotyxy and WriteStrin function to write the class
;Recives:    Nothing
;Return:     Nothing
;Conditions: None
;-------------------------
;This block of code will set the text stored in the class variable to the position 1,6
	MOV dh, 2
	MOV dl, 0
	CALL Gotoxy
	MOV edx, OFFSET class
	CALL WriteString
ret
ClassName ENDP

AssignmentName PROC
;-------------------------
;Description: This procedure will use the Gotyxy and WriteStrin function to write the assingment
;Recives:    Nothing
;Return:     Nothing
;Conditions: None
;-------------------------
;this block will the set the text stored in the assingment variable to the postion 2,6
	MOV dh, 3
	MOV dl, 0
	CALL Gotoxy
	MOV edx, OFFSET assingment
	CALL WriteString
ret
AssignmentName ENDP

MyPrompt PROC
;-------------------------
;Description: This procedure will use the WriteHex, WriteString, and Gotoxy function to prompt the user
;to enter an MP3 header in hex format.
;Recives:    Nothing
;Return:     Nothing
;Conditions: None
;-------------------------
MOV dh, 6
MOV dl, 0
CALL Gotoxy
MOV edx, OFFSET userPrompt
CALL WriteString
CALL ReadHex
MOV header,eax
MOV eax, 0
CALL Crlf
ret
MyPrompt ENDP

END main ;END OF FILE