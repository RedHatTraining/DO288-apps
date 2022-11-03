       PROCESS CICS,NODYNAM,NSYMBOL(NATIONAL),TRUNC(STD)
       CBL CICS('SP,EDF')
      ******************************************************************
      *                                                                *
      * Licensed Materials - Property of IBM                           *
      *                                                                *
      * (c) Copyright IBM Corp. 2015,2020.                             *
      *                                                                *
      * US Government Users Restricted Rights - Use, duplication       *
      * or disclosure restricted by GSA ADP Schedule Contract          *
      * with IBM Corp.                                                 *
      *                                                                *
      ******************************************************************

      ******************************************************************
      * This is the Credit/Debit program in the BANKING application
      * BMS suite.
      *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BNK1CRA.
       AUTHOR. Jon Collett.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
      *SOURCE-COMPUTER.   IBM-370 WITH DEBUGGING MODE.
       SOURCE-COMPUTER.  IBM-370.
       OBJECT-COMPUTER.  IBM-370.

       INPUT-OUTPUT SECTION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      * Copyright statement as a literal to go into the load module
       77 FILLER PIC X(80) VALUE
           'Licensed Materials - Property of IBM'.
       77 FILLER PIC X(80) VALUE
           '(c) Copyright IBM Corp. 2015,2020. All Rights Reserved.'.
       77 FILLER PIC X(80) VALUE
           'US Government Users Restricted Rights - Use, duplication '.
       77 FILLER PIC X(80) VALUE
           'or disclosure restricted by GSA ADP Schedule Contract '.
       77 FILLER PIC X(80) VALUE
           'with IBM Corp.'.


       01 WS-CICS-WORK-AREA.
          03 WS-CICS-RESP              PIC S9(8) COMP
                                                     VALUE 0.
          03 WS-CICS-RESP2             PIC S9(8) COMP
                                                     VALUE 0.
       01 WS-FAIL-INFO.
          03 FILLER                    PIC X(9)      VALUE 'BNK1CRA  '.
          03 WS-CICS-FAIL-MSG          PIC X(70)     VALUE ' '.
          03 FILLER                    PIC X(6)      VALUE ' RESP='.
          03 WS-CICS-RESP-DISP         PIC 9(10)     VALUE 0.
          03 FILLER                    PIC X(7)      VALUE ' RESP2='.
          03 WS-CICS-RESP2-DISP        PIC 9(10)     VALUE 0.
          03 FILLER                    PIC X(15)     VALUE
                                                      ' ABENDING TASK.'.
       01 SWITCHES.
          03 VALID-DATA-SW             PIC X         VALUE 'Y'.
             88 VALID-DATA                           VALUE 'Y'.

       01 FLAGS.
          03 SEND-FLAG                 PIC X.
             88 SEND-ERASE                           VALUE '1'.
             88 SEND-DATAONLY                        VALUE '2'.
             88 SEND-DATAONLY-ALARM                  VALUE '3'.

       01 ACTION-ALPHA.
          03 ACTION-NUM                PIC 9.

      *
      * The end of session message
      *
       01 END-OF-SESSION-MESSAGE       PIC X(13)     VALUE
                                                        'Session Ended'.
       01 RESPONSE-CODE                PIC S9(8) COMP.

       01 COMMUNICATION-AREA           PIC X.

       COPY BNK1CDM.

       COPY DFHAID.

       01 AMTI9                        PIC 9(12).

       01 WS-AMOUNT-AS-FLOAT COMP-2.
       01 WS-NUM-COUNT-TOTAL           PIC S9(8) BINARY.
       01 WS-NUM-COUNT-POINT           PIC S9(8) BINARY.
       01 WS-NUM-COUNT-SPACE           PIC S9(8) BINARY.

       01 WS-AMOUNT-UNSTR              PIC X(13).
       01 WS-AMOUNT-UNSTR-L            PIC S9(8) BINARY.
       01 WS-AMOUNT-UNSTR-REVERSE      PIC X(13).

       01 WS-STUFF1.
          03 WS-COMM-ACT-BAL-UNSIGN    PIC 9(12).
       01 WS-STUFF2 REDEFINES WS-STUFF1.
          03 WS-COMM-ACT-BAL-X         PIC X(12).

       01 WS-STUFF3.
          03 WS-COMM-AMT-UNSIGN        PIC 9(12).
       01 WS-STUFF4 REDEFINES WS-STUFF3.
          03 WS-COMM-AMT-X             PIC X(12).

       01 WS-STUFF5.
          03 WS-COMM-AV-BAL-UNSIGN     PIC 9(12).
       01 WS-STUFF6 REDEFINES WS-STUFF5.
          03 WS-COMM-AV-BAL-X          PIC X(12).

       01 WS-COMM-AREA.
          03 WS-COMM-ACCNO             PIC X(8).
          03 WS-COMM-SIGN              PIC X.
          03 WS-COMM-AMT               PIC 9(12).

       01 WS-CONVERSIONA.
          03 WS-CONVERT-PIC1           PIC X(13).
          03 WS-CONVERT-PIC1SP REDEFINES WS-CONVERT-PIC1.
             05 WS-CONVERT-PIC1-1ST    PIC X(10).
             05 WS-CONVERT-PIC1-POINT  PIC X.
             05 WS-CONVERT-PIC1-2ND    PIC XX.

       01 WS-CONVERSIONB.
          03 WS-CONVERT-PICX           PIC X(13).
          03 WS-CONVERT-SPLIT REDEFINES WS-CONVERT-PICX.
             05 WS-CONVERT-DEC         PIC 9(10).
             05 WS-CONVERT-POINT       PIC X.
             05 WS-CONVERT-REMAIN      PIC 99.

       01 WS-CONVERTED-VAL1            PIC S9(10)V99 VALUE 0.
       01 WS-CONVERTED-VAL2            PIC S9(10)V99 VALUE 0.
       01 WS-CONVERTED-VAL3            PIC S9(10)V99 VALUE 0.
       01 WS-CONVERTED-VAL4            PIC S9(10)V99 VALUE 0.

       01 SUBPGM-PARMS.
          03 SUBPGM-ACCNO              PIC X(8).
          03 SUBPGM-AMT                PIC S9(10)V99.
          03 SUBPGM-SORTC              PIC 9(6).
          03 SUBPGM-AV-BAL             PIC S9(10)V99.
          03 SUBPGM-ACT-BAL            PIC S9(10)V99.
          03 SUBPGM-ORIGIN.
               05 SUBPGM-APPLID           PIC X(8).
               05 SUBPGM-USERID           PIC X(8).
               05 SUBPGM-FACILITY-NAME    PIC X(8).
               05 SUBPGM-NETWRK-ID        PIC X(8).
               05 SUBPGM-FACILTYPE        PIC S9(8) COMP.
               05 FILLER                  PIC X(4) VALUE SPACES.
          03 SUBPGM-SUCCESS            PIC X.
          03 SUBPGM-FAIL-CODE          PIC X.

       01 COMPANY-NAME-FULL            PIC X(32).

       01 AVAILABLE-BALANCE-DISPLAY    PIC +9(10).99.
       01 ACTUAL-BALANCE-DISPLAY       PIC +9(10).99.

       01 WS-U-TIME                    PIC S9(15) COMP-3.
       01 WS-ORIG-DATE                 PIC X(10).
       01 WS-ORIG-DATE-GRP REDEFINES WS-ORIG-DATE.
          03 WS-ORIG-DATE-DD           PIC 99.
          03 FILLER                    PIC X.
          03 WS-ORIG-DATE-MM           PIC 99.
          03 FILLER                    PIC X.
          03 WS-ORIG-DATE-YYYY         PIC 9999.

       01 WS-ORIG-DATE-GRP-X.
          03 WS-ORIG-DATE-DD-X         PIC XX.
          03 FILLER                    PIC X         VALUE '.'.
          03 WS-ORIG-DATE-MM-X         PIC XX.
          03 FILLER                    PIC X         VALUE '.'.
          03 WS-ORIG-DATE-YYYY-X       PIC X(4).

       01 WS-TIME-DATA.
          03 WS-TIME-NOW               PIC 9(6).
          03 WS-TIME-NOW-GRP REDEFINES WS-TIME-NOW.
             05 WS-TIME-NOW-GRP-HH     PIC 99.
             05 WS-TIME-NOW-GRP-MM     PIC 99.
             05 WS-TIME-NOW-GRP-SS     PIC 99.

       01 WS-ABEND-PGM                 PIC X(8)      VALUE 'ABNDPROC'.

       01 ABNDINFO-REC.
           COPY ABNDINFO.

       LINKAGE SECTION.
       01 DFHCOMMAREA.
          03 COMM-ACCNO                PIC X(8).
          03 COMM-SIGN                 PIC X.
          03 COMM-AMT                  PIC 9(12).


       PROCEDURE DIVISION USING DFHCOMMAREA.
       PREMIERE SECTION.
       A010.

           EVALUATE TRUE
      *
      *       Is it the first time through? If so, send the map
      *       with erased (empty) data fields.
      *
              WHEN EIBCALEN = ZERO
                 MOVE LOW-VALUE TO BNK1CDO
                 MOVE -1 TO ACCNOL
                 SET SEND-ERASE TO TRUE
                 PERFORM SEND-MAP

      *
      *       If a PA key is pressed, just carry on
      *
              WHEN EIBAID = DFHPA1 OR DFHPA2 OR DFHPA3
                 CONTINUE

      *
      *       When Pf3 is pressed, return to the main menu
      *
              WHEN EIBAID = DFHPF3
                 EXEC CICS RETURN
                    TRANSID('OMEN')
                    IMMEDIATE
                    RESP(WS-CICS-RESP)
                    RESP2(WS-CICS-RESP2)
                 END-EXEC

      *
      *       If the aid or Pf12 is pressed, then send a termination
      *       message.
      *
              WHEN EIBAID = DFHAID OR DFHPF12
                 PERFORM SEND-TERMINATION-MSG

                 EXEC CICS
                    RETURN
                 END-EXEC

      *
      *       When CLEAR is pressed
      *
              WHEN EIBAID = DFHCLEAR
                EXEC CICS SEND CONTROL
                          ERASE
                          FREEKB
                END-EXEC

                EXEC CICS RETURN
                END-EXEC

      *
      *       When enter is pressed then process the content
      *
              WHEN EIBAID = DFHENTER
                 PERFORM PROCESS-MAP

      *
      *       When anything else happens, send the invalid key message
      *
              WHEN OTHER
                 MOVE LOW-VALUES TO BNK1CDO
                 MOVE 'Invalid key pressed.' TO MESSAGEO
                 MOVE 8 TO ACCNOL
                 SET SEND-DATAONLY-ALARM TO TRUE
                 PERFORM SEND-MAP

           END-EVALUATE.

      *
      *    Provided that we have been around this way before
      *    (i.e. it is NOT the first time through, put the data
      *    returned from the sub program into the area that we use
      *    as the COMMAREA on the RETURN.
      *
           IF EIBCALEN NOT = ZERO

              MOVE COMM-ACCNO  TO WS-COMM-ACCNO
              MOVE COMM-SIGN   TO  WS-COMM-SIGN
              MOVE COMM-AMT    TO WS-COMM-AMT

           END-IF.

           EXEC CICS
              RETURN TRANSID('OCRA')
              COMMAREA(WS-COMM-AREA)
              LENGTH(21)
              RESP(WS-CICS-RESP)
              RESP2(WS-CICS-RESP2)
           END-EXEC.

           IF WS-CICS-RESP NOT = DFHRESP(NORMAL)
      *
      *       Preserve the RESP and RESP2, then set up the
      *       standard ABEND info before getting the applid,
      *       date/time etc. and linking to the Abend Handler
      *       program.
      *
              INITIALIZE ABNDINFO-REC
              MOVE EIBRESP    TO ABND-RESPCODE
              MOVE EIBRESP2   TO ABND-RESP2CODE
      *
      *       Get supplemental information
      *
              EXEC CICS ASSIGN APPLID(ABND-APPLID)
              END-EXEC

              MOVE EIBTASKN   TO ABND-TASKNO-KEY
              MOVE EIBTRNID   TO ABND-TRANID

              PERFORM POPULATE-TIME-DATE

              MOVE WS-ORIG-DATE TO ABND-DATE
              STRING WS-TIME-NOW-GRP-HH DELIMITED BY SIZE,
                    ':' DELIMITED BY SIZE,
                     WS-TIME-NOW-GRP-MM DELIMITED BY SIZE,
                     ':' DELIMITED BY SIZE,
                     WS-TIME-NOW-GRP-MM DELIMITED BY SIZE
                     INTO ABND-TIME
              END-STRING

              MOVE WS-U-TIME   TO ABND-UTIME-KEY
              MOVE 'HBNK'      TO ABND-CODE

              EXEC CICS ASSIGN PROGRAM(ABND-PROGRAM)
              END-EXEC

              MOVE ZEROS      TO ABND-SQLCODE

              STRING 'A010 - RETURN TRANSID(OCRA) FAIL.'
                    DELIMITED BY SIZE,
                    'EIBRESP=' DELIMITED BY SIZE,
                    ABND-RESPCODE DELIMITED BY SIZE,
                    ' RESP2=' DELIMITED BY SIZE,
                    ABND-RESP2CODE DELIMITED BY SIZE
                    INTO ABND-FREEFORM
              END-STRING

              EXEC CICS LINK PROGRAM(WS-ABEND-PGM)
                        COMMAREA(ABNDINFO-REC)
              END-EXEC

              INITIALIZE WS-FAIL-INFO
              MOVE 'BNK1CRA - A010 - RETURN TRANSID(OCRA) FAIL' TO
                 WS-CICS-FAIL-MSG
              MOVE WS-CICS-RESP  TO WS-CICS-RESP-DISP
              MOVE WS-CICS-RESP2 TO WS-CICS-RESP2-DISP
              PERFORM ABEND-THIS-TASK
           END-IF.

       A999.
           EXIT.


       PROCESS-MAP SECTION.
       PM010.
      *
      *    Retrieve the data from the map
      *
           PERFORM RECEIVE-MAP.

      *
      *    Validate the received data
      *
           PERFORM EDIT-DATA.

      *
      *    If the data passes validation go on to apply the debit or
      *    credit.
      *
           IF VALID-DATA
              PERFORM UPD-CRED-DATA
           END-IF.

           SET SEND-DATAONLY-ALARM TO TRUE.

      *
      *    Output the data to the screen
      *
           PERFORM SEND-MAP.

       PM999.
           EXIT.


       RECEIVE-MAP SECTION.
       RM010.
      *
      *    Retrieve the data
      *
           EXEC CICS
              RECEIVE MAP('BNK1CD')
              MAPSET('BNK1CDM')
              INTO(BNK1CDI)
              RESP(WS-CICS-RESP)
              RESP2(WS-CICS-RESP2)
           END-EXEC.

           IF WS-CICS-RESP NOT = DFHRESP(NORMAL)
      *
      *       Preserve the RESP and RESP2, then set up the
      *       standard ABEND info before getting the applid,
      *       date/time etc. and linking to the Abend Handler
      *       program.
      *
              INITIALIZE ABNDINFO-REC
              MOVE EIBRESP    TO ABND-RESPCODE
              MOVE EIBRESP2   TO ABND-RESP2CODE
      *
      *       Get supplemental information
      *
              EXEC CICS ASSIGN APPLID(ABND-APPLID)
              END-EXEC

              MOVE EIBTASKN   TO ABND-TASKNO-KEY
              MOVE EIBTRNID   TO ABND-TRANID

              PERFORM POPULATE-TIME-DATE

              MOVE WS-ORIG-DATE TO ABND-DATE
              STRING WS-TIME-NOW-GRP-HH DELIMITED BY SIZE,
                    ':' DELIMITED BY SIZE,
                     WS-TIME-NOW-GRP-MM DELIMITED BY SIZE,
                     ':' DELIMITED BY SIZE,
                     WS-TIME-NOW-GRP-MM DELIMITED BY SIZE
                     INTO ABND-TIME
              END-STRING

              MOVE WS-U-TIME   TO ABND-UTIME-KEY
              MOVE 'HBNK'      TO ABND-CODE

              EXEC CICS ASSIGN PROGRAM(ABND-PROGRAM)
              END-EXEC

              MOVE ZEROS      TO ABND-SQLCODE

              STRING 'RM010 - RECEIVE MAP FAIL.'
                    DELIMITED BY SIZE,
                    'EIBRESP=' DELIMITED BY SIZE,
                    ABND-RESPCODE DELIMITED BY SIZE,
                    ' RESP2=' DELIMITED BY SIZE,
                    ABND-RESP2CODE DELIMITED BY SIZE
                    INTO ABND-FREEFORM
              END-STRING

              EXEC CICS LINK PROGRAM(WS-ABEND-PGM)
                        COMMAREA(ABNDINFO-REC)
              END-EXEC

              INITIALIZE WS-FAIL-INFO
              MOVE 'BNKMENU - RM010 - RECEIVE MAP FAIL ' TO
                 WS-CICS-FAIL-MSG
              MOVE WS-CICS-RESP  TO WS-CICS-RESP-DISP
              MOVE WS-CICS-RESP2 TO WS-CICS-RESP2-DISP
              PERFORM ABEND-THIS-TASK
           END-IF.

       RM999.
           EXIT.


       EDIT-DATA SECTION.
       ED010.
      *
      *    Perform validation on the incoming fields
      *
           EXEC CICS BIF
              DEEDIT FIELD(ACCNOI)
           END-EXEC.

           IF ACCNOI NOT NUMERIC
              MOVE 'Please enter an account number.  ' TO
                 MESSAGEO
              MOVE 'N' TO VALID-DATA-SW
              GO TO ED999
           END-IF.

           IF ACCNOI = ZERO
              MOVE 'Please enter a non zero account number.   ' TO
                 MESSAGEO
              MOVE 'N' TO VALID-DATA-SW
              GO TO ED999
           END-IF.

           IF SIGNI NOT = '+' AND SIGNI NOT = '-' AND SIGNL = 1
              MOVE 'Please enter + or - preceeding the amount ' TO
                 MESSAGEO
              MOVE 'N' TO VALID-DATA-SW
              GO TO ED999
           END-IF.

      *
      *    Validate the Amount entered
      *
           PERFORM VALIDATE-AMOUNT.

       ED999.
           EXIT.


       UPD-CRED-DATA SECTION.
       UCD010.
      *
      *    Set up the COMMAREA fields required by DBCRFUN and then
      *    link to it.
      *
           INITIALIZE SUBPGM-PARMS.

           MOVE ACCNOI TO SUBPGM-ACCNO.
           MOVE 0 TO SUBPGM-AMT.

      *
      *    Provide the correct Amount
      *
           IF SIGNI = '-'
              COMPUTE WS-AMOUNT-AS-FLOAT = WS-AMOUNT-AS-FLOAT * -1
           END-IF.

           MOVE WS-AMOUNT-AS-FLOAT TO SUBPGM-AMT.

      *
      *    Get the ORIGIN data
      *
           EXEC CICS INQUIRE ASSOCIATION(EIBTASKN)
               ODAPPLID(SUBPGM-APPLID)
               ODUSERID(SUBPGM-USERID)
               ODFACILNAME(SUBPGM-FACILITY-NAME)
               ODNETWORKID(SUBPGM-NETWRK-ID)
               ODFACILTYPE(SUBPGM-FACILTYPE)
           END-EXEC.

           EXEC CICS LINK
              PROGRAM('DBCRFUN')
              COMMAREA(SUBPGM-PARMS)
              RESP(WS-CICS-RESP)
              RESP2(WS-CICS-RESP2)
              SYNCONRETURN
           END-EXEC.

           IF WS-CICS-RESP NOT = DFHRESP(NORMAL)
      *
      *       Preserve the RESP and RESP2, then set up the
      *       standard ABEND info before getting the applid,
      *       date/time etc. and linking to the Abend Handler
      *       program.
      *
              INITIALIZE ABNDINFO-REC
              MOVE EIBRESP    TO ABND-RESPCODE
              MOVE EIBRESP2   TO ABND-RESP2CODE
      *
      *       Get supplemental information
      *
              EXEC CICS ASSIGN APPLID(ABND-APPLID)
              END-EXEC

              MOVE EIBTASKN   TO ABND-TASKNO-KEY
              MOVE EIBTRNID   TO ABND-TRANID

              PERFORM POPULATE-TIME-DATE

              MOVE WS-ORIG-DATE TO ABND-DATE
              STRING WS-TIME-NOW-GRP-HH DELIMITED BY SIZE,
                    ':' DELIMITED BY SIZE,
                     WS-TIME-NOW-GRP-MM DELIMITED BY SIZE,
                     ':' DELIMITED BY SIZE,
                     WS-TIME-NOW-GRP-MM DELIMITED BY SIZE
                     INTO ABND-TIME
              END-STRING

              MOVE WS-U-TIME   TO ABND-UTIME-KEY
              MOVE 'HBNK'      TO ABND-CODE

              EXEC CICS ASSIGN PROGRAM(ABND-PROGRAM)
              END-EXEC

              MOVE ZEROS      TO ABND-SQLCODE

              STRING 'UCD010 - LINK DBCRFUN FAIL.'
                    DELIMITED BY SIZE,
                    'EIBRESP=' DELIMITED BY SIZE,
                    ABND-RESPCODE DELIMITED BY SIZE,
                    ' RESP2=' DELIMITED BY SIZE,
                    ABND-RESP2CODE DELIMITED BY SIZE
                    INTO ABND-FREEFORM
              END-STRING

              EXEC CICS LINK PROGRAM(WS-ABEND-PGM)
                        COMMAREA(ABNDINFO-REC)
              END-EXEC

              INITIALIZE WS-FAIL-INFO
              MOVE 'BNK1CRA - UCD010 - LINK DBCRFUN  FAIL      '
                 TO WS-CICS-FAIL-MSG
              MOVE WS-CICS-RESP  TO WS-CICS-RESP-DISP
              MOVE WS-CICS-RESP2 TO WS-CICS-RESP2-DISP
              PERFORM ABEND-THIS-TASK
           END-IF.

      *
      *    Check to see if the debit or credit was successful
      *
           IF SUBPGM-SUCCESS = 'N'

              MOVE 'N' TO VALID-DATA-SW

              EVALUATE SUBPGM-FAIL-CODE
                 WHEN '1'
                    MOVE SPACES TO MESSAGEO
                    STRING 'Sorry but the ACCOUNT no was not found'
                           ' for SORTCODE '
                           SUBPGM-SORTC
                           ' . Amount not applied. '
                           DELIMITED BY SIZE
                           INTO MESSAGEO
                    GO TO UCD999

                 WHEN '2'
                    MOVE SPACES TO MESSAGEO
                    STRING 'Sorry but the AMOUNT could not be applied'
                           ' due to an unexpected error.'
                           DELIMITED BY SIZE
                           INTO MESSAGEO
                    GO TO UCD999

                 WHEN '3'
                    MOVE SPACES TO MESSAGEO
                    STRING 'Sorry insufficient funds available to pro'
                           'cess the request.           '
                           DELIMITED BY SIZE
                           INTO MESSAGEO
                    GO TO UCD999

                 WHEN OTHER
                    MOVE SPACES TO MESSAGEO
                    STRING 'Sorry but the AMOUNT could not be applied'
                           ' due to an unexpected error. '
                           SUBPGM-FAIL-CODE
                           DELIMITED BY SIZE
                           INTO MESSAGEO
                    GO TO UCD999
              END-EVALUATE

           ELSE
              MOVE SPACES TO MESSAGEO
              MOVE 'Amount successfully applied to the account.' TO
                 MESSAGEO
           END-IF.

      *
      *    Set up the values on the map
      *
           MOVE SUBPGM-ACCNO       TO ACCNOO.
           MOVE SUBPGM-SORTC       TO SORTCO.

           MOVE SUBPGM-ACT-BAL    TO ACTUAL-BALANCE-DISPLAY.
           MOVE SUBPGM-AV-BAL     TO AVAILABLE-BALANCE-DISPLAY.
           MOVE ACTUAL-BALANCE-DISPLAY      TO ACTBALO.
           MOVE AVAILABLE-BALANCE-DISPLAY   TO AVBALO.

       UCD999.
           EXIT.


       SEND-MAP SECTION.
       SM010.
      *
      *    If the map needs to have its data erased
      *
           IF SEND-ERASE
              EXEC CICS SEND MAP('BNK1CD')
                 MAPSET('BNK1CDM')
                 FROM(BNK1CDO)
                 ERASE
                 RESP(WS-CICS-RESP)
                 RESP2(WS-CICS-RESP2)
              END-EXEC

              IF WS-CICS-RESP NOT = DFHRESP(NORMAL)
      *
      *          Preserve the RESP and RESP2, then set up the
      *          standard ABEND info before getting the applid,
      *          date/time etc. and linking to the Abend Handler
      *          program.
      *
                 INITIALIZE ABNDINFO-REC
                 MOVE EIBRESP    TO ABND-RESPCODE
                 MOVE EIBRESP2   TO ABND-RESP2CODE
      *
      *          Get supplemental information
      *
                 EXEC CICS ASSIGN APPLID(ABND-APPLID)
                 END-EXEC

                 MOVE EIBTASKN   TO ABND-TASKNO-KEY
                 MOVE EIBTRNID   TO ABND-TRANID

                 PERFORM POPULATE-TIME-DATE

                 MOVE WS-ORIG-DATE TO ABND-DATE
                 STRING WS-TIME-NOW-GRP-HH DELIMITED BY SIZE,
                       ':' DELIMITED BY SIZE,
                        WS-TIME-NOW-GRP-MM DELIMITED BY SIZE,
                        ':' DELIMITED BY SIZE,
                        WS-TIME-NOW-GRP-MM DELIMITED BY SIZE
                        INTO ABND-TIME
                 END-STRING

                 MOVE WS-U-TIME   TO ABND-UTIME-KEY
                 MOVE 'HBNK'      TO ABND-CODE

                 EXEC CICS ASSIGN PROGRAM(ABND-PROGRAM)
                 END-EXEC

                 MOVE ZEROS      TO ABND-SQLCODE

                 STRING 'SM010 - SEND MAP ERASE FAIL.'
                       DELIMITED BY SIZE,
                       'EIBRESP=' DELIMITED BY SIZE,
                       ABND-RESPCODE DELIMITED BY SIZE,
                       ' RESP2=' DELIMITED BY SIZE,
                       ABND-RESP2CODE DELIMITED BY SIZE
                       INTO ABND-FREEFORM
                 END-STRING

                 EXEC CICS LINK PROGRAM(WS-ABEND-PGM)
                           COMMAREA(ABNDINFO-REC)
                 END-EXEC

                 INITIALIZE WS-FAIL-INFO
                 MOVE 'BNK1CRA - SM010 - SEND MAP ERASE FAIL '
                    TO WS-CICS-FAIL-MSG
                 MOVE WS-CICS-RESP  TO WS-CICS-RESP-DISP
                 MOVE WS-CICS-RESP2 TO WS-CICS-RESP2-DISP
                 PERFORM ABEND-THIS-TASK
              END-IF

              GO TO SM999
           END-IF.

      *
      *    If the map just needs a resend of only the data
      *
           IF SEND-DATAONLY
              EXEC CICS SEND MAP('BNK1CD')
                 MAPSET('BNK1CDM')
                 FROM(BNK1CDO)
                 DATAONLY
                 RESP(WS-CICS-RESP)
                 RESP2(WS-CICS-RESP2)
              END-EXEC

              IF WS-CICS-RESP NOT = DFHRESP(NORMAL)
      *
      *          Preserve the RESP and RESP2, then set up the
      *          standard ABEND info before getting the applid,
      *          date/time etc. and linking to the Abend Handler
      *          program.
      *
                 INITIALIZE ABNDINFO-REC
                 MOVE EIBRESP    TO ABND-RESPCODE
                 MOVE EIBRESP2   TO ABND-RESP2CODE
      *
      *          Get supplemental information
      *
                 EXEC CICS ASSIGN APPLID(ABND-APPLID)
                 END-EXEC

                 MOVE EIBTASKN   TO ABND-TASKNO-KEY
                 MOVE EIBTRNID   TO ABND-TRANID

                 PERFORM POPULATE-TIME-DATE

                 MOVE WS-ORIG-DATE TO ABND-DATE
                 STRING WS-TIME-NOW-GRP-HH DELIMITED BY SIZE,
                       ':' DELIMITED BY SIZE,
                        WS-TIME-NOW-GRP-MM DELIMITED BY SIZE,
                        ':' DELIMITED BY SIZE,
                        WS-TIME-NOW-GRP-MM DELIMITED BY SIZE
                        INTO ABND-TIME
                 END-STRING

                 MOVE WS-U-TIME   TO ABND-UTIME-KEY
                 MOVE 'HBNK'      TO ABND-CODE

                 EXEC CICS ASSIGN PROGRAM(ABND-PROGRAM)
                 END-EXEC

                 MOVE ZEROS      TO ABND-SQLCODE

                 STRING 'SM010 - SEND MAP DATAONLY FAIL.'
                       DELIMITED BY SIZE,
                       'EIBRESP=' DELIMITED BY SIZE,
                       ABND-RESPCODE DELIMITED BY SIZE,
                       ' RESP2=' DELIMITED BY SIZE,
                       ABND-RESP2CODE DELIMITED BY SIZE
                       INTO ABND-FREEFORM
                 END-STRING

                 EXEC CICS LINK PROGRAM(WS-ABEND-PGM)
                           COMMAREA(ABNDINFO-REC)
                 END-EXEC

                 INITIALIZE WS-FAIL-INFO
                 MOVE 'BNK1CRA - SM010 - SEND MAP DATAONLY FAIL '
                    TO WS-CICS-FAIL-MSG
                 MOVE WS-CICS-RESP  TO WS-CICS-RESP-DISP
                 MOVE WS-CICS-RESP2 TO WS-CICS-RESP2-DISP
                 PERFORM ABEND-THIS-TASK
              END-IF

              GO TO SM999
           END-IF.

      *
      *    If we have elected to send the map and a beep
      *
           IF SEND-DATAONLY-ALARM
              EXEC CICS SEND MAP('BNK1CD')
                 MAPSET('BNK1CDM')
                 FROM(BNK1CDO)
                 DATAONLY
                 ALARM
                 RESP(WS-CICS-RESP)
                 RESP2(WS-CICS-RESP2)
              END-EXEC

              IF WS-CICS-RESP NOT = DFHRESP(NORMAL)
      *
      *          Preserve the RESP and RESP2, then set up the
      *          standard ABEND info before getting the applid,
      *          date/time etc. and linking to the Abend Handler
      *          program.
      *
                 INITIALIZE ABNDINFO-REC
                 MOVE EIBRESP    TO ABND-RESPCODE
                 MOVE EIBRESP2   TO ABND-RESP2CODE
      *
      *          Get supplemental information
      *
                 EXEC CICS ASSIGN APPLID(ABND-APPLID)
                 END-EXEC

                 MOVE EIBTASKN   TO ABND-TASKNO-KEY
                 MOVE EIBTRNID   TO ABND-TRANID

                 PERFORM POPULATE-TIME-DATE

                 MOVE WS-ORIG-DATE TO ABND-DATE
                 STRING WS-TIME-NOW-GRP-HH DELIMITED BY SIZE,
                       ':' DELIMITED BY SIZE,
                        WS-TIME-NOW-GRP-MM DELIMITED BY SIZE,
                        ':' DELIMITED BY SIZE,
                        WS-TIME-NOW-GRP-MM DELIMITED BY SIZE
                        INTO ABND-TIME
                 END-STRING

                 MOVE WS-U-TIME   TO ABND-UTIME-KEY
                 MOVE 'HBNK'      TO ABND-CODE

                 EXEC CICS ASSIGN PROGRAM(ABND-PROGRAM)
                 END-EXEC

                 MOVE ZEROS      TO ABND-SQLCODE

                 STRING 'SM010 - SEND MAP DATAONLY ALARM FAIL.'
                       DELIMITED BY SIZE,
                       'EIBRESP=' DELIMITED BY SIZE,
                       ABND-RESPCODE DELIMITED BY SIZE,
                       ' RESP2=' DELIMITED BY SIZE,
                       ABND-RESP2CODE DELIMITED BY SIZE
                       INTO ABND-FREEFORM
                 END-STRING

                 EXEC CICS LINK PROGRAM(WS-ABEND-PGM)
                           COMMAREA(ABNDINFO-REC)
                 END-EXEC

                 INITIALIZE WS-FAIL-INFO
                 MOVE 'BNK1CRA - SM010 - SEND MAP DATAONLY ALARM FAIL '
                    TO WS-CICS-FAIL-MSG
                 MOVE WS-CICS-RESP  TO WS-CICS-RESP-DISP
                 MOVE WS-CICS-RESP2 TO WS-CICS-RESP2-DISP
                 PERFORM ABEND-THIS-TASK
              END-IF

           END-IF.

       SM999.
           EXIT.


       SEND-TERMINATION-MSG SECTION.
       STM010.
      *
      *    Send the termination message
      *
           EXEC CICS SEND TEXT
              FROM(END-OF-SESSION-MESSAGE)
              ERASE
              FREEKB
              RESP(WS-CICS-RESP)
              RESP2(WS-CICS-RESP2)
           END-EXEC.

           IF WS-CICS-RESP NOT = DFHRESP(NORMAL)
      *
      *       Preserve the RESP and RESP2, then set up the
      *       standard ABEND info before getting the applid,
      *       date/time etc. and linking to the Abend Handler
      *       program.
      *
              INITIALIZE ABNDINFO-REC
              MOVE EIBRESP    TO ABND-RESPCODE
              MOVE EIBRESP2   TO ABND-RESP2CODE
      *
      *       Get supplemental information
      *
              EXEC CICS ASSIGN APPLID(ABND-APPLID)
              END-EXEC

              MOVE EIBTASKN   TO ABND-TASKNO-KEY
              MOVE EIBTRNID   TO ABND-TRANID

              PERFORM POPULATE-TIME-DATE

              MOVE WS-ORIG-DATE TO ABND-DATE
              STRING WS-TIME-NOW-GRP-HH DELIMITED BY SIZE,
                    ':' DELIMITED BY SIZE,
                     WS-TIME-NOW-GRP-MM DELIMITED BY SIZE,
                     ':' DELIMITED BY SIZE,
                     WS-TIME-NOW-GRP-MM DELIMITED BY SIZE
                     INTO ABND-TIME
              END-STRING

              MOVE WS-U-TIME   TO ABND-UTIME-KEY
              MOVE 'HBNK'      TO ABND-CODE

              EXEC CICS ASSIGN PROGRAM(ABND-PROGRAM)
              END-EXEC

              MOVE ZEROS      TO ABND-SQLCODE

              STRING 'STM010 - SEND TEXT FAIL.'
                    DELIMITED BY SIZE,
                    'EIBRESP=' DELIMITED BY SIZE,
                    ABND-RESPCODE DELIMITED BY SIZE,
                    ' RESP2=' DELIMITED BY SIZE,
                    ABND-RESP2CODE DELIMITED BY SIZE
                    INTO ABND-FREEFORM
              END-STRING

              EXEC CICS LINK PROGRAM(WS-ABEND-PGM)
                        COMMAREA(ABNDINFO-REC)
              END-EXEC

              INITIALIZE WS-FAIL-INFO
              MOVE 'BNK1CRA - STM010 - SEND TEXT FAIL'
                 TO WS-CICS-FAIL-MSG
              MOVE WS-CICS-RESP  TO WS-CICS-RESP-DISP
              MOVE WS-CICS-RESP2 TO WS-CICS-RESP2-DISP
              PERFORM ABEND-THIS-TASK
           END-IF.

       STM999.
           EXIT.


       ABEND-THIS-TASK SECTION.
       ATT010.
           DISPLAY WS-FAIL-INFO.
           EXEC CICS ABEND
              ABCODE('HBNK')
              NODUMP
           END-EXEC.

       ATT999.
           EXIT.


       VALIDATE-AMOUNT SECTION.
       VA010.

           MOVE 0 TO WS-AMOUNT-AS-FLOAT.

           IF AMTL = ZERO
              MOVE 'The Amount entered must be numeric.' TO
                 MESSAGEO
              MOVE 'N' TO VALID-DATA-SW
              MOVE -1 TO AMTL
              GO TO VA999
           END-IF.


           IF AMTI(1:AMTL) IS NUMERIC
              COMPUTE WS-AMOUNT-AS-FLOAT =
                 FUNCTION NUMVAL(AMTI(1:AMTL))

              MOVE 'Y' TO VALID-DATA-SW
              GO TO VA999
           END-IF.

           MOVE ZERO TO WS-NUM-COUNT-TOTAL.
           INSPECT AMTI(1:AMTL) TALLYING WS-NUM-COUNT-TOTAL
              FOR LEADING SPACES.

      *
      *    It is entirely spaces
      *
           IF WS-NUM-COUNT-TOTAL = AMTL
              MOVE 'The Amount entered must be numeric.' TO
                 MESSAGEO
              MOVE 'N' TO VALID-DATA-SW
              MOVE -1 TO AMTL
              GO TO VA999
           END-IF.

           COMPUTE WS-AMOUNT-UNSTR-L = AMTL - WS-NUM-COUNT-TOTAL.

           IF WS-NUM-COUNT-TOTAL = ZERO
              MOVE SPACES TO WS-AMOUNT-UNSTR
              UNSTRING AMTI(1:AMTL)
                 INTO WS-AMOUNT-UNSTR
           ELSE
              MOVE SPACES TO WS-AMOUNT-UNSTR
              ADD 1 TO WS-NUM-COUNT-TOTAL GIVING WS-NUM-COUNT-TOTAL
              UNSTRING AMTI(WS-NUM-COUNT-TOTAL:AMTL)
                 INTO WS-AMOUNT-UNSTR
           END-IF.

           MOVE ZERO TO WS-NUM-COUNT-TOTAL.

           MOVE FUNCTION REVERSE(WS-AMOUNT-UNSTR(1:WS-AMOUNT-UNSTR-L))
              TO WS-AMOUNT-UNSTR-REVERSE

           INSPECT WS-AMOUNT-UNSTR-REVERSE
              TALLYING WS-NUM-COUNT-TOTAL
              FOR LEADING SPACES.

           SUBTRACT WS-NUM-COUNT-TOTAL FROM WS-AMOUNT-UNSTR-L
              GIVING WS-AMOUNT-UNSTR-L.

           MOVE ZERO TO WS-NUM-COUNT-TOTAL WS-NUM-COUNT-SPACE.
           INSPECT WS-AMOUNT-UNSTR(1:WS-AMOUNT-UNSTR-L)
              TALLYING
              WS-NUM-COUNT-TOTAL FOR ALL '0'
              WS-NUM-COUNT-TOTAL FOR ALL '1'
              WS-NUM-COUNT-TOTAL FOR ALL '2'
              WS-NUM-COUNT-TOTAL FOR ALL '3'
              WS-NUM-COUNT-TOTAL FOR ALL '4'
              WS-NUM-COUNT-TOTAL FOR ALL '5'
              WS-NUM-COUNT-TOTAL FOR ALL '6'
              WS-NUM-COUNT-TOTAL FOR ALL '7'
              WS-NUM-COUNT-TOTAL FOR ALL '8'
              WS-NUM-COUNT-TOTAL FOR ALL '9'
              WS-NUM-COUNT-TOTAL FOR ALL '.'
              WS-NUM-COUNT-SPACE FOR ALL ' '.

      *
      *       If there is a decimal point, the field is not numeric.
      *       But if it is 1.1 then it is valid. So first of all
      *       we check to see that only the above chars are
      *       valid.
      *       We DO NOT tolerate embedded spaces too
      *
           IF WS-NUM-COUNT-SPACE > 0
              MOVE SPACES TO MESSAGEO
              STRING
                 'Please supply a numeric amount without embedded'
                  DELIMITED BY SIZE,
                  ' spaces.' DELIMITED BY SPACES
              INTO MESSAGEO
              MOVE 'N' TO VALID-DATA-SW
              MOVE -1 TO AMTL
              GO TO VA999
           END-IF.

           IF WS-NUM-COUNT-TOTAL < WS-AMOUNT-UNSTR-L
              MOVE SPACES TO MESSAGEO
              STRING 'Please supply a numeric amount.'
                 DELIMITED BY SIZE,
                 INTO MESSAGEO
              MOVE 'N' TO VALID-DATA-SW
              MOVE -1 TO AMTL
              GO TO VA999
           END-IF.

      *
      *    Check that we have no or just one decimal point
      *
           MOVE ZERO TO WS-NUM-COUNT-POINT
           INSPECT WS-AMOUNT-UNSTR(1:WS-AMOUNT-UNSTR-L)
             TALLYING
             WS-NUM-COUNT-POINT FOR ALL '.'.

           IF WS-NUM-COUNT-POINT > 1
              MOVE SPACES TO MESSAGEO
              STRING 'Use one decimal point for amount only.'
                 DELIMITED BY SIZE,
              INTO MESSAGEO

              MOVE 'N' TO VALID-DATA-SW
              MOVE -1 TO AMTL
              GO TO VA999
           END-IF.

      *
      *    Have we got too many decimals?
      *
           IF WS-NUM-COUNT-POINT = 1
              MOVE ZERO TO WS-NUM-COUNT-TOTAL
              INSPECT WS-AMOUNT-UNSTR(1:WS-AMOUNT-UNSTR-L)
                 TALLYING WS-NUM-COUNT-TOTAL FOR CHARACTERS AFTER '.'

              IF WS-NUM-COUNT-TOTAL > 2
                 MOVE ZERO TO WS-NUM-COUNT-TOTAL WS-NUM-COUNT-POINT
                 INSPECT WS-AMOUNT-UNSTR(1:WS-AMOUNT-UNSTR-L)
                 TALLYING
                    WS-NUM-COUNT-POINT FOR CHARACTERS BEFORE '.'
                 ADD 2 TO WS-NUM-COUNT-POINT GIVING WS-NUM-COUNT-POINT

                 INSPECT
                 WS-AMOUNT-UNSTR(WS-NUM-COUNT-POINT:WS-AMOUNT-UNSTR-L)
                    TALLYING WS-NUM-COUNT-TOTAL FOR ALL '0'
                    WS-NUM-COUNT-TOTAL FOR ALL '1'
                    WS-NUM-COUNT-TOTAL FOR ALL '2'
                    WS-NUM-COUNT-TOTAL FOR ALL '3'
                    WS-NUM-COUNT-TOTAL FOR ALL '4'
                    WS-NUM-COUNT-TOTAL FOR ALL '5'
                    WS-NUM-COUNT-TOTAL FOR ALL '6'
                    WS-NUM-COUNT-TOTAL FOR ALL '7'
                    WS-NUM-COUNT-TOTAL FOR ALL '8'
                    WS-NUM-COUNT-TOTAL FOR ALL '9'
                    AFTER '.'

                 IF WS-NUM-COUNT-TOTAL > 2
      *
      *             There are two numerics
      *
                    MOVE SPACES TO MESSAGEO
                    STRING
                       'Only up to two decimal places are supported.'
                       DELIMITED BY SIZE,
                    INTO MESSAGEO
                    MOVE 'N' TO VALID-DATA-SW
                    MOVE -1 TO AMTL
                    GO TO VA999
                 END-IF
              END-IF
           END-IF.

           COMPUTE WS-AMOUNT-AS-FLOAT =
              FUNCTION NUMVAL(WS-AMOUNT-UNSTR(1:WS-AMOUNT-UNSTR-L)).

           IF WS-AMOUNT-AS-FLOAT = ZERO
              MOVE SPACES TO MESSAGEO
              STRING
                 'Please supply a non-zero amount.'
                 DELIMITED BY SIZE,
              INTO MESSAGEO
              MOVE 'N' TO VALID-DATA-SW
              MOVE -1 TO AMTL
              GO TO VA999
           END-IF.

           MOVE SPACES TO MESSAGEO.
           MOVE 'Y' TO VALID-DATA-SW.

       VA999.
           EXIT.


       POPULATE-TIME-DATE SECTION.
       PTD010.

           EXEC CICS ASKTIME
              ABSTIME(WS-U-TIME)
           END-EXEC.

           EXEC CICS FORMATTIME
                     ABSTIME(WS-U-TIME)
                     DDMMYYYY(WS-ORIG-DATE)
                     TIME(WS-TIME-NOW)
                     DATESEP
           END-EXEC.

       PTD999.
           EXIT.

