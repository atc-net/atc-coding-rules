Clear-Host
Write-Host "Update atc-coding-rules"

[bool] $isFirstTime = 1
if (Test-Path .editorconfig -PathType Leaf)
{
    $isFirstTime = 0
}

if ($isFirstTime)
{
    New-Item -ItemType Directory -Force -Path build
    New-Item -ItemType Directory -Force -Path sample
    New-Item -ItemType Directory -Force -Path src
    New-Item -ItemType Directory -Force -Path test

    Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/build/common.props" -outfile "build/common.props"
    Write-Host "Please update build/common.props with you information"
}

Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/build/code-analysis.props" -outfile "build/code-analysis.props"
Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/.editorconfig" -outfile ".editorconfig"

if (Test-Path sample -PathType Any)
{
    Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/sample/.editorconfig" -outfile "sample/.editorconfig"
}

if (Test-Path src -PathType Any)
{
    Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/src/.editorconfig" -outfile "src/.editorconfig"
}

if (Test-Path test -PathType Any)
{
    Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/test/.editorconfig" -outfile "test/.editorconfig"
}

Write-Host "Done..."
