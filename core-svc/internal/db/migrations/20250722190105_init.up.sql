create EXTENSION if not exists "uuid-ossp";

-- USERS --------------------------------------------------------------------
create table app_user (
                          id          uuid primary key default uuid_generate_v4(),
                          email       text unique not null,
                          created_at  timestamptz default now()
);

-- LOOKUP -------------------------------------------------------------------
create table exercise (
                          id    smallint primary key,            -- 1-5 push-up, pull-up, …
                          name  varchar(100) not null
);

-- WORKOUT ------------------------------------------------------------------
create table workout (
                         id         uuid primary key default uuid_generate_v4(),
                         user_id    uuid not null references app_user(id),

                         started_at timestamptz default now(),
                         ended_at   timestamptz                    -- NULL ⇒ in-progress
);

-- WORKOUT_SET --------------------------------------------------------------
DROP TYPE IF EXISTS workout_set_status;
create type  workout_set_status as enum ('ACTIVE', 'DONE', 'ABORTED');

create table workout_set (
                             id           uuid primary key default uuid_generate_v4(),
                             workout_id   uuid not null references workout(id),
                             exercise_id  smallint not null references exercise(id),

                             cxx_pod      text,                       -- hostname / gRPC addr
                             expires_at   timestamptz,                -- 5-min TTL, nullable
                             started_at   timestamptz default now(),
                             ended_at     timestamptz,
                             status       workout_set_status  NOT NULL default 'ACTIVE'
);

create index workout_set_workout_started_idx
    on workout_set (workout_id, started_at desc);

-- REP ----------------------------------------------------------------------
create table rep (
                     id            uuid primary key default uuid_generate_v4(),
                     workout_set_id uuid not null references workout_set(id) on delete cascade,
                     rep_index     smallint not null,           -- starts at 1
                     quality_score numeric(4,2),               -- 0-10
                     done_at       timestamptz default now(),
                     constraint uniq_rep_per_set
                         unique (workout_set_id, rep_index)
);

create index rep_set_idx on rep (workout_set_id);

-- REFRESH TOKENS -----------------------------------------------------------
create table refresh_token (
                               token       text primary key,
                               user_id     uuid not null references app_user(id),
                               issued_at   timestamptz default now(),
                               expires_at  timestamptz,
                               user_agent  text
);

create index refresh_token_user_idx on refresh_token (user_id);
