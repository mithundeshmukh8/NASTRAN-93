      SUBROUTINE TRHT        
C        
C     TRANSIENT INTEGRATION HEAT TRANSFER MODULE        
C        
C     INPUTS  CASEXX,USETD,NLFT,DIT,GPTT,KDD,BDD,RDD,PD,TRL (10)        
C        
C     OUTPUTS  UDVT,PNLD (2)        
C        
C     SCRATCHES (7)        
C     PARAMETERS BETA(R),TABS(R),NORAD(L),RADLIN(L)        
C        
C     ICR1 IS LLL        
C     ICR2 IS ULL        
C     ICR5 IS INITIAL CONDITIONS        
C     ICR6 IS A MATRIX        
C     ICR3,ICR4,ICR7 ARE DECOMP SCRATCH FILES        
C        
      INTEGER         CASEXX,USETD,NLFT,DIT,GPTT,KDD,BDD,RDD,PD,TRL,    
     1                UDVT,PNLD,RADLIN,ISCR1,ISCR2,ISCR3,ISCR4,        
     2                IZ(1),NAME(2),IPNL(7),SYSBUF,DIT1,PNL1        
      COMMON /BLANK / BETA,TABS,NORAD,RADLIN,SIGMA        
      COMMON /SYSTEM/ KSYSTM(65)        
CZZ   COMMON /ZZTRDC/ Z(1)        
      COMMON /ZZZZZZ/ Z(1)        
      COMMON /TRHTX / IK(7),IB(7),ICR1,ICR2,ICR3,ICR4,ICR5,ISYM,ICR6,   
     1                ICR7,TIM        
      COMMON /TRDD1 / NLFT1,DIT1,NLFTP1,NOUT,ICOUNT,ILOOP1,MODA1,NZ,    
     1                ICORE,IU2,IP4,IPNL,NMODES,NSTEP,PNL1,IST,MORE(6)  
      EQUIVALENCE     (KSYSTM(1),SYSBUF),(KSYSTM(55),IPREC),(Z(1),IZ(1))
      DATA    CASEXX, USETD,NLFT,DIT,GPTT,KDD,BDD,RDD,PD ,TRL/        
     1        101   , 102  ,103 ,104,105 ,106,107,108,109,110/,        
     2        UDVT  , PNLD,ISCR1 ,ISCR2,ISCR3,ISCR4,ISCR5,ISCR6,ISCR7/  
     3        201   , 202 ,301   ,302  ,303  ,304  ,305  ,306  ,307  /  
      DATA    NAME  / 4HTRD ,4H    /,   NB   / 8 /        
C        
C     SET UP FILES        
C        
      IK(1) = KDD        
      CALL RDTRL (IK)        
      IB(1) = BDD        
      CALL RDTRL (IB)        
      ICR1 = ISCR1        
      ICR2 = ISCR2        
      ICR3 = ISCR3        
      ICR4 = ISCR4        
      ICR5 = ISCR5        
      ICR6 = ISCR6        
      ICR7 = ISCR7        
C        
C     SET UP NONLINEAR FILES        
C        
      NLFT1 = NLFT        
      DIT1  = DIT        
      PNL1  = PNLD        
      IF (IK(1) .LE. 0) IK(1) = 0        
      IF (IB(1) .LE. 0) IB(1) = 0        
      MODA1 = -1        
      IF (IB(1) .NE. 0) IK(2) = IB(2)        
C        
C     OBTAIN PARAMETERS, INITIAL CONDITIONS        
C        
      CALL TRHT1A (CASEXX,USETD,GPTT,TRL,NGROUP)        
C        
C     ALLOCATE CORE        
C        
      NZ = KORSZ(Z)        
      IGROUP = NZ - 3*NGROUP + 1        
      NV = 4        
      IF (NLFTP1.NE.0 .OR. NORAD.NE.-1) NV = NV + 3        
      IF (NZ .LT. NV*IK(2)*IPREC-NB*SYSBUF-3*NGROUP)        
     1    CALL MESAGE (-8,0,NAME)        
      TIM = 0.        
      DO 10 I = 1, NGROUP        
      CALL KLOCK (ITIM1)        
      NSTEP  = IZ(IGROUP )        
      DELTA  = Z(IGROUP+1)        
      IGROUP = IGROUP + 3        
C        
C     FORM  A  MATRIX AND DECOMPOSE        
C        
      CALL TRHT1B (3*NGROUP,DELTA)        
      CALL KLOCK  (ITIM3)        
      CALL TRHT1C (NGROUP,UDVT,PD,RDD,I)        
      CALL KLOCK  (ITIM2)        
      CALL TMTOGO (ITLEFT)        
      IF (I .EQ. NGROUP) GO TO 10        
      IF ((ITIM 3-ITIM1+((ITIM 2-ITIM 3)/NSTEP)*IZ(IGROUP)) .GE. ITLEFT)
     1   GO TO 30        
   10 CONTINUE        
   20 RETURN        
C        
   30 CALL MESAGE (45,NGROUP-I,NAME)        
      GO TO 20        
      END        
