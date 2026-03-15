# pi-skills

> **⚠️ Migrated to [agent-config](https://github.com/junghan0611/agent-config)**
>
> All 23 skills have been moved to `agent-config/skills/`. This repo is kept as archive.
> New development happens at [junghan0611/agent-config](https://github.com/junghan0611/agent-config).
>
> ```bash
> # New setup
> git clone https://github.com/junghan0611/agent-config.git
> cd agent-config && ./run.sh setup
> ```

---

Personal AI agent skill set for [pi-coding-agent](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent). 23 skills covering knowledge base, life tracking, git timeline, Google Workspace, Slack, web search, session analysis, and more.

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

### 🛠️ Editor & Tools (4 skills)

| Skill | Description |
|-------|-------------|
| [emacs](emacs/SKILL.md) | Emacs buffer/selection context via emacsclient |
| [tmux](tmux/SKILL.md) | 장시간 명령(빌드, 서버, 배포) tmux 실행 + 인터랙티브 동기화 |
| [transcribe](transcribe/SKILL.md) | Speech-to-text via Groq Whisper API |

### 🔍 Agent Meta (1 skill)

| Skill | Description |
|-------|-------------|
| [improve-agent](improve-agent/SKILL.md) | 과거 세션 JSONL 분석 → 반복 실패/패턴 발견 → AGENTS.md/스킬 개선 |

### 📦 Utility (1 skill)

| Skill | Description |
|-------|-------------|
| [bd-to-br-migration](bd-to-br-migration/SKILL.md) | Beads tracker migration guide |

## Environment Setup

See [ENV-SETUP.md](ENV-SETUP.md) for full details.

## License

MIT
