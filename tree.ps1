# cmd: @chcp 65001 > nul
# cmd: powershell -ExecutionPolicy Bypass -File C:\JnJ-soft\_script\tree.ps1 -e '.git,.next,node_modules' -o 'docs/tree_root.md' -f
# ps: tree.ps1 -e '.git,.next,node_modules' -o 'docs/tree_root.md' -f // -f: 파일 포함

param(
    [Parameter(Mandatory=$false)]
    [Alias("e")]
    [string]$excludedDirsString = ".git,.next,node_modules",

    [Parameter(Mandatory=$false)]
    [Alias("o")]
    [string]$outputFile = "docs/tree_root.md",

    [Parameter(Mandatory=$false)]
    [Alias("f")]
    [switch]$includeFiles = $false,

    [Parameter(Mandatory=$false)]
    [Alias("h")]
    [switch]$help = $false
)

function Show-Help {
    Write-Host "사용법: tree.ps1 [옵션]"
    Write-Host ""
    Write-Host "옵션:"
    Write-Host "  -e, -excludedDirsString   제외할 디렉토리 (쉼표로 구분)"
    Write-Host "  -o, -outputFile           출력 파일 경로"
    Write-Host "  -f, -includeFiles         파일 포함 (기본: 디렉토리만)"
    Write-Host "  -h, --help                도움말 표시"
    Write-Host ""
    Write-Host "예시:"
    Write-Host "  tree.ps1 -e '.git,.next,node_modules' -o 'docs/tree_root.md'"
    Write-Host "  tree.ps1 -e '.git,.next,node_modules' -o 'docs/tree_root.md' -f"
}

if ($help) {
    Show-Help
    exit
}

$excludedDirs = $excludedDirsString -split ','

function Show-CustomTree($path, $prefix = "", $output) {
    $items = Get-ChildItem $path | Where-Object { $excludedDirs -notcontains $_.Name }
    if (-not $includeFiles) {
        $items = $items | Where-Object { $_.PSIsContainer }
    }

    for ($i = 0; $i -lt $items.Count; $i++) {
        $item = $items[$i]
        $isLast = ($i -eq $items.Count - 1)
        $marker = if ($isLast) { "└─" } else { "├─" }

        $line = "$prefix$marker $($item.Name)"
        Write-Host $line
        $output.AppendLine($line)

        if ($item.PSIsContainer) {
            $newPrefix = if ($isLast) { "$prefix   " } else { "$prefix│  " }
            Show-CustomTree $item.FullName $newPrefix $output
        }
    }
}

$currentPath = Get-Location
$output = New-Object System.Text.StringBuilder

# 마크다운 헤더 추가
$output.AppendLine("# 프로젝트 디렉토리 구조")
$output.AppendLine("")
$output.AppendLine('```')

Show-CustomTree $currentPath "" $output

$output.AppendLine('```')

# 파일에 저장
$output.ToString() | Out-File -FilePath $outputFile -Encoding utf8

Write-Host "트리 구조가 $outputFile 에 저장되었습니다."
