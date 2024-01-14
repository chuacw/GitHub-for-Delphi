object GitHub: TGitHub
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object RESTResponse: TRESTResponse
    Left = 272
    Top = 168
  end
  object RESTClient: TRESTClient
    Params = <>
    SecureProtocols = [TLS12, TLS13]
    SynchronizedEvents = False
    Left = 176
    Top = 168
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Params = <>
    Response = RESTResponse
    SynchronizedEvents = False
    Left = 176
    Top = 240
  end
end
