******************************************************************************
*
*   Header file for XML BASIC programs
*
*	Module	%M%	Version	%I% 	Date	%H%
*
*       (c) Copyright 2002 - 2014 Rocket Software, Inc. - All Rights Reserved
*       This is unpublished proprietary source code of Ardent Software Inc.
*       The copyright notice above does not evidence any actual or intented
*       publication of such source code.
*
*******************************************************************************
*
*       Maintenence log - insert most recent change descriptions at top
*
*       Date.... GTAR# WHO Description.........................................
*
*	11/14/13 Double Xia UDT-8081: XML library update.
*	07/07/11 Double Xia UDT-4007: XDOM API enhancements.
*	11/06/03       ZJH add for U2XMAP APIs.
*
*****************************************************************************

* XML RETCODES and defines.

EQU XML.SUCCESS				TO		  0
EQU XML.ERROR				TO		 -1
EQU XML.INVALID.HANDLE			TO		 -2
EQU XML.EOF				TO		100

* Open mode for XMAPOpen() and XMLOpen()
EQU XML.READ				TO		0
EQU XML.WRITE				TO		1
EQU XML.READWRITE			TO		2
EQU XML.CREATE				TO		3

* Write mode for XMLWrite()
EQU XML.TO.FILE				TO		0
EQU XML.TO.STRING			TO		1
EQU XML.TO.DOM				TO		2

* Flag for form File or from STRING
EQU XML.FROM.FILE			TO		0
EQU XML.FROM.STRING			TO		1
EQU XML.FROM.DOM			TO		2

* Flag for form File or from STRING
EQU XMAP.FROM.FILE			TO		0
EQU XMAP.FROM.STRING			TO		1
EQU XMAP.FROM.DOM			TO		2

* Field type for XMAP RELATIONSHIP (for internal use only)
EQU XML.NORMAL.FIELD			TO		0
EQU XML.GENERATED.ID			TO		1
EQU XML.ORDER.COLUMN			TO		2
EQU XML.GEN.CANDIDATEKEY		TO		3
EQU XML.CANDIDATE.KEY			TO		4
EQU XML.FOREIGN.KEY			TO		5
EQU XML.GEN.FOREIGNKEY			TO		6

* Generated KEY type
EQU XKEY.XFIELD				TO		1
EQU XKEY.SUBR				TO		2

* Macro for XDOM operations
EQU XDOM.TRUE		     TO				1
EQU XDOM.FALSE		     TO				0