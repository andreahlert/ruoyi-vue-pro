# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**ruoyi-vue-pro** (芋道管理系统) is a comprehensive enterprise-grade rapid development platform built on Spring Boot. It provides a modular monolith architecture where business modules can be selectively enabled or disabled based on project needs.

**Key Characteristics:**
- Chinese open-source project (MIT license)
- Production-ready with 1000+ real deployments
- Extensive feature set spanning 15+ business domains
- Code generation as a first-class feature
- Multi-tenancy (SaaS) support built-in

## Technology Stack

- **Backend:** Spring Boot 2.7.18, Java 8 (JDK 1.8)
- **ORM:** MyBatis Plus
- **Cache:** Redis + Redisson
- **Security:** Spring Security + JWT
- **Workflow:** Flowable
- **Build:** Maven (multi-module)
- **Database:** MySQL 5.7+ / 8.0+, PostgreSQL, Oracle, SQL Server, 达梦, 瀚高

## Architecture

### Multi-Module Structure

The project follows a **modular monolith** pattern where functionality is organized into independent Maven modules:

```
yudao/
├── yudao-dependencies/     # Dependency version management (BOM)
├── yudao-framework/        # Custom Spring Boot starters & common utilities
├── yudao-server/          # Application entry point (empty shell)
├── yudao-module-system/   # Core: users, roles, permissions, menus, depts
├── yudao-module-infra/    # Infrastructure: config, logging, file storage, code gen
└── yudao-module-*/        # Business modules (commented out by default):
    ├── member/            # Member management
    ├── bpm/              # Workflow (Flowable)
    ├── pay/              # Payment integration
    ├── mp/               # WeChat Official Account
    ├── mall/             # E-commerce (product/promotion/trade/statistics)
    ├── crm/              # Customer Relationship Management
    ├── erp/              # Enterprise Resource Planning
    ├── ai/               # AI/LLM integration
    ├── iot/              # IoT device management
    └── report/           # Reporting & BI
```

### Module Activation

**Default Setup (Fast Compilation):**
- Only `system` and `infra` modules are active
- All other modules are commented out in `pom.xml` files

**Enabling Modules:**
1. Uncomment the desired `<module>` in root `pom.xml`
2. Uncomment the corresponding `<dependency>` in `yudao-server/pom.xml`
3. Run `mvn clean install` to rebuild

### Internal Module Structure

Each business module follows a consistent layered pattern:

```
yudao-module-*/
├── controller/
│   ├── admin/          # Backend admin API endpoints
│   └── app/            # Mobile/frontend API endpoints
├── service/            # Business logic layer
│   └── impl/
├── dal/                # Data Access Layer
│   ├── dataobject/     # Entity classes (database tables)
│   ├── mysql/          # MyBatis mappers
│   └── redis/          # Redis operations
├── convert/            # MapStruct converters (DTO ↔ Entity)
├── vo/                 # View Objects (API request/response DTOs)
├── enums/              # Business enumerations
├── framework/          # Module-specific configuration
├── job/                # Scheduled tasks
└── mq/                 # Message queue consumers
```

### Framework Layer (yudao-framework)

Custom Spring Boot starters that provide cross-cutting concerns:

- **yudao-spring-boot-starter-web**: Web layer enhancements, exception handling
- **yudao-spring-boot-starter-security**: Authentication, authorization, JWT
- **yudao-spring-boot-starter-mybatis**: MyBatis Plus config, pagination, multi-tenancy
- **yudao-spring-boot-starter-redis**: Redis template, distributed locks
- **yudao-spring-boot-starter-biz-tenant**: Multi-tenancy isolation
- **yudao-spring-boot-starter-biz-data-permission**: Row-level data permissions
- **yudao-spring-boot-starter-biz-ip**: IP geolocation utilities
- **yudao-spring-boot-starter-job**: Quartz job scheduling
- **yudao-spring-boot-starter-mq**: Message queue abstraction (Redis/RabbitMQ/Kafka/RocketMQ)
- **yudao-spring-boot-starter-excel**: Excel import/export via EasyExcel
- **yudao-spring-boot-starter-monitor**: Metrics & monitoring
- **yudao-spring-boot-starter-protection**: Rate limiting, idempotency, lock4j
- **yudao-spring-boot-starter-websocket**: WebSocket support
- **yudao-spring-boot-starter-test**: Test utilities

### Data Access Patterns

**MyBatis Plus Conventions:**
- Mappers extend `BaseMapperX<T>` (enhanced BaseMapper)
- Service layer extends `IService<T>` + `ServiceImpl<M, T>`
- Automatic pagination via `PageResult<T>`
- Multi-tenancy via `@TenantIgnore` annotation control
- Soft delete support with logical delete fields

**Validation:**
- Use `@Valid` + `@Validated` with JSR-303 annotations
- Custom validators in `framework/validator`

## Common Development Tasks

### Building the Project

```bash
# Clean build all modules
mvn clean install -Dmaven.test.skip=true

# Build without optional modules (faster)
mvn clean install -pl yudao-server -am -Dmaven.test.skip=true

# Package for deployment
cd yudao-server
mvn clean package spring-boot:repackage
```

### Running the Application

```bash
# Run from IDE: Execute YudaoServerApplication.main()

# Run from command line
cd yudao-server
mvn spring-boot:run

# Run packaged JAR
java -jar yudao-server/target/yudao-server.jar
```

**Default Ports:**
- Application: `48080`
- Admin UI: Runs separately (Vue 2 or Vue 3 project)

### Testing

```bash
# Run all tests
mvn test

# Run tests for specific module
mvn test -pl yudao-module-system

# Run single test class
mvn test -Dtest=UserServiceImplTest

# Run single test method
mvn test -Dtest=UserServiceImplTest#testCreateUser
```

### Code Generation

The project includes a powerful code generator accessible via:
- Admin UI: System Tools → Code Generator
- Database-first approach: Select tables → Generate CRUD code
- Generates: Controller, Service, Mapper, Entity, VO, SQL scripts, Vue components

**Generated Code Location:**
- Backend: Downloads as ZIP → Extract to appropriate module
- Frontend: Downloads as ZIP → Extract to frontend project

### Database Migrations

SQL scripts are located in:
- `sql/mysql/`: Main database schemas
- `sql/postgresql/`, `sql/oracle/`, `sql/sqlserver/`: Alternative databases
- Each module may have its own `sql/` directory for module-specific tables

**Migration Strategy:**
- Manual SQL execution (no Flyway/Liquibase by default)
- Use version-controlled SQL files
- Apply incrementally during deployment

## Configuration

### Application Properties

Configuration files in `yudao-server/src/main/resources/`:
- `application.yaml`: Base configuration
- `application-dev.yaml`: Development environment
- `application-local.yaml`: Local overrides (gitignored)

**Key Configuration Areas:**
- Database: `spring.datasource`
- Redis: `spring.redis`
- Multi-tenancy: `yudao.tenant`
- Security: `yudao.security`
- File storage: `yudao.file` (local/S3/OSS/MinIO)
- SMS: `yudao.sms`
- Email: `spring.mail`

### Environment Variables

Can override any property using:
```bash
java -jar app.jar --spring.profiles.active=prod --server.port=8080
```

## Development Guidelines

### API Endpoints

**RESTful Conventions:**
- `GET /admin-api/{module}/{entity}/get?id=` - Get single record
- `GET /admin-api/{module}/{entity}/list` - List all (with filtering)
- `GET /admin-api/{module}/{entity}/page` - Paginated list
- `POST /admin-api/{module}/{entity}/create` - Create new record
- `PUT /admin-api/{module}/{entity}/update` - Update existing record
- `DELETE /admin-api/{module}/{entity}/delete?id=` - Delete record
- `GET /admin-api/{module}/{entity}/export-excel` - Export to Excel

### Security

**Authentication:**
- Login: `POST /admin-api/system/auth/login`
- Returns: Access token (1 day) + Refresh token (30 days)
- Use: `Authorization: Bearer <token>` header

**Permission Control:**
- `@PreAuthorize("@ss.hasPermission('system:user:create')")` on controller methods
- Permissions stored in `system_menu` table
- Data permissions via `@DataPermission` annotation

### Multi-Tenancy

**Tenant Isolation:**
- Enabled by default for most tables
- Automatic tenant_id filtering in queries
- Use `@TenantIgnore` to bypass tenant filtering
- Tenant context stored in `TenantContextHolder`

**Tenant Management:**
- Configured in System → Tenant Management
- Each tenant has isolated data
- Shared: system configuration, data dictionaries

## Common Pitfalls

1. **Missing Module Dependencies**: If a module reference fails at runtime, check that the module is uncommented in both root `pom.xml` and `yudao-server/pom.xml`.

2. **MyBatis Mapper Not Found**: Ensure mapper XML files are in `src/main/resources/mapper/` and mapper scanning is configured.

3. **Tenant Filter Issues**: If queries return empty unexpectedly, check if tenant_id is correctly set or if `@TenantIgnore` is needed.

4. **Code Generator Overwrites**: Generated code may overwrite manual changes. Always review diffs before replacing files.

5. **Redis Connection**: Application won't start without Redis. Configure `spring.redis.host` or disable features requiring Redis.

6. **Database Charset**: Use `utf8mb4` charset for MySQL to support full Unicode (emojis, special characters).

## Additional Resources

- **Official Documentation**: https://doc.iocoder.cn/
- **Demo Environment**: https://demo.iocoder.cn/ (admin/admin123)
- **Source Repository**: https://github.com/YunaiV/ruoyi-vue-pro
- **Frontend Projects**:
  - Vue 2: yudao-ui-admin (Element UI)
  - Vue 3: yudao-ui-admin-vue3 (Element Plus)
  - Vben 5: yudao-ui-admin-vben (Ant Design Vue)
- **Video Tutorials**: Available on project website
- **Community Support**: WeChat groups, QQ groups (see README)

## Notes for Claude Code

- This is an **active production system** - changes should be carefully considered
- The codebase contains **extensive Chinese comments** - context matters
- **Code generation** is heavily used - many files follow templates
- Focus on understanding **module boundaries** and **starter abstractions**
- When debugging, check **framework starters** before assuming Spring Boot defaults
- The project prioritizes **convention over configuration** - follow existing patterns
