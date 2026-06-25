#define AppName "DummyApp"
#define AppExeName "DummyApp.exe"
#define AppVersion "0.0.1-test"  ; Sera écrasé par /dAppVersion du template

[Setup]
AppId={{DUMMY-APP-TEST-0001}
AppName={#AppName}
AppVersion={#AppVersion}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
OutputDir=..\..\release
OutputBaseFilename={#AppName}_Setup_v{#AppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
DisableProgramGroupPage=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "dummy_app.spec"; DestDir: "{app}"; Flags: ignoreversion
Source: "../../src/main.py"; DestDir: "{app}"; Flags: ignoreversion
Source: "../../dist/MainApp.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"

[Run]
Filename: "{app}\{#AppExeName}"; Description: "Launch {#AppName}"; Flags: nowait postinstall skipifsilent
