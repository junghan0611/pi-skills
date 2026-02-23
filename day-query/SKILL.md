---
name: day-query
description: "날짜 기반 통합 조회 — 특정 날짜(또는 기간)에 사용자가 무엇을 했는지, 무엇을 만들었는지, 무엇을 읽었는지, 몸 상태는 어땠는지를 한번에 파악. git 커밋, org 저널, denote 노트, bib 참고문헌, 건강/시간 데이터를 시간축으로 통합하여 사용자의 하루를 재구성한다. Use when user asks 'what did I do on [date]', '어제 뭐 했지', '3년전 오늘', or any date-based activity question."
---

# day-query — 날짜 기반 통합 조회 스킬

특정 날짜에 대해 **모든 데이터 소스**를 조회하여 사용자의 하루를 재구성한다.

## When to Use

- "어제 뭐 했지?" / "3년 전 오늘"
- "2025-10-10에 뭘 작업했나"
- "이번 주 활동 정리"
- "지난 달 얼마나 코딩했지?"
- "연봉협상 자료 정리해줘" (회사 리포 기준)

## 호출 순서 (5개 CLI)

날짜 질문을 받으면 아래 CLI를 **순차 호출**한다:

### 1. 코딩 활동 (gitcli)

```bash
gitcli day <DATE> --me                               # 개인+회사
gitcli day <DATE> --me --repos ~/repos/gh            # 개인만
gitcli day <DATE> --me --repos ~/repos/work          # 회사만
```

### 2. 저널/노트 (denotecli)

```bash
denotecli day <DATE> --dirs ~/org
```

Journal(daily/weekly), diary.org datetree, 당일 생성 노트를 한번에 반환.

### 3. 건강/시간 추적 (lifetract)

```bash
lifetract read <DATE>
```

수면, 걸음, 심박, 스트레스, aTimeLogger 시간 카테고리.

### 4. 참고문헌 (bibcli, 선택)

```bash
bibcli search "<YYYYMMDD>"
```

당일 추가된 Zotero 참고문헌 (해당일에 bib 엔트리가 생성된 경우).

### 5. 일정/할일 (gogcli, 선택)

```bash
gog cal list --date <DATE>
gog tasks list
```

Google Calendar 일정, Tasks 할일.

## 날짜 형식 (모든 CLI 공통)

| 입력 | 해석 |
|------|------|
| `2025-10-10` | 해당 날짜 |
| `20251010` | Denote ID 호환 |
| `--years-ago N` | N년 전 오늘 |
| `--days-ago N` | N일 전 오늘 |

## 통합 해석 가이드

에이전트가 5개 결과를 받으면:

1. **시간순 병합** — 커밋 시각 + 저널 시각 + 건강 데이터를 시간축으로 정렬
2. **패턴 인식** — "새벽 2시부터 코딩, 점심 안 먹음, 스트레스 높음"
3. **장기 비교** — `--years-ago`로 작년 같은 시기와 비교
4. **프로젝트 추적** — gitcli timeline으로 프로젝트 전환 패턴 파악

## Repo Groups (gitcli용)

| 경로 | 성격 | 용도 |
|------|------|------|
| `~/repos/gh` | 개인 GitHub (~30 repos) | 개인 프로젝트 |
| `~/repos/work` | 회사 GitHub (~18 repos) | 업무/연봉협상 |

`--me` 플래그: `~/.config/gitcli/authors`에 정의된 패턴으로 본인 커밋만 필터.

## 사용 예시

### "3년 전 오늘 뭐 했지?"

```bash
gitcli day --years-ago 3 --me
denotecli day --years-ago 3
lifetract read $(date -d '3 years ago' +%Y-%m-%d)
```

### "이번 달 회사 작업 정리"

```bash
gitcli timeline --month 2026-02 --me --repos ~/repos/work
```

### "어제 하루 전체"

```bash
gitcli day --days-ago 1 --me
denotecli day --days-ago 1
lifetract read $(date -d yesterday +%Y-%m-%d)
```
