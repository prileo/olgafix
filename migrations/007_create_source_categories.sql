BEGIN;

-- ------------------------------------------------------------
-- Source browse categories
-- ------------------------------------------------------------

CREATE TABLE source_categories (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

  name text NOT NULL,
  slug text NOT NULL,
  description text,

  sort_order integer NOT NULL DEFAULT 1000,
  is_active boolean NOT NULL DEFAULT true,

  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT source_categories_name_not_blank
    CHECK (length(trim(name)) > 0),

  CONSTRAINT source_categories_slug_not_blank
    CHECK (length(trim(slug)) > 0),

  CONSTRAINT source_categories_name_unique
    UNIQUE (name),

  CONSTRAINT source_categories_slug_unique
    UNIQUE (slug)
);

CREATE TRIGGER trg_source_categories_set_updated_at
BEFORE UPDATE ON source_categories
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ------------------------------------------------------------
-- Source-category links
-- ------------------------------------------------------------

CREATE TABLE source_category_links (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

  source_id integer NOT NULL
    REFERENCES sources(id)
    ON DELETE CASCADE,

  category_id integer NOT NULL
    REFERENCES source_categories(id)
    ON DELETE CASCADE,

  confidence text NOT NULL DEFAULT 'medium',
  assigned_by text NOT NULL DEFAULT 'manual',
  notes text,

  created_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT source_category_links_confidence_valid
    CHECK (confidence IN ('low', 'medium', 'high')),

  CONSTRAINT source_category_links_assigned_by_valid
    CHECK (assigned_by IN ('manual', 'rule', 'import', 'review')),

  CONSTRAINT source_category_links_unique
    UNIQUE (source_id, category_id)
);


-- ------------------------------------------------------------
-- Helpful indexes
-- ------------------------------------------------------------

CREATE INDEX idx_source_categories_slug
  ON source_categories (slug);

CREATE INDEX idx_source_categories_active
  ON source_categories (is_active);

CREATE INDEX idx_source_category_links_source_id
  ON source_category_links (source_id);

CREATE INDEX idx_source_category_links_category_id
  ON source_category_links (category_id);

CREATE INDEX idx_source_category_links_confidence
  ON source_category_links (confidence);

COMMIT;