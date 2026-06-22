BEGIN;

CREATE TABLE IF NOT EXISTS source_import_staging (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

  title text,
  url text,
  source_type text,
  notes text,

  imported_at timestamptz NOT NULL DEFAULT now(),
  reviewed boolean NOT NULL DEFAULT false,
  review_notes text
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_sources_unique_url
  ON sources (lower(url))
  WHERE url IS NOT NULL;

COMMIT;
