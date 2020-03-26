unit ideuimain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazIDEIntf, IDECommands;

procedure Register;

implementation

type
  TPrevHandler = record
    OnMethod: TNotifyEvent;
    OnProc: TNotifyProcedure;
  end;

var
  IDECloseAll: TPrevHandler;

procedure InvokeHandler(const h: TPrevHandler; Sender: TObject);
begin
  if Assigned(h.OnMethod) then h.OnMethod(Sender);
  if Assigned(h.OnProc) then h.OnProc(Sender);
end;

procedure MyCloseAll(Sender: Tobject);
begin
  InvokeHandler(IDECloseAll, Sender);
  IDECommandList.FindIDECommand(ecCloseProject).Execute(Sender);
end;


procedure UpdateCloseAll;
var
  idecmd : TIDECommand;
begin
  idecmd := IDECommandList.FindIDECommand(ecCloseAll);
  if not Assigned(idecmd) then begin
    writeln('no command close all :(');
    exit;
  end;

  IDECloseAll.OnMethod := idecmd.OnExecute;;
  IDECloseAll.OnProc := idecmd.OnExecuteProc;

  idecmd.OnExecuteProc := @MyCloseAll;
  idecmd.OnExecute := nil;
end;

procedure Register;
begin
  UpdateCloseAll;
end;

end.

