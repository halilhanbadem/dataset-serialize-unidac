unit DataSet.Serialize.Samples.Basic;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.JSON, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, DataSet.Serialize, DataSet.Serialize.Import, MemDS,
  VirtualTable;

type
  TFrmSamples = class(TForm)
    pclSamples: TPageControl;
    tabDataSet: TTabSheet;
    dsUsers: TDataSource;
    Panel7: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    memoDataSet: TMemo;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel5: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    edtName: TEdit;
    edtCountry: TEdit;
    Button2: TButton;
    DBGrid1: TDBGrid;
    Panel6: TPanel;
    Button4: TButton;
    Button1: TButton;
    Button3: TButton;
    tabJSON: TTabSheet;
    Splitter1: TSplitter;
    Panel13: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    memoJSONArray: TMemo;
    btnLoadJSONArray: TButton;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel14: TPanel;
    memoJSONObject: TMemo;
    Button5: TButton;
    Panel15: TPanel;
    Button6: TButton;
    memoMerge: TMemo;
    DBGrid2: TDBGrid;
    Splitter2: TSplitter;
    tabEmptyDataSet: TTabSheet;
    Panel16: TPanel;
    dsEmpty: TDataSource;
    DBGrid3: TDBGrid;
    memoEmpty: TMemo;
    Panel17: TPanel;
    Button7: TButton;
    mmDataType: TMemo;
    vtUsers: TVirtualTable;
    vtUsersNAME: TWideStringField;
    vtUsersCOUNTRY: TWideStringField;
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLoadJSONArrayClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  end;

var
  FrmSamples: TFrmSamples;

implementation

uses System.TypInfo;

{$R *.dfm}

procedure TFrmSamples.btnLoadJSONArrayClick(Sender: TObject);
begin
  if not(vtUsers.Active) then
    vtUsers.Open;
  vtUsers.Clear;
  vtUsers.LoadFromJSON(memoJSONArray.Lines.Text);
end;

procedure TFrmSamples.Button1Click(Sender: TObject);
var
  LJSONArray: TJSONArray;
begin
  LJSONArray := vtUsers.ToJSONArray;
  try
    {$IF COMPILERVERSION < 33}
        memoDataSet.Lines.Text := LJSONArray.ToJSON;
    {$ELSE}
        memoDataSet.Lines.Text := LJSONArray.Format;
    {$ENDIF}
  finally
    LJSONArray.Free;
  end;
end;

procedure TFrmSamples.Button2Click(Sender: TObject);
begin
  vtUsers.Append;
  vtUsersNAME.AsString := edtName.Text;
  vtUsersCOUNTRY.AsString := edtCountry.Text;
  vtUsers.Post;
  edtName.Clear;
  edtCountry.Clear;
  edtName.SetFocus;
end;

procedure TFrmSamples.Button3Click(Sender: TObject);
var
  LJSONArray: TJSONArray;
begin
  LJSONArray := vtUsers.SaveStructure;
  try
{$IF COMPILERVERSION < 33}
    memoDataSet.Lines.Text := LJSONArray.ToJSON;
{$ELSE}
    memoDataSet.Lines.Text := LJSONArray.Format;
{$ENDIF}
  finally
    LJSONArray.Free;
  end;
end;

procedure TFrmSamples.Button4Click(Sender: TObject);
var
  LJSONObject: TJSONObject;
begin
  LJSONObject := vtUsers.ToJSONObject;
  try
{$IF COMPILERVERSION < 33}
    memoDataSet.Lines.Text := LJSONObject.ToJSON;
{$ELSE}
    memoDataSet.Lines.Text := LJSONObject.Format;
{$ENDIF}
  finally
    LJSONObject.Free;
  end;
end;

procedure TFrmSamples.Button5Click(Sender: TObject);
begin
  vtUsers.LoadFromJSON(memoJSONObject.Lines.Text);
end;

procedure TFrmSamples.Button6Click(Sender: TObject);
begin
  if not(vtUsers.Active) or vtUsers.IsEmpty then
    ShowMessage('No selected user to merge!')
  else
    vtUsers.MergeFromJSONObject(memoMerge.Lines.Text);
end;

procedure TFrmSamples.Button7Click(Sender: TObject);
var
  LField: TField;
begin
  vtUsers.LoadFromJSON(memoEmpty.Lines.Text);
  for LField in vtUsers.Fields do
    mmDataType.Lines.Add(Format('Field: %s - %s', [LField.FieldName, GetEnumName(System.TypeInfo(TFieldType), Ord(LField.DataType))]));
end;

procedure TFrmSamples.FormCreate(Sender: TObject);
begin
  vtUsers.Open;
end;

end.
