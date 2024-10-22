# 사용법  ./md.ps1 "tree_test3.md"
param (
  [string]$dir = "./tree_test2.md"
)

# 마크다운 파일 내용 읽기
$content = Get-Content $dir -Raw

# 트리 구조 라인 추출
$treeLines = $content -split "`n" | Where-Object { $_ -match '^\s*[│├└]' }

# 루트 디렉토리 설정 (현재 디렉토리로 설정, 필요시 변경 가능)
$rootDir = $PWD.Path

# 디렉토리 생성 함수
function Create-Directory {
  param (
    [string]$path
  )
  if (!(Test-Path $path)) {
    New-Item -ItemType Directory -Path $path -Force | Out-Null
    Write-Host "디렉토리 생성됨: $path"
  }
}

# depth 계산 함수
function Get-Depth {
  param (
    [string]$line
  )
  $indent = ($line -match '^(\s*)')[0].Length
  $symbols = ($line -replace '\s' -replace '[^│├└]').Length
  return [math]::Max($indent / 2, $symbols)
}

# 트리 구조에 따라 디렉토리 생성
$pathParts = @()
$prevDepth = 0
$lastRootFound = $false
$depthOffset = 0

foreach ($line in $treeLines) {
  $baseDepth = Get-Depth $line
  $depth = $baseDepth + $depthOffset
  $dirName = ($line -replace '^[\s│├└─]+', '').Split('#')[0].Trim()
  Write-Host "<$dirName> path: $depth"

  if ($dirName -ne '') {
    if ($baseDepth -le $prevDepth) {
      $pathParts = $pathParts[0..($depth-1)]
    }

    while ($pathParts.Count -le $depth) {
      $pathParts += ""
    }

    $pathParts[$depth] = $dirName
    $newPath = Join-Path $rootDir ([string]::Join('\', ($pathParts[0..$depth] | Where-Object { $_ -ne "" })))
    Create-Directory $newPath
    $prevDepth = $baseDepth

    if ($dirName -eq '_docs') {
      $lastRootFound = $true
      $depthOffset = 1
    }
  }
}

Write-Host "디렉토리 구조 생성 완료."