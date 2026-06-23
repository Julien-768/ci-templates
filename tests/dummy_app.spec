# -*- mode: python ; coding: utf-8 -*-
import os

script_path = os.path.join(os.environ.get("CI_PROJECT_DIR", "."), "tests", "dummy_app.py")

a = Analysis(
    [script_path],
    pathex=[os.environ.get("CI_PROJECT_DIR", ".")],
    binaries=[],
    datas=[],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
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
