unit GitHubAPI.Activity;

interface

uses
  System.Generics.Collections, REST.Json.Types;

type

  TGitHubActivity = class
  public
    destructor Destroy; override;
  end;

implementation


{ TGitHubActivity }

destructor TGitHubActivity.Destroy;
begin
  inherited;
end;

end.
