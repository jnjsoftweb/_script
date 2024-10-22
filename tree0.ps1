$excludedDirs = @('.git', '.next', 'node_modules', '_docs', '_settings', '_scripts', 'backend', 'pages')
$outputFile = "_docs/dev/tree_root.md"

function Show-CustomTree($path, $prefix = "", $output) {
    $items = Get-ChildItem $path -Directory | Where-Object { $excludedDirs -notcontains $_.Name }

    for ($i = 0; $i -lt $items.Count; $i++) {
        $item = $items[$i]
        $isLast = ($i -eq $items.Count - 1)
        $marker = if ($isLast) { "└─" } else { "├─" }

        $line = "$prefix$marker $($item.Name)"
        Write-Host $line
        $output.AppendLine($line)

        $newPrefix = if ($isLast) { "$prefix   " } else { "$prefix│  " }
        Show-CustomTree $item.FullName $newPrefix $output
    }
}

$currentPath = Get-Location
$output = New-Object System.Text.StringBuilder

# 마크다운 헤더 추가
$output.AppendLine("# 프로젝트 디렉토리 구조")
$output.AppendLine("")
$output.AppendLine("``````")

Show-CustomTree $currentPath "" $output

$output.AppendLine("``````")

# 파일에 저장
$output.ToString() | Out-File -FilePath $outputFile -Encoding utf8

Write-Host "트리 구조가 $outputFile 에 저장되었습니다."