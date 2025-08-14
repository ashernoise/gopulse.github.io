Projeto completo gerado com integração básica ao Supabase.
Arquivos incluídos:
  - index.html (login)
  - cadastro.html (registro de usuário, inclui campo localidade)
  - inicio.html (registro de ponto com geolocalização e regra 30 minutos)
  - relatorios.html (lista de registros do usuário)
  - opcoes.html (alterar senha e localidade)
  - supabase.js (configuração do cliente Supabase)
  - create_tables.sql (script SQL para criar as tabelas no Supabase)
  - style.css (seu CSS original copiado)

Passos para usar:
  1. No painel do Supabase, execute o arquivo create_tables.sql no SQL Editor para criar as tabelas.
  2. Ative o projeto e verifique as policies (RLS) – para testes, você pode desativar RLS para as tabelas ou criar policies permitindo inserts/selects para o usuário autenticado.
  3. Coloque estes arquivos em um servidor estático (ou abra index.html localmente). O supabase.js já contém a URL e chave anon informadas.
  4. Ao cadastrar, será criado um usuário no Auth e um registro na tabela 'usuarios' com a localidade.
  5. Na página inicio.html, clique em 'Registrar ponto' e permita o uso da localização no navegador.
  6. Em relatorios.html você verá a listagem dos seus registros.
  7. Em opcoes.html você pode alterar a senha (updateUser) e mudar a localidade (atualiza tabela usuarios).

Observações de segurança:
  - A chave anon é pública por design, mas evite compartilhá-la em repositórios públicos sem proteção adicional.
  - Para produção, revise as Row-Level Security (RLS) e policies no Supabase para proteger dados.
