program GitHubCLI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

begin
  RESTClient1.BaseURL := 'https://trakt.tv/';
  RESTRequest1.Resource := 'calendars/my/movies/{start_date}/{days}';
  RESTRequest1.AddParameter('Authorization','Bearer ' + TraktAccessToken.Text, pkHTTPHEADER);
  RESTRequest1.AddParameter('trakt-api-version', '2', pkHTTPHEADER);
  RESTRequest1.AddParameter('trakt-api-key', TraktClientId.Text, pkHTTPHEADER);

  RESTRequest1.Params.AddItem('start_date', '2019-05-05', pkURLSEGMENT); // Dummy date
  RESTRequest1.Params.AddItem('days', '7', pkURLSEGMENT);                // Dummy time

  RESTRequest1.Method := TRESTRequestMethod.rmGET;
  RESTRequest1.Execute;
end.
