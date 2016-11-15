TITLE Program Template           (Template.asm)

; Program Description : Assembly Assingment 4
; Team Name           :
; Author(s)           : Samuel Reeder, Sean Graham
; DueDate             : 4/4/2016
; Revisions           : Final

INCLUDE Irvine32.inc

.data
	;string variables
	myName     BYTE      "Samuel Reeder",0
	class      BYTE      "CS2810 Spring Semester 2016",0
	assingment BYTE      "Assembler Assingment #4",0
	userPrompt BYTE      "Please enter a FAT-16 file date in hex format: ", 0
	doAgain    BYTE		 "To check another file, enter 1. Enter 0 to quit.", 0

	;Array that stores the months, this will be used to print months based on the file date
	monthArray BYTE      "January ",0, "  "
			   BYTE		 "February ",0, " "
	           BYTE		 "March ",0, "    "
			   BYTE		 "April ",0, "    "
			   BYTE		 "May ",0, "      "
			   BYTE		 "June ",0, "     "
			   BYTE		 "July ",0, "     "
			   BYTE		 "August ",0, "   " 
			   BYTE		 "September ",0
			   BYTE		 "October ",0, "  "
			   BYTE		 "November ",0, " "
			   BYTE		 "December ",0, " "

	;suffix variables
	sTh        BYTE      "th ",0
	sSt        BYTE      "st ",0
	sNd		   BYTE      "nd ",0
	sRd		   BYTE      "rd ",0




	dateFile   DWORD	 0	;variable to store the date file hex number	

	year	   BYTE	 "----", 13, 10, 0  ;variable to track the year
	month      DWORD    0  ;variable to store the month index
	day		   BYTE	 "--",0  ;variable to track the day	

.code
main PROC
	mainLoop:
		;seting back and forground color
		MOV eax, white + (red*16)
		CALL SetTextColor
		;Clearing the screen
		CALL Clrscr

		;Calling the procedures that creat the assingment header
		CALL ClassName
		CALL AssignmentName
		CALL MyNameString
		CALL MyPrompt
		CALL getMonth
		CALL getDay
		CALL getSuff
		CALL getYear
		
	;This block of code asks the user to press enter a value of 1 to enter another date number or a value of 0 to end the program
	MOV edx, OFFSET doAgain
    CALL WriteString
    CALL ReadHex
	CMP eax, 01b
	JZ mainLoop
	JMP endProgram
	endProgram:
		CALL Crlf

	exit
main ENDP

;----------------------

;--------------------

getSuff PROC
MOV eax, dateFile
ROR ax, 8
AND eax, 00000000000000000000000000011111b

 CMP al, 00000b ;0
 	JZ TheEnd
 CMP al, 00001b ;1
 	JZ dST
 CMP al, 00010b ;2
 	JZ dND
 CMP al, 00011b ;3
 	JZ dRD
 CMP al, 10101b ;21
 	JZ dST
 CMP al, 10110b ;22
 	JZ dND
 CMP al, 10111b ;23
 	JZ dRD
 CMP al, 11111b ;31
 	JZ dST
;defalut case
 MOV edx, OFFSET sTh
 	JMP Display


 dST:
 	MOV edx, OFFSET sSt
 	JMP Display
 dND:
 	MOV edx, OFFSET sNd
 	JMP Display
 dRD:
 	MOV edx, OFFSET sRd
 	JMP Display
 TheEnd:
 	CALL WaitMsg


 Display:
 	CALL WriteString 


ret
getSuff ENDP



;---------------------------
getDay PROC

MOV eax, dateFile
ROR ax, 8
AND eax, 00000000000000000000000000011111b
XOR dx, dx
MOV bx, 10
DIV bx
ADD al, 30h
MOV BYTE ptr[day], al
MOV ax, dx
XOR dx, dx ; clears the register
MOV bx, 1
DIV bx
ADD al, 30h
MOV BYTE ptr[day+1], al



MOV edx, OFFSET[day]
CAll WriteString

ret
getDay ENDP

;------------------------

getMonth PROC
;-------------------------
;Description: This procedure will isolate the month bits from the user input and then print the month
;Recives:     16 bit hex number reprsenting a FAT-16 date.
;Return:      prints the month based on the number 0-11 obtained from decoding the FAT-16 date number
;Conditions:  None
;-------------------------
;Isloate the month bits
MOV eax, dateFile
ROR ax, 8
AND eax, 00000000000000000000000111100000b
SHR eax, 5
DEC eax

;logical comparisons to pick the months
CMP eax, 0000b ;january
JZ jan
CMP eax, 0001b ;February
JZ feb
CMP eax, 0010b ;march
JZ mar
CMP eax, 0011b ;April
JZ april
CMP eax, 0100b ;may
JZ may
CMP eax, 0101b ;june
JZ jun
CMP eax, 0110b ;july
JZ july
CMP eax, 0111b ;august
JZ aug
CMP eax, 1000b ;September
JZ sept
CMP eax, 1001b ;October
JZ oct
CMP eax, 1010b ;Novmeber
JZ nov
CMP eax, 1011b ;december
JZ decem
jan:
	MOV edx, OFFSET[monthArray]
	MOV bl,11
	MUL bl
	ADD edx, eax
	JMP Display

feb:
	MOV edx, OFFSET[monthArray]
	MOV bl,11
	MUL bl
	ADD edx, eax
	JMP Display 

mar:
	MOV edx, OFFSET[monthArray]
	MOV bl,11
	MUL bl
	ADD edx, eax
	JMP Display  

april:
	MOV edx, OFFSET[monthArray]
	MOV bl,11
	MUL bl
	ADD edx, eax
	JMP Display

may:
	MOV edx, OFFSET[monthArray]
	MOV bl,11
	MUL bl
	ADD edx, eax
	JMP Display

jun:
	MOV edx, OFFSET[monthArray]
	MOV bl,11
	MUL bl
	ADD edx, eax
	JMP Display

july:
	MOV edx, OFFSET[monthArray]
	MOV bl,11
	MUL bl
	ADD edx, eax
	JMP Display

aug:
	MOV edx, OFFSET[monthArray]
	MOV bl,11
	MUL bl
	ADD edx, eax
	JMP Display

sept:
	MOV edx, OFFSET[monthArray]
	MOV bl,11
	MUL bl
	ADD edx, eax
	JMP Display

oct:
	MOV edx, OFFSET[monthArray]
	MOV bl,11
	MUL bl
	ADD edx, eax
	JMP Display

nov:
	MOV edx, OFFSET[monthArray]
	MOV bl,11
	MUL bl
	ADD edx, eax
	JMP Display

decem:
	MOV edx, OFFSET[monthArray]
	MOV bl,11
	MUL bl
	ADD edx, eax
	JMP Display

Display:
	CALL WriteString 
ret
getMonth ENDP

getYear PROC
;-------------------------
;Description: This procedure will isolate the year bits from the user input and then print them as an ASCII characters
;Recives:     16 bit hex number reprsenting a FAT-16 date.
;Return:      a string of ASCII characters representing the year portion of the date
;Conditions:  None
;-------------------------

;Isolate the year bits of the date hex number
MOV eax, dateFile
ROR ax, 8
AND eax, 00000000000000001111111000000000b
SHR eax, 9
;calculating the year
ADD eax, 1980d 

;using Division the year will be turned in ACSII characters and stored in the year string
XOR dx, dx
MOV bx, 1000
DIV bx
ADD al, 30h
MOV BYTE ptr[year], al
MOV ax, dx
XOR dx, dx ; clears the register
MOV bx, 100
DIV bx
ADD al, 30h
MOV BYTE ptr[year+1], al
MOV ax, dx
XOR dx, dx ; clears the register
MOV bx, 10
DIV bx
ADD al, 30h
MOV BYTE ptr[year+2], al
MOV ax, dx
XOR dx, dx ; clears the register
MOV bx, 1
DIV bx
ADD al, 30h
MOV BYTE ptr[year+3], al
MOV edx, OFFSET[year]
CAll WriteString
CALL Crlf
ret
getYear ENDP

MyNameString PROC
;-------------------------
;Description: This procedure will use the Gotyxy and WriteStrin function to write my name
;Recives:     Nothing
;Return:      Nothing
;Conditions:  None
;-------------------------
;this block will set the texgt stored in the myName variable at the postion 3,6
	MOV dh, 6
	MOV dl, 0
	CALL Gotoxy
	MOV edx, OFFSET myName
	CALL WriteString
ret
MyNameString ENDP

ClassName PROC
;-------------------------
;Description: This procedure will use the Gotyxy and WriteStrin function to write the class
;Recives:     Nothing
;Return:      Nothing
;Conditions:  None
;-------------------------
;This block of code will set the text stored in the class variable to the position 1,6
	MOV dh, 4
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
	MOV dh, 5
	MOV dl, 0
	CALL Gotoxy
	MOV edx, OFFSET assingment
	CALL WriteString
ret
AssignmentName ENDP

MyPrompt PROC
;-------------------------
;Description: This procedure will use the WriteHex, WriteString, and Gotoxy function to prompt the user
;to enter a FAT-16 file date in hex format. This procedure will set the 
;Recives:    Nothing
;Return:     Nothing
;Conditions: None
;-------------------------
MOV dh, 8
MOV dl, 0
CALL Gotoxy
MOV edx, OFFSET userPrompt
CALL WriteString
CALL ReadHex
MOV dateFile,eax
MOV eax, 0
CALL Crlf
ret
MyPrompt ENDP

END main ;END OF FILE