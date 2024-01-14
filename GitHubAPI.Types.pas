unit GitHubAPI.Types;

interface

uses
  System.Generics.Collections, REST.Json.Types;

type

  TCustomGitHubUser = class
  protected
    [JSONName('login')]
    Login: string;

    [JSONName('id')]
    ID: string;

    [JSONName('node_id')]
    NodeID: string;

    [JSONName('avatar_url')]
    AvatarUrl: string;

    [JSONName('gravatar_id')]
    GravatarID: string;

    [JSONName('url')]
    Url: string;

    [JSONName('html_url')]
    HtmlUrl: string;

    [JSONName('followers_url')]
    FollowersUrl: string;

    [JSONName('following_url')]
    FollowingUrl: string;

    [JSONName('gists_url')]
    GistsUrl: string;

    [JSONName('starred_url')]
    StarredUrl: string;

    [JSONName('subscriptions_url')]
    SubscriptionsUrl: string;

    [JSONName('organizations_url')]
    OrganizationsUrl: string;

    [JSONName('repos_url')]
    ReposUrl: string;

    [JSONName('events_url')]
    EventsUrl: string;

    [JSONName('received_events_url')]
    ReceivedEventsUrl: string;

    [JSONName('type')]
    &Type: Boolean;

    [JSONName('site_admin')]
    SiteAdmin: Boolean;

  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TCustomGitHubUser }

constructor TCustomGitHubUser.Create;
begin
  inherited Create;
end;

destructor TCustomGitHubUser.Destroy;
begin
  inherited;
end;

end.
