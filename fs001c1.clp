/********************************************************************/
/*                                                                  */
/*  Automate OSS Package Updates                                    */
/*                                                                  */
/*  Andy Youens                                                     */
/*  © 1990 - 2019 FormaServe Systems Ltd                            */
/*                                                                  */
/********************************************************************/
 Start:      Pgm

             Dcl        &Date          *char             6
             Dcl        &Mbr           *char            10
             Dcl        &IFSDir        *Char           256  Value( '/oss/logs/' )
             Dcl        &Time          *Char             6
             Dcl        &FullName      *Char           256
             Dcl        &PDFName       *Char           640

             Dcl        &MsgId         *Char             7
             Dcl        &MsgDta        *Char           256
             Dcl        &MsgF          *Char            10
             Dcl        &MsgfLib       *Char            10
             Dcl        &ErrorSw       *Lgl

             Copyright  '© 1990 - 2019 FormaServe Systems Ltd.'

             MonMsg     Cpf0000 Exec(Goto Error)

             RtvSysVal  QDate  &Date
             RtvSysVal  QTime  &Time

             ChgVar     &Mbr   ('Log_' || &Date )
             ChgVar     &FullName ('/QSYS.LIB/POWERWIRE.LIB/OSS_LOG.FILE/' ||  &Mbr |< '.MBR')

             CrtPf      FILE(PowerWire/OSS_log) RCDLEN(512) TEXT('OSS Audit Log ') MAXMBRS(*NOMAX)

             MonMsg     (Cpf5813 Cpf7302) /* Aleady exists - dont care!  */

/*              Remove previous log                                           */
             RmvLnk     '/oss/logs/yumupdates.log'
             Monmsg     CPFA0A9 /* Dont care if not there  */

/*              Check if there are any updates                                */
             QSH        CMD('/QOpenSys/pkgs/bin/yum check-update > /oss/logs/yumupdates.log')

/*              Copy log file to physical file                                */
             Cpy        OBJ('/oss/logs/yumupdates.log') ToObj(&fullname) Replace(*Yes) DtaFmt(*Text)

/*              Produce spool of packages to be updated                       */
             CpyF       FROMFILE(PowerWire/OSS_Log) TOFILE(*LIBL/QSYSPRT) FROMMBR(&Mbr)

/*              Build PDF name - Uses Date & Time to make unique              */
             ChgVar     &PdfName (&IFSDir |< 'Yum Update Log ' || &Date || '_' || &Time |< '.pdf')

/*              Create PDF for auditing purposes                              */
             CpySplF    File(QSYSPRT) ToFile(*ToStmf) Job(*) SplNbr(*Last) ToStmf(&PdfName) Wscst(*Pdf) +
                          StmfOpt(*Replace)

/*              Update packages                                               */
             QSH        CMD('/QOpenSys/pkgs/bin/yum update < /tmp/yes >> /tmp/os002')

                          /*  All Done - 'Omers!    */
             Return

 Error:      If         Cond(&ErrorSw) Then(SndPgmMsg  MsgID(Cpf9999) MsgF(QCpfMsg) MsgType(*Escape))

             ChgVar     &ErrorSw    '1'

 Error2:     RcvMsg     MsgType(*Diag) MsgDta(&MsgDta) MsgID(&MsgID) MsgF(&MsgF) SndMsgFLib(&MsgFLib)
             If         (&MsgID =   ' ') Goto Error3
             SndPgmMsg  MsgID(&MsgID) MsgF(&MsgFLib/&Msgf) MsgDta(&MsgDta) MsgType(*Diag)
             Goto       Error2

 Error3:     RcvMsg     MsgType(*Excp) MsgDta(&MsgDta) MsgID(&MsgID) MsgF(&MsgF) SndMsgFLib(&MsgFLib)
             SndPgmMsg  MsgID(&MsgID) MsgF(&MsgFLib/&MsgF) MsgDta(&MsgDta) MsgType(*Escape)

 End:        EndPgm

