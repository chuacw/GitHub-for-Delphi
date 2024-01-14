unit GitHubAPI.Ratelimit;

interface

uses
  REST.Json.Types;

type

  TGitHubRateLimit = class
  private
    FLimit: Integer;
    FRemaining: Integer;
    FResource: string;
    FUsed: Integer;
    FReset: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    property Limit: Integer read FLimit write FLimit;
    property Remaining: Integer read FRemaining write FRemaining;
    property Reset: Integer read FReset write FReset;
    property Resource: string read FResource write FResource;
    property Used: Integer read FUsed write FUsed;
  end;

implementation


{ TGitHubRateLimit }

constructor TGitHubRateLimit.Create;
begin

end;

destructor TGitHubRateLimit.Destroy;
begin

  inherited;
end;

end.
