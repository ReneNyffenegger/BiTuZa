unit StringUnit;

interface

procedure cut(t:string; var s:string);
// Schneidet den (1.) String t aus s weg.
procedure change(c1,c2: char; var s:string);
// Ersetzt alle Zeichen c1 durch c2 in s.
procedure cutBefore(t: string; var s:string);
// Schneidet alles vor dem (1.) String t aus s weg.
procedure cutAfter(t: string; var s:string);
// Schneidet alles nach dem (1.) String t aus s weg.
function getBefore(t:string; s:string):string;
// Liefert den String vor dem (1.) String t aus s.
function getAfter(t:string; s:string):string;
// Liefert den String nach dem (1.) String t aus s.

implementation

procedure cut(t:string; var s:string);
var l:Integer;
begin
  l:=Pos(t,s);
  if l > 0 then System.Delete(s,l,Length(t));
end;

procedure change(c1,c2: char; var s: string);
var l:Integer;
begin
  for l:=1 to Length(s) do
    if s[l]=c1 then s[l]:=c2
end;

procedure cutBefore(t: string; var s: string);
var l:Integer;
begin
  l:=Pos(t,s);
  System.Delete(s,1,l-1);
end;

procedure cutAfter(t: string; var s: string);
var l:Integer;
begin
  l:=Pos(t,s);
  System.Delete(s,l,Length(s));
end;

function getBefore(t:string; s:string):string;
var l:Integer;
begin
  l:=Pos(t,s);
  if l>0 then s:= System.Copy(s,1,l-1);
  Result:=s
end;

function getAfter(t:string; s:string):string;
var l:Integer;
begin
  l:=Pos(t,s);
  if l>0 then s:= System.Copy(s,l+Length(t),Length(s));
  Result:=s
end;

end.
