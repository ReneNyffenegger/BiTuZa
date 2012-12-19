unit Bibel;

{ Cluster: Bibel
}
{ Explanation:
    Konstanten, Typen und Klassen für Bibel-Programme.
    Die Bibel umfaßt Altes Testament (AT) und Neues Testament (NT).
    Als Textbasis dient die Online Bible (OLB).
    Features:
    - Get_Book_of
    Klassen:
    - TBiblestructure (Beschreibt die Kapitel/Vers-Struktur)
    - TAbstract_Bible (Abstrakte Klasse für ein Buch der Bibel)
    - TBible     (Stellt ein Buch der Bibel für
                  eine TRichEdit-Box bereit)
    - TBiblebook (Stellt ein Buch der Bibel zum Zugriff auf
                  Kapitel und Vers bereit)
}
{ Indexing:
    Keywords: Bibel
    Author  : Dr. P.G. Zint
    Street  : Dresselndorfer Str. 3
    City    : 57299 Burbach
    Created : 30.03.1997
    Revised : 15.10.2011
    Compile : Delphi 7
}
{ Changing:
    14.10.1997 Testamenttyp neu
    26.10.1997 Urtext neu
    31.10.1997 TBibel neu
    02.11.1997 Ohne Urtext
    16.11.1997 Bibeltexte auf ..\Bibel
    22.11.1997 Luther neu
    11.03.1998 Neue Subdirectory-Struktur für Biblepath
    07.01.2000 Einrahmungszeichen definiert.
    29.01.2000 TAbstract_Bible neu.
    13.02.2000 Get_Book_of neu
    01.02.2001 Get_Book_of_Short neu
    13.02.2001 Get_Verstext ohne Leerzeilen.
    21.04.2002 ..._as_String neu
    15.10.2011 Short_Biblebook neu
    }

interface

uses
   ComCtrls, Classes, Language;

const
  Biblepath   = '..\'; // Pfad der Bibelquellen.
  Struct_Path = Biblepath + '\Struktur\'; // Pfad der Strukturdateien.
  Struct_Ext  = '_s'; // Extensionergänzung für Strukturdatei.

  Transl_max   = 4; // Anzahl der möglichen Versionen:
  Rev_Elb_Tran = 1; // Revidierte Elberfelder Übersetzung.
  Alt_Elb_Tran = 2; // Nicht Rev. Elberfelder Übersetzung.
  Urtext_Orig  = 3; // AT: Hebräisch, NT: Griechisch.
  Luther_Tran  = 4; // Luther-Übersetzung.

  Buch_max    =   66; // Anzahl der Bücher der Bibel.
  AT_Buch_max =   39; // Anzahl der Bücher des AT.
  NT_Buch_max =   27; // Anzahl der Bücher des NT.
  Kapitel_max =  150; // Kapitel des längsten Buchs.
  Vers_max    = 2600; // Verse des längsten Buchs.

  Transl_Ext // File-Extensions der Übersetzungen:
    : array [1 .. Transl_max] of ShortString =
    (
     '.txt', // Revidierte Elberfelder.
     '.elb', // Alte (nicht rev.) Elberfelder.
     '.urt', // Urtext.
     '.lut'  // Luther.
    );

  Transl_Name // Bezeichnung der Übersetzungen:
    : array [1 .. Transl_max] of ShortString =
    ('Rev. Elberfelder Übersetzung',
     'Alte Elberfelder Übersetzung',
     'Urtext Hebräisch/Griechisch',
     'Luther-Übersetzung'
    );

  Buch // DOS-Namen (max. 8 Zeichen) der Bibelbücher:
    : array [1 .. Buch_max] of ShortString =
    ('1mose',    '2mose',    '3mose',    '4mose',    '5mose',    'josua',
     'richter',  'ruth',     '1samuel',  '2samuel',  '1koenig',  '2koenig',
     '1chronik', '2chronik', 'esra',     'nehemia',  'esther',   'hiob',
     'psalm',    'spruch',   'prediger', 'hoheslie', 'jesaja',   'jeremia',
     'klagelie', 'hesekiel', 'daniel',   'hosea',    'joel',     'amos',
     'obadja',   'jona',     'micha',    'nahum',    'habakuk',  'zephanja',
     'haggai',   'sacharja', 'maleachi', 'matth',    'markus',   'lukas',
     'johannes', 'apostel',  'roemer',   '1korinth', '2korinth', 'galater',
     'epheser',  'philippe', 'kolosser', '1thessal', '2thessal', '1timothe',
     '2timothe', 'titus',    'philemon', 'hebraer',  'jakobus',  '1petrus',
     '2petrus',  '1johann',  '2johann',  '3johann',  'judas',    'offenbar');

  Long_Biblebook // (Lang-)Namen der Bibelbücher:
    : array [1 .. Buch_max] of ShortString =
    ('1. Mose', '2. Mose', '3. Mose', '4. Mose', '5. Mose',
     'Josua', 'Richter', 'Ruth', '1. Samuel', '2. Samuel',
     '1. Könige', '2. Könige', '1. Chronika', '2. Chronika', 'Esra',
     'Nehemia', 'Esther', 'Hiob', 'Psalm', 'Sprüche',
     'Prediger', 'Hoheslied', 'Jesaja', 'Jeremia', 'Klagelieder',
     'Hesekiel', 'Daniel', 'Hosea', 'Joel', 'Amos',
     'Obadja', 'Jona', 'Micha', 'Nahum', 'Habakuk',
     'Zephanja', 'Haggai', 'Sacharja', 'Maleachi',
     'Matthäus', 'Markus', 'Lukas', 'Johannes', 'Apostelgeschichte',
     'Römer', '1. Korinther', '2. Korinther', 'Galater', 'Epheser',
     'Philipper', 'Kolosser', '1. Thessalonicher',
     '2. Thessalonicher', '1. Timotheus', '2. Timotheus', 'Titus',
     'Philemon', 'Hebräer',  'Jakobus', '1. Petrus', '2. Petrus',
     '1. Johannes', '2. Johannes', '3. Johannes', 'Judas',
     'Offenbarung');

  Short_Biblebook // (Kurz-)Namen der Bibelbücher:
    : array [1 .. Buch_max] of ShortString =
    ('1Mos', '2Mos', '3Mos', '4Mos', '5Mos',
     'Josu', 'Rich', 'Ruth', '1Sam', '2Sam',
     '1Kön', '2Kön', '1Chr', '2Chr', 'Esra',
     'Nehe', 'Esth', 'Hiob', 'Psal', 'Sprü',
     'Pred', 'Hohe', 'Jesa', 'Jere', 'Klag',
     'Hese', 'Dani', 'Hose', 'Joel', 'Amos',
     'Obad', 'Jona', 'Mich', 'Nahu', 'Haba',
     'Zeph', 'Hagg', 'Sach', 'Male',
     'Matt', 'Mark', 'Luka', 'Joha', 'Apos',
     'Röme', '1Kor', '2Kor', 'Gala', 'Ephe',
     'Plip', 'Kolo', '1The', '2The', '1Tim',
     '2Tim', 'Titu', 'Plem', 'Hebr', 'Jako',
     '1Pet', '2Pet', '1Joh', '2Joh', '3Joh',
     'Juda', 'Offe');

  Chapter_Char = '\'; // Einrahmungszeichen des Kapitels.
     Vers_Char = '$'; // Einrahmungszeichen der Versnummer.

type
  Testamenttyp =
    (Ganze_Bibel, Altes_Testament, Neues_Testament);

  TChapter_Structure = record
    Index, // Index in Vers_Lines.
    v      // Anzahl der Verse zu diesem Kapitel.
      : Integer;
    end;

  TVers_Structure = record
    k,  // Kapitel.
    v,  // Vers.
    l1, // Anfangszeile.
    l2  // Endezeile
      : Integer;
    end;

  TBiblestructure = class
    Chapter   // Anzahl der Kapitel im aktuellen Buch.
      : Integer;
    procedure Clear; // Setzt Vers_Count = 0.
    procedure Read_Structure (Name: string);
      // Liest Strukturdatei zum Buch Name und füllt Vers_Lines.
    function  Get_Vers_of (k: Integer): Integer;
      // Liefert Verse zu Kapitel k.
    procedure Lines_of (k, v1, v2: Integer; var l1, l2: Integer);
      // Liefert Zeilen l1 .. l2 zu Kapitel k mit Versen v1 .. v2.
  private
    Vers_Count // Anzahl der gültigen Einträge in Vers_Lines.
      : Integer;
    Chapter_Indices: array [1 .. Kapitel_max] of TChapter_Structure;
    Vers_Lines: array [1 .. Vers_max] of TVers_Structure;
      { Zeigt mit l1 und l2 auf Text in TBiblebook }
    end;

  TAbstract_Bible = class
    constructor Create (t: Integer); // Translation = t, Book = 1.
    function  Is_AT: Boolean;
    function  Is_NT: Boolean;
    procedure Set_Book (b: Integer);
      // Setzt Book = b, Chapter = 1, Vers = 1 und ruft Set_Names auf.
    procedure Set_Translation (t: Integer);
      // Setzt Translation = t und ruft Set_Names auf.
    function  Get_Bookname:  string; // Liefert Bookname.
    function  Get_Biblename: string; // Liefert Biblename.
    function  Get_Filename:  string; // Liefert Filename.
    function  Get_Book: Integer; // Liefert Book.
  protected
    Bookname,  // DOS-Name des Buches der Bibel.
    Shortname, // Kurzform vom Bookname.
    Biblename, // Name der Bibelübersetzung oder Urtext.
    Filename   // Filename des aktuellen Bibelbuchs.
      : string;
    Translation, // Index der Bibelübersetzung.
    Book,        // Index des aktuellen Bibelbuchs.
    Chapter,     // Aktuelles Kapitel.
    Vers         // Aktueller Vers.
      : Integer;
    procedure Read_Book; virtual; abstract;
      // Liest das Bibelbuch für Translation und Book ein.
    procedure Set_Names;
      // Setzt alle Namen (...name) aufgrund von Translation und Book.
    end;

  TBiblebook = class (TAbstract_Bible)
    constructor Create; // Translation = Rev_Elb_Tran, Book = 1.
    destructor  Destroy; override;
    procedure Load_Book (b, t: Integer);
      // Liest ggf. Buch b in Übersetzung t neu ein.
    procedure Load_Book_Struct (b, t: Integer);
      // Liest ggf. Buch b in Übersetzung t mit Struktur neu ein.
    procedure Generate_Structure;
      // Erzeugt Strukturdatei zum Buch (Siehe Implementation).
    function  Get_Chapters: Integer; // Liefert Kapitelzahl des Buchs.
    function  Get_Vers_of (k: Integer): Integer;
      // Liefert Verse zu Kapitel k.
    procedure Lines_of (k, v1, v2: Integer; var l1, l2: Integer);
      // Liefert Zeilen l1 .. l2 zu Kapitel k mit Versen v1 .. v2.
    function  Get_Text: TStringList; // Liefert Bibeltext des Buchs.
    function  Get_Verstext (k, v1, v2: Integer; t: Boolean): TStringList;
      // Liefert Bibeltext für Verse v1 .. v2 in Kapitel k
      // mit Überschrift aus Buch, Kapitel und Vers bei t = True.
  protected
    Verstext, // Enthält den Text eines Kapitels zwischen Versen.
    Text: TStringList;
    Line: string; // Aktuelle Zeile in Text.
    Structure: TBiblestructure;
    Loaded: Boolean; // Text eingelesen?
    procedure Read_Book; override; // Liest Buch nach Text.
    procedure Read_Structure;
      // Liest Strukturdatei zum Buch und füllt Structure.
    function Is_Chapter: Boolean;
      // Aktuelle Zeile ist Kapitelzeile? Wenn ja, Chapter ermitteln.
    function Is_Vers: Boolean;
      // Aktuelle Zeile ist Versanfang? Wenn ja, Vers ermitteln.
    function Get_Chapter: Integer; // Liefert Chapter.
    end;

  TBible = class (TAbstract_Bible)
    constructor Create (e: TRichEdit; t: Integer; p: string);
      // Bibelbuch mit Translation t und Path p; Anzeige in e.
    function  Versname: string; // Shortname.K."Kapitel".V."Vers".
    procedure Read_Book; override; // Zeigt "Path + Filename" in Box.
  protected
    Path: string;
    Box: TRichEdit; // Anzeigebox.
    end;

function Get_Book_of (b: string): Integer;
  // Liefert Index für ein Buch b (aus den Buch-Array) oder 1.
function Get_Book_of_Short (b: string): Integer;
  { Liefert Index für ein Buch b oder 0. b muß (nicht Case-sensitv)
    mit einem Anfang von Buch [] übereinstimmen }
function Book_as_String (b: Integer): string;
  // Liefert Buch b als 2-stellige Zahl (01 .. 66).
function Chapter_as_String (c: Integer): string;
  // Liefert Kapitel c als 3-stellige Zahl (001 .. 150).
function Vers_as_String (v: Integer): string;
  // Liefert Vers v als 3-stellige Zahl (001 .. 999).
function Code_as_String (v: Integer): string;
  // Liefert Bibelcode v als 3-stellige Zahl (001 .. 999).
function Word_Code_as_String (v: Integer): string;
  // Liefert Bibelcode v eines Wortes als 4-stellige Zahl (0001 .. 9999).
function Total_as_String (v: Integer): string;
  // Liefert Totalcode v als 7-stellige Zahl (0000001 .. 9999999).

implementation

uses Zeichen, Numbers, SysUtils, Dialogs;

function Get_Book_of (b: string): Integer;
var i: Integer; Found: Boolean;
begin
  Found := False;
  i := 1;
  while (i <= Buch_max) and not Found do
    if b = Buch [i]
    then Found := True
    else Inc (i);
  Result := i
end;

function Get_Book_of_Short (b: string): Integer;
var i: Integer; Found: Boolean;
begin
  Found := False;
  i := 1;
  while (i <= Buch_max) and not Found do
    if Pos (Lower_String (b), Buch [i]) > 0
    then Found := True
    else Inc (i);
  if Found
  then Result := i
  else Result := 0
end;

function Book_as_String (b: Integer): string;
begin
  Result := LeadingZero (b, 2)
end;

function Chapter_as_String (c: Integer): string;
begin
  Result := LeadingZero (c, 3)
end;

function Vers_as_String (v: Integer): string;
begin
  Result := LeadingZero (v, 3)
end;

function Code_as_String (v: Integer): string;
begin
  Result := LeadingZero (v, 3)
end;

function Word_Code_as_String (v: Integer): string;
begin
  Result := LeadingZero (v, 4)
end;

function Total_as_String (v: Integer): string;
begin
  Result := LeadingZero (v, 7)
end;

// TBiblestructure: -------------------------------------------------

procedure TBiblestructure.Clear;
begin
  Vers_Count := 0
end;

procedure TBiblestructure.Read_Structure (Name: string);
var Vers, i, l: Integer; s: string; Struct: TStringList;
begin
  s := Name + Struct_Ext;
  if FileExists (s)
  then
    begin
    Struct := TStringList.Create;
    Struct.LoadFromFile (s);
    Chapter    := 0;
    Vers_Count := 0;
    for i := 0 to Pred (Struct.Count) do
      begin
      s := Struct [i];
      l := Length (s);
      if Pos (Chapter_Char, s) = 1
      then Inc (Chapter);
      if Pos (Vers_Char, s) = 1
      then
        begin
        Inc (Vers_Count);
        if Vers_Count > Vers_max
        then
          begin
          ShowMessage ('Anzahl der Verse > ' + IntToStr (Vers_max));
          Vers_Count := Vers_max
          end;
        Vers := StrToIntDef (Copy (s, 2, l), 1);
        with Vers_Lines [Vers_Count] do
          begin
          k := Chapter;
          v := Vers
          end
        end;
      if Pos ('[', s) = 1
      then Vers_Lines [Vers_Count].l1 := StrToIntDef (Copy (s, 2, l), 1);
      if Pos (']', s) = 1
      then Vers_Lines [Vers_Count].l2 := StrToIntDef (Copy (s, 2, l), 1);
      end;
    Chapter := 0;
    for i := 1 to Vers_Count do
      begin
      Chapter := Vers_Lines [i].k;
      if Chapter <= Kapitel_max then with Chapter_Indices [Chapter] do
        begin
        if Vers_Lines [i].v = 1
        then Index := i
        else v := Vers_Lines [i].v
        end
      end;
    Struct.Free
    end
  else ShowMessage ('Strukturdatei ' + s + ' fehlt')
end;

function TBiblestructure.Get_Vers_of (k: Integer): Integer;
begin
  Result := Chapter_Indices [k].v
end;

procedure TBiblestructure.Lines_of (k, v1, v2: Integer; var l1, l2: Integer);
var i: Integer;
begin
  i := Chapter_Indices [k].Index;
  l1 := Vers_Lines [i + Pred (v1)].l1;
  l2 := Vers_Lines [i + Pred (v2)].l2;
end;

// TAbstract_Bible: -------------------------------------------------

constructor TAbstract_Bible.Create (t: Integer);
begin
  Translation := t; // Muß als erste definiert werden!
  Set_Book (1)
end;

function TAbstract_Bible.Is_NT: Boolean;
begin
  Result := Book > AT_Buch_max
end;

function TAbstract_Bible.Is_AT: Boolean;
begin
  Result := not Is_NT
end;

procedure TAbstract_Bible.Set_Book (b: Integer);
begin
  if (b > 0) and (b <= Buch_max)
  then
    begin
    Book    := b;
    Chapter := 1;
    Vers    := 1;
    Set_Names
    end
end;

procedure TAbstract_Bible.Set_Translation (t: Integer);
begin
  Translation := t;
  Set_Names
end;

procedure TAbstract_Bible.Set_Names;
begin
   Bookname  := Buch [Book];
   Shortname := Copy (Bookname, 1, 3);
   Biblename := Transl_Name [Translation];
   Filename  := Bookname + Transl_Ext [Translation]
end;

function TAbstract_Bible.Get_Bookname: string;
begin
  Result := Bookname
end;

function TAbstract_Bible.Get_Biblename: string;
begin
  Result := Biblename
end;

function TAbstract_Bible.Get_Filename: string;
begin
  Result := Filename
end;

function TAbstract_Bible.Get_Book: Integer;
begin
  Result := Book
end;

// TBible: ----------------------------------------------------------

constructor TBible.Create (e: TRichEdit; t: Integer; p: string);
begin
  inherited Create (t);
  Box  := e;
  Path := p
end;

procedure TBible.Read_Book;
begin
  Box.Lines.LoadFromFile (Path + Filename)
end;

function TBible.Versname: string;
begin
  Result := Shortname + '.' + IntToStr (Chapter) +
            '.' + IntToStr (Vers)
end;

// TBiblebook: ------------------------------------------------------

constructor TBiblebook.Create;
begin
  inherited Create (Rev_Elb_Tran);
  Loaded    := False;
  Structure := TBiblestructure.Create;
  Verstext  := TStringList.Create;
  Text      := TStringList.Create
end;

destructor TBiblebook.Destroy;
begin
  Structure.Free;
  Verstext.Free;
  Text.Free;
  inherited Destroy
end;

procedure TBiblebook.Load_Book (b, t: Integer);
begin
  if not Loaded or (Book <> b) or (Translation <> t)
  then
    begin
    Translation := t;
    Set_Book (b);
    Read_Book
    end
end;

procedure TBiblebook.Load_Book_Struct (b, t: Integer);
begin
  if not Loaded or (Book <> b) or (Translation <> t)
  then
    begin
    Translation := t;
    Set_Book (b);
    Read_Book;
    Read_Structure
    end
end;

procedure TBiblebook.Read_Book;
begin
  Structure.Clear;
  Loaded := True;
  Text.LoadFromFile (Biblepath + Filename)
end;

procedure TBiblebook.Generate_Structure;
{ Die Kapitel/Vers/Zeile-Struktur zu jedem Buch der Bibel besteht
  aus einer Folge von Einträgen:
  \"nr"["l"] (Zeile l zum Kapitel "nr", Zeilenzählung beginnt mit 0)
  $"nr" (Vers "nr")
  ["nr" (Zeile "nr" zum Versanfang)
  ]"nr" (Zeile "nr" zum Versende)
}
var i: Integer;
  Struct: TStringList; // Liste der Strukturdaten Kapitel, Vers;
  Start: Boolean; // Versstart?
begin
  Read_Book;
  Struct := TStringList.Create;
  Start := True;
  for i := 0 to Pred (Text.Count) do
    begin
    Line := Text [i];
    if Is_Chapter
    then
      begin
      if not Start then Struct.Add (']' + IntToStr (Pred (i)));
      Struct.Add (Chapter_Char + IntToStr (Chapter) +
                 '[' + IntToStr (i) + ']');
      Start := True;
      end;
    if Is_Vers
    then
      begin
      if not Start then Struct.Add (']' + IntToStr (Pred (i)));
      Struct.Add (Vers_Char + IntToStr (Vers));
      Struct.Add ('[' + IntToStr (i));
      Start := False
      end
    end;
  Struct.Add (']' + IntToStr (Pred (Text.Count)));
  Struct.SaveToFile (Filename + Struct_Ext);
  Struct.Free
end;

procedure TBiblebook.Read_Structure;
begin
  Structure.Read_Structure (Struct_Path + Filename)
end;

function TBiblebook.Get_Chapters: Integer;
begin
  Result := Structure.Chapter
end;

function TBiblebook.Get_Vers_of (k: Integer): Integer;
begin
  Result := Structure.Get_Vers_of (k)
end;

procedure TBiblebook.Lines_of (k, v1, v2: Integer; var l1, l2: Integer);
begin
  Structure.Lines_of (k, v1, v2, l1, l2)
end;

function TBiblebook.Get_Verstext (k, v1, v2: Integer; t: Boolean): TStringList;
var i, l1, l2: Integer;

  procedure Show_Chapter;
  begin
     Verstext.Add (Long_Biblebook [Book] +
       ': Kapitel \' + IntToStr (k) + '\');
     Verstext.Add ('')
  end;

begin
  Structure.Lines_of (k, v1, v2, l1, l2);
  Verstext.Clear;
  if t then Show_Chapter;
  for i := l1 to l2 do
    begin
    if Is_not_Blank (Text [i]) then Verstext.Add (Text [i])
    end;
  Result := Verstext
end;

function TBiblebook.Get_Text: TStringList;
begin
  Result := Text
end;

// TBiblebook: Private Features: ------------------------------------

function TBiblebook.Is_Chapter: Boolean;
var p: Integer; s: string;
begin
  p := Pos  (Chapter_Char, Line);
  s := Copy (Line, Succ (p), Length (Line));
  p := Pos  (Chapter_Char, s);
  s := Copy (s, 1, Pred (p));
  Chapter := StrToIntDef (s, 1);
  Result := p > 0
end;

function TBiblebook.Is_Vers: Boolean;
var p: Integer; s: string;
begin
  p := Pos  (Vers_Char, Line);
  s := Copy (Line, Succ (p), Length (Line));
  p := Pos  (Vers_Char, s);
  s := Copy (s, 1, Pred (p));
  Vers := StrToIntDef (s, 1);
  Result := p > 0
end;

function TBiblebook.Get_Chapter: Integer;
begin
  Result := Chapter
end;

end.
