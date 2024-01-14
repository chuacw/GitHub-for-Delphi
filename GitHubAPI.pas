unit GitHubAPI;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, System.Generics.Collections,
  GitHubAPI.Notifications, GitHubAPI.Users, GitHubAPI.Ratelimit;

type
  TGitHub = class(TDataModule)
    RESTResponse: TRESTResponse;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FAuthToken: string;
    FNotifications: TObjectList<TNotification>;
    FUsers: TGitHubUsers;
    FGitHubRateLimit: TGitHubRateLimit;
    FOnAfterExecute: TCustomRESTRequestNotifyEvent;

    procedure SetAuthToken(const Value: string);
    function GetNotifications: TObjectList<TNotification>;
    function GetGitHubUsers: TGitHubUsers;

    procedure AfterExecute(Sender: TCustomRESTRequest);
    function GetGitHubRateLimit: TGitHubRateLimit;
  public
    { Public declarations }
    procedure AddDefaultHeaders; virtual;
    procedure Authenticate;
    destructor Destroy; override;
    function DumpHeaders(const AHeaders: TStrings): string;

    property Response: TRESTResponse read RESTResponse;
    property AuthToken: string read FAuthToken write SetAuthToken;
    property Notifications: TObjectList<TNotification> read GetNotifications;
    property Users: TGitHubUsers read GetGitHubUsers;
    property RateLimit: TGitHubRateLimit read GetGitHubRateLimit;

    property OnAfterExecute: TCustomRESTRequestNotifyEvent read FOnAfterExecute write FOnAfterExecute;
  end;

var
  GitHub: TGitHub;

function RESTClient: TRESTClient;
function RESTRequest: TRESTRequest;

implementation

uses
  REST.Client.Helper;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function RESTClient: TRESTClient;
begin
  Result := GitHub.RESTClient;
end;

function RESTRequest: TRESTRequest;
begin
  Result := GitHub.RESTRequest;
end;

{ TGitHub }

procedure TGitHub.AddDefaultHeaders;
begin
//  RESTClient.Accept := '';
//  RESTClient.AddAuthParameter('Authorization','Bearer ' + FAuthToken,
//    pkHTTPHEADER, [poDoNotEncode, poTransient]);
//  RESTClient.AddParameter('X-GitHub-Api-Version', '2022-11-28', pkHTTPHEADER);

  RESTRequest.ClearBody;
  RESTRequest.Params.Clear;
  RESTRequest.Accept := 'application/vnd.github+json';
  RESTRequest.AddAuthParameter('Authorization','Bearer ' + FAuthToken,
    pkHTTPHEADER, [poDoNotEncode, poTransient]);
  RESTRequest.AddParameter('X-GitHub-Api-Version', '2022-11-28', pkHTTPHEADER);
end;

procedure TGitHub.AfterExecute(Sender: TCustomRESTRequest);
begin
  if not Assigned(FGitHubRateLimit) then
    FGitHubRateLimit := TGitHubRateLimit.Create;

  FGitHubRateLimit.Limit := StrToInt(RESTResponse.Headers.Values['X-RateLimit-Limit']);
  FGitHubRateLimit.Remaining := StrToInt(RESTResponse.Headers.Values['X-RateLimit-Limit']);
  FGitHubRateLimit.Reset := StrToInt(RESTResponse.Headers.Values['X-RateLimit-Limit']);
  FGitHubRateLimit.Resource := RESTResponse.Headers.Values['X-RateLimit-Resource'];
  FGitHubRateLimit.Used := StrToInt(RESTResponse.Headers.Values['X-RateLimit-Used']);

  if Assigned(FOnAfterExecute) then
    FOnAfterExecute(Sender);
end;

procedure TGitHub.Authenticate;
begin
  AddDefaultHeaders;
end;

procedure TGitHub.DataModuleCreate(Sender: TObject);
begin
  RESTClient.BaseURL := 'https://api.github.com/';

  RESTClient.ProxyPort := 8888;
  RESTClient.ProxyServer := 'localhost';

  RESTRequest.Response := RESTResponse;
  RESTRequest.OnAfterExecute := AfterExecute;
end;

destructor TGitHub.Destroy;
begin
  FUsers.Free;
  FNotifications.Free;
  inherited;
end;

function TGitHub.DumpHeaders(const AHeaders: TStrings): string;
begin
  for var AHeader in AHeaders do
    begin
      Result := Result + AHeader + #13#10;
    end;
end;

function TGitHub.GetGitHubRateLimit: TGitHubRateLimit;
begin
  if not Assigned(FGitHubRateLimit) then
    FGitHubRateLimit := TGitHubRateLimit.Create;
  Result := FGitHubRateLimit;
end;

function TGitHub.GetGitHubUsers: TGitHubUsers;
begin
  if not Assigned(FUsers) then
    FUsers := TGitHubUsers.Create;
  Result := FUsers;
end;

function TGitHub.GetNotifications: TObjectList<TNotification>;
begin
   RESTRequest.AddAuthParameter('Authorization', 'Bearer ' + FAuthToken,
     pkHTTPHEADER, [poDoNotEncode]);
   for var LRESTClient in [RESTClient, RESTRequest.Client] do
     LRESTClient.AddAuthParameter('Authorization', 'Bearer ' + FAuthToken,
       pkHTTPHEADER, [poDoNotEncode]);

   FreeAndNil(FNotifications);
   var LNotifications := RESTRequest.GetEntityList<TNotification>('/notifications');

   FNotifications := LNotifications;
   Result := LNotifications;
end;

procedure TGitHub.SetAuthToken(const Value: string);
begin
  if FAuthToken <> Value then
    FAuthToken := Value;
end;

end.
