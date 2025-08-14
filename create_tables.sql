-- SQL para criar tabelas necessárias no Supabase (execute no SQL Editor do Supabase)
-- Tabela de usuários (metadados)
create table if not exists public.usuarios (
  id bigserial primary key,
  user_id uuid,
  email text,
  localidade text,
  created_at timestamptz default now()
);

-- Tabela de registros de ponto
create table if not exists public.registros (
  id bigserial primary key,
  user_id uuid,
  email text,
  latitude double precision,
  longitude double precision,
  horario timestamptz,
  localidade_cadastro text,
  created_at timestamptz default now()
);

-- Índices úteis
create index if not exists idx_registros_user_horario on public.registros (user_id, horario desc);
