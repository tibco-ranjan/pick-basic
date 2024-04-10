*******************************************************************************
*
*       Program CALL_DUMPDATA.B
*       
*       Copyright (C) 2021
*
*
*******************************************************************************
*
*  Author: rprasad
*  Created on: Sep 30, 2021 2:11:45 PM
*  Description:
*
*
*****************************************************************************
X_CODE=2
X_PARAMS=""
X_OUTDATA=""
X_ERROR=0
*Initialize required variables.
CALL DUMP_SAMPLEDATA.B(X_CODE, X_PARAMS, X_OUTDATA, X_ERROR)

*Call the method to write in the Data File
X_CODE=3
PRINT "Calling the DUMP data method"
CALL DUMP_SAMPLEDATA.B(X_CODE, X_PARAMS, X_OUTDATA, X_ERROR)
PRINT X_OUTDATA
