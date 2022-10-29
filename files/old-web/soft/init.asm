.MODEL SMALL
.CODE
ORG 100h

START: JMP DEBUT
;**** Donnees ****

 MonFic   DB 'C:\DOS\INIT.DAT',0
 Handle   DW 0
 Tab      DB '          '
 Jour     DB 'Dimanche  '
          DB 'Lundi     '
          DB 'Mardi     '
          DB 'Mercredi  '
          DB 'Jeudi     '
          DB 'Vendredi  '
          DB 'Samedi    '
 NbLet    DW 10
 Num      DB '00010203040506070809'
          DB '10111213141516171819'
          DB '20212223242526272829'
          DB '30313233343536373839'
          DB '40414243444546474849'
          DB '50515253545556575859'
          DB '60616263646566676869'
          DB '70717273747576777879'
          DB '80818283848586878889'
          DB '90919293949596979899'
 Slash    DB '/'
 Points   DB ':'
 Retour   DB 10,13


; **** Macros ****

 EcritNum PROC
          MOV BX,2
          MUL BX
          ADD AX,OFFSET Num
          MOV DX,AX
          MOV BX,Handle
          MOV CX,2
          MOV AH,40h
          INT 21h
          RET
 EcritNum ENDP

 EcritCar PROC
          MOV AX,4000h
          MOV BX,Handle
          INT 21h
          RET
 EcritCar ENDP

; **** Programme ****

 DEBUT: PUSH DS
        POP DS

        MOV AH,02
        INT 16h
        AND AL,127
        CMP Al,69
        JE SUITE
        JMP FINT
 SUITE: JMP FIN
 FINT:  MOV AX,3D02h
        MOV DX,OFFSET MonFic
        INT 21h
        JNC Pass1
        CMP AX,02
        JE Sui1
        JMP FIN

 Sui1:  MOV DX,OFFSET MonFic
        MOV AX,3C00h
        MOV CX,02h
        INT 21h
        JNC Pass1
        JMP FIN

 Pass1: MOV Handle,AX

        MOV AX,4202h
        MOV BX,Handle
        MOV CX,0
        MOV DX,0
        INT 21h

        MOV BX,Handle
        MOV AX,4000h
        MOV CX,4
        MOV DX,OFFSET Tab
        INT 21h
        JNC Sui2
        JMP FIN

 Sui2:  MOV AX,2A00h
        INT 21h

        PUSH CX
        PUSH DX

        MOV AH,0
        MOV BX,NbLet
        MUL BX
        ADD AX,OFFSET Jour
        MOV DX,AX
        MOV CX,NbLet
        CALL EcritCar

        POP DX
        PUSH DX

        XOR AX,AX
        MOV AL,DL
        CALL EcritNum

        MOV DX,OFFSET Slash
        MOV CX,1
        CALL EcritCar

        POP DX
        XOR AX,AX
        MOV AL,DH
        CALL EcritNum

        MOV DX,OFFSET Slash
        MOV CX,1
        CALL EcritCar

        POP CX
        MOV AX,CX
        MOV BX,1900
        SUB AX,BX  ;DIV BX
        ;CLC
        ;MOV AX,DX
        CALL EcritNum

        MOV DX,OFFSET Tab
        MOV CX,4
        CALL EcritCar

        MOV AX,2C00h
        INT 21h

        PUSH DX
        PUSH CX

        MOV AH,0
        MOV AL,CH
        CALL EcritNum

        MOV DX,OFFSET Points
        MOV CX,1
        CALL EcritCar

        POP CX
        XOR AH,AH
        MOV AL,CL
        CALL EcritNum

        MOV DX,OFFSET Points
        MOV CX,1
        CALL EcritCar

        POP DX
        XOR AH,AH
        MOV AL,DH
        CALL EcritNum

        MOV DX,OFFSET Retour
        MOV CX,2
        CALL EcritCar

        MOV BX,Handle
        MOV AX,3E00h
        INT 21h
        JC FIN

        XOR AL,AL
 FIN:   MOV AH,4Ch
        INT 21h

END START
