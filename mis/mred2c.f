      SUBROUTINE MRED2C (KODE)        
C        
C     THIS SUBROUTINE PROCESSES THE OLDMODES OPTION FLAG FOR THE MRED2  
C     MODULE.        
C        
C     INPUT DATA        
C     GINO - LAMAMR   - EIGENVALUE TABLE  FOR SUBSTRUCTURE BEING REDUCED
C            PHISS    - EIGENVCTOR MATRIX FOR SUBSTRUCTURE BEING REDUCED
C     SOF  - LAMS     - EIGENVALUE  TABLE FOR ORIGINAL SUBSTRUCTURE     
C            PHIS     - EIGENVCTOR  TABLE FOR ORIGINAL SUBSTRUCTURE     
C        
C     OUTPUT DATA        
C     GINO - LAMAMR   - EIGENVALUE TABLE  FOR SUBSTRUCTURE BEING REDUCED
C            PHISS    - EIGENVCTOR MATRIX FOR SUBSTRUCTURE BEING REDUCED
C     SOF  - LAMS     - EIGENVALUE TABLE  FOR ORIGINAL SUBSTRUCTURE     
C            PHIS     - EIGENVCTOR MATRIX FOR ORIGINAL SUBSTRUCTURE     
C        
C     PARAMETERS        
C     INPUT  - GBUF   - GINO BUFFER        
C              INFILE - INPUT FILE NUMBERS        
C              ISCR   - SCRATCH FILE NUMBERS        
C              KORBGN - BEGINNING ADDRESS OF OPEN CORE        
C              OLDNAM - NAME OF SUBSTRUCTURE BEING REDUCED        
C              MODES  - OLDMODES OPTION FLAG        
C              LAMAAP - BEGINNING ADDRESS OF LAMS RECORD TO BE APPENDED 
C              NFOUND - NUMBER OF MODAL POINTS USED        
C              MODLEN - LENGTH OF MODE USE ARRAY        
C     OTHERS - LAMAMR - LAMAMR INPUT FILE NUMBER        
C              PHIS   - PHIS INPUT FILE NUMBER        
C              LAMS   - LAMS INPUT FILE NUMBER        
C              PHISS  - PHISS INPUT FILE NUMBER        
C        
      LOGICAL         MODES        
      INTEGER         DRY,GBUF1,OLDNAM,Z,PHIS,PHISS,RGDFMT        
      DIMENSION       MODNAM(2),ITMLST(2)        
      COMMON /BLANK / IDUM1,DRY,IDUM7,GBUF1,IDUM2(5),INFILE(12),        
     1                IDUM3(6),ISCR(10),KORLEN,KORBGN,OLDNAM(2),        
     2                IDUM5(9),MODES,IDUM6,LAMAAP,NFOUND,MODLEN        
CZZ   COMMON /ZZMRD2/ Z(1)        
      COMMON /ZZZZZZ/ Z(1)        
      COMMON /SYSTEM/ IDUM4,IPRNTR        
      EQUIVALENCE     (LAMAMR,INFILE(2)),(PHIS,INFILE(3)),        
     1                (LAMS,ISCR(5)),(PHISS,ISCR(6))        
      DATA    MODNAM/ 4HMRED,4H2C  /        
      DATA    ITMLST/ 4HPHIS,4HLAMS/        
      DATA    RGDFMT/ 3 /        
C        
C     TEST OPERATION FLAG        
C        
      IF (DRY .EQ. -2) GO TO 200        
      IF (KODE .GT. 1) GO TO 20        
C        
C     TEST OLDMODES OPTION FLAG        
C        
      IF (MODES) GO TO 10        
C        
C     STORE GINO PHIS AS PHIS ON SOF        
C        
      IFILE = PHIS        
      CALL MTRXO (PHIS,OLDNAM,ITMLST(1),0,ITEST)        
      ITEM  = ITMLST(1)        
      IF (ITEST .NE. 3) GO TO 120        
      GO TO 200        
C        
C     READ SOF PHIS ONTO GINO PHIS SCRATCH FILE        
C        
   10 CALL MTRXI (PHISS,OLDNAM,ITMLST(1),0,ITEST)        
      ITEM = ITMLST(1)        
      IF (ITEST .NE. 1) GO TO 120        
C        
C     READ SOF LAMS ONTO GINO LAMAMR SCRATCH FILE        
C        
      CALL SFETCH (OLDNAM,ITMLST(2),1,ITEST)        
      ITEM = ITMLST(2)        
      IF (ITEST .GT. 1) GO TO 120        
      CALL GOPEN  (LAMS,Z(GBUF1),1)        
      CALL SUREAD (Z(KORBGN),-1,NWDSRD,ITEST)        
      CALL WRITE  (LAMS,Z(KORBGN),NWDSRD,1)        
      CALL SUREAD (Z(KORBGN),-1,NWDSRD,ITEST)        
      CALL WRITE  (LAMS,Z(KORBGN),NWDSRD,1)        
      CALL CLOSE  (LAMS,1)        
C        
C     SWITCH FILE NUMBERS        
C        
      PHIS   = PHISS        
      LAMAMR = LAMS        
      GO TO 200        
C        
C     STORE LAMAMR (TABLE) AS LAMS ON SOF        
C        
   20 IF (MODES) GO TO 70        
      ITEM = ITMLST(2)        
      CALL DELETE (OLDNAM,ITEM,ITEST)        
      IF (ITEST.EQ.2 .OR. ITEST.GT.3) GO TO 120        
      IFILE = LAMAMR        
      CALL GOPEN (LAMAMR,Z(GBUF1),0)        
      CALL FWDREC (*100,LAMAMR)        
      ITEST = 3        
      CALL SFETCH (OLDNAM,ITMLST(2),2,ITEST)        
      IF (ITEST .NE. 3) GO TO 120        
      DO 30 I = 1,2        
   30 Z(KORBGN+I-1) = OLDNAM(I)        
      Z(KORBGN+2  ) = RGDFMT        
      Z(KORBGN+3  ) = MODLEN        
      CALL SUWRT (Z(KORBGN),4,2)        
      LAMWDS = MODLEN - 1        
      IF (LAMWDS .LT. 1) GO TO 55        
      DO 50 I = 1,LAMWDS        
      CALL READ  (*90,*100,LAMAMR,Z(KORBGN),7,0,NWDS)        
   50 CALL SUWRT (Z(KORBGN),7,1)        
   55 CALL READ  (*90,*100,LAMAMR,Z(KORBGN),7,0,NWDS)        
      CALL CLOSE (LAMAMR,1)        
      CALL SUWRT (Z(KORBGN),7,2)        
      IF (KODE .EQ. 3) GO TO 60        
      CALL SUWRT (Z(LAMAAP),MODLEN,2)        
      CALL SUWRT (Z(LAMAAP),0,3)        
      GO TO 70        
   60 DO 65 I = 1,MODLEN        
   65 Z(KORBGN+I-1) = 1        
      CALL SUWRT (Z(KORBGN),MODLEN,2)        
      CALL SUWRT (Z(KORBGN),0,3)        
   70 CONTINUE        
      GO TO 200        
C        
C     PROCESS SYSTEM FATAL ERRORS        
C        
   90 IMSG = -2        
      GO TO 110        
  100 IMSG = -3        
  110 CALL SOFCLS        
      CALL MESAGE (IMSG,IFILE,MODNAM)        
      GO TO 200        
C        
C     PROCESS MODULE FATAL ERRORS        
C        
  120 GO TO (130,135,140,150,160,180), ITEST        
  130 IMSG = -9        
      GO TO 190        
  135 ISMG = -11        
      GO TO 190        
  140 IMSG = -1        
      GO TO 170        
  150 IMSG = -2        
      GO TO 170        
  160 IMSG = -3        
  170 CALL SMSG (IMSG,ITEM,OLDNAM)        
      GO TO 200        
  180 IMSG = -10        
  190 DRY  = -2        
      CALL SMSG1 (IMSG,ITEM,OLDNAM,MODNAM)        
  200 RETURN        
      END        
