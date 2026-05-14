# Arquivos `.jasper`

Use esta pasta para armazenar relatórios JasperReports compilados a partir dos arquivos `.jrxml` em `reports/jrxml/`.

Recomendações:

- Compile apenas templates genéricos e anonimizados.
- Não inclua conexões de banco, credenciais ou caminhos internos.
- Prefira versionar o `.jrxml` como fonte principal e gerar o `.jasper` durante o build quando possível.
