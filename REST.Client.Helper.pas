unit REST.Client.Helper;

interface

uses
  REST.Client, REST.Types, System.SysUtils, System.Generics.Collections;

type

  TFixedRESTClient = class helper for TRESTClient
  public
    procedure Delete(const AResource: string);
    function GetFixedEntity<T: class, constructor>(const AResource: string): T;
    procedure Method(const AMethod: TRESTRequestMethod; const AResource: string;
      const AllowedResponses: TArray<Integer>;
      const AProc: TProc<TRESTRequest> = nil);
    procedure Put(const AResource: string; const AllowedResponses: TArray<Integer>);
  end;

  TFixedRESTRequest = class helper for TRESTRequest
  public
    procedure Delete(const AResource: string);
    function GetFixedEntity<T: class, constructor>(const AResource: string): T;
    function GetEntityList<T: class, constructor>(const AResource: string): TObjectList<T>;
    procedure ExecuteMethod(const AMethod: TRESTRequestMethod; const AResource: string;
      const AllowedResponses: TArray<Integer>;
      const AProc: TProc<TRESTRequest> = nil);
    procedure Put(const AResource: string; const AllowedResponses: TArray<Integer>);
  end;

implementation

uses
  REST.Json, System.JSON, REST.Consts;

{ TFixedRESTClient }

procedure TFixedRESTClient.Delete(const AResource: string);
begin
  Method(rmDELETE, AResource, [204, 304, 401, 403]);
end;

function TFixedRESTClient.GetFixedEntity<T>(const AResource: string): T;
//var
//  LRequest: TRESTRequest;
var
  LResult: T;
begin
//  LRequest := TRESTRequest.Create(Self);
//  try
//    LRequest.Method := rmGET;
//    LRequest.Resource := AResource;
//    LRequest.Execute;
//    Result := TJson.JsonToObject<T>(LRequest.Response.JSONValue as TJSONObject);
//  finally
//    LRequest.Free;
//  end;
  LResult := nil;
  try
    Method(rmGET, AResource, [200, 304, 401, 403],
      procedure(ARequest: TRESTRequest)
      begin
        ARequest.Response.StatusCode;
        LResult := TJson.JsonToObject<T>(ARequest.Response.JSONValue as TJSONObject);
      end
    );
    Result := LResult;
  except
    LResult := nil;
    Result := nil;
  end;
end;

function ValidateInSet(AIntValue: Integer; const AIntSet: TArray<Integer>): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := Low(AIntSet) to High(AIntSet) do
  begin
    if AIntSet[I] = AIntValue then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TFixedRESTClient.Method(const AMethod: TRESTRequestMethod;
  const AResource: string; const AllowedResponses: TArray<Integer>;
  const AProc: TProc<TRESTRequest> = nil);
var
  LRequest: TRESTRequest;
begin
  LRequest := TRESTRequest.Create(Self);
  try
    LRequest.Method := AMethod;
    LRequest.Resource := AResource;
    LRequest.Execute;
    if not ValidateInSet(LRequest.Response.StatusCode, AllowedResponses) then
      raise Exception.Create(Format('Status Code: %d', [LRequest.Response.StatusCode]));
    if Assigned(AProc) then
      AProc(LRequest);
  finally
    LRequest.Free;
  end;
end;

procedure TFixedRESTClient.Put(const AResource: string;
  const AllowedResponses: TArray<Integer>);
begin
  Method(rmPUT, AResource, AllowedResponses);
end;

{ TFixedRESTRequest }

procedure TFixedRESTRequest.Delete(const AResource: string);
begin
  ExecuteMethod(rmDELETE, AResource, [204, 304, 401, 403]);
end;

function TFixedRESTRequest.GetEntityList<T>(
  const AResource: string): TObjectList<T>;
var
  LResponse: string;
  LJsonResponse: TJSONObject;
  LResponseArray: TJSONArray;
  i: Integer;
  LItem: T;
  LJSONObject: TJSONObject;
  LRequest: TRESTRequest;
begin
  Result := nil;
  LRequest := Self;

  LRequest.Method := rmGET;
  LRequest.Resource := AResource;
  LRequest.Execute;

  // Parse response as Json and try interpreting it as Array
  LResponseArray := LRequest.Response.JSONValue as TJSONArray;
  if LResponseArray <> nil then
  begin
    Result := TObjectList<T>.Create;
    // The array's items are supposed to be representations of class <T>
    for i := 0 to LResponseArray.Count - 1 do
    begin
      LJSONObject := LResponseArray.Items[i] as TJSONObject;
      LItem := TJson.JsonToObject<T>(LJSONObject);
      Result.Add(LItem);
    end;
  end
  else
    raise ERESTException.CreateFmt(sResponseDidNotReturnArray, [T.Classname]);

end;

function TFixedRESTRequest.GetFixedEntity<T>(const AResource: string): T;
var
  LResult: T;
  LJSONObject: TJSONObject;
begin
  LResult := nil;
  try
    ExecuteMethod(rmGET, AResource, [200, 304, 401, 403],
      procedure(ARequest: TRESTRequest)
      begin
        ARequest.Response.StatusCode;
        LJSONObject := ARequest.Response.JSONValue as TJSONObject;
        LResult := TJson.JsonToObject<T>(LJSONObject);
      end
    );
  except
    LResult := nil;
  end;
  Result := LResult;
end;

procedure TFixedRESTRequest.ExecuteMethod(const AMethod: TRESTRequestMethod;
  const AResource: string; const AllowedResponses: TArray<Integer>;
  const AProc: TProc<TRESTRequest>);
begin
  Method := AMethod;
  Resource := AResource;
  Execute;
  if not ValidateInSet(Response.StatusCode, AllowedResponses) then
    raise Exception.Create(Format('Status Code: %d', [Response.StatusCode]));
  if Assigned(AProc) then
    AProc(Self);
end;

procedure TFixedRESTRequest.Put(const AResource: string;
  const AllowedResponses: TArray<Integer>);
begin
  ExecuteMethod(rmPUT, AResource, AllowedResponses);
end;

end.
