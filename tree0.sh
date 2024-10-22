#!/bin/bash

# 제외할 디렉토리 목록
excludedDirs=('.git' '.next' 'node_modules')

# 출력 파일
outputFile="_docs/dev/tree_root.md"

# 제외할 디렉토리를 tree 명령어에 맞게 변환
excludeArgs=""
for dir in "${excludedDirs[@]}"; do
  excludeArgs="$excludeArgs -I $dir"
done

# 마크다운 헤더 추가
echo "# 프로젝트 디렉토리 구조" > $outputFile
echo "" >> $outputFile
echo "``````" >> $outputFile

# tree 명령 실행 및 결과 저장
tree -L 3 $excludeArgs >> $outputFile

# 마크다운 끝
echo "``````" >> $outputFile

echo "트리 구조가 $outputFile 에 저장되었습니다."