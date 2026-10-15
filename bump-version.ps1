<#
.SYNOPSIS
    Otomatisasi pembaruan versi (Version Bumper) untuk Grimlite Li x CODEX.
.DESCRIPTION
    Script ini menyinkronkan penomoran versi di semua file proyek:
      - Properties/AssemblyInfo.cs (AssemblyVersion & AssemblyFileVersion)
      - Grimoire/Tools/CodexBankManager.cs (CURRENT_APP_VERSION)
      - CodexBank/manifest.json (app_version & changelog)
      - .github/scripts/generate_manifest.py (fallback app_version)
    Serta membuat git commit, git tag (misal: v2.0.3), dan opsi push langsung ke GitHub.
.EXAMPLE
    .\bump-version.ps1 2.0.3
.EXAMPLE
    .\bump-version.ps1 2.0.3 -Changelog "Fix auto-attack dan update bank script" -Push
#>

param(
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Nomor versi baru (contoh: 2.0.3)")]
    [string]$Version,

    [Parameter(Position = 1)]
    [string]$Changelog = "",

    [switch]$Push
)

$ErrorActionPreference = "Stop"

# 1. Bersihkan prefix 'v' jika user memasukkan "v2.0.3"
$CleanVer = $Version.Trim().TrimStart('v', 'V')
if ($CleanVer -notmatch '^\d+\.\d+\.\d+(\.\d+)?$') {
    Write-Error "Format versi tidak valid! Gunakan format X.Y.Z (contoh: 2.0.3)"
    exit 1
}

$parts = $CleanVer.Split('.')
if ($parts.Length -eq 3) {
    $AssemblyVer = "$CleanVer.0"
} else {
    $AssemblyVer = $CleanVer
}
$TagVer = "v$CleanVer"

$repoRoot = $PSScriptRoot

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Bumping Version to: $CleanVer ($TagVer) " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 2. Update Properties/AssemblyInfo.cs
$assemblyInfoPath = Join-Path $repoRoot "Properties\AssemblyInfo.cs"
if (Test-Path $assemblyInfoPath) {
    $content = Get-Content $assemblyInfoPath -Raw -Encoding UTF8
    $content = $content -replace '\[assembly: AssemblyVersion\("[^"]+"\)', "[assembly: AssemblyVersion(`"$AssemblyVer`")"
    $content = $content -replace '\[assembly: AssemblyFileVersion\("[^"]+"\)', "[assembly: AssemblyFileVersion(`"$AssemblyVer`")"
    Set-Content -Path $assemblyInfoPath -Value $content -Encoding UTF8
    Write-Host "[OK] Updated AssemblyInfo.cs -> $AssemblyVer" -ForegroundColor Green
} else {
    Write-Warning "AssemblyInfo.cs tidak ditemukan di $assemblyInfoPath"
}

# 3. Update Grimoire/Tools/CodexBankManager.cs
$codexBankManagerPath = Join-Path $repoRoot "Grimoire\Tools\CodexBankManager.cs"
if (Test-Path $codexBankManagerPath) {
    $content = Get-Content $codexBankManagerPath -Raw -Encoding UTF8
    $content = $content -replace 'public const string CURRENT_APP_VERSION = "[^"]+";', "public const string CURRENT_APP_VERSION = `"$CleanVer`";"
    Set-Content -Path $codexBankManagerPath -Value $content -Encoding UTF8
    Write-Host "[OK] Updated CodexBankManager.cs -> $CleanVer" -ForegroundColor Green
} else {
    Write-Warning "CodexBankManager.cs tidak ditemukan di $codexBankManagerPath"
}

# 4. Update CodexBank/manifest.json
$manifestPath = Join-Path $repoRoot "CodexBank\manifest.json"
if (Test-Path $manifestPath) {
    $jsonContent = Get-Content $manifestPath -Raw -Encoding UTF8
    $manifestObj = $jsonContent | ConvertFrom-Json
    $manifestObj.app_version = $CleanVer
    if (-not [string]::IsNullOrWhiteSpace($Changelog)) {
        $manifestObj.changelog = "Grimlite Li x CODEX $TagVer - $Changelog"
    }
    $newJson = $manifestObj | ConvertTo-Json -Depth 10
    Set-Content -Path $manifestPath -Value $newJson -Encoding UTF8
    Write-Host "[OK] Updated CodexBank/manifest.json -> $CleanVer" -ForegroundColor Green
} else {
    Write-Warning "manifest.json tidak ditemukan di $manifestPath"
}

# 5. Update .github/scripts/generate_manifest.py (fallback default)
$scriptGenPath = Join-Path $repoRoot ".github\scripts\generate_manifest.py"
if (Test-Path $scriptGenPath) {
    $content = Get-Content $scriptGenPath -Raw -Encoding UTF8
    $content = $content -replace 'app_version = "[^"]+"', "app_version = `"$CleanVer`""
    if (-not [string]::IsNullOrWhiteSpace($Changelog)) {
        $changelogEscaped = $Changelog -replace '"', '\"'
        $content = $content -replace 'changelog = "Grimlite Li x CODEX [^"]+"', "changelog = `"Grimlite Li x CODEX $TagVer - $changelogEscaped`""
    }
    Set-Content -Path $scriptGenPath -Value $content -Encoding UTF8
    Write-Host "[OK] Updated generate_manifest.py default -> $CleanVer" -ForegroundColor Green
}

# 6. Update README.md (badges & intro)
$readmePath = Join-Path $repoRoot "README.md"
if (Test-Path $readmePath) {
    $content = Get-Content $readmePath -Raw -Encoding UTF8
    $content = $content -replace 'Release-v\d+\.\d+\.\d+_Stable', "Release-${TagVer}_Stable"
    $content = $content -replace 'Grimlite Li x CODEX v\d+\.\d+\.\d+', "Grimlite Li x CODEX $TagVer"
    Set-Content -Path $readmePath -Value $content -Encoding UTF8
    Write-Host "[OK] Updated README.md -> $TagVer" -ForegroundColor Green
}

Write-Host ""
Write-Host "Semua file versi berhasil disinkronkan!" -ForegroundColor Cyan

# 7. Git Operations (Commit & Tag)
$git = Get-Command git -ErrorAction SilentlyContinue
if ($git) {
    Write-Host "Menyiapkan git commit & tag..." -ForegroundColor Yellow
    
    & git add -A
    
    $commitMsg = "chore(release): bump version to $TagVer"
    if (-not [string]::IsNullOrWhiteSpace($Changelog)) {
        $commitMsg = "chore(release): bump version to $TagVer`n`n$Changelog"
    }
    
    & git commit -m "$commitMsg"
    
    # Periksa apakah tag sudah ada
    $existingTag = & git tag -l "$TagVer"
    if ($existingTag) {
        Write-Warning "Tag $TagVer sudah ada di git lokal. Menimpa tag..."
        & git tag -d "$TagVer" | Out-Null
    }
    
    & git tag -a "$TagVer" -m "Grimlite Li x CODEX $TagVer"
    Write-Host "[OK] Git Tag dibuat: $TagVer" -ForegroundColor Green

    if ($Push) {
        Write-Host "Mendorong commit & tag ke GitHub (origin)..." -ForegroundColor Yellow
        & git push origin HEAD
        & git push origin "$TagVer" --force
        Write-Host ""
        Write-Host "================================================================" -ForegroundColor Green
        Write-Host " SUKSES! Tag $TagVer terkirim ke GitHub.                         " -ForegroundColor Green
        Write-Host " GitHub Actions sekarang sedang otomatis mem-build Grimoire.exe!" -ForegroundColor Green
        Write-Host " Cek progress di: https://github.com/zsxbb/grimli-codex/actions " -ForegroundColor Cyan
        Write-Host "================================================================" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "Commit dan Tag lokal ($TagVer) sudah siap!" -ForegroundColor Yellow
        Write-Host "Untuk memicu auto-release di GitHub, jalankan:" -ForegroundColor White
        Write-Host "  git push origin HEAD" -ForegroundColor Gray
        Write-Host "  git push origin $TagVer --force" -ForegroundColor Gray
        Write-Host "(atau jalankan ulang script dengan parameter -Push)" -ForegroundColor Gray
    }
} else {
    Write-Warning "Git CLI tidak ditemukan di PATH. File telah diubah, silakan commit manual."
}
