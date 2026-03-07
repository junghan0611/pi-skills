# pi-skills

Personal AI agent skill set for [pi-coding-agent](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent). 20 skills covering knowledge base, life tracking, git timeline, Google Workspace, Slack, web search, and more.

Forked from [badlogic/pi-skills](https://github.com/badlogic/pi-skills) — upstream skills retained, custom skills added for personal data integration.

## Skills Overview

### 📊 Data Access (6 skills + 1 orchestrator)

Core skills that access personal data accumulated over years.

| Skill | CLI | Version | Data | Repo |
|-------|-----|---------|------|------|
| [denotecli](denotecli/SKILL.md) | `denotecli` | v0.8.0 | 3,100+ Denote/org notes, 715 journal files | [junghan0611/denotecli](https://github.com/junghan0611/denotecli) |
| [gitcli](gitcli/SKILL.md) | `gitcli` | v0.1.0 | 58 repos (41 personal + 17 work), 14,000+ commits | [junghan0611/gitcli](https://github.com/junghan0611/gitcli) |
| [lifetract](lifetract/SKILL.md) | `lifetract` | v0.1.0 | Samsung Health (2017~) + aTimeLogger (2021~) | [junghan0611/lifetract](https://github.com/junghan0611/lifetract) |
| [bibcli](bibcli/SKILL.md) | `bibcli` | v0.2.0 | 8,060 BibTeX entries (Zotero) | [junghan0611/zotero-config](https://github.com/junghan0611/zotero-config) |
| [gogcli](gogcli/SKILL.md) | `gog` | v0.11.0 | Google Calendar, Gmail, Drive, Tasks, Contacts | — |
| [ghcli](ghcli/SKILL.md) | `gh` | v2.83.2 | GitHub issues, PRs, starred repos | NixOS package |
| [day-query](day-query/SKILL.md) | — | — | Orchestrates all above by date | — |

### 💬 Communication (1 skill)

| Skill | Description |
|-------|-------------|
| [slack-latest](slack-latest/SKILL.md) | Slack 메시지 수집, 쓰레드 읽기, 답장. 브라우저 토큰 인증, DM 필터링 지원 |

### 🌐 External Information (4 skills)

| Skill | Description |
|-------|-------------|
| [brave-search](brave-search/SKILL.md) | Web search via Brave Search API |
| [youtube-transcript](youtube-transcript/SKILL.md) | YouTube video transcript extraction |
| [medium-extractor](medium-extractor/SKILL.md) | Medium article markdown extraction |
| [browser-tools](browser-tools/SKILL.md) | Chrome DevTools Protocol automation |

### 🛠️ Editor & Tools (3 skills)

| Skill | Description |
|-------|-------------|
| [emacs](emacs/SKILL.md) | Emacs buffer/selection context via emacsclient |
| [transcribe](transcribe/SKILL.md) | Speech-to-text via Groq Whisper API |
| [vscode](vscode/SKILL.md) | VS Code diff/compare integration |

### 🔔 Peon Ping (4 skills)

| Skill | Description |
|-------|-------------|
| [peon-ping-toggle](peon-ping-toggle/SKILL.md) | Sound notifications on/off |
| [peon-ping-config](peon-ping-config/SKILL.md) | Volume, pack rotation, categories |
| [peon-ping-use](peon-ping-use/SKILL.md) | Voice pack selection per session |
| [peon-ping-log](peon-ping-log/SKILL.md) | Exercise rep logging |

### 📦 Utility (1 skill)

| Skill | Description |
|-------|-------------|
| [bd-to-br-migration](bd-to-br-migration/SKILL.md) | Beads tracker migration guide |

## Custom CLIs (Go, zero dependencies)

All custom CLIs are written in Go with no external dependencies. Static binaries, CGO_ENABLED=0.

| CLI | Description | Tests | Coverage |
|-----|-------------|-------|----------|
| **denotecli** | Denote knowledge base search, read, day timeline, tag management | 30+ | 70.8% |
| **gitcli** | Local git commit timeline across 58 repos | 21 | 70.3% |
| **lifetract** | Samsung Health + aTimeLogger unified query | — | — |
| **bibcli** | BibTeX search/show across 8 bib files | — | — |

### Build & Install

```bash
# Each CLI: cd into repo, build, copy to ~/.local/bin
cd ~/repos/gh/denotecli/denotecli && CGO_ENABLED=0 go build -o denotecli . && cp denotecli ~/.local/bin/
cd ~/repos/gh/gitcli/gitcli && CGO_ENABLED=0 go build -o gitcli . && cp gitcli ~/.local/bin/
cd ~/repos/gh/lifetract/lifetract && CGO_ENABLED=0 go build -o lifetract . && cp lifetract ~/.local/bin/
cd ~/repos/gh/zotero-config/bibcli && CGO_ENABLED=0 go build -o bibcli . && cp bibcli ~/.local/bin/
```

## Environment Setup

See [ENV-SETUP.md](ENV-SETUP.md) for full details.

### Required

```bash
# ~/.env.local or home.sessionVariables in NixOS
export BIBCLI_DIR="$HOME/sync/emacs/zotero-config/output"
export GOG_ACCOUNT="junghanacs@gmail.com"
```

### API Keys (in ~/.env.local)

```bash
export BRAVE_API_KEY="..."       # Brave Search
export GROQ_API_KEY="..."        # Groq Whisper (transcribe)
export OPENROUTER_API_KEY="..."  # OpenRouter

# Slack — browser session tokens (expire on logout)
export SLACK_WORKSPACE_URL="https://WORKSPACE.slack.com"
export SLACK_TOKEN="xoxc-..."
export SLACK_COOKIE="xoxd-..."
```

### Author Config (gitcli)

```
# ~/.config/gitcli/authors
junghan
jhkim2
```

## Agent Compatibility

이 스킬셋은 로컬 에이전트와 OpenClaw 봇들이 공유한다. **공통 스킬은 동일한 SKILL.md를 유지해야 한다.**

### 배포 위치

| 에이전트 | 위치 | 설명 |
|----------|------|------|
| **pi** (로컬) | `~/.pi/agent/skills/pi-skills/` | 이 리포의 원본. 노트북/NUC에서 직접 사용 |
| **glg봇** | `~/openclaw/config/workspace-glg/skills/` | OpenClaw Docker — glg 워크스페이스 |
| **bbot** | `~/openclaw/config/workspace/skills/` | OpenClaw Docker — b 워크스페이스 |

### 스킬 동기화 현황

공통 17개 스킬은 세 곳 모두 동일하게 유지:

| 스킬 | pi | glg봇 | bbot |
|------|:--:|:-----:|:----:|
| agenda | ✓ | ✓ | ✓ |
| bibcli | ✓ | ✓ | ✓ |
| botlog | ✓ | ✓ | ✓ |
| brave-search | ✓ | ✓ | ✓ |
| day-query | ✓ | ✓ | ✓ |
| denotecli | ✓ | ✓ | ✓ |
| emacs | ✓ | ✓ | ✓ |
| ghcli | ✓ | ✓ | ✓ |
| gitcli | ✓ | ✓ | ✓ |
| gogcli | ✓ | ✓ | ✓ |
| lifetract | ✓ | ✓ | ✓ |
| medium-extractor | ✓ | ✓ | ✓ |
| punchout | ✓ | ✓ | ✓ |
| slack-latest | ✓ | ✓ | ✓ |
| summarize | ✓ | ✓ | ✓ |
| transcribe | ✓ | ✓ | ✓ |
| youtube-transcript | ✓ | ✓ | ✓ |

pi 전용 (봇에 불필요):
- `browser-tools`, `vscode`, `peon-ping-*`, `bd-to-br-migration`

### Slack ↔ 텔레그램 브릿지 (openclaw 봇)

회사 Slack은 admin 권한이 없어 Slack 앱/봇 설치 불가. 대신 **텔레그램 힣봇이 Slack 인터페이스 역할**을 한다:

```
텔레그램 → 힣봇(openclaw) → slack-latest 스킬 → 회사 Slack
```

- 텔레그램에서 "슬랙 오늘 뭐 올라왔어?" → 힣봇이 `slack.py gather --no-dm` 실행 → 결과 텔레그램으로 전달
- 환경변수(`SLACK_*`)를 Docker에 전달하면 동일하게 동작
- **DM은 기본 제외** — 에이전트 규칙으로 개인정보 보호

### 동기화 규칙

1. **pi-skills 리포가 원본** — 여기서 수정 후 봇에 복사
2. **봇에서 먼저 수정한 경우** — pi-skills에도 반영 (glg봇 emacs SKILL.md 사례)
3. **공통 스킬 수정 시** 세 곳 모두 동일한지 확인:
   ```bash
   diff ~/.pi/agent/skills/pi-skills/<skill>/SKILL.md ~/openclaw/config/workspace-glg/skills/<skill>/SKILL.md
   diff ~/openclaw/config/workspace-glg/skills/<skill>/SKILL.md ~/openclaw/config/workspace/skills/<skill>/SKILL.md
   ```

### 기타 에이전트

| Agent | Method |
|-------|--------|
| Claude Code | Symlink each skill to `~/.claude/skills/` |
| Codex CLI | `~/.codex/skills/pi-skills/` |
| Amp | `~/.config/amp/tools/pi-skills/` |

## License

MIT
