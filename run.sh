#!/usr/bin/env bash
set -euo pipefail

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# pi-skills run.sh — Self-documenting CLI for humans & agents
# Usage:
#   ./run.sh              → Interactive menu
#   ./run.sh <command>    → Direct execution (agent-friendly)
#   ./run.sh help         → Show all commands
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Project root (where this script lives)
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Skills that need npm install
NPM_SKILLS=(brave-search browser-tools youtube-transcript medium-extractor)

# Global CLI tools
GLOBAL_CLIS=("@mariozechner/gccli" "@mariozechner/gdcli" "@mariozechner/gmcli")

# Helper functions
info()    { echo -e "${BLUE}i ${NC}$1"; }
success() { echo -e "${GREEN}v${NC} $1"; }
warn()    { echo -e "${YELLOW}!${NC} $1"; }
error()   { echo -e "${RED}x${NC} $1"; }
header()  { echo -e "\n${BOLD}${CYAN}$1${NC}"; }

ensure_project_dir() {
    cd "$PROJECT_DIR"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# COMMANDS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ── Setup ────────────────────────────────────────────────────────────

cmd_install() {
    # DESC: 모든 skill 의존성 설치 (npm + global CLI)
    # USAGE: install
    ensure_project_dir
    header "npm skills 설치"
    for skill in "${NPM_SKILLS[@]}"; do
        if [[ -d "$skill" && -f "$skill/package.json" ]]; then
            info "$skill: npm install..."
            (cd "$skill" && npm install --no-audit --no-fund) || warn "$skill: 설치 실패"
        fi
    done

    echo ""
    header "글로벌 CLI 설치"
    for cli in "${GLOBAL_CLIS[@]}"; do
        local name
        name=$(echo "$cli" | sed 's|.*/||')
        if command -v "$name" &>/dev/null; then
            success "$name: 이미 설치됨 ($(which "$name"))"
        else
            info "$name: pnpm install -g $cli..."
            pnpm install -g "$cli" || warn "$name: 설치 실패"
        fi
    done
    echo ""
    success "설치 완료!"
}

cmd_install_skill() {
    # DESC: 특정 skill 의존성 설치
    # USAGE: install-skill <skill-name>
    # EXAMPLE: install-skill brave-search
    ensure_project_dir
    local skill="${1:-}"
    if [[ -z "$skill" ]]; then
        error "skill 이름을 지정하세요: ./run.sh install-skill <name>"
        return 1
    fi
    if [[ ! -d "$skill" ]]; then
        error "존재하지 않는 skill: $skill"
        return 1
    fi
    if [[ -f "$skill/package.json" ]]; then
        info "$skill: npm install..."
        (cd "$skill" && npm install --no-audit --no-fund)
        success "$skill 설치 완료!"
    else
        info "$skill: npm 의존성 없음 (설치 불필요)"
    fi
}

# ── Link ─────────────────────────────────────────────────────────────

cmd_link() {
    # DESC: ~/.pi/agent/skills/pi-skills 심볼릭 링크 생성
    # USAGE: link
    ensure_project_dir
    local target="$HOME/.pi/agent/skills/pi-skills"
    mkdir -p "$(dirname "$target")"

    if [[ -L "$target" ]]; then
        local current
        current=$(readlink "$target")
        if [[ "$current" == "$PROJECT_DIR" ]]; then
            success "이미 링크됨: $target -> $PROJECT_DIR"
            return 0
        fi
        warn "기존 링크 제거: $target -> $current"
        rm "$target"
    elif [[ -e "$target" ]]; then
        warn "기존 디렉토리를 백업: ${target}.bak"
        mv "$target" "${target}.bak"
    fi

    ln -s "$PROJECT_DIR" "$target"
    success "링크 완료: $target -> $PROJECT_DIR"
}

cmd_unlink() {
    # DESC: ~/.pi/agent/skills/pi-skills 심볼릭 링크 제거
    # USAGE: unlink
    local target="$HOME/.pi/agent/skills/pi-skills"
    if [[ -L "$target" ]]; then
        rm "$target"
        success "링크 제거됨: $target"
        if [[ -e "${target}.bak" ]]; then
            mv "${target}.bak" "$target"
            success "백업 복원됨"
        fi
    else
        warn "$target 가 심볼릭 링크가 아닙니다"
    fi
}

# ── Test ─────────────────────────────────────────────────────────────

cmd_test_emacs() {
    # DESC: Emacs context skill 테스트 (emacsclient 필요)
    # USAGE: test-emacs
    ensure_project_dir
    if [[ ! -f "emacs/scripts/context.sh" ]]; then
        error "emacs skill이 없습니다"
        return 1
    fi

    header "Emacs context 테스트"
    echo ""
    bash emacs/scripts/context.sh 2>&1 | python3 -m json.tool 2>/dev/null || bash emacs/scripts/context.sh
    echo ""
    success "테스트 완료!"
}

cmd_test_emacs_el() {
    # DESC: Emacs context elisp 단위 테스트 (ert)
    # USAGE: test-emacs-el
    ensure_project_dir
    if [[ ! -f "emacs/tests/context-test.el" ]]; then
        error "emacs 테스트 파일이 없습니다"
        return 1
    fi

    header "Emacs ERT 테스트"
    emacs --batch -l emacs/tests/context-test.el -f ert-run-tests-batch-and-exit
}

# ── Status ───────────────────────────────────────────────────────────

cmd_status() {
    # DESC: 전체 skill 상태 점검
    # USAGE: status
    ensure_project_dir

    header "Skill 상태"
    echo ""

    # Link
    local target="$HOME/.pi/agent/skills/pi-skills"
    if [[ -L "$target" ]]; then
        local dest
        dest=$(readlink "$target")
        if [[ "$dest" == "$PROJECT_DIR" ]]; then
            success "링크: $target -> $dest"
        else
            warn "링크 경로 불일치: $target -> $dest (expected: $PROJECT_DIR)"
        fi
    else
        warn "링크 없음: $target"
    fi
    echo ""

    # Skills
    printf "  ${BOLD}%-20s %-10s %-10s${NC}\n" "Skill" "SKILL.md" "Deps"
    printf "  %-20s %-10s %-10s\n" "--------------------" "--------" "--------"
    for dir in */; do
        local name="${dir%/}"
        [[ "$name" == "node_modules" ]] && continue

        local has_skill="--"
        local deps_status="--"

        [[ -f "$dir/SKILL.md" ]] && has_skill="OK"

        if [[ -f "$dir/package.json" ]]; then
            if [[ -d "$dir/node_modules" ]]; then
                deps_status="OK"
            else
                deps_status="MISSING"
            fi
        else
            deps_status="N/A"
        fi

        printf "  %-20s %-10s %-10s\n" "$name" "$has_skill" "$deps_status"
    done

    echo ""

    # Global CLIs
    header "Global CLI"
    echo ""
    for cli in "${GLOBAL_CLIS[@]}"; do
        local name
        name=$(echo "$cli" | sed 's|.*/||')
        if command -v "$name" &>/dev/null; then
            success "$name: $(which "$name")"
        else
            warn "$name: 미설치"
        fi
    done
    echo ""
}

# ── Utility ──────────────────────────────────────────────────────────

cmd_update() {
    # DESC: upstream (badlogic) 최신 변경사항 가져오기
    # USAGE: update
    ensure_project_dir
    if ! git remote | grep -q upstream; then
        git remote add upstream https://github.com/badlogic/pi-skills.git
    fi
    git fetch upstream main
    info "upstream/main 가져옴. 머지하려면:"
    echo "  git merge upstream/main"
}

cmd_clean() {
    # DESC: 모든 skill의 node_modules 삭제
    # USAGE: clean
    ensure_project_dir
    for dir in */; do
        if [[ -d "$dir/node_modules" ]]; then
            rm -rf "$dir/node_modules"
            info "${dir%/}: node_modules 삭제"
        fi
    done
    success "정리 완료!"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# COMMAND REGISTRY
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

COMMANDS=(
    "--- Setup"
    "install:cmd_install"
    "install-skill:cmd_install_skill"
    "--- Link"
    "link:cmd_link"
    "unlink:cmd_unlink"
    "--- Test"
    "test-emacs:cmd_test_emacs"
    "test-emacs-el:cmd_test_emacs_el"
    "--- Status"
    "status:cmd_status"
    "--- Utility"
    "update:cmd_update"
    "clean:cmd_clean"
)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# INTROSPECTION
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SCRIPT_SOURCE="${BASH_SOURCE[0]}"

get_cmd_meta() {
    local func_name="$1"
    local tag="$2"
    sed -n "/^${func_name}()/,/^}/p" "$SCRIPT_SOURCE" \
        | { grep -m1 "# ${tag}:" || true; } \
        | sed "s/.*# ${tag}: *//"
}

get_cmd_meta_all() {
    local func_name="$1"
    local tag="$2"
    sed -n "/^${func_name}()/,/^}/p" "$SCRIPT_SOURCE" \
        | { grep "# ${tag}:" || true; } \
        | sed "s/.*# ${tag}: *//"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# HELP
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

show_help() {
    echo ""
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${GREEN}  pi-skills${NC} — Pi Coding Agent Skills"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${DIM}사용법:${NC}"
    echo -e "    ./run.sh                  ${DIM}# Interactive 메뉴${NC}"
    echo -e "    ./run.sh <command> [args] ${DIM}# 직접 실행 (에이전트용)${NC}"
    echo -e "    ./run.sh help             ${DIM}# 이 도움말${NC}"

    local idx=0
    for entry in "${COMMANDS[@]}"; do
        if [[ "$entry" == ---* ]]; then
            local section="${entry#--- }"
            echo ""
            echo -e "  ${YELLOW}${section}${NC}"
            continue
        fi

        idx=$((idx + 1))
        local cmd_name="${entry%%:*}"
        local func_name="${entry#*:}"
        local desc
        desc=$(get_cmd_meta "$func_name" "DESC")

        printf "    ${BOLD}%-3s${NC} %-18s %s\n" "${idx})" "${cmd_name}" "${desc:-}"
    done

    echo ""
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# INTERACTIVE MENU
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

interactive_menu() {
    while true; do
        show_help
        echo -e "    ${BOLD} 0)${NC} 종료"
        echo ""
        read -rp "  선택 (번호 또는 명령어): " choice

        if [[ "$choice" == "0" || "$choice" == "q" ]]; then
            info "종료합니다."
            exit 0
        fi

        [[ -z "$choice" ]] && continue

        if [[ "$choice" =~ ^[0-9]+$ ]]; then
            local idx=0
            local found=""
            for entry in "${COMMANDS[@]}"; do
                [[ "$entry" == ---* ]] && continue
                idx=$((idx + 1))
                if [[ "$idx" -eq "$choice" ]]; then
                    found="$entry"
                    break
                fi
            done

            if [[ -z "$found" ]]; then
                error "잘못된 번호입니다: $choice"
                read -rp "  계속하려면 Enter..."
                continue
            fi

            local func_name="${found#*:}"
            eval "$func_name" || true
        else
            dispatch_command "$choice"
        fi

        echo ""
        read -rp "  계속하려면 Enter..."
    done
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DISPATCH
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

dispatch_command() {
    local cmd="$1"
    shift 2>/dev/null || true

    for entry in "${COMMANDS[@]}"; do
        [[ "$entry" == ---* ]] && continue
        local cmd_name="${entry%%:*}"
        local func_name="${entry#*:}"
        if [[ "$cmd_name" == "$cmd" ]]; then
            "$func_name" "$@"
            return $?
        fi
    done

    error "알 수 없는 명령어: $cmd"
    echo "  ./run.sh help 로 전체 목록을 확인하세요."
    return 1
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ENTRYPOINT
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

main() {
    if [[ $# -eq 0 ]]; then
        interactive_menu
        return
    fi

    local cmd="$1"
    shift

    case "$cmd" in
        help|--help|-h)
            show_help
            ;;
        *)
            dispatch_command "$cmd" "$@"
            ;;
    esac
}

main "$@"
