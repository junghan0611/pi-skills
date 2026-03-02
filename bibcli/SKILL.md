---
name: bibcli
description: Search and view 8,000+ BibTeX entries from personal bibliography. Use when user mentions papers, books, citations, references, or asks to find/show bibliographic entries.
---

# bibcli - BibTeX Search CLI

Search and view bibliographic entries from the user's personal library (8,000+ entries across 8 BibTeX files).

Binary is bundled in the skill directory. Invoke via `{baseDir}/bibcli`.

Set `BIBCLI_DIR` environment variable or use `--dir` flag.

## Environment Paths

Bib files location differs by environment. Use `--dir` accordingly:

| Environment | Bib Path | Example |
|-------------|----------|---------|
| **Local** (Claude Code) | `~/sync/emacs/zotero-config/output` | `bibcli search "query"` (uses `$BIBCLI_DIR`) |
| **Local** (alt) | `~/org/resources` | `bibcli search "query" --dir ~/org/resources` |
| **Container** (OpenClaw) | `/data/org/resources` | `bibcli search "query" --dir /data/org/resources` |

## Commands

### Search entries

```bash
bibcli search "emacs org-mode" --max 10
bibcli search "knowledge graph" --type Book
bibcli search "한국" --type Book --max 5
```

- Multiple words = AND condition (all must match)
- Searches: title, author, keywords, citationKey, date, abstract
- Case-insensitive (Korean included)

### Show single entry (full details)

```bash
bibcli show "165.84-박82ㅅ"
bibcli show "web-MermaidAscii터미널에서"
```

Returns all fields including abstract, url, isbn, keywords.

### List entries by type

```bash
bibcli list --type Book --max 10
bibcli list --type Online --max 20
bibcli list --type Software --max 5
```

### Statistics

```bash
bibcli stats
```

## Flags

| Flag | Description | Default |
|------|-------------|---------|
| `--dir DIR` | Bib files directory | `$BIBCLI_DIR` |
| `--type TYPE` | Filter by type: `Book`, `Online`, `Software`, `Reference`, `Video`, `Article`, `Misc` | all |
| `--max N` | Max results | search: 20, list: 50 |

## Output

All output is JSON. Examples:

**search/list** returns brief entries:
```json
[{"key": "book-pkm2024", "type": "book", "title": "...", "author": "...", "date": "2024", "file": "Book.bib"}]
```

**show** returns full entry with all fields:
```json
{"key": "...", "type": "book", "title": "...", "author": "...", "isbn": "...", "abstract": "...", "file": "Book.bib"}
```

**stats** returns counts:
```json
{"total": 8030, "files": {"Book.bib": 1463, "Online.bib": 2610, ...}}
```

## Update Bib Data

Bib files can become stale. Use these commands to sync from Zotero Cloud:

```bash
cd ~/repos/gh/zotero-config

# 증분 동기화 (Zotero 변경분만)
./run.sh bib sync

# 전체 재동기화
./run.sh bib full

# 증분 + GitHub starred 한번에
./run.sh update

# 현재 상태 확인 (동기화 없이)
./run.sh bib status
```

동기화 후 `output/*.bib` → `~/org/resources/`로 자동 복사됩니다.

## BibTeX File Types

| File | Content | Count |
|------|---------|-------|
| Book.bib | Books (KDC citation keys for Korean) | ~1,463 |
| Online.bib | Webpages, blog posts, forum posts | ~2,610 |
| Software.bib | Software projects | ~1,082 |
| github-starred.bib | GitHub starred repos | ~2,140 |
| Reference.bib | Encyclopedias, dictionaries | ~365 |
| Video.bib | Videos, films, broadcasts | ~239 |
| Article.bib | Journal articles | ~69 |
| Misc.bib | Everything else | ~62 |
