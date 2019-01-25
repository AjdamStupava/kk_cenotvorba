unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type zoznam=record
  nazov:String;
  nakup,predaj:Real;
end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Memo1: TMemo;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Edit1EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  cennik:array[1..6]of zoznam;
  aktual:Integer;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i:Integer;
begin
  image1.Canvas.Font.Height:=40;
  image1.Canvas.TextOut(0,0,'CENOTVORBA');

  Memo1.Clear;

  cennik[1].nazov:='rozok';
  cennik[2].nazov:='mrkva';
  cennik[3].nazov:='horalka';
  cennik[4].nazov:='jablko';
  cennik[5].nazov:='pivo';
  cennik[6].nazov:='salama';

  cennik[1].nakup:=0.00;
  cennik[2].nakup:=0.00;
  cennik[3].nakup:=0.29;
  cennik[4].nakup:=1.03;
  cennik[5].nakup:=0.40;
  cennik[6].nakup:=1.50;

  cennik[1].predaj:=0.00;
  cennik[2].predaj:=0.00;
  cennik[3].predaj:=0.00;
  cennik[4].predaj:=1.19;
  cennik[5].predaj:=0.44;
  cennik[6].predaj:=1.73;

  for i:=1 to 6 do
   begin
    ListBox1.Items.Add(cennik[i].nazov);
    ListBox2.Items.Add(FloatToStr(cennik[i].nakup));
    ListBox3.Items.Add(FloatToStr(cennik[i].predaj));
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
      ListBox2.ItemIndex:=i;
      ListBox3.ItemIndex:=i;
    end;

end;

procedure TForm1.Button1Click(Sender: TObject);
var i:Integer;
begin
  Memo1.Clear;

  cennik[aktual].nakup:=StrToFloat(Edit2.text);
  cennik[aktual].predaj:=StrToFloat(Edit3.text);

  {IF ListBox1.ItemIndex > -1 THEN
   ListBox1.Items.Delete(ListBox1.ItemIndex);
  IF ListBox2.ItemIndex > -1 THEN
   ListBox2.Items.Delete(ListBox2.ItemIndex);
  IF ListBox3.ItemIndex > -1 THEN
   ListBox3.Items.Delete(ListBox3.ItemIndex);

  ListBox1.Items.Add(cennik[aktual].nazov);
  ListBox2.Items.Add(FloatToStr(cennik[aktual].nakup));
  ListBox3.Items.Add(FloatToStr(cennik[aktual].predaj));}

  ListBox1.Items.Clear;
  ListBox2.Items.Clear;
  ListBox3.Items.Clear;

  for i:=1 to 6 do
   begin
    ListBox1.Items.Add(cennik[i].nazov);
    ListBox2.Items.Add(FloatToStr(cennik[i].nakup));
    ListBox3.Items.Add(FloatToStr(cennik[i].predaj));
   end;

  Memo1.Append(cennik[aktual].nazov);
  Memo1.Append(FloatToStr(cennik[aktual].nakup));
  Memo1.Append(FloatToStr(cennik[aktual].predaj));
end;

procedure TForm1.Edit1EditingDone(Sender: TObject);
var i:Integer;
begin

  for i:=1 to 6 do
   IF Edit1.text = cennik[i].nazov THEN
    begin
     aktual:=i;
     Edit2.text:=FloatToStr(cennik[i].nakup);
     Edit3.text:=FloatToStr(cennik[i].predaj);
    end;

end;

end.

