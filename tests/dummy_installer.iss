#define AppName "DummyApp"
#define AppExeName "DummyApp.exe"
#define AppVersion "0.0.1-test"
#define SourcePath "Z:\builds\iphc\ci-templates"  ; <-- Définition de SourcePath

[Setup]
AppId={{DUMMY-APP-TEST-0001}
AppName={#AppName}
AppVersion={#AppVersion}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
OutputDir={#SourcePath}\tests\release  ; <-- Chemin absolu pour OutputDir
OutputBaseFilename={#AppName}_Setup_v{#AppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
DisableProgramGroupPage=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; Chemins relatifs par rapport à SourcePath
Source: "{#SourcePath}\tests\dummy_app.spec"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#SourcePath}\tests\dummy_app.py"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"

[Run]
Filename: "{app}\{#AppExeName}"; Description: "Launch {#AppName}"; Flags: nowait postinstall skipifsilent
