# Claude Code 완전 사용 가이드

## 개요

Claude Code는 개발자 워크플로우에 직접 통합되는 터미널 기반 AI 코딩 어시스턴트입니다. 이 가이드는 연구와 실제 사례를 바탕으로 한 포괄적인 사용 패턴, 폴더 구조, 고급 설정을 다룹니다.

## 목차

1. [설치 및 설정](#설치-및-설정)
2. [폴더 구조 패턴](#폴더-구조-패턴)  
3. [설정 예제](#설정-예제)
4. [고급 기능](#고급-기능)
5. [모범 사례](#모범-사례)
6. [실제 예제](#실제-예제)

## 설치 및 설정

### 빠른 설치
```bash
# Claude Code 전역 설치
npm install -g @anthropic-ai/claude-code

# 프로젝트에서 초기화
claude-code init
```

### 필수 조건
- Node.js 18+
- Git 저장소 (권장)
- Anthropic, AWS Bedrock, 또는 Google Vertex AI의 API 키

## 폴더 구조 패턴

### 기본 프로젝트 구조
최소한의 Claude Code 설정은 프로젝트 루트에 `.claude` 폴더가 필요합니다:

```
project-root/
├── .claude/
│   ├── settings.json          # 메인 설정
│   ├── settings.local.json    # 개인 재정의 (gitignore)
│   └── hooks/                 # 커스텀 자동화 스크립트
│       ├── format-and-lint.sh
│       └── pre-commit-check.sh
├── src/
├── tests/
└── README.md
```

### 고급 프로젝트 구조  
여러 환경과 전문화된 에이전트가 있는 복잡한 프로젝트의 경우:

```
enterprise-project/
├── .claude/
│   ├── settings.json          # 팀 공유 설정
│   ├── settings.local.json    # 개인 개발 설정
│   ├── settings.prod.json     # 프로덕션 전용 설정
│   ├── agents/                # 커스텀 에이전트 정의
│   │   ├── backend-architect.md
│   │   ├── frontend-specialist.md
│   │   └── devops-engineer.md
│   ├── hooks/                 # 자동화 스크립트
│   │   ├── pre-commit-checks.sh
│   │   ├── comprehensive-check.sh
│   │   └── deployment-validation.sh
│   └── mcp/                   # MCP 서버 설정
│       ├── github.json
│       ├── monitoring.json
│       └── database.json
├── services/                  # 마이크로서비스용
│   ├── auth-service/
│   ├── user-service/
│   └── notification-service/
├── frontend/
├── infrastructure/
│   ├── kubernetes/
│   ├── terraform/
│   └── docker/
└── docs/
```

### 마이크로서비스 아키텍처 구조
여러 서비스가 있는 분산 시스템의 경우:

```
microservices-project/
├── .claude/
│   ├── settings.json          # 글로벌 마이크로서비스 설정
│   ├── agents/
│   │   ├── microservice-architect.md
│   │   ├── kubernetes-specialist.md
│   │   └── api-gateway-engineer.md
│   └── hooks/
│       ├── microservice-validation.sh
│       └── container-security-check.sh
├── services/
│   ├── auth-service/
│   │   ├── .claude/settings.json    # 서비스별 설정
│   │   ├── Dockerfile
│   │   ├── k8s/
│   │   └── src/
│   ├── user-service/
│   └── payment-service/
├── api-gateway/
├── monitoring/
│   ├── prometheus/
│   ├── grafana/
│   └── jaeger/
└── k8s/                       # 공유 Kubernetes 매니페스트
    ├── namespaces/
    ├── ingress/
    └── monitoring/
```

## 설정 예제

### 1. 기본 설정 (`settings.json`)

```json
{
  "permissions": {
    "allow": [
      "Bash",
      "Read", 
      "Write",
      "Edit",
      "Glob",
      "Grep"
    ]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "echo '🔍 사전 검사: 수정 전 검증 중...'",
            "timeout": 5
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/format-and-lint.sh", 
            "timeout": 30
          }
        ]
      }
    ]
  },
  "model": "claude-3-5-sonnet-20241022",
  "environment": {
    "NODE_ENV": "development",
    "PROJECT_TYPE": "fullstack"
  }
}
```

### 2. 에이전트가 있는 고급 설정

```json
{
  "permissions": {
    "allow": [
      "Bash", "Read", "Write", "Edit", "MultiEdit", 
      "Glob", "Grep", "WebFetch", "Task"
    ]
  },
  "subagents": {
    "backend-architect": {
      "name": "백엔드 아키텍트",
      "description": "백엔드 아키텍처, API 설계, 데이터베이스 최적화 전문가",
      "model": "claude-3-5-sonnet-20241022",
      "instructions": "확장 가능한 시스템 설계, API 아키텍처, 데이터베이스 최적화, 성능에 중점을 둡니다. 항상 보안, 유지보수성, 확장성을 고려하세요."
    },
    "frontend-specialist": {
      "name": "프론트엔드 전문가",
      "description": "React, TypeScript, UI/UX를 활용한 모던 프론트엔드 개발 전문가", 
      "model": "claude-3-5-sonnet-20241022",
      "instructions": "모던 React 패턴, TypeScript 모범 사례, 반응형 디자인, 접근성, 성능 최적화에 중점을 둡니다."
    }
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'if [ -f \"Makefile\" ] && make -n check >/dev/null 2>&1 && ! make check >/dev/null 2>&1; then echo \"❌ 파일 수정 불가: make check가 실패 중입니다.\" >&2; exit 2; fi'",
            "timeout": 10
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/comprehensive-check.sh",
            "timeout": 60
          }
        ]
      }
    ]
  },
  "model": "claude-3-5-sonnet-20241022",
  "environment": {
    "NODE_ENV": "development",
    "PYTHON_ENV": "development",
    "PROJECT_TYPE": "fullstack",
    "ENABLE_DEBUG": "true"
  },
  "tools": {
    "disabled": [],
    "custom": {
      "project-stats": {
        "command": "find . -name '*.ts' -o -name '*.js' -o -name '*.py' | wc -l",
        "description": "프로젝트의 총 코드 파일 수 계산"
      }
    }
  }
}
```

### 3. 마이크로서비스 설정

```json
{
  "permissions": {
    "allow": ["Bash", "Read", "Write", "Edit", "MultiEdit", "Glob", "Grep", "WebFetch", "Task"]
  },
  "agents": [
    {
      "name": "microservice-architect",
      "description": "마이크로서비스 아키텍처, 서비스 메시, API 게이트웨이 설계, 분산 시스템 패턴 전문가",
      "instructions": "분산 시스템을 전문으로 합니다. 서비스 분해, 서비스 간 통신, 데이터 일관성 패턴, 서킷 브레이커, 관찰성에 중점을 둡니다.",
      "model": "claude-3-5-sonnet-20241022"
    },
    {
      "name": "kubernetes-specialist",
      "description": "Kubernetes, 컨테이너 오케스트레이션, 서비스 메시, 클라우드 네이티브 배포 패턴 전문가", 
      "instructions": "컨테이너 오케스트레이션, 서비스 디스커버리, 로드 밸런싱, 자동 스케일링, 모니터링, 클라우드 네이티브 배포 전략에 중점을 둡니다.",
      "model": "claude-3-5-sonnet-20241022"
    }
  ],
  "mcp": {
    "servers": {
      "kubernetes": {
        "command": "kubectl-mcp-server",
        "args": ["--kubeconfig", "~/.kube/config"]
      },
      "docker-compose": {
        "command": "docker-compose-mcp-server",
        "args": ["--file", "docker-compose.yml"]
      }
    }
  }
}
```

## 고급 기능

### 1. 모델 컨텍스트 프로토콜 (MCP) 통합

Claude Code는 외부 도구 및 데이터 소스와의 통합을 위한 MCP를 지원합니다:

```json
{
  "mcp": {
    "servers": {
      "github": {
        "command": "mcp-server-github",
        "args": ["--auth-token", "${GITHUB_TOKEN}"]
      },
      "sentry": {
        "command": "mcp-server-sentry", 
        "args": ["--org", "my-org", "--auth-token", "${SENTRY_TOKEN}"]
      },
      "database": {
        "command": "mcp-server-postgres",
        "args": ["--connection-string", "${DATABASE_URL}"]
      }
    }
  }
}
```

### 2. 커스텀 훅 시스템

훅은 도구 사용의 다양한 단계에서 자동화를 허용합니다:

**사전 도구 사용 훅**: Claude Code가 도구를 실행하기 전에 실행
- 코드 품질 검증
- 보안 검사
- 환경 확인

**사후 도구 사용 훅**: Claude Code가 도구를 실행한 후에 실행  
- 자동 포맷팅
- 테스팅
- 빌드 검증
- 배포 검사

### 3. 전문화된 에이전트

에이전트는 특정 작업에 최적화된 Claude의 전문화된 인스턴스입니다:

```markdown
---
name: backend-typescript-architect
description: Bun 런타임을 사용한 TypeScript 백엔드 개발 전문가
color: red
---

당신은 다음 분야의 깊은 전문 지식을 갖춘 시니어 백엔드 TypeScript 아키텍트입니다:
- 백엔드 시스템을 위한 고급 TypeScript 패턴 및 모범 사례
- Bun 런타임 최적화 및 생태계 숙련도  
- RESTful API 설계 및 GraphQL 구현
- 데이터베이스 설계, 최적화 및 ORM 사용
- 마이크로서비스 아키텍처 및 분산 시스템

개발 철학:
- 전략적 주석으로 자체 문서화 코드 작성
- 타입 안전성을 우선시하고 TypeScript의 고급 기능 활용
- 처음부터 유지보수성, 확장성, 성능을 위한 설계
- SOLID 원칙 및 클린 아키텍처 패턴 준수
```

### 4. 환경 관리

Claude Code는 계층적 구성을 지원합니다:

1. **기업/조직 수준**: 글로벌 정책
2. **사용자 수준** (`~/.claude/settings.json`): 개인 설정
3. **프로젝트 수준** (`.claude/settings.json`): 팀 공유 설정
4. **로컬 수준** (`.claude/settings.local.json`): 개인 프로젝트 재정의

## 모범 사례

### 1. 보안 모범 사례

```json
{
  "permissions": {
    "allow": ["Read", "Glob", "Grep"],
    "deny": ["Bash", "Write", "Edit"]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/security-scan.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### 2. 개발 워크플로우 통합

**TDD 워크플로우 예제**:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command", 
            "command": "bash -c 'if ! make test >/dev/null 2>&1; then echo \"❌ 테스트 실패 - 코드 수정 전 수정하세요\" >&2; exit 1; fi'",
            "timeout": 30
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "make test && make format && make lint",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

### 3. 다중 언어 프로젝트 지원

```bash
#!/bin/bash
# .claude/hooks/comprehensive-check.sh

# Node.js/TypeScript
if [ -f "package.json" ]; then
    npm run type-check
    npm run lint
    npm run test
fi

# Python  
if [ -f "pyproject.toml" ]; then
    uv run ruff format .
    uv run ruff check .
    uv run mypy .
    uv run pytest
fi

# Rust
if [ -f "Cargo.toml" ]; then
    cargo fmt
    cargo clippy
    cargo test
fi

# Go
if [ -f "go.mod" ]; then
    go fmt ./...
    go vet ./...
    go test ./...
fi
```

## 실제 예제

### 예제 1: 기본 웹 애플리케이션 설정

```bash
# 프로젝트 초기화
mkdir my-web-app && cd my-web-app
git init

# 기본 Claude Code 설정 생성
mkdir -p .claude/hooks

# 기본 설정
cat > .claude/settings.json << 'EOF'
{
  "permissions": {
    "allow": ["Bash", "Read", "Write", "Edit", "Glob", "Grep"]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/format-and-lint.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
EOF

# 포맷 훅 생성
cat > .claude/hooks/format-and-lint.sh << 'EOF'
#!/bin/bash
if [ -f "package.json" ]; then
    npm run format 2>/dev/null || true
    npm run lint -- --fix 2>/dev/null || true
fi
EOF

chmod +x .claude/hooks/format-and-lint.sh
```

### 예제 2: 마이크로서비스 프로젝트 설정

```bash
# 마이크로서비스 프로젝트 초기화
mkdir microservices-app && cd microservices-app
git init

# 고급 설정 생성
mkdir -p .claude/{hooks,agents}

# 마이크로서비스 에이전트가 있는 고급 설정
cat > .claude/settings.json << 'EOF'
{
  "permissions": {
    "allow": ["Bash", "Read", "Write", "Edit", "MultiEdit", "Glob", "Grep", "WebFetch", "Task"]
  },
  "agents": [
    {
      "name": "microservice-architect",
      "description": "마이크로서비스 아키텍처 및 분산 시스템 전문가",
      "model": "claude-3-5-sonnet-20241022"
    }
  ],
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/microservice-validation.sh",
            "timeout": 120
          }
        ]
      }
    ]
  }
}
EOF

# 프로젝트 구조 생성
mkdir -p {services/{auth,user,payment},api-gateway,monitoring,k8s}
```

### 예제 3: TDD를 사용한 Python/FastAPI 프로젝트

```bash
# uv를 사용한 Python 프로젝트 초기화
mkdir fastapi-project && cd fastapi-project
git init

# TDD 워크플로우를 위한 Claude Code 설정 생성
mkdir -p .claude/hooks

cat > .claude/settings.json << 'EOF'
{
  "permissions": {
    "allow": ["Bash", "Read", "Write", "Edit", "Glob", "Grep"]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'if [ -f \"Makefile\" ] && ! make check >/dev/null 2>&1; then echo \"❌ 실패한 검사를 먼저 수정하세요\" >&2; exit 1; fi'",
            "timeout": 10
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "make format && make check && make test",
            "timeout": 60
          }
        ]
      }
    ]
  },
  "environment": {
    "PYTHON_ENV": "development"
  }
}
EOF

# uv 프로젝트 초기화
uv init
uv add fastapi uvicorn pytest ruff mypy

# TDD 워크플로우를 위한 Makefile 생성
cat > Makefile << 'EOF'
.PHONY: format check test run

format:
	uv run ruff format .

check:
	uv run ruff check .
	uv run mypy .

test:
	uv run pytest -v

run:
	uv run uvicorn app.main:app --reload
EOF
```

## 요약

Claude Code는 다음을 통해 강력한 커스터마이제이션을 제공합니다:

1. **계층적 구성**: 기업 → 사용자 → 프로젝트 → 로컬 설정
2. **커스텀 훅**: 사전/사후 도구 실행 시 자동화
3. **전문화된 에이전트**: 도메인별 AI 어시스턴트  
4. **MCP 통합**: 외부 도구 및 데이터 소스 연결
5. **다중 언어 지원**: 기술 스택 전반의 통합 워크플로우

효과적인 Claude Code 사용의 핵심은:
- 기본 설정으로 시작하여 반복 개선
- 자동화 및 품질 게이트를 위한 훅 사용
- 전문화된 작업을 위한 에이전트 활용
- 기존 개발 워크플로우와 통합
- 전반적으로 보안 및 모범 사례 유지

이러한 포괄적인 설정을 통해 팀은 코드 품질을 유지하고, 반복 작업을 자동화하며, 복잡한 다중 서비스 아키텍처 전반에서 AI 지원을 효과적으로 활용할 수 있습니다.