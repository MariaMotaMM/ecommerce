use ecommerce;

-- Visão de situação de estoque
create or replace view vw_produtos_estoque as
select
    p.descricao,
    p.marca,
    c.nome as nomeCategoria,
    s.nome as nomeSubcategoria,
    e.quantidadeAtual,
    e.quantidadeMinima,
    case
        when e.quantidadeAtual <= e.quantidadeMinima then 'Estoque baixo'
        else 'Estoque normal'
    end as situacaoEstoque
from Categoria c
inner join Subcategoria s on c.id_categoria = s.id_categoria
inner join Produto p on p.id_subcategoria = s.id_subcategoria
inner join Estoque e on p.id_produto = e.id_produto;

-- Visão de total de vendas por produto
create or replace view vw_vendas_por_produtos as
select
    p.descricao,
    sum(ip.quantidade_vendida) as quantidadeVendida,
    sum(ip.quantidade_vendida * ip.precoUnitario) as valorTotalVendas
from Produto p
inner join ItemPedido ip on ip.id_produto = p.id_produto
group by p.id_produto, p.descricao;

-- Visão de total de compras por cliente
create or replace view vw_clientes_compras as
select
    c.nome as nomeCliente,
    c.CPF,
    count(p.id_pedido) as quantidadePedidos,
    sum(p.valorTotVenda) as valorTotal
from Cliente c
inner join Pedido p on c.CPF = p.CPF
group by c.CPF, c.nome;

-- Visão de acompanhamento de devoluções e estornos
create or replace view vw_devolucao_estorno as
select
    c.nome as nomeCliente,
    ped.id_pedido,
    prod.descricao,
    itemDev.quantidade,
    d.dataDevolucao,
    est.valor as valorEstornado,
    (pag.valor - est.valor) as diferencaValor,
    est.dataEstorno,
    est.motivo
from Cliente c
inner join Pedido ped on c.CPF = ped.CPF
inner join Devolucao d on ped.id_pedido = d.id_pedido
inner join ItensDevolucao itemDev on itemDev.id_devolucao = d.id_devolucao
inner join Produto prod on prod.id_produto = itemDev.id_produto
inner join Estorno est on d.id_devolucao = est.id_devolucao
inner join Pagamento pag on pag.id_pagamento = est.id_pagamento;