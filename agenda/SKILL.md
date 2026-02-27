---
name: agenda
description: "에이전트 어젠다 — reverse datetree에 타임스탬프 엔트리 추가. 에이전트 활동을 org-agenda에서 볼 수 있게 기록. Use when starting work, completing a task, or any notable activity to stamp. '도장', 'stamp', '기록', 'agenda에 찍어'."
user_invocable: true
---

# agenda — 에이전트 어젠다 스탬프

에이전트 활동을 `~/org/botlog/agenda/` 의 reverse datetree에 타임스탬프로 기록한다.
org-agenda에서 인간과 에이전트 활동을 통합 조회할 수 있게 한다.

## When to Use

- 세션 시작 시 — "작업 시작" 스탬프
- 의미 있는 작업 완료 시 — "무엇을 했다" 스탬프
- punchout 전 — 마지막 활동 스탬프
- 사용자가 "agenda에 찍어", "stamp", "기록해" 요청 시

## 핵심 원칙

1. **TODO/DONE 안 씀** — 상태관리가 아닌 가시성(visibility)이 목적
2. **CLOCK 안 씀** — 타임스탬프만으로 타임라인 충분
3. **디바이스별 파일 분리** — `~/.current-device` 기반, 충돌 구조적 제거
4. **reverse datetree** — 최신이 위, 에이전트는 앞에만 읽고 앞에 추가

## 사용법

### 스탬프 찍기

```bash
{baseDir}/scripts/agenda-stamp.sh "설명" [tag1:tag2] [device]
```

- `설명`: 무엇을 했는지 한줄 (필수)
- `tag1:tag2`: org 태그, 콜론으로 구분 (선택)
- `device`: 디바이스명, 생략하면 `~/.current-device` 사용 (선택)

### 예시

```bash
# 기본 — 현재 디바이스에 스탬프
{baseDir}/scripts/agenda-stamp.sh "sks-hub-zig 디버깅 시작" "pi:sks"

# 태그 없이
{baseDir}/scripts/agenda-stamp.sh "세션 시작"

# 디바이스 지정
{baseDir}/scripts/agenda-stamp.sh "리서치 완료" "heebot:research" "oracle"
```

### 결과 파일 구조

```org
* 2026
** 2026-02 February
*** 2026-02-27 Friday
**** <2026-02-27 Fri 15:24> sks-hub-zig 디버깅 시작 :pi:sks:
**** <2026-02-27 Fri 11:04> 유튜브 자막 추출 테스트 :pi:claude:
*** 2026-02-26 Thursday
**** <2026-02-26 Thu 20:16> pi-skills 일원화 :pi:
```

## 파일 위치

```
~/org/botlog/agenda/
  YYYYMMDDTHHMMSS--agent-agenda__agenda_<device>.org
```

- 파일이 없으면 자동 생성 (Denote 규약)
- `~/.current-device` 값이 `__tags`로 들어감

## agenda 파일 읽기

에이전트가 최근 컨텍스트를 파악하려면:

```bash
# 현재 디바이스의 agenda 파일에서 최근 10줄
DEVICE=$(cat ~/.current-device)
AGENDA=$(find ~/org/botlog/agenda/ -name "*__${DEVICE}_agenda.org" | head -1)
head -30 "$AGENDA"
```

reverse datetree이므로 파일 앞부분 = 최신 활동.

## 에이전트 세션 워크플로우

```
1. 세션 시작
   → agenda-stamp.sh "세션 시작" "pi"

2. 의미 있는 작업 완료마다
   → agenda-stamp.sh "무엇을 했다" "pi:project-tag"

3. 세션 종료 / punchout
   → agenda-stamp.sh "세션 종료" "pi"
   → punchout 스킬 실행 (agenda 파일의 타임스탬프를 저널에 요약)
```

## punchout 연동

punchout 스킬이 agenda 파일에서 오늘 타임스탬프를 수집하면
gitcli 커밋 + agenda 스탬프 = 더 완전한 타임라인이 된다.

```bash
# punchout에서 agenda 타임스탬프 수집
DEVICE=$(cat ~/.current-device)
AGENDA=$(find ~/org/botlog/agenda/ -name "*__${DEVICE}_agenda.org" | head -1)
grep "^\\*\\*\\*\\* <$(TZ='Asia/Seoul' date '+%Y-%m-%d')" "$AGENDA"
```

## org-agenda 설정 (Emacs)

```elisp
;; botlog/agenda 폴더를 org-agenda-files에 추가
(add-to-list 'org-agenda-files
             (file-name-concat org-directory "botlog/agenda/") t)
```

이것만으로 에이전트 스탬프가 org-agenda 일간/주간 뷰에 나타난다.

## 주의사항

- agenda 파일은 **에이전트만 쓴다** — 인간은 org-agenda로 읽기만
- 저널 파일과 **별개** — 저널 수정은 punchout 스킬이 담당
- reverse datetree 포맷 유지 — 수동으로 날짜 순서 바꾸지 말 것
- 너무 자주 찍지 말 것 — 의미 있는 활동 단위로 (매 도구 호출마다 X)
