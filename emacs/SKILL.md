---
name: emacs
description: Emacs integration for capturing current selection, buffer, and persp context via emacsclient. Use when working in Emacs and need editor context.
---

# Emacs Integration

Use `emacsclient` to query the active Emacs session for context: buffer, selection, cursor, and buffer list (optionally scoped to persp-mode). It prefers the buffer with an active region and falls back to the selected window buffer.

## Requirements

- Emacs server running (`M-x server-start` or `emacs --daemon`)
- `emacsclient` available in PATH
- Emacs 27+ (for `json-serialize`)

## Detecting Emacs

When running inside Emacs/vterm, environment variables are usually set:

```bash
echo $INSIDE_EMACS
echo $TERM_PROGRAM
```

Verify the server is reachable:

```bash
emacsclient --eval "(emacs-version)"
```

## Get Current Context

```bash
./scripts/context.sh
```

Outputs JSON to stdout with:

- `buffer`: active-region buffer (if any) or selected window buffer (name, file, mode, modified, active)
- `cursor`: line/column
- `selection`: selected text and range (empty object when no active region)
- `persp`: current persp name (if persp-mode is loaded)
- `project`: project root (if project.el is available)
- `buffers`: file-backed buffers in the current persp (or all buffers when no persp)

If you have a region active in another buffer (e.g., you are in vterm but selected text in a file buffer), the selection and `buffer` fields will reflect that active region.

## org-agenda 통합 뷰

에이전트가 Emacs org-agenda를 직접 호출하여 일정·커밋·활동을 조회한다.
소켓 통신이므로 **토큰 소비 0**, 응답도 즉시.

### 오늘/특정 날짜/주간 뷰

```bash
# 오늘 일간 뷰
emacsclient --eval '(org-agenda-list nil nil 1)'

# 특정 날짜 일간 뷰
emacsclient --eval '(org-agenda-list nil "2026-02-27" 1)'

# 주간 뷰
emacsclient --eval '(org-agenda-list nil nil 7)'
```

결과를 텍스트로 가져오려면:

```bash
emacsclient --eval '(with-current-buffer "*Org Agenda*" (buffer-string))'
```

### 태그 필터 뷰

```bash
# 커밋만 보기
emacsclient --eval '(org-tags-view nil "commit")'

# 에이전트 활동만 보기
emacsclient --eval '(org-tags-view nil "pi")'

# PUNCHOUT만 보기
emacsclient --eval '(org-tags-view nil "PUNCHOUT")'
```

### 비용/성능

- `emacsclient`는 Unix 소켓으로 실행 중인 Emacs에 연결
- 외부 API 호출 없음 → **토큰 0, 비용 0**
- 응답 시간: 수십 ms (로컬 소켓)
- day-query나 gitcli보다 가벼움 — 빠른 확인에 적합

### day-query 연동 가이드

1. **빠른 확인**: org-agenda 뷰로 일정·태그 먼저 조회
2. **상세 조회**: 커밋 수·리포 통계가 필요하면 day-query 스킬 사용
3. **조합 패턴**: agenda로 타임라인 확인 → gitcli로 커밋 상세 → lifetract로 건강 데이터
