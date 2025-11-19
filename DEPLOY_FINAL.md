# Deploy Final - ruoyi-vue-pro no Railway

## ✅ Concluído Até Agora

1. ✅ Módulos ativados (ERP, CRM, Member, BPM, Mall)
2. ✅ Dockerfile criado
3. ✅ Projeto Railway criado
4. ✅ MySQL deployado e inicializado (2704 tabelas/dados)
5. ✅ Redis deployado
6. ✅ Scripts SQL executados com sucesso

## 🚀 Próximos Passos (Manual no Dashboard)

### 1. Criar Serviço para a Aplicação Spring Boot

1. Acesse: https://railway.app/project/97e440da-9333-4670-9206-f10ee3fcdd44
2. Clique no botão **"+ New"**
3. Selecione **"Empty Service"**
4. Nomeie como: `yudao-server`

### 2. Conectar ao GitHub (Recomendado)

**Opção A - Via GitHub:**
1. No serviço criado, clique em **"Settings"**
2. Vá em **"Source"** → **"Connect Repo"**
3. Conecte seu repositório GitHub

**Opção B - Deploy Local:**
```bash
# Fazer commit das alterações
git add .
git commit -m "Configure Railway deployment with all modules"
git push

# Depois no Railway CLI
railway link
railway service  # Selecione yudao-server
railway up
```

### 3. Configurar Variáveis de Ambiente

No serviço `yudao-server`, vá em **"Variables"** e adicione:

```bash
SPRING_PROFILES_ACTIVE=prod

DATABASE_URL=jdbc:mysql://mysql-y8ht.railway.internal:3306/railway?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&nullCatalogMeansCurrent=true&rewriteBatchedStatements=true
DATABASE_USER=root
DATABASE_PASSWORD=DyggfTbtDDzvmXGpDsPvsspcnoeFGQwn

REDIS_HOST=redis-1g-z.railway.internal
REDIS_PORT=6379
REDIS_DATABASE=1
REDIS_PASSWORD=nkSjHgEPddDZywPdzqRrqYDQoAVTtHDM

PORT=48080
DRUID_PASSWORD=admin123
ADMIN_UI_URL=https://dashboard.yudao.iocoder.cn
```

### 4. Verificar Build Settings

Em **"Settings"** → **"Build"**:
- ✅ Builder: **Dockerfile**
- ✅ Dockerfile Path: `Dockerfile`
- ✅ Build Command: (deixe vazio, está no Dockerfile)

### 5. Deploy

1. Clique em **"Deploy"** ou faça um push no repositório
2. Aguarde o build (15-20 minutos na primeira vez)
3. Monitore os logs na aba **"Deployments"**

### 6. Gerar Domínio Público

Após o deploy bem-sucedido:

1. No serviço `yudao-server`, vá em **"Settings"**
2. Clique em **"Networking"** → **"Generate Domain"**
3. Copie o domínio gerado (ex: `yudao-server-production.up.railway.app`)

### 7. Testar a Aplicação

```bash
# Health check
curl https://SEU-DOMINIO.railway.app/actuator/health

# Swagger UI
https://SEU-DOMINIO.railway.app/swagger-ui/index.html

# Login padrão
usuário: admin
senha: admin123
```

## 📊 Monitoramento

### Ver Logs em Tempo Real

```bash
railway logs --service yudao-server
```

### Ver Status dos Serviços

```bash
railway status
```

### Conectar ao MySQL

```bash
railway connect MySQL-y8Ht
```

## ⚠️ Troubleshooting

### Build Falha por Memória

Se o build falhar por falta de memória:
1. Considere desativar alguns módulos temporariamente
2. Ou upgrade para Railway Pro (mais memória)

### Aplicação Não Inicia

Verifique os logs:
```bash
railway logs --service yudao-server | grep ERROR
```

Problemas comuns:
- **Conexão MySQL**: Verifique se as variáveis `DATABASE_*` estão corretas
- **Conexão Redis**: Verifique se as variáveis `REDIS_*` estão corretas
- **Porta**: Railway define PORT automaticamente via $PORT

### Flowable/BPM Não Funciona

O módulo BPM cria as tabelas automaticamente. Se falhar:
- Verifique logs para erros do Flowable
- Confirme que `flowable.database-schema-update=true` está ativo

## 📝 Credenciais Importantes

### MySQL Railway
- Host Público: `nozomi.proxy.rlwy.net:25234`
- Host Interno: `mysql-y8ht.railway.internal:3306`
- User: `root`
- Password: `DyggfTbtDDzvmXGpDsPvsspcnoeFGQwn`
- Database: `railway`

### Redis Railway
- Host Interno: `redis-1g-z.railway.internal:6379`
- Password: `nkSjHgEPddDZywPdzqRrqYDQoAVTtHDM`

### Aplicação (após deploy)
- User: `admin`
- Password: `admin123`

## 💰 Custos Estimados

**Railway cobra por uso:**
- Build Time: ~$0.20-0.30 (primeira vez, 15-20 min)
- Runtime: ~$5-10/mês (dependendo do tráfego)
- MySQL Volume: ~$1/mês (1GB)
- Redis Volume: ~$1/mês (1GB)

**Total estimado: $7-15/mês**

## 🔧 Comandos Úteis

```bash
# Ver todas as variáveis
railway variables

# Abrir dashboard
railway open

# Ver deployments
railway status

# Redeploy
railway up --service yudao-server

# Ver logs específicos
railway logs --service yudao-server | grep "Started YudaoServerApplication"
```

## ✨ Próximos Passos Após Deploy

1. Configure domínio customizado (opcional)
2. Configure CI/CD automático via GitHub Actions
3. Configure backups do MySQL
4. Configure monitoring/alerting
5. Deploy do frontend (yudao-ui-admin)

---

**✅ Status Atual:**
- Banco de dados: PRONTO
- Aplicação configurada: PRONTO
- Aguardando: Deploy manual no dashboard

**🎯 Próxima ação:**
Criar o serviço `yudao-server` no dashboard do Railway e fazer deploy!
