use ecommerce;

-- 1. Endereços
insert into Endereco (CEP, rua, bairro, cidade, estado) values
('01001-000', 'Praça da Sé', 'Sé', 'São Paulo', 'SP'),
('20040-002', 'Rua Primeiro de Março', 'Centro', 'Rio de Janeiro', 'RJ'),
('30130-010', 'Avenida Afonso Pena', 'Centro', 'Belo Horizonte', 'MG'),
('40020-010', 'Avenida Sete de Setembro', 'Centro', 'Salvador', 'BA'),
('80010-000', 'Rua XV de Novembro', 'Centro', 'Curitiba', 'PR');

-- 2. Clientes
insert into Cliente (CPF, nome, dataNascimento, numeroTelefone, email) values
('111.222.333-44', 'Lucas Silva Ferreira', '1995-04-12', '11988887777', 'lucas.silva@email.com'),
('222.333.444-55', 'Mariana Costa Oliveira', '1990-08-25', '21977776666', 'mariana.costa@email.com'),
('333.444.555-66', 'Carlos Eduardo Santos', '1988-01-15', '31966665555', 'carlos.eduardo@email.com'),
('444.555.666-77', 'Beatriz Rodrigues Souza', '2001-11-30', '71955554444', 'beatriz.souza@email.com');

-- 3. Fornecedores e Empresas Parceiras
insert into Fornecedor (CNPJ_fornecedor, nomeFantasia, razaoSocial, inscricaoEstadual, inscricaoMunicipal, nomeContatoPrincipal, telefone, email, whatsApp, status, dataContrato, CEP, numeroEndereco, complemento) values
('12345678000190', 'TechDistribuidora', 'Tech Distribuidora de Eletronicos LTDA', '123456789', '987654321', 'Roberto Alves', '1133334444', 'contato@techdist.com.br', '11911112222', 'Ativo', '2023-01-15', '01001-000', '500', 'Galpão B'),
('98765432000101', 'LogiTech Brasil', 'Logitech do Brasil Comercio de Eletronicos', '987654321', '123456789', 'Fernanda Lima', '1133335555', 'vendas@logitechbr.com', '11922223333', 'Ativo', '2022-05-10', '01001-000', '1200', 'Andar 4');

insert into EmpresaParceira (CNPJ_Parceira, nomeFantasia, razaoSocial, inscricaoEstadual, inscricaoMunicipal, nomeContatoPrincipal, telefone, email, whatsApp, status, dataContrato, CEP, numeroEndereco, complemento) values
('11222333000144', 'InovaMarketplace', 'Inova Comercio Digital S.A.', '456789012', '654321098', 'Juliana Paes', '2122223333', 'parcerias@inovamarket.com', '21933334444', 'Ativo', '2023-03-01', '20040-002', '100', 'Sala 301');

-- 4. Endereços dos Clientes
insert into EnderecoCliente (CPF, CEP, numeroEndereco, complemento) values
('111.222.333-44', '01001-000', '105', 'Apto 42'),
('222.333.444-55', '20040-002', '45', 'Bloco A'),
('333.444.555-66', '30130-010', '800', 'Apto 1201'),
('444.555.666-77', '40020-010', '250', 'Casa');

-- 5. Categorias e Subcategorias
insert into Categoria (nome) values
('Informática'),
('Periféricos'),
('Áudio');

insert into Subcategoria (nome, id_categoria) values
('Notebooks', 1),
('Mouses', 2),
('Teclados', 2),
('Headsets', 3);

-- 6. Produtos
insert into Produto (CNPJ_Fornecedor, CNPJ_EmpresaParceira, codigoBarra, descricao, marca, lote, dataFabricacao, dataValidade, peso, valorCusto, valorVenda, id_subcategoria) values
('12345678000190', null, '7891234567890', 'Notebook Lenovo Ideapad Gaming 3i i5 16GB 512GB SSD', 'Lenovo', 'L0124', '2024-01-10', null, '2.2kg', 3200.00, 4199.90, 1),
('98765432000101', null, '7891234567891', 'Mouse Sem Fio Logitech MX Master 3S', 'Logitech', 'L0224', '2024-02-15', null, '141g', 350.00, 549.90, 2),
('98765432000101', null, '7891234567892', 'Teclado Mecanico Logitech G PRO X', 'Logitech', 'L0224', '2024-02-20', null, '980g', 450.00, 699.90, 3),
(null, '11222333000144', '7891234567893', 'Headset Gamer HyperX Cloud II 7.1', 'HyperX', 'L0324', '2024-03-01', null, '320g', 280.00, 429.90, 4);

-- 7. Estoque Inicial
insert into Estoque (id_produto, quantidadeAtual, quantidadeMinima) values
(1, 15, 3),
(2, 40, 10),
(3, 25, 5),
(4, 2, 5);

-- 8. Avaliações
insert into Avaliacao (id_produto, notaAvaliacao) values
(1, '5'),
(2, '5'),
(3, '4'),
(4, '5');

-- Execução de Procedures para Simulação
call alterarPreco(1, 4099.90);
call entradaEstoqueCompra(4, 10);
call saidaEstoqueAvarias(2, 1);
call saidaEstoqueFurto(3, 1);

-- Simulação de Pedidos e Triggers
call registrarPedido('111.222.333-44', 4099.90, 0.00, 1, 1, 4099.90);
call registrarPedido('222.333.444-55', 549.90, 0.00, 2, 1, 549.90);

insert into Pagamento (id_pedido, FormaPg, valor, parcelas, id_enderecoCliente) values
(1, 'Cartão de Crédito', 4099.90, 10, 1),
(2, 'PIX', 549.90, 1, 2);

insert into HistoricoPedido (id_pedido, dataHistorico, statusPedido) values
(1, curdate(), 'Pagamento aprovado'),
(2, curdate(), 'Entregue');

-- Simulação de Devolução e Estorno
call registrarDevolucao(2, 2, 1);

insert into Estorno (id_pagamento, id_devolucao, valor, dataEstorno, motivo, status) values
(2, 1, 549.90, curdate(), 'Arrependimento de compra no prazo de 7 dias', 'Estornado');