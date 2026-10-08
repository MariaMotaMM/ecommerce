use ecommerce;

-- --------------------------------------------------------
-- 1. CONSULTAS DAS VIEWS (RELATÓRIOS CONSOLIDADOS)
-- --------------------------------------------------------
select * from vw_produtos_estoque;
select * from vw_vendas_por_produtos order by quantidadeVendida desc;
select * from vw_clientes_compras order by nomeCliente;
select * from vw_devolucao_estorno;

-- --------------------------------------------------------
-- 2. AUDITORIA E MOVIMENTAÇÃO DE ESTOQUE
-- --------------------------------------------------------
select 
    m.id_movimentacao,
    p.descricao as produto,
    m.tipo,
    m.descricao as motivo,
    m.quantidade,
    m.observacao,
    m.dataHoraMovimentacao
from Movimentacao m
inner join Estoque e on m.id_estoque = e.id_estoque
inner join Produto p on e.id_produto = p.id_produto
order by m.id_movimentacao asc;

-- --------------------------------------------------------
-- 3. VISÃO COMPLETA DE PEDIDOS E ENDEREÇO DE ENTREGA
-- --------------------------------------------------------
select 
    p.id_pedido,
    c.nome as cliente,
    p.valorTotVenda,
    pag.FormaPg,
    pag.parcelas,
    concat(end.rua, ', ', ec.numeroEndereco, ' - ', end.bairro, ' (', end.cidade, '/', end.estado, ')') as enderecoEntrega
from Pedido p
inner join Cliente c on p.cpf = c.CPF
left join Pagamento pag on p.id_pedido = pag.id_pedido
left join EnderecoCliente ec on pag.id_enderecoCliente = ec.id_enderecoCliente
left join Endereco end on ec.CEP = end.CEP;

-- --------------------------------------------------------
-- 4. CONFERÊNCIA GERAL DE DADOS (SELECT * FROM EM TODAS AS TABELAS)
-- --------------------------------------------------------
select * from Endereco;
select * from Cliente;
select * from EnderecoCliente;
select * from Fornecedor;
select * from EmpresaParceira;
select * from Categoria;
select * from Subcategoria;
select * from Produto;
select * from Estoque;
select * from Avaliacao;
select * from Carrinho;
select * from ItensCarrinho;
select * from Pedido;
select * from ItemPedido;
select * from HistoricoPedido;
select * from Pagamento;
select * from Entrega;
select * from Movimentacao;
select * from Devolucao;
select * from ItensDevolucao;
select * from Estorno;