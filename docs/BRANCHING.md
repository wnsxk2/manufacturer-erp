# 브랜치 전략 및 PR 흐름

## 1. 브랜치 모델

`main`은 항상 배포 가능한 상태를 유지하는 보호 브랜치다. 모든 변경은 작업 브랜치에서 PR을 통해 병합한다.

### 1-1. 브랜치 네이밍

```
<type>/<kebab-case-설명>
```

`<type>`은 [Conventional Commits](https://www.conventionalcommits.org/) type과 동일하다.

| type    | 용도                            | 예시                             |
| ------- | ------------------------------- | -------------------------------- |
| `feat`  | 새 프로시저·테이블 추가         | `feat/order-place-procedure`     |
| `fix`   | 버그 수정                       | `fix/inventory-stock-underflow`  |
| `style` | 포맷·린트 정렬 (기능 변경 없음) | `style/ddl-leading-comma`        |
| `chore` | 빌드·설정 변경                  | `chore/update-sqlfluff-version`  |
| `docs`  | 문서 수정                       | `docs/convention-update`         |

---

## 2. 작업 흐름

```
main에서 브랜치 생성
    → 커밋 (로컬 pre-commit hook 통과)
    → GitHub에 push
    → PR 생성 (PR 템플릿 작성)
    → 리뷰 & 대화 해결
    → Squash merge → main
    → 작업 브랜치 삭제
```

### 2-1. 브랜치 생성

항상 최신 `main`에서 분기한다.

```sh
git switch main
git pull origin main
git switch -c feat/my-new-procedure
```

### 2-2. 커밋

로컬에서 pre-commit hook이 자동 실행된다.

| 단계         | 도구                    | 역할                                |
| ------------ | ----------------------- | ----------------------------------- |
| `pre-commit` | sqlfluff                | `db/**/*.sql` 포맷 자동 수정 + 린트 |
| `commit-msg` | conventional-pre-commit | 커밋 메시지 규칙 검증               |

hook이 설치되지 않은 경우 `uv run pre-commit install --hook-type pre-commit --hook-type commit-msg`로 등록한다.

### 2-3. PR 생성

GitHub에서 PR을 열면 `.github/PULL_REQUEST_TEMPLATE.md`가 자동으로 채워진다. 체크리스트를 모두 확인한 뒤 제출한다.

---

## 3. 병합 정책

| 항목         | 규칙                                                              |
| ------------ | ----------------------------------------------------------------- |
| 병합 방식    | **Squash merge** — 작업 브랜치의 커밋을 하나로 합쳐 `main`에 추가 |
| PR 제목      | Conventional Commits 형식 (`feat: 주문 생성 프로시저 추가`)       |
| 최소 승인 수 | 1인 이상 Approve                                                  |
| 대화 해결    | 모든 conversation이 Resolved 상태여야 병합 가능                   |
| 브랜치 삭제  | 병합 후 작업 브랜치 삭제 (GitHub에서 자동 삭제 설정 가능)         |

> Squash merge를 사용하면 `main` 히스토리가 PR 단위로 정리되어 `git log`가 깔끔하게 유지된다.

---

## 4. 브랜치 보호 규칙

GitHub 레포 설정에서 아래 규칙을 적용한다. 자세한 설정 방법은 [docs/GITHUB_SETUP.md](./GITHUB_SETUP.md)를 참고한다.

| 규칙                         | 설정값              |
| ---------------------------- | ------------------- |
| `main` 직접 push 금지        | 활성화              |
| 병합 전 PR 승인               | 최소 1건            |
| 대화(conversation) 해결 필수 | 활성화              |
| force push 금지              | 활성화              |
