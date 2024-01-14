unit GitHubAPI.Plans;

interface

uses
  System.Generics.Collections, REST.Json.Types;

type

  TGitHubPlan = class
  protected
    [JSONName('name')]
    FName: string;

    [JSONName('space')]
    FSpace: Integer;

    [JSONName('private_repos')]
    FPrivateRepos: Integer;

    [JSONName('collaborators')]
    FCollaborators: Integer;
  public
    destructor Destroy; override;

    property Name: string read FName;
    property Space: Integer read FSpace;
    property PrivateRepos: Integer read FPrivateRepos;
    property Collaborators: Integer read FCollaborators;
  end;

implementation

{ TGitHubPlan }

destructor TGitHubPlan.Destroy;
begin
  inherited;
end;

end.
