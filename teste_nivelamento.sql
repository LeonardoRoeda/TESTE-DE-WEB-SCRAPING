
USE teste_nivelamento;

CREATE TABLE operadoras (
    id SERIAL PRIMARY KEY,
    registro_ans VARCHAR(20) UNIQUE NOT NULL,
    cnpj VARCHAR(18) NOT NULL,
    razao_social VARCHAR(255) NOT NULL,
    nome_fantasia VARCHAR(255),
    modalidade VARCHAR(100),
    uf VARCHAR(2),
    municipio VARCHAR(100),
    data_registro DATE
);

CREATE TABLE demonstracoes_contabeis (
    id SERIAL PRIMARY KEY,
    registro_ans VARCHAR(20) NOT NULL,
    data_registro DATE NOT NULL,
    cd_conta_contabil VARCHAR(20) NOT NULL,
    descricao TEXT NOT NULL,
    vl_saldo_inicial NUMERIC(18,2) NOT NULL,
    vl_saldo_final NUMERIC(18,2) NOT NULL,
    FOREIGN KEY (registro_ans) REFERENCES operadoras(registro_ans)
);

LOAD DATA LOCAL INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\1T2023.csv' INTO TABLE demonstracoes_contabeis FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (@data_registro, registro_ans, cd_conta_contabil, descricao, @vl_saldo_inicial, @vl_saldo_final) SET data_registro = STR_TO_DATE(@data_registro, '%Y-%m-%d'), vl_saldo_inicial = REPLACE(@vl_saldo_inicial, ',', '.'), vl_saldo_final = REPLACE(@vl_saldo_final, ',', '.');
LOAD DATA LOCAL INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\2T2023.csv' INTO TABLE demonstracoes_contabeis FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (@data_registro, registro_ans, cd_conta_contabil, descricao, @vl_saldo_inicial, @vl_saldo_final) SET data_registro = STR_TO_DATE(@data_registro, '%Y-%m-%d'), vl_saldo_inicial = REPLACE(@vl_saldo_inicial, ',', '.'), vl_saldo_final = REPLACE(@vl_saldo_final, ',', '.');
LOAD DATA LOCAL INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\3T2023.csv' INTO TABLE demonstracoes_contabeis FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (@data_registro, registro_ans, cd_conta_contabil, descricao, @vl_saldo_inicial, @vl_saldo_final) SET data_registro = STR_TO_DATE(@data_registro, '%Y-%m-%d'), vl_saldo_inicial = REPLACE(@vl_saldo_inicial, ',', '.'), vl_saldo_final = REPLACE(@vl_saldo_final, ',', '.');
LOAD DATA LOCAL INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\4T2023.csv' INTO TABLE demonstracoes_contabeis FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (@data_registro, registro_ans, cd_conta_contabil, descricao, @vl_saldo_inicial, @vl_saldo_final) SET data_registro = STR_TO_DATE(@data_registro, '%Y-%m-%d'), vl_saldo_inicial = REPLACE(@vl_saldo_inicial, ',', '.'), vl_saldo_final = REPLACE(@vl_saldo_final, ',', '.');
LOAD DATA LOCAL INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\1T2024.csv' INTO TABLE demonstracoes_contabeis FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (@data_registro, registro_ans, cd_conta_contabil, descricao, @vl_saldo_inicial, @vl_saldo_final) SET data_registro = STR_TO_DATE(@data_registro, '%Y-%m-%d'), vl_saldo_inicial = REPLACE(@vl_saldo_inicial, ',', '.'), vl_saldo_final = REPLACE(@vl_saldo_final, ',', '.');
LOAD DATA LOCAL INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\2T2024.csv' INTO TABLE demonstracoes_contabeis FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (@data_registro, registro_ans, cd_conta_contabil, descricao, @vl_saldo_inicial, @vl_saldo_final) SET data_registro = STR_TO_DATE(@data_registro, '%Y-%m-%d'), vl_saldo_inicial = REPLACE(@vl_saldo_inicial, ',', '.'), vl_saldo_final = REPLACE(@vl_saldo_final, ',', '.');
LOAD DATA LOCAL INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\3T2024.csv' INTO TABLE demonstracoes_contabeis FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (@data_registro, registro_ans, cd_conta_contabil, descricao, @vl_saldo_inicial, @vl_saldo_final) SET data_registro = STR_TO_DATE(@data_registro, '%Y-%m-%d'), vl_saldo_inicial = REPLACE(@vl_saldo_inicial, ',', '.'), vl_saldo_final = REPLACE(@vl_saldo_final, ',', '.');
LOAD DATA LOCAL INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\4T2024.csv' INTO TABLE demonstracoes_contabeis FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS (@data_registro, registro_ans, cd_conta_contabil, descricao, @vl_saldo_inicial, @vl_saldo_final) SET data_registro = STR_TO_DATE(@data_registro, '%Y-%m-%d'), vl_saldo_inicial = REPLACE(@vl_saldo_inicial, ',', '.'), vl_saldo_final = REPLACE(@vl_saldo_final, ',', '.');

SELECT o.registro_ans, o.razao_social, SUM(d.vl_saldo_final - d.vl_saldo_inicial) AS total_despesas
FROM demonstracoes_contabeis d
JOIN operadoras o ON d.registro_ans = o.registro_ans
WHERE d.data_registro >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
AND d.cd_conta_contabil LIKE '123911%'
GROUP BY o.registro_ans, o.razao_social
ORDER BY total_despesas DESC
LIMIT 10;

SELECT o.registro_ans, o.razao_social, SUM(d.vl_saldo_final - d.vl_saldo_inicial) AS total_despesas
FROM demonstracoes_contabeis d
JOIN operadoras o ON d.registro_ans = o.registro_ans
WHERE d.data_registro >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
AND d.cd_conta_contabil LIKE '123911%'
GROUP BY o.registro_ans, o.razao_social
ORDER BY total_despesas DESC
LIMIT 10;
