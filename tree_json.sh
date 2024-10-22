#!/bin/bash

# 기본값 설정
excludedDirs=('.git' '.next' 'node_modules')
excludeFiles=false
outputFile="_docs/dev/tree_root.json"
debugFile="/tmp/tree_debug.log"

# 사용법 함수
usage() {
    echo "사용법: $0 [-d <제외할 디렉토리>] [-f] [-o <출력 파일>]"
    echo "  -d: 제외할 디렉토리 (쉼표로 구분, 기본값: ${excludedDirs[*]})"
    echo "  -f: 파일 제외 (기본값: 포함)"
    echo "  -o: 출력 파일 경로 (기본값: $outputFile)"
    exit 1
}

# 매개변수 파싱
while getopts "d:fo:" opt; do
    case $opt in
        d) IFS=',' read -ra excludedDirs <<< "$OPTARG" ;;
        f) excludeFiles=true ;;
        o) outputFile="$OPTARG" ;;
        *) usage ;;
    esac
done

# tree 명령 옵션 설정
treeOptions="-J -L 3"
for dir in "${excludedDirs[@]}"; do
    treeOptions+=" -I $dir"
done

if [ "$excludeFiles" = false ]; then
    treeOptions+=" -a"
fi

# tree 명령 실행 및 JSON 변환
tree $treeOptions | jq '
def process_contents(contents):
  contents | map(
    if .type == "directory" then
      {(.name): (if .contents then process_contents(.contents) else [] end)}
    elif .type == "file" then
      .name
    else
      empty
    end
  ) | add // {}
;

.[0] | {(.name): process_contents(.contents)}
' > "$outputFile"

echo "트리 구조가 $outputFile 에 JSON 형식으로 저장되었습니다."
echo "JSON 파일 내용:"
cat "$outputFile"

# 디버그 정보 저장
{
    echo "실행한 tree 명령어: tree $treeOptions"
    echo "tree 명령어 출력:"
    tree $treeOptions
    echo "jq 처리 후 결과:"
    cat "$outputFile"
} > "$debugFile"

echo "디버그 정보가 $debugFile 에 저장되었습니다."