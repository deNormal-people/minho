unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Data.Win.ADODB,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MSAcc, FireDAC.Phys.MSAccDef, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Phys.ODBC, FireDAC.Phys.ODBCDef,
  dxSkinsCore, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinscxPCPainter, dxBarBuiltInMenu, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxContainer,
  cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxButtons, cxPC, cxStyles,
  cxInplaceContainer, cxVGrid, cxDBVGrid, cxClasses, cxCustomData,
  cxCustomPivotGrid, cxDBPivotGrid, cxLabel, cxFilter, cxData, cxDataStorage,
  cxNavigator, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridLevel, cxGridCustomView, cxGrid;

type
  TForm1 = class(TForm)
    pgcDB: TcxPageControl;
    tasADOC: TcxTabSheet;
    cbxTablename: TcxComboBox;
    btnSearch: TcxButton;
    btnInsert: TcxButton;
    btnUpdate: TcxButton;
    btnDelete: TcxButton;
    edtSearch: TEdit;
    cbxColumn: TcxComboBox;
    tasFireDAC: TcxTabSheet;
    ADOConnection: TADOConnection;
    odgConnection: TOpenDialog;
    adqTmp: TADOQuery;
    adtTmp: TADOTable;
    dtsAdt: TDataSource;
    dtsAdq: TDataSource;
    FDConnection: TFDConnection;
    dbgVeiw_FD: TDBGrid;
    cbxTablename_FD: TcxComboBox;
    cbxColumn_FD: TcxComboBox;
    edtSearch_FD: TEdit;
    btnSearch_FD: TcxButton;
    btnInsert_FD: TcxButton;
    btnUpdate_FD: TcxButton;
    btnDelete_FD: TcxButton;
    fdtTmp: TFDTable;
    fdqTmp: TFDQuery;
    dtsFdt: TDataSource;
    dtsFdq: TDataSource;
    cxGrid1: TcxGrid;
    dbgVeiw2: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    procedure FormCreate(Sender: TObject);
    procedure cbxTablenameChange(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure cbxColumnChange(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure btnInsertClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure dbgVeiwDblClick(Sender: TObject);
    procedure btnSearch_FDClick(Sender: TObject);
    procedure btnInsert_FDClick(Sender: TObject);
    procedure btnUpdate_FDClick(Sender: TObject);
    procedure btnDelete_FDClick(Sender: TObject);
    procedure cbxColumn_FDChange(Sender: TObject);
    procedure dbgVeiw2CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
    { Private declarations }
    function lbeCreate():Boolean;
    function lbeCreate2():Boolean;
    function ModeCheck_Enabledchange():Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}
function TForm1.ModeCheck_Enabledchange():Boolean; 
var
  I : integer;
  lbeTemp : TLabeledEdit;
begin
  if Self.pgcDB.ActivePage.ComponentCount <> 0 then
  begin
    if ((btnUpdate.Caption = '수정하기') or (btnUpdate_FD.Caption = '수정하기')) then
      (Self.pgcDB.ActivePage.Components[0] as TLabeledEdit).Enabled := false;
    if ((btnDelete.Caption = '삭제하기') or (btnDelete_FD.Caption = '삭제하기')) then
    begin
      for I := Self.pgcDB.ActivePage.ComponentCount - 1 downto 0 do
      begin
        if Self.pgcDB.ActivePage.Components[i] is TLabeledEdit then
        begin
          (Self.pgcDB.ActivePage.Components[i] as TLabeledEdit).Enabled := false;
        end;
      end;
    end;  
  end;
end;

procedure TForm1.btnDeleteClick(Sender: TObject);
begin
  if btnDelete.Caption = '삭제모드' then
    btnDelete.Caption := '삭제하기'
  else
  begin
    btnDelete.Caption := '삭제모드';
    if Self.pgcDB.ActivePage.ComponentCount = 0 then
      ShowMessage('테이블를 선택해주세요')
    else if (Self.pgcDB.ActivePage.Components[0] as TLabeledEdit).Text <> ''then
    begin
      adtTmp.Close;
      adqTmp.Close;
      adqTmp.SQL.Text := 'DELETE FROM ' + cbxTablename.Text + ' WHERE ' +
      (Self.pgcDB.ActivePage.Components[0] as TLabeledEdit).EditLabel.Caption + ' = ' +
      (Self.pgcDB.ActivePage.Components[0] as TLabeledEdit).Text ;
    if adqTmp.ExecSQL.ToBoolean then
      ShowMessage('삭제완료!');
    end
    else
      ShowMessage('필드를 선택해주세요');
  end;
  btnInsert.Enabled := not btnInsert.Enabled;
  btnUpdate.Enabled := not btnUpdate.Enabled;
  cbxTablenameChange(nil);
end;

procedure TForm1.btnDelete_FDClick(Sender: TObject);
begin
  if btnDelete_FD.Caption = '삭제모드' then
    btnDelete_FD.Caption := '삭제하기'
  else
  begin
    btnDelete_FD.Caption := '삭제모드';
    if Self.pgcDB.ActivePage.ComponentCount = 0 then
      ShowMessage('테이블를 선택해주세요')
    else if (Self.pgcDB.ActivePage.Components[0] as TLabeledEdit).Text <> ''then
    begin
      fdtTmp.Close;
      fdqTmp.Close;
      fdqTmp.SQL.Text := 'DELETE FROM ' + cbxTablename_FD.Text + ' WHERE ' +
      (Self.pgcDB.ActivePage.Components[0] as TLabeledEdit).EditLabel.Caption + ' = ' +
      (Self.pgcDB.ActivePage.Components[0] as TLabeledEdit).Text ;
      fdqTmp.ExecSQL;
    end
    else
      ShowMessage('필드를 선택해주세요');
  end;
  btnInsert_FD.Enabled := not btnInsert_FD.Enabled;
  btnUpdate_FD.Enabled := not btnUpdate_FD.Enabled;
  cbxTablenameChange(nil);
end;

procedure TForm1.btnInsertClick(Sender: TObject);
var
  I, ntemp: Integer;
  cptTemp : TComponent;
  strTmpcol, strTmpval : String;
begin
  if Self.pgcDB.ActivePage.ComponentCount = 0 then
    ShowMessage('테이블를 선택해주세요')
  else if (Self.pgcDB.ActivePage.Components[0] as TLabeledEdit).Text <> ''then
  begin
    adtTmp.Close;
    adqTmp.Close;
    adqTmp.SQL.Text := 'insert into ' + cbxTablename.Text;
    strTmpcol := '(';
    strTmpval := '(';
    for I := 0 to Self.pgcDB.ActivePage.ComponentCount - 1 do
    begin
      cptTemp := Self.pgcDB.ActivePage.Components[i];
      if TryStrToInt((cptTemp as TLabeledEdit).Text, ntemp) then
      begin
        strTmpcol := strTmpcol + (cptTemp as TLabeledEdit).EditLabel.Caption + ', ';
        strTmpval := strTmpval + (cptTemp as TLabeledEdit).Text + ', ';
      end
      else
      begin
        strTmpcol := strTmpcol + (cptTemp as TLabeledEdit).EditLabel.Caption + ', ';
        strTmpval := strTmpval + #39 +(cptTemp as TLabeledEdit).Text + #39  + ', ';
      end;
    end;
    strTmpcol := copy(strTmpcol, 1, strTmpcol.Length - 2) + ')';
    strTmpval := copy(strTmpval, 1, strTmpval.Length - 2) + ')';

    adqTmp.SQL.Text := adqTmp.SQL.Text + strTmpcol + ' values ' + strTmpval;
    adqTmp.ExecSQL;
  end
  else
    ShowMessage('필드를 선택해주세요');
  cbxTablenameChange(nil);
end;

procedure TForm1.btnInsert_FDClick(Sender: TObject);
var
  I, ntemp: Integer;
  cptTemp : TComponent;
  strTmpcol, strTmpval : String;
begin
  if Self.pgcDB.ActivePage.ComponentCount = 0 then
    ShowMessage('테이블를 선택해주세요')
  else if (Self.pgcDB.ActivePage.Components[0] as TLabeledEdit).Text <> ''then
  begin
    fdtTmp.Close;
    fdqTmp.Close;
    fdqTmp.SQL.Text := 'insert into ' + cbxTablename_FD.Text;
    strTmpcol := '(';
    strTmpval := '(';
    for I := 0 to Self.pgcDB.ActivePage.ComponentCount - 1 do
    begin
      cptTemp := Self.pgcDB.ActivePage.Components[i];

      strTmpcol := strTmpcol + (cptTemp as TLabeledEdit).EditLabel.Caption + ', ';
      strTmpval := strTmpval + (cptTemp as TLabeledEdit).Text + ', ';
      if TryStrToInt((cptTemp as TLabeledEdit).Text, ntemp) then
      begin
        strTmpcol := strTmpcol + (cptTemp as TLabeledEdit).EditLabel.Caption + ', ';
        strTmpval := strTmpval + (cptTemp as TLabeledEdit).Text + ', ';
      end
      else
      begin
        strTmpcol := strTmpcol + (cptTemp as TLabeledEdit).EditLabel.Caption + ', ';
        strTmpval := strTmpval + #39 +(cptTemp as TLabeledEdit).Text + #39  + ', ';
      end;
    end;
    strTmpcol := copy(strTmpcol, 1, strTmpcol.Length - 2) + ')';
    strTmpval := copy(strTmpval, 1, strTmpval.Length - 2) + ')';

    fdqTmp.SQL.Text := fdqTmp.SQL.Text + strTmpcol + ' values ' + strTmpval;
    fdqTmp.ExecSQL;
  end
  else
    ShowMessage('필드를 선택해주세요');
  cbxTablenameChange(nil);
end;

procedure TForm1.btnSearchClick(Sender: TObject);
var
  ntmp : integer;
begin
  if Self.pgcDB.ActivePage.ComponentCount = 0 then
    ShowMessage('테이블를 선택해주세요')
  else if cbxColumn.Text = '' then
    ShowMessage('컬럼을 선택해 주세요')
  else if edtSearch.Text <> '' then
  begin
    adtTmp.Close;
    adqTmp.Close;
    adqTmp.SQL.Text := ' select * from ' + cbxTablename.Text;
    if edtSearch.Text <> '' then
      adqTmp.SQL.Text := adqTmp.SQL.Text + ' where ' + cbxColumn.Text + ' like ' + QuotedStr('%'+edtSearch.Text+'%');
    adqTmp.Open;
    dbgVeiw2.DataController.DataSource := dtsAdq;
  end
  else
    ShowMessage('검색어를 입력해 주세요');
end;

procedure TForm1.btnSearch_FDClick(Sender: TObject);
var
  ntmp : integer;
begin
  if Self.pgcDB.ActivePage.ComponentCount = 0 then
    ShowMessage('테이블를 선택해주세요')
  else if cbxColumn_FD.Text = '' then
    ShowMessage('컬럼을 선택해 주세요')
  else if edtSearch_FD.Text <> '' then
  begin
    fdtTmp.Close;
    fdqTmp.Close;
    fdqTmp.SQL.Text := ' select * from ' + cbxTablename_FD.Text;
    if edtSearch_FD.Text <> '' then
      fdqTmp.SQL.Text := fdqTmp.SQL.Text + ' where ' + cbxColumn_FD.Text + ' like ' + QuotedStr('%'+edtSearch_FD.Text+'%');
    fdqTmp.Open;
    dbgVeiw_FD.DataSource := dtsfdq;
  end
  else
    ShowMessage('검색어를 입력해 주세요');
end;

procedure TForm1.btnUpdateClick(Sender: TObject);
var
  I, nTmp, nSelect: integer;
  cptTmp : TComponent;
  strTmp : String;
begin
  if btnUpdate.Caption = '수정모드' then
    btnUpdate.Caption := '수정하기'
  else
  begin
    btnUpdate.Caption := '수정모드';
    if Self.pgcDB.ActivePage.ComponentCount = 0 then
      ShowMessage('테이블를 선택해주세요')
    else if (Self.pgcDB.ActivePage.Components[0] as TLabeledEdit).Text <> ''then
    begin
      adtTmp.Close;
      adqTmp.Close;
      adqTmp.SQL.Text := 'UPDATE ' + cbxTablename.Text + ' set ';
      nSelect := dbgVeiw2.DataController.GetSelectedCount;
      for I := Self.pgcDB.ActivePage.ComponentCount - 1  downto 0 do
      begin
        cptTmp := Self.pgcDB.ActivePage.Components[i];
        if i = 0 then
        begin
          strTmp := copy(strTmp, 1, strTmp.Length - 2);
          strTmp := strTmp + ' where ' +
            (cptTmp as TLabeledEdit).EditLabel.Caption +
              ' = ' + (cptTmp as TLabeledEdit).Text;
        end
        else
        begin
          strTmp := strTmp + (cptTmp as TLabeledEdit).EditLabel.Caption +
              ' = ' + QuotedStr((cptTmp as TLabeledEdit).Text) + ', ';
        end;
      end;
      adqTmp.SQL.Text := adqTmp.SQL.Text + strTmp;
      if adqTmp.ExecSQL.ToBoolean then
        ShowMessage('수정 완료!');
    end
    else
      ShowMessage('필드를 선택해주세요');
  end;
  btnInsert.Enabled := not btnInsert.Enabled;
  btnDelete.Enabled := not btnDelete.Enabled;
  cbxTablenameChange(nil);
end;

procedure TForm1.btnUpdate_FDClick(Sender: TObject);
var
  I, nTmp, nSelect: integer;
  cptTmp : TComponent;
  strTmp : String;
begin
  if btnUpdate_FD.Caption = '수정모드' then
    btnUpdate_FD.Caption := '수정하기'
  else
  begin
    btnUpdate_FD.Caption := '수정모드';
    if Self.pgcDB.ActivePage.ComponentCount = 0 then
      ShowMessage('테이블를 선택해주세요')
    else if (Self.pgcDB.ActivePage.Components[0] as TLabeledEdit).Text <> ''then
    begin
      fdtTmp.Close;
      fdqTmp.Close;
      fdqTmp.SQL.Text := 'UPDATE ' + cbxTablename_FD.Text + ' set ';
      nSelect := dbgVeiw_FD.SelectedRows.Count;
      for I := Self.pgcDB.ActivePage.ComponentCount - 1  downto 0 do
      begin
        cptTmp := Self.pgcDB.ActivePage.Components[i];
        if i = 0 then
        begin
          strTmp := copy(strTmp, 1, strTmp.Length - 2);
          strTmp := strTmp + ' where ' +
            (cptTmp as TLabeledEdit).EditLabel.Caption +
              ' = ' + (cptTmp as TLabeledEdit).Text;
        end
        else
        begin
          strTmp := strTmp + (cptTmp as TLabeledEdit).EditLabel.Caption +
            ' = ' + QuotedStr((cptTmp as TLabeledEdit).Text) + ', ';
        end;
      end;
      fdqTmp.SQL.Text := fdqTmp.SQL.Text + strTmp;
      fdqTmp.ExecSQL;
    end
    else
      ShowMessage('필드를 선택해주세요');
  end;
  btnInsert_FD.Enabled := not btnInsert_FD.Enabled;
  btnDelete_FD.Enabled := not btnDelete_FD.Enabled;
  cbxTablenameChange(nil);
end;

function TForm1.lbeCreate():boolean;  //라벨 만드는 김에 콤보박스 아이템추가
var
  I, Ntmp : Integer;
  cbxTmp : TcxComboBox;
  dbgTmp  : TDBGrid ;
begin
  {
  Ntmp := 0;
  if pgcDB.ActivePage.Caption = 'ADOC' then
  begin
    cbxTmp := cbxColumn;
    dbgTmp := dbgVeiw2;
    cbxColumn.Properties.Items.Clear;
  end
  else
  begin
    cbxTmp := cbxColumn_FD;
    dbgTmp := dbgVeiw2_FD;
    cbxColumn_FD.Properties.Items.Clear;
  end;
  for I := 0 to dbgTmp.Columns.Count - 1 do
  begin
    with TLabeledEdit.Create(Self.pgcDB.ActivePage) do
    begin
      Parent := Self.pgcDB.ActivePage;
      Height := 20;
      Width := 75;
      Left := 3+(i * 80) - (Ntmp * 14 * 80);
      Top := 15 + (Ntmp * 45);
      Name := Format('lbe%d',[i]);
      text := '';
      EditLabel.Caption := dbgTmp.Columns[i].FieldName;
      cbxTmp.Properties.Items.Add(dbgTmp.Columns[i].FieldName);

      if (((i + 1) mod 14) = 0) then
        Ntmp := Ntmp + 1;
    end;
  end;
  cbxTmp.ItemIndex := 0;
  Result := true;
  }
end;
function TForm1.lbeCreate2():boolean;  //라벨 만드는 김에 콤보박스 아이템추가
var
  I, Ntmp : Integer;
  cbxTmp : TcxComboBox;
  dbgTmp : TcxGridDBTableView ;
begin
  Ntmp := 0;
  if pgcDB.ActivePage.Caption = 'ADOC' then
  begin
    cbxTmp := cbxColumn;
    dbgTmp := dbgVeiw2;
    cbxColumn.Properties.Items.Clear;
  end;
  for I := 0 to dbgTmp.ColumnCount - 1 do
  begin
    with TLabeledEdit.Create(Self.pgcDB.ActivePage) do
    begin
      Parent := Self.pgcDB.ActivePage;
      Height := 20;
      Width := 75;
      Left := 3+(i * 80) - (Ntmp * 14 * 80);
      Top := 15 + (Ntmp * 45);
      Name := Format('lbe%d',[i]);
      text := '';
      EditLabel.Caption := dbgTmp.Columns[i].Caption;
      cbxTmp.Properties.Items.Add(dbgTmp.Columns[i].Caption);

      if (((i + 1) mod 14) = 0) then
        Ntmp := Ntmp + 1;
    end;
  end;
  cbxTmp.ItemIndex := 0;
  Result := true;
end;

procedure TForm1.cbxColumnChange(Sender: TObject);
begin
  edtSearch.Text := '';
end;

procedure TForm1.cbxColumn_FDChange(Sender: TObject);
begin
  edtSearch.Text := '';
end;

procedure TForm1.cbxTablenameChange(Sender: TObject);
var
  I: Integer;
begin
  for I := Self.pgcDB.ActivePage.ComponentCount - 1 downto 0 do
  begin
    if Self.pgcDB.ActivePage.Components[i] is TLabeledEdit then
    begin
      Self.pgcDB.ActivePage.Components[i].Free;
    end;
  end;
  if Self.pgcDB.ActivePage.Caption = 'ADOC' then
  begin
    adqTmp.Close;
    adtTmp.Close;
    adtTmp.TableName := cbxTablename.Text;
    adtTmp.Open;
    dbgVeiw2.ClearItems;
    dbgVeiw2.DataController.DataSource := dtsAdt;
    dbgVeiw2.DataController.CreateAllItems();
    lbeCreate2();
    ModeCheck_Enabledchange();
  end
  else  
  begin
    fdqTmp.Close;
    fdtTmp.Close;
    fdtTmp.TableName := cbxTablename_FD.Text;
    fdtTmp.Open;
    dbgVeiw_FD.DataSource := dtsFdt;
    lbeCreate();
    ModeCheck_Enabledchange();
  end;
end;

procedure TForm1.dbgVeiw2CellClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
var
  I : Integer;
begin
  for I := 0 to Self.pgcDB.ActivePage.ComponentCount - 1 do
  begin
    (Self.pgcDB.ActivePage.Components[i] as TLabeledEdit).Text := VarToStr(Sender.Controller.SelectedRecords[0].Values[i]);
  end;
end;

procedure TForm1.dbgVeiwDblClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Self.pgcDB.ActivePage.ComponentCount - 1 do
  begin
    (Self.pgcDB.ActivePage.Components[i] as TLabeledEdit).Text := ((Sender as TDBGrid).Fields[i].ToString);
  end;
end;

procedure TForm1.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnSearchClick(nil);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if odgConnection.Execute() then
  begin
    {
    ADOConnection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0; Data Source='
                                     + odgConnection.FileName
                                     + ';Persist Security Info=False';

    DBQ=C:\Users\20181151\Desktop\test\test.mdb;
    DefaultDir=C:\Users\20181151\Desktop\test;
    Driver='Microsoft Access Driver (*.mdb)'
    DriverId=25;
    FIL=MS Access;
    FILEDSN=C:\Users\20181151\Desktop\test\myODBC.dsn;
    MaxBufferSize=2048;
    MaxScanRows=8;
    PageTimeout=5;
    SafeTransactions=0;
    Threads=1;
    UID=admin;
    UserCommitSync=Yes;

    ADOConnection.ConnectionString = 'FILE NAME=' + odgConnection.FileName;
    ADOConnection.Connected := true;
    }
    ADOConnection.GetTableNames(cbxTablename.Properties.Items, false);
    FDConnection.Params.Database := odgConnection.FileName;

    FDConnection.Connected := true;
    FDConnection.GetTableNames('','','',cbxTablename_FD.Properties.Items);

  end
end;

end.
