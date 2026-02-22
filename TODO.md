# pi-skills TODO

## gogcli 전환 (gccli/gdcli/gmcli → gog)

- [x] Google Cloud Console에서 **Desktop app** OAuth 클라이언트 생성
- [x] 크레덴셜 등록: `gog auth credentials set <json> --client work/personal`
- [x] 개인 계정 인증: junghanacs@gmail.com (services: all)
- [x] 회사 계정 인증: jhkim2@goqual.com (services: calendar,gmail,drive,tasks,chat)
- [x] gogcli SKILL.md 작성
- [x] gccli/gdcli/gmcli → _deprecated/ 이동
- [ ] 회사 계정 OAuth 동의 화면 정리 (n8n-goqual, classroom 등 불필요 scope 제거)

## OracleVM gogcli 배포

- [ ] ssh oracle 접속하여 gog 바이너리 설치 (`go install github.com/steipete/gogcli/cmd/gog@latest`)
- [ ] gogcli 크레덴셜 전송 (`~/.config/gogcli/` 디렉토리)
- [ ] OracleVM에서 계정 인증 (--remote 2-step)
- [ ] OpenClaw 봇에게 gogcli 스킬 전달

## Samsung Health 봇 연동

- [ ] [samsung-health 스킬](https://clawhub.ai/mudgesbot/samsung-health) 검토
- [ ] 봇에게 건강 데이터 컨텍스트 제공 (존재 대 존재 협력)
- [ ] pi-skills로 가져올지 / OpenClaw 내장으로 쓸지 판단

## OpenClaw 내장 스킬 검토

- [ ] OpenClaw 내장 스킬 목록 파악
- [ ] pi-skills와 겹치는 것 / 더 나은 것 비교
- [ ] 유망한 스킬 pi-skills로 가져오기
