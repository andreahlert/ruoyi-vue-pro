#!/bin/bash
set -e

echo "==================================="
echo "Railway MySQL Initialization"
echo "==================================="
echo ""
echo "Aguardando MySQL estar disponível..."

# Aguardar MySQL estar pronto
until mysql -h mysql-y8ht.railway.internal -u root -p"${MYSQLPASSWORD}" railway -e "SELECT 1" > /dev/null 2>&1; do
    echo "MySQL não está pronto ainda... aguardando..."
    sleep 5
done

echo "MySQL está pronto!"
echo ""
echo "Executando ruoyi-vue-pro.sql (schema principal)..."
mysql -h mysql-y8ht.railway.internal -u root -p"${MYSQLPASSWORD}" railway < /app/sql/mysql/ruoyi-vue-pro.sql
echo "✓ ruoyi-vue-pro.sql executado com sucesso"
echo ""

echo "Executando quartz.sql (scheduler)..."
mysql -h mysql-y8ht.railway.internal -u root -p"${MYSQLPASSWORD}" railway < /app/sql/mysql/quartz.sql
echo "✓ quartz.sql executado com sucesso"
echo ""

echo "==================================="
echo "Database inicializado com sucesso!"
echo "==================================="
