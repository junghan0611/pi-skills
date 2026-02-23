# 환경별 경로 매핑

스킬 문서(SKILL.md)에서 `~/org`, `~/repos/gh` 등은 **로컬 기본값**입니다.
컨테이너(OpenClaw 등)에서는 아래 매핑을 참조하여 `--dirs`, `--repos` 등으로 오버라이드하세요.

## 경로 매핑 테이블

| 용도 | 로컬 (NixOS) | 컨테이너 (OpenClaw) | CLI 플래그 |
|------|-------------|-------------------|-----------|
| Denote 노트 | `~/org` | `/data/org` | `denotecli --dirs` |
| Git 개인 리포 | `~/repos/gh` | `/data/repos/gh` | `gitcli --repos` |
| Git 회사 리포 | `~/repos/work` | `/data/repos/work` | `gitcli --repos` |
| Bib 파일 | `~/sync/emacs/zotero-config/output` | `/data/org/resources` | `bibcli --dir` 또는 `BIBCLI_DIR` |
| Health 데이터 | `~/repos/gh/self-tracking-data` | `/data/self-tracking-data` | `lifetract --data-dir` |
| Author 설정 | `~/.config/gitcli/authors` | 동일 | — |

## 컨테이너 예시

```bash
# denotecli
denotecli day 2023-02-22 --dirs /data/org

# gitcli
gitcli day --me --repos /data/repos/gh,/data/repos/work

# bibcli
BIBCLI_DIR=/data/org/resources bibcli search "emacs"

# lifetract
lifetract read 2023-02-22 --data-dir /data/self-tracking-data
```

## 바이너리 경로

| 방식 | 설명 | 사용 스킬 |
|------|------|----------|
| `{baseDir}/CLI` | 스킬 폴더에 번들된 바이너리. pi가 자동 치환 | denotecli, brave-search, browser-tools, youtube-transcript |
| `~/.local/bin/CLI` | PATH에 설치된 바이너리 | gitcli, lifetract, bibcli |
| 시스템 패키지 | NixOS/apt로 설치 | gh, gog, curl, node |

**권장**: `{baseDir}` 방식이 이식성 최고. 바이너리를 스킬 폴더에 복사하면 컨테이너에서도 수정 없이 동작.
