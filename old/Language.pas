unit Language;

{ Cluster: Language
}
{ Explanation:
    Zusammenstellung der Buchstaben einer Sprache.
    Das Programm wird z.B. zur Bibelanalyse Urtext eingesetzt.

    - Klasse Language
    - Klasse German
    - Klasse Greek
    - Klasse Hebrew
}
{ Indexing:
    Keywords: Sprache, Bibel
    Author  : Dr. P.G. Zint
    Street  : Holzheimer Str. 96
    City    : 57299 Burbach
    Phone   : 02736-3378
    Created : 21.08.1995
    Revised : 27.04.2002
    Compile : Delphi 5
}
{ Changing:
    03.10.1995 Neue Features: Order_of.
    26.10.1997 Eingerichtet für Delphi 2.0
    28.10.1997 Read_Code neu
    15.11.1997 Hebrew.Read_Code neu
    16.11.1997 Font_Code neu
    22.11.1997 Class-Header neu
    28.03.2002 Anpassungen für Windows XP und neue Fonts.
    27.04.2002 Code_of_OLB neu
}

interface

const
  Code_Zeichen = '_'; // Zeichen zwischen 2 Code-Zahlen im Urtext.

type
  TLanguage = class
    constructor Create;
    function    Get_Letter_max: Byte;
      // Anzahl der Buchstaben der Sprache.
    function    Get_Lower (i: Byte): string; virtual; abstract;
      // Liefert den Namen des i. Kleinbuchstabens.
    function    Get_Upper (i: Byte): string; virtual;
      // Liefert den Namen des i. Großbuchstabens.
    function    Get_Random_Word (l: Byte): string;
      { Liefert einen zufälligen Wortstring der Länge l.
        Der Wordstring besteht aus den Nummern der Buchstaben. }

  { Features des durch Latin_Letter
    in der Online Bible definierten Buchstaben: }
    function Order (Latin_Letter: Char): Integer; virtual; abstract;
      // Ordnungszahl: z.B. a = 1, b = 2 etc.
    function Code (Latin_Letter: Char): Integer; virtual;
      // Zahlencode der Sprache.
    function Name (Latin_Letter: Char): string; virtual;
      // Name des Buchstaben.
    function Read_Code (Latin_Letter: Char): Char; virtual;
      // Normaler Lese-Code des Buchstaben.
    function Font_Code (Latin_Letter: Char): Char; virtual;
      // Code des Buchstaben zur Darstellung im WINWORD-Font.

    // Urtext features:
    function Code_of_OLB (s: string): string;
      // Liefert Zahlencode xxx-yyy-... zum OLB-Wort s.
    function Total_of_OLB (s: string): Integer;
      // Liefert Totalwerte des Zahlencodes zum OLB-Wort s.
  private
    Letter_max: Byte; // Anzahl der Buchstaben.
    end;

  TGerman = class (TLanguage)
    constructor Create;
    function    Get_Lower (i: Byte): string; override;
    function    Order (Latin_Letter: Char): Integer; override;
    end;

  TGreek = class (TLanguage)
    constructor Create;
    function    Get_Lower (i: Byte): string; override;
    function    Order (Latin_Letter: Char): Integer; override;
    function    Code (Latin_Letter: Char): Integer; override;
    function    Name (Latin_Letter: Char): string; override;
    function    Read_Code (Latin_Letter: Char): Char; override;
    function    Font_Code (Latin_Letter: Char): Char; override;
    function    OLB_to_Symbol (Latin_Letter: Char): Char;
      // Liefert Symbol-Font-Zeichen zum OLB-Zeichen Latin_Letter.
    function    OLB_to_TITUS (Latin_Letter: Char): Char;
      // Liefert TITUS-Font-Zeichen zum OLB-Zeichen Latin_Letter.
    function German_to_TITUS (Latin_Letter: Char): Char;
      // Liefert TITUS-Font-Zeichen zum deutschen Zeichen Latin_Letter.
    end;

  THebrew = class (TLanguage)
    constructor Create;
    function    Get_Lower (i: Byte): string; override;
    function    Order (Latin_Letter: Char): Integer; override;
    function    Code  (Latin_Letter: Char): Integer; override;
    function    Name  (Latin_Letter: Char): string; override;
    function    Read_Code (Latin_Letter: Char): Char; override;
    function    OLB_to_David (Latin_Letter: Char): Char;
      // Liefert David-Font-Zeichen zum OLB-Zeichen Latin_Letter.
    end;

implementation

uses SysUtils, Zeichen;

// TLanguage: -------------------------------------------------------

constructor TLanguage.Create;
begin
  Letter_max := 1
end;

function TLanguage.Get_Letter_max: Byte;
begin
  Result := Letter_max
end;

function TLanguage.Get_Upper (i: Byte): string;
begin
  Result := First_Capital (Get_Lower (i))
end;

function TLanguage.Get_Random_Word (l: Byte): string;
var i: Byte; s: string;
begin
  s := '';
  for i := 1 to l do s := s + Chr (Succ (Random (Letter_max)));
  Result := s
end;

function TLanguage.Code (Latin_Letter: Char): Integer;
begin
  Result := Ord (Latin_Letter)
end;

function TLanguage.Name (Latin_Letter: Char): string;
begin
  Result := Latin_Letter
end;

function TLanguage.Read_Code (Latin_Letter: Char): Char;
begin
  Result := Latin_Letter
end;

function TLanguage.Font_Code (Latin_Letter: Char): Char;
begin
  Result := Latin_Letter
end;

function TLanguage.Code_of_OLB (s: string): string;
var Len, i: Integer;
begin
  Len := Length (s);
  Result := '';
  for i := 1 to Len do
    begin
    Result := Result + IntToStr (Code (s [i]));
    if i < Len then Result := Result + Code_Zeichen
    end
end;

function TLanguage.Total_of_OLB (s: string): Integer;
var i: Integer;
begin
  Result := 0;
  for i := 1 to Length (s) do Result := Result + Code (s [i])
end;

// TGerman: ---------------------------------------------------------

constructor TGerman.Create;
begin
  Letter_max := 26
end;

function TGerman.Get_Lower (i: Byte): string;
begin
  case i of
     1: Result := 'a';
     2: Result := 'b';
     3: Result := 'c';
     4: Result := 'd';
     5: Result := 'e';
     6: Result := 'f';
     7: Result := 'g';
     8: Result := 'h';
     9: Result := 'i';
    10: Result := 'j';
    11: Result := 'k';
    12: Result := 'l';
    13: Result := 'm';
    14: Result := 'n';
    15: Result := 'o';
    16: Result := 'p';
    17: Result := 'q';
    18: Result := 'r';
    19: Result := 's';
    20: Result := 't';
    21: Result := 'u';
    22: Result := 'v';
    23: Result := 'w';
    24: Result := 'x';
    25: Result := 'y';
    26: Result := 'z';
    else Result := ''
    end
end;

function TGerman.Order (Latin_Letter: Char): Integer;
begin
  if Latin_Letter >= 'a'
  then Result := Ord (Latin_Letter) - Ord ('a') + 1
  else Result := Ord (Latin_Letter) - Ord ('A') + 1
end;

// TGreek: ----------------------------------------------------------

constructor TGreek.Create;
begin
  Letter_max := 24
end;

function TGreek.Get_Lower (i: Byte): string;
begin // Nach K. Breest:
  case i of                  {OnLine: Lies:}
     1: Result := 'alpha';   {a       a}
     2: Result := 'beta';    {b       b}
     3: Result := 'gamma';   {g       g}
     4: Result := 'delta';   {d       d}
     5: Result := 'epsilon'; {e       e}
     6: Result := 'zeta';    {z       z}
     7: Result := 'eta';     {h       e}
     8: Result := 'theta';   {y       t}
     9: Result := 'jota';    {i       i}
    10: Result := 'kappa';   {k       k}
    11: Result := 'lambda';  {l       l}
    12: Result := 'my';      {m       m}
    13: Result := 'ny';      {n       n}
    14: Result := 'xi';      {x       x}
    15: Result := 'omicron'; {o       o}
    16: Result := 'pi';      {p       p}
    17: Result := 'rho';     {r       r}
    18: Result := 'sigma';   {s       s}
    19: Result := 'tau';     {t       t}
    20: Result := 'ypsilon'; {u       u}
    21: Result := 'phi';     {f       f}
    22: Result := 'chi';     {c       c}
    23: Result := 'psi';     {q       p}
    24: Result := 'omega';   {w       o}
    else Result := ''
    end
end;

function TGreek.Order (Latin_Letter: Char): Integer;
begin
  case Latin_Letter of
    'a': Result := 1;
    'b': Result := 2;
    'g': Result := 3;
    'd': Result := 4;
    'e': Result := 5;
    'z': Result := 6;
    'h': Result := 7;
    'y': Result := 8;
    'i': Result := 9;
    'k': Result := 10;
    'l': Result := 11;
    'm': Result := 12;
    'n': Result := 13;
    'x': Result := 14;
    'o': Result := 15;
    'p': Result := 16;
    'r': Result := 17;
    's',
    'v': Result := 18;
    't': Result := 19;
    'u': Result := 20;
    'f': Result := 21;
    'c': Result := 22;
    'q': Result := 23;
    'w': Result := 24;
    else Result := 0
    end
end;

function TGreek.Code (Latin_Letter: Char): Integer;
begin
  case Latin_Letter of
    'a': Result := 1;   // Alpha
    'b': Result := 2;   // Beta
    'g': Result := 3;   // Gamma
    'd': Result := 4;   // Delta
    'e': Result := 5;   // Epsilon
    'z': Result := 7;   // Zeta
    'h': Result := 8;   // Eta !
    'y': Result := 9;   // Theta !
    'i': Result := 10;  // Jota
    'k': Result := 20;  // Kappa
    'l': Result := 30;  // Lambda
    'm': Result := 40;  // My
    'n': Result := 50;  // Ny
    'x': Result := 60;  // Xi
    'o': Result := 70;  // Omicron
    'p': Result := 80;  // Pi
    'r': Result := 100; // Rho
    's',
    'v': Result := 200; // Sigma !
    't': Result := 300; // Tau
    'u': Result := 400; // Ypsilon !
    'f': Result := 500; // Phi
    'c': Result := 600; // Chi
    'q': Result := 700; // Psi !
    'w': Result := 800; // Omega !
    else Result := 0
    end
end;

function TGreek.Name (Latin_Letter: Char): string;
begin
  case Latin_Letter of
    'a': Result := Get_Lower (1);
    'b': Result := Get_Lower (2);
    'g': Result := Get_Lower (3);
    'd': Result := Get_Lower (4);
    'e': Result := Get_Lower (5);
    'z': Result := Get_Lower (6);
    'h': Result := Get_Lower (7);
    'y': Result := Get_Lower (8);
    'i': Result := Get_Lower (9);
    'k': Result := Get_Lower (10);
    'l': Result := Get_Lower (11);
    'm': Result := Get_Lower (12);
    'n': Result := Get_Lower (13);
    'x': Result := Get_Lower (14);
    'o': Result := Get_Lower (15);
    'p': Result := Get_Lower (16);
    'r': Result := Get_Lower (17);
    's',
    'v': Result := Get_Lower (18);
    't': Result := Get_Lower (19);
    'u': Result := Get_Lower (20);
    'f': Result := Get_Lower (21);
    'c': Result := Get_Lower (22);
    'q': Result := Get_Lower (23);
    'w': Result := Get_Lower (24);
    else Result := Blank
    end
end;

function TGreek.Read_Code (Latin_Letter: Char): Char;
begin
  case Latin_Letter of
    'h': Result := 'e'; // OLB h -> Eta
    'q': Result := 'p'; // OLB q -> Psi
    'v': Result := 's'; // OLB v -> Schuß s = Sigma
    'w': Result := 'o'; // OLB w -> Omega
    // eigentlich: 'u': Result := 'y'; // OLB u -> Ypsilon
    'y': Result := 't'; // OLB y -> Theta
    else Result := Latin_Letter
    end
end;

function TGreek.Font_Code (Latin_Letter: Char): Char;
begin
  case Latin_Letter of
    'q': Result := 'y';
    'v': Result := 'j';
    'y': Result := 'q';
    else Result := Latin_Letter
    end
end;

function TGreek.OLB_to_Symbol (Latin_Letter: Char): Char;
begin
  case Latin_Letter of
    '\':  Result := #35;
    '$':  Result := #42;
    #121: Result := #74;
    #102: Result := #106;
    #113: Result := #121;
    else  Result := Latin_Letter
    end
end;

function TGreek.OLB_to_TITUS (Latin_Letter: Char): Char;
begin
  case Latin_Letter of
    'a': Result := Chr (215);
    'b': Result := Chr (225);
    'g': Result := Chr (217);
    'd': Result := Chr (218);
    'e': Result := Chr (219);
    'z': Result := Chr (220);
    'h': Result := Chr (221);
    'y': Result := Chr (222);
    'i': Result := Chr (223);
    'k': Result := Chr (224);
    'l': Result := Chr (226);
    'm': Result := Chr (227);
    'n': Result := Chr (228);
    'x': Result := Chr (229);
    'o': Result := 'o';
    'p': Result := Chr (231);
    'r': Result := Chr (232);
    's': Result := Chr (233);
    't': Result := Chr (234);
    'u': Result := Chr (235);
    'f': Result := Chr (236);
    'c': Result := Chr (237);
    'q': Result := Chr (238);
    'w': Result := Chr (239);
    '\': Result := Chr (47);
    '$': Result := Chr (42);
    else Result := Latin_Letter
    end
end;

function TGreek.German_to_TITUS (Latin_Letter: Char): Char;
begin
  case Latin_Letter of
    'ä': Result := Chr (155);
    'ü': Result := Chr (145);
    'ö': Result := Chr (144);
    'ß': Result := Chr (225);
    '\': Result := Chr (47);
    '$': Result := Chr (42);
    else Result := Latin_Letter
    end
end;

// THebrew: ---------------------------------------------------------

constructor THebrew.Create;
begin
  Letter_max := 22
end;

function THebrew.Get_Lower (i: Byte): string;
begin
  case i of                  {OnLine: Lies:}
     1: Result := 'aleph';   {a       a}
     2: Result := 'beth';    {b       b}
     3: Result := 'gimel';   {g       g}
     4: Result := 'daleth';  {d       d}
     5: Result := 'he';      {h       h}
     6: Result := 'waw';     {w       w}
     7: Result := 'zayin';   {z       z}
     8: Result := 'cheth';   {x       c}
     9: Result := 'teth';    {j       t}
    10: Result := 'yod';     {y       y}
    11: Result := 'kaph';    {k       k}
    12: Result := 'lamedh';  {l       l}
    13: Result := 'mem';     {m       m}
    14: Result := 'nun';     {n       n}
    15: Result := 'samekh';  {o       s}
    16: Result := 'ayin';    {e       a}
    17: Result := 'peh';     {p       p}
    18: Result := 'tsadhe';  {u       t}
    19: Result := 'qoph';    {q       q}
    20: Result := 'resh';    {r       r}
    21: Result := 's(h)in';  {v       s}
    22: Result := 'tau';     {t       t}
    else Result := ''
    end
end;

function THebrew.Order (Latin_Letter: Char): Integer;
begin
  case Latin_Letter of
    'a': Result := 1;
    'b': Result := 2;
    'g': Result := 3;
    'd': Result := 4;
    'h': Result := 5;
    'w': Result := 6;
    'z': Result := 7;
    'x': Result := 8;
    'j': Result := 9;
    'y': Result := 10;
    'k',
    'K': Result := 11;
    'l': Result := 12;
    'm',
    'M': Result := 13;
    'n',
    'N': Result := 14;
    'o': Result := 15;
    'e': Result := 16;
    'p',
    'P': Result := 17;
    'u',
    'U': Result := 18;
    'q': Result := 19;
    'r': Result := 20;
    'v',
    's': Result := 21;
    't': Result := 22;
    else Result := 0
    end
end;

function THebrew.Code (Latin_Letter: Char): Integer;
begin
  case Latin_Letter of
    'a': Result := 1;
    'b': Result := 2;
    'g': Result := 3;
    'd': Result := 4;
    'h': Result := 5;
    'w': Result := 6;
    'z': Result := 7;
    'x': Result := 8;
    'j': Result := 9;
    'y': Result := 10;
    'k',
    'K': Result := 20;
    'l': Result := 30;
    'm',
    'M': Result := 40;
    'n',
    'N': Result := 50;
    'o': Result := 60;
    'e': Result := 70;
    'p',
    'P': Result := 80;
    'u',
    'U': Result := 90;
    'q': Result := 100;
    'r': Result := 200;
    'v',
    's': Result := 300;
    't': Result := 400;
    else Result := 0
    end
end;

function THebrew.Name (Latin_Letter: Char): string;
begin
  case Latin_Letter of
    'a': Result := Get_Lower (1);
    'b': Result := Get_Lower (2);
    'g': Result := Get_Lower (3);
    'd': Result := Get_Lower (4);
    'h': Result := Get_Lower (5);
    'w': Result := Get_Lower (6);
    'z': Result := Get_Lower (7);
    'x': Result := Get_Lower (8);
    'j': Result := Get_Lower (9);
    'y': Result := Get_Lower (10);
    'k',
    'K': Result := Get_Lower (11);
    'l': Result := Get_Lower (12);
    'm',
    'M': Result := Get_Lower (13);
    'n',
    'N': Result := Get_Lower (14);
    'o': Result := Get_Lower (15);
    'e': Result := Get_Lower (16);
    'p',
    'P': Result := Get_Lower (17);
    'u',
    'U': Result := Get_Lower (18);
    'q': Result := Get_Lower (19);
    'r': Result := Get_Lower (20);
    'v',
    's': Result := Get_Lower (21);
    't': Result := Get_Lower (22);
    else Result := Blank
    end
end;

function THebrew.Read_Code (Latin_Letter: Char): Char;
begin
  case Latin_Letter of
    'e': Result := 'a';
    'o': Result := 's';
    'U': Result := 'T';
    'u': Result := 't';
    'v': Result := 's';
    'x': Result := 'c';
    else Result := Latin_Letter
    end
end;

function THebrew.OLB_to_David (Latin_Letter: Char): Char;
  begin
    case Latin_Letter of
      'a': Result := Chr (224);
      'b': Result := Chr (225);
      'g': Result := Chr (226);
      'd': Result := Chr (227);
      'h': Result := Chr (228);
      'w': Result := Chr (229);
      'z': Result := Chr (230);
      'x': Result := Chr (231);
      'j': Result := Chr (232);
      'y': Result := Chr (233);
      'K': Result := Chr (234); // am Wortende.
      'k': Result := Chr (235);
      'l': Result := Chr (236);
      'M': Result := Chr (237); // am Wortende.
      'm': Result := Chr (238);
      'N': Result := Chr (239); // am Wortende.
      'n': Result := Chr (240);
      'o': Result := Chr (241);
      'e': Result := Chr (242);
      'P': Result := Chr (243); // am Wortende.
      'p': Result := Chr (244);
      'U': Result := Chr (245); // am Wortende.
      'u': Result := Chr (246);
      'q': Result := Chr (247);
      'r': Result := Chr (248);
      'v',
      's': Result := Chr (249);
      't': Result := Chr (250);
      else Result := Latin_Letter
      end
end;

end.
