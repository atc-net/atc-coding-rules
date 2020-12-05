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

Write-Host "Working on root folder"
Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/build/code-analysis.props" -outfile "build/code-analysis.props"
Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/.editorconfig" -outfile ".editorconfig"

if (Test-Path sample -PathType Any)
{
    Write-Host "Working on sample folder"
    Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/sample/.editorconfig" -outfile "sample/.editorconfig"
    Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/sample/directory.build.props" -outfile "sample/directory.build.props"
    Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/sample/directory.build.targets" -outfile "sample/directory.build.targets"
}

if (Test-Path src -PathType Any)
{
    Write-Host "Working on src folder"
    Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/src/.editorconfig" -outfile "src/.editorconfig"
    Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/src/directory.build.props" -outfile "src/directory.build.props"
    Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/src/directory.build.targets" -outfile "src/directory.build.targets"
}

if (Test-Path test -PathType Any)
{
    Write-Host "Working on test folder"
    Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/test/.editorconfig" -outfile "test/.editorconfig"
    Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/test/directory.build.props" -outfile "test/directory.build.props"
    Invoke-WebRequest "https://raw.githubusercontent.com/atc-net/atc-coding-rules/main/distribution/test/directory.build.targets" -outfile "test/directory.build.targets"
}

Write-Host "Done..."
