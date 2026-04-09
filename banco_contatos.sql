-- Criação do banco
CREATE DATABASE IF NOT EXISTS agenda;
USE agenda;

-- Criação da tabela
CREATE TABLE IF NOT EXISTS contatos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserção de dados de exemplo
INSERT INTO contatos (nome, telefone) VALUES
('João Silva', '(11) 9 1234-5678'),
('Maria Oliveira', '(21) 9 2345-6789'),
('Carlos Souza', '(31) 9 3456-7890'),
('Ana Santos', '(41) 9 4567-8901'),
('Pedro Lima', '(51) 9 5678-9012'),
('Fernanda Costa', '(61) 9 6789-0123'),
('Lucas Pereira', '(71) 9 7890-1234'),
('Juliana Alves', '(81) 9 8901-2345'),
('Rafael Gomes', '(91) 9 9012-3456'),
('Camila Rocha', '(19) 9 1122-3344');