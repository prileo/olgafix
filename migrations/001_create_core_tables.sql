BEGIN;

-- ----------------------------
-- Utility trigger function
-- ----------------------------

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ----------------------------
-- Solutions
-- ----------------------------

CREATE TABLE solutions (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

  title text NOT NULL,
  summary text,
  body text,

  solution_type text NOT NULL,
  cost_level text,
  effort_level text,
  technical_level text,
  reversibility text,

  status text NOT NULL DEFAULT 'draft',

  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT solutions_title_not_blank
    CHECK (length(trim(title)) > 0),

  CONSTRAINT solutions_solution_type_not_blank
    CHECK (length(trim(solution_type)) > 0),

  CONSTRAINT solutions_status_valid
    CHECK (status IN ('draft', 'review', 'published', 'archived')),

  CONSTRAINT solutions_cost_level_valid
    CHECK (
      cost_level IS NULL
      OR cost_level IN ('free', 'low', 'moderate', 'high', 'unknown')
    ),

  CONSTRAINT solutions_effort_level_valid
    CHECK (
      effort_level IS NULL
      OR effort_level IN ('low', 'moderate', 'high', 'unknown')
    ),

  CONSTRAINT solutions_technical_level_valid
    CHECK (
      technical_level IS NULL
      OR technical_level IN ('low', 'moderate', 'high', 'unknown')
    ),

  CONSTRAINT solutions_reversibility_valid
    CHECK (
      reversibility IS NULL
      OR reversibility IN ('easy', 'moderate', 'difficult', 'irreversible', 'unknown')
    )
);

CREATE TRIGGER trg_solutions_set_updated_at
BEFORE UPDATE ON solutions
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ----------------------------
-- Dimensions
-- ----------------------------

CREATE TABLE dimensions (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

  name text NOT NULL,
  dimension_type text NOT NULL,
  description text,

  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT dimensions_name_not_blank
    CHECK (length(trim(name)) > 0),

  CONSTRAINT dimensions_type_not_blank
    CHECK (length(trim(dimension_type)) > 0),

  CONSTRAINT dimensions_name_type_unique
    UNIQUE (name, dimension_type)
);

CREATE TRIGGER trg_dimensions_set_updated_at
BEFORE UPDATE ON dimensions
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ----------------------------
-- Solution fit rules
-- ----------------------------

CREATE TABLE solution_fit_rules (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

  solution_id integer NOT NULL
    REFERENCES solutions(id)
    ON DELETE CASCADE,

  relation text NOT NULL,

  dimension_id integer NOT NULL
    REFERENCES dimensions(id)
    ON DELETE RESTRICT,

  strength text NOT NULL DEFAULT 'moderate',
  confidence text NOT NULL DEFAULT 'medium',

  notes text,

  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT solution_fit_rules_relation_valid
    CHECK (
      relation IN (
        'supports',
        'requires',
        'poor_fit_for',
        'caution_for',
        'works_well_with',
        'conflicts_with',
        'alternative_to'
      )
    ),

  CONSTRAINT solution_fit_rules_strength_valid
    CHECK (strength IN ('weak', 'moderate', 'strong')),

  CONSTRAINT solution_fit_rules_confidence_valid
    CHECK (confidence IN ('low', 'medium', 'high')),

  CONSTRAINT solution_fit_rules_unique
    UNIQUE (solution_id, relation, dimension_id)
);

CREATE TRIGGER trg_solution_fit_rules_set_updated_at
BEFORE UPDATE ON solution_fit_rules
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ----------------------------
-- Sources
-- ----------------------------

CREATE TABLE sources (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

  title text NOT NULL,
  url text,
  source_type text NOT NULL DEFAULT 'note',
  notes text,

  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT sources_title_not_blank
    CHECK (length(trim(title)) > 0),

  CONSTRAINT sources_source_type_valid
    CHECK (
      source_type IN (
        'note',
        'lived_experience',
        'professional_experience',
        'manual',
        'article',
        'product_page',
        'research',
        'video',
        'other'
      )
    )
);

CREATE TRIGGER trg_sources_set_updated_at
BEFORE UPDATE ON sources
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ----------------------------
-- Entity-source links
-- ----------------------------

CREATE TABLE entity_sources (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

  entity_type text NOT NULL,
  entity_id integer NOT NULL,

  source_id integer NOT NULL
    REFERENCES sources(id)
    ON DELETE CASCADE,

  notes text,

  created_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT entity_sources_entity_type_valid
    CHECK (
      entity_type IN (
        'solution',
        'dimension',
        'solution_fit_rule',
        'search_term'
      )
    ),

  CONSTRAINT entity_sources_unique
    UNIQUE (entity_type, entity_id, source_id)
);


-- ----------------------------
-- Search terms
-- ----------------------------

CREATE TABLE search_terms (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

  entity_type text NOT NULL,
  entity_id integer NOT NULL,

  term text NOT NULL,
  term_type text NOT NULL DEFAULT 'synonym',

  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT search_terms_entity_type_valid
    CHECK (
      entity_type IN (
        'solution',
        'dimension'
      )
    ),

  CONSTRAINT search_terms_term_not_blank
    CHECK (length(trim(term)) > 0),

  CONSTRAINT search_terms_term_type_valid
    CHECK (
      term_type IN (
        'synonym',
        'plain_language',
        'common_phrase',
        'misspelling',
        'related_term'
      )
    )
);

CREATE TRIGGER trg_search_terms_set_updated_at
BEFORE UPDATE ON search_terms
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ----------------------------
-- Helpful indexes
-- ----------------------------

CREATE INDEX idx_solutions_title
  ON solutions (title);

CREATE INDEX idx_solutions_solution_type
  ON solutions (solution_type);

CREATE INDEX idx_solutions_status
  ON solutions (status);

CREATE INDEX idx_dimensions_name
  ON dimensions (name);

CREATE INDEX idx_dimensions_dimension_type
  ON dimensions (dimension_type);

CREATE INDEX idx_solution_fit_rules_solution_id
  ON solution_fit_rules (solution_id);

CREATE INDEX idx_solution_fit_rules_dimension_id
  ON solution_fit_rules (dimension_id);

CREATE INDEX idx_solution_fit_rules_relation
  ON solution_fit_rules (relation);

CREATE INDEX idx_sources_source_type
  ON sources (source_type);

CREATE INDEX idx_entity_sources_entity
  ON entity_sources (entity_type, entity_id);

CREATE INDEX idx_search_terms_entity
  ON search_terms (entity_type, entity_id);

CREATE INDEX idx_search_terms_term
  ON search_terms (lower(term));

-- PostgreSQL does not allow lower(term) inside a table-level UNIQUE constraint.
-- Use a unique expression index instead.
CREATE UNIQUE INDEX idx_search_terms_unique_lower_term
  ON search_terms (entity_type, entity_id, lower(term), term_type);

COMMIT;