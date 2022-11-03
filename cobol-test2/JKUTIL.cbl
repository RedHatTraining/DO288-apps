      *****************************************************************         
      * Licensed Materials - Property of IBM                          *         
      *                                                               *         
      * JKUTIL.cbl                                                  *          
      *                                                               *         
      * ? Copyright IBM Corporation 2008                              *         
      * U.S. Government Users Restricted Rights:  Use, duplication    *         
      * or disclosure                                                 *         
      *                                                               *         
      *                                                               *         
      *****************************************************************         
       ID DIVISION.                                                             
       PROGRAM-ID. JKUTIL.                                                     
      *                                                          
       ENVIRONMENT DIVISION.                                                    
       CONFIGURATION SECTION.                                                   
       SOURCE-COMPUTER. IBM-SERIES.                                             
       OBJECT-COMPUTER. IBM-SERIES.                                             
       DATA DIVISION.                                                           
       WORKING-STORAGE SECTION.                                                 
      *                                                                         
       01 WS-OPEN-TABLE.                                                       
           88 WS-LEC-TABLE    PIC X Value 'N'. 
           88 WS-FIN-TABLE    PIC X Value 'Y'. 		   
      *                                          
       01  WS-HOST-VARIABLE.
	       05 WS-ID              PIC 9(006).
           05 WS-NOM             PIC X(100).
		   05 WS-PRENOM          PIC X(100).
		   05 WS-EMAIL           PIC X(255).
		   05 WS-DATE-NAISSANCE  PIC X(010).
		      10 WS-SIECLE       PIC X(004).
			  10 FILLER          PIC X(001) VALUE '-'.
			  10 WS-MOIS         PIC X(002).
			  10 FILLER          PIC X(001) VALUE '-'.
			  10 WS-JOUR         PIC X(002).
		   05 WS-PAYS            PIC X(255).
		   05 WS-VILLE           PIC X(255).
		   05 WS-CODE-POSTAL     PIC X(005).
		   05 WS-NOMBRE-ACHAT    PIC X(006).
		   05 WS-SEXE            PIC X(001).
		   05 WS-CLUB            PIC X(050).
      *  normalement le sqlca est generé par le système pas besoin de l'écrire		
	   01 SQLCA.
	      05 SQLCAID     PIC X(8).
		  05 SQLCABC     PIC S9(9) COMP.
		  05 SQLCODE     PIC S9(9) COMP.
		  05 SQLERRM.
		     49 SQLERRML PIC S9(4) COMP.
			 49 SQLERRMC PIC X(70).
		  05 SQLERRP     PIC X(8).
          05 SQLERRD  OCCURS 6 TIMES PIC S9(9) COMP.
          05 SQLWARN.
             10 SQLWARN0 PIC X.		
             10 SQLWARN1 PIC X.
             10 SQLWARN2 PIC X.
             10 SQLWARN3 PIC X.
             10 SQLWARN4 PIC X.
             10 SQLWARN5 PIC X.
             10 SQLWARN6 PIC X.
             10 SQLWARN7 PIC X.
             10 SQLWARN8 PIC X.
             10 SQLWARN9 PIC X.	
             10 SQLWARNA PIC X.	
		  05 SQLERRP     PIC X(5).		  
			 
           EXEC SQL 
		        INCLUDE SQLCA 
	       END-EXEC.	
      *
           EXEC SQL 
		        INCLUDE DB_UTILISATEUR 
				    (
					 ID DECIMAL(006) NOT NULL,
                     NOM VARCHAR(100) NOT NULL,
                     PRENOM VARCHAR(100) NOT NULL,
                     EMAIL VARCHAR(255) NOT NULL,
                     DATE_NAISSANCE DATE NOT NULL,
                     PAYS VARCHAR(255) NOT NULL,
                     VILLE VARCHAR(255) NOT NULL,
                     CODE_POSTAL VARCHAR(005) NOT NULL,
                     NOMBRE_ACHAT CHAR(006) NOT NULL,
	                 SEXE CHAR(001) NOT NULL BY DEFAULT,
	                 CLUB CHAR(050) NOT NULL BY DEFAULT
					)
	       END-EXEC.		
      *
           EXEC SQL
                DECLARE CRS1 CURSOR FOR 
                SELECT ID,
				       NOM,
                       PRENOM,
					   EMAIL,
					   DATE_NAISSANCE,
					   PAYS,
					   VILLE,
					   CODE_POSTAL,
					   NOMBRE_ACHAT,
					   SEXE,
					   CLUB
				FROM DB_UTILISATEUR
		   END-EXEC.   
      *                                                                         
      ******** DEBUT PROGRAMME
      *	  
       PROCEDURE DIVISION. 	   
      *                                                                         
           PERFORM A000-INITIALISATION.
		   PERFORM A010-READ-TABLE UNTIL WS-OPEN-TABLE = 'Y'.           
           PERFORM Z999-END-PROGRAM.                                            
      *                                                                         
       A000-INITIALISATION.                                                    
           INITIALIZE WS-HOST-VARIABLE
            REPLACING ALPHANUMERIC DATA BY SPACES
                      NUMERIC BY ZEROES.
           MOVE 'N' TO WS-OPEN-TABLE.					  
           PERFORM B000-OPEN-CURSOR.
           PERFORM B010-READ-CURSOR. 		    
      *
       A010-READ-TABLE.
	       PERFORM B010-READ-CURSOR. 
		   PERFORM A020-ACTIONS-MAJ-PGM.
      *
       A020-ACTIONS-MAJ-PGM.	  
		   IF WS-PAYS NOT = 'FRANCE'
		      MOVE 'AAAAA' TO WS-CODE-POSTAL
              PERFORM B030-UPDATE-TABLE		
           ELSE
              DISPLAY 'NOM : ' WS-NOM
              DISPLAY 'PRENOM : ' WS-PRENOM
		   .
      *
	   B000-OPEN-CURSOR.
	       EXEC SQL 
		        OPEN CRS1
		   END-EXEC.
      *
       B010-READ-CURSOR.
	       EXEC SQL
		        FETCH CRS1
				INTO   :WS-ID,
				       :WS-NOM,
                       :WS-PRENOM,
					   :WS-EMAIL,
					   :WS-DATE-NAISSANCE,
					   :WS-PAYS,
					   :WS-VILLE,
					   :WS-CODE-POSTAL,
					   :WS-NOMBRE-ACHAT,
					   :WS-SEXE,
					   :WS-CLUB
		   END-EXEC
		   IF SQLCODE NOT = 100 AND ZEROES
		      DISPLAY 'ERROR PROGRAMME LECTURE TABLE DB_UTILISATEUR'
			  PERFORM Z999-END-PROGRAM
		   ELSE
		      IF SQLCODE = 100
                 SET WS-FIN-TABLE TO TRUE
			  END-IF
           END-IF
		   .
      *
	   B020-CLOSE-CURSOR.
	       EXEC SQL
			    CLOSE CRS1
		   END-EXEC	 
	       .
      *
	   B030-UPDATE-TABLE.
           EXEC SQL	   
	            UPDATE DB_UTILISATEUR
			       SET CODE_POSTAL = :WS-CODE-POSTAL
		   END-EXEC
           .	
      *		   
	   Z999-END-PROGRAM.
	       PERFORM B020-CLOSE-CURSOR.
           STOP RUN	   
           .
      *                                                                         
      ******** FIN PROGRAMME
      *	                                                                        
