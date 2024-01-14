unit GitHubAPI.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  REST.Types, Vcl.StdCtrls, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FAuthToken: string;
    { Private declarations }
    procedure Authenticate(const AuthToken: string);
    function DumpHeaders(const AHeaders: TStrings): string;
    procedure AfterExecute(Sender: TCustomRESTRequest);
  public
    { Public declarations }
    property AuthToken: string read FAuthToken;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  GitHubAPI, System.IniFiles, dotenv;

procedure TForm1.AfterExecute(Sender: TCustomRESTRequest);
begin
  Memo1.Text := Sender.Response.JSONValue.Format;
end;

procedure TForm1.Authenticate(const AuthToken: string);
begin
  GitHub.AuthToken := AuthToken;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Authenticate(AuthToken);
// List Notifications
  var LNotifications := GitHub.Notifications;

// List Followers
  var LFollowers := GitHub.Users.Followers.List;
  if Assigned(LFollowers) then
    begin
      var LFollower := LFollowers.ToArray;
    end;

//  GitHub.Users.AuthenticatedUser;
//  var LTempUser := GitHub.Users['chuacwXXX32423423423412321313234'];
//  LTempUser.Block;
  Memo1.Clear;
  for var LNotification in LNotifications do
    begin
      Memo1.Lines.Add(Format('Repo: %s, Subject: %s', [
        LNotification.Repository.Name, LNotification.Subject.Title
      ]));
    end;

end;

function TForm1.DumpHeaders(const AHeaders: TStrings): string;
begin
  for var AHeader in AHeaders do
    begin
      Result := Result + AHeader + #13#10;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FAuthToken := process.env['AuthToken'];
  process.Clear;

  GitHub.OnAfterExecute := AfterExecute;
end;

end.
