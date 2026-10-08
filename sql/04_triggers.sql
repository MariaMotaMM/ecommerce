use ecommerce;

delimiter //

create trigger trg_itemPedido_saidaEstoque
before insert on ItemPedido
for each row
begin
    declare v_idEstoque int;
    declare v_quantidadeAtual int;

    if NEW.quantidade_vendida <= 0 then
        signal sqlstate '45000' set message_text = 'A quantidade vendida deve ser maior que zero';
    end if;

    select id_estoque, quantidadeAtual into v_idEstoque, v_quantidadeAtual
    from Estoque where id_produto = NEW.id_produto;

    if v_quantidadeAtual < NEW.quantidade_vendida then
        signal sqlstate '45000' set message_text = 'Estoque insuficiente para realizar a venda';
    end if;

    update Estoque
    set quantidadeAtual = quantidadeAtual - NEW.quantidade_vendida
    where id_produto = NEW.id_produto;

    insert into Movimentacao (tipo, id_estoque, descricao, observacao, dataHoraMovimentacao, quantidade)
    values ('saida', v_idEstoque, 'Venda', 'Saida de estoque referente a uma venda', now(), NEW.quantidade_vendida);
end //

create trigger trg_itensDevolucao_entradaEstoque
after insert on ItensDevolucao
for each row
begin
    declare v_idEstoque int;

    if NEW.quantidade <= 0 then
        signal sqlstate '45000' set message_text = 'A quantidade devolvida deve ser maior que zero';
    end if;

    select id_estoque into v_idEstoque
    from Estoque where id_produto = NEW.id_produto;

    update Estoque
    set quantidadeAtual = quantidadeAtual + NEW.quantidade
    where id_produto = NEW.id_produto;

    insert into Movimentacao (tipo, id_estoque, descricao, observacao, dataHoraMovimentacao, quantidade)
    values ('entrada', v_idEstoque, 'Estorno', 'Entrada de estoque referente a uma devolucao', now(), NEW.quantidade);
end //

delimiter ;