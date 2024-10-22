## 설명
1. 매개변수 처리:
-d: 제외할 디렉토리를 쉼표로 구분하여 지정
-f: 파일 제외 옵션
-o: 출력 파일 경로 지정

2. 기본값 설정:
excludedDirs: 기본적으로 제외할 디렉토리 목록
excludeFiles: 기본적으로 파일 포함
outputFile: 기본 출력 파일 경로

3. 사용법 함수: 스크립트 사용법을 출력하는 함수 추가
매개변수 파싱: getopts를 사용하여 매개변수 처리
tree 명령 옵션:
제외할 디렉토리에 대해 -I 옵션 추가
파일 제외 옵션(-f)이 지정된 경우 -d 옵션 추가

## 실행 권한 변경

```sh
chmod +x ./_scripts/tree.sh
```


## 사용 예시


1. 기본 실행:
```sh
./_scripts/tree.sh
```

2. 특정 디렉토리 제외 및 파일 제외:
```sh
./_scripts/tree.sh -d "dist,build,test" -f
```

3. 출력 파일 지정:
```sh
./_scripts/tree.sh -o "custom_output.md"
```

4. 모든 옵션 사용:
```sh
./_scripts/tree.sh -d "dist,build,test" -f -o "custom_output.md"
```

이 스크립트를 사용하면 원하는 대로 디렉토리를 제외하고, 파일 포함 여부를 선택하며, 출력 파일을 지정할 수 있습니다.
