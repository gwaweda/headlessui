#!/usr/bin/env bash
set -e

# 항상 레포 루트 기준에서 실행
ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT_DIR"

prettierArgs=()

# CI 환경이면 --check, 아니면 --write
if [ -n "$CI" ]; then
  prettierArgs+=("--check")
else
  prettierArgs+=("--write")
fi

# 기본 옵션
prettierArgs+=("--ignore-unknown")

# lint-staged가 넘겨준 파일 경로들을 처리
if [ "$#" -gt 0 ]; then
  for arg in "$@"; do
    # 절대 경로로 넘어온 경우 루트 기준 상대 경로로 변환
    if [[ "$arg" == "$ROOT_DIR"* ]]; then
      rel="${arg#"$ROOT_DIR"/}"
      prettierArgs+=("$rel")
    else
      prettierArgs+=("$arg")
    fi
  done
else
  # 인자가 없으면 레포 전체 대상
  prettierArgs+=(".")
fi

# 실행
npx prettier "${prettierArgs[@]}"
