SUBROUTINE XTOOLSUB(X_CODE, X_PARAMS, X_OUTDATA, X_ERROR)
*******************************************************************************
*
*       Server subroutine for XMAP TOOL
*
*       Module%M%Version%I% Date%H%
*
*   Rocket Confidential
*   OCO Source Materials
*   Copyright (C) Rocket software, 2020
*
*
*******************************************************************************
*
* DESCRIPTION:
*
*   This subroutine contains all the server codes for XMAPTOOL
*
*   Input arguments:  Action  - key for action to be taken
*                              Params  - parameters required by the
*                                                    particular function being
*                                                    performed, field mark separated
*
*   Output arguments: OutData - any output from the requested
*                                                    function, field mark separated
*                              Error   - error code or 0 if no error
*
*****************************************************************************
include dm,bp,includes sysID.inc
include dm,bp,unix.h fcntl.h

COMMON /AAA/ Logging, LogFile, VFLAG, ClearXOUTDATA, LogFilePath
WhoAmI = "Main Program XTOOLSUB"
X_ERROR = 0
ClearXOUTDATA = 0
X_CODE = X_CODE + 1
Logging = 0
LogStmt=""
LogFilePath = ""

*Getting the System OS info
imp=SYSTEM(38)
IF imp<sys$host>=sys$unix THEN
    * UNIX system
     OS.TYPE = "UNIX"
     OS.SEP = "/"
 END ELSE
    * Windows NT system
     OS.TYPE = "NT"
     OS.SEP = "\"
END

* Read the XTOOLSUBLOG data file to read LogFilePath value
* logging

OPEN 'XTOOLSUBLOG' TO XTOOLSUBLOG.FILE ELSE STOP 201, 'xtoolsublog'
ID=1
READU item FROM  XTOOLSUBLOG.FILE,ID ELSE STOP 202, ID
LogFilePath  = item<1>

PRINT "LogFilePath FROM FILE XTOOLSUBLOG=": LogFilePath

IF LogFilePath <> "" THEN
    Logging = 1
END ELSE
    Logging = 0
END

PRINT "Logging Value set to ":Logging
*Check of Any Error : Not Equal : ne # <>
IF X_ERROR <> 0 THEN
 RETURN
END

*Envokes the respective local subroutine corresponding to passed X_CODE value
 * INITIALISE,          ;* Get essentinal systme information.
 * GetAccounts,                                      ;* Get all accounts in this server.
 * LogtoAccount,                                 ;* Logto one account.
 * GetFiles,            ;* Get all data table under this acct.
 * ReadDICT,            ;* Read DICT info
 * PREINITIALISE,                                ;* execute initial commands, before doing anything else.
ON X_CODE GOSUB INITIALISE,
    GetAccounts,
    LogtoAccount,
    GetFiles,
    GetDict,
    OSBrowse,
    ToXMAP1,
    ToXMAP2,
    ReadXMAP,
    WriteXMAP,
    GetDTDs,
    ReadDTD,
    GetXMAPs,
    CheckXMAP,

    Readitems,
    ClearTable,
    DB2XML,
    XML2DB,

    GetXSDs,
    ReadXSD,

    FileLock,
    ReleaseFileLock,

    GetDrivers,

    ReadOSFile,

    WriteOSFile,
    WriteOSFileForce,
    CopyOSFile,
    CopyOSFileForce,

    GetPlatform,

    RemoveFiles,
    NewAcct,
    DeleteAcct,

    CreateFile,
    ReadDICT,
    WriteDICT,

    ReadFile,
    UpdateFile,
    Deleteitem,
    Additem,

    GenDICT,
    GenXSD,
    CopyFile,

    GetXMLFiles,
    CheckID,

    Iconv,
    Oconv,

    GetCTLGFiles,
    GetParas,

    GetBPFiles,
    ReadBPFile,
    WriteBPFile,

    GetDIRitemordList,
    ReadDIRitemord,
    WriteDIRitemord,
    CompileDIRitemord,
    CatalogDIRitemord,
    ListUsers,
    GetMultiDIRitemordLis,
    PREINITIALISE,
    GetAccountFlavor,

    GetToolVersion,
    OSCreateFolder,

    SetNoConvert,
    GetHome,

    GetFileList,
    GetFileTypeInfo,

    SetRCPToolName,
    LocateCTLGSource,
    LmeCheck,
    LmeBridgeCall,
    STARTWS,
    STOPWS,
    Unused

GOSUB InitLOG
RETURN

***********************************************************************
*
* PRE_INITIALISE is called only when there're some initial commands to execute
*
***********************************************************************
PREINITIALISE:
WhoAmI = "PREINITIALISE"
LogStmt = "From ":WhoAmI

    PRINT "In the PREINITIALISE local call"
    INICMDS = TRIM(X_PARAMS<1>)

    IF INICMDS <> "" THEN
    GOSUB ExecInitialCommands
    END
    GOSUB InitLOG

RETURN


ExecInitialCommands:

NO_CMDS = DCOUNT(INICMDS, CHAR(10))

FOR CMDIDX = 1 TO NO_CMDS
    ONECMD = FIELD(INICMDS, CHAR(10), CMDIDX)
    ONECMD = TRIM(ONECMD)
    IF ONECMD <> "" THEN
         X_OUTDATA = X_OUTDATA:CHAR(10):ONECMD

         CMD_PREF = FIELD(ONECMD, ' ', 1)
         CMD_REST=FIELD(ONECMD, ' ', 2, 999)

         IF CMD_PREF = "PERFORM" THEN
                             PERFORM CMD_REST ; *CAPTURING outX
         END ELSE IF CMD_PREF = "EXECUTE" THEN
                             EXECUTE CMD_REST CAPTURING outX
         END ELSE
                             EXECUTE ONECMD CAPTURING outX
         END

         X_OUTDATA = X_OUTDATA:CHAR(10): CHANGE(outX, @FM, CHAR(10)):CHAR(10)
    END


NEXT CMDIDX

RETURN

***********************************************************************
*
* Get and Set environment before deal the real functions
* As of now just printing the system info
* This local subrouitine will change as per the requirement.
*
***********************************************************************
INITIALISE:

*Get Host Details
imp = SYSTEM(100)
PRINT "Systme Info  ": imp

*Set Syestem var
info=SYSTEM(38)
IF info<sys$host>=sys$unix THEN
   * UNIX system
     OS.TYPE = "UNIX"
     OS.SEP = "/"
 END ELSE
   * Windows NT system
     OS.TYPE = "NT"
     OS.SEP = "\"
END

PRINT "OS=":OS.TYPE
***********************************************************************
*
* Get ALL ACCOUNTS on this server
*     input: none
*
***********************************************************************
GetAccounts:
OPEN 'mds' TO mds.file ELSE STOP
  EXECUTE 'SELECT mds,, WITH a1 = "d]" OR WITH a1 = "q]" AND WITH a2 = "fsi:]"' CAPTURING accounts
  SELECT mds.file TO mds.list; *  saving the select output account list into the mds.list
  EOF=0
LOOP
  READNEXT ID FROM mds.list ELSE EOF=1; * Read the ID iteretively.
UNTIL EOF DO
   X_OUTDATA<-1> = ID:@VM:ID ; * Need to parse for @VM while reading.
REPEAT

CLOSE mds.file
RETURN

***********************************************************************
*
* Goto ONE special ACCOUNT
*     input: account name
*

***********************************************************************
LogtoAccount:
WhoAmI = "GetFiles"
LogStmt = "From ":WhoAmI
ACCT_ID = TRIM(X_PARAMS)
PRINT "ACC_ID=":" ":ACCT_ID

X_OUT = ""
ExLine = "LOGTO ":ACCT_ID: " (f"
GOSUB ExecWithCapture
X_OUT = TRIM(X_OUT)

*The (f option supress any output, does the login silently
IF X_OUT <> "" THEN
      X_ERROR = ETOOL.WRONGPATH
      X_OUTDATA = "Invalid account ":ACCT_ID
      RETURN
END ELSE
      ExLine="WHO "
      GOSUB ExecWithCapture
      X_OUTDATA = 'LOGTO ':ACCT_ID:' was successful'
END

PRINT "Logging the account details ":X_OUTDATA
GOSUB InitLOG

RETURN
***********************************************************************
*
* Get ALL FILES under one ACCOUNT on this server,
* trying to get file type as well.
*     no input,
*
***********************************************************************
GetFiles:

WhoAmI = "GetFiles"
LogStmt = "From ":WhoAmI
OPEN 'md' TO md.file ELSE STOP
 EXECUTE 'SSELECT md WITH a1 = "d]" ' CAPTURING OUTPUT
 SELECT md.file TO md.list; * Rediitemting to list
EOF=0

LOOP
  READNEXT ID FROM md.list ELSE EOF=1; * Getting the files from list.
UNTIL EOF DO
   X_OUTDATA<-1> = ID:@VM:ID ; * Formatig to read.
REPEAT
CLOSE md.file

GOSUB InitLOG
RETURN

***********************************************************************
*

* Subroutine to read DICT info
*     input: filename
*
***********************************************************************
ReadDICT:
WhoAmI = "ReadDICT"
LogStmt = "From ":WhoAmI
FILE_NAME = TRIM(X_PARAMS)
FLAG=0

OPEN 'dict',FILE_NAME  TO dict.file ELSE STOP
   statement = 'SSELECT DICT ':FILE_NAME:'  WITH a1 NE "d]"'
   EXECUTE statement CAPTURING OUTPUT
   SELECT dict.file to dict.list; *rediitemt output to the list
EOF=0
LOOP
  READNEXT ID FROM dict.list ELSE eof=1
  WHILE eof NE 1 DO

    READ item FROM dict.file,ID THEN

    *Used char(251)  as a @TM
    *Used char(254)  as a @FM
    ************************************
    *a0 Item-ID
    *a1 Dictionary-Code
    *a2 Attribute-Count (Location)
    *a3 Substitute-Header
    *a4 Structure (Association)
    *a5,a6 Reserved and Unavailable
    *a7 Output conversion
    *a8 Correlative
    *a9 Attribute-Type
    *a10 Column-Width
    *a11,a12,a13 Reserved and Unavailable
    *a14 Input-Conversion (process code value limit [v1: single value, if not assigned multivalued])
    *a15 Macro
    *a16 Reserved and Unavailable
    *a17 Description
    *a18,a19 Reserved and Unavailable
    *a20-a30 Hot Keys.
    **************************************
    *Reference : Defining attributes (D3 Reference Guide)
    *https://www3.rocketsoftware.com/rocketd3/support/documentation/d3nt/103/refman/index.htm


    IF FLAG THEN
        X_OUTDATA = X_OUTDATA:char(251):ID:char(254):item<1>:char(254):item<2>:char(254):item<7>:char(254):item<3>:char(254):item<10>:item<9>:char(254):item<4>:char(254):item<8
>:char(254):item<14>
     END ELSE
        X_OUTDATA = ID:char(254):item<1>:char(254):item<2>:char(254):item<7>:char(254):item<3>:char(254):item<10>:item<9>:char(254):item<4>:char(254):item<8>:char(254):item<14>

        FLAG = 1
    END
   END

REPEAT

CLOSE dict.file
GOSUB InitLOG
RETURN

**********************************************************************
* Get Cataloged files
**********************************************************************
GetCTLGFiles:
CTLGFlag = TRIM(X_PARAMS)

WhoAmI = "GetCTLGFiles"
LogStmt = "From ":WhoAmI

OPEN 'md' TO md.file ELSE STOP
 EXECUTE 'sselect md v/cat with v/type = "vr""VR" and with v/cat ' CAPTURING OUTPUT
 SELECT md.file TO md.list; * Rediitemting to list
EOF=0

LOOP
  READNEXT ID FROM md.list ELSE EOF=1; * Getting the files from list.
UNTIL EOF DO
   ID=TRIM(ID)
   X_OUTDATA<-1> = ID
REPEAT
CLOSE md.file

GOSUB InitLOG
RETURN

 **********************************************************************
*
*  Execute an ECL command, put the result into LIST 0
*
************************************************************************
ExecWithCapture:
    ECHO ON
    PRINT "ExLine=":" ":ExLine
    EXECUTE ExLine CAPTURING X_OUT
    PRINT "X_OUT=":" ":X_OUT
    ECHO OFF
    ECHO ON
RETURN


**************************************************
* Debugging log file
* As of now enabling logging true by default,
* will make it configurable later on.
**************************************************
InitLOG:
LogFile="XTOOLSUB"
ID=1
*If Logging is set then log output to XTOOLSUB.LOG file

IF Logging THEN
  IF   LogFilePath  = ""  THEN
    IF OS.TYPE = "UNIX" THEN
        LogFilePath = "/tmp/"
     END  ELSE
        LogFilePath="C:\Temp\"
    END
   END

  PRINT "LogFilePath=":LogFilePath
 *Get the Logging Path.
 IF LogFilePath <> "" THEN
    LogDate = oconv(date(),"d-")
    LogTime = time()
    LogFile = LogFilePath:LogFile:"_":LogDate:"_":LogTime:".log"
 END

 PRINT "The log file ":LogFile
 fd=%open(LogFile, o$creat+o$wronly+o$append)
 if fd<0 then
  PRINT "Cannot open. errno=":system(0)
  RETURN
 end

 timestamp = OCONV(DATE(),'D2/'):" ":OCONV(TIME(),'MTHS')
 item = LogStmt :" Code ":X_CODE:", Para ":X_PARAMS:", Error ":X_ERROR:", Out ":X_OUTDATA
 writeInLog=timestamp:"   ":item

 n = len(writeInLog)
 if %write(fd,writeInLog,n)<n then
   PRINT "write error"
 end

 if %close(fd) then
   PRINT "Cannot close file"
   stop
 end

END
PRINT "Done with the writing"
RETURN

**************************************************
* As of now provided empty implementation for
* most of the local subroutine, to make them
* incline with the existing client.
**************************************************
GetDict:
RETURN
OSBrowse:
RETURN
ToXMAP1:
RETURN
ToXMAP2:
RETURN

ReadXMAP:
RETURN
WriteXMAP:
RETURN
GetDTDs:
RETURN
ReadDTD:
RETURN
GetXMAPs:
RETURN
CheckXMAP:
RETURN
Readitems:
RETURN
ClearTable:
RETURN
DB2XML:
RETURN
XML2DB:
RETURN
GetXSDs:
RETURN
ReadXSD:
RETURN
FileLock:
RETURN
ReleaseFileLock:
RETURN
GetDrivers:
RETURN
ReadOSFile:
RETURN
WriteOSFile:
RETURN
WriteOSFileForce:
RETURN
CopyOSFile:
RETURN
CopyOSFileForce:
RETURN
GetPlatform:
RETURN
RemoveFiles:
RETURN
NewAcct:
RETURN
DeleteAcct:
RETURN
CreateFile:
RETURN
WriteDICT:
RETURN
ReadFile:
RETURN
UpdateFile:

RETURN
Deleteitem:
RETURN
Additem:
RETURN
GenDICT:
RETURN
GenXSD:
RETURN
CopyFile:
RETURN
GetXMLFiles:
RETURN
CheckID:
RETURN
Iconv:
RETURN
Oconv:
RETURN
GetParas:
RETURN
GetBPFiles:
RETURN
ReadBPFile:
RETURN
WriteBPFile:
RETURN
GetDIRitemordList:
RETURN
ReadDIRitemord:
RETURN
WriteDIRitemord:
RETURN
CompileDIRitemord:
RETURN
CatalogDIRitemord:
RETURN
ListUsers:
RETURN
GetMultiDIRitemordLis:
RETURN
GetAccountFlavor:
RETURN
GetToolVersion:
RETURN
OSCreateFolder:
RETURN
SetNoConvert:
RETURN
GetHome:
RETURN
GetFileList:
RETURN
GetFileTypeInfo:
RETURN

SetRCPToolName:
RETURN
LocateCTLGSource:
RETURN
LmeCheck:
RETURN
LmeBridgeCall:
RETURN
STARTWS:
RETURN
STOPWS:
RETURN
Unused:
RETURN

RETURN ;*End of Main SUBROUTINE XTOOLSUB