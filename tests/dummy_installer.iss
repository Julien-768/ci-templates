#define AppName "DummyApp"
#define AppExeName "DummyApp.exe"
#define AppVersion "0.0.1-test"

[Setup]
AppId={{DUMMY-APP-TEST-0001}
AppName={#AppName}
AppVersion={#AppVersion}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
OutputDir=tests\release
OutputBaseFilename={#AppName}_Setup_v{#AppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
DisableProgramGroupPage=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "tests\dummy_app.spec"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"

[Run]
Filename: "{app}\{#AppExeName}"; Description: "Launch {#AppName}"; Flags: nowait postinstall skipifsilent