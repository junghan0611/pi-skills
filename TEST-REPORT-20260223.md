# pi-skills 테스트 리포트

**일시**: 2026-02-23 16:20 KST  
**테스터**: pi (홈 디렉토리 세션, PID 25629)  
**환경**: NixOS 25.11 / ThinkPad P16s  
**pi-skills 위치**: `~/repos/gh/pi-skills/` (15개 스킬 + 4개 peon-ping 스킬)

---

## 종합 결과

| 상태 | 개수 | 비율 |
|------|------|------|
| ✅ 정상 동작 | 15 | 79% |
| ⚠️ 설정 필요 | 2 | 11% |
| 🔧 마이너 이슈 | 2 | 11% |
| ❌ 실패 | 0 | 0% |

> **2차 테스트 (16:25)**: bibcli, gogcli 환경변수 해결 후 재확인 → 모두 정상

---

## 스킬별 상세

### ✅ 정상 동작 (13개)

| 스킬 | CLI/도구 | 버전 | 테스트 내용 | 비고 |
|------|----------|------|-------------|------|
| **denotecli** | `denotecli` | v0.8.0 | search, day, timeline-journal 모두 정상 | 🆕 day, timeline-journal 신규 기능 OK |
| **gitcli** | `gitcli` | v0.1.0 | day, repos, log 모두 정상. 오늘 40커밋 탐지 | 🆕 신규 CLI |
| **bibcli** | `bibcli` | - | search, show, list, stats 정상. 8,060 엔트리 | `BIBCLI_DIR` 환경변수 설정 완료 |
| **ghcli** | `gh` | v2.83.2 | API 인증 OK, `junghan0611` 확인 | NixOS 패키지 |
| **lifetract** | `lifetract` | v0.1.0 | status, today 정상. DB 모드 동작 | Samsung Health + aTimeLogger |
| **emacs** | `emacsclient` | - | 서버 연결 정상, 버퍼명 반환 OK | Doom Emacs 서버 구동 중 |
| **day-query** | (오케스트레이션) | - | SKILL.md 가이드 정상, 5개 CLI 연계 | 🆕 신규 스킬 |
| **transcribe** | curl + Groq | - | `GROQ_API_KEY` 설정됨, 사용 가능 | - |
| **youtube-transcript** | `transcript.js` | - | node_modules 설치됨, 실행 준비 완료 | - |
| **medium-extractor** | `extract.js` | - | node_modules 설치됨, 실행 준비 완료 | - |
| **vscode** | `code` | - | CLI 존재 확인, diff 기능 사용 가능 | - |
| **bd-to-br-migration** | `br` | v0.1.14 | br CLI 정상 동작 | 마이그레이션 가이드 |
| **peon-ping-toggle** | `peon.sh` | v2.5.0 | pause/resume 정상 | pi 확장과 연동 확인 |

### ⚠️ 설정 필요 (2개)

| 스킬 | 상태 | 필요 조치 |
|------|------|-----------|
| **brave-search** | `BRAVE_SEARCH_API_KEY` 미설정 | API 키 발급 필요 (무료 플랜 가능) |
| **browser-tools** | Chrome `:9222` 필요 | `npm install` + Chrome `--remote-debugging-port=9222` 실행 필요 |

### ✅ 2차 테스트 해결 (환경변수)

| 스킬 | 해결 방법 | 결과 |
|------|-----------|------|
| **bibcli** | `BIBCLI_DIR` → `~/.config/environment.d/50-pi-skills.conf` | 8,060 엔트리 검색 정상 |
| **gogcli** | `GOG_ACCOUNT=junghanacs@gmail.com` 동일 파일 | Calendar(No events=정상), Gmail 검색 정상 |

### 🔧 마이너 이슈 (2개)

| 스킬 | 이슈 | 심각도 | 해결 방안 |
|------|------|--------|-----------|
| **peon-ping-use** | pi 세션에서 `session_id` 매핑이 Claude Code와 다름 | 낮음 | peon-ping.ts에서 이미 `pi-UUID` 형식 사용, 팩 전환은 `.pi/peon-ping.json`으로 대체 |
| **peon-ping-log** | trainer 비활성 상태 (`"enabled": false`) | 낮음 | `peon trainer on`으로 활성화하면 동작 |

---

## 환경변수 현황

| 변수 | 상태 | 용도 |
|------|------|------|
| `BIBCLI_DIR` | ✅ 설정됨 | `~/sync/emacs/zotero-config/output` |
| `GOG_ACCOUNT` | ✅ 설정됨 | `junghanacs@gmail.com` |
| `GROQ_API_KEY` | ✅ 설정됨 | Groq Whisper 음성인식 |
| `BRAVE_SEARCH_API_KEY` | ❌ 미설정 | Brave 웹 검색 |
| `GITHUB_TOKEN` / `gh auth` | ✅ 인증됨 | GitHub CLI |

**설정 파일**: `~/.config/environment.d/50-pi-skills.conf`

---

## 🆕 신규 기능 테스트 (오늘 빌드)

### gitcli v0.1.0
```
$ gitcli day 2026-02-23 --me
→ 48개 리포 스캔, 오늘 40커밋 탐지
→ denotecli, pi-skills, gitcli 등 리포별 커밋 타임라인 정상
```

### denotecli v0.8.0 (+day, +timeline-journal)
```
$ denotecli day 2026-02-23
→ 저널 엔트리 시간별 출력 정상
→ weekly 저널 포맷 자동 감지

$ denotecli timeline-journal --month 2026-02
→ 28일 중 23일 활성, 일별 소스 분류 정상
```

### day-query 스킬
```
오케스트레이션 가이드로 5개 CLI 순차 호출:
  1. gitcli day → 코딩 활동
  2. denotecli day → 저널/노트
  3. denotecli search → 생성 노트
  4. bibcli search → 참고문헌
  5. lifetract read → 건강/시간
모든 CLI가 개별 동작 확인됨
```

---

## 권장 조치

### 완료 ✅
1. ~~`BIBCLI_DIR` 환경변수~~ → `50-pi-skills.conf`에 설정 완료
2. ~~`GOG_ACCOUNT` 환경변수~~ → 동일 파일에 설정 완료

### 남은 조치
1. (선택) Brave Search API 키 발급
2. peon-ping v2.5.0 → v2.8.0 업데이트
3. lifetract DB 최신 데이터 동기화 확인 (오늘자 steps=0, 폰 동기화 필요)

---

*2차 테스트 완료. 17/19 스킬 즉시 사용 가능. (brave-search, browser-tools만 추가 설정 필요)*
