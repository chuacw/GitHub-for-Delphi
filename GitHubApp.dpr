program GitHubApp;

uses
  Vcl.Forms,
  GitHubAPI.Main in 'GitHubAPI.Main.pas' {Form1},
  GitHubAPI in 'GitHubAPI.pas' {GitHub: TDataModule},
  GitHubAPI.Artifacts in 'GitHubAPI.Artifacts.pas',
  GitHubAPI.Activity in 'GitHubAPI.Activity.pas',
  GitHubAPI.Apps in 'GitHubAPI.Apps.pas',
  GitHubAPI.Billing in 'GitHubAPI.Billing.pas',
  GitHubAPI.Branches in 'GitHubAPI.Branches.pas',
  GitHubAPI.Checks in 'GitHubAPI.Checks.pas',
  GitHubAPI.CodeScanning in 'GitHubAPI.CodeScanning.pas',
  GitHubAPI.CodesOfConduct in 'GitHubAPI.CodesOfConduct.pas',
  GitHubAPI.Codespaces in 'GitHubAPI.Codespaces.pas',
  GitHubAPI.Collaborators in 'GitHubAPI.Collaborators.pas',
  GitHubAPI.Commits in 'GitHubAPI.Commits.pas',
  GitHubAPI.Dependabot in 'GitHubAPI.Dependabot.pas',
  GitHubAPI.DependencyGraph in 'GitHubAPI.DependencyGraph.pas',
  GitHubAPI.DeployKeys in 'GitHubAPI.DeployKeys.pas',
  GitHubAPI.Deployments in 'GitHubAPI.Deployments.pas',
  GitHubAPI.Emails in 'GitHubAPI.Emails.pas',
  GitHubAPI.Emojis in 'GitHubAPI.Emojis.pas',
  GitHubAPI.Followers in 'GitHubAPI.Followers.pas',
  GitHubAPI.Gists in 'GitHubAPI.Gists.pas',
  GitHubAPI.GitDatabase in 'GitHubAPI.GitDatabase.pas',
  GitHubAPI.GitIgnore in 'GitHubAPI.GitIgnore.pas',
  GitHubAPI.Interactions in 'GitHubAPI.Interactions.pas',
  GitHubAPI.Issues in 'GitHubAPI.Issues.pas',
  GitHubAPI.Licenses in 'GitHubAPI.Licenses.pas',
  GitHubAPI.Markdown in 'GitHubAPI.Markdown.pas',
  GitHubAPI.Meta in 'GitHubAPI.Meta.pas',
  GitHubAPI.Metrics in 'GitHubAPI.Metrics.pas',
  GitHubAPI.Migrations in 'GitHubAPI.Migrations.pas',
  GitHubAPI.Notifications in 'GitHubAPI.Notifications.pas',
  GitHubAPI.Organizations in 'GitHubAPI.Organizations.pas',
  GitHubAPI.Packages in 'GitHubAPI.Packages.pas',
  GitHubAPI.Pages in 'GitHubAPI.Pages.pas',
  GitHubAPI.Projects in 'GitHubAPI.Projects.pas',
  GitHubAPI.Pulls in 'GitHubAPI.Pulls.pas',
  GitHubAPI.Ratelimit in 'GitHubAPI.Ratelimit.pas',
  GitHubAPI.Reactions in 'GitHubAPI.Reactions.pas',
  GitHubAPI.Releases in 'GitHubAPI.Releases.pas',
  GitHubAPI.Repositories in 'GitHubAPI.Repositories.pas',
  GitHubAPI.Search in 'GitHubAPI.Search.pas',
  GitHubAPI.SecretScanning in 'GitHubAPI.SecretScanning.pas',
  GitHubAPI.Teams in 'GitHubAPI.Teams.pas',
  GitHubAPI.Users in 'GitHubAPI.Users.pas',
  GitHubAPI.Actions in 'GitHubAPI.Actions.pas',
  GitHubAPI.Types in 'GitHubAPI.Types.pas',
  GitHubAPI.Plans in 'GitHubAPI.Plans.pas',
  REST.Client.Helper in 'REST.Client.Helper.pas',
  dotenv in 'dotenv.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TGitHub, GitHub);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
