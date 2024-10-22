#!/bin/bash

# 기본값 설정
excludedDirs=('.git' '.next' 'node_modules')
excludeFiles=false
outputFile="_docs/dev/tree_root.md"

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
treeOptions="-L 3"
for dir in "${excludedDirs[@]}"; do
    treeOptions+=" -I $dir"
done

if [ "$excludeFiles" = true ]; then
    treeOptions+=" -d"
fi

# 마크다운 헤더 추가
echo "# 프로젝트 디렉토리 구조" > "$outputFile"
echo "" >> "$outputFile"
echo "\`\`\`\`\`" >> "$outputFile"

# tree 명령 실행 및 결과 저장
tree $treeOptions >> "$outputFile"

# 마크다운 끝
echo "\`\`\`\`\`" >> "$outputFile"

echo "트리 구조가 $outputFile 에 저장되었습니다."