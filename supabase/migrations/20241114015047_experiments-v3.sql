create table "public"."experiment_output" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone not null default now(),
    "input_record_id" uuid,
    "request_id" uuid,
    "prompt_version_id" uuid,
    "experiment_id" uuid,
    "is_original" boolean not null default false
);


alter table "public"."experiment_output" enable row level security;

REVOKE ALL ON TABLE "public"."experiment_output" FROM anon, authenticated, public;

create table "public"."experiment_v3" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "name" character varying not null,
    "original_prompt_version" uuid not null,
    "organization" uuid not null,
    "input_keys" text[] default '{}'::text[],
    "copied_original_prompt_version" uuid
);


alter table "public"."experiment_v3" enable row level security;

REVOKE ALL ON TABLE "public"."experiment_v3" FROM anon, authenticated, public;

alter table "public"."prompt_input_record" add column "experiment_id" uuid;

alter table "public"."prompts_versions" add column "experiment_id" uuid;

CREATE UNIQUE INDEX experiment_output_pkey ON public.experiment_output USING btree (id);

CREATE UNIQUE INDEX experiment_v3_pkey ON public.experiment_v3 USING btree (id);

CREATE UNIQUE INDEX experiment_output_experiment_id_input_record_id_prompt_version_id_key ON public.experiment_output USING btree (experiment_id, input_record_id, prompt_version_id);

alter table "public"."experiment_output" add constraint "experiment_output_pkey" PRIMARY KEY using index "experiment_output_pkey";

alter table "public"."experiment_v3" add constraint "experiment_v3_pkey" PRIMARY KEY using index "experiment_v3_pkey";

alter table "public"."experiment_output" add constraint "public_experiment_output_experiment_id_fkey" FOREIGN KEY (experiment_id) REFERENCES experiment_v3(id) not valid;

alter table "public"."experiment_output" validate constraint "public_experiment_output_experiment_id_fkey";

alter table "public"."experiment_output" add constraint "public_experiment_output_input_record_id_fkey" FOREIGN KEY (input_record_id) REFERENCES prompt_input_record(id) not valid;

alter table "public"."experiment_output" validate constraint "public_experiment_output_input_record_id_fkey";

alter table "public"."experiment_output" add constraint "public_experiment_output_prompt_version_id_fkey" FOREIGN KEY (prompt_version_id) REFERENCES prompts_versions(id) not valid;

alter table "public"."experiment_output" validate constraint "public_experiment_output_prompt_version_id_fkey";

alter table "public"."experiment_output" add constraint "public_experiment_output_request_id_fkey" FOREIGN KEY (request_id) REFERENCES request(id) not valid;

alter table "public"."experiment_output" validate constraint "public_experiment_output_request_id_fkey";

alter table "public"."experiment_v3" add constraint "public_experiment_v3_original_prompt_version_fkey" FOREIGN KEY (original_prompt_version) REFERENCES prompts_versions(id) not valid;

alter table "public"."experiment_v3" validate constraint "public_experiment_v3_original_prompt_version_fkey";

alter table "public"."prompt_input_record" add constraint "public_prompt_input_record_experiment_id_fkey" FOREIGN KEY (experiment_id) REFERENCES experiment_v3(id) not valid;

alter table "public"."prompt_input_record" validate constraint "public_prompt_input_record_experiment_id_fkey";

alter table "public"."prompts_versions" add constraint "public_prompts_versions_experiment_id_fkey" FOREIGN KEY (experiment_id) REFERENCES experiment_v3(id) not valid;

alter table "public"."prompts_versions" validate constraint "public_prompts_versions_experiment_id_fkey";


alter table "public"."experiment_v3" add constraint "public_experiment_v3_organization_fkey" FOREIGN KEY (organization) REFERENCES organization(id) not valid;

alter table "public"."experiment_v3" validate constraint "public_experiment_v3_organization_fkey"



alter table "public"."experiment_v3" add constraint "public_experiment_v3_copied_original_prompt_version_fkey" FOREIGN KEY (copied_original_prompt_version) REFERENCES prompts_versions(id) not valid;

alter table "public"."experiment_v3" validate constraint "public_experiment_v3_copied_original_prompt_version_fkey";

alter table "public"."prompts_versions" add column "parent_prompt_version" uuid;

alter table "public"."prompts_versions" add constraint "public_prompts_versions_parent_prompt_version_fkey" FOREIGN KEY (parent_prompt_version) REFERENCES prompts_versions(id) not valid;

alter table "public"."prompts_versions" validate constraint "public_prompts_versions_parent_prompt_version_fkey";

