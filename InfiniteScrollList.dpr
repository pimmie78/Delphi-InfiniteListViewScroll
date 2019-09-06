program InfiniteScrollList;

uses
  System.StartUpCopy,
  FMX.Forms,
  View.Main in 'View.Main.pas' {frmMain},
  Utils.ListViewHelper in 'Utils.ListViewHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
