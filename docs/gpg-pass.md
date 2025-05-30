
#### 1 gpg(Ed25519) generate

```bash
gpg --full-generate-key
```

그 후 Ed25519 (ECC) 선택 후 계속 진행


#### 2 search gpg keys

```bash
gpg --list-key
```


#### 3 pass init

```bash
pass init "Your Name (Comment)" # gpg --list-key에서 출력된 uid 영역
```



#### 4 암호 생성

```bash
pass insert email/test@test.com # 그 후 비밀번호 입력
```



---
