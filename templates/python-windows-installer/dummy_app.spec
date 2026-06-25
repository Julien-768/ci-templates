# -*- mode: python ; coding: utf-8 -*-
a = Analysis(
    ["../../src/dummy_app.py"],  # Chemin relatif depuis templates/python-windows-installer/
    pathex=["../.."],              # Remonte de 2 niveaux pour accéder à src/
    binaries=[],
    datas=[],
    hiddenimports=[],
    hookspath=[],
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)
exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name="DummyApp",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
)