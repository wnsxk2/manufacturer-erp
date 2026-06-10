# manufacturer_erp

제조사 ERP 데이터베이스 — PostgreSQL DDL, DML, 프로시저 저장소.

## 요구 사항

- [PostgreSQL 17](https://www.postgresql.org/)
- [uv](https://docs.astral.sh/uv/) — Python 패키지 관리자

## 온보딩

### 1. 의존성 설치

```sh
uv sync
```

### 2. git hook 등록

```sh
uv run pre-commit install --hook-type pre-commit --hook-type commit-msg
```

이후 커밋 시 아래 두 가지가 자동 실행됩니다.

| 단계         | 도구                    | 역할                                |
| ------------ | ----------------------- | ----------------------------------- |
| `pre-commit` | sqlfluff                | `db/**/*.sql` 포맷 자동 수정 + 린트 |
| `commit-msg` | conventional-pre-commit | 커밋 메시지 규칙 검증               |

## 커밋 메시지 규칙

[Conventional Commits](https://www.conventionalcommits.org/) 형식을 따릅니다.

```
<type>: <한국어 설명>
```

자주 쓰는 type.

| type    | 용도                            |
| ------- | ------------------------------- |
| `feat`  | 새 프로시저·테이블 추가         |
| `fix`   | 버그 수정                       |
| `style` | 포맷·린트 정렬 (기능 변경 없음) |
| `chore` | 빌드·설정 변경                  |
| `docs`  | 문서 수정                       |

## 참고 문서

- [docs/CONVENTION.md](./docs/CONVENTION.md) — SQL 작성 컨벤션 (프로시저 네이밍, 포맷 규칙 등)
