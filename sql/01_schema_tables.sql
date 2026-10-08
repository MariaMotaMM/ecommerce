create database if not exists ecommerce;
use ecommerce;

-- --------------------------------------------------------
-- TABELAS DE ENDEREÇO E PESSOAS
-- --------------------------------------------------------

create table if not exists Endereco (
    CEP varchar(12) primary key not null,
    rua varchar(100),
    bairro varchar(100),
    cidade varchar(100),
    estado varchar(50)
);

create table if not exists Cliente (
    CPF varchar(14) primary key not null,
    nome varchar(255),
    dataNascimento date,
    numeroTelefone varchar(12),
    email varchar(200)
);

create table if not exists Fornecedor (
    CNPJ_fornecedor varchar(14) primary key not null,
    nomeFantasia varchar(150),
    razaoSocial varchar(150),
    inscricaoEstadual varchar(255),
    inscricaoMunicipal varchar(255),
    nomeContatoPrincipal varchar(244),
    telefone varchar(12),
    email varchar(155),
    whatsApp varchar(12),
    status enum('Ativo', 'Inativo') default 'Ativo',
    dataContrato date,
    CEP varchar(12),
    numeroEndereco varchar(10),
    complemento varchar(150),
    constraint end_forn foreign key (CEP) references Endereco(CEP) 
    on update cascade 
    on delete restrict
);

create table if not exists EmpresaParceira (
    CNPJ_Parceira varchar(14) primary key not null,
    nomeFantasia varchar(150),
    razaoSocial varchar(150),
    inscricaoEstadual varchar(255),
    inscricaoMunicipal varchar(255),
    nomeContatoPrincipal varchar(244),
    telefone varchar(12),
    email varchar(155),
    whatsApp varchar(12),
    status enum('Ativo', 'Inativo') default 'Ativo',
    dataContrato date,
    CEP varchar(12),
    numeroEndereco varchar(10),
    complemento varchar(150),
    constraint end_parceiro foreign key (CEP) references Endereco(CEP) 
    on update cascade
    on delete restrict
);

create table if not exists EnderecoCliente (
    id_enderecoCliente int auto_increment primary key,
    CPF varchar(14),
    CEP varchar(12),
    numeroEndereco varchar(10),
    complemento varchar(150),
    constraint endCliente_cliente foreign key (CPF) references Cliente(CPF) 
    on update cascade
    on delete restrict,
    constraint end_endCliente foreign key (CEP) references Endereco(CEP) 
    on update cascade 
    on delete restrict
);

-- --------------------------------------------------------
-- CATÁLOGO E ESTOQUE
-- --------------------------------------------------------

create table if not exists Categoria (
    id_categoria int auto_increment primary key,
    nome varchar(150) unique
);

create table if not exists Subcategoria (
    id_subcategoria int auto_increment primary key,
    nome varchar(150) unique,
    id_categoria int,
    constraint cat_sub foreign key (id_categoria) references Categoria(id_categoria) 
    on update cascade 
    on delete restrict
);

create table if not exists Produto (
    id_produto int auto_increment primary key,
    CNPJ_Fornecedor varchar(14),
    CNPJ_EmpresaParceira varchar(14),
    codigoBarra varchar(44) unique,
    descricao varchar(150) unique,
    marca varchar(150),
    lote varchar(5),
    dataFabricacao date,
    dataValidade date,
    peso varchar(100),
    valorCusto decimal(10,2),
    valorVenda decimal(10,2),
    id_subcategoria int,
    constraint prod_forn foreign key (CNPJ_Fornecedor) references Fornecedor(CNPJ_fornecedor) 
    on update cascade 
    on delete restrict,
    constraint prod_parc foreign key (CNPJ_EmpresaParceira) references EmpresaParceira(CNPJ_Parceira) 
    on update cascade 
    on delete restrict,
    constraint subcat_prod foreign key (id_subcategoria) references Subcategoria(id_subcategoria) 
    on update cascade 
    on delete restrict
);

create table if not exists Estoque (
    id_estoque int auto_increment primary key,
    id_produto int not null unique,
    quantidadeAtual int not null default 0,
    quantidadeMinima int not null default 0,
    constraint estoque_produto foreign key (id_produto) references Produto(id_produto) 
    on update cascade
    on delete restrict
);

create table if not exists Avaliacao (
    id_avaliacao int auto_increment primary key,
    id_produto int,
    notaAvaliacao enum('1','2','3','4','5'),
    constraint avaliacao_produto foreign key (id_produto) references Produto(id_produto) 
    on update cascade 
    on delete cascade
);

-- --------------------------------------------------------
-- VENDAS E CARRINHO
-- --------------------------------------------------------

create table if not exists Carrinho (
    id_carrinho int auto_increment primary key,
    cpf varchar(14),
    valorTotal decimal(10,2),
    constraint car_cliente foreign key (cpf) references Cliente(CPF) 
    on update cascade 
    on delete restrict
);

create table if not exists ItensCarrinho (
    id_itensCarrinho int auto_increment primary key,
    id_carrinho int,
    id_produto int,
    quantidade int,
    constraint itenscar_carr foreign key (id_carrinho) references Carrinho(id_carrinho) 
    on update cascade 
    on delete restrict,
    constraint car_produto foreign key (id_produto) references Produto(id_produto) 
    on update cascade 
    on delete restrict
);

create table if not exists Pedido (
    id_pedido int auto_increment primary key,
    dataPedido date,
    valorTotVenda decimal(10,2),
    cpf varchar(14),
    desconto decimal(10,2),
    constraint ped_cliente foreign key (cpf) references Cliente(CPF)
    on update cascade
    on delete restrict
);

create table if not exists ItemPedido (
    id_produto int,
    id_pedido int,
    quantidade_vendida int,
    hora_venda timestamp default current_timestamp,
    precoUnitario decimal(10,2),
    constraint item_prod foreign key (id_produto) references Produto(id_produto) 
    on update cascade 
    on delete restrict,
    constraint item_venda foreign key (id_pedido) references Pedido(id_pedido)
    on update cascade 
    on delete restrict,
    primary key (id_produto, id_pedido, hora_venda)
);

create table if not exists HistoricoPedido (
    id_historico int auto_increment primary key,
    id_pedido int,
    dataHistorico date,
    horaHistorico timestamp default current_timestamp,
    statusPedido enum('Aguardando pagamento', 'Pagamento aprovado', 'Em preparação', 'Enviado', 'Entregue', 'Cancelado', 'Finalizado'),
    constraint historico_pedido foreign key (id_pedido) references Pedido(id_pedido) 
    on update cascade
    on delete restrict
);

create table if not exists Pagamento (
    id_pagamento int auto_increment primary key,
    id_pedido int,
    FormaPg enum('Dinheiro', 'PIX', 'Cartão de Débito', 'Cartão de Crédito'),
    valor decimal(10,2),
    parcelas int default 1,
    id_enderecoCliente int,
    constraint pag_ped foreign key (id_pedido) references Pedido(id_pedido) 
    on update cascade 
    on delete restrict,
    constraint pag_endClien foreign key (id_enderecoCliente) references EnderecoCliente(id_enderecoCliente) 
    on update cascade
    on delete restrict
);

create table if not exists Entrega (
    id_entrega int auto_increment primary key,
    id_pedido int,
    id_enderecoCliente int,
    codigoRastreamento varchar(50),
    statusEntrega enum('Aguardando envio', 'Enviado', 'Em trânsito', 'Saiu para entrega', 'Entregue', 'Não entregue'),
    dataEnvio date,
    dataPrevista date,
    dataEntrega date,
    valorFrete decimal(10,2) default 0,
    constraint entrega_pedido foreign key (id_pedido) references Pedido(id_pedido) 
    on update cascade 
    on delete restrict,
    constraint entrega_endCliente foreign key (id_enderecoCliente) references EnderecoCliente(id_enderecoCliente) 
    on update cascade
    on delete restrict
);

-- --------------------------------------------------------
-- LOGISTICA DE ESTOQUE, DEVOLUÇÃO E ESTORNO
-- --------------------------------------------------------

create table if not exists Movimentacao (
    id_movimentacao int auto_increment primary key,
    tipo enum('entrada', 'saida') default 'saida',
    id_estoque int,
    descricao enum('Compra', 'Venda', 'Estorno', 'Avarias', 'Furto') default 'Venda',
    observacao text,
    dataHoraMovimentacao datetime,
    quantidade int,
    constraint estoque_mov foreign key (id_estoque) references Estoque(id_estoque) 
    on update cascade 
    on delete restrict
);

create table if not exists Devolucao (
    id_devolucao int auto_increment primary key,
    id_pedido int,
    dataDevolucao date,
    constraint dev_ped foreign key (id_pedido) references Pedido(id_pedido) 
    on update cascade
    on delete restrict
);

create table if not exists ItensDevolucao (
    id_itensDevolucao int auto_increment primary key,
    id_produto int,
    id_devolucao int,
    quantidade int,
    constraint itens_produto foreign key (id_produto) references Produto(id_produto) 
    on update cascade
    on delete restrict,
    constraint itens_devolucao foreign key (id_devolucao) references Devolucao(id_devolucao) 
    on update cascade
    on delete restrict
);

create table if not exists Estorno (
    id_estorno int auto_increment primary key,
    id_pagamento int,
    id_devolucao int,
    valor decimal(10,2),
    dataEstorno date,
    motivo text,
    status enum('Solicitado', 'Processando', 'Estornado', 'Recusado', 'Cancelado'),
    constraint estorno_pagamento foreign key (id_pagamento) references Pagamento(id_pagamento)
    on update cascade 
    on delete restrict,
    constraint devolucao_estorno foreign key (id_devolucao) references Devolucao(id_devolucao)
    on update cascade 
    on delete restrict
);