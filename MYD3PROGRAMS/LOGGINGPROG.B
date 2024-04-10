*******************************************************************************
*
*       Program LOGGINGPROG
*       
*       Copyright (C) 2021
*
*
*******************************************************************************
*
*  Author: rprasad
*  Created on: Jul 28, 2021 11:38:55 AM
*  Description:
*
*
*****************************************************************************
SUBROUTINE LOGGINGPROG(X_CODE, X_PARAMS, X_OUTDATA, X_ERROR)

$INCLUDE INCLUDES LOGGING.H

X_CODE = X_CODE + 1

ON X_CODE GOSUB INITIALISE,
         StartUP,               ;* Startup code
         AddNum,                ;* Add Operation
         SubNum,                ;* Sub Operation
         MulNum,                ;* Mul Operation
         DivNum,                ;* Div Operation
         Unused                 ;*

INITIALISE:
PRINT "X_CODE=":X_CODE
PRINT "Initialization goes here"

*Get the system information
sys = SYSTEM(33)
PRINT "MV Platform=": sys 
ver = SYSTEM(45)
UDHOME = SYSTEM(31)
PRINT "MV Version=": ver 

*Initialize OS.TYPE and OS.SEP   
IF sys = "UNIX" THEN
    OS.TYPE = "UNIX"
    OS.SEP = "/"
END ELSE
	OS.TYPE = "NT"
    OS.SEP = "\"
END

*Initialize debugging flag
Logging = 1
RETURN ;*End of Initialization

AddNum:
PRINT "X_CODE=":X_CODE
PRINT "Called Addition"
SUM = X_PARAMS<1> + X_PARAMS<2>
X_OUTDATA = X_OUTDATA:" SUM=":SUM
PRINT "Addition Result=": X_OUTDATA
X_ERROR = ETOOL.SUCCESS
GOSUB LOG
*GOSUB READPERSONDICT
GOSUB READLOGINSEQ
RETURN

SubNum:
PRINT "X_CODE=":X_CODE
PRINT "Called Substraction"
RETURN

MulNum:
PRINT "X_CODE=":X_CODE
PRINT "Called Multiplicatoin"
RETURN

DivNum:
PRINT "X_CODE=":X_CODE
PRINT "Called Division"
RETURN

Unused:
PRINT "X_CODE=":X_CODE
PRINT "Unused local function"
RETURN

StartUP:
RETURN
**************************************************
* Debugging log file
*************************************
LOG:
* Change logging to use OPENSEQ, WRITESEQF
    IF Logging THEN
	IF NOT(FILEINFO(LogFile,0)) THEN	 
          IF OS.TYPE = "UNIX" THEN
             LogFilePath = "/tmp/XTOOLSUB"
          END ELSE
             LogFilePath = "C:\tmp\XTOOLSUB"
          END  
	  
	  LogFilePath = LogFilePath:"_":@DATE:"_":@TIME:".log"	  
	  OPENSEQ LogFilePath TO LogFile ELSE PRINT "error"
	  WRITESEQF "Logging started ":OCONV(@DATE,'D'):" ":OCONV(@TIME,'MTHS') TO LogFile ELSE PRINT "error"
	END
	
	rec = "Code ":X_CODE:", Para ":X_PARAMS:", Error ":X_ERROR:", out ":X_OUTDATA
	WRITESEQF rec APPEND TO LogFile ELSE MsgFileFD
	WRITESEQF " " APPEND TO LogFile ELSE PRINT "error"
	
	END ;* End of Logging
	CLOSESEQ LogFile
RETURN ;* End of LOG method.

READLOGINSEQ:
OPENSEQ LogFilePath TO ReadLogFile ELSE PRINT "error in OPENSEQ"
IF FILEINFO(ReadLogFile,0) THEN
	READSEQ rec1 FROM  ReadLogFile ELSE rec1=""
	PRINT "rec1=":rec1
	READSEQ rec2 FROM  ReadLogFile ELSE rec2=""
	PRINT "rec2=":rec2
END
CLOSESEQ ReadLogFile
RETURN ;* End of READLOGINSEQ

READLOG:
PRINT "READING THE LOG FILE ":LogFilePath
OPEN LogFilePath TO LOG.DATA ON ERROR PRINT "File open error." THEN
PRINT "SELECTING THE RECORED OF ":LogFilePath
SELECT LOG.DATA TO 1
 LOOP
  WHILE READNEXT rec FROM 1 DO
    PRINT "Reading Record ID=":rec
    READU REC FROM LOG.DATA,rec THEN
    PRINT "Record Raw Format":REC
    *PRINT "Record ":rec:" Details"
    *PRINT "NAME=":REC<1>
    *PRINT "Childern=":REC<2,1>:" ":REC<2,2>:" ":REC<2,3>:" "
    *PRINT "Childern Age=":REC<3,1>:" ":REC<3,2>:" ":REC<3,3>:" "
    END ELSE
    PRINT "Record not found."
    END
 REPEAT
END
RETURN ;* End of READLOG

READPERSONDICT:
OPEN 'PERSON' TO PERSON.DATA ON ERROR PRINT "File open error." THEN
PRINT "SELECTING THE RECORED OF ":LogFilePath
SELECT PERSON.DATA TO 1
 LOOP
  WHILE READNEXT rec FROM 1 DO
    PRINT "Reading Record ID=":rec
    READU REC FROM PERSON.DATA,rec THEN
    PRINT "Record Raw Format":REC
    PRINT "Record ":rec:" Details"
    PRINT "NAME=":REC<1>
    PRINT "Childern=":REC<2,1>:" ":REC<2,2>:" ":REC<2,3>:" "
    PRINT "Childern Age=":REC<3,1>:" ":REC<3,2>:" ":REC<3,3>:" "
    END ELSE
    PRINT "Record not found."
    END
 REPEAT
END
RETURN ;* End of fucntion READPERSONDICT

*End of SUBROUTINE LOGGINGPROG
END 


