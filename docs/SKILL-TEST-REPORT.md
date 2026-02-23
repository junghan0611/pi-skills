# pi-skills 통합 테스트 리포트

- **테스트 일시**: 2026-02-23
- **테스트 환경**: NixOS, Claude Code (claude-opus-4-6)
- **스킬 총 수**: 19개 (CLI 바이너리 7 + Node.js 3 + Shell 1 + 오케스트레이션 2 + 프롬프트 6)

## 요약

| 분류 | 테스트 수 | 통과 | 실패 | 커버리지 |
|------|----------|------|------|----------|
| 개별 CLI | 59 | 57 | 2 | **97%** |
| 통합 시나리오 (day-query) | 7 | 7 | 0 | **100%** |
| **합계** | **66** | **64** | **2** | **97%** |

---

## 1. 개별 스킬 테스트

### 1.1 denotecli — 15/15 OK

Denote 지식베이스 CLI. 3,000+ org-mode 파일 대상.

| # | 커맨드 | 결과 | 비고 |
|---|--------|------|------|
| 1 | `search "에릭 호퍼" --max 3` | OK | 3건, 한글 검색 정상 |
| 2 | `search "emacs" --tags emacs --max 3` | OK | 태그 필터 정상 |
| 3 | `search "창조" --title-only --max 3` | OK | 제목만 검색 |
| 4 | `keyword-map "이맥스"` | OK | 6 entries, 한→영 매핑 |
| 5 | `keyword-map "emacs"` | OK | 20 entries, 영→한 역방향 |
| 6 | `search-content "양자역학 관찰자" --max 3` | OK | 본문 전문 검색 (~300ms) |
| 7 | `search-headings "창조" --max 3` | OK | 헤딩 레벨+줄번호 포함 |
| 8 | `search-headings "양자역학" --level 1 --max 3` | OK | 레벨 필터 |
| 9 | `read <ID> --outline --level 2` | OK | 36개 outline 항목 |
| 10 | `read <ID> --offset 1 --limit 10` | OK | 부분 읽기 |
| 11 | `graph <ID>` | OK | outgoing 5 + incoming 13 |
| 12 | `tags --top 5` | OK | bib(967), journal(695)... |
| 13 | `tags --pattern "emacs\|vim"` | OK | 15개 태그 매칭 |
| 14 | `tags --suggest` | OK | 75 clusters |
| 15 | `rename-tag --dry-run` | OK | dry_run=true, 0 modified |

**미문서화 발견**: `day` 커맨드가 바이너리에 존재하나 SKILL.md에 없음 → **수정 완료**

### 1.2 lifetract — 15/15 OK

Samsung Health + aTimeLogger 생활추적 CLI.

| # | 커맨드 | 결과 | 비고 |
|---|--------|------|------|
| 1 | `status` | OK | DB 모드, 33MB |
| 2 | `today` | OK | 값 0 (데이터 범위 밖) |
| 3 | `read 2025-10-04` | OK | 걸음 41,382, 수면 8.6h |
| 4 | `read 20250115T000000` | OK | Denote ID 형식 호환 |
| 5 | `timeline --days 7` | OK | null (데이터 범위 밖) |
| 6 | `timeline --days 30` | OK | null (데이터 범위 밖) |
| 7 | `sleep --days 7` | OK | null (데이터 범위 밖) |
| 8 | `sleep --days 30 --summary` | OK | null (데이터 범위 밖) |
| 9 | `steps --days 7` | OK | null (데이터 범위 밖) |
| 10 | `heart --days 7` | OK | null (데이터 범위 밖) |
| 11 | `stress --days 7` | OK | null (데이터 범위 밖) |
| 12 | `exercise --days 30` | OK | null (데이터 범위 밖) |
| 13 | `time --days 7` | OK | null (데이터 범위 밖) |
| 14 | `time --days 30 --category 본짓` | OK | null (데이터 범위 밖) |
| 15 | `export` | OK | 정리 계획 JSON 반환 |

**참고**: DB 최신 데이터는 2025-10-06. 최근 날짜 조회 시 null 반환은 정상 동작.

### 1.3 gitcli — 7/7 OK

로컬 git 타임라인 CLI. 50+ 리포지토리 대상.

| # | 커맨드 | 결과 | 비고 |
|---|--------|------|------|
| 1 | `repos --repos ~/repos/gh` | OK | 31개 리포 |
| 2 | `repos --repos ~/repos/work` | OK | 17개 리포 |
| 3 | `day 2025-10-04 --me --repos ~/repos/gh` | OK | 0 commits (토요일) |
| 4 | `day --days-ago 1 --me` | OK | 45 commits, 6개 리포 |
| 5 | `day --years-ago 1 --me --repos ~/repos/gh` | OK | 0 commits |
| 6 | `log nixos-config --repos ~/repos/gh --days 30` | OK | 109 commits |
| 7 | `timeline --repos ~/repos/gh --days 7 --me` | OK | 294 commits |

### 1.4 bibcli — 4/4 OK

Zotero 서지 8,000+ 검색/조회 CLI.

| # | 커맨드 | 결과 | 비고 |
|---|--------|------|------|
| 1 | `search "에릭 호퍼" --max 3` | OK | 3건 (맹신자들, 영혼의 연금술, 길 위의 철학자) |
| 2 | `search "emacs" --max 3` | OK | 3건 |
| 3 | `search "quantum" --max 3` | OK | 3건 |
| 4 | `show "<key>"` | OK | 전체 필드 반환 |

**참고**: 서브커맨드는 `view`가 아닌 `show`.

### 1.5 gogcli (gog) — 1/3 OK (2 FAIL)

Google Workspace 올인원 CLI.

| # | 커맨드 | 결과 | 비고 |
|---|--------|------|------|
| 1 | `gog calendar list --from ... --to ...` | OK | 정상 (해당 기간 일정 없음) |
| 2 | `gog tasks list` | **FAIL** | `tasklistId` 필수 인자 누락. `gog tasks lists` → ID 획득 후 호출 |
| 3 | `gog contacts search "test"` | **FAIL** | People API 미활성화 (403 accessNotConfigured) |

**FAIL 원인**:
- `gog tasks list`: 테스트 커맨드 오류. 올바른 순서: `gog tasks lists` → `gog tasks list <listId>`
- `gog contacts search`: Google Cloud 프로젝트에서 People API 활성화 필요

### 1.6 ghcli (gh) — 3/3 OK

GitHub CLI.

| # | 커맨드 | 결과 | 비고 |
|---|--------|------|------|
| 1 | `gh api user` | OK | junghan0611 |
| 2 | `gh api repos/junghan0611/pi-skills` | OK | 리포 정보 |
| 3 | `gh api user/starred` | OK | 스타 리포 목록 |

### 1.7 brave-search — 2/2 OK

Brave Search API 웹 검색.

| # | 테스트 | 결과 | 비고 |
|---|--------|------|------|
| 1 | BRAVE_API_KEY 존재 | OK | 환경변수 설정됨 |
| 2 | `node search.js "NixOS 2025"` | OK | 4건+ 검색 결과 |

### 1.8 emacs — 1/1 OK

Emacs 컨텍스트 연동.

| # | 테스트 | 결과 | 비고 |
|---|--------|------|------|
| 1 | `context.sh` | OK | 현재 버퍼, 커서 위치, 프로젝트 정보 JSON 반환 |

### 1.9 youtube-transcript — 1/1 OK

YouTube 자막 추출.

| # | 테스트 | 결과 | 비고 |
|---|--------|------|------|
| 1 | `transcript.js "dQw4w9WgXcQ"` | OK | 자막 정상 추출 |

### 1.10 medium-extractor — 1/1 OK

Medium 글 마크다운 추출.

| # | 테스트 | 결과 | 비고 |
|---|--------|------|------|
| 1 | `node extract.js <URL>` | OK | 마크다운 변환 정상 |

**주의**: ESM 모듈이므로 스킬 디렉토리 내에서 실행해야 함.

### 1.11 transcribe — 구조 확인 OK

음성→텍스트 변환 (Groq Whisper).

| # | 테스트 | 결과 | 비고 |
|---|--------|------|------|
| 1 | GROQ_API_KEY 존재 | OK | 환경변수 설정됨 |
| 2 | `transcribe.sh` 구조 | OK | config 소싱, 인자/키 검증 로직 확인 |

**SKIP**: 실 음성 파일 테스트 미실시.

### 1.12 peon-ping (4개) — 구조 확인 OK

운동 알림 시스템 (config, log, toggle, use).

| 스킬 | SKILL.md | 비고 |
|------|----------|------|
| peon-ping-config | OK | 설정 변경 |
| peon-ping-log | OK | 운동 로그 |
| peon-ping-toggle | OK | 알림 토글 |
| peon-ping-use | OK | 보이스팩 선택 |

### 1.13 browser-tools — 구조 확인 OK

Chrome DevTools 자동화. 브라우저 환경 필요.

### 1.14 bd-to-br-migration — 구조 확인 OK

beads → beads_rust 마이그레이션 가이드 스킬.

---

## 2. 통합 시나리오 테스트 (day-query)

시나리오: **"2025-10-04에 뭘 했나?"**

5개 CLI를 순차 호출하여 하루를 재구성.

| 단계 | CLI | 결과 | 데이터 |
|------|-----|------|--------|
| 1 | `gitcli day 2025-10-04 --me` | OK | 0 commits (토요일 휴식) |
| 2 | `denotecli day 2025-10-04` | OK | 저널 2건 + 노트 1건 (Oracle ARM NixOS) |
| 3 | `lifetract read 2025-10-04` | OK | 걸음 41,382 / 수면 8.6h / 심박 93.1 / 시간추적 18 카테고리 |
| 4 | `bibcli search "20251004"` | OK | 0건 (해당일 서지 없음) |
| 5 | `gog calendar list --from ...` | OK | 0건 (해당일 일정 없음) |

### 크로스레퍼런스 검증

| 테스트 | 결과 |
|--------|------|
| lifetract `20251004T000000` = denotecli `20251004` 날짜 프리픽스 | **조인 가능** |
| lifetract 수면 이벤트 ID `20251004T141149` 시각 = 저널 시각과 교차 | **시간축 병합 가능** |

### 재구성된 하루 요약

> 2025-10-04 (토) — 가족 중심 휴일. 가족과 8.5시간(나들이 추정, 걸음 41,382보).
> 낮에 Oracle Cloud ARM VM NixOS 설치 작업을 AI와 협업(llmlog 1건).
> 수면은 오후~저녁 3회 분할(총 8.6h), 깊은 수면 부족.

---

## 3. 발견된 이슈 및 수정 사항

### 3.1 수정 완료

| 이슈 | 파일 | 변경 내용 |
|------|------|-----------|
| `denotecli day` 미문서화 | `denotecli/SKILL.md` | `day` 커맨드 섹션 추가 |
| `gog cal list --date` 존재하지 않음 | `day-query/SKILL.md` | `--from`/`--to` 형식으로 수정 |
| `gog tasks list` 인자 누락 | `day-query/SKILL.md` | `gog tasks lists` → `gog tasks list <listId>` 순서 명시 |
| bibcli 스킬 디렉토리에 바이너리 없음 | `~/.claude/skills/bibcli/` | `~/.local/bin/bibcli` 심링크 추가 |

### 3.2 미해결 (외부 의존)

| 이슈 | 원인 | 조치 필요 |
|------|------|-----------|
| `gog contacts search` 403 | People API 미활성화 | Google Console에서 API 활성화 |
| lifetract 최근 데이터 없음 | 마지막 Samsung Health 내보내기: 2025-10-06 | 새 데이터 내보내기 후 `lifetract import --exec` |

### 3.3 주의 사항

| 스킬 | 주의 |
|------|------|
| medium-extractor | ESM 모듈 — 스킬 디렉토리 내에서 실행 필요 |
| transcribe | 실 음성 파일 테스트 미실시 (API 키 확인만) |
| browser-tools | Chrome 브라우저 실행 환경 필요 |

---

## 4. 스킬 설치 현황

### ~/.claude/skills/ 심링크 구조

| 스킬 | 바이너리 위치 | SKILL.md 위치 |
|------|-------------|---------------|
| denotecli | 스킬 디렉토리 내 | pi-skills 리포 |
| lifetract | `~/.local/bin/lifetract` → 심링크 | pi-skills → 심링크 |
| gitcli | `~/.local/bin/gitcli` → 심링크 | pi-skills → 심링크 |
| bibcli | `~/.local/bin/bibcli` → 심링크 | pi-skills → 심링크 |
| gogcli | `~/go/bin/gog` (PATH) | pi-skills 직접 복사 |
| ghcli | `/etc/profiles/.../gh` (NixOS) | pi-skills 직접 복사 |
| brave-search | 스킬 디렉토리 내 (Node.js) | 스킬 디렉토리 내 |
| emacs | 스킬 디렉토리 내 (Shell) | 스킬 디렉토리 내 |
| youtube-transcript | 스킬 디렉토리 내 (Node.js) | 스킬 디렉토리 내 |
| medium-extractor | 스킬 디렉토리 내 (Node.js) | 스킬 디렉토리 내 |
| transcribe | 스킬 디렉토리 내 (Shell) | 스킬 디렉토리 내 |
| browser-tools | 스킬 디렉토리 내 (Node.js) | 스킬 디렉토리 내 |
| peon-ping-* (4개) | 프롬프트 전용 | 스킬 디렉토리 내 |
| day-query | 프롬프트 전용 | pi-skills → 심링크 |
| bd-to-br-migration | 프롬프트 전용 | 스킬 디렉토리 내 |
