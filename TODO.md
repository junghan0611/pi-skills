# pi-skills TODO

## gogcli 전환 (gccli/gdcli/gmcli → gog)

- [x] Google Cloud Console에서 **Desktop app** OAuth 클라이언트 생성
- [x] 크레덴셜 등록: `gog auth credentials set <json> --client work/personal`
- [x] 개인 계정 인증: junghanacs@gmail.com (services: all)
- [x] 회사 계정 인증: jhkim2@goqual.com (services: calendar,gmail,drive,tasks,chat)
- [x] gogcli SKILL.md 작성
- [x] gccli/gdcli/gmcli → _deprecated/ 이동
- [ ] 회사 계정 OAuth 동의 화면 정리 (n8n-goqual, classroom 등 불필요 scope 제거)

### 삽질 기록: 회사 계정 OAuth 인증 실패

- `--services all`로 요청하면 `unknownerror` 발생
- **원인**: n8n-goqual 프로젝트에서 Classroom, Forms 등 API가 활성화되지 않아 해당 scope 요청 시 실패
- **해결**: `--services calendar,gmail,drive,tasks,chat` 으로 필요한 서비스만 지정
- **교훈**: 회사/조직 프로젝트는 `--services all` 대신 실제 사용하는 서비스만 명시할 것

## OracleVM gogcli 배포

- [x] ssh oracle 접속하여 gog 바이너리 설치
- [x] gogcli 크레덴셜 전송 + 계정 인증 (--remote 2-step)
- [x] keyring: file 모드, `GOG_KEYRING_PASSWORD=gogcli` 필수
- [ ] OpenClaw 봇에게 gogcli 스킬 전달

### 삽질 기록: Docker에서 gog 실행 불가 (동적 링크)

- NixOS에서 `go install`로 빌드한 gog는 glibc에 동적 링크됨
- Debian 기반 Docker 컨테이너에서 실행 불가 (glibc 버전 불일치)
- **해결**: `CGO_ENABLED=0 go install github.com/steipete/gogcli/cmd/gog@v0.11.0` 로 정적 빌드
- **참고**: denotecli(Rust)는 statically linked라 Docker 어디서든 동작
- **교훈**: Go 바이너리를 Docker/다른 배포판에 넣을 때는 반드시 `CGO_ENABLED=0`

## Samsung Health 봇 연동

- [ ] [samsung-health 스킬](https://clawhub.ai/mudgesbot/samsung-health) 검토
- [ ] 봇에게 건강 데이터 컨텍스트 제공 (존재 대 존재 협력)
- [ ] pi-skills로 가져올지 / OpenClaw 내장으로 쓸지 판단

## OpenClaw 내장 스킬 검토

- [ ] OpenClaw 내장 스킬 목록 파악
- [ ] pi-skills와 겹치는 것 / 더 나은 것 비교
- [ ] 유망한 스킬 pi-skills로 가져오기
