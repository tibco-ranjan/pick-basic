CREATERESOURCE
001 SUBROUTINE CreateResource(ID, FirstName, Result, FailureReason)

$INCLUDE INCLUDES COMMON.H
002 * Res ID - Input
003 * FirstName - Input
004 * Result - Output. Success or failure condition.
005 * FailureReason - details of the failure
006 *
007 Result = 0                                 ;*Success Condition
008 OPEN "", "MEMBERS" TO MEMBERS ELSE         ;* Open MEMBERS file
009 Result = 1                                 ;* Failure Condition
010 FailureReason = "Unable to open MEMBERS file"
011 RETURN
012 END
013 *
014 READ MEM.REC FROM MEMBERS, ID THEN         ;* Read MEMBERS file to make sure the Resource ID is already
015 Result = 1                           ;* If resource Id already exists then we return and set the failure condition
016 FailureReason = "ID already exists"    
017 RETURN
018 END ELSE
019 MEM.REC = ""
020 END
021 *
022 MEM.REC<1> = FirstName                     ;* Assuming field 1 is first name
023 WRITE MEM.REC ON MEMBERS, ID               ;*     Write away record to the MEMBERS file
024 Result = STATUS()
025 FailureReason = "Write success on MEMBERS file"
026 RETURN
027 END
028 *
029 RETURN
