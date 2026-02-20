# pi-skills TODO

## gogcli 전환 (gccli/gdcli/gmcli → gog)

- [ ] Google Cloud Console에서 **Desktop app** OAuth 클라이언트 생성
  - 회사: [n8n-goqual](https://console.cloud.google.com/auth/clients?project=n8n-goqual)
  - 개인: [emacs-361304](https://console.cloud.google.com/auth/clients?project=emacs-361304)
- [ ] 크레덴셜 등록: `gog auth credentials set <json> --client work/personal`
- [ ] 계정 인증: `gog auth add <email> --client <name> --services all --manual`
- [ ] 동작 확인 후 gogcli SKILL.md 작성
- [ ] gccli/gdcli/gmcli → deprecated 처리 또는 제거

## OpenClaw 내장 스킬 검토

- [ ] OpenClaw 내장 스킬 목록 파악
- [ ] pi-skills와 겹치는 것 / 더 나은 것 비교
- [ ] 유망한 스킬 pi-skills로 가져오기
