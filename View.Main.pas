unit View.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.ListView, FMX.StdCtrls,
  FMX.Layouts;

type
  TfrmMain = class(TForm)
    lv: TListView;
    log: TMemo;
    GridPanelLayout1: TGridPanelLayout;
    lblScrollPos: TLabel;
    lblItemsHeight: TLabel;
    procedure lvUpdateObjects(const Sender: TObject; const AItem: TListViewItem);
    procedure FormCreate(Sender: TObject);
    procedure lvScrollViewChange(Sender: TObject);
  private
    fCachedItemsHeight: Single;

    procedure GenerateItems(const below: Boolean; beforeOrAfterItem: TListViewItem; const numItems: Integer);
    procedure LogAdd(const msg: String);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Utils.ListViewHelper;

{$R *.fmx}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  fCachedItemsHeight:=0;

  GenerateItems(True, nil, 50);

  lv.ScrollTo(28);
end;

procedure TfrmMain.GenerateItems(const below: Boolean; beforeOrAfterItem: TListViewItem; const numItems: Integer);
var
  I: Integer;
  newTag: Integer;
begin
  if below then
  begin
    if beforeOrAfterItem <> nil then
      newTag:=beforeOrAfterItem.Tag+1
    else
      newTag:=0;

    //Add the necessary items
    lv.BeginUpdate;
    try
      for I := 0 to numItems-1 do
      begin
        var li:=lv.Items.Add;
        li.Tag:=newTag;
        li.Text:='Item #'+li.Tag.ToString;

        Inc(newTag);
      end;
    finally
      lv.EndUpdate;

      fCachedItemsHeight:=0; //reset it to make sure this is recalculated using the new number of items
    end;
  end
  else
  begin
    if beforeOrAfterItem <> nil then
      newTag:=beforeOrAfterItem.Tag-1
    else
      newTag:=0;

    var newItemsHeight: Single := 0;

    //Add the necessary items
    lv.BeginUpdate;
    try
      for I := 0 to numItems-1 do
      begin
        var li:=lv.Items.Insert(0);
        li.Tag:=newTag;
        li.Text:='Item #'+li.Tag.ToString;

        newItemsHeight:=newItemsHeight + lv.ItemHeight(li.Index);

        Dec(newTag);
      end;
    finally
      lv.EndUpdate;

      lv.Paint; //forces the list to recalculate itself

      fCachedItemsHeight:=0; //reset it to make sure this is recalculated using the new number of items

      //Now set the scrolled item to current position + number of items added so it stays in the same position from a user's perspective
      lv.ScrollViewPos:=lv.ScrollViewPos + newItemsHeight;
    end;
  end;
end;

procedure TfrmMain.LogAdd(const msg: String);
begin
  log.Lines.Add(msg);
  log.SelStart:=log.Text.Length;
end;

procedure TfrmMain.lvScrollViewChange(Sender: TObject);
begin
  if fCachedItemsHeight = 0 then
    fCachedItemsHeight:=lv.TotalItemsHeight;

  lblItemsHeight.Text:='Height: '+Trunc(fCachedItemsHeight).ToString;
  lblScrollPos.Text  :='Scroll: '+Trunc(lv.ScrollViewPos).ToString;

  if lv.ScrollViewPos < (lv.ItemAppearance.ItemHeight * 2) then
  begin
    logAdd('More needed ABOVE');
    GenerateItems(False, lv.Items[0], 50);
  end

  //Scroll pos is always to the top of the list view so the bottom is the scrollpos + height of the list view
  else if lv.ScrollViewPos > fCachedItemsHeight - lv.Height - lv.ItemAppearance.ItemHeight then
  begin
    logAdd('More needed BELOW');
    GenerateItems(True, lv.Items[lv.Items.Count-1], 50);
  end;
end;

procedure TfrmMain.lvUpdateObjects(const Sender: TObject; const AItem: TListViewItem);
begin
  logAdd('UpdateObjects('+AItem.Tag.ToString+': '+AItem.Text+')');
end;

end.
