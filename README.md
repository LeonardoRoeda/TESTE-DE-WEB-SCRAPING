
# Web Scraper

Esse projeto foi desenvolvido em Java para baixar e processar arquivos relacionados à atualização do Rol de Procedimentos da Agência Nacional de Saúde Suplementar (ANS).

# Funcionalidades

-Raspagem de arquivos PDF 

-Download automático dos    documentos

-Compactação dos arquivos em formato ZIP

-Conversão de PDF para CSV

-Verificação de disponibilidade da página


# Bibliotecas utilizadas
-Jsoup (para parsing HTML e web scraping)

-Java Standard Library (para operações de rede e arquivos)


# Estrutura de arquivos
-downloads/: Pasta onde os arquivos serão baixados

-anexos.zip: Arquivo compactado com todos os PDFs baixados

-procedimentos.csv: Arquivo CSV gerado (se implementado)

-csv_anexos.zip: Arquivo compactado com o CSV (se implementado)

# Tecnologias para a conversão  PDF para CSV
Tabula: Extração de tabelas de PDFs

OpenCSV: Geração de arquivos CSV

PDFBox: Manipulação básica de PDFs
