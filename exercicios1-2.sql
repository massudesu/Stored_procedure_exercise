-- Exercicio 1 
DELIMITER //
CREATE PROCEDURE atualizar_preco_categoria(
    IN p_id_categoria INT,
    IN p_percentual DECIMAL(5,2),
    OUT p_quantidade_alterada INT,
    OUT p_mensagem VARCHAR(255)
)
BEGIN
    DECLARE v_categoria_existe INT DEFAULT 0;

    SET p_quantidade_alterada = 0;

    SELECT COUNT(*)
    INTO v_categoria_existe
    FROM categorias
    WHERE id_categoria = p_id_categoria;

    IF v_categoria_existe = 0 THEN
        SET p_mensagem = 'ERRO: Categoria não encontrada.';

    ELSEIF p_percentual IS NULL THEN
        SET p_mensagem = 'ERRO: O percentual não pode ser NULL.';

    ELSEIF p_percentual < -50 THEN
        SET p_mensagem = 'ERRO: Desconto máximo permitido é 50%.';

    ELSEIF p_percentual > 100 THEN
        SET p_mensagem = 'ERRO: Aumento máximo permitido é 100%.';

    ELSEIF p_percentual = 0 THEN
        SET p_mensagem = 'Nenhum ajuste realizado. Percentual igual a zero.';

    ELSE
        UPDATE produtos
        SET preco = preco + (preco * p_percentual / 100)
        WHERE id_categoria = p_id_categoria
          AND ativo = TRUE;

        SET p_quantidade_alterada = ROW_COUNT();

        SET p_mensagem = CONCAT(
            'Preços atualizados com sucesso! ',
            p_quantidade_alterada,
            ' produto(s) alterado(s).'
        );
    END IF;

    INSERT INTO log_operacoes (
        tabela_afetada,
        operacao,
        descricao
    )
    VALUES (
        'produtos',
        'UPDATE',
        CONCAT(
            'Atualização de preços da categoria ',
            p_id_categoria,
            '. Percentual: ',
            IFNULL(p_percentual, 0),
            '%. Resultado: ',
            p_mensagem
        )
    );

END //

DELIMITER ;

CALL atualizar_preco_categoria(3, 10, @quantidade, @mensagem);

CALL atualizar_preco_categoria(3, -20, @quantidade, @mensagem);

CALL atualizar_preco_categoria(3, -60, @quantidade, @mensagem);

CALL atualizar_preco_categoria(3, 0, @quantidade, @mensagem);

CALL atualizar_preco_categoria(99, 10, @quantidade, @mensagem);

SELECT @quantidade AS produtos_alterados,
       @mensagem AS resultado;
       


-- Exercicio 2 
DELIMITER //

CREATE PROCEDURE consultar_extrato_cliente(
    IN p_id_cliente INT
)
BEGIN
    DECLARE v_cliente_existe INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_cliente_existe
    FROM clientes
    WHERE id_cliente = p_id_cliente;

    IF v_cliente_existe = 0 THEN

        SELECT 'ERRO: Cliente não encontrado.' AS mensagem;

    ELSE

        SELECT
            nome,
            email,
            telefone,
            criado_em AS data_cadastro
        FROM clientes
        WHERE id_cliente = p_id_cliente;

        SELECT
            id_pedido AS numero_pedido,
            data_pedido,
            status,
            valor_total
        FROM pedidos
        WHERE id_cliente = p_id_cliente
        ORDER BY data_pedido DESC;

        SELECT
            COUNT(*) AS total_pedidos,

            SUM(
                CASE
                    WHEN status <> 'cancelado'
                    THEN valor_total
                    ELSE 0
                END
            ) AS valor_total_gasto,

            AVG(
                CASE
                    WHEN status <> 'cancelado'
                    THEN valor_total
                    ELSE NULL
                END
            ) AS ticket_medio,

            MAX(data_pedido) AS ultimo_pedido

        FROM pedidos
        WHERE id_cliente = p_id_cliente;

    END IF;

END //

DELIMITER ;

CALL consultar_extrato_cliente(1);
CALL consultar_extrato_cliente(99);