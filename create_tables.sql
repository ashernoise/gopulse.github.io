-- PASSO 1: CRIAÇÃO DAS TABELAS
-------------------------------------------------------------------

-- Tabela 1: USUARIOS
-- Armazena os perfis públicos dos usuários, complementando a tabela 'auth.users'.
-- A coluna 'nivel' é crucial para as permissões.
-- Nível 1 = Usuário Padrão (aluno/funcionário)
-- Nível 2 = Supervisor (professor/admin)

CREATE TABLE public.usuarios (
  id UUID PRIMARY KEY NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  nome_completo TEXT,
  email TEXT,
  avatar_url TEXT,
  nivel INT DEFAULT 1 NOT NULL -- Padrão é Nível 1
);
COMMENT ON TABLE public.usuarios IS 'Perfis de usuário para armazenar dados públicos e nível de acesso.';


-- Tabela 2: REGISTROS
-- Armazena os registros de ponto JÁ CONFIRMADOS.

CREATE TABLE public.registros (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id UUID NOT NULL REFERENCES public.usuarios(id) ON DELETE CASCADE,
  email TEXT,
  horario TIMESTAMPTZ NOT NULL DEFAULT now(),
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  localidade TEXT,
  tipo_registro TEXT DEFAULT 'Automático' NOT NULL -- Para diferenciar de registros manuais
);
COMMENT ON TABLE public.registros IS 'Armazena todos os registros de ponto confirmados.';


-- Tabela 3: SOLICITACOES_REGISTRO
-- Armazena os pedidos de registro manual que aguardam aprovação.

CREATE TABLE public.solicitacoes_registro (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  criado_em TIMESTAMPTZ NOT NULL DEFAULT now(),
  solicitante_id UUID NOT NULL REFERENCES public.usuarios(id) ON DELETE CASCADE,
  email_solicitante TEXT,
  horario_solicitado TIMESTAMPTZ NOT NULL,
  localizacao TEXT,
  justificativa TEXT,
  status TEXT NOT NULL DEFAULT 'pendente', -- 'pendente', 'aprovado', 'reprovado'
  aprovador_id UUID REFERENCES public.usuarios(id) ON DELETE SET NULL, -- Quem analisou
  data_acao TIMESTAMPTZ -- Quando foi analisado
);
COMMENT ON TABLE public.solicitacoes_registro IS 'Fluxo de aprovação para registros de ponto manuais.';


-- PASSO 2: FUNÇÕES AUXILIARES
-------------------------------------------------------------------

-- Função 1: CRIAÇÃO AUTOMÁTICA DE PERFIL
-- Esta função é chamada por um gatilho sempre que um novo usuário
-- se cadastra no sistema (na tabela auth.users).

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.usuarios (id, email)
  VALUES (new.id, new.email);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Gatilho (Trigger) que executa a função acima.
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();


-- Função 2: OBTER NÍVEL DO USUÁRIO
-- Função essencial para as políticas de segurança. Retorna o nível
-- do usuário que está fazendo a requisição.

CREATE OR REPLACE FUNCTION public.get_user_nivel()
RETURNS INT AS $$
BEGIN
  RETURN (
    SELECT nivel
    FROM public.usuarios
    WHERE id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- PASSO 3: POLÍTICAS DE SEGURANÇA (ROW LEVEL SECURITY)
-------------------------------------------------------------------

-- Habilitando RLS para todas as tabelas
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.registros ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.solicitacoes_registro ENABLE ROW LEVEL SECURITY;

-- Políticas para a tabela USUARIOS
CREATE POLICY "Usuários podem ver e editar seus próprios perfis"
ON public.usuarios FOR ALL
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Políticas para a tabela REGISTROS (pontos confirmados)
CREATE POLICY "Usuários podem inserir seus próprios registros"
ON public.registros FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Supervisores veem tudo, usuários veem apenas o seu"
ON public.registros FOR SELECT
USING (
  (public.get_user_nivel() = 2) OR (auth.uid() = user_id)
);

-- Políticas para a tabela SOLICITACOES_REGISTRO (pedidos manuais)
CREATE POLICY "Usuários podem criar solicitações para si mesmos"
ON public.solicitacoes_registro FOR INSERT
WITH CHECK (auth.uid() = solicitante_id);

CREATE POLICY "Supervisores veem todas solicitações, usuários veem as suas"
ON public.solicitacoes_registro FOR SELECT
USING (
  (public.get_user_nivel() = 2) OR (auth.uid() = solicitante_id)
);

CREATE POLICY "Supervisores podem atualizar o status das solicitações"
ON public.solicitacoes_registro FOR UPDATE
USING (public.get_user_nivel() = 2);

-- FIM DO SCRIPT
-- =================================================================
