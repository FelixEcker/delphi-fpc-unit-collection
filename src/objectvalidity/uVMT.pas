{$ifndef dcc}
  {$mode delphi}
{$endif}
unit uVMT;

(* Virtual Method Table Helper ; Author: TS *)
(* Written for Freepascal and Delphi 2      *)
(* Licensed under the WTFPL License         *)

interface
  type
    PClass = ^TClass;
    PSafeCallException = function  (Self: TObject; ExceptObject:
      TObject; ExceptAddr: Pointer): HResult;
    PAfterConstruction = procedure (Self: TObject);
    PBeforeDestruction = procedure (Self: TObject);
    PDispatch          = procedure (Self: TObject; var Message);
    PDefaultHandler    = procedure (Self: TObject; var Message);
    PNewInstance       = function  (Self: TClass) : TObject;
    PFreeInstance      = procedure (Self: TObject);
    PDestroy           = procedure (Self: TObject; OuterMost: ShortInt);
    PVmt = ^TVmt;
    TVmt = packed record
      SelfPtr           : TClass;
      IntfTable         : Pointer;
      AutoTable         : Pointer;
      InitTable         : Pointer;
      TypeInfo          : Pointer;
      FieldTable        : Pointer;
      MethodTable       : Pointer;
      DynamicTable      : Pointer;
      ClassName         : PShortString;
      InstanceSize      : PLongint;
      ClassParent       : PClass;
      SafeCallException : PSafeCallException;
      AfterConstruction : PAfterConstruction;
      BeforeDestruction : PBeforeDestruction;
      Dispatch          : PDispatch;
      DefaultHandler    : PDefaultHandler;
      NewInstance       : PNewInstance;
      FreeInstance      : PFreeInstance;
      Destroy           : PDestroy;
   (* UserDefinedVirtuals: array[0..999] of procedure; *)
    end;
    
  function GetVmt(AClass: TClass): PVmt; overload;
  function GetVmt(Instance: TObject): PVmt; overload;
implementation
  function GetVmt(AClass: TClass): PVmt; overload;
  begin
    Result := PVmt(AClass);
    Dec(Result);
  end;

  function GetVmt(Instance: TObject): PVmt; overload;
  begin
    Result := GetVmt(Instance.ClassType);
  end;
end.
