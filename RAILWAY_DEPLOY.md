# Instruções de Deploy no Railway - ruoyi-vue-pro

## Status Atual

✅ Módulos ativados: ERP, CRM, Member, BPM, Mall
✅ Dockerfile criado
✅ Projeto Railway criado e linkado
✅ MySQL deployado
✅ Redis deployado

## Serviços no Railway

**MySQL:**
- Host interno: `mysql-y8ht.railway.internal`
- Porta: 3306
- Usuário: `root`
- Senha: `DyggfTbtDDzvmXGpDsPvsspcnoeFGQwn`
- Database: `railway`
- URL: `mysql://root:DyggfTbtDDzvmXGpDsPvsspcnoeFGQwn@mysql-y8ht.railway.internal:3306/railway`

**Redis:**
- Host interno: `redis-1g-z.railway.internal`
- Porta: 6379
- Senha: `nkSjHgEPddDZywPdzqRrqYDQoAVTtHDM`
- URL: `redis://default:nkSjHgEPddDZywPdzqRrqYDQoAVTtHDM@redis-1g-z.railway.internal:6379`

## Próximos Passos

### 1. Inicializar o Banco de Dados MySQL

Primeiro, você precisa executar os scripts SQL no banco MySQL do Railway:

```bash
# Conectar ao MySQL via proxy público (para executar os scripts)
# Use o MySQL Workbench ou qualquer cliente MySQL com:
# Host: nozomi.proxy.rlwy.net
# Port: 25234
# User: root
# Password: DyggfTbtDDzvmXGpDsPvsspcnoeFGQwn
# Database: railway
```

**Scripts a executar (em ordem):**
1. `sql/mysql/ruoyi-vue-pro.sql` - Schema principal e dados
2. `sql/mysql/quartz.sql` - Tabelas do Quartz Scheduler

### 2. Criar Serviço da Aplicação Spring Boot

Você precisa adicionar um novo serviço no Railway para a aplicação:

1. Acesse o dashboard do Railway: https://railway.app/
2. Selecione o projeto "ruoyi-vue-pro"
3. Clique em "+ New" para adicionar um novo serviço
4. Selecione "GitHub Repo" ou "Empty Service"
5. Se usar GitHub, conecte seu repositório. Caso contrário, crie um empty service.

### 3. Configurar Variáveis de Ambiente

No serviço da aplicação Spring Boot, adicione as seguintes variáveis:

```bash
# Perfil Spring
SPRING_PROFILES_ACTIVE=prod

# Configuração do MySQL
DATABASE_URL=jdbc:mysql://mysql-y8ht.railway.internal:3306/railway?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&nullCatalogMeansCurrent=true&rewriteBatchedStatements=true
DATABASE_USER=root
DATABASE_PASSWORD=DyggfTbtDDzvmXGpDsPvsspcnoeFGQwn

# Configuração do Redis
REDIS_HOST=redis-1g-z.railway.internal
REDIS_PORT=6379
REDIS_DATABASE=1
REDIS_PASSWORD=nkSjHgEPddDZywPdzqRrqYDQoAVTtHDM

# Senha do Druid Monitor (opcional)
DRUID_PASSWORD=admin123

# URL do Admin UI (ajustar após obter domínio)
ADMIN_UI_URL=https://seu-dominio-frontend.railway.app

# Porta (Railway define automaticamente, mas podemos especificar)
PORT=48080
```

### 4. Fazer Deploy

**Opção A: Deploy via Railway CLI (recomendado)**

```bash
# No diretório do projeto
railway up

# Ou com CI mode (apenas mostra logs e sai)
railway up --ci
```

**Opção B: Deploy via Git (se conectou GitHub)**

```bash
git add .
git commit -m "Configure Railway deployment"
git push origin main
```

### 5. Gerar Domínio Público

Após o deploy bem-sucedido:

```bash
# Gerar domínio Railway
railway domain
```

Ou use o dashboard do Railway para gerar um domínio.

## Comandos Úteis

```bash
# Ver logs em tempo real
railway logs

# Ver status dos serviços
railway status

# Listar variáveis de ambiente
railway variables

# Conectar ao MySQL via CLI
railway connect MySQL-y8Ht

# Abrir dashboard
railway open
```

## Troubleshooting

### Build muito lento
O build Maven com todos os módulos pode levar 10-20 minutos na primeira vez. Para acelerar:
- Os módulos já foram ativados no pom.xml
- O Dockerfile usa cache de dependências

### Erro de conexão com MySQL
- Verifique se os scripts SQL foram executados
- Confirme que o serviço MySQL está rodando no Railway
- Use o host interno (`.railway.internal`) para comunicação entre serviços

### Erro de memória durante build
Se o build falhar por falta de memória, você pode:
1. Desativar alguns módulos temporariamente
2. Usar o plano Pro do Railway (mais memória)

### Flowable não inicializa
O módulo BPM (Flowable) cria as tabelas automaticamente na primeira execução. Se falhar:
- Verifique os logs: `railway logs`
- Confirme que `flowable.database-schema-update=true` está ativo

## Arquivos Criados

- ✅ `Dockerfile` - Multi-stage build otimizado
- ✅ `.dockerignore` - Ignora arquivos desnecessários
- ✅ `railway.json` - Configuração do Railway
- ✅ `application-prod.yaml` - Configuração de produção
- ✅ Módulos ativados nos arquivos `pom.xml`

## Próximo: Testar a Aplicação

Após o deploy:

1. Acesse a URL gerada pelo Railway
2. Teste o endpoint de health: `https://seu-dominio.railway.app/actuator/health`
3. Acesse o Swagger: `https://seu-dominio.railway.app/swagger-ui/index.html`
4. Login padrão: admin / admin123

## Custos Estimados

Railway cobra por:
- **Build time** (~15-20 min primeira vez)
- **Runtime** (CPU + RAM + Network)
- **MySQL storage** (volume persistente)
- **Redis storage** (volume persistente)

Estimativa: $5-15/mês dependendo do uso.

---

**Criado automaticamente por Claude Code**
