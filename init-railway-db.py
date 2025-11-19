#!/usr/bin/env python3
"""
Script para inicializar o banco de dados MySQL no Railway
Executa os scripts SQL necessários para o ruoyi-vue-pro
"""

import mysql.connector
import sys
import time

# Configurações do MySQL Railway
MYSQL_CONFIG = {
    'host': 'nozomi.proxy.rlwy.net',
    'port': 25234,
    'user': 'root',
    'password': 'DyggfTbtDDzvmXGpDsPvsspcnoeFGQwn',
    'database': 'railway',
    'charset': 'utf8mb4'
}

def connect_mysql(max_retries=5):
    """Conecta ao MySQL com retry"""
    for attempt in range(max_retries):
        try:
            print(f"Tentativa {attempt + 1} de conectar ao MySQL Railway...")
            conn = mysql.connector.connect(**MYSQL_CONFIG)
            print("OK - Conectado ao MySQL com sucesso!")
            return conn
        except mysql.connector.Error as err:
            print(f"ERRO na conexao: {err}")
            if attempt < max_retries - 1:
                print("Aguardando 5 segundos antes de tentar novamente...")
                time.sleep(5)
            else:
                print("ERRO: Nao foi possivel conectar ao MySQL apos varias tentativas")
                sys.exit(1)

def execute_sql_file(cursor, filepath):
    """Executa um arquivo SQL"""
    print(f"\n{'='*60}")
    print(f"Executando: {filepath}")
    print('='*60)

    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            sql_content = f.read()

        # Dividir em statements individuais (separados por ;)
        statements = sql_content.split(';')

        total = len(statements)
        executed = 0

        for i, statement in enumerate(statements, 1):
            statement = statement.strip()
            if not statement:
                continue

            try:
                cursor.execute(statement)
                executed += 1

                # Mostrar progresso a cada 50 statements
                if executed % 50 == 0:
                    print(f"Progresso: {executed}/{total} statements executados...")

            except mysql.connector.Error as err:
                # Ignorar erros de "table already exists"
                if "already exists" not in str(err).lower():
                    print(f"WARNING no statement {i}: {err}")

        print(f"OK - Concluido: {executed} statements executados com sucesso")
        return True

    except FileNotFoundError:
        print(f"ERRO: Arquivo nao encontrado: {filepath}")
        return False
    except Exception as e:
        print(f"ERRO ao processar arquivo: {e}")
        return False

def main():
    """Função principal"""
    print("""
============================================================
    Inicializacao do Banco de Dados Railway
              ruoyi-vue-pro MySQL Setup
============================================================
    """)

    # Conectar ao MySQL
    conn = connect_mysql()
    cursor = conn.cursor()

    try:
        # Executar script principal
        success1 = execute_sql_file(cursor, 'sql/mysql/ruoyi-vue-pro.sql')
        conn.commit()

        if not success1:
            print("\nERRO: Falha ao executar ruoyi-vue-pro.sql")
            sys.exit(1)

        # Executar script do Quartz
        success2 = execute_sql_file(cursor, 'sql/mysql/quartz.sql')
        conn.commit()

        if not success2:
            print("\nERRO: Falha ao executar quartz.sql")
            sys.exit(1)

        print(f"\n{'='*60}")
        print("OK - Database inicializado com sucesso!")
        print('='*60)
        print("\nProximos passos:")
        print("1. railway up  # Fazer deploy da aplicacao")
        print("2. railway domain  # Gerar dominio publico")
        print('='*60)

    except Exception as e:
        print(f"\nERRO durante a execucao: {e}")
        sys.exit(1)
    finally:
        cursor.close()
        conn.close()
        print("\nConexao fechada.")

if __name__ == "__main__":
    main()
