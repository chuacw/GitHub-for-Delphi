unit GitHubAPI.Actions;

interface

uses
  System.Generics.Collections, REST.Json.Types;

type

  TGitHubWorkflowRun = class;

  TGitHubWorkflowRun = class
  private
    [JSONName('head_branch')]
    FHeadBranch: string;
    [JSONName('head_repository_id')]
    FHeadRepositoryId: Integer;
    [JSONName('head_sha')]
    FHeadSha: string;
    FId: Integer;
    [JSONName('repository_id')]
    FRepositoryId: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property HeadBranch: string read FHeadBranch write FHeadBranch;
    property HeadRepositoryId: Integer read FHeadRepositoryId write FHeadRepositoryId;
    property HeadSha: string read FHeadSha write FHeadSha;
    property Id: Integer read FId write FId;
    property RepositoryId: Integer read FRepositoryId write FRepositoryId;
  end;

  TGitHubArtifact = class
  protected
    [JSONName('archive_download_url')]
    FArchiveDownloadUrl: string;
    [JSONName('created_at')]
    FCreatedAt: TDateTime;
    FExpired: Boolean;
    [JSONName('expires_at')]
    FExpiresAt: TDateTime;
    FId: Integer;
    FName: string;
    [JSONName('node_id')]
    FNodeId: string;
    [JSONName('size_in_bytes')]
    FSizeInBytes: Integer;
    [JSONName('updated_at')]
    FUpdatedAt: TDateTime;
    FUrl: string;
    [JSONName('workflow_run')]
    FWorkflowRun: TGitHubWorkflowRun;
  public
    property ArchiveDownloadUrl: string read FArchiveDownloadUrl write FArchiveDownloadUrl;
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
    property Expired: Boolean read FExpired write FExpired;
    property ExpiresAt: TDateTime read FExpiresAt write FExpiresAt;
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
    property NodeId: string read FNodeId write FNodeId;
    property SizeInBytes: Integer read FSizeInBytes write FSizeInBytes;
    property UpdatedAt: TDateTime read FUpdatedAt write FUpdatedAt;
    property Url: string read FUrl write FUrl;
    property WorkflowRun: TGitHubWorkflowRun read FWorkflowRun;
  public
    constructor Create;
    destructor Destroy; override;
  end;

//  TRoot = class(TJsonDTO)
//  private
//    [JSONName('artifacts'), JSONMarshalled(False)]
//    FArtifactsArray: TArray<TArtifacts>;
//    [GenericListReflect]
//    FArtifacts: TObjectList<TArtifacts>;
//    [JSONName('total_count')]
//    FTotalCount: Integer;
//    function GetArtifacts: TObjectList<TArtifacts>;
//  protected
//    function GetAsJson: string; override;
//  published
//    property Artifacts: TObjectList<TArtifacts> read GetArtifacts;
//    property TotalCount: Integer read FTotalCount write FTotalCount;
//  public
//    destructor Destroy; override;
//  end;

  TGitHubArtifacts = class
  protected
    function GetArtifact(const ArtifactID: string): TGitHubArtifact;

  protected
    [JSONName('artifacts')]
    FArtifacts: TObjectList<TGitHubArtifact>;
    [JSONName('total_count')]
    FTotalCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Delete(const ArtifactID: string);
    function Download(const ArtifactID: string): string;
    property Artifact[const ArtifactID: string]: TGitHubArtifact read GetArtifact;
  end;

implementation

uses
  System.Generics.Defaults, System.SysUtils;

{ TGitHubArtifacts }

constructor TGitHubArtifacts.Create;
begin
  inherited Create;
  FArtifacts := TObjectList<TGitHubArtifact>.Create;
end;

procedure TGitHubArtifacts.Delete(const ArtifactID: string);
begin
end;

destructor TGitHubArtifacts.Destroy;
begin
  FArtifacts.Free;
  inherited;
end;

function TGitHubArtifacts.Download(const ArtifactID: string): string;
begin

end;

function TGitHubArtifacts.GetArtifact(
  const ArtifactID: string): TGitHubArtifact;
var
  LItem: TGitHubArtifact;
  LFoundIndex: Integer;
begin
  LItem := TGitHubArtifact.Create;
  LItem.Name := ArtifactID;
  if FArtifacts.BinarySearch(LItem, LFoundIndex, TDelegatedComparer<TGitHubArtifact>.Create(
    function(const Left, Right: TGitHubArtifact): Integer
    begin
      Result := CompareText(Left.Name, Right.Name);
    end
  )) then
    Result := FArtifacts.Items[LFoundIndex] else
    Result := nil;
end;

{ TGitHubArtifact }

constructor TGitHubArtifact.Create;
begin
  inherited Create;
  FWorkflowRun := TGitHubWorkflowRun.Create;
end;

destructor TGitHubArtifact.Destroy;
begin
  FWorkflowRun.Free;
  inherited;
end;

{ TGitHubWorkflowRun }

constructor TGitHubWorkflowRun.Create;
begin
  inherited;
end;

destructor TGitHubWorkflowRun.Destroy;
begin
  inherited;
end;

end.
