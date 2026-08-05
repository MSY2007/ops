-- Run this in Supabase SQL Editor. If you already ran the earlier "measurements"-only
-- version, drop it first (it's superseded by this generic table):
--   drop table if exists measurements;

create table records (
  bucket text not null,
  id text not null,
  user_id uuid not null default auth.uid() references auth.users(id),
  data jsonb not null,
  ts bigint not null,
  updated_at timestamptz default now(),
  primary key (user_id, bucket, id)
);

alter table records enable row level security;

create policy "own rows only" on records
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create index records_user_bucket_idx on records (user_id, bucket);
