unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type zoznam=record
  nazov,kod:String;
  nakup,predaj:Real;
end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
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
    procedure Edit1EditingDone(Sender: TObject);
    procedure Edit4EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox2SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox3SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox4SelectionChange(Sender: TObject; User: boolean);
    procedure aktualizuj;
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


  AssignFile(subor,'TOVAR.txt');
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

  CloseFile(subor);


  AssignFile(subor2,'CENNIK.txt');
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

  CloseFile(subor2);


  for i:=1 to pocet do
   begin
    ListBox1.Items.Add(cennik[i].nazov);
    ListBox2.Items.Add(FloatToStr(cennik[i].nakup)+' €');
    ListBox3.Items.Add(FloatToStr(cennik[i].predaj)+' €');
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
      Edit1.text:=cennik[i+1].nazov;
      Edit2.text:=FloatToStr(cennik[i+1].nakup);
      Edit3.text:=FloatToStr(cennik[i+1].predaj);
      Edit4.text:=cennik[i+1].kod;
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
      Edit1.text:=cennik[i+1].nazov;
      Edit2.text:=FloatToStr(cennik[i+1].nakup);
      Edit3.text:=FloatToStr(cennik[i+1].predaj);
      Edit4.text:=cennik[i+1].kod;
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
      Edit1.text:=cennik[i+1].nazov;
      Edit2.text:=FloatToStr(cennik[i+1].nakup);
      Edit3.text:=FloatToStr(cennik[i+1].predaj);
      Edit4.text:=cennik[i+1].kod;
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
      Edit1.text:=cennik[i+1].nazov;
      Edit2.text:=FloatToStr(cennik[i+1].nakup);
      Edit3.text:=FloatToStr(cennik[i+1].predaj);
      Edit4.text:=cennik[i+1].kod;
      ListBox1.ItemIndex:=i;
      ListBox2.ItemIndex:=i;
      listBox3.ItemIndex:=i;
    end;

end;

procedure TForm1.Edit1EditingDone(Sender: TObject);
var i:Integer;
begin

  for i:=1 to pocet do
   IF Edit1.text = cennik[i].nazov THEN
    begin
     aktual:=i;
     Edit2.text:=FloatToStr(cennik[i].nakup);
     Edit3.text:=FloatToStr(cennik[i].predaj);
     Edit4.text:=cennik[i].kod;
    end;

end;

procedure TForm1.Edit4EditingDone(Sender: TObject);
var i:Integer;
begin

  for i:=1 to pocet do
   IF Edit4.text = cennik[i].kod THEN
    begin
     aktual:=i;
     Edit1.text:=cennik[i].nazov;
     Edit2.text:=FloatToStr(cennik[i].nakup);
     Edit3.text:=FloatToStr(cennik[i].predaj);
    end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Clear;

    IF StrToFloat(Edit2.text) > StrToFloat(Edit3.text) THEN
     begin

       IF MessageDlg('Otázka', 'Chcete zadať nákupnú cenu vyššiu ako predajnú?', mtConfirmation,
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
   begin
    ListBox2.Items.Add(FloatToStr(cennik[i].nakup)+' €');
    ListBox3.Items.Add(FloatToStr(cennik[i].predaj)+' €');
   end;

  Memo1.Append(cennik[aktual].kod);
  Memo1.Append(cennik[aktual].nazov);
  Memo1.Append(FloatToStr(cennik[aktual].nakup)+' €');
  Memo1.Append(FloatToStr(cennik[aktual].predaj)+' €');

end;

end.

