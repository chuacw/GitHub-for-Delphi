unit GitHubAPI.Notifications;

interface

uses
  System.Generics.Collections, REST.Json.Types;

type
  TNotificationSubject = class
  protected
    [JSONName('title')]
    FTitle: string;

    [JSONName('url')]
    FUrl: string;

    [JSONName('latest_comment_url')]
    FLatestCommentUrl: string;

    [JSONName('type')]
    FType: string;
  public
    property Title: string read FTitle;
    property Url: string read FUrl;
    property LatestCommentUrl: string read FLatestCommentUrl;
    property &Type: string read FType;
  end;

  TNotificationOwner = class
  protected
    [JSONName('login')]
    Login: string;

    [JSONName('id')]
    ID: Integer;

    [JSONName('node_id')]
    NodeID: string;

    [JSONName('avatar_url')]
    AvatarURL: string;

    [JSONName('gravatar_url')]
    GravatarURL: string;

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
    &Type: string;

    [JSONName('site_admin')]
    SiteAdmin: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TNotificationRepository = class
  protected
    [JSONName('id')]
    ID: string;

    [JSONName('node_id')]
    NodeId: string;

    [JSONName('name')]
    FName: string;

    [JSONName('full_name')]
    FullName: string;

    [JSONName('private')]
    &private: Boolean;

    [JSONName('owner')]
    FOwner: TNotificationOwner;

    [JSONName('html_url')]
    HtmlUrl: string;

    [JSONName('description')]
    Description: string;

    [JSONName('fork')]
    Fork: Boolean;

    [JSONName('url')]
    Url: string;

    [JSONName('forks_url')]
    ForksUrl: string;

    [JSONName('keys_url')]
    KeysUrl: string;

    [JSONName('collaborators_url')]
    CollaboratorsUrl: string;

    [JSONName('teams_url')]
    TeamsUrl: string;

    [JSONName('hooks_url')]
    HooksUrl: string;

    [JSONName('issue_events_url')]
    IssueEventsUrl: string;

    [JSONName('events_url')]
    EventsUrl: string;

    [JSONName('assignees_url')]
    AssigneesUrl: string;

    [JSONName('branches_url')]
    BranchesUrl: string;

    [JSONName('tags_url')]
    TagsUrl: string;

    [JSONName('blobs_url')]
    BlobsUrl: string;

    [JSONName('git_tags_url')]
    GitTagsUrl: string;

    [JSONName('git_refs_url')]
    GitRefsUrl: string;

    [JSONName('trees_url')]
    TreesUrl: string;

    [JSONName('statuses_url')]
    StatusesUrl: string;

    [JSONName('languages_url')]
    LanguagesUrl: string;

    [JSONName('stargazers_url')]
    StargazersUrl: string;

    [JSONName('contributors_url')]
    ContributorsUrl: string;

    [JSONName('subscribers_url')]
    SubscribersUrl: string;

    [JSONName('subscription_url')]
    SubscriptionUrl: string;

    [JSONName('commits_url')]
    CommitsUrl: string;

    [JSONName('git_commits_url')]
    GitCommitsUrl: string;

    [JSONName('comments_url')]
    CommentsUrl: string;

    [JSONName('issue_comment_url')]
    IssueCommentUrl: string;

    [JSONName('contents_url')]
    ContentsUrl: string;

    [JSONName('merges_url')]
    MergesUrl: string;

    [JSONName('archive_url')]
    ArchiveUrl: string;

    [JSONName('downloads_url')]
    DownloadsUrl: string;

    [JSONName('issues_url')]
    IssuesUrl: string;

    [JSONName('pulls_url')]
    PullsUrl: string;

    [JSONName('milestones_url')]
    MilestonesUrl: string;

    [JSONName('notifications_url')]
    NotificationsUrl: string;

    [JSONName('labels_url')]
    LabelsUrl: string;

    [JSONName('releases_url')]
    ReleasesUrl: string;

    [JSONName('deployments_url')]
    DeploymentsUrl: string;
  public
    constructor Create;
    destructor Destroy; override;

    property Name: string read FName;
    property Owner: TNotificationOwner read FOwner;
  end;

  TNotification = class
  protected
    [JSONName('id')]
    FID: Integer;

    [JSONName('unread')]
    FUnread: Boolean;

    [JSONName('reason')]
    FReason: string;

    [JSONName('updated_at')]
    FUpdatedAt: TDateTime;

    [JSONName('last_read_at')]
    FLastReadAt: TDateTime;

    [JSONName('subject')]
    FSubject: TNotificationSubject;

    [JSONName('repository')]
    FRepository: TNotificationRepository;

    [JSONName('url')]
    FUrl: string;

    [JSONName('subscription_url')]
    FSubscriptionUrl: string;
  public

    constructor Create;
    destructor Destroy; override;

    property ID: Integer read FID;
    property LastReadAt: TDateTime read FLastReadAt;
    property Reason: string read FReason;
    property Repository: TNotificationRepository read FRepository;
    property Subject: TNotificationSubject read FSubject;
    property SubscriptionUrl: string read FSubscriptionUrl;
    property Unread: Boolean read FUnread;
    property UpdatedAt: TDateTime read FUpdatedAt;
    property Url: string read FUrl;
  end;

implementation

{ TNotification }

constructor TNotification.Create;
begin
  inherited Create;
  FRepository := TNotificationRepository.Create;
  FSubject := TNotificationSubject.Create;
end;

destructor TNotification.Destroy;
begin
  FRepository.Free;
  FSubject.Free;
  inherited;
end;

{ TNotificationOwner }

constructor TNotificationOwner.Create;
begin
  inherited;
end;

destructor TNotificationOwner.Destroy;
begin
  inherited;
end;

{ TNotificationRepository }

constructor TNotificationRepository.Create;
begin
  inherited Create;
  FOwner := TNotificationOwner.Create;
end;

destructor TNotificationRepository.Destroy;
begin
  FOwner.Free;
  inherited;
end;

end.
