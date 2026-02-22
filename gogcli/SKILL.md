---
name: gogcli
description: Google Workspace all-in-one CLI (gog) for Calendar, Gmail, Drive, Tasks, Chat, Contacts, Sheets, Docs. Replaces gccli/gdcli/gmcli.
---

# gogcli (gog)

All-in-one Google Workspace CLI. Single binary covering Calendar, Gmail, Drive, Tasks, Chat, Contacts, Sheets, Docs, and more.

## Accounts

- **Personal**: `--account junghanacs@gmail.com` (client: personal, services: all)
- **Work**: `--account jhkim2@goqual.com` (client: work, services: calendar,gmail,drive,tasks,chat)

Tip: `GOG_ACCOUNT=junghanacs@gmail.com` 환경변수로 기본 계정 설정 가능.

## Tasks

```bash
# 태스크 리스트 목록
gog tasks lists

# 특정 리스트의 태스크 조회
gog tasks list <listId> --all
gog tasks list <listId> --due-min 2026-01-01T00:00:00Z --due-max 2026-12-31T23:59:59Z

# 태스크 추가
gog tasks add <listId> --title "제목"
gog tasks add <listId> --title "반복" --due 2026-03-01 --repeat weekly --repeat-count 4

# 태스크 완료/미완료
gog tasks done <listId> <taskId>
gog tasks undo <listId> <taskId>

# 태스크 삭제
gog tasks delete <listId> <taskId>
gog tasks clear <listId>   # 완료된 것만 삭제
```

## Calendar

```bash
gog calendar list --max 10
gog calendar list --from 2026-02-22T00:00:00Z --to 2026-02-28T23:59:59Z
gog calendar get <eventId>
gog calendar create --summary "회의" --start 2026-03-01T10:00:00+09:00 --end 2026-03-01T11:00:00+09:00
gog calendar update <eventId> --summary "변경된 제목"
gog calendar delete <eventId>
gog calendar calendars   # 캘린더 목록
```

## Gmail

```bash
gog gmail search "newer_than:7d" --max 10
gog gmail search "from:someone@example.com subject:report"
gog gmail get <messageId>
gog gmail thread <threadId>
gog gmail send --to "a@b.com" --subject "제목" --body "내용"
gog gmail send --to "a@b.com" --subject "첨부" --body "파일" --attach /path/to/file
gog gmail labels
gog gmail label <messageId> --add STARRED
```

## Drive

```bash
gog drive ls [folderId]
gog drive search "query" --max 10
gog drive get <fileId>
gog drive download <fileId> --out /tmp/
gog drive upload /path/to/file [--folder <folderId>]
gog drive mkdir "폴더명" [--parent <folderId>]
gog drive share <fileId> --anyone --role reader
gog drive permissions <fileId>
```

## Contacts

```bash
gog contacts list --max 20
gog contacts search "이름"
gog contacts get <resourceName>
gog contacts create --given-name "이름" --family-name "성" --email "a@b.com"
```

## Sheets

```bash
gog sheets get <sheetId> "Sheet1!A1:D10" --json
gog sheets update <sheetId> "Sheet1!A1:B2" --values-json '[["A","B"],["1","2"]]' --input USER_ENTERED
gog sheets append <sheetId> "Sheet1!A:C" --values-json '[["x","y","z"]]' --insert INSERT_ROWS
gog sheets clear <sheetId> "Sheet1!A2:Z"
gog sheets metadata <sheetId> --json
```

## Docs

```bash
gog docs cat <docId>
gog docs export <docId> --format txt --out /tmp/doc.txt
gog docs export <docId> --format pdf --out /tmp/doc.pdf
```

## Chat (Workspace)

```bash
gog chat spaces
gog chat messages <spaceId> --max 20
gog chat send <spaceId> --text "메시지"
```

## Shortcuts

```bash
gog send          # gmail send
gog ls            # drive ls
gog search        # drive search
gog download      # drive download
gog upload        # drive upload
gog whoami        # people me
```

## Output Formats

```bash
gog --json <command>       # JSON 출력
gog --plain <command>      # TSV 출력 (스크립팅용)
gog <command> --json --results-only   # envelope 제거
```

## Auth Management

```bash
gog auth status
gog auth list              # 등록된 계정 목록
gog auth credentials set <json> --client <name>
gog auth add <email> --client <name> --services <list> --manual
gog auth alias set <alias> <email>
```

## Notes

- **확인 필요**: 메일 발송, 이벤트 생성/삭제 전 반드시 사용자 확인
- `--json`과 `jq` 조합으로 스크립팅 가능
- `gog schema`로 머신 리더블 명령어 스키마 조회
