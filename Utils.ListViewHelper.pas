unit Utils.ListViewHelper;

interface

uses
  FMX.ListView;

type
  TListViewHelper = class helper for TListView
  public
    function ItemHeight(const idx: Integer): Single;
    function TotalItemsHeight: Single;
  end;

implementation

uses
  FMX.ListView.Types;

{ TListViewHelper }

function TListViewHelper.ItemHeight(const idx: Integer): Single;
begin
  if (idx >= 0) and (idx < Self.Items.Count) then
  begin
    var item:=Self.Items[idx];

    Result:=item.Height;
    if Result <> 0 then //auto calculated;
      Exit;

    if item.Purpose = TListItemPurpose.None then
    begin
      if Self.EditMode then
        Result:=Self.ItemAppearance.ItemEditHeight
      else
        Result:=Self.ItemAppearance.ItemHeight;
    end
    else if item.Purpose = TListItemPurpose.Header then
      Result:=Self.ItemAppearance.HeaderHeight
    else if item.Purpose = TListItemPurpose.Footer then
      Result:=Self.ItemAppearance.FooterHeight;
  end
  else
    Result:=0;
end;

function TListViewHelper.TotalItemsHeight: Single;
begin
  Result:=0;
  for var I := 0 to Self.Items.Count-1 do
    Result:=Result + Self.ItemHeight(I);
end;

end.
