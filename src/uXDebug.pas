{$IFNDEF dcc}
  {$mode delphi}
{$ENDIF}
unit uXDebug;

{ uXDebug.pas ; Debugging functions }
{ Author: Felix Eckert              }

{$H+}
{$DEFINE DEBUG}

interface
  uses SysUtils;

  function InDebug: Boolean;

  procedure debugwrite(const ACont: String);
  procedure debugwriteln(const ALine: String);
  procedure debugwritef(const ACont: String; const AFormats: array of const);

  const
    PROGNAME = 'deash';
implementation
  function InDebug: Boolean;
  begin
    {$IFDEF DEBUG} 
      InDebug := True; 
    {$ELSE} 
      InDebug := False; 
    {$ENDIF}
  end;

  procedure debugwrite(const ACont: String);
  begin
    {$IFDEF DEBUG}
    write(ACont);
    {$ENDIF}
  end;

  procedure debugwriteln(const ALine: String);
  begin
    {$IFDEF DEBUG}
    writeln(Format('%s <DEBUG>:: %s', [PROGNAME, ALine]));
    {$ENDIF}
  end;

  procedure debugwritef(const ACont: String; const AFormats: array of const);
  begin
    {$IFDEF DEBUG}
    write(Format(ACont, AFormats));
    {$ENDIF}
  end;
end.
