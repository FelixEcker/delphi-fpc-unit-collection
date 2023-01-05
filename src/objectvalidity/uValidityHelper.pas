{$ifndef dcc}
  {$mode delphi}
{$endif}
unit uValidityHelper;

{ uValidityHelper.pas - Helper functions for determening     }
{                       the Validity of Objects and Pointers }
{                                                            }
{ NOTE: THIS UNIT RELIES ON THE WINAPI                       }
{ Author: Felix Eckert                                       }
{ Licensed under the ISC license                             }

(* Copyright (c) 2022, Felix Eckert                                         *)
(*                                                                          *)
(* Permission to use, copy, modify, and/or distribute this software for any *)
(* purpose with or without fee is hereby granted, provided that the above   *)
(* copyright notice and this permission notice appear in all copies.        *)
(*                                                                          *)
(* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES *)
(* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF         *)
(* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR  *)
(* ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES   *)
(* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN    *)
(* ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF  *)
(* OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.           *)

interface
  {$ifdef mswindows}
  uses Winapi.Windows, uVMT;
  {$endif}

  type
    PClass = ^TClass;
    
  function ValidPtr(P: Pointer; Size: Cardinal): Boolean;
  function ValidObjectType(Obj: TObject; ClazzType: TClass): Boolean;
  function ValidPtrShortString(Str: PShortString): Boolean;
  function ValidClassParent(ClazzParent: PClass): Boolean;
  function ValidClassType(ClazzType: TClass): Boolean;
  function ValidObj(Obj: TObject): Boolean;
  
implementation
  { Check if Pointer is readable }
  function ValidPtr(P: pointer; Size: Cardinal): Boolean;
  begin
    {$ifdef mswindows}
    result := not IsBadReadPtr(P, Size);
    {$endif}
  end;

  function ValidObjectType(Obj: TObject; ClazzType: TClass): Boolean;
  begin
    {$ifdef mswindows}
    result := Assigned(Obj) 
          and ValidPtr(Pointer(Obj), SizeOf(TObject)) 
          and ValidPtr(Pointer(Obj), ClazzType.InstanceSize);
    {$endif}
  end;

  function ValidPtrShortString(Str: PShortString): Boolean;
  begin
    {$ifdef mswindows}
    result := ValidPtr(Str, SizeOf(Byte)) 
          and ValidPtr(Str, Ord(Str^[0]));
    {$endif}
  end;

  function ValidClassParent(ClazzParent: PClass): Boolean;
  begin
    {$ifdef mswindows}
    if ClazzParent = nil then
      result := True
    else
    if ValidPtr(ClazzParent, SizeOf(ClazzParent^)) then
      result := (ClazzParent^ = nil) or ValidClassType(ClazzParent^)
    else
      result := False;
    {$endif}
  end;

  function ValidClassType(ClazzType: TClass): Boolean;
  var
    {$ifdef mswindows} Vmt: PVmt; {$endif}
    Foo: Integer;
  begin
    {$ifdef mswindows}
    Vmt := GetVmt(ClazzType);
    result := ValidPtr(Vmt, SizeOf(Vmt^))
          and (Vmt^.SelfPtr = ClazzType)
          and ValidPtrShortString(Vmt^.ClassName)
          and ValidClassParent(PClass(Vmt^.ClassParent));
    {$endif}
  end;

  function ValidObj(Obj: TObject): Boolean;
  begin
    {$ifdef mswindows}
    result := Assigned(Obj) 
          and ValidPtr(PClass(Obj), SizeOf(TClass))
          and ValidClassType(Obj.ClassType) 
          and ValidPtr(Pointer(Obj), Obj.InstanceSize);
    {$endif}
  end;
  
end.
