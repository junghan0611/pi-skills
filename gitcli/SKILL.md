---
name: gitcli
description: "Local git timeline CLI. Query commit history across 50+ repositories. Use when user asks about coding activity, what they worked on, commit history, project timeline, or 'what did I do on [date]'."
---

# gitcli — Local Git Timeline CLI

Query commit history across all local git repositories (~/repos/gh, ~/repos/work).

Binary is bundled in the skill directory. Invoke via `{baseDir}/gitcli`.

Also installed at `~/.local/bin/gitcli`.

All output is JSON.

## When to Use

- "어제 뭐 코딩했지?" → `gitcli day --days-ago 1`
- "pi-mono 최근 커밋" → `gitcli log pi-mono --days 7`
- "이번 달 활동량" → `gitcli timeline --month 2026-02`
- "리포 몇 개야?" → `gitcli repos`
- 특정 날짜 활동 → `gitcli day 2025-10-10`

## Commands

### day — 특정 날짜의 모든 커밋

```bash
gitcli day                          # 오늘
gitcli day 2025-10-10               # 특정 날짜
gitcli day 20251010                 # Denote ID 호환
gitcli day --years-ago 1            # 1년 전 오늘
gitcli day --days-ago 7             # 7일 전
gitcli day --repos ~/repos/gh      # 특정 디렉토리만
gitcli day --author junghan        # 작성자 필터 (포크 리포 제외용)
```

Output: date, day_of_week, repos[].commits[], summary (active_repos, first/last commit, active_hours)

### repos — 리포 목록과 통계

```bash
gitcli repos                        # 기본 (~/repos/gh + ~/repos/work)
gitcli repos --repos ~/repos/gh    # 개인만
```

Output: total_repos, repos[].{name, path, first_commit, last_commit, total_commits, current_branch}

### log — 특정 리포 커밋 로그

```bash
gitcli log pi-mono --days 7
gitcli log pi-mono --from 2025-10-01 --to 2025-10-31
gitcli log pi-mono --author junghan
```

Output: repo, period, total, commits[].{hash, date, time, message, author}

### timeline — 기간별 활동 개요

```bash
gitcli timeline --days 30
gitcli timeline --month 2025-10
gitcli timeline --author junghan
```

Output: period, total_commits, active_days, daily[].{date, commits, repos[], hours}

## Important Notes

- **포크 리포 주의**: repos/gh에 포크한 리포가 섞여 있음. `--author` 필터로 본인 커밋만 볼 것.
- **기본 경로**: `~/repos/gh,~/repos/work` (1-depth 스캔, .git 있는 디렉토리만)
- **날짜 형식**: YYYY-MM-DD, YYYYMMDD, YYYYMMDDT... (Denote ID) 모두 지원
- **day-query 스킬과 연동**: 날짜 질문 시 denotecli day, lifetract read와 함께 호출

## Combination with Other Skills

날짜 기반 통합 조회 시 함께 사용:

```bash
# 1. 코딩 활동
gitcli day 2025-10-10

# 2. 저널/노트 (denotecli day 구현 예정)
denotecli search "20251010"

# 3. 건강/시간
lifetract read 2025-10-10
```
