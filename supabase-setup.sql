-- Run this in Supabase SQL Editor for cross-device DSA dashboard sync.
-- The app stores one JSON payload per authenticated user. Row Level Security prevents
-- users from reading or changing another user's progress.

create table if not exists public.dsa_progress (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{"attempts":[],"concepts":[],"reviews":[],"studyDays":[],"settings":{"goalHours":6}}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.dsa_progress enable row level security;

drop policy if exists "Users can read own DSA progress" on public.dsa_progress;
create policy "Users can read own DSA progress"
on public.dsa_progress for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert own DSA progress" on public.dsa_progress;
create policy "Users can insert own DSA progress"
on public.dsa_progress for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update own DSA progress" on public.dsa_progress;
create policy "Users can update own DSA progress"
on public.dsa_progress for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

grant select, insert, update on public.dsa_progress to authenticated;
