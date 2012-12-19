unit UnitExtraktor;

{
Suchen und Extrahieren in *.TuZ-Dateien *.TuZ auf ..\TuZ
Dabei wird die Struktur-Datei BiTuZa.Struktur auf ..\Struktur benötigt.
Zur Anzeige kommen die Lexika *.Lex auf ..\Lexikon\
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  Zeichen, StringUnit, Bibel, ExtCtrls, Menus;

const
  Dir_TuZ='..\TuZ\';
  Dir_Lexikon='..\Lexika\';
  Name_Info='Info.txt';
  Name_Struktur='..\Struktur_Generator\BiTuZa.Struktur';
  OutName='BiTuZa.Extract'; // Name der Ausgabe-Datei
type
  TForm1 = class(TForm)
  VonLabel: TLabel;
    VonBuch: TComboBox;
    ButtonGenerate: TButton;
    BisLabel: TLabel;
    BisBuch: TComboBox;
    KapitelLabel: TLabel;
    VonKapitel: TComboBox;
    BisKapitel: TComboBox;
    VersLabel: TLabel;
    WortLabel: TLabel;
    VonVers: TComboBox;
    BisVers: TComboBox;
    VonWort: TComboBox;
    BisWort: TComboBox;
    Bibelstellen: TRadioGroup;
    Kriterien: TRadioGroup;
    SuchLabel: TLabel;
    SuchBox: TComboBox;
    Optionen: TGroupBox;
    Kurzform: TCheckBox;
    Header: TCheckBox;
    Format: TGroupBox;
    TuZStatistik: TCheckBox;
    Totalwert: TCheckBox;
    Zahlencode: TCheckBox;
    Grundtext: TCheckBox;
    Deutsch: TCheckBox;
    BuchstabenCheck: TCheckBox;
    Auswertung: TCheckBox;
    MainMenu1: TMainMenu;
    Datei: TMenuItem;
    Lexikon: TMenuItem;
    Hilfe: TMenuItem;
    Speichern: TMenuItem;
    ATTW: TMenuItem;
    NTTW: TMenuItem;
    BibelTW: TMenuItem;
    ATCode: TMenuItem;
    NTCode: TMenuItem;
    BibelCode1: TMenuItem;
    ATWort: TMenuItem;
    NTWort: TMenuItem;
    BibelWort: TMenuItem;
    Info: TMenuItem;
    Version: TMenuItem;
    SaveDialog1: TSaveDialog;
    ListBox: TListBox;
    Anzeigen: TButton;
    LabelName: TLabel;
    Wortwahl: TButton;
    procedure FillKapitel(BoxBuch,BoxKapitel:TComboBox);
      // Füllt BoxKapitel mit Kapitelnummern des Bibelbuchs BoxBuch.Text
    procedure FillVers(BoxBuch,BoxKapitel,BoxVers:TComboBox);
      // Füllt BoxVers mit Versnummern des Kapitels
      // BoxBuch.Text/BoxKapitel.Text
    procedure FillWort(BoxBuch,BoxKapitel,BoxVers,BoxWort:TComboBox);
      // Füllt BoxWort mit Wortanzahlen des Verses
      // BoxBuch.Text/BoxKapitel.Text/BoxVers.Text
    procedure LoadLexikon(Name,Text:string);
    procedure InSuchBoxeintragen(s:string);
      // Trägt s in die Liste der SuchBox ein
    procedure EnableBoxes; // Alle Boxen auf Enable
    procedure DisableBoxes; // Alle Boxen auf Disable
    procedure FormActivate(Sender: TObject);
    procedure ButtonGenerateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure VonBuchChange(Sender: TObject);
    procedure BisBuchChange(Sender: TObject);
    procedure VonKapitelChange(Sender: TObject);
    procedure BisKapitelChange(Sender: TObject);
    procedure VonVersChange(Sender: TObject);
    procedure BisVersChange(Sender: TObject);
    procedure BibelstellenClick(Sender: TObject);
    procedure KriterienClick(Sender: TObject);
    procedure SpeichernClick(Sender: TObject);
    procedure VersionClick(Sender: TObject);
    procedure AnzeigenClick(Sender: TObject);
    procedure InfoClick(Sender: TObject);
    procedure ATTWClick(Sender: TObject);
    procedure NTTWClick(Sender: TObject);
    procedure BibelTWClick(Sender: TObject);
    procedure ATCodeClick(Sender: TObject);
    procedure NTCodeClick(Sender: TObject);
    procedure BibelCode1Click(Sender: TObject);
    procedure ATWortClick(Sender: TObject);
    procedure NTWortClick(Sender: TObject);
    procedure BibelWortClick(Sender: TObject);
    procedure WortwahlClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  Book: Integer; // Nummer des Bibelbuchs in der Bibel
  OutList,StructList, Struktur:TStringList;

implementation

{$R *.dfm}

function GetBoxIndex(Box:TComboBox):Integer;
// Liefert den Index (0, ...) von Text in der Box
var b:Integer;
begin
  Result:=-1;
  for b:=0 to Pred(Box.Items.Count) do
    if Box.Items[b]=Box.Text then Result:=b;
  end;

function GetFileName(b:Integer):string;
// Liefert den Dateinamen zur Nummer (1 ...) des Bibelbuchs
  var s:string;
  begin
  if b < 10
  then s:= 'AT 0'+ IntToStr(b)+' '+Long_BibleBook[b]+'.TuZ'
  else
    begin
    if b <= AT_Buch_max
    then s:= 'AT '+ IntToStr(b)+' '+Long_BibleBook[b]+'.TuZ'
    else s:= 'NT '+ IntToStr(b)+' '+Long_BibleBook[b]+'.TuZ'
    end;
  Result:=s
end;

procedure SetAnfang(Box:TComboBox);
begin
Box.Text:=Box.Items[0];
end;

procedure SetEnde(Box:TComboBox);
begin
Box.Text:=Box.Items[Pred(Box.Items.Count)];
end;

procedure FillBooks(Box:TComboBox);
// Büchernamen in Box.Items füllen
var b:Integer;
begin
for b:=1 to Buch_max do
  begin
  Box.Items.Add(Long_BibleBook[b]);
  end;
end;

function BoxOk(Box:TComboBox):Boolean;
begin
  Result:=GetBoxIndex(Box)>=0
end;

// -------------------------------------------------------------------------

procedure TForm1.FillKapitel(BoxBuch,BoxKapitel:TComboBox);
var i,Nr:Integer;s:string;
begin
BoxKapitel.Items.Clear;
s:= IntToStr(Succ(GetBoxIndex(BoxBuch)))+'.';
i:=0;
Nr:=1;
while (i<Struktur.Count) do
  begin
  if Pos(s+IntToStr(Nr)+'.',Struktur[i])=1
  then
    begin
    BoxKapitel.Items.Add(IntToStr(Nr));
    Inc(Nr);
    end;
  Inc(i);
  end;
end;

procedure TForm1.FillVers(BoxBuch,BoxKapitel,BoxVers:TComboBox);
var i,Nr:Integer;s:string;
begin
BoxVers.Items.Clear;
s:= IntToStr(Succ(GetBoxIndex(BoxBuch)))+'.'+BoxKapitel.Text+'.';
i:=0;
Nr:=1;
while (i<Struktur.Count) do
  begin
  if Pos(s+IntToStr(Nr)+'.',Struktur[i])=1
  then
    begin
    BoxVers.Items.Add(IntToStr(Nr));
    Inc(Nr);
    end;
  Inc(i);
  end;
end;

procedure TForm1.FillWort(BoxBuch,BoxKapitel,BoxVers,BoxWort:TComboBox);
var i,L,Nr:Integer;s:string;
begin
BoxWort.Items.Clear;
s:=IntToStr(Succ(GetBoxIndex(BoxBuch)))+'.'+BoxKapitel.Text+'.'+
   BoxVers.Text+'.';
L:=Length(s);
i:=0;
while (i<Struktur.Count) do
  begin
  if Pos(s,Struktur[i])=1
  then
    begin
    s:= Struktur[i];
    System.Delete(s,1,L);
    for Nr:= 1 to StrToInt(s) do
      BoxWort.Items.Add(IntToStr(Nr));
    i:=Struktur.Count;
    end;
  Inc(i);
  end;

end;

procedure TForm1.EnableBoxes;
begin
VonBuch.Enabled:=True;
VonKapitel.Enabled:=True;
VonVers.Enabled:=True;
VonWort.Enabled:=True;
BisBuch.Enabled:=True;
BisKapitel.Enabled:=True;
BisVers.Enabled:=True;
BisWort.Enabled:=True;
end;

procedure TForm1.DisableBoxes;
begin
VonBuch.Enabled:=False;
VonKapitel.Enabled:=False;
VonVers.Enabled:=False;
VonWort.Enabled:=False;
BisBuch.Enabled:=False;
BisKapitel.Enabled:=False;
BisVers.Enabled:=False;
BisWort.Enabled:=False;
end;

procedure TForm1.InSuchBoxeintragen(s:string);
var i:Integer;gefunden:Boolean;
begin
  gefunden:=False;
  for i:=0 to Pred(SuchBox.Items.Count) do
    if s=SuchBox.Items[i] then gefunden:=True;
  if not gefunden then SuchBox.Items.Add(s)
end;

// -------------------------------------------------------------------------

procedure TForm1.FormActivate(Sender: TObject);
var i,c1,c2:Integer;s:string;
begin
// Struktur wird aus StructList erzeugt.
// Das Format von Struktur ist:
// BuchNr.KapitelNr.VersNr.Wortanzahl

StructList:=TStringList.Create;
StructList.LoadFromFile(Name_Struktur);
Struktur:=TStringList.Create;
OutList:=TStringList.Create;
for i:=0 to Pred(StructList.Count) do
  begin
  s:=StructList[i];
  c1:=Pos(' ',s);
  System.Delete(s,1,c1);
  c1:=Pos(' ',s);
  System.Insert('.',s,c1);
  c2:=Pos('-- ',s);
  System.Delete(s,c1+1,c2-c1+2);
  c1:=Pos(' ',s);
  c2:=Pos(').',s);
  if c1>0 then System.Delete(s,c1,c2-c1+1);
  Struktur.Add(s);
  end;

// ComboBoxen füllen:
FillBooks(VonBuch);
SetAnfang(VonBuch);
FillKapitel(VonBuch,VonKapitel);
SetAnfang(VonKapitel);
FillVers(VonBuch,VonKapitel,VonVers);
SetAnfang(VonVers);
FillWort(VonBuch,VonKapitel,VonVers,VonWort);
SetAnfang(VonWort);

FillBooks(BisBuch);
SetEnde(BisBuch);
FillKapitel(BisBuch,BisKapitel);
SetEnde(BisKapitel);
FillVers(BisBuch,BisKapitel,BisVers);
SetEnde(BisVers);
FillWort(BisBuch,BisKapitel,BisVers,BisWort);
SetEnde(BisWort);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
;
end;

// -------------------------------------------------------------------------
// Erzeugt Strukturdatei

procedure TForm1.ButtonGenerateClick(Sender: TObject);
const
  BuchNr = 1; // Nummern von VonIndex
  KapitelNr = 2;
  VersNr = 3;
  WortNr = 4;
var InpList:TStringList;
  BuchN, // Laufende Nummer des Bibelbuchs bei der Suche
  KapitelN, // Laufende Kapitelnummer
  VersN, // Laufende Versnummer
  BuchZahl,
  KapitelZahl, // für Statistik
  Fundstellen, // für Suchstatistik
  i:Integer;
  VersZahl, // für Statistik
  WortZahl, // für Statistik
  BuchstabenZahl, // für Statistik
  TWZahl, // für Statistik
  HebrTWZahl:Int64; // Hebräische Summe für Statistik

  BuchKapitel, // Buch.Kapitel vor der neuen Versausgabe
  s:string;
  Suche:Boolean;
  VonN:array[BuchNr..WortNr] of Integer; // Nummer von VonBuch .. VonWort
  BisN:array[BuchNr..WortNr] of Integer; // Nummer von BisBuch .. BisWort

  function BibelstellenOk: Boolean; // ButtonGenerateClick/BibelstellenOk
  // Sind die Bibelstellen korrekt eingegeben?
  begin
    Result:=False;
    if
      BoxOk(VonBuch) and BoxOk(VonKapitel) and
      BoxOk(VonVers) and BoxOk(VonBuch) and
      BoxOk(BisBuch) and BoxOk(BisKapitel) and
      BoxOk(BisVers) and BoxOk(BisBuch) and
      (GetBoxIndex(VonBuch)<=GetBoxIndex(BisBuch))
    then
      begin
      if (GetBoxIndex(VonBuch)<GetBoxIndex(BisBuch))
      then Result:=True
      else // Anfangsbuch = Endebuch
        begin
        if (GetBoxIndex(VonKapitel)<GetBoxIndex(BisKapitel))
        then Result:=True
        else // Anfangskapitel >= EndeKapitel
          begin
          if (GetBoxIndex(VonKapitel)=GetBoxIndex(BisKapitel))
          then // Anfangskapitel = EndeKapitel
            begin
            if (GetBoxIndex(VonVers)<=GetBoxIndex(BisVers))
            then Result:=True
            end
          end
        end
      end
  end; // ButtonGenerateClick/BibelstellenOk

  function IsVersSelected:Boolean;// ButtonGenerateClick/IsVersSelected
  var L:Integer;
    VersZeile:string; // Zur Ermittlung von Buchnummer,Kapitelnummer.Versnummer

    function IsInLowerBound:Boolean; // ButtonGenerateClick/IsInLowerBound
      begin
        if VonN[BuchNr]>BuchN
        then Result:=False
        else
          begin
          if VonN[BuchNr]<BuchN
          then Result:=True
          else // VonN[BuchNr]=BuchN
            begin
            if VonN[KapitelNr]>KapitelN
            then Result:=False
            else
              begin
              if VonN[KapitelNr]<KapitelN
              then Result:=True
              else //VonN[KapitelNr]=KapitelN
                Result:=VonN[VersNr]<=VersN
              end
            end
          end;
     end; // ButtonGenerateClick/IsVersSelected/IsInLowerBound

    function IsInUpperBound:Boolean;
      // ButtonGenerateClick/IsVersSelected/IsInUpperBound
      begin
        if BisN[BuchNr]<BuchN
        then Result:=False
        else
          begin
          if BisN[BuchNr]>BuchN
          then Result:=True
          else // BisN[BuchNr]=BuchN
            begin
            if BisN[KapitelNr]<KapitelN
            then Result:=False
            else
              begin
              if BisN[KapitelNr]>KapitelN
              then Result:=True
              else //BisN[KapitelNr]=KapitelN
                Result:=BisN[VersNr]>=VersN
              end
            end
          end;
      end; // ButtonGenerateClick/IsVersSelected/IsInUpperBound

  begin // ButtonGenerateClick/IsVersSelected
    Result:=False;
    L:=Pos(' -- ',s);
    if L > 0
    then
      begin // Kapitelnummer.Versnummer ermittteln
      VersZeile:= s;
      System.Delete(VersZeile,1,L+3);
      L:=Pos(' (',VersZeile);
      System.Delete(VersZeile,L,Length(s));
      L:=Pos(' ',VersZeile);
      System.Delete(VersZeile,L,1);
      L:=Pos('.',VersZeile);
      KapitelN:=StrToInt(System.Copy(Verszeile,1,L-1));
      VersN:=StrToInt(System.Copy(Verszeile,L+1, Length(VersZeile)));
      Result:=IsInLowerBound and IsInUpperBound;
      end
  end; // ButtonGenerateClick/IsVersSelected

  procedure VersExtraktion; // ButtonGenerateClick/VersExtraktion
  Var Bibelstelle,BibelstelleKurz,BuchKapitelAlt:string;
    SuchSpalteCheck:Boolean;
    SuchSpalte:Integer;

    function Anfangsvers:Boolean;
      // ButtonGenerateClick/VersExtraktion/Anfangsvers
    begin
      Result:=(VonN[BuchNr]=BuchN) and (VonN[KapitelNr]=KapitelN) and
              (VonN[VersNr]=VersN)
    end; // ButtonGenerateClick/VersExtraktion/Anfangsvers

    function Endvers:Boolean;
      // ButtonGenerateClick/VersExtraktion/Endvers
    begin
      Result:=(BisN[BuchNr]=BuchN) and (BisN[KapitelNr]=KapitelN) and
              (BisN[VersNr]=VersN)
    end; // ButtonGenerateClick/VersExtraktion/Endvers

    procedure HeaderAusgabe;
      // ButtonGenerateClick/VersExtraktion/HeaderAusgabe
    begin
      if not Kurzform.Checked then OutList.Add(Bibelstelle);
      Inc(i);
    end; // ButtonGenerateClick/VersExtraktion/HeaderAusgabe

    procedure ZeilenAusgabe(Line:string;mitHeader:Boolean);
       // ButtonGenerateClick/VersExtraktion/ZeilenAusgabe
    begin
      if mitHeader
      then
        begin
        if Kurzform.Checked
        then OutList.Add(BibelstelleKurz+'| '+Line)
        else OutList.Add(Bibelstelle+'| '+Line);
        end
      else OutList.Add(Line)
    end; // ButtonGenerateClick/VersExtraktion/ZeilenAusgabe

    procedure BuchstabenAusgabe(Z:Integer;W,C,Ur:string);
       // ButtonGenerateClick/VersExtraktion/BuchstabenAusgabe
    var b:Integer;CodeList:TStringList;
    begin
      CodeList:=TStringList.Create;
      b:=0;
      while C<>'' do // Zahlencode überprüfen
        begin
        b:=Pos('_',C);
        if b>0
        then
          begin
          CodeList.Add(Copy(c,1,Pred(b)));
          System.Delete(C,1,b);
          end
        else
          if C<>''
          then
            begin
            CodeList.Add(C);
            C:=''
            end
        end;
      if (CodeList.Count=Z) and (Length(Ur)=Z)
      then
        for b:= 1 to Z do
          begin
          OutList.Add(BibelstelleKurz+'.'+W+'.'+IntToStr(b)+'| '+
                  Ur[b]+' '+ CodeList[Pred(b)]);
          TWZahl:=TWZahl+Int64(StrToInt(CodeList[Pred(b)])); // Summe der TW
          HebrTWZahl:=HebrTWZahl+TWZahl; // Hebräische Summe der TW
          end
      else OutList.Add(BibelstelleKurz+'.'+IntToStr(b)+'| '+C+' '+Ur+' Fehler');
    end; // ButtonGenerateClick/VersExtraktion/BuchstabenAusgabe

    procedure WortAusgabe(Line:string;mitHeader:Boolean);
      // ButtonGenerateClick/VersExtraktion/WortAusgabe
    var
      BuchstabenZ, // Anzahl der Buchstaben aus der Wortzeille
      c,n:Integer;
      Trenner,
      Wort,WortS,
      Statistik,
      Buchstaben,BuchstabenS,
      TW,TWS,
      Code,Urtext,Translation:string;

    procedure ExtraktLine;
    var s:string;
    begin
      s:=InpList[i];
      System.Delete(s,1,SuchSpalte);
      if (SuchSpalteCheck and (Pos(SuchBox.Text,s)>0)) or
         not SuchSpalteCheck
      then
        begin
        if SuchSpalteCheck then Inc(Fundstellen);
        if mitHeader
        then
          begin
          if Kurzform.Checked
          then OutList.Add(BibelstelleKurz+Trenner+Line)
          else OutList.Add(Bibelstelle+Trenner+Line);
          end
        else OutList.Add(Line)
        end
    end;

    begin// Bearbeiten von Line aufgrund der Optionen:
      Inc(WortZahl); // Anzahl der Wörter erhöhen
      Trenner:='| ';
      c:=Pos('.',Line);
      // WortS und Wort bestimmen
      WortS:=Copy(Line,1,c);
      System.Delete(Line,1,5);
      while (Line[1]=' ') do System.Delete(Line,1,1);
      c:=Pos('.',Line);
      Wort:= Copy(Line,1,Pred(c));
      System.Delete(Line,1,c);
      if Kurzform.Checked
      then
        begin
        Trenner:='.';
        WortS:=Wort+'| '
        end;
      // Statistik bestimmen
      Statistik:='';
      for n:=1 to 5 do
        begin
        c:=Pos('.',Line);
        Statistik:=Statistik+Copy(Line,1,c);
        System.Delete(Line,1,c);
        end;
      if TuZStatistik.Checked then Statistik:='';
      // Buchstabenanzahl bestimmen
      while (Line[1]=' ') do
        begin
        BuchstabenS:=BuchstabenS+' ';
        System.Delete(Line,1,1);
        end;
      c:=Pos(' ',Line);
      Buchstaben:=Copy(Line,1,Pred(c));
      BuchstabenZ:=StrToInt(Buchstaben);
      Inc(BuchstabenZahl,BuchstabenZ);
      BuchstabenS:=BuchstabenS+Buchstaben;
      System.Delete(Line,1,c);
      if BuchstabenCheck.Checked then BuchstabenS:='';
      // TW bestimmen
      while (Line[1]=' ') do
        begin
        TWS:=TWS+' ';
        System.Delete(Line,1,1);
        end;
      c:=Pos(' ',Line);
      TW:=Copy(Line,1,Pred(c));
      TWS:=TWS+TW;
      System.Delete(Line,1,c);
      if Totalwert.Checked then TWS:='';
      if Kriterien.ItemIndex<>6
      then
        begin
        TWZahl:=TWZahl+Int64(StrToInt(TW)); // Summe der Totalwerte erhöhen
        HebrTWZahl:=HebrTWZahl+TWZahl; // Hebräische Summe der Totalwerte erhöhen
        end;
      // Zahlencode bestimmen
      c:=Pos(' ',Line);
      Code:=Copy(Line,1,Pred(c));
      System.Delete(Line,1,c);
      if Zahlencode.Checked then Code:='';
      // Urtext bestimmen
      c:=Pos(' ',Line);
      Urtext:=Copy(Line,1,Pred(c));
      System.Delete(Line,1,c);
      if Grundtext.Checked then Urtext:='';
      // Übersetzung(en) bestimmen
      if Deutsch.Checked
      then Translation:=''
      else Translation:=Line;

      Line:=WortS+Statistik+BuchstabenS+' '+TWS+' '+Code+' '+Urtext+Translation;
      SuchSpalte:=Length(WortS+Statistik+BuchstabenS);

      if Kriterien.ItemIndex=6
      then Buchstabenausgabe(BuchstabenZ,Wort,Code,Urtext)
      else
        begin
        ExtraktLine;
        end
    end; // ButtonGenerateClick/VersExtraktion/WortAusgabe

    procedure NurWortzeilen;
      // ButtonGenerateClick/VersExtraktion/NurWortzeilen
    var z:Integer;
    begin
      HeaderAusgabe; // Versangabe
      if Anfangsvers
      then
        begin
        if Endvers
        then // Nur 1 Vers ist ausgewählt
          begin
          Inc(i,Pred(VonN[WortNr]));
          z:=VonN[WortNr];
          while (Pos('Wort',InpList[i])=1) and (z<=BisN[WortNr]) do
            begin
            Wortausgabe(InpList[i],Kurzform.Checked);
            Inc(i);
            Inc(z);
            end
          end
        else // Anfangsvers von mehreren ausgewählten Versen
          begin
          Inc(i,Pred(VonN[WortNr]));
          while Pos('Wort',InpList[i])=1 do
            begin
            Wortausgabe(InpList[i],Kurzform.Checked);
            Inc(i)
            end;
          end
        end
      else
        begin
        if Endvers
        then
          begin
          z:=0;
          while (Pos('Wort',InpList[i])=1) and (z<BisN[WortNr]) do
            begin
            Wortausgabe(InpList[i],Kurzform.Checked);
            Inc(i);
            Inc(z);
            end
          end
        else while Pos('Wort',InpList[i])=1 do
          begin
            Wortausgabe(InpList[i],Kurzform.Checked);
            Inc(i)
          end
        end;
      Dec(i);
    end; // ButtonGenerateClick/VersExtraktion/NurWortzeilen

    procedure TuZFormat; // ButtonGenerateClick/VersExtraktion/TuZFormat
    var z:Integer;
    begin
      NurWortzeilen;
      Inc(i);
      for z:=1 to 3 do
        begin
          ZeilenAusgabe(InpList[i],Kurzform.Checked);
          Inc(i)
        end;
      Dec(i);
    end; // ButtonGenerateClick/VersExtraktion/TuZFormat

    procedure NurElberfeld; // ButtonGenerateClick/VersExtraktion/NurElberfeld
    begin
      Inc(i);
      while Pos('Wort',InpList[i])=1 do Inc(i);
      Inc(i,2);
      ZeilenAusgabe(Copy(InpList[i],5,Length(InpList[i])),True);
    end; // ButtonGenerateClick/VersExtraktion/NurElberfeld

    procedure SucheInWortzeilen; // ButtonGenerateClick/VersExtraktion/
    begin
      SuchSpalteCheck:=True;
      Inc(i,2);
      while Pos('Wort',InpList[i])=1 do
        begin
        if Pos(SuchBox.Text,InpList[i])>0
        then WortAusgabe(InpList[i],True);
        Inc(i);
        end;
    end; // ButtonGenerateClick/VersExtraktion/

    procedure SucheInElberfeld;
      // ButtonGenerateClick/VersExtraktion/SucheInWortzeilen
    begin
      Inc(i);
      while Pos('Wort',InpList[i])=1 do Inc(i);
      Inc(i,2);
      if Pos(SuchBox.Text,InpList[i])>0
      then
        begin
        Inc(Fundstellen);
        ZeilenAusgabe(InpList[i],True);
        end
    end; // ButtonGenerateClick/VersExtraktion/SucheInWortzeilen

  begin // ButtonGenerateClick/VersExtraktion
    Bibelstelle:=s;
    Inc(VersZahl); // Anzahl der Verse erhöhen
    // Anzahl der Kapitel ermitteln:
    BuchKapitelAlt:=BuchKapitel;
    BuchKapitel:=IntToStr(BuchN)+'.'+IntToStr(KapitelN);
    if BuchKapitel<>BuchKapitelAlt then Inc(KapitelZahl);
    BibelstelleKurz:=BuchKapitel+'.'+IntToStr(VersN);

    SuchSpalteCheck:=False;
    case Kriterien.ItemIndex of
      0:begin
        Dec(i);
        SucheInWortzeilen;
        Inc(i,2);
        if Pos(SuchBox.Text,InpList[i])>0
        then
          begin
          Inc(Fundstellen);
          ZeilenAusgabe(InpList[i],True);
          end
        end;
      1:SucheInWortzeilen;
      2:SucheInElberfeld;
      3:TuZFormat;
      4,6:NurWortzeilen;
      5:NurElberfeld;
      else
    end
  end; // ButtonGenerateClick/VersExtraktion

  procedure HeaderAusgabe; // ButtonGenerateClick/HeaderAusgabe
  begin
    OutList.Add('Bibelabschnitt:   Von '+
      VonBuch.Text+' '+
      VonKapitel.Text+'.'+
      VonVers.Text+'.'+
      VonWort.Text+' bis '+
      BisBuch.Text+' '+
      BisKapitel.Text+'.'+
      BisVers.Text+'.'+
      BisWort.Text);
    case Kriterien.ItemIndex of
      0:OutList.Add('Auswahlkriterium: Suche in den Versen nach <'+
        SuchBox.Text+'>');
      1:OutList.Add('Auswahlkriterium: Suche in den Wortzeilen nach <'+
        SuchBox.Text+'>');
      2:OutList.Add('Auswahlkriterium: Suche im Elberfelder Text nach <'+
        SuchBox.Text+'>');
      3:OutList.Add('Auswahlkriterium: Suche alle Verse');
      4:OutList.Add('Auswahlkriterium: Suche alle Wortzeilen');
      5:OutList.Add('Auswahlkriterium: Suche alle Elberfelder Textzeilen');
      else
      end;
   if Kurzform.Checked
   then OutList.Add('Bibelstellen in Kurzform')
   else OutList.Add('Bibelstellen in genauer Schreibweise');
   if TuZStatistik.Checked
   then OutList.Add('Wortzeilen ohne TuZ-Statistik')
   else OutList.Add('Wortzeilen mit TuZ-Statistik');
   if BuchstabenCheck.Checked
   then OutList.Add('Wortzeilen ohne Buchstabenanzahl')
   else OutList.Add('Wortzeilen mit Buchstabenanzahl');
   if Totalwert.Checked
   then OutList.Add('Wortzeilen ohne Totalwert')
   else OutList.Add('Wortzeilen mit Totalwert');
   if Zahlencode.Checked
   then OutList.Add('Wortzeilen ohne Zahlencode')
   else OutList.Add('Wortzeilen mit Zahlencode');
   if Grundtext.Checked
   then OutList.Add('Wortzeilen ohne Grundtext (lateinische Umschrift)')
   else OutList.Add('Wortzeilen mit Grundtext (lateinische Umschrift)');
   if Deutsch.Checked
   then OutList.Add('Wortzeilen ohne deutsche Übersetzung(en)')
   else OutList.Add('Wortzeilen mit deutsche Übersetzung(en)');
  end; // ButtonGenerateClick/HeaderAusgabe

  function InTausender(Zahl:Int64):string;
   // ButtonGenerateClick/InTausender
   // Liefert Zahl mit Dezimalpunkten nach 1000er-Stellen
  var s,sOut:string;i,Stellen:Integer;
    begin
    //Result:=Format('%10.0n',[Zahl*1.0])
    s:=IntToStr(Zahl);
    sOut:='';
    Stellen:=0;
    for i:= Length(s) downto 1 do
      begin
      Inc(Stellen);
     sOut:=s[i]+sOut;
      if (Stellen>=3) and (i>1)
      then
        begin
        sOut:='.'+sOut;
        Stellen:=0;
        end
      end;
    if Length(s)>4
    then Result:=s+'|'+sOut
    else Result:=s
  end; // ButtonGenerateClick/InTausender

  procedure StatistikAusgabe; // ButtonGenerateClick/StatistikAusgabe
  begin
    OutList.Add('Statistik für den extrahierten Bibelabschnitt');
    //OutList.Add('Anzahl der Zeilen     '+InTausender(OutList.Count-1));
    OutList.Add('Anzahl der Bücher     '+IntToStr(BuchN-BuchZahl+1));
    OutList.Add('Anzahl der Kapitel    '+IntToStr(KapitelZahl));
    OutList.Add('Anzahl der Verse      '+InTausender(VersZahl));
    OutList.Add('Anzahl der Wörter     '+InTausender(WortZahl));
    OutList.Add('Anzahl der Buchstaben '+InTausender(BuchstabenZahl));
    case Kriterien.ItemIndex of
      0,1,2:
         begin
         OutList.Add('Anzahl Fundstellen    '+IntToStr(Fundstellen));
         OutList.Add('Summe der Totalwerte der Wörter:'+InTausender(TWZahl));
         OutList.Add('Hebräische Summe     der Wörter:'+InTausender(HebrTWZahl));
         end;
      6:
         begin
         OutList.Add('Summe der Totalwerte der Buchstaben:'+InTausender(TWZahl));
         OutList.Add('Hebräische Summe     der Buchstaben:'+InTausender(HebrTWZahl));
         end
      else
         begin
         OutList.Add('Summe der Totalwerte der Wörter:'+InTausender(TWZahl));
         OutList.Add('Hebräische Summe     der Wörter:'+InTausender(HebrTWZahl));
         end
      end;
  end; // ButtonGenerateClick/StatistikAusgabe

  begin // ButtonGenerateClick
  if BibelstellenOk
  then
    begin
    ListBox.Clear;
    Wortwahl.Hide;
    ButtonGenerate.Enabled:=False;
    InpList:=TStringList.Create;
    OutList.Clear;
    if Header.Checked then HeaderAusgabe;
    Suche:=True;
    VonN[BuchNr]:=Succ(GetBoxIndex(VonBuch));
    BuchN:=VonN[BuchNr];
    VonN[KapitelNr]:=Succ(GetBoxIndex(VonKapitel));
    VonN[VersNr]:=Succ(GetBoxIndex(VonVers));
    VonN[WortNr]:=Succ(GetBoxIndex(VonWort));
    BisN[BuchNr]:=Succ(GetBoxIndex(BisBuch));
    BisN[KapitelNr]:=Succ(GetBoxIndex(BisKapitel));
    BisN[VersNr]:=Succ(GetBoxIndex(BisVers));
    BisN[WortNr]:=Succ(GetBoxIndex(BisWort));
    BuchZahl:=BuchN;
    KapitelZahl:=0;
    VersZahl:=0;
    WortZahl:=0;
    BuchstabenZahl:=0;
    TWZahl:=0;
    HebrTWZahl:=0;
    Fundstellen:=0;
    BuchKapitel:='';
    InSuchBoxEintragen(Suchbox.Text);
    while Suche do
      begin
      InpList.LoadFromFile(Dir_TuZ+GetFileName(BuchN));
      LabelName.Caption:=Dir_TuZ+GetFileName(BuchN)+
      '                                                  ';
      LabelName.Refresh;
      i:=0;
      while i<InpList.Count do
        begin
        s:=InpList[i];
        if IsVersSelected
        then VersExtraktion;
        Inc(i);
        end;
      // Suche in aktueller Datei beendet
      if BuchN >= BisN[BuchNr]
      then Suche:=False
      else
        begin
        Inc(BuchN);
        VonN[KapitelNr]:=1;
        VonN[VersNr]:=1;
        VonN[WortNr]:=1;
        end
      end;
    if Auswertung.Checked then StatistikAusgabe;
    LabelName.Caption:='BiTuZa.Extrakt neu erzeugt';
    OutList.SaveToFile(Outname);
    ButtonGenerate.Enabled:=True;
    end
  else ShowMessage('Bibelstelle(n) nicht korrekt angegeben!')
end; // ButtonGenerateClick

// -------------------------------------------------------------------------
// Bei Änderungen der Boxen:

procedure TForm1.VonBuchChange(Sender: TObject);
begin
  FillKapitel(VonBuch,VonKapitel);
  SetAnfang(VonKapitel);
  FillVers(VonBuch,VonKapitel,VonVers);
  SetAnfang(VonVers);
  FillWort(VonBuch,VonKapitel,VonVers,VonWort);
  SetAnfang(VonWort);
end;

procedure TForm1.BisBuchChange(Sender: TObject);
begin
  FillKapitel(BisBuch,BisKapitel);
  SetEnde(BisKapitel);
  FillKapitel(BisBuch,BisKapitel);
  SetEnde(BisKapitel);
  FillVers(BisBuch,BisKapitel,BisVers);
  SetEnde(BisVers);
  FillWort(BisBuch,BisKapitel,BisVers,BisWort);
  SetEnde(BisWort);
end;

procedure TForm1.VonKapitelChange(Sender: TObject);
begin
  FillVers(VonBuch,VonKapitel,VonVers);
  SetAnfang(VonVers);
  FillWort(VonBuch,VonKapitel,VonVers,VonWort);
  SetAnfang(VonWort);
end;

procedure TForm1.BisKapitelChange(Sender: TObject);
begin
  FillVers(BisBuch,BisKapitel,BisVers);
  SetEnde(BisVers);
  FillWort(BisBuch,BisKapitel,BisVers,BisWort);
  SetEnde(BisWort);
end;

procedure TForm1.VonVersChange(Sender: TObject);
begin
  FillWort(VonBuch,VonKapitel,VonVers,VonWort);
  SetAnfang(VonWort);
end;

procedure TForm1.BisVersChange(Sender: TObject);
begin
  FillWort(BisBuch,BisKapitel,BisVers,BisWort);
  SetEnde(BisWort);
end;

procedure TForm1.BibelstellenClick(Sender: TObject);
begin
  case Bibelstellen.ItemIndex of
    0:EnableBoxes;
    1:begin // AT
      VonBuch.Text:=Long_BibleBook[1];
      VonBuchChange(nil);
      BisBuch.Text:=Long_BibleBook[AT_Buch_max];
      BisBuchChange(nil);
      DisableBoxes;
      end;
    2:begin // NT
      VonBuch.Text:=Long_BibleBook[AT_Buch_max+1];
      VonBuchChange(nil);
      BisBuch.Text:=Long_BibleBook[Buch_max];
      BisBuchChange(nil);
      DisableBoxes;
      end;
    3:begin // Bibel
      VonBuch.Text:=Long_BibleBook[1];
      VonBuchChange(nil);
      BisBuch.Text:=Long_BibleBook[Buch_max];
      BisBuchChange(nil);
      DisableBoxes;
      end;
    4:begin // 1 Buch
      BisBuch.Text:=VonBuch.Text;
      BisBuchChange(nil);
      EnableBoxes;
      end;
    5:begin // 1 Buch
      BisBuch.Text:=VonBuch.Text;
      BisBuchChange(nil);
      BisKapitel.Text:=VonKapitel.Text;
      BisKapitelChange(nil);
      EnableBoxes;
      end;
    6:begin // 1 Vers
      BisBuch.Text:=VonBuch.Text;
      BisBuchChange(nil);
      BisKapitel.Text:=VonKapitel.Text;
      BisKapitelChange(nil);
      BisVers.Text:=VonVers.Text;
      BisVersChange(nil);
      EnableBoxes;
      end;
  else
  end
end;

// -------------------------------------------------------------------------
// Bei Änderungen der Suchkriterien:

procedure TForm1.KriterienClick(Sender: TObject);
begin
  case Kriterien.ItemIndex of
    0:begin // String in Versen suchen
      SuchLabel.Visible:=True;
      SuchBox.Visible:=True;
      Format.Visible:=True;
      end;
    1:begin // String in Wortzeilen suchen
      SuchLabel.Visible:=True;
      SuchBox.Visible:=True;
      Format.Visible:=True;
      end;
    2:begin // String im Elberfelder Text suchen
      SuchLabel.Visible:=True;
      SuchBox.Visible:=True;
      Format.Visible:=True;
      end;
    3:begin // Vers in TuZ-Format ausgewählt
      SuchLabel.Visible:=False;
      SuchBox.Visible:=False;
      Format.Visible:=True;
      end;
    4:begin // Nur Wortzeilen ausgewählt
      SuchLabel.Visible:=False;
      SuchBox.Visible:=False;
      Format.Visible:=True;
      end;
    5:begin // Nur Elberfelder Text ausgewählt
      SuchLabel.Visible:=False;
      SuchBox.Visible:=False;
      Format.Visible:=False;
      end;
    6:begin // Anzeige der Bibel mit einer Zeile pro Buchstabe
      SuchLabel.Visible:=False;
      SuchBox.Visible:=False;
      Format.Visible:=False;
      Kurzform.Checked:=True;
      end;
    else
    end;
end;

// -------------------------------------------------------------------------
// MainMenu-Änderungen:

procedure TForm1.SpeichernClick(Sender: TObject);
begin
  try
    if SaveDialog1.Execute then ListBox.Items.SaveToFile(SaveDialog1.Filename);
  except ShowMessage('BiTuZa ließ sich nicht speichern!');
  end
end;

procedure TForm1.LoadLexikon(Name,Text:string);
begin
  Name:=Dir_Lexikon+Name;
  if FileExists(Name)
  then  begin
        LabelName.Caption:='Etwas Geduld bitte ...';
        LabelName.Update;
        ListBox.Hide;
        ListBox.Items.LoadFromFile(Name);
        LabelName.Caption:='Anzeige enthält das Lexikon '+Text;
        ListBox.Show;
        Wortwahl.Show;
        end
  else ShowMessage(Name+' wurde nicht gefunden!');
end;

procedure TForm1.ATTWClick(Sender: TObject);
begin
  LoadLexikon('AT_TW.Text','des AT, sortiert nach TW')
end;

procedure TForm1.NTTWClick(Sender: TObject);
begin
  LoadLexikon('NT_TW.Text','des NT, sortiert nach TW')
end;

procedure TForm1.BibelTWClick(Sender: TObject);
begin
  LoadLexikon('Bibel_TW.Text','der Bibel, sortiert nach TW')
end;

procedure TForm1.ATCodeClick(Sender: TObject);
begin
  LoadLexikon('AT_Code.Text','des AT, sortiert nach Zahlencode')
end;

procedure TForm1.NTCodeClick(Sender: TObject);
begin
  LoadLexikon('NT_Code.Text','des NT, sortiert nach Zahlencode')
end;

procedure TForm1.BibelCode1Click(Sender: TObject);
begin
  LoadLexikon('Bibel_Code.Text','der Bibel, sortiert nach Zahlencode')
end;

procedure TForm1.ATWortClick(Sender: TObject);
begin
  LoadLexikon('AT_Wort.Text','des AT, sortiert nach Bibelwort')
end;

procedure TForm1.NTWortClick(Sender: TObject);
begin
  LoadLexikon('NT_Wort.Text','des NT, sortiert nach Bibelwort')
end;

procedure TForm1.BibelWortClick(Sender: TObject);
begin
  LoadLexikon('Bibel_Wort.Text','der Bibel, sortiert nach Bibelwort')
end;

procedure TForm1.InfoClick(Sender: TObject);
begin
  if FileExists(Name_Info)
  then  begin
        Wortwahl.Hide;
        ListBox.Items.LoadFromFile(Name_Info);
        LabelName.Caption:='Anzeige enthält die Datei '+Name_Info;
        end
  else ShowMessage('Info.txt wurde nicht gefunden!');
end;

procedure TForm1.VersionClick(Sender: TObject);
begin
  ShowMessage('Version 1.2, PGZ, Oktober 2011');
end;

// -------------------------------------------------------------------------
// BiTuZa.Extrakt anzeigen:

procedure TForm1.AnzeigenClick(Sender: TObject);
const Limit=50000;
var i:Integer;FileList:TStringList;
begin
  Anzeigen.Enabled:=False;
  ListBox.Clear;
  ListBox.Hide;
  if FileExists(OutName)
  then
    begin
    FileList:=TstringList.Create;
    FileList.LoadFromFile(OutName);
    if FileList.Count<=Limit
    then
      begin
      ListBox.Items.LoadFromFile(OutName);
      LabelName.Caption:='Anzeige enthält die Datei '+OutName;
      end
    else
      begin
      LabelName.Caption:='Etwas Geduld bitte ...';
      LabelName.Update;
      ListBox.Items.Add('Anzahl der Zeilen ist größer als '+IntToStr(Limit));
      ListBox.Items.Add('(Bitte verwenden Sie einen Texteditor zur Anzeige)');
      ListBox.Items.Add('');
      for i:=0 to Limit do ListBox.Items.Add(FileList[i]);
      ListBox.Items.Add('');
      ListBox.Items.Add('...');
      ListBox.Items.Add('');
      for i:=(FileList.Count-15) to (FileList.Count-1) do
        ListBox.Items.Add(FileList[i]);
      LabelName.Caption:='Anzeige enthält die Datei '+OutName+' (Auszug)';
      end
    end
  else ShowMessage('Datei '+OutName+' fehlt');
  ListBox.Show;
  Anzeigen.Enabled:=True;
end;

// -------------------------------------------------------------------------
// Begriff aus der markierten Lexikonzeile ins Suchfeld eintragen:

procedure TForm1.WortwahlClick(Sender: TObject);
var i,c:Integer;
begin
  for i:= 0 to Pred(ListBox.Count) do
    begin
    if ListBox.Selected[i]
    then
      begin
      if (Pos('TW',LabelName.Caption)>0)
      then // Suche nach TW
        begin
        SuchBox.Text:=' '+Copy(ListBox.Items[i],1,5);
        InSuchBoxEintragen(Suchbox.Text);
        end
      else // Suche nach Grundtext oder Zahlencode
        begin
        c:=Pos(' ',ListBox.Items[i]);
        SuchBox.Text:=' '+Copy(ListBox.Items[i],1,c);
        InSuchBoxEintragen(Suchbox.Text);
        end
      end;
    end;
end;

end.
