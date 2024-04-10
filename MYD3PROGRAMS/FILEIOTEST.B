*******************************************************************************
*
*       Program FILEIOTEST
*       
*       Copyright (C) 2021
*
*
*******************************************************************************
*
*  Author: rprasad
*  Created on: Aug 18, 2021 8:26:10 PM
*  Description:
*
*
*****************************************************************************
SUBROUTINE FILEIOTEST(X_CODE, X_PARAMS, X_OUTDATA, X_ERROR)

$INCLUDE INCLUDES LOGGING.H

ON X_CODE GOSUB STARTUP, 
	READ_WRITE_DATA_FILE_SR_TEST,                 ;*Methoed used
	READ_WRITE_DATA_FILE_ALL_R_TEST,              ;*Methoed used
	READ_WRITE_DICT_TEST,                         ;*Methoed used
	SELECT_TEST,                                  ;*Methods used 
	READSEQ_WRTIESEQ_TEST,                        ;*Methods used
	READU_WRITEU_TEST,                            ;*Methods used
	READV_WRITEV_TEST                             ;*Methods used

********************************************
*Read and Write single record of ORDERS data file
********************************************
*---------------------------------------------------
*Data As a part of Read operation.
*---------------------------------------------------
*:LIST ORDERS ID CLIENT_NO BY.DSND ID
*
*:LISTDICT ORDERS
*SORT DICT ORDERS TYP LOC CONV MNAME FORMAT SM ASSOC BY TYP BY LOC BY @ID 12:45:09 Aug 21 2021 1
*@ID............ TYP LOC.......... CONV MNAME.......... FORMAT SM ASSOC.....
*
*@ID             D               0      ORDERS          10R    S
*ID              D               0      Order Number    10R    S
*ORD_DATE        D               1 D4/  Order Date      10R    S
*ORD_TIME        D               2 MTH  Order Time      7R     S
*CLIENT_NO       D               3      Client Number   10R    S
*PRODUCT_NO      D               4      Product Number  10R    MV LINE_ITEMS
*COLOR           D               5      Color           10T    MS LINE_ITEMS
*QTY             D               6      Qty             6R     MS LINE_ITEMS
*PRICE           D               7 MD2, Price           10R    MS LINE_ITEMS
*
*:LIST ORDERS ID ORD_DATE ORD_TIME CLIENT_NO PRODUCT_NO COLOR QTY PRICE WITH ID=982
*LIST ORDERS ID ORD_DATE ORD_TIME CLIENT_NO PRODUCT_NO COLOR QTY PRICE WITH ID=982 12:45:52 Aug 21 2021 1
*ORDERS                 982
*Order Number           982
*Order Date      10/24/2002
*Order Time      01:45PM
*Client Number        10020
*Product Number Color      Qty    Price
*         54000 N/A             5    $199.95
*         57050 Black           5    $179.99
*         56030 White           5     $19.99
*         10008 Black           2    $400.00
*
*1 record listed
*
*:AE ORDERS 982
*Top of "982" in "ORDERS", 7 lines, 94 characters.
**--: P10
*001: 12716
*002: 49500
*003: 10020
*004: 54000??????
*005: N/A??????
*006: 5??
*007: 19995????40000
*Bottom.
**--:
*
*:RUN BP CALL_FILEIOTEST
*In /usr/ud82/sys/CTLG/f/FILEIOTEST at line 18, INCLUDE/LOGGING.H at line 20 WARNING: UNINITIALIZED VARIABLE USED! Zero Assumed!
*CALLING READ_WRITE_TEST
*Enter the ORDERS record ID::
*?982
*Record ID=982
*Read ORDERS record 982 Value 12716?�49500?�10020?�54000???????�N/A???????�5???�19995????40000
*----------------------------------------------
* Data after write operations.
*---------------------------------------------
*:LIST ORDERS ID ORD_DATE ORD_TIME CLIENT_NO PRODUCT_NO COLOR QTY PRICE WITH ID=983
*LIST ORDERS ID ORD_DATE ORD_TIME CLIENT_NO PRODUCT_NO COLOR QTY PRICE WITH ID=983 13:53:35 Aug 21 2021 1
*ORDERS                 983
*Order Number           983
*Order Date      10/25/2002
*Order Time      01:45PM
*Client Number        10020
*Product Number Color      Qty    Price
*         54001 Blue           12    $299.95
*         57051 Purple         24    $399.95
*         56031 Green          36    $499.95
*         10009 Indigo         48    $599.95
*
*1 record listed
*
*:LIST ORDERS ID ORD_DATE ORD_TIME CLIENT_NO PRODUCT_NO COLOR QTY PRICE WITH ID=984
*LIST ORDERS ID ORD_DATE ORD_TIME CLIENT_NO PRODUCT_NO COLOR QTY PRICE WITH ID=984 13:53:47 Aug 21 2021 1
*ORDERS                 984
*Order Number           984
*Order Date      10/26/2002
*Order Time      01:45PM
*Client Number        10020
*Product Number Color      Qty    Price
*         54000 Blue            5    $199.95
*         57050 Black           5    $179.99
*         56030 White           5     $19.99
*         10008 Black           2    $400.00
*
*1 record listed
DataFile = 'ORDERS'
READ_WRITE_DATA_FILE_SR_TEST:
PRINT "CALLING READ_WRITE_TEST"

*Open the ORDERS Data file 
OPEN 'ORDERS' TO FDORDERS ELSE
	X_ERROR = ETOOL.OPENFILE
	X_OUTDATA = 'Failed to open the file: "' : DataFile : '"' : ' with STATUS= ' : STATUS()
END

*Read a specific record from the ORDERS FILE 
READ_RECORD = ''
PRINT "Enter the ORDERS record ID::"
INPUT RECORDID
READ READ_RECORD FROM FDORDERS, RECORDID THEN
	X_ERROR = ETOOL.SUCCESS
	GOSUB DISPLAY_RECORD
END ELSE
	X_ERROR = ETOOL.READFAIL
	X_OUTDATA = 'Failed to read record ' : RECORDID : ' with STATUS= ' : STATUS()
	*CLOSE FDORDERS
END

*--------------------------------------------
*How to get the number of records in a data file.
*:LIST ORDERS ID CLIENT_NO BY.DSND ID
*:SELECT ORDERS
*--------------------------------------------
*Write a new record in the ORDERS FILE.
NEW_REC_ID = 983
REC = ''
REC<1> = 12717
REC<2> = 49501
REC<3> = 10020
REC<4, 1> = 54001
REC<4, 2> = 57051
REC<4, 3> = 56031
REC<4, 4> = 10009
REC<5, 1> = 'Blue'
REC<5, 2> = 'Purple'
REC<5, 3> = 'Green'
REC<5, 4> = 'Indigo'
REC<6, 1> = 12
REC<6, 2> = 24
REC<6, 3> = 36
REC<6, 4> = 48
REC<7, 1> = 29995
REC<7, 2> = 39995
REC<7, 3> = 49995
REC<7, 4> = 59995

*Write a NEW record	
WRITE REC ON FDORDERS, NEW_REC_ID ON ERROR
	X_ERROR = ETOOL.WRITEFAIL
	X_OUTDATA = 'Failed to write for record ID' : NEW_REC_ID : ' with STATUS= ' : STATUS()
END

*Write another record
NEW_REC_ID = 984
SREC = 12718 : @FM : 49502 : @FM : 10020 : @FM : 54000 : @VM : 57050 : @VM : 56030 : @VM : 10008 : @FM : 'Blue' : @VM : 'Black' : @VM : 'White' : @VM : 'Black' : @FM : 5 : @VM : 5 : @VM : 5 : @VM : 2 : @FM : 19995 : @VM : 17999 : @VM : 1999 : @VM : 40000
WRITE SREC ON FDORDERS, NEW_REC_ID ON ERROR
	X_ERROR = ETOOL.WRITEFAIL
	X_OUTDATA = 'Failed to write for record ID ' : NEW_REC_ID : ' with STATUS= ' : STATUS()
END
CLOSE FDORDERS

RETURN TO STARTUP

********************************************
*Read all records of ORDERS data file
********************************************
READ_WRITE_DATA_FILE_ALL_R_TEST:
	*Read all the records of ORDER data file.
	RETURN TO STARTUP

********************************************
*Read all attributes of ORDERS DICT file
********************************************
READ_WRITE_DICT_TEST:
	*Open the ORDERS DIR to read the attributes	
	DFptr = ""
	OPEN 'DICT', 'ORDERS' TO DFptr ELSE
		X_ERROR = ETOOL.OPENFILE
		X_OUTDATA = 'Failed to open the file: "' : DataFile : '"' : ' with STATUS= ' : STATUS()
	END

	*STORE the ORDER DIR attributes in a SELECT LIST
	DirAttributes = ""
	HUSH ON
	EXECUTE "SSELECT DICT ORDERS BY LOC TO 3"
	HUSH OFF


	LOOP
		READNEXT D_ID FROM 3 ELSE D_ID = ""
	UNTIL D_ID = "" DO
		READ DirAttributes FROM DFptr, D_ID THEN
			PRINT '--------------------------------------'
			PRINT 'ID=     ' : D_ID
			PRINT '--------------------------------------'
			PRINT 'TYPE=   ' : DirAttributes<1>
			PRINT 'LOC=    ' : DirAttributes<2>
			PRINT 'CONV=   ' : DirAttributes<3>
			PRINT 'NAME=   ' : DirAttributes<4>
			PRINT 'FORMAT= ' : DirAttributes<5>
			PRINT 'SM=     ' : DirAttributes<6>
			PRINT 'ASSOC=  ' : DirAttributes<7>
		END ELSE
			X_ERROR = ETOOL.READFAIL
			X_OUTDATA = 'Failed to READ the DICT: "' : DataFile : '"' : ' with STATUS= ' : STATUS()
		END
	REPEAT
	RETURN TO STARTUP

********************************************
*Helper Function: Display a record
********************************************	
DISPLAY_RECORD:
	PRINT "Record ID=" : RECORDID
	OUTDATA = 'Read record ' : RECORDID : ' Value ' : READ_RECORD
	X_OUTDATA = READ_RECORD
	PRINT OUTDATA
	RETURN



SELECT_TEST:
	PRINT "SELECT_TEST"
	RETURN TO STARTUP

READSEQ_WRTIESEQ_TEST:
	PRINT "READSEQ_WRTIESEQ_TEST"
	RETURN TO STARTUP

READU_WRITEU_TEST:
	PRINT "READU_WRITEU_TEST"
	RETURN TO STARTUP

READV_WRITEV_TEST:
	PRINT "READV_WRITEV_TEST"
	RETURN TO STARTUP

STARTUP:
	RETURN

END
