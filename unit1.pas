unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, EditBtn;

type zoznam=record
  nazov,kod:String;
  nakup,predaj:Real;
end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    EditButton1: TEditButton;
    EditButton2: TEditButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    Memo1: TMemo;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure EditButton1ButtonClick(Sender: TObject);
    procedure EditButton2ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox2SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox3SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox4SelectionChange(Sender: TObject; User: boolean);
    procedure aktualizuj;
    procedure twodecplaces(i:Integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

const N=100;
var
  cennik:array[1..N]of zoznam;
  aktual,pocet:Integer;
  subor,subor2:TextFile;
  pomoc:String;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i,poz:Integer;
begin
  image1.Canvas.Font.Height:=40;
  image1.Canvas.TextOut(0,0,'CENOTVORBA');

  Memo1.Clear;

  AssignFile(subor,'TOVAR.txt');     // nacitavanie kodov a nazvov tovarov
  Reset(subor);
  Readln(subor,pocet);
  i:=0;

  while not eof(subor) do
   begin
    inc(i);
    Readln(subor,pomoc);
    poz:=POS(';',pomoc);
    cennik[i].kod:=COPY(pomoc,1,poz-1);
    cennik[i].nazov:=COPY(pomoc,poz+1,length(pomoc));
   end;

  CloseFile(subor);            // koniec nacitavania kodov a nazvov tovarov


  AssignFile(subor2,'CENNIK.txt');    // nacitavanie cien
  Reset(subor2);
  Readln(subor2);
  i:=0;

  while not eof(subor2) do
   begin
    inc(i);
    Readln(subor2,pomoc);
    poz:=POS(';',pomoc);
    Delete(pomoc,1,poz);
    poz:=POS(';',pomoc);
    cennik[i].nakup:=StrToFloat(COPY(pomoc,1,poz-1)) / 100;
    cennik[i].predaj:=StrToFloat(COPY(pomoc,poz+1,length(pomoc))) / 100;
   end;

  CloseFile(subor2);                // koniec nacitavania cien


  for i:=1 to pocet do
   begin
    ListBox1.Items.Add(cennik[i].nazov);
    twodecplaces(i);                       // vypis cien do listboxov
    ListBox4.Items.Add(cennik[i].kod);
   end;

end;

procedure TForm1.ListBox1SelectionChange(Sender: TObject; User: boolean);
var i:Integer;
begin

  for i:=ListBox1.Items.Count -1 downto 0 do
   IF ListBox1.Selected[i] THEN
    begin
      aktual:=i+1;
      EditButton2.text:=cennik[i+1].nazov;
      Edit2.text:=FloatToStr(cennik[i+1].nakup);
      Edit3.text:=FloatToStr(cennik[i+1].predaj);
      EditButton1.text:=cennik[i+1].kod;
      ListBox2.ItemIndex:=i;
      ListBox3.ItemIndex:=i;
      ListBox4.ItemIndex:=i;
    end;

end;

procedure TForm1.ListBox2SelectionChange(Sender: TObject; User: boolean);
var i:Integer;
begin

  for i:=ListBox2.Items.Count -1 downto 0 do
   IF ListBox2.Selected[i] THEN
    begin
      aktual:=i+1;
      EditButton2.text:=cennik[i+1].nazov;
      Edit2.text:=FloatToStr(cennik[i+1].nakup);
      Edit3.text:=FloatToStr(cennik[i+1].predaj);
      EditButton1.text:=cennik[i+1].kod;
      ListBox1.ItemIndex:=i;
      ListBox3.ItemIndex:=i;
      ListBox4.ItemIndex:=i;
    end;

end;

procedure TForm1.ListBox3SelectionChange(Sender: TObject; User: boolean);
var i:Integer;
begin

  for i:=ListBox3.Items.Count -1 downto 0 do
   IF ListBox3.Selected[i] THEN
    begin
      aktual:=i+1;
      EditButton2.text:=cennik[i+1].nazov;
      Edit2.text:=FloatToStr(cennik[i+1].nakup);
      Edit3.text:=FloatToStr(cennik[i+1].predaj);
      EditButton1.text:=cennik[i+1].kod;
      ListBox1.ItemIndex:=i;
      ListBox2.ItemIndex:=i;
      ListBox4.ItemIndex:=i;
    end;

end;

procedure TForm1.ListBox4SelectionChange(Sender: TObject; User: boolean);
var i:Integer;
begin

  for i:=ListBox4.Items.Count -1 downto 0 do
   IF ListBox4.Selected[i] THEN
    begin
      aktual:=i+1;
      EditButton2.text:=cennik[i+1].nazov;
      Edit2.text:=FloatToStr(cennik[i+1].nakup);
      Edit3.text:=FloatToStr(cennik[i+1].predaj);
      EditButton1.text:=cennik[i+1].kod;
      ListBox1.ItemIndex:=i;
      ListBox2.ItemIndex:=i;
      ListBox3.ItemIndex:=i;
    end;

end;

procedure TForm1.EditButton1ButtonClick(Sender: TObject);
var i,k:Integer;
begin

  for i:=1 to pocet do
   IF EditButton1.text = cennik[i].kod THEN
    begin
     k:=1;
     aktual:=i;
     EditButton2.text:=cennik[i].nazov;
     Edit2.text:=FloatToStr(cennik[i].nakup);
     Edit3.text:=FloatToStr(cennik[i].predaj);
     ListBox1.ItemIndex:=i-1;
     ListBox2.ItemIndex:=i-1;
     ListBox3.ItemIndex:=i-1;
     ListBox4.ItemIndex:=i-1;
     exit;
    end
   ELSE
    k:=0;

  IF k=0 THEN
   begin
    ShowMessage('Tovar s týmto kódom sa nenachádza na sklade.');
   end;

end;

procedure TForm1.EditButton2ButtonClick(Sender: TObject);
var i,k:Integer;
begin

  for i:=1 to pocet do
   IF EditButton2.text = cennik[i].nazov THEN
    begin
     k:=1;
     aktual:=i;
     EditButton1.text:=cennik[i].kod;
     Edit2.text:=FloatToStr(cennik[i].nakup);
     Edit3.text:=FloatToStr(cennik[i].predaj);
     ListBox1.ItemIndex:=i-1;
     ListBox2.ItemIndex:=i-1;
     ListBox3.ItemIndex:=i-1;
     ListBox4.ItemIndex:=i-1;
     exit;
    end
   ELSE
    k:=0;

  IF k=0 THEN
   begin
    ShowMessage('Tento tovar sa nenachádza na sklade.');
   end;

end;

procedure TForm1.Button1Click(Sender: TObject);
var kontrola,check:Boolean;
    zlomok:Real;
begin
  Memo1.Clear;


  kontrola:=TryStrToFloat(Edit2.text,zlomok);
  IF not kontrola THEN
   begin
    Edit2.text:=FloatToStr(cennik[aktual].nakup);
    Edit3.text:=FloatToStr(cennik[aktual].predaj);
    ShowMessage('Zadajte nákupnú cenu tovaru.');
   end;

  check:=TryStrToFloat(Edit3.text,zlomok);
  IF not check THEN
   begin
    Edit2.text:=FloatToStr(cennik[aktual].nakup);
    Edit3.text:=FloatToStr(cennik[aktual].predaj);
    ShowMessage('Zadajte predajnú cenu tovaru.');
   end;

  IF (StrToFloat(Edit2.text)<=0) or (StrToFloat(Edit3.text)<=0) THEN
   begin
    Edit2.text:=FloatToStr(cennik[aktual].nakup);
    Edit3.text:=FloatToStr(cennik[aktual].predaj);
    ShowMessage('Zadajte cenu tovaru, zadarmo nekupujeme ani nepredávame.');
   end;


  IF (check=true) and (kontrola=true) and (StrToFloat(Edit2.text)>0) and (StrToFloat(Edit3.text)>0) THEN
    IF StrToFloat(Edit2.text) > StrToFloat(Edit3.text) THEN
     begin

       IF MessageDlg('Otázka', 'Chcete uložiť nákupnú cenu vyššiu ako predajnú?', mtConfirmation,
       [mbYes, mbNo],0) = mrYes THEN
          aktualizuj
       ELSE
          Edit2.text:=FloatToStr(cennik[aktual].nakup);

     end
    ELSE
      aktualizuj;

end;

procedure TForm1.aktualizuj;
var i:Integer;
begin

  cennik[aktual].nakup:=StrToFloat(Edit2.text);
  cennik[aktual].predaj:=StrToFloat(Edit3.text);
  ListBox2.Items.Clear;
  ListBox3.Items.Clear;

  for i:=1 to pocet do
    twodecplaces(i);

  AssignFile(subor2,'CENNIK.txt');
  Rewrite(subor2);
  Writeln(subor2,IntToStr(pocet));

  for i:=1 to pocet do
   begin
    Writeln(subor2,cennik[i].kod+';'+FloatToStr(cennik[i].nakup*100)+';'+FloatToStr(cennik[i].predaj*100));
   end;

  CloseFile(subor2);


  Memo1.Append(cennik[aktual].kod);
  Memo1.Append(cennik[aktual].nazov);
  Memo1.Append(FloatToStr(cennik[aktual].nakup)+' €');
  Memo1.Append(FloatToStr(cennik[aktual].predaj)+' €');

end;

procedure TForm1.twodecplaces(i:Integer);
var ncena,pcena:String;
begin
  ncena:=FloatToStr(cennik[i].nakup*100);

    IF (ncena[length(ncena)] = '0') THEN
     begin
      IF (ncena[length(ncena)-1] = '0') THEN
        ListBox2.Items.Add(FloatToStr(cennik[i].nakup)+',00 €')
      ELSE
        ListBox2.Items.Add(FloatToStr(cennik[i].nakup)+'0 €');
     end;

    IF (ncena[length(ncena)] <> '0') THEN
      ListBox2.Items.Add(FloatToStr(cennik[i].nakup)+' €');


  pcena:=FloatToStr(cennik[i].predaj*100);

    IF (pcena[length(pcena)] = '0') THEN
     begin
      IF (pcena[length(pcena)-1] = '0') THEN
        ListBox3.Items.Add(FloatToStr(cennik[i].predaj)+',00 €')
      ELSE
        ListBox3.Items.Add(FloatToStr(cennik[i].predaj)+'0 €');
     end;

    IF (pcena[length(pcena)] <> '0') THEN
      ListBox3.Items.Add(FloatToStr(cennik[i].predaj)+' €');

end;
end.

