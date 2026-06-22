BEGIN;

-- ------------------------------------------------------------
-- Source note
-- ------------------------------------------------------------

INSERT INTO sources (title, source_type, notes)
VALUES (
  'Project design example: identifying shampoo and body wash by touch',
  'note',
  'Example developed during early schema design. Represents a common low-cost tactile identification strategy for shower products.'
)
ON CONFLICT DO NOTHING;


-- ------------------------------------------------------------
-- Solution
-- ------------------------------------------------------------

INSERT INTO solutions (
  title,
  summary,
  body,
  solution_type,
  cost_level,
  effort_level,
  technical_level,
  reversibility,
  status
)
VALUES (
  'Use rubber bands as tactile markers on shower bottles',
  'Add different numbers of rubber bands to similar shower bottles so they can be identified by touch.',
  'Place one or more rubber bands, hair ties, or similar tactile markers around bottles that are otherwise hard to tell apart in the shower. For example, one rubber band could mean shampoo, two could mean conditioner, and three could mean body wash. This can help when vision is unavailable, unreliable, or intentionally not used. The system should be kept consistent and should be simple enough to remember. In shared bathrooms, other household members should know not to remove or rearrange the markers.',
  'diy_adaptation',
  'low',
  'low',
  'low',
  'easy',
  'draft'
)
ON CONFLICT DO NOTHING;


-- ------------------------------------------------------------
-- Source link
-- ------------------------------------------------------------

INSERT INTO entity_sources (
  entity_type,
  entity_id,
  source_id,
  notes
)
SELECT
  'solution',
  s.id,
  src.id,
  'Source note for the initial shower bottle tactile marker example.'
FROM solutions s
JOIN sources src
  ON src.title = 'Project design example: identifying shampoo and body wash by touch'
WHERE s.title = 'Use rubber bands as tactile markers on shower bottles'
ON CONFLICT DO NOTHING;


-- ------------------------------------------------------------
-- Fit rules: supports
-- ------------------------------------------------------------

INSERT INTO solution_fit_rules (
  solution_id,
  relation,
  dimension_id,
  strength,
  confidence,
  notes
)
SELECT
  s.id,
  'supports',
  d.id,
  'strong',
  'medium',
  'Rubber bands provide a tactile cue that can help distinguish bottles without using vision.'
FROM solutions s
JOIN dimensions d
  ON d.name = 'no vision'
 AND d.dimension_type = 'vision'
WHERE s.title = 'Use rubber bands as tactile markers on shower bottles'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (
  solution_id,
  relation,
  dimension_id,
  strength,
  confidence,
  notes
)
SELECT
  s.id,
  'supports',
  d.id,
  'strong',
  'medium',
  'The strategy relies on touch rather than visual labels.'
FROM solutions s
JOIN dimensions d
  ON d.name = 'tactile identification'
 AND d.dimension_type = 'tactile'
WHERE s.title = 'Use rubber bands as tactile markers on shower bottles'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (
  solution_id,
  relation,
  dimension_id,
  strength,
  confidence,
  notes
)
SELECT
  s.id,
  'supports',
  d.id,
  'moderate',
  'medium',
  'Different numbers or placements of bands can create texture or shape differences.'
FROM solutions s
JOIN dimensions d
  ON d.name = 'texture differentiation'
 AND d.dimension_type = 'tactile'
WHERE s.title = 'Use rubber bands as tactile markers on shower bottles'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (
  solution_id,
  relation,
  dimension_id,
  strength,
  confidence,
  notes
)
SELECT
  s.id,
  'supports',
  d.id,
  'strong',
  'medium',
  'This is a low-cost adaptation using common household items.'
FROM solutions s
JOIN dimensions d
  ON d.name = 'low cost'
 AND d.dimension_type = 'implementation'
WHERE s.title = 'Use rubber bands as tactile markers on shower bottles'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (
  solution_id,
  relation,
  dimension_id,
  strength,
  confidence,
  notes
)
SELECT
  s.id,
  'supports',
  d.id,
  'strong',
  'medium',
  'This strategy usually requires no tools and can be tried quickly.'
FROM solutions s
JOIN dimensions d
  ON d.name = 'no tools required'
 AND d.dimension_type = 'implementation'
WHERE s.title = 'Use rubber bands as tactile markers on shower bottles'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (
  solution_id,
  relation,
  dimension_id,
  strength,
  confidence,
  notes
)
SELECT
  s.id,
  'supports',
  d.id,
  'strong',
  'medium',
  'The adaptation can usually be removed without damaging the bottle.'
FROM solutions s
JOIN dimensions d
  ON d.name = 'easy to reverse'
 AND d.dimension_type = 'implementation'
WHERE s.title = 'Use rubber bands as tactile markers on shower bottles'
ON CONFLICT DO NOTHING;


-- ------------------------------------------------------------
-- Fit rules: cautions
-- ------------------------------------------------------------

INSERT INTO solution_fit_rules (
  solution_id,
  relation,
  dimension_id,
  strength,
  confidence,
  notes
)
SELECT
  s.id,
  'caution_for',
  d.id,
  'moderate',
  'medium',
  'In wet environments, bands may slip, degrade, trap residue, or become less reliable over time.'
FROM solutions s
JOIN dimensions d
  ON d.name = 'wet environment'
 AND d.dimension_type = 'environment'
WHERE s.title = 'Use rubber bands as tactile markers on shower bottles'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (
  solution_id,
  relation,
  dimension_id,
  strength,
  confidence,
  notes
)
SELECT
  s.id,
  'caution_for',
  d.id,
  'moderate',
  'medium',
  'In shared bathrooms, other people may remove bands, move bottles, or disrupt the system.'
FROM solutions s
JOIN dimensions d
  ON d.name = 'shared household'
 AND d.dimension_type = 'environment'
WHERE s.title = 'Use rubber bands as tactile markers on shower bottles'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (
  solution_id,
  relation,
  dimension_id,
  strength,
  confidence,
  notes
)
SELECT
  s.id,
  'caution_for',
  d.id,
  'weak',
  'medium',
  'The person needs to remember what each number or placement of bands means unless the system is very simple.'
FROM solutions s
JOIN dimensions d
  ON d.name = 'memory support'
 AND d.dimension_type = 'cognitive'
WHERE s.title = 'Use rubber bands as tactile markers on shower bottles'
ON CONFLICT DO NOTHING;


-- ------------------------------------------------------------
-- Search terms
-- ------------------------------------------------------------

INSERT INTO search_terms (entity_type, entity_id, term, term_type)
SELECT 'solution', s.id, term_value, term_kind
FROM solutions s
CROSS JOIN (
  VALUES
    ('shampoo', 'common_phrase'),
    ('conditioner', 'common_phrase'),
    ('body wash', 'common_phrase'),
    ('soap bottle', 'common_phrase'),
    ('shower bottle', 'common_phrase'),
    ('tell shampoo and conditioner apart', 'plain_language'),
    ('identify shampoo by touch', 'plain_language'),
    ('identify body wash by touch', 'plain_language'),
    ('rubber bands on bottles', 'plain_language'),
    ('blind shower organization', 'plain_language'),
    ('newly blind shower tips', 'plain_language'),
    ('shower in the dark', 'plain_language'),
    ('eyes closed shower', 'plain_language'),
    ('tactile bottle labels', 'synonym'),
    ('tactile markers', 'synonym')
) AS terms(term_value, term_kind)
WHERE s.title = 'Use rubber bands as tactile markers on shower bottles'
ON CONFLICT DO NOTHING;

COMMIT;