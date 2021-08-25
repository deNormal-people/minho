object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 660
  ClientWidth = 1153
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pgcDB: TcxPageControl
    Left = 8
    Top = 8
    Width = 1137
    Height = 644
    TabOrder = 0
    Properties.ActivePage = tasADOC
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 640
    ClientRectLeft = 4
    ClientRectRight = 1133
    ClientRectTop = 24
    object tasADOC: TcxTabSheet
      Caption = 'ADOC'
      ExplicitLeft = 68
      ExplicitTop = 168
      object cbxTablename: TcxComboBox
        Left = 3
        Top = 138
        Properties.OnChange = cbxTablenameChange
        TabOrder = 0
        Width = 145
      end
      object btnSearch: TcxButton
        Left = 804
        Top = 136
        Width = 75
        Height = 25
        Caption = #44160#49353
        TabOrder = 1
        OnClick = btnSearchClick
      end
      object btnInsert: TcxButton
        Left = 885
        Top = 136
        Width = 75
        Height = 25
        Caption = #51077#47141
        TabOrder = 2
        OnClick = btnInsertClick
      end
      object btnUpdate: TcxButton
        Left = 966
        Top = 136
        Width = 75
        Height = 25
        Caption = #49688#51221#47784#46300
        TabOrder = 3
        OnClick = btnUpdateClick
      end
      object btnDelete: TcxButton
        Left = 1047
        Top = 136
        Width = 75
        Height = 25
        Caption = #49325#51228#47784#46300
        TabOrder = 4
        OnClick = btnDeleteClick
      end
      object edtSearch: TEdit
        Left = 677
        Top = 138
        Width = 121
        Height = 21
        TabOrder = 5
        OnKeyPress = edtSearchKeyPress
      end
      object cbxColumn: TcxComboBox
        Left = 584
        Top = 138
        TabOrder = 6
        OnClick = cbxColumnChange
        Width = 87
      end
      object cxGrid1: TcxGrid
        Left = 3
        Top = 164
        Width = 1123
        Height = 449
        TabOrder = 7
        object dbgVeiw2: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          OnCellClick = dbgVeiw2CellClick
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
        end
        object cxGrid1Level1: TcxGridLevel
          GridView = dbgVeiw2
        end
      end
    end
    object tasFireDAC: TcxTabSheet
      Caption = 'fireDAC'
      ImageIndex = 1
      object dbgVeiw_FD: TDBGrid
        Left = 3
        Top = 160
        Width = 1123
        Height = 456
        DataSource = dtsFdt
        Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = dbgVeiwDblClick
      end
      object cbxTablename_FD: TcxComboBox
        Left = 0
        Top = 133
        TabOrder = 1
        OnClick = cbxTablenameChange
        Width = 145
      end
      object cbxColumn_FD: TcxComboBox
        Left = 584
        Top = 131
        TabOrder = 2
        OnClick = cbxColumn_FDChange
        Width = 87
      end
      object edtSearch_FD: TEdit
        Left = 677
        Top = 131
        Width = 121
        Height = 21
        TabOrder = 3
      end
      object btnSearch_FD: TcxButton
        Left = 804
        Top = 129
        Width = 75
        Height = 25
        Caption = #44160#49353
        TabOrder = 4
        OnClick = btnSearch_FDClick
      end
      object btnInsert_FD: TcxButton
        Left = 885
        Top = 129
        Width = 75
        Height = 25
        Caption = #51077#47141
        TabOrder = 5
        OnClick = btnInsert_FDClick
      end
      object btnUpdate_FD: TcxButton
        Left = 966
        Top = 129
        Width = 75
        Height = 25
        Caption = #49688#51221#47784#46300
        TabOrder = 6
        OnClick = btnUpdate_FDClick
      end
      object btnDelete_FD: TcxButton
        Left = 1046
        Top = 129
        Width = 75
        Height = 25
        Caption = #49325#51228#47784#46300
        TabOrder = 7
        OnClick = btnDelete_FDClick
      end
    end
  end
  object ADOConnection: TADOConnection
    Connected = True
    ConnectionString = 'FILE NAME=C:\Users\20181151\Desktop\test\myODBC.dsn'
    KeepConnection = False
    LoginPrompt = False
    Left = 769
    Top = 547
  end
  object odgConnection: TOpenDialog
    Filter = 'database|*.mdb|dsn|*.dsn'
    Left = 769
    Top = 596
  end
  object adqTmp: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    Left = 849
    Top = 596
  end
  object adtTmp: TADOTable
    Connection = ADOConnection
    TableName = 'TA220'
    Left = 849
    Top = 544
  end
  object dtsAdt: TDataSource
    DataSet = adtTmp
    Left = 913
    Top = 544
  end
  object dtsAdq: TDataSource
    DataSet = adqTmp
    Left = 913
    Top = 596
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=C:\Users\20181151\Desktop\test\test.mdb'
      'ODBCDriver={Microsoft Access Driver (*.mdb)}'
      'DriverID=ODBC')
    LoginPrompt = False
    Left = 41
    Top = 544
  end
  object fdtTmp: TFDTable
    Connection = FDConnection
    Left = 113
    Top = 544
  end
  object fdqTmp: TFDQuery
    Connection = FDConnection
    Left = 112
    Top = 600
  end
  object dtsFdt: TDataSource
    DataSet = fdtTmp
    Left = 185
    Top = 544
  end
  object dtsFdq: TDataSource
    DataSet = fdqTmp
    Left = 185
    Top = 600
  end
end
