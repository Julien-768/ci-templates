#define AppName "DummyApp"
#define AppExeName "DummyApp.exe"
#define AppVersion "0.0.1-test"

[Setup]
AppId={{DUMMY-APP-TEST-0001}
AppName={#AppName}
AppVersion={#AppVersion}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
OutputDir=..\..\release  ; Relative path to avoid permission issues in CI
OutputBaseFilename={#AppName}_Setup_v{#AppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
DisableProgramGroupPage=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; Source files relative to the .iss file directory
Source: "..\..\tests\dummy_app.spec"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\..\tests\dummy_app.py"; DestDir: "{app}"; Flags: ignoreversion
; Uncomment if you have a PyInstaller-generated .exe
; Source: "..\..\dist\DummyApp.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"

[Run]
Filename: "{app}\{#AppExeName}"; Description: "Launch {#AppName}"; Flags: nowait postinstall skipifsilent
