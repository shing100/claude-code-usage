# Claude Code Usage Examples / Claude Code 사용 예제

[English](#english) | [한국어](#한국어)

---

## English

This repository contains comprehensive Claude Code configuration examples and documentation for various project types and development scenarios.

### 📁 Repository Structure

- **CLAUDE.md**: Repository-specific guidance for Claude Code instances
- **CLAUDE_CODE_COMPLETE_GUIDE.md**: Complete usage guide with installation, configuration, and best practices
- **claude-code-examples/**: Seven complete configuration examples with executable hooks
- **CLAUDE_CODE_완전가이드.md**: Korean version of the complete guide

### 🚀 Featured Examples

**7 Complete Configuration Examples**:

1. **Basic Project**: Simple web applications with formatting/linting
2. **Advanced Project**: Complex fullstack with subagents and comprehensive validation  
3. **Microservices Project**: Distributed systems with container orchestration
4. **Enterprise Security Project**: High-security environments with compliance validation
5. **AI Research Project**: ML research with experiment tracking and MCP integration
6. **Startup MVP Project**: Rapid development with modern startup stack
7. **Open Source Project**: OSS maintenance with community workflows

### 🔧 Key Features Covered

- **Hierarchical Configuration**: Enterprise → User → Project → Local settings
- **Custom Hooks**: Pre/post-tool automation with 15+ executable scripts
- **Specialized Agents**: Domain-specific AI assistants for various roles
- **MCP Integration**: External tool connections (GitHub, W&B, Supabase, etc.)
- **Multi-language Support**: Node.js, Python, Rust, Go with appropriate tooling
- **Security Validation**: Advanced prompt filtering and compliance checking
- **Advanced Patterns**: TDD integration, experiment tracking, deployment automation

### 📖 Quick Start

1. Choose an appropriate example from `claude-code-examples/`
2. Copy the `.claude/` configuration to your project
3. Customize `settings.json` for your specific needs
4. Make hook scripts executable: `chmod +x .claude/hooks/*.sh`
5. Start using Claude Code with your configured setup

### 🏗️ Architecture Examples

From simple projects to complex distributed systems:
- **Basic**: Single service with formatting hooks
- **Enterprise**: Multi-agent security-focused development
- **Research**: ML experiment tracking with reproducibility
- **Microservices**: Container orchestration with service mesh validation

---

## 한국어

다양한 프로젝트 유형과 개발 시나리오를 위한 포괄적인 Claude Code 설정 예제와 문서를 포함한 저장소입니다.

### 📁 저장소 구조

- **CLAUDE.md**: Claude Code 인스턴스를 위한 저장소별 가이드
- **CLAUDE_CODE_COMPLETE_GUIDE.md**: 설치, 설정, 모범 사례가 포함된 완전 사용 가이드 (영문)
- **claude-code-examples/**: 실행 가능한 훅이 있는 7개의 완전한 설정 예제
- **CLAUDE_CODE_완전가이드.md**: 완전 가이드 한국어 버전

### 🚀 주요 예제

**7개의 완전한 설정 예제**:

1. **기본 프로젝트**: 포맷팅/린팅이 포함된 간단한 웹 애플리케이션
2. **고급 프로젝트**: 서브에이전트와 포괄적 검증이 있는 복잡한 풀스택  
3. **마이크로서비스 프로젝트**: 컨테이너 오케스트레이션이 있는 분산 시스템
4. **기업 보안 프로젝트**: 컴플라이언스 검증이 있는 고보안 환경
5. **AI 연구 프로젝트**: 실험 추적 및 MCP 통합이 있는 ML 연구
6. **스타트업 MVP 프로젝트**: 모던 스타트업 스택을 활용한 빠른 개발
7. **오픈소스 프로젝트**: 커뮤니티 워크플로우가 있는 OSS 유지보수

### 🔧 다루는 주요 기능

- **계층적 설정**: 기업 → 사용자 → 프로젝트 → 로컬 설정
- **커스텀 훅**: 15개 이상의 실행 가능한 스크립트로 사전/사후 도구 자동화
- **전문화된 에이전트**: 다양한 역할을 위한 도메인별 AI 어시스턴트
- **MCP 통합**: 외부 도구 연결 (GitHub, W&B, Supabase 등)
- **다중 언어 지원**: 적절한 도구가 있는 Node.js, Python, Rust, Go
- **보안 검증**: 고급 프롬프트 필터링 및 컴플라이언스 확인
- **고급 패턴**: TDD 통합, 실험 추적, 배포 자동화

### 📖 빠른 시작

1. `claude-code-examples/`에서 적절한 예제 선택
2. `.claude/` 설정을 프로젝트에 복사
3. 특정 요구사항에 맞게 `settings.json` 커스터마이징
4. 훅 스크립트를 실행 가능하게 만들기: `chmod +x .claude/hooks/*.sh`
5. 설정된 설정으로 Claude Code 사용 시작

### 🏗️ 아키텍처 예제

간단한 프로젝트부터 복잡한 분산 시스템까지:
- **기본**: 포맷팅 훅이 있는 단일 서비스
- **기업**: 보안 중심 개발을 위한 다중 에이전트
- **연구**: 재현성이 있는 ML 실험 추적
- **마이크로서비스**: 서비스 메시 검증이 있는 컨테이너 오케스트레이션

---

## Documentation / 문서

### English Documentation
- [Complete Guide](./CLAUDE_CODE_COMPLETE_GUIDE.md) - Comprehensive usage guide with all features
- [Examples README](./claude-code-examples/README.md) - Detailed explanation of all configuration examples

### Korean Documentation / 한국어 문서
- [완전 가이드](./CLAUDE_CODE_완전가이드.md) - 모든 기능을 포함한 포괄적 사용 가이드
- [예제 README](./claude-code-examples/README.md) - 모든 설정 예제의 상세 설명

## Contributing / 기여

This repository demonstrates various Claude Code usage patterns. Feel free to:
- Add new configuration examples
- Improve existing hook scripts
- Enhance documentation
- Share your Claude Code setup patterns

이 저장소는 다양한 Claude Code 사용 패턴을 보여줍니다. 자유롭게:
- 새로운 설정 예제 추가
- 기존 훅 스크립트 개선
- 문서 향상
- Claude Code 설정 패턴 공유

## License / 라이센스

MIT License - Feel free to use these examples in your projects.

MIT 라이센스 - 이 예제들을 자유롭게 프로젝트에서 사용하세요.