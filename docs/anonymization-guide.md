# Guia de anonimização para exemplos de BI

Use este guia antes de publicar consultas, relatórios, dashboards, prints ou códigos derivados de projetos reais.

## O que remover ou trocar

| Tipo de informação | Ação recomendada | Exemplo seguro |
| --- | --- | --- |
| Nome de empresa | Trocar por termos genéricos | `Empresa A`, `organização`, `unidade` |
| Nome de cliente | Gerar identificador fictício | `cliente_001`, `cliente_anonimo` |
| CPF, CNPJ, RG ou documento | Remover ou mascarar irreversivelmente | `***.***.***-**` |
| E-mail e telefone | Remover | `contato_removido` |
| Endereço | Generalizar | `regiao_sul`, `cidade_ficticia` |
| Valor financeiro real | Normalizar ou sintetizar | `valor_indice`, `receita_simulada` |
| Regras comerciais sensíveis | Descrever em alto nível | `regra de elegibilidade genérica` |
| Conexão de banco | Remover completamente | usar variáveis de ambiente em documentação |

## Estratégia recomendada

1. **Classifique o artefato**: consulta, relatório, screenshot, código, exportação ou documentação.
2. **Remova identificadores diretos**: nomes, documentos, e-mails, telefones e IDs reais.
3. **Generalize contexto de negócio**: troque nomes internos por conceitos como `pedido`, `evento`, `ticket`, `produto` e `canal`.
4. **Substitua dados por sintéticos**: gere amostras que preservem a lógica analítica sem representar pessoas reais.
5. **Revise metadados**: verifique comentários, nomes de arquivos, propriedades de relatórios e parâmetros ocultos.
6. **Faça uma leitura final**: confirme que o material pode ser entendido sem expor informações confidenciais.

## Checklist antes de commitar

- [ ] Não há dados pessoais identificáveis.
- [ ] Não há nome de empresa, cliente, fornecedor ou sistema interno.
- [ ] Não há credenciais, URLs internas ou strings de conexão.
- [ ] Os exemplos usam nomenclatura genérica.
- [ ] Os valores são sintéticos, normalizados ou fictícios.
- [ ] O arquivo pode ser compartilhado publicamente sem contexto confidencial.
