-- Steelcon | Gestión de Envíos y Retiros
-- Ejecutar en Supabase > SQL Editor. RLS limita lectura/escritura a usuarios autenticados.
create extension if not exists pgcrypto;

create table if not exists public.movimientos (
  id uuid primary key default gen_random_uuid(),
  folio text not null unique,
  tipo text not null check (tipo in ('Envío','Retiro')),
  fecha date not null default current_date,
  prioridad text not null default 'Normal' check (prioridad in ('Normal','Urgente')),
  origen text not null default '',
  destino text not null default '',
  solicitante text not null default '',
  sector text not null default '',
  responsable_logistica text not null default '',
  transporte text not null default 'Propio' check (transporte in ('Propio','Externo')),
  vehiculo text not null default '',
  matricula text not null default '',
  conductor text not null default '',
  estado text not null default 'Pendiente' check (estado in ('Pendiente','Autorizado','En tránsito','Completado','Cancelado')),
  items jsonb not null default '[]'::jsonb,
  observaciones text not null default '',
  salida timestamptz,
  llegada timestamptz,
  recibido_por text not null default '',
  referencia text not null default '',
  archived boolean not null default false,
  created_by uuid references auth.users(id) on delete set null default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists movimientos_fecha_idx on public.movimientos(fecha desc);
create index if not exists movimientos_estado_idx on public.movimientos(estado);
create index if not exists movimientos_archived_idx on public.movimientos(archived);

create table if not exists public.vehiculos (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  matricula text not null default '',
  tipo text not null default 'Propio' check (tipo in ('Propio','Externo')),
  conductor text not null default '',
  transportista text not null default '',
  activo boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.movimientos enable row level security;
alter table public.vehiculos enable row level security;
drop policy if exists "auth_movimientos_select" on public.movimientos;
drop policy if exists "auth_movimientos_insert" on public.movimientos;
drop policy if exists "auth_movimientos_update" on public.movimientos;
drop policy if exists "auth_movimientos_delete" on public.movimientos;
drop policy if exists "auth_vehiculos_all" on public.vehiculos;
create policy "auth_movimientos_select" on public.movimientos for select to authenticated using (true);
create policy "auth_movimientos_insert" on public.movimientos for insert to authenticated with check (true);
create policy "auth_movimientos_update" on public.movimientos for update to authenticated using (true) with check (true);
create policy "auth_movimientos_delete" on public.movimientos for delete to authenticated using (true);
create policy "auth_vehiculos_all" on public.vehiculos for all to authenticated using (true) with check (true);

-- Permisos SQL para usuarios autenticados; RLS sigue filtrando el acceso.
grant usage on schema public to authenticated;
grant select, insert, update, delete on public.movimientos to authenticated;
grant select, insert, update, delete on public.vehiculos to authenticated;
revoke all on public.movimientos from anon;
revoke all on public.vehiculos from anon;

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$ begin new.updated_at = now(); return new; end; $$;
drop trigger if exists movimientos_updated_at on public.movimientos;
create trigger movimientos_updated_at before update on public.movimientos for each row execute function public.set_updated_at();
