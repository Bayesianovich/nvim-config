[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$SkipDependencies,
    [switch]$SkipSync,
    [switch]$WithAI
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$RepoUrl = if ($env:NVIM_CONFIG_REPO) { $env:NVIM_CONFIG_REPO } else { "https://github.com/Bayesianovich/nvim-config.git" }
if (-not $env:LOCALAPPDATA) {
    throw "LOCALAPPDATA is not defined. This installer requires native Windows."
}
$ConfigDir = if ($env:NVIM_CONFIG_DIR) { $env:NVIM_CONFIG_DIR } else { Join-Path $env:LOCALAPPDATA "nvim" }

function Write-Step {
    param([string]$Message)
    Write-Host "[nvim-install] $Message" -ForegroundColor Cyan
}

function Invoke-Native {
    param(
        [Parameter(Mandatory = $true)][string]$FilePath,
        [Parameter(Mandatory = $true)][string[]]$ArgumentList
    )

    if ($DryRun) {
        Write-Host ("[dry-run] {0} {1}" -f $FilePath, ($ArgumentList -join " "))
        return
    }

    & $FilePath @ArgumentList
    if ($LASTEXITCODE -ne 0) {
        throw "$FilePath failed with exit code $LASTEXITCODE"
    }
}

function Refresh-ProcessPath {
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath"
}

function Test-Command {
    param([string]$Name)
    return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

function Install-WingetPackage {
    param(
        [string]$Command,
        [string]$Id
    )

    if (Test-Command $Command) {
        Write-Step "$Command is already installed."
        return
    }

    Write-Step "Installing $Id with winget."
    Invoke-Native -FilePath "winget" -ArgumentList @(
        "install", "--id", $Id, "--exact", "--silent",
        "--accept-package-agreements", "--accept-source-agreements"
    )
    if (-not $DryRun) {
        Refresh-ProcessPath
    }
}

function Test-NeovimCompatible {
    if (-not (Test-Command "nvim")) {
        return $false
    }

    $versionOutput = & nvim --version 2>$null | Select-Object -First 1
    if ($versionOutput -notmatch "v([0-9]+)\.([0-9]+)") {
        return $false
    }

    $major = [int]$Matches[1]
    $minor = [int]$Matches[2]
    return $major -gt 0 -or $minor -ge 11
}

function Install-Neovim {
    if (Test-NeovimCompatible) {
        $version = (& nvim --version | Select-Object -First 1)
        Write-Step "$version is already compatible."
        return
    }

    Write-Step "Installing the latest Neovim release with winget."
    Invoke-Native -FilePath "winget" -ArgumentList @(
        "install", "--id", "Neovim.Neovim", "--exact", "--silent", "--force",
        "--accept-package-agreements", "--accept-source-agreements"
    )
    if (-not $DryRun) {
        Refresh-ProcessPath
        if (-not (Test-NeovimCompatible)) {
            throw "Neovim >= 0.11 was installed but is not visible in PATH. Open a new PowerShell window and run this script again."
        }
    }
}

function Test-PythonUsable {
    $pythonCommand = Get-Command "python" -ErrorAction SilentlyContinue
    if ($null -eq $pythonCommand) {
        return $false
    }
    if ($pythonCommand.Source -like "*\WindowsApps\python.exe") {
        return $false
    }

    $versionOutput = (& python --version 2>&1 | Out-String).Trim()
    return $LASTEXITCODE -eq 0 -and $versionOutput -match "^Python 3\."
}

function Install-Python {
    if (Test-PythonUsable) {
        Write-Step "Python 3 is already installed."
        return
    }

    Write-Step "Installing Python 3 with winget."
    Invoke-Native -FilePath "winget" -ArgumentList @(
        "install", "--id", "Python.Python.3.13", "--exact", "--silent", "--force",
        "--accept-package-agreements", "--accept-source-agreements"
    )
    if (-not $DryRun) {
        Refresh-ProcessPath
    }
}

function Install-Dependencies {
    if ($SkipDependencies) {
        Write-Step "Skipping Windows dependencies."
        return
    }
    if (-not $DryRun -and -not (Test-Command "winget")) {
        throw "winget is required. Install Microsoft App Installer, then run this script again."
    }

    $packages = @(
        @{ Command = "git"; Id = "Git.Git" },
        @{ Command = "rg"; Id = "BurntSushi.ripgrep.MSVC" },
        @{ Command = "fd"; Id = "sharkdp.fd" },
        @{ Command = "lazygit"; Id = "JesseDuffield.lazygit" },
        @{ Command = "node"; Id = "OpenJS.NodeJS.LTS" },
        @{ Command = "clang-format"; Id = "LLVM.LLVM" }
    )

    foreach ($package in $packages) {
        Install-WingetPackage -Command $package.Command -Id $package.Id
    }
    Install-Python
    Install-Neovim
}

function Install-AIClis {
    if (-not $WithAI) {
        return
    }
    if (-not $DryRun -and -not (Test-Command "npm")) {
        throw "-WithAI requires npm."
    }

    Write-Step "Installing optional AI CLIs. Authentication is still required afterward."
    Invoke-Native -FilePath "npm" -ArgumentList @(
        "install", "-g", "@anthropic-ai/claude-code", "@google/gemini-cli", "@openai/codex"
    )
}

function Assert-RequiredCommands {
    if ($DryRun) {
        return
    }
    foreach ($command in @("git", "nvim", "rg", "fd", "lazygit", "node", "npm", "python", "clang-format")) {
        if (-not (Test-Command $command)) {
            throw "Required command is unavailable after installation: $command"
        }
    }
}

function Sync-Config {
    $parentDir = Split-Path -Parent $ConfigDir
    if ($DryRun) {
        Write-Host "[dry-run] Ensure directory $parentDir"
    } else {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    if (Test-Path (Join-Path $ConfigDir ".git")) {
        $origin = (& git -C $ConfigDir remote get-url origin 2>$null | Out-String).Trim()
        $dirty = (& git -C $ConfigDir status --porcelain 2>$null | Out-String).Trim()
        if ($origin -eq $RepoUrl -and [string]::IsNullOrWhiteSpace($dirty)) {
            Write-Step "Updating the existing clean configuration."
            Invoke-Native -FilePath "git" -ArgumentList @("-C", $ConfigDir, "fetch", "--prune", "origin")
            Invoke-Native -FilePath "git" -ArgumentList @("-C", $ConfigDir, "pull", "--ff-only", "origin", "main")
            return
        }
    }

    if (Test-Path $ConfigDir) {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $backupDir = "$ConfigDir.backup.$timestamp"
        if ($DryRun) {
            Write-Host "[dry-run] Move $ConfigDir to $backupDir"
        } else {
            Move-Item -LiteralPath $ConfigDir -Destination $backupDir
        }
        Write-Step "Backed up the existing configuration to $backupDir."
    }

    Write-Step "Cloning Neovim configuration into $ConfigDir."
    Invoke-Native -FilePath "git" -ArgumentList @("clone", $RepoUrl, $ConfigDir)
}

function Sync-Plugins {
    if ($SkipSync) {
        Write-Step "Skipping Lazy.nvim plugin sync."
        return
    }
    if (-not $DryRun -and -not (Test-Command "nvim")) {
        throw "nvim is not available after installation. Restart PowerShell and run this script again."
    }

    Write-Step "Synchronizing Neovim plugins. This may take a few minutes."
    Invoke-Native -FilePath "nvim" -ArgumentList @("--headless", "+Lazy! sync", "+qa")
}

function Main {
    Install-Dependencies
    if (-not $DryRun) {
        Refresh-ProcessPath
    }
    Install-AIClis
    Assert-RequiredCommands
    Sync-Config
    Sync-Plugins

    Write-Step "Installation complete."
    Write-Step "Open a new PowerShell window, run nvim, then use :checkhealth and :Mason."
    if (-not $WithAI) {
        Write-Step "Optional AI CLIs were not installed. Re-run with -WithAI if needed."
    } else {
        Write-Step "Authenticate claude, gemini, and codex before using their Neovim integrations."
    }
    Write-Step "Select a Nerd Font in your terminal if icons are missing."
}

Main
