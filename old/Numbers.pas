unit Numbers;

{ Cluster: Numbers
}
{ Explanation:
    Enthält Klassen, die verschieden Zahlen darstellen:
    (Ersetzt die obsolete Unit Zahlen)
    - TNumber (Zahl als Klasse)
    - TNumber2 (2 Zahlen als Klasse)
    Außerdem werden folgende Funktionen bereitgestellt:
    Double_Str (Double als String)
    LeadingZero  (Integer mit fester Stellenzahl (führende Nullen))
    TrailingZero (Integer mit fester Stellenzahl (Ende mit Nullen))
    LeadingBlank (Integer mit fester Stellenzahl (führende Blanks))
    TrailingBlank(Integer mit fester Stellenzahl (Ende mit Blanks))
}
{ Indexing:
    Keywords: Zahlen
    Author  : Dr. P.G. Zint
    Street  : Dresselndorfer Str. 3
    City    : 57299 Burbach
    Created : 10.05.1997
    Revised : 12.06.2001
    Compile : Delphi 2.0, 3.01
}
{ Changing:
    28.05.1997 TNumber2 neu
    29.06.1997 Unit Zahlen in *.alt umbenannt
    17.09.1997 Großschreibung
    22.11.1997 Class-Header neu
    12.06.2001 Factors neu.
}

interface

type
  TNumber = class
    Number: Integer; // Aktueller Zählerwert.
    constructor Create  (n: Integer); // Number wird mit n kreiert.
    procedure Put       (n: Integer); // Number wird auf n gesetzt.
    procedure Increment (n: Integer); // Number wird um n erhöht.
    procedure Decrement (n: Integer); // Number wird um n erniedrigt.
    function  Decimal_l0 (Stellen: Word): string;
      // Number als String mit Stellen.
    end;

  TNumber2 = class
    Number1,
    Number2: Integer;
    constructor Create   (n1, n2: Integer);
      // Number1 wird mit n1, Number2 mit n2 kreiert.
    procedure Put        (n1, n2: Integer);
     // Number1 wird auf n1, Number2 auf n2 gesetzt.
    procedure Put1       (n: Integer); // Number1 wird auf n gesetzt.
    procedure Increment1 (n: Integer); // Number1 wird um n erhöht.
    procedure Decrement1 (n: Integer); // Number1 wird um n erniedrigt.
    procedure Put2       (n: Integer); // Number2 wird auf n gesetzt.
    procedure Increment2 (n: Integer); // Number2 wird um n erhöht.
    procedure Decrement2 (n: Integer); // Number2 wird um n erniedrigt.
    end;

function Factors (Number, Factor: Integer): string;
  // Liefert Number als Vielfache von Factor (oder Number selbst).
function Double_Str    (Value: Double; len, Digits: Word): string;
function Left_Double   (Value: Double; len, Digits: Word): string;
function Left_Long     (Value: LongInt; Digits: Word): string;
function LeadingZero   (Value: LongInt; Digits: Word): string;
function TrailingZero  (Value: LongInt; Digits: Word): string;
function LeadingBlank  (Value: LongInt; Digits: Word): string;
function TrailingBlank (Value: LongInt; Digits: Word): string;

implementation

uses Zeichen, SysUtils;

const
  Digit_max = 10;
  Nulls : array [1 .. Digit_max] of string =
    ('0', '00', '000', '0000', '00000', '000000', '0000000', '00000000',
     '000000000', '0000000000');
  Blanks : array [1 .. Digit_max] of string =
    (' ', '  ', '   ', '    ', '     ', '      ', '       ', '        ',
     '         ', '          ');

function Factors (Number, Factor: Integer): string;
var s: string; m: Integer;

  procedure Next_Factor;
  begin
    m := Number mod Factor;
    if (m = 0) and (Number <> 0)
    then // Number durch Factor teilbar:
      begin
      if s = ''
      then s := IntToStr (Factor)
      else s := s + ' * ' + IntToStr (Factor);
      Number := Number div Factor;
      Next_Factor
      end
    else
      begin
      if s = ''
      then s := IntToStr (Number)
      else
        begin
        if Number <> 1 then s := s + ' * ' + IntToStr (Number)
        end
      end
  end;

begin
  s := '';
  Next_Factor;
  Result := s
end;

function Double_Str (Value: Double; len, Digits: Word): string;
begin
  Result := Just_Right (FloatToStrF (Value, ffFixed, 7, Digits), len)
end;

function Left_Double (Value: Double; len, Digits: Word): string;
begin
  Result := No_Blanks (Double_Str (Value, len, Digits))
end;

function Left_Long (Value: LongInt; Digits: Word): string;
begin
  Result := No_Blanks (LeadingBlank (Value, Digits))
end;

function LeadingZero (Value: LongInt; Digits: Word): string;
var s: string; i: Integer;
begin
  Str (Value, s);
  i := Digits - Length (s);
  if (i <= Digit_max) and (i > 0)
  then Result := Nulls [i] + s
  else Result := s
end;

function TrailingZero (Value: LongInt; Digits: Word): string;
var s: string; i: Integer;
begin
  Str (Value, s);
  i := Digits - Length (s);
  if (i <= Digit_max) and (i > 0)
  then Result := s + Nulls [i]
  else Result := s
end;

function LeadingBlank (Value: LongInt; Digits: Word): string;
var s: string; i: Integer;
begin
  Str (Value, s);
  i := Digits - Length (s);
  if (i <= Digit_max) and (i > 0)
  then Result := Blanks [i] + s
  else Result := s
end;

function TrailingBlank (Value: LongInt; Digits: Word): string;
var s: string; i: Integer;
begin
  Str (Value, s);
  i := Digits - Length (s);
  if (i <= Digit_max) and (i > 0)
  then Result := s + Blanks [i]
  else Result := s
end;

// TNumber: ---------------------------------------------------------

constructor TNumber.Create (n: Integer);
begin
  inherited Create;
  Put (n)
end;

procedure TNumber.Put (n: Integer);
begin
  Number := n
end;

procedure TNumber.Increment (n: Integer);
begin
  Inc (Number, n)
end;

procedure TNumber.Decrement (n: Integer);
begin
  Dec (Number, n)
end;

function TNumber.Decimal_l0 (Stellen: Word): string;
begin
  Result := LeadingZero (Number, Stellen)
end;

// TNumber2: --------------------------------------------------------

constructor TNumber2.Create (n1, n2: Integer);
begin
  inherited Create;
  Put (n1, n2)
end;

procedure TNumber2.Put (n1, n2: Integer);
begin
  Put1 (n1);
  Put2 (n2)
end;

procedure TNumber2.Put1 (n: Integer);
begin
  Number1 := n
end;

procedure TNumber2.Increment1(n: Integer);
begin
  Inc (Number1,n)
end;

procedure TNumber2.Decrement1(n: Integer);
begin
  Dec (Number1, n)
end;

procedure TNumber2.Put2(n: Integer);
begin
  Number2:= n
end;

procedure TNumber2.Increment2 (n: Integer);
begin
  Inc (Number1, n)
end;

procedure TNumber2.Decrement2 (n: Integer);
begin
  Dec (Number2, n)
end;

end.
