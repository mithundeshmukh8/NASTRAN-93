      SUBROUTINE EMGTAB        
C*****        
C     THIS ROUTINE OF THE -EMG- MODULE PREPARES OPEN CORE WITH SOME     
C     VARIOUS TABLES.  CSTM, MAT, ETC.        
C        
C     UTILITY ROUTINES ARE USED FOR THE MOST PART.        
C*****        
      LOGICAL         ANYCON, ERROR, HEAT        
      INTEGER         RDREW, WRT, WRTREW, CLS, CLSREW, BUF1, SUBR(2),   
     1                PRECIS, SYSBUF, EST, CSTM, DIT, GEOM2, Z, FILE,   
     2                EOR, RD, FLAGS, DITFIL        
      COMMON /SYSTEM/ KSYSTM(65)        
      COMMON /NAMES / RD, RDREW, WRT, WRTREW, CLSREW, CLS        
      COMMON /EMGPRM/ ICORE, JCORE, NCORE, ICSTM, NCSTM, IMAT, NMAT,    
     1                IHMAT, NHMAT, IDIT, NDIT, ICONG, NCONG, LCONG,    
     2                ANYCON, FLAGS(3), PRECIS, ERROR, HEAT        
     3               ,ICMBAR, LCSTM, LMAT, LHMAT        
      COMMON /EMGFIL/ EST, CSTM, MPT, DIT, GEOM2        
      COMMON /HMATDD/ IIHMAT, NNHMAT, MPTFIL, DITFIL        
CZZ   COMMON /ZZEMGX/ Z(1)        
      COMMON /ZZZZZZ/ Z(1)        
      EQUIVALENCE     (KSYSTM(1), SYSBUF)        
      DATA    SUBR  / 4HEMGT,  4HAB  /,   EOR/ 1 /        
C*****        
C     READ -CSTM- INTO CORE.        
C*****        
      BUF1 = NCORE - SYSBUF - 2        
      ICRQ = JCORE - BUF1        
      IF (BUF1 .LE. JCORE) GO TO 10        
      ICSTM = JCORE        
      NCSTM = JCORE - 1        
      FILE  = CSTM        
      CALL OPEN (*30,CSTM,Z(BUF1),RDREW)        
      CALL FWDREC (*30,CSTM)        
      CALL READ (*60,*20,CSTM,Z(ICSTM),BUF1-JCORE,EOR,LCSTM)        
      ICRQ = BUF1 - JCORE        
   10 CALL MESAGE (-8,ICRQ,SUBR)        
   20 CALL CLOSE (CSTM,CLSREW)        
      NCSTM = ICSTM + LCSTM - 1        
      CALL PRETRS (Z(ICSTM),LCSTM)        
      CALL PRETRD (Z(ICSTM),LCSTM)        
C*****        
C     HAMT AND PREMAT        
C*****        
   30 IF (.NOT.HEAT) GO TO 40        
C        
C     HEAT PROBLEM THUS USE -HMAT-        
C        
      IMAT   = NCSTM + 1        
      NMAT   = NCSTM        
      IIHMAT = NMAT        
      NNHMAT = NCORE        
      MPTFIL = MPT        
      DITFIL = DIT        
      CALL PREHMA (Z)        
      IHMAT = IIHMAT        
      NHMAT = NNHMAT        
      LHMAT = NHMAT - IHMAT        
      JCORE = NHMAT + 1        
      GO TO 50        
C        
C     NON-HEAT PROBLEM THUS USE -MAT-        
C        
   40 IMAT = NCSTM + 1        
      CALL PREMAT (Z(IMAT),Z(IMAT),Z(BUF1),BUF1-IMAT,LMAT,MPT,DIT)      
      NMAT  = IMAT + LMAT - 1        
      IHMAT = NMAT + 1        
      NHMAT = NMAT        
      JCORE = NHMAT + 1        
C        
   50 CONTINUE        
      RETURN        
C        
   60 CALL MESAGE (-2,FILE,SUBR)        
      RETURN        
      END        
