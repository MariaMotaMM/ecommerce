use ecommerce;

delimiter //

create procedure alterarPreco(
    in idDoProduto int,
    in novoPreco decimal(10,2)
)
begin
    update Produto
    set valorVenda = novoPreco
    where id_produto = idDoProduto;
end //

create procedure entradaEstoqueCompra(
    in produto_id int,
    in quantidadeEntrada int
)
begin
    declare v_id_estoque int;

    if quantidadeEntrada <= 0 then
        signal sqlstate '45000' set message_text = 'A quantidade de entrada deve ser maior que zero';
    end if;

    select id_estoque into v_id_estoque from Estoque where id_produto = produto_id;

    update Estoque
    set quantidadeAtual = quantidadeAtual + quantidadeEntrada
    where id_produto = produto_id;

    insert into Movimentacao (tipo, id_estoque, descricao, observacao, dataHoraMovimentacao, quantidade)
    values ('entrada', v_id_estoque, 'Compra', 'Realizacao de compra', now(), quantidadeEntrada);
end //

create procedure saidaEstoqueAvarias(
    in produto_id int,
    in quantidadeSaida int
)
begin
    declare v_id_estoque int;
    declare v_quantidadeAtual int;

    if quantidadeSaida <= 0 then
        signal sqlstate '45000' set message_text = 'A quantidade de saída deve ser maior que zero';
    end if;

    select id_estoque, quantidadeAtual into v_id_estoque, v_quantidadeAtual
    from Estoque where id_produto = produto_id;

    if v_quantidadeAtual < quantidadeSaida then
        signal sqlstate '45000' set message_text = 'Estoque insuficiente para registrar a avaria';
    end if;

    update Estoque
    set quantidadeAtual = quantidadeAtual - quantidadeSaida
    where id_produto = produto_id;

    insert into Movimentacao (tipo, id_estoque, descricao, observacao, dataHoraMovimentacao, quantidade)
    values ('saida', v_id_estoque, 'Avarias', 'Produto com avaria', now(), quantidadeSaida);
end //

create procedure saidaEstoqueFurto(
    in produto_id int,
    in quantidadeSaida int
)
begin
    declare v_id_estoque int;
    declare v_quantidadeAtual int;

    if quantidadeSaida <= 0 then
        signal sqlstate '45000' set message_text = 'A quantidade de saída deve ser maior que zero';
    end if;

    select id_estoque, quantidadeAtual into v_id_estoque, v_quantidadeAtual
    from Estoque where id_produto = produto_id;

    if v_quantidadeAtual < quantidadeSaida then
        signal sqlstate '45000' set message_text = 'Estoque insuficiente para registrar o furto';
    end if;

    update Estoque
    set quantidadeAtual = quantidadeAtual - quantidadeSaida
    where id_produto = produto_id;

    insert into Movimentacao (tipo, id_estoque, descricao, observacao, dataHoraMovimentacao, quantidade)
    values ('saida', v_id_estoque, 'Furto', 'Produto furtado', now(), quantidadeSaida);
end //

create procedure registrarPedido(
    in p_cpf varchar(14),
    in p_valorTotal decimal(10,2),
    in p_desconto decimal(10,2),
    in p_idProduto int,
    in p_quantidade int,
    in p_precoUnitario decimal(10,2)
)
begin
    declare v_id_pedido int;

    if p_quantidade <= 0 then
        signal sqlstate '45000' set message_text = 'A quantidade vendida deve ser maior que zero';
    end if;

    insert into Pedido (cpf, valorTotVenda, desconto, dataPedido)
    values (p_cpf, p_valorTotal, p_desconto, curdate());

    set v_id_pedido = last_insert_id();

    insert into ItemPedido (id_pedido, id_produto, quantidade_vendida, hora_venda, precoUnitario)
    values (v_id_pedido, p_idProduto, p_quantidade, now(), p_precoUnitario);
end //

create procedure registrarDevolucao(
    in p_idPedido int,
    in p_idProduto int,
    in p_quantidade int
)
begin
    declare v_id_devolucao int;

    if p_quantidade <= 0 then
        signal sqlstate '45000' set message_text = 'A quantidade devolvida deve ser maior que zero';
    end if;

    insert into Devolucao (id_pedido, dataDevolucao)
    values (p_idPedido, curdate());

    set v_id_devolucao = last_insert_id();

    insert into ItensDevolucao (id_produto, id_devolucao, quantidade)
    values (p_idProduto, v_id_devolucao, p_quantidade);
end //

delimiter ;