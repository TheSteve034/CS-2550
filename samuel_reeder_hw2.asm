TITLE Program Template           (Template.asm)

; Program Description:
; Author: Samuel Reeder
; DueDate: 4/4/2016
; Revisions: 1.0

INCLUDE Irvine32.inc

CHAR_VALUE = 'X' ; Set Global Constant value

.data
	;string variables
	myName BYTE     "Samuel Reeder",0
	class BYTE      "CS2810 Spring Semester 2016",0
	assingment BYTE "Assembler Assingment #2",0
	myX BYTE        "X",0
	
	;counter variables
	rowColor  DWORD 0;
	charColor DWORD 0;
	dhCount   BYTE 5;
	dlCount1  BYTE 6;
	dhCount1  BYTE 5;
	count     DWORD 0;
	
	
.code
main PROC
	;Clearing the screen
	CALL Clrscr

    ;This block of code will set the text stored in the class variable to the position 1,6
	MOV dh, 1
	MOV dl, 6
	CALL Gotoxy
	MOV edx, OFFSET class
	CALL WriteString

	;this block will the set the text stored in the assingment variable to the postion 2,6
	MOV dh, 2
	MOV dl, 6
	CALL Gotoxy
	MOV edx, OFFSET assingment
	CALL WriteString

	;this block will set the texgt stored in the myName variable at the postion 3,6
	MOV dh, 3
	MOV dl, 6
	CALL Gotoxy
	MOV edx, OFFSET myName
	CALL WriteString

		MOV ecx,16
    ;this label holdc the logic for setting the brground color for each row as well as moving each new row to the next line with the correct offset			
	L1:
	    MOV dh, dhCount
	    MOV dl, 6
	    CALL Gotoxy
		MOV eax, rowColor
		MOV ebx, 16
		MUL ebx
		ADD eax, rowColor
		CALL SetTextColor
		INC dhCount
		INC dl
		MOV count,ecx
		MOV ecx, 16
	;this label holds the logic for writting the character "X" in different colors on each line.	
	L2:
		MOV eax, charColor
		CALL SetTextColor
		MOV al, CHAR_VALUE
		CALL WriteChar
		INC charColor
	LOOP L2
	MOV ecx, count
	LOOP L1
	
	;this final block of code will reset the text color to white and the background to black so that the wait message can be easily read.
	MOV eax, white + (black * 16)
	CALL SetTextColor
	MOV dh, 21
	MOV dl, 6
	CALL Gotoxy
	CALL WaitMsg
	;clearing the screen again so that there will not be two wait messages on screen
	CALL Clrscr

	exit
main ENDP
	; (insert additional procedures here)

END main