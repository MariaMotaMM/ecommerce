# 🛒 E-commerce Database (MySQL)

Base de dados relacional robusta desenvolvida em MySQL para suportar as operações completas de uma plataforma de e-commerce.

---

## 📋 Sobre o Projeto
Este projeto modela e implementa a infraestrutura de dados para uma loja virtual. O sistema foi desenhado para cobrir todo o ciclo de vida de um e-commerce: desde a gestão de clientes, fornecedores e catálogo de produtos, até ao processamento de pedidos, pagamentos, logística de entregas e controlo rigoroso de stock.

---

## 🚀 O que o projeto inclui?
* **20 Tabelas Normalizadas:** Estrutura relacional completa que abrange clientes, moradas, categorias, produtos, fornecedores, stock, métodos de pagamento, pedidos e itens de pedido.
* **Gestão de Stock Automatizada (*Triggers*):** Implementação de gatilhos em SQL para atualizar automaticamente as quantidades em stock no momento em que um pedido é confirmado.
* **Consultas e Relatórios (*Views*):** Vistas otimizadas para consulta rápida de dados analíticos essenciais, como o histórico de compras de clientes e os produtos mais vendidos.
* **Dados de Teste (*Seed Data*):** Ficheiros com dados fictícios para popular a base de dados e testar o funcionamento imediato das tabelas e consultas.

---

## 📂 Estrutura do Repositório
```text
ecommerce/
├── docs/
│   └── der-ecommerce.png    # Diagrama de Entidade-Relacionamento (ERD)
└── sql/
    ├── 01_schema.sql        # Scripts DDL (Criação de tabelas, chaves e restrições)
    ├── 02_triggers.sql      # Automatizações e regras de negócio (Triggers)
    ├── 03_views.sql         # Consultas analíticas guardadas (Views)
    └── 04_seed_data.sql     # Dados de exemplo para testes
