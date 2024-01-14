unit GitHubAPI.Users;

interface

uses
  System.Generics.Collections, REST.Json.Types, GitHubAPI.Types,
  GitHubAPI.Followers, GitHubAPI.Plans;

type

  TGitHubUser = class(TCustomGitHubUser)
  public
    destructor Destroy; override;
  end;

  TGitHubAuthenticatedUser = class(TGitHubUser)
  public
    [JSONName('name')]
    Name: string;

    [JSONName('company')]
    Company: string;

    [JSONName('blog')]
    Blog: string;

    [JSONName('location')]
    Location: string;

    [JSONName('email')]
    Email: string;

    [JSONName('hireable')]
    Hireable: Boolean;

    [JSONName('bio')]
    Bio: string;

    [JSONName('twitter_username')]
    TwitterUsername: string;

    [JSONName('public_repos')]
    PublicRepos: Integer;

    [JSONName('public_gists')]
    PublicGists: Integer;

    [JSONName('followers')]
    Followers: Integer;

    [JSONName('following')]
    Following: Integer;

    [JSONName('created_at')]
    CreatedAt: TDateTime;

    [JSONName('updated_at')]
    UpdatedAt: TDateTime;

    [JSONName('private_gists')]
    PrivateGists: Integer;

    [JSONName('total_private_repos')]
    TotalPrivateRepos: Integer;

    [JSONName('owned_private_repos')]
    OwnedPrivateRepos: Integer;

    [JSONName('disk_usage')]
    DiskUsage: Integer;

    [JSONName('collaborators')]
    Collaborators: Integer;

    [JSONName('plan')]
    Plan: TGitHubPlan;
  public
    procedure Block;
    constructor Create;
    destructor Destroy; override;
    procedure Unblock;
  end;

  TGitHubUsers = class
  private
    FGitHubFollowers: TGitHubFollowers;
    FGitHubUser: TGitHubUser;
    FList: TObjectList<TGitHubUser>;
    FAuthenticatedUser: TGitHubAuthenticatedUser;
    FAuthenticatedUserName: string;
//    FGitHubBlocked: TGitHubBlocked;
    function GetGitHubFollowers: TGitHubFollowers;
    function GetGitHubUser: TGitHubUser;
    function _GetGitHubUserName(const UserName: string): TGitHubAuthenticatedUser;
    function GetAuthenticatedGitHubUser: TGitHubAuthenticatedUser;
    function GetGitHubUserByUserName(const UserName: string): TGitHubAuthenticatedUser;
  public
    constructor Create;
    destructor Destroy; override;

    function List: TObjectList<TGitHubUser>;

    property AuthenticatedUser: TGitHubAuthenticatedUser read GetAuthenticatedGitHubUser;
//    property Blocked: TGitHubBlocked read GetGitHubBlocked;
    property Followers: TGitHubFollowers read GetGitHubFollowers;
    property User: TGitHubUser read GetGitHubUser;
    property Users[const UserName: string]: TGitHubAuthenticatedUser read GetGitHubUserByUserName; default;
  end;

implementation

uses
  System.SysUtils, GitHubAPI, System.JSON, REST.Json, REST.Client,
  REST.Client.Helper;

{ TGitHubUser }

destructor TGitHubUser.Destroy;
begin
  inherited;
end;

{ TGitHubAuthenticatedUser }

procedure TGitHubAuthenticatedUser.Block;
var
  LBlockUserName: string;
begin
  if not Assigned(Self) then
    Exit;
  GitHub.AddDefaultHeaders;
  LBlockUserName := Format('/user/blocks/%s', [Login]);
  RESTRequest.Put(LBlockUserName, []);
end;

constructor TGitHubAuthenticatedUser.Create;
begin
  inherited Create;
end;

destructor TGitHubAuthenticatedUser.Destroy;
begin
  inherited;
end;

procedure TGitHubAuthenticatedUser.Unblock;
var
  LBlockUserName: string;
begin
  GitHub.AddDefaultHeaders;
  LBlockUserName := Format('/user/blocks/%s', [Login]);
  RESTRequest.Delete(LBlockUserName);
end;

{ TGitHubUsers }

constructor TGitHubUsers.Create;
begin
  inherited Create;
//  FAuthenticatedUser := TGitHubAuthenticatedUser.Create;
end;

destructor TGitHubUsers.Destroy;
begin
  FGitHubFollowers.Free;
  FGitHubUser.Free;
  FList.Free;
  FAuthenticatedUser.Free;
  inherited;
end;

function TGitHubUsers.GetAuthenticatedGitHubUser: TGitHubAuthenticatedUser;
begin
  Result := _GetGitHubUserName('/user');
  if Assigned(Result) then
    FAuthenticatedUserName := Result.Login;
end;

function TGitHubUsers.GetGitHubFollowers: TGitHubFollowers;
begin
  if not Assigned(FGitHubFollowers) then
    FGitHubFollowers := TGitHubFollowers.Create;

  Result := FGitHubFollowers;
end;

function TGitHubUsers.GetGitHubUser: TGitHubUser;
begin
  if not Assigned(FAuthenticatedUser) then
    AuthenticatedUser;
  Result := FAuthenticatedUser;
end;

function TGitHubUsers.GetGitHubUserByUserName(
  const UserName: string): TGitHubAuthenticatedUser;
var
  LUserName: string;
begin
  LUserName := Format('/users/%s', [UserName]);
  Result := _GetGitHubUserName(LUserName);
end;

function TGitHubUsers.List: TObjectList<TGitHubUser>;
begin
  FreeAndNil(FList);
  GitHub.AddDefaultHeaders;
  FList := RESTRequest.GetEntityList<TGitHubUser>('/users');
  Result := FList;
end;

function TGitHubUsers._GetGitHubUserName(
  const UserName: string): TGitHubAuthenticatedUser;
begin
  FreeAndNil(FAuthenticatedUser);
  GitHub.AddDefaultHeaders;
  try
    FAuthenticatedUser := RESTRequest.GetFixedEntity<TGitHubAuthenticatedUser>(UserName);
    Result := FAuthenticatedUser;
  except
    FAuthenticatedUser := nil;
    Result := nil;
  end;
end;

end.
