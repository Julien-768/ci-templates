#define AppName "DummyApp"
#define AppExeName "DummyApp.exe"
#define AppVersion "0.0.1-test"
#define SourcePath "Z:\builds\iphc\ci-templates\tests"  ; <-- Définis le chemin absolu de la source

[Setup]
AppId={{DUMMY-APP-TEST-0001}
AppName={#AppName}
AppVersion={#AppVersion}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
OutputDir={#SourcePath}\release  ; <-- Output dans le répertoire tests/release
OutputBaseFilename={#AppName}_Setup_v{#AppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
DisableProgramGroupPage=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; Utilise {#SourcePath} pour les chemins sources
Source: "{#SourcePath}\dummy_app.spec"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#SourcePath}\dummy_app.py"; DestDir: "{app}"; Flags: ignoreversion
; Si tu as un .exe généré par PyInstaller, ajoute-le ici
; Source: "dist\DummyApp.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"

[Run]
Filename: "{app}\{#AppExeName}"; Description: "Launch {#AppName}"; Flags: nowait postinstall skipifsilent
