{$ifndef dcc}
  {$H+}
  {$mode delphi}
{$endif}
unit uSimpleMatchPatterns;

{******************************************************************}
{           uSimpleMatchPatterns.pas ; Vereinfachte RegEx          }
{                                                                  }
{ Autor: Felix Eckert                                              }
{ Licensed under the "Do What The Fuck You Want To Public License" }
{******************************************************************}

(*
            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar
  14 rue de Plaisance, 75014 Paris, France
 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO.
*)

interface
  uses SysUtils;

  function SMPCMDToRegEx(const ACommand, ALenCommand, ARangeA, ARangeB: String): String;
  function ConvertToRegEx(ASource: String): String;

  const
    OPATTERN_ALLCHARS = '>AlleBuchstaben';
    OPATTERN_USCHARS = '>USBuchstaben';
    OPATTERN_DIGITS = '>Ziffern';
    RPATTERN_ALLCHARS = '[a-zA-ZäÄöÖüÜ]';
    RPATTERN_USCHARS = '[a-zA-Z]';
    RPATTERN_DIGITS = '[0-9]';

implementation
  function SMPCMDToRegEx(const ACommand, ALenCommand, ARangeA, ARangeB: String): String;
  begin
    // Attempt conversion to throw exception if invalid number
    if (ALenCommand <> '') then
    begin
      StrToInt(ARangeA);
      if (ARangeB <> '') then
        StrToInt(ARangeB);
    end;

    if (ACommand = OPATTERN_ALLCHARS) then
      result := RPATTERN_ALLCHARS
    else if (ACommand = OPATTERN_USCHARS) then
      result := RPATTERN_USCHARS
    else 
      result := RPATTERN_DIGITS;
      
    if (ALenCommand = 'Von') then
      result := result+'{'+ARangeA+',}'
    else if (ALenCommand = 'Bis') then
      result := result+'{0-'+ARangeB+'}'
    else if (ALenCommand = 'VonBis') then
      result := result+'{'+ARangeA+'-'+ARangeB+'}'
    else
      result := result+'+';
  end;

  function ConvertToRegEx(ASource: String): String;
  var
    i: Integer;
    building: Boolean;
    buildstage: Integer;
    command, rangecommand: String;
    rangeA, rangeB: String;
  begin
    result := '';
    
    for i := 1 to Length(ASource) do
    begin
      if ASource[i] = '>' then
      begin
        command := '';
        rangecommand := '';
        rangeA := '';
        rangeB := '';
        building := True;
      end;
      
      if building then
      begin
        if (ASource[i] = ';') then
        begin
          building := False;
          buildstage := 0;
          result := result + SMPCMDToRegEx(command, rangecommand, rangeA, rangeB);
          continue;
        end;
        
        if (ASource[i] = ',') then 
        begin
          buildstage := buildstage + 1; 
          continue;
        end;
        
        case buildstage of
          0: command := command + ASource[i];
          1: rangecommand := rangecommand + ASource[i];
          2: rangeA := rangeA+ASource[i];
          3: rangeB := rangeB+ASource[i];
        end;
      end else
      begin
        if (ASource[i] = '.')
        or (ASource[i] = '+')
        or (ASource[i] = '*')
        or (ASource[i] = '?')
        or (ASource[i] = '^')
        or (ASource[i] = '(')
        or (ASource[i] = ')')
        or (ASource[i] = '[')
        or (ASource[i] = ']')
        or (ASource[i] = '{')
        or (ASource[i] = '}')
        or (ASource[i] = '|')
        or (ASource[i] = '\')
        or (ASource[i] = '$') then
          result := result + '\';
        
        result := result + ASource[i];
      end;

    end;
    result := result + '';
  end;
end.