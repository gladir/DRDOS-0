{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2021
  @website(https://www.gladir.com/drdos-0)
  @abstract(Target: Turbo Pascal, Free Pascal)
}

Program TOUCH;

Uses DOS;

Var
 OptionFlag:(_None,_t);
 DT:DateTime;
 Err:Word;
 NewTime:LongInt;
 FileTouch:File;
 I:Integer;
 DateString,TimeString:String;
 FileName:String;

Function StrToUpper(s:String):String;
Var
 i:Integer;
Begin
 For i:=1 to Length(s) do If s[i] in ['a'..'z']Then s[i] := UpCase(s[i]);
 StrToUpper:=s;
End;


BEGIN
 If(ParamStr(1)='/?')or(ParamStr(1)='--help')or(ParamStr(1)='-h')Then Begin
  WriteLn('TOUCH : Cette commande permet de modifier leur d''un fichier.');
  WriteLn;
  WriteLn('Syntaxe : TOUCH [-t CCAAMMJJhhmmSS] nomdufichier');
  WriteLn;
  WriteLn('Exemple : TOUCH abcd.txt -t 20100101235910');
 End
  Else
 Begin
  OptionFlag:=_None;
  FileName:='';
  TimeString:='';
  DateString:='';
  For I:=1 to ParamCount do Begin
   If OptionFlag<>_None Then Begin
    Case OptionFlag of
     _t:TimeString:=ParamStr(I);
    End;
    OptionFlag:=_None;
   End
    Else
   If ParamStr(I)='-t'Then OptionFlag:=_t Else
   If StrToUpper(Copy(ParamStr(I),1,3))='/T:'Then Begin
    TimeString:=Copy(ParamStr(I),4,255)
   End
    Else
   If StrToUpper(Copy(ParamStr(I),1,3))='/D:'Then Begin
    DateString:=Copy(ParamStr(I),4,255)
   End
    Else
   Begin
    FileName:=ParamStr(I);
    OptionFlag:=_None;
   End;
  End;
  If FileName<>''Then Begin
   If DateString<>''Then TimeString:=DateString+TimeString;
   Assign(FileTouch,FileName);
   {$I-}Reset(FileTouch);{$I+}
   If IOResult<>0 Then Rewrite(FileTouch);
   If TimeString<>''Then Begin
    Val(Copy(TimeString,1,4),DT.Year,Err);
    Val(Copy(TimeString,5,2),DT.Month,Err);
    Val(Copy(TimeString,7,2),DT.Day,Err);
    Val(Copy(TimeString,9,2),DT.Hour,Err);
    Val(Copy(TimeString,11,2),DT.Min,Err);
    Val(Copy(TimeString,13,2),DT.Sec,Err);
    PackTime(DT,NewTime);
    SetFTime(FileTouch,NewTime);
   End;
   Close(FileTouch);
  End;
 End;
END.
