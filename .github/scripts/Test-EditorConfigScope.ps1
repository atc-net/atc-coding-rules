<#
.SYNOPSIS
  Verifies that .NET/C# settings in .editorconfig files are placed in a section that matches C# files.

.DESCRIPTION
  In an .editorconfig file every key belongs to the most recent [section] header. Roslyn only applies
  a key to source files that match that section's glob. A .NET setting placed under e.g. [Makefile],
  or before the first section, is silently ignored.

  This script scans all .editorconfig files under -Path and reports every .NET/C# key
  (dotnet_*, csharp_*, file_header_template) that is not inside a section matching *.cs files.
  It exits with code 1 when any problem is found, so it can be used in CI.

.PARAMETER Path
  Folder to scan recursively. Defaults to the repository's distribution folder.

.EXAMPLE
  ./.github/scripts/Test-EditorConfigScope.ps1

.EXAMPLE
  ./.github/scripts/Test-EditorConfigScope.ps1 -Path ./distribution/dotnet10
#>
[CmdletBinding()]
param(
  [Parameter(Position = 0)]
  [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
  [string]$Path = (Join-Path -Path $PSScriptRoot -ChildPath '../../distribution')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Expand-BraceGlob {
  # Expands EditorConfig brace lists, e.g. '*.{cs,csx}' -> '*.cs', '*.csx'
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [string]$Glob
  )

  $match = [regex]::Match($Glob, '\{([^{}]*)\}')
  if (-not $match.Success) {
    return , $Glob
  }

  $prefix = $Glob.Substring(0, $match.Index)
  $suffix = $Glob.Substring($match.Index + $match.Length)
  foreach ($alternative in $match.Groups[1].Value.Split(',')) {
    Expand-BraceGlob -Glob ($prefix + $alternative.Trim() + $suffix)
  }
}

function Test-CSharpSection {
  # True when the section glob can match a C# source file
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [string]$Section
  )

  foreach ($glob in (Expand-BraceGlob -Glob $Section)) {
    if ($glob -in @('*', '**') -or $glob -match '\.(cs|csx|cake)$') {
      return $true
    }
  }

  return $false
}

$dotnetKeyPattern = '^(dotnet_|csharp_|file_header_template$)'
$problemCount = 0
$files = @(Get-ChildItem -LiteralPath $Path -Filter '.editorconfig' -Recurse -File -Force)

foreach ($file in $files) {
  $section = $null
  $lineNumber = 0

  foreach ($line in [System.IO.File]::ReadLines($file.FullName)) {
    $lineNumber++
    $trimmed = $line.Trim()

    if ($trimmed -eq '' -or $trimmed.StartsWith('#') -or $trimmed.StartsWith(';')) {
      continue
    }

    $sectionMatch = [regex]::Match($trimmed, '^\[(.+)\]$')
    if ($sectionMatch.Success) {
      $section = $sectionMatch.Groups[1].Value
      continue
    }

    $key = ($trimmed -split '=', 2)[0].Trim()
    if ($key -notmatch $dotnetKeyPattern) {
      continue
    }

    $message = $null
    if ($null -eq $section) {
      $message = "'$key' is placed before the first [section] and is ignored by Roslyn."
    }
    elseif (-not (Test-CSharpSection -Section $section)) {
      $message = "'$key' is placed in section [$section], which does not match C# files."
    }

    if ($message) {
      $problemCount++
      $relativePath = [System.IO.Path]::GetRelativePath((Get-Location).Path, $file.FullName) -replace '\\', '/'
      if ($env:GITHUB_ACTIONS -eq 'true') {
        Write-Host "::error file=$relativePath,line=$lineNumber::$message"
      }
      else {
        Write-Host "$($relativePath):$($lineNumber): $message" -ForegroundColor Red
      }
    }
  }
}

if ($problemCount -gt 0) {
  Write-Host "Found $problemCount misplaced .NET setting(s) in $($files.Count) .editorconfig file(s)." -ForegroundColor Red
  exit 1
}

Write-Host "Checked $($files.Count) .editorconfig file(s): all .NET settings are in C# sections." -ForegroundColor Green
