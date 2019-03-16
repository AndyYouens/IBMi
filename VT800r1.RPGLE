**Free
//*************************************************//
// Program:       VT804r1                          //
// Date:          March 2019                       //
// Description:   f_MTD Briging API Example        //
//                                                 //
// FormaServe Systems Ltd                          //
// © Copyright - 1990 FormaServe Systems Ltd       //
//                                                 //
//*************************************************//

Ctl-Opt
 Option(*NoDebugIO:*SrcStmt:*NoUnref)
 AlwNull( *UsrCtl )
 Copyright('© FormaServe Systems 1990 | V1.0.0 2019/01 | f_MTD')
   ;

// Global Definitions
dcl-ds dsGlobal ;
  v1  char(10) Inz('1111.10') ;
  v2  char(10) Inz('22.20') ;
  v4  char(10) Inz('44.40') ;
  v6  char(10) Inz('6.60') ;
  v7  char(10) Inz('7.70') ;
  v8  char(10) Inz('8.80') ;
  v9  char(10) Inz('9.90') ;
  ErrMessage varchar(2048) ;
  rc int(3) ;
end-ds ;

dcl-pr setVATValues Int(3) ;
  *n char(10) ;
  *n char(10) ;
  *n char(10) ;
  *n char(10) ;
  *n char(10) ;
  *n char(10) ;
  *n char(10) ;
End-Pr;

// Main Loop
DoU 1 = ABD ;

  rc = SetVATValues( v1
   : v2
   : v4
   : v6
   : v7
   : v8
   : v9
   ) ;

  // We get any errors back from service program?
  if (rc > 0) ;
    Dsply 'Errors occurred!' ;
    if (rc = 9) ;
      Dsply 'Licensing Errors!' ;
    EndIf;
  else ;
    Dsply 'VAT Values Updated!' ;
  EndIf;

EndDo;

*Inlr = TRUE ;
Return;

