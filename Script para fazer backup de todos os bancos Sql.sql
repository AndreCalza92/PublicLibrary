DECLARE @name VARCHAR(50) -- variável para o nome dos bancos de dados  
DECLARE @path VARCHAR(256) -- Diretório de backup  
DECLARE @fileName VARCHAR(256) -- Variavel para o nome do arquivo de backup  
DECLARE @fileDate VARCHAR(20) -- Variavel para guardar a data utilizada no nome do backup

 
-- Definir em qual diretório serão feitos os Backups
SET @path = 'C:\Backup\'  

 
-- Definir o formato da data
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 

 -- Selecionar todos os bancos na instancia
DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb')  -- excluir os bancos que estiver aqui, por padrão não fazemos backup dos bancos padrões do Sql

 
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   

 
WHILE @@FETCH_STATUS = 0   
BEGIN   
       SET @fileName = @path + @name + '_' + @fileDate + '.BAK'  -- Diretorio + Nome do banco + _Data do backup + .BAK
       BACKUP DATABASE @name TO DISK = @fileName  -- comando que realiza o backup

 
       FETCH NEXT FROM db_cursor INTO @name   -- aponta para o proximo banco a ser feito o backup
END   

 
CLOSE db_cursor   
DEALLOCATE db_cursor