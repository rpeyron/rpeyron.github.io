.286c
SEG_A		SEGMENT
		ASSUME CS:SEG_A, DS:SEG_A
		ORG	100H

COMDUMMY	PROC FAR
	INIT:	JMP	START

MSGINIT DB 'SaveMem 1.0 Install‚ avec succŠs. RP-Soft 27/7/99.',10,13,'$'
MSGACTI DB 'Activation par la touche ImprEcran.',10,13,'$'
NOMFIC  DB 'SaveMem.Bin',0
HANDLE  DW 0

NEWINT PROC FAR
	PUSHA
	PUSH CS
	POP AX
	MOV DS,AX
	;Creation du fichier
	MOV AH,3Ch
	MOV DX,OFFSET NOMFIC
	XOR CX,CX
	INT 21h
	MOV HANDLE,AX
	MOV BX,AX
	;Traitement
	MOV AX,0
	MOV CX,32
Boucle: PUSH AX
	PUSH CX
	MOV DS,AX
	MOV CX,32768
	MOV DX,0
	MOV AH,40h
	INT 21h
	POP CX
	POP AX
	ADD AX,2048
	LOOP Boucle
	;Fermeture du fichier
	MOV AH,3Eh
	INT 21h
	POPA
	IRET
NEWINT ENDP

START:	
;Installation du programme r‚sident
	;Affiche les messages
	MOV AH,09h
	MOV DX,OFFSET MSGINIT
	INT 21h
	;Remplacement de l'ancien vecteur d'interruption
	MOV AH,25h
	MOV AL,05h
	MOV DX,OFFSET NEWINT
	INT 21h
	;Termine et reste r‚sident
	MOV AX,3100h
	MOV DX,50		;Nombre de $ de 16
	INT 21h

		RETN
COMDUMMY	ENDP

SEG_A		ENDS
		END	INIT
