# Claude Code Configuration Examples / Claude Code 설정 예제

[English](#english) | [한국어](#한국어)

---

## English

This directory contains comprehensive examples of Claude Code configurations for different project types and use cases.

## Directory Structure

```
claude-code-examples/
├── basic-project/               # Simple web application setup
│   └── .claude/
│       ├── settings.json        # Basic configuration
│       └── hooks/
│           └── format-and-lint.sh
├── advanced-project/            # Complex fullstack project
│   └── .claude/
│       ├── settings.json        # Advanced config with subagents
│       └── hooks/
│           └── comprehensive-check.sh
├── microservices-project/       # Distributed systems setup
│   └── .claude/
│       ├── settings.json        # Microservices-specific config
│       └── hooks/
│           ├── microservice-validation.sh
│           └── pre-commit-checks.sh
├── enterprise-security-project/ # High-security enterprise environment
│   └── .claude/
│       ├── settings.json        # Security-focused configuration
│       └── hooks/
│           └── security-prompt-filter.py
├── ai-research-project/         # ML/AI research environment
│   └── .claude/
│       ├── settings.json        # Research-focused config with MCP
│       └── hooks/
│           └── experiment-tracking.py
├── startup-mvp-project/         # Rapid MVP development
│   └── .claude/
│       ├── settings.json        # MVP-focused configuration
│       └── hooks/
│           └── rapid-feedback.sh
└── open-source-project/         # OSS project management
    └── .claude/
        ├── settings.json        # Community-focused configuration
        ├── commands/
        │   └── create-issue-template.md
        └── hooks/
            └── contribution-standards.sh
```

## Example Configurations

### 1. Basic Project (`basic-project/`)
- **Use Case**: Simple web applications, small teams
- **Features**: 
  - Basic permissions and hooks
  - Automatic formatting and linting
  - Simple error checking
- **Languages**: JavaScript/TypeScript, Python, Rust
- **Hook Scripts**: format-and-lint.sh

### 2. Advanced Project (`advanced-project/`)
- **Use Case**: Complex fullstack applications, larger teams
- **Features**:
  - Specialized subagents (backend, frontend, devops)
  - Comprehensive pre/post-tool hooks
  - Multi-language support with extensive validation
  - Security audits and type checking
- **Languages**: All major languages with advanced tooling
- **Hook Scripts**: comprehensive-check.sh

### 3. Microservices Project (`microservices-project/`)
- **Use Case**: Distributed systems, container orchestration
- **Features**:
  - Microservices-specific agents
  - Kubernetes and Docker validation
  - Service mesh and API gateway configuration
  - Comprehensive container and security checks
- **Technologies**: Docker, Kubernetes, service mesh
- **Hook Scripts**: microservice-validation.sh, pre-commit-checks.sh

### 4. Enterprise Security Project (`enterprise-security-project/`)
- **Use Case**: High-security enterprise environments, compliance-focused development
- **Features**:
  - Restricted permissions with security-first approach
  - Advanced prompt filtering and validation
  - Comprehensive audit logging
  - Compliance checking and risk assessment
- **Security Focus**: Defensive security, vulnerability analysis, compliance validation
- **Hook Scripts**: security-prompt-filter.py, compliance-check.py, audit-logging.py

### 5. AI Research Project (`ai-research-project/`)
- **Use Case**: Machine learning research, data science, academic environments
- **Features**:
  - ML-focused agents (researcher, data scientist, research engineer)
  - Experiment tracking and reproducibility
  - MCP integration with research tools (arXiv, W&B, HuggingFace)
  - GPU monitoring and compute resource management
- **Research Tools**: MLflow, W&B, arXiv, Kaggle, HuggingFace
- **Hook Scripts**: experiment-tracking.py, context-enhancement.py, compute-monitoring.py

### 6. Startup MVP Project (`startup-mvp-project/`)
- **Use Case**: Rapid prototyping, startup development, fast iteration
- **Features**:
  - Product-focused agents (PM, fullstack dev, growth engineer)
  - Rapid feedback and deployment readiness checks
  - Modern startup stack integration (Vercel, Supabase, PostHog)
  - Performance and conversion optimization
- **Startup Stack**: Vercel, Supabase, PostHog, Stripe
- **Hook Scripts**: rapid-feedback.sh, deployment-ready-check.sh, mvp-validation.sh

### 7. Open Source Project (`open-source-project/`)
- **Use Case**: OSS maintenance, community management, public repositories
- **Features**:
  - Community-focused agents (maintainer, docs specialist, community manager)
  - OSS standards validation and contribution workflows
  - License compliance and security scanning
  - GitHub integration and automated workflows
- **Community Tools**: GitHub Actions, semantic-release, license-checker
- **Hook Scripts**: contribution-standards.sh, license-check.py, ci-cd-validation.sh
- **Custom Commands**: create-issue-template.md

## Hook Scripts Explained

### format-and-lint.sh (Basic)
- Detects project type (Node.js, Python, Rust)
- Runs appropriate formatters (Prettier, ruff, rustfmt)
- Applies linting fixes (ESLint, ruff, clippy)

### comprehensive-check.sh (Advanced)  
- Multi-language type checking and testing
- Security audits
- Performance validation
- Docker build verification
- Complete CI/CD pipeline simulation

### microservice-validation.sh (Microservices)
- Dockerfile and Kubernetes manifest validation
- Service discovery and API gateway checks
- Health check endpoint verification
- Observability configuration validation
- Security and resource limit checks

### security-prompt-filter.py (Enterprise Security)
- Advanced prompt validation for security risks
- Credential exposure detection
- SQL/shell injection prevention
- Compliance violation checking
- Comprehensive audit logging

### experiment-tracking.py (AI Research)
- Automatic experiment metadata tracking
- Git commit and environment capture
- ML framework detection and integration
- File hashing for reproducibility
- W&B and MLflow integration

### rapid-feedback.sh (Startup MVP)
- Fast build and deployment validation
- Bundle size optimization checks
- Essential file verification
- Environment configuration validation
- MVP readiness scoring

### contribution-standards.sh (Open Source)
- OSS project health assessment
- Essential file validation (README, LICENSE, etc.)
- Package.json completeness checking
- CI/CD workflow validation
- Community template verification

## Usage

1. **Copy Configuration**: Copy the appropriate example to your project
2. **Customize Settings**: Modify settings.json for your specific needs
3. **Update Hooks**: Adapt hook scripts to your project requirements
4. **Set Permissions**: Make hook scripts executable with `chmod +x`

## Configuration Hierarchy

Settings are applied in this order of precedence:
1. Enterprise/Organization policies
2. User settings (`~/.claude/settings.json`)
3. Project settings (`.claude/settings.json`)
4. Local overrides (`.claude/settings.local.json`)

## Best Practices

1. **Start Simple**: Begin with basic-project configuration
2. **Iterate Gradually**: Add complexity as your project grows
3. **Test Hooks**: Verify hook scripts work in your environment
4. **Document Changes**: Keep README updated with configuration changes
5. **Security First**: Never commit sensitive information in settings files
6. **Version Control**: Commit .claude/settings.json, ignore settings.local.json

## Further Reading

See `CLAUDE_CODE_COMPLETE_GUIDE.md` in the parent directory for comprehensive documentation on Claude Code usage patterns, advanced features, and integration strategies.

---

## 한국어

이 디렉토리는 다양한 프로젝트 유형과 사용 사례를 위한 Claude Code 설정의 포괄적인 예제를 포함합니다.

## 디렉토리 구조

```
claude-code-examples/
├── basic-project/               # 간단한 웹 애플리케이션 설정
│   └── .claude/
│       ├── settings.json        # 기본 설정
│       └── hooks/
│           └── format-and-lint.sh
├── advanced-project/            # 복잡한 풀스택 프로젝트
│   └── .claude/
│       ├── settings.json        # 서브에이전트가 있는 고급 설정
│       └── hooks/
│           └── comprehensive-check.sh
├── microservices-project/       # 분산 시스템 설정
│   └── .claude/
│       ├── settings.json        # 마이크로서비스 전용 설정
│       └── hooks/
│           ├── microservice-validation.sh
│           └── pre-commit-checks.sh
├── enterprise-security-project/ # 고보안 기업 환경
│   └── .claude/
│       ├── settings.json        # 보안 중점 설정
│       └── hooks/
│           └── security-prompt-filter.py
├── ai-research-project/         # ML/AI 연구 환경
│   └── .claude/
│       ├── settings.json        # MCP가 포함된 연구 중점 설정
│       └── hooks/
│           └── experiment-tracking.py
├── startup-mvp-project/         # 빠른 MVP 개발
│   └── .claude/
│       ├── settings.json        # MVP 중점 설정
│       └── hooks/
│           └── rapid-feedback.sh
└── open-source-project/         # OSS 프로젝트 관리
    └── .claude/
        ├── settings.json        # 커뮤니티 중점 설정
        ├── commands/
        │   └── create-issue-template.md
        └── hooks/
            └── contribution-standards.sh
```

## 예제 설정들

### 1. 기본 프로젝트 (`basic-project/`)
- **사용 사례**: 간단한 웹 애플리케이션, 소규모 팀
- **기능**: 
  - 기본 권한 및 훅
  - 자동 포맷팅 및 린팅
  - 간단한 오류 검사
- **언어**: JavaScript/TypeScript, Python, Rust
- **훅 스크립트**: format-and-lint.sh

### 2. 고급 프로젝트 (`advanced-project/`)
- **사용 사례**: 복잡한 풀스택 애플리케이션, 대규모 팀
- **기능**:
  - 전문화된 서브에이전트 (백엔드, 프론트엔드, 데브옵스)
  - 포괄적인 사전/사후 도구 훅
  - 광범위한 검증이 포함된 다중 언어 지원
  - 보안 감사 및 타입 검사
- **언어**: 고급 도구가 포함된 모든 주요 언어
- **훅 스크립트**: comprehensive-check.sh

### 3. 마이크로서비스 프로젝트 (`microservices-project/`)
- **사용 사례**: 분산 시스템, 컨테이너 오케스트레이션
- **기능**:
  - 마이크로서비스 전용 에이전트
  - Kubernetes 및 Docker 검증
  - 서비스 메시 및 API 게이트웨이 설정
  - 포괄적인 컨테이너 및 보안 검사
- **기술**: Docker, Kubernetes, 서비스 메시
- **훅 스크립트**: microservice-validation.sh, pre-commit-checks.sh

### 4. 기업 보안 프로젝트 (`enterprise-security-project/`)
- **사용 사례**: 고보안 기업 환경, 컴플라이언스 중심 개발
- **기능**:
  - 보안 우선 접근법으로 제한된 권한
  - 고급 프롬프트 필터링 및 검증
  - 포괄적인 감사 로깅
  - 컴플라이언스 확인 및 위험 평가
- **보안 중점**: 방어적 보안, 취약성 분석, 컴플라이언스 검증
- **훅 스크립트**: security-prompt-filter.py, compliance-check.py, audit-logging.py

### 5. AI 연구 프로젝트 (`ai-research-project/`)
- **사용 사례**: 머신러닝 연구, 데이터 사이언스, 학술 환경
- **기능**:
  - ML 중점 에이전트 (연구자, 데이터 사이언티스트, 연구 엔지니어)
  - 실험 추적 및 재현성
  - 연구 도구와의 MCP 통합 (arXiv, W&B, HuggingFace)
  - GPU 모니터링 및 컴퓨팅 리소스 관리
- **연구 도구**: MLflow, W&B, arXiv, Kaggle, HuggingFace
- **훅 스크립트**: experiment-tracking.py, context-enhancement.py, compute-monitoring.py

### 6. 스타트업 MVP 프로젝트 (`startup-mvp-project/`)
- **사용 사례**: 빠른 프로토타이핑, 스타트업 개발, 빠른 반복
- **기능**:
  - 제품 중심 에이전트 (PM, 풀스택 개발자, 성장 엔지니어)
  - 빠른 피드백 및 배포 준비 상태 검사
  - 모던 스타트업 스택 통합 (Vercel, Supabase, PostHog)
  - 성능 및 전환 최적화
- **스타트업 스택**: Vercel, Supabase, PostHog, Stripe
- **훅 스크립트**: rapid-feedback.sh, deployment-ready-check.sh, mvp-validation.sh

### 7. 오픈소스 프로젝트 (`open-source-project/`)
- **사용 사례**: OSS 유지보수, 커뮤니티 관리, 공개 저장소
- **기능**:
  - 커뮤니티 중심 에이전트 (유지보수자, 문서 전문가, 커뮤니티 매니저)
  - OSS 표준 검증 및 기여 워크플로우
  - 라이선스 컴플라이언스 및 보안 스캐닝
  - GitHub 통합 및 자동화된 워크플로우
- **커뮤니티 도구**: GitHub Actions, semantic-release, license-checker
- **훅 스크립트**: contribution-standards.sh, license-check.py, ci-cd-validation.sh
- **커스텀 명령어**: create-issue-template.md

## 훅 스크립트 설명

### format-and-lint.sh (기본)
- 프로젝트 유형 감지 (Node.js, Python, Rust)
- 적절한 포맷터 실행 (Prettier, ruff, rustfmt)
- 린팅 수정 적용 (ESLint, ruff, clippy)

### comprehensive-check.sh (고급)  
- 다중 언어 타입 검사 및 테스팅
- 보안 감사
- 성능 검증
- Docker 빌드 확인
- 완전한 CI/CD 파이프라인 시뮬레이션

### microservice-validation.sh (마이크로서비스)
- Dockerfile 및 Kubernetes 매니페스트 검증
- 서비스 디스커버리 및 API 게이트웨이 검사
- 헬스 체크 엔드포인트 확인
- 관찰성 설정 검증
- 보안 및 리소스 제한 검사

### security-prompt-filter.py (기업 보안)
- 보안 위험에 대한 고급 프롬프트 검증
- 자격 증명 노출 감지
- SQL/셸 인젝션 방지
- 컴플라이언스 위반 검사
- 포괄적인 감사 로깅

### experiment-tracking.py (AI 연구)
- 자동 실험 메타데이터 추적
- Git 커밋 및 환경 캡처
- ML 프레임워크 감지 및 통합
- 재현성을 위한 파일 해싱
- W&B 및 MLflow 통합

### rapid-feedback.sh (스타트업 MVP)
- 빠른 빌드 및 배포 검증
- 번들 크기 최적화 검사
- 필수 파일 확인
- 환경 설정 검증
- MVP 준비 상태 점수 매기기

### contribution-standards.sh (오픈소스)
- OSS 프로젝트 건강도 평가
- 필수 파일 검증 (README, LICENSE 등)
- Package.json 완성도 검사
- CI/CD 워크플로우 검증
- 커뮤니티 템플릿 확인

## 사용법

1. **설정 복사**: 적절한 예제를 프로젝트에 복사
2. **설정 커스터마이징**: 특정 요구사항에 맞게 settings.json 수정
3. **훅 업데이트**: 프로젝트 요구사항에 맞게 훅 스크립트 조정
4. **권한 설정**: `chmod +x`로 훅 스크립트를 실행 가능하게 만들기

## 설정 계층 구조

설정은 다음 우선순위로 적용됩니다:
1. 기업/조직 정책
2. 사용자 설정 (`~/.claude/settings.json`)
3. 프로젝트 설정 (`.claude/settings.json`)
4. 로컬 재정의 (`.claude/settings.local.json`)

## 모범 사례

1. **간단하게 시작**: basic-project 설정으로 시작
2. **점진적 반복**: 프로젝트가 성장함에 따라 복잡성 추가
3. **훅 테스트**: 환경에서 훅 스크립트가 작동하는지 확인
4. **변경사항 문서화**: 설정 변경사항으로 README 업데이트 유지
5. **보안 우선**: 설정 파일에 민감한 정보 커밋 금지
6. **버전 제어**: .claude/settings.json 커밋, settings.local.json 무시

## 추가 읽기

Claude Code 사용 패턴, 고급 기능, 통합 전략에 대한 포괄적인 문서는 상위 디렉토리의 `CLAUDE_CODE_완전가이드.md`를 참조하세요.