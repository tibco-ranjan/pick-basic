*******************************************************************************
*
*       Program LOGGING.H
*       
*       Copyright (C) 2021
*
*
*******************************************************************************
*
*  Author: rprasad
*  Created on: Sep 30, 2021 10:26:09 AM
*  Description:
*
*
*****************************************************************************
* COMMON VARIABLE
COMMON /LOGGING/ OS.TYPE, OS.SEP, UVHOME, UDHOME, Logging, LogFile, LogFilePath

* CONSTANT defination
EQU	TRUE	TO	1
EQU	FALSE	TO	0

* ERROR number defination
EQU ETOOL.SUCCESS           TO  0   ;* Operation Success.
EQU	ETOOL.LOGERROR	        TO	5	;* intermediate file not exist
EQU ETOOL.OPENFILE          TO	6	;* c
EQU ETOOL.READFAIL		    TO	7	;* c
EQU ETOOL.WRITEFAIL		    TO	8	;* f
EQU ETOOL.LOCKED            TO  9   ;*L
EQU ETOOL.RECORDEXIST       TO 10   ;*next
EQU ETOOL.RECORDCHANGED     TO 11   ;* RECORED CHANGED