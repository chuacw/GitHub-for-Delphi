unit GitHubAPI.Followers;

interface

uses
  System.Generics.Collections, REST.Json.Types, GitHubAPI.Types;

type

  TGitHubFollower = class(TCustomGitHubUser)
//  protected
//    [JSONName('login')]
//    Login: string;
//
//    [JSONName('id')]
//    ID: string;
//
//    [JSONName('node_id')]
//    NodeID: string;
//
//    [JSONName('avatar_url')]
//    AvatarUrl: string;
//
//    [JSONName('gravatar_id')]
//    GravatarID: string;
//
//    [JSONName('url')]
//    Url: string;
//
//    [JSONName('html_url')]
//    HtmlUrl: string;
//
//    [JSONName('followers_url')]
//    FollowersUrl: string;
//
//    [JSONName('following_url')]
//    FollowingUrl: string;
//
//    [JSONName('gists_url')]
//    GistsUrl: string;
//
//    [JSONName('starred_url')]
//    StarredUrl: string;
//
//    [JSONName('subscriptions_url')]
//    SubscriptionsUrl: string;
//
//    [JSONName('organizations_url')]
//    OrganizationsUrl: string;
//
//    [JSONName('repos_url')]
//    ReposUrl: string;
//
//    [JSONName('events_url')]
//    EventsUrl: string;
//
//    [JSONName('received_events_url')]
//    ReceivedEventsUrl: string;
//
//    [JSONName('type')]
//    &Type: Boolean;
//
//    [JSONName('site_admin')]
//    SiteAdmin: Boolean;
  public
    destructor Destroy; override;
  end;

  TGitHubFollowers = class
  protected
    FList: TObjectList<TGitHubFollower>;
  public
    function List: TObjectList<TGitHubFollower>;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils, GitHubAPI, REST.Client.Helper;

{ TGitHubFollowers }

destructor TGitHubFollowers.Destroy;
begin
  FList.Free;
  inherited;
end;

function TGitHubFollowers.List: TObjectList<TGitHubFollower>;
begin
  FreeAndNil(FList);
  GitHub.AddDefaultHeaders;
  RESTRequest.Accept := 'application/vnd.github+json';
  FList := RESTRequest.GetEntityList<TGitHubFollower>('/user/followers');
  Result := FList;
end;

{ TGitHubFollower }

destructor TGitHubFollower.Destroy;
begin

  inherited;
end;

end.
