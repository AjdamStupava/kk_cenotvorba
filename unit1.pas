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
type zaznam=record
  nazov,kod:String;
end;

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
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
    Panel1: TPanel;
    Panel2: TPanel;
    Timer1: TTimer;
    procedure Edit5EditingDone(Sender: TObject);
    procedure Edit6EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox2SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox3SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox4SelectionChange(Sender: TObject; User: boolean);
    procedure aktualizuj;
    procedure Panel1Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure twodecplaces(i:Integer);
    procedure hladaniepodlakodu;
    procedure hladaniepodlanazvu;
    procedure selekciaitemu;
    procedure selekciaitemu2;
    procedure zapisarefresh;
    procedure nacitanieavypis;
  private
    { private declarations }
  public
    { public declarations }
  end;

const N=100;
var
  cennik:array[1..N]of zoznam;
  help:array[1..2]of zoznam;
  tovarybez:array[1..N]of zaznam;
  tovary:array[1..N]of zaznam;
  Slist,Slist2:TStringList;
  aktual,pocet,pocet2,pocet3,aktualverzia,verzia:Integer;
  subor,subor2,subor3:TextFile;
  pomoc,stare,nove:String;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  //image1.Canvas.Font.Color:=clWhite;
  image1.Canvas.Font.Height:=40;
  image1.Canvas.TextOut(0,0,'CENOTVORBA');


  Slist2:=TStringList.Create;       // Slist2 je stringlist s nazvami a kodmi
  Slist:=TStringList.Create;       // Slist je stringlist s cenami a kodmi

  AssignFile(subor,'CENNIK_VERZIA.txt');
  Reset(subor);
  Read(subor,aktualverzia);
  CloseFile(subor);

  nacitanieavypis;

end;

procedure TForm1.ListBox1SelectionChange(Sender: TObject; User: boolean);
var i:Integer;
begin

  for i:=ListBox1.Items.Count -1 downto 0 do
   IF ListBox1.Selected[i] THEN
    begin
     IF i<=(pocet2-1) THEN
      begin
       aktual:=i+1;
       selekciaitemu;
       ListBox2.ItemIndex:=i;
       ListBox3.ItemIndex:=i;
       ListBox4.ItemIndex:=i;
      end
     ELSE
      begin
       aktual:=i+1-pocet2;
       selekciaitemu2;
       ListBox2.ItemIndex:=i;
       ListBox3.ItemIndex:=i;
       ListBox4.ItemIndex:=i;
      end;
    end;

end;

procedure TForm1.ListBox2SelectionChange(Sender: TObject; User: boolean);
var i:Integer;
begin

  for i:=ListBox2.Items.Count -1 downto 0 do
   IF ListBox2.Selected[i] THEN
    begin
     IF i<=(pocet2-1) THEN
      begin
       aktual:=i+1;
       selekciaitemu;
       ListBox1.ItemIndex:=i;
       ListBox3.ItemIndex:=i;
       ListBox4.ItemIndex:=i;
      end
     ELSE
      begin
       aktual:=i+1-pocet2;
       selekciaitemu2;
       ListBox1.ItemIndex:=i;
       ListBox3.ItemIndex:=i;
       ListBox4.ItemIndex:=i;
      end;
    end;

end;

procedure TForm1.ListBox3SelectionChange(Sender: TObject; User: boolean);
var i:Integer;
begin

  for i:=ListBox3.Items.Count -1 downto 0 do
   IF ListBox3.Selected[i] THEN
    begin
      IF i<=(pocet2-1) THEN
      begin
       aktual:=i+1;
       selekciaitemu;
       ListBox1.ItemIndex:=i;
       ListBox2.ItemIndex:=i;
       ListBox4.ItemIndex:=i;
      end
     ELSE
      begin
       aktual:=i+1-pocet2;
       selekciaitemu2;
       ListBox1.ItemIndex:=i;
       ListBox2.ItemIndex:=i;
       ListBox4.ItemIndex:=i;
      end;
    end;

end;

procedure TForm1.ListBox4SelectionChange(Sender: TObject; User: boolean);
var i:Integer;
begin

  for i:=ListBox4.Items.Count -1 downto 0 do
   IF ListBox4.Selected[i] THEN
    begin
      IF i<=(pocet2-1) THEN
      begin
       aktual:=i+1;
       selekciaitemu;
       ListBox1.ItemIndex:=i;
       ListBox2.ItemIndex:=i;
       ListBox3.ItemIndex:=i;
      end
     ELSE
      begin
       aktual:=i+1-pocet2;
       selekciaitemu2;
       ListBox1.ItemIndex:=i;
       ListBox2.ItemIndex:=i;
       ListBox3.ItemIndex:=i;
      end;
    end;

end;

procedure TForm1.Edit5EditingDone(Sender: TObject);
begin

  hladaniepodlakodu;

end;

procedure TForm1.Edit6EditingDone(Sender: TObject);
begin

  hladaniepodlanazvu;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin

  AssignFile(subor,'CENNIK_VERZIA.txt');
  Reset(subor);
  Read(subor,verzia);
  CloseFile(subor);

  IF aktualverzia <> verzia THEN
   begin
    aktualverzia:=verzia;

    IF FileExists('CENNIK_LOCK.txt') THEN
     begin
      // este neviem co, asi sa spusti nejaky druhy timer, ktory bude cakat, kym sa neodstrani lock
     end
    ELSE
     begin
      nacitanieavypis;
     end;

   end;

end;

procedure TForm1.Panel1Click(Sender: TObject);  //odstran cenu
begin

  IF (length(Edit1.text) = 3) and (length(Edit4.text) > 0) THEN
    IF MessageDlg('Otázka','Naozaj chcete vymazať tomuto tovaru cenu a tým ho spraviť nenakupovateľným a nepredajným?',
    mtConfirmation,[mbYes, mbNo],0) = mrYes THEN
     begin
      nove:=help[2].kod;
      stare:=help[2].kod+';'+FloatToStr(help[2].nakup*100)+';'+FloatToStr(help[2].predaj*100);

      inc(pocet2);
      tovarybez[pocet2].kod:=help[2].kod;
      tovarybez[pocet2].nazov:=help[2].nazov;
      with cennik[aktual] do
       begin
        kod:=cennik[pocet].kod;
        nazov:=cennik[pocet].nazov;
        nakup:=cennik[pocet].nakup;
        predaj:=cennik[pocet].predaj;
       end;
      dec(pocet);

      zapisarefresh;

      Edit2.text:='bez ceny';
      Edit3.text:='bez ceny';
      Edit1.text:='';
      Edit4.text:='';
     end
    ELSE
     begin
      Edit1.text:=help[2].kod;
      Edit4.text:=help[2].nazov;
     end;

end;

procedure TForm1.Panel2Click(Sender: TObject);   //uloz zmenu
var kontrola,check:Boolean;
    zlomok:Real;
begin

  kontrola:=TryStrToFloat(Edit2.text,zlomok);
  IF not kontrola THEN
   begin
    Edit2.text:=FloatToStr(help[2].nakup);
    Edit3.text:=FloatToStr(help[2].predaj);
    ShowMessage('Zadajte nákupnú cenu tovaru.');
   end;

  check:=TryStrToFloat(Edit3.text,zlomok);
  IF not check THEN
   begin
    Edit2.text:=FloatToStr(help[2].nakup);
    Edit3.text:=FloatToStr(help[2].predaj);
    ShowMessage('Zadajte predajnú cenu tovaru.');
   end;

  IF (StrToFloat(Edit2.text)<0) or (StrToFloat(Edit3.text)<0) THEN
   begin
    Edit2.text:=FloatToStr(help[2].nakup);
    Edit3.text:=FloatToStr(help[2].predaj);
    ShowMessage('Zadajte cenu tovaru, zadarmo nekupujeme ani nepredávame.');
   end;


  IF (check=true) and (kontrola=true) and (StrToFloat(Edit2.text)>=0) and (StrToFloat(Edit3.text)>=0) THEN
    IF StrToFloat(Edit2.text) > StrToFloat(Edit3.text) THEN
     begin

       IF MessageDlg('Otázka', 'Chcete uložiť nákupnú cenu vyššiu ako predajnú?', mtConfirmation,
       [mbYes, mbNo],0) = mrYes THEN
         aktualizuj
       ELSE
         begin
          Edit2.text:=FloatToStr(help[2].nakup);
          Edit3.text:=FloatToStr(help[2].predaj);
         end;

     end
    ELSE
      aktualizuj;

end;

procedure TForm1.aktualizuj;
var i,k:Integer;
begin

  stare:=help[2].kod+';'+FloatToStr(help[2].nakup*100)+';'+FloatToStr(help[2].predaj*100);
  help[2].nakup:=StrToFloat(Edit2.text);
  help[2].predaj:=StrToFloat(Edit3.text);
  nove:=help[2].kod+';'+FloatToStr(help[2].nakup*100)+';'+FloatToStr(help[2].predaj*100);
  k:=0;

  for i:=1 to pocet do
    IF (help[2].kod = cennik[i].kod) THEN
     begin
      with cennik[i] do
       begin
        nakup:=help[2].nakup;
        predaj:=help[2].predaj;
       end;
      k:=1;
     end;

  IF k=0 THEN
   begin
    with tovarybez[aktual] do
     begin
      kod:=tovarybez[pocet2].kod;
      nazov:=tovarybez[pocet2].nazov;
     end;
    dec(pocet2);
    inc(pocet);
    with cennik[pocet] do
     begin
      kod:=help[2].kod;
      nazov:=help[2].nazov;
      nakup:=help[2].nakup;
      predaj:=help[2].predaj;
     end;
    stare:=help[2].kod;
   end;

  zapisarefresh;
end;

procedure TForm1.zapisarefresh;
var i:Integer;
begin

  ListBox1.Items.Clear;
  ListBox2.Items.Clear;
  ListBox3.Items.Clear;
  ListBox4.Items.Clear;

  for i:=1 to pocet2 do
   begin
    ListBox1.Items.Add(tovarybez[i].nazov);
    ListBox2.Items.Add('-');
    ListBox3.Items.Add('-');
    ListBox4.Items.Add(tovarybez[i].kod);
   end;

  for i:=1 to pocet do
   begin
    ListBox1.Items.Add(cennik[i].nazov);
    twodecplaces(i);
    ListBox4.Items.Add(cennik[i].kod);
   end;

  Slist.text:=StringReplace(Slist.text,stare,nove,[rfIgnoreCase]);
  inc(aktualverzia);

  IF (FileExists('CENNIK_LOCK.txt')) or (FileExists('CENNIK_VERZIA_LOCK.txt')) THEN
   begin
    // este neviem co, asi sa spusti nejaky druhy timer, ktory bude cakat, kym sa neodstrani lock
   end
  ELSE
   begin
    AssignFile(subor2,'CENNIK_LOCK.txt');  //vytvorim lock na cennik
    Rewrite(subor2);
    CloseFile(subor2);

    AssignFile(subor3,'CENNIK_VERZIA_LOCK.txt');   //vytvorim lock na verziu
    Rewrite(subor3);
    CloseFile(subor3);

    Slist.SaveToFile('CENNIK.txt');        //zapisem do cennika

    AssignFile(subor,'CENNIK_VERZIA.txt');    //zapisem do verzie novu verziu
    Rewrite(subor);
    Write(subor,aktualverzia);
    CloseFile(subor);

    DeleteFile('CENNIK_VERZIA_LOCK.txt');       //odstranim oba locky
    DeleteFile('CENNIK_LOCK.txt');
    //Slist.Free;
   end;

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
       IF ncena='0' THEN
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
       IF pcena='0' THEN
        ListBox3.Items.Add(FloatToStr(cennik[i].predaj)+',00 €')
       ELSE
        ListBox3.Items.Add(FloatToStr(cennik[i].predaj)+'0 €');
     end;

    IF (pcena[length(pcena)] <> '0') THEN
      ListBox3.Items.Add(FloatToStr(cennik[i].predaj)+' €');

end;

procedure TForm1.hladaniepodlakodu;

var i,k:Integer;
begin

  for i:=1 to (pocet2+pocet) do
    IF (Edit5.text = tovarybez[i].kod) or
    (Edit5.text = cennik[i].kod) THEN
     begin
      k:=1;
      break;
     end
    ELSE
     k:=0;

  IF k=0 THEN
   begin
    ShowMessage('Tovar s týmto kódom sa nenachádza na sklade.');
    exit;
   end;


  for i:=1 to pocet2 do
    IF Edit5.text = tovarybez[i].kod THEN
     begin
      aktual:=i;
      with help[2] do
        begin
         kod:=tovarybez[aktual].kod;
         nazov:=tovarybez[aktual].nazov;
         nakup:=0;
         predaj:=0;
        end;
      Edit6.text:=help[2].nazov;
      Edit2.text:='bez ceny';
      Edit3.text:='bez ceny';
      ListBox1.ItemIndex:=i-1;
      ListBox2.ItemIndex:=i-1;
      ListBox3.ItemIndex:=i-1;
      ListBox4.ItemIndex:=i-1;
      exit;
     end;

  for i:=1 to pocet do
   IF Edit5.text = cennik[i].kod THEN
    begin
     aktual:=i;
     with help[2] do
        begin
         kod:=cennik[aktual].kod;
         nazov:=cennik[aktual].nazov;
         nakup:=cennik[aktual].nakup;
         predaj:=cennik[aktual].predaj;
        end;
     Edit6.text:=help[2].nazov;
     Edit2.text:=FloatToStr(help[2].nakup);
     Edit3.text:=FloatToStr(help[2].predaj);
     Edit1.text:=help[2].kod;
     Edit4.text:=help[2].nazov;
     ListBox1.ItemIndex:=i-1+pocet2;
     ListBox2.ItemIndex:=i-1+pocet2;
     ListBox3.ItemIndex:=i-1+pocet2;
     ListBox4.ItemIndex:=i-1+pocet2;
    end;

  Panel2.enabled:=true;

end;

procedure TForm1.hladaniepodlanazvu;
var i,k:Integer;
begin

  for i:=1 to pocet3 do
    IF (Edit6.text = tovarybez[i].nazov) or
    (Edit6.text = cennik[i].nazov) THEN
     begin
      k:=1;
      break;
     end
    ELSE
     k:=0;

  IF k=0 THEN
   begin
    ShowMessage('Tento tovar sa nenachádza na sklade.');
    exit;
   end;


  for i:=1 to pocet2 do
    IF Edit6.text = tovarybez[i].nazov THEN
     begin
      aktual:=i;
      with help[2] do
        begin
         kod:=tovarybez[aktual].kod;
         nazov:=tovarybez[aktual].nazov;
         nakup:=0;
         predaj:=0;
        end;
      Edit5.text:=help[2].kod;
      Edit2.text:='bez ceny';
      Edit3.text:='bez ceny';
      ListBox1.ItemIndex:=i-1;
      ListBox2.ItemIndex:=i-1;
      ListBox3.ItemIndex:=i-1;
      ListBox4.ItemIndex:=i-1;
      exit;
     end;

  for i:=1 to pocet do
   IF Edit6.text = cennik[i].nazov THEN
    begin
     aktual:=i;
     with help[2] do
        begin
         kod:=cennik[aktual].kod;
         nazov:=cennik[aktual].nazov;
         nakup:=cennik[aktual].nakup;
         predaj:=cennik[aktual].predaj;
        end;
     Edit5.text:=help[2].kod;
     Edit2.text:=FloatToStr(help[2].nakup);
     Edit3.text:=FloatToStr(help[2].predaj);
     Edit1.text:=help[2].kod;
     Edit4.text:=help[2].nazov;
     ListBox1.ItemIndex:=i-1+pocet2;
     ListBox2.ItemIndex:=i-1+pocet2;
     ListBox3.ItemIndex:=i-1+pocet2;
     ListBox4.ItemIndex:=i-1+pocet2;
    end;

  Panel2.enabled:=true;

end;

procedure TForm1.selekciaitemu;
begin

  with help[2] do
   begin
    kod:=tovarybez[aktual].kod;
    nazov:=tovarybez[aktual].nazov;
    nakup:=0;
    predaj:=0;
   end;
  Edit6.text:=help[2].nazov;
  Edit2.text:='bez ceny';
  Edit3.text:='bez ceny';
  Edit5.text:=help[2].kod;
  Edit1.text:='';
  Edit4.text:='';
  Panel2.enabled:=true;

end;

procedure TForm1.selekciaitemu2;
begin

  with help[2] do
   begin
    kod:=cennik[aktual].kod;
    nazov:=cennik[aktual].nazov;
    nakup:=cennik[aktual].nakup;
    predaj:=cennik[aktual].predaj;
   end;
  Edit6.text:=help[2].nazov;
  Edit2.text:=FloatToStr(help[2].nakup);
  Edit3.text:=FloatToStr(help[2].predaj);
  Edit5.text:=help[2].kod;
  Edit1.text:=help[2].kod;
  Edit4.text:=help[2].nazov;
  Panel2.enabled:=true;

end;

procedure TForm1.nacitanieavypis;
var i,poz,j,h:Integer;
begin

  IF FileExists('CENNIK_LOCK.txt') THEN
   begin
    // este neviem co, asi sa spusti nejaky druhy timer, ktory bude cakat, kym sa neodstrani lock
   end
  ELSE
   begin
    AssignFile(subor2,'CENNIK_LOCK.txt');
    Rewrite(subor2);
    CloseFile(subor2);
    Slist.LoadFromFile('CENNIK.txt');
    DeleteFile('CENNIK_LOCK.txt');
   end;

  IF FileExists('TOVAR_LOCK.txt') THEN
   begin
    // este neviem co, asi sa spusti nejaky druhy timer, ktory bude cakat, kym sa neodstrani lock
   end
  ELSE
   begin
    AssignFile(subor2,'TOVAR_LOCK.txt');
    Rewrite(subor2);
    CloseFile(subor2);
    Slist2.LoadFromFile('TOVAR.txt');
    DeleteFile('TOVAR_LOCK.txt');
   end;


  pocet3:=StrToInt(Slist2[0]);        // pocet3 je pocet vsetkych tovarov

  for i:=1 to pocet3 do
   begin
    pomoc:=Slist2[i];
    poz:=POS(';',pomoc);
    tovary[i].kod:=COPY(pomoc,1,poz-1);
    tovary[i].nazov:=COPY(pomoc,poz+1,length(pomoc));
   end;


  i:=0;
  j:=0;

  for h:=1 to pocet3 do
   begin
    pomoc:=Slist[h];
    IF (length(pomoc) = 3) THEN
     begin
      inc(j);
      tovarybez[j].kod:=pomoc;
     end
    ELSE
     begin
      inc(i);
      poz:=POS(';',pomoc);
      cennik[i].kod:=COPY(pomoc,1,poz-1);
      Delete(pomoc,1,poz);
      poz:=POS(';',pomoc);
      cennik[i].nakup:=StrToFloat(COPY(pomoc,1,poz-1)) / 100;
      cennik[i].predaj:=StrToFloat(COPY(pomoc,poz+1,length(pomoc))) / 100;
     end;
   end;
  pocet2:=j;                       // pocet2 je pocet tovarov bez ceny
  pocet:=i;                        // pocet je pocet tovarov s cenami


  for i:=1 to pocet do            // priradovanie nazvov k ich cenam a kodom
    for j:=1 to pocet3 do
      IF cennik[i].kod = tovary[j].kod THEN
        cennik[i].nazov:=tovary[j].nazov;

  for i:=1 to pocet2 do
    for j:=1 to pocet3 do
      IF tovarybez[i].kod = tovary[j].kod THEN
        tovarybez[i].nazov:=tovary[j].nazov;


  for i:=1 to pocet2 do        // tovary bez ceny na horne pozicie listboxov
   begin
    ListBox1.Items.Add(tovarybez[i].nazov);
    ListBox2.Items.Add('-');
    ListBox3.Items.Add('-');
    ListBox4.Items.Add(tovarybez[i].kod);
   end;

  for i:=1 to pocet do
   begin
    ListBox1.Items.Add(cennik[i].nazov);
    twodecplaces(i);                       // vypis cien do listboxov
    ListBox4.Items.Add(cennik[i].kod);
   end;

end;

end.

