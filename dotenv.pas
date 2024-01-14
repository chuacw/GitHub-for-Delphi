unit dotenv;

interface

uses
  System.Classes, System.Messaging;

type

  /// <summary>
  /// Imitates the dotenv class from Nodejs / TypeScript
  /// Access all values using process.env['name'].
  /// By default, loads values from the file: .env
  /// Each line in the file is Name=Value
  /// Anything starting with # signifies a comment. It can be at the beginning
  /// of a line, or after the value.
  /// </summary>
  TProcessEnv = class
  private
    function GetEnvValue(const Name: string): string;
    procedure SetEnvValue(const Name, Value: string);
  protected
    FLastSaved: TDateTime;
    FSearchUpwards: Boolean;
    FLoaded, FDirty, FTrimTrailingBlanks: Boolean;
    FSL: TStringList;
    FFileName: string;
  public
    constructor Create(const AFileName: string = '';
      const ASearchUpwards: Boolean = True;
      const ATrimTrailingBlanks: Boolean = True);
    destructor Destroy; override;

//    procedure ClearAll;

    function GetDefaultFileName(const AFileName: string = ''): string;

    class procedure Clear; static;
    procedure ReloadFrom(const AFileName: string = '');
    procedure Flush;

    property env[const Name: string]: string read GetEnvValue write SetEnvValue; default;
    property FileName: string read FFileName write FFileName;
    property SearchUpwards: Boolean read FSearchUpwards write FSearchUpwards;
    property TrimTrailingBlanks: Boolean read FTrimTrailingBlanks write
      FTrimTrailingBlanks;

  end;

  TSetEnvValue = class(TMessage)
  protected
    FName: string;
    FValue: string;
  public
    constructor Create(const AName, AValue: string);
    property Name: string read FName;
    property Value: string read FValue;
  end;

  function process: TProcessEnv;

implementation

uses
  System.SysUtils, System.DateUtils;

{ TSetEnvValue }

constructor TSetEnvValue.Create(const AName, AValue: string);
begin
  inherited Create;
  FName  := AName;
  FValue := AValue;
end;

{ TProcessEnv }

var
  GProcess: TProcessEnv = nil;

function process: TProcessEnv;
begin
  if GProcess = nil then
    begin
      GProcess := TProcessEnv.Create;
    end;
  Result := GProcess;
end;

class procedure TProcessEnv.Clear;
begin
  FreeAndNil(GProcess);
end;

constructor TProcessEnv.Create(const AFileName: string;
  const ASearchUpwards: Boolean;
  const ATrimTrailingBlanks: Boolean);
begin
  inherited Create;
  FSearchUpwards := ASearchUpwards;
  FTrimTrailingBlanks := ATrimTrailingBlanks;

  FDirty := False;

  FSL := TStringList.Create;
  FSL.StrictDelimiter := True;
  FSL.Delimiter := '=';

  FFileName := AFileName;
  FLastSaved := Now;
end;

destructor TProcessEnv.Destroy;
begin
  Flush;
  FSL.Free;
  inherited;
end;

procedure TProcessEnv.Flush;
var
  LFileName: string;
begin
  if FDirty then
    begin
      LFileName := GetDefaultFileName(FFileName);
      FSL.SaveToFile(LFileName);
      FDirty := False;
    end;
end;

function TProcessEnv.GetEnvValue(const Name: string): string;
var
  CommentI: Integer;
begin
  if not Assigned(Self) then
    Exit('');
  if not FLoaded then
    ReloadFrom(FFileName);
  Result := FSL.Values[Name];
  CommentI := Pos('#', Result);
  if CommentI <> 0 then
    Delete(Result, CommentI, Length(Result));
  if FTrimTrailingBlanks then
    Result := TrimRight(Result);
end;

procedure TProcessEnv.ReloadFrom(const AFileName: string = '');
var
  LDir, LFileName, LFileNameOnly: string;
  I: Integer;
  FTempSL: TStringList;
begin
  FTempSL := nil;
  if FSearchUpwards then
    begin
      if AFileName = '' then
        begin
          LDir := ExtractFileDir(ParamStr(0));
          LFileNameOnly := '.env';
        end else
        begin
          LFileNameOnly := ExtractFileName(AFileName);
          LDir := ExtractFileDir(AFileName);
          if LDir = '' then
            LDir := ExtractFileDir(ParamStr(0));
        end;
      repeat
        if LDir <> '' then
          LFileName := IncludeTrailingPathDelimiter(LDir) + LFileNameOnly;
        if FileExists(LFileName) then
          begin
            Break;
          end else
          begin
            I := LastDelimiter(PathDelim, LDir);
            if I > 0 then
              LDir := Copy(LDir, 1, I-1) else
              LDir := '';
          end;
      until LDir = '';
    end else
    begin
      LFileName := AFileName; // Exact
    end;

  if FFileName <> LFileName then
    FFileName := LFileName;
  if not FileExists(LFileName) then
    Exit;

  if FDirty then
    begin
      FTempSL := TStringList.Create;
      FTempSL.AddStrings(FSL);
    end;

  FSL.Clear;
  FSL.LoadFromFile(LFileName);

  if FDirty then
    begin
      FSL.AddStrings(FTempSL);
      FSL.SaveToFile(LFileName);
      FTempSL.Free;
      FDirty := False;
    end;

  FLoaded := True;
end;

function TProcessEnv.GetDefaultFileName(const AFileName: string = ''): string;
var
  I: Integer;
  LDir, LFileName, LFileNameOnly: string;
begin
  if FSearchUpwards then
    begin
      if AFileName = '' then
        begin
          LDir := ExtractFileDir(ParamStr(0));
          LFileNameOnly := '.env';
        end else
        begin
          LFileNameOnly := ExtractFileName(AFileName);
          LDir := ExtractFileDir(AFileName);
          if LDir = '' then
            LDir := ExtractFileDir(ParamStr(0));
        end;
      repeat
        if LDir <> '' then
          LFileName := IncludeTrailingPathDelimiter(LDir) + LFileNameOnly;
        if FileExists(LFileName) then
          begin
            Break;
          end else
          begin
            I := LastDelimiter(PathDelim, LDir);
            if I > 0 then
              LDir := Copy(LDir, 1, I-1) else
              LDir := '';
          end;
      until LDir = '';
    end else
    begin
      Result := AFileName; // Exact
    end;

  if Result <> LFileName then
    Result := LFileName;

  FFileName := Result;
end;

procedure TProcessEnv.SetEnvValue(const Name, Value: string);
var
  LTempSL: TStringList;
begin
  TMessageManager.DefaultManager.SendMessage(Self, TSetEnvValue.Create(Name, Value));

  FSL.Values[Name] := Value;
  if FDirty and (MinutesBetween(Now, FLastSaved) >= 1) then
    begin
      LTempSL := TStringList.Create;
      try
        LTempSL.LoadFromFile(FFileName);
        var LExistingIndex := LTempSL.IndexOf(Name);
        if LExistingIndex <> -1 then
          LTempSL.Delete(LExistingIndex);
        FSL.Clear;
        FSL.Assign(LTempSL);
        FSL.Values[Name] := Value;
      finally
        LTempSL.Free;
      end;
      FSL.SaveToFile(FFileName);
      FLastSaved := Now;
      FDirty := False;
    end else
    begin
      FDirty := True;
    end;
end;

initialization
  GProcess := nil;
finalization
  GProcess.Free;
end.
