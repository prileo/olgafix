BEGIN;

-- ------------------------------------------------------------
-- Source note
-- ------------------------------------------------------------

INSERT INTO sources (title, source_type, notes)
VALUES (
  'Project design example: shower product organization strategies',
  'note',
  'Example set developed during early schema design. Covers spatial consistency, reachable placement, and shape differentiation for shower products.'
)
ON CONFLICT DO NOTHING;


-- ------------------------------------------------------------
-- Solution 1: Fixed left-to-right order
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
  'Keep shower products in a fixed left-to-right order',
  'Place shower products in a consistent order so they can be found and identified by location.',
  'Arrange shampoo, conditioner, body wash, soap, or other shower products in a consistent left-to-right or top-to-bottom order. For example, shampoo is always on the left, conditioner is always in the middle, and body wash is always on the right. This can reduce the need to read labels or visually inspect bottles. It works best when the storage location is stable and other household members do not move items.',
  'environmental_setup',
  'free',
  'low',
  'low',
  'easy',
  'draft'
)
ON CONFLICT DO NOTHING;

INSERT INTO entity_sources (entity_type, entity_id, source_id, notes)
SELECT
  'solution',
  s.id,
  src.id,
  'Source note for fixed spatial order shower product strategy.'
FROM solutions s
JOIN sources src
  ON src.title = 'Project design example: shower product organization strategies'
WHERE s.title = 'Keep shower products in a fixed left-to-right order'
ON CONFLICT DO NOTHING;


-- Supports: fixed order
INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'strong', 'medium',
  'A consistent product order can support identification when vision is unavailable or unreliable.'
FROM solutions s
JOIN dimensions d ON d.name = 'no vision' AND d.dimension_type = 'vision'
WHERE s.title = 'Keep shower products in a fixed left-to-right order'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'strong', 'medium',
  'This strategy uses stable location and routine rather than labels.'
FROM solutions s
JOIN dimensions d ON d.name = 'consistent routine' AND d.dimension_type = 'cognitive'
WHERE s.title = 'Keep shower products in a fixed left-to-right order'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'moderate', 'medium',
  'A fixed order can reduce the need to remember or inspect each bottle individually.'
FROM solutions s
JOIN dimensions d ON d.name = 'memory support' AND d.dimension_type = 'cognitive'
WHERE s.title = 'Keep shower products in a fixed left-to-right order'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'strong', 'medium',
  'A stable product order can help prevent selecting the wrong product.'
FROM solutions s
JOIN dimensions d ON d.name = 'error prevention' AND d.dimension_type = 'cognitive'
WHERE s.title = 'Keep shower products in a fixed left-to-right order'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'strong', 'medium',
  'This strategy usually costs nothing if the person already has a stable storage location.'
FROM solutions s
JOIN dimensions d ON d.name = 'low cost' AND d.dimension_type = 'implementation'
WHERE s.title = 'Keep shower products in a fixed left-to-right order'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'strong', 'medium',
  'This strategy does not require tools or equipment.'
FROM solutions s
JOIN dimensions d ON d.name = 'no tools required' AND d.dimension_type = 'implementation'
WHERE s.title = 'Keep shower products in a fixed left-to-right order'
ON CONFLICT DO NOTHING;

-- Cautions: fixed order
INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'caution_for', d.id, 'strong', 'medium',
  'In shared bathrooms, other people may move items and break the location-based system.'
FROM solutions s
JOIN dimensions d ON d.name = 'shared household' AND d.dimension_type = 'environment'
WHERE s.title = 'Keep shower products in a fixed left-to-right order'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'caution_for', d.id, 'moderate', 'medium',
  'The storage location still needs to be reachable; order alone does not solve reach barriers.'
FROM solutions s
JOIN dimensions d ON d.name = 'limited reach' AND d.dimension_type = 'reach'
WHERE s.title = 'Keep shower products in a fixed left-to-right order'
ON CONFLICT DO NOTHING;


-- Search terms: fixed order
INSERT INTO search_terms (entity_type, entity_id, term, term_type)
SELECT 'solution', s.id, term_value, term_kind
FROM solutions s
CROSS JOIN (
  VALUES
    ('shower product order', 'plain_language'),
    ('shampoo on the left', 'plain_language'),
    ('conditioner in the middle', 'plain_language'),
    ('body wash on the right', 'plain_language'),
    ('left right order', 'common_phrase'),
    ('fixed placement', 'synonym'),
    ('spatial consistency', 'synonym'),
    ('same place every time', 'plain_language'),
    ('blind shower organization', 'plain_language'),
    ('identify shampoo by location', 'plain_language'),
    ('shower routine', 'common_phrase')
) AS terms(term_value, term_kind)
WHERE s.title = 'Keep shower products in a fixed left-to-right order'
ON CONFLICT DO NOTHING;


-- ------------------------------------------------------------
-- Solution 2: Wall-mounted dispensers
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
  'Use wall-mounted dispensers at reachable height',
  'Put shampoo, conditioner, and body wash in fixed wall-mounted dispensers positioned within easy reach.',
  'Install or attach wall-mounted shower dispensers at a height and location the person can reliably reach. Each dispenser can be assigned a consistent product, such as shampoo, conditioner, or body wash. This can combine reach support, spatial consistency, and reduced bottle handling. It works best when the dispenser is easy to operate, refill, clean, and distinguish by position or touch. Adhesive dispensers may be more renter-friendly but can fail in wet environments.',
  'environmental_setup',
  'moderate',
  'moderate',
  'low',
  'moderate',
  'draft'
)
ON CONFLICT DO NOTHING;

INSERT INTO entity_sources (entity_type, entity_id, source_id, notes)
SELECT
  'solution',
  s.id,
  src.id,
  'Source note for wall-mounted shower dispenser strategy.'
FROM solutions s
JOIN sources src
  ON src.title = 'Project design example: shower product organization strategies'
WHERE s.title = 'Use wall-mounted dispensers at reachable height'
ON CONFLICT DO NOTHING;


-- Supports: dispensers
INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'strong', 'medium',
  'Positioning dispensers at an appropriate height can reduce reach demands.'
FROM solutions s
JOIN dimensions d ON d.name = 'limited reach' AND d.dimension_type = 'reach'
WHERE s.title = 'Use wall-mounted dispensers at reachable height'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'strong', 'medium',
  'Dispensers can be placed within seated reach if the shower setup allows.'
FROM solutions s
JOIN dimensions d ON d.name = 'seated reach' AND d.dimension_type = 'reach'
WHERE s.title = 'Use wall-mounted dispensers at reachable height'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'moderate', 'medium',
  'A fixed dispenser location can reduce overhead reaching if placed below shoulder height.'
FROM solutions s
JOIN dimensions d ON d.name = 'limited overhead reach' AND d.dimension_type = 'reach'
WHERE s.title = 'Use wall-mounted dispensers at reachable height'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'strong', 'medium',
  'A fixed dispenser location can make products easier to find without visual searching.'
FROM solutions s
JOIN dimensions d ON d.name = 'no vision' AND d.dimension_type = 'vision'
WHERE s.title = 'Use wall-mounted dispensers at reachable height'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'strong', 'medium',
  'A wall-mounted dispenser is designed for shower or bathroom use.'
FROM solutions s
JOIN dimensions d ON d.name = 'shower' AND d.dimension_type = 'environment'
WHERE s.title = 'Use wall-mounted dispensers at reachable height'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'strong', 'medium',
  'A dispenser can reduce the need to handle slippery bottles in the shower.'
FROM solutions s
JOIN dimensions d ON d.name = 'wet environment' AND d.dimension_type = 'environment'
WHERE s.title = 'Use wall-mounted dispensers at reachable height'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'moderate', 'medium',
  'Pump or push-button dispensers may be usable with one hand depending on the design and force required.'
FROM solutions s
JOIN dimensions d ON d.name = 'one-handed use' AND d.dimension_type = 'motor'
WHERE s.title = 'Use wall-mounted dispensers at reachable height'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'strong', 'medium',
  'Each dispenser can have a consistent position, supporting a stable routine.'
FROM solutions s
JOIN dimensions d ON d.name = 'consistent routine' AND d.dimension_type = 'cognitive'
WHERE s.title = 'Use wall-mounted dispensers at reachable height'
ON CONFLICT DO NOTHING;

-- Cautions/requires: dispensers
INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'requires', d.id, 'moderate', 'medium',
  'Wall-mounted dispensers require installation, mounting, or adhesive attachment.'
FROM solutions s
JOIN dimensions d ON d.name = 'requires installation' AND d.dimension_type = 'implementation'
WHERE s.title = 'Use wall-mounted dispensers at reachable height'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'requires', d.id, 'moderate', 'medium',
  'Dispensers need periodic refilling, cleaning, and checking for leaks or clogs.'
FROM solutions s
JOIN dimensions d ON d.name = 'requires maintenance' AND d.dimension_type = 'implementation'
WHERE s.title = 'Use wall-mounted dispensers at reachable height'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'caution_for', d.id, 'strong', 'medium',
  'Some dispensers require drilling or strong adhesive; this may be a concern for renters or people who cannot modify the shower.'
FROM solutions s
JOIN dimensions d ON d.name = 'renter or no drilling' AND d.dimension_type = 'environment'
WHERE s.title = 'Use wall-mounted dispensers at reachable height'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'caution_for', d.id, 'moderate', 'medium',
  'The dispenser mechanism may require more force than some users can comfortably apply.'
FROM solutions s
JOIN dimensions d ON d.name = 'limited grip strength' AND d.dimension_type = 'motor'
WHERE s.title = 'Use wall-mounted dispensers at reachable height'
ON CONFLICT DO NOTHING;


-- Search terms: dispensers
INSERT INTO search_terms (entity_type, entity_id, term, term_type)
SELECT 'solution', s.id, term_value, term_kind
FROM solutions s
CROSS JOIN (
  VALUES
    ('wall mounted dispenser', 'common_phrase'),
    ('shower dispenser', 'common_phrase'),
    ('soap dispenser in shower', 'common_phrase'),
    ('reachable shampoo', 'plain_language'),
    ('shampoo within reach', 'plain_language'),
    ('reach shampoo in shower', 'plain_language'),
    ('fixed shower dispenser', 'plain_language'),
    ('blind shower dispenser', 'plain_language'),
    ('seated shower reach', 'plain_language'),
    ('one handed shampoo dispenser', 'plain_language'),
    ('no drill shower dispenser', 'plain_language')
) AS terms(term_value, term_kind)
WHERE s.title = 'Use wall-mounted dispensers at reachable height'
ON CONFLICT DO NOTHING;


-- ------------------------------------------------------------
-- Solution 3: Differently shaped containers
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
  'Use differently shaped containers for similar shower products',
  'Choose or refill shower products into containers with distinct shapes so they can be identified by touch.',
  'Use containers with noticeably different shapes for shampoo, conditioner, body wash, or other shower products. For example, one product could be in a pump bottle, another in a squeeze bottle, and another in a wide jar or tub. Refillable containers can also be chosen specifically for tactile distinction. This can be more durable than small labels or bands, but it may require decanting products and maintaining the system over time.',
  'diy_adaptation',
  'low',
  'moderate',
  'low',
  'easy',
  'draft'
)
ON CONFLICT DO NOTHING;

INSERT INTO entity_sources (entity_type, entity_id, source_id, notes)
SELECT
  'solution',
  s.id,
  src.id,
  'Source note for differently shaped shower container strategy.'
FROM solutions s
JOIN sources src
  ON src.title = 'Project design example: shower product organization strategies'
WHERE s.title = 'Use differently shaped containers for similar shower products'
ON CONFLICT DO NOTHING;


-- Supports: different containers
INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'strong', 'medium',
  'Distinct container shapes can help identify products by touch.'
FROM solutions s
JOIN dimensions d ON d.name = 'shape differentiation' AND d.dimension_type = 'tactile'
WHERE s.title = 'Use differently shaped containers for similar shower products'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'strong', 'medium',
  'This strategy can work without reading labels or using vision.'
FROM solutions s
JOIN dimensions d ON d.name = 'no vision' AND d.dimension_type = 'vision'
WHERE s.title = 'Use differently shaped containers for similar shower products'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'strong', 'medium',
  'The solution uses tactile identification through shape rather than visual labeling.'
FROM solutions s
JOIN dimensions d ON d.name = 'tactile identification' AND d.dimension_type = 'tactile'
WHERE s.title = 'Use differently shaped containers for similar shower products'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'moderate', 'medium',
  'The strategy can be low cost if existing containers or inexpensive refillable containers are used.'
FROM solutions s
JOIN dimensions d ON d.name = 'low cost' AND d.dimension_type = 'implementation'
WHERE s.title = 'Use differently shaped containers for similar shower products'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'supports', d.id, 'moderate', 'medium',
  'Changing containers can help prevent selecting the wrong product.'
FROM solutions s
JOIN dimensions d ON d.name = 'error prevention' AND d.dimension_type = 'cognitive'
WHERE s.title = 'Use differently shaped containers for similar shower products'
ON CONFLICT DO NOTHING;

-- Cautions/requires: different containers
INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'requires', d.id, 'moderate', 'medium',
  'Refillable or transferred products require ongoing refilling and cleaning.'
FROM solutions s
JOIN dimensions d ON d.name = 'requires maintenance' AND d.dimension_type = 'implementation'
WHERE s.title = 'Use differently shaped containers for similar shower products'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'caution_for', d.id, 'moderate', 'medium',
  'Containers must be stable, non-slippery, and safe to use in a wet shower environment.'
FROM solutions s
JOIN dimensions d ON d.name = 'wet environment' AND d.dimension_type = 'environment'
WHERE s.title = 'Use differently shaped containers for similar shower products'
ON CONFLICT DO NOTHING;

INSERT INTO solution_fit_rules (solution_id, relation, dimension_id, strength, confidence, notes)
SELECT s.id, 'caution_for', d.id, 'moderate', 'medium',
  'If other household members refill or replace products, the shape-to-product mapping may become inconsistent.'
FROM solutions s
JOIN dimensions d ON d.name = 'shared household' AND d.dimension_type = 'environment'
WHERE s.title = 'Use differently shaped containers for similar shower products'
ON CONFLICT DO NOTHING;


-- Search terms: different containers
INSERT INTO search_terms (entity_type, entity_id, term, term_type)
SELECT 'solution', s.id, term_value, term_kind
FROM solutions s
CROSS JOIN (
  VALUES
    ('different shaped bottles', 'plain_language'),
    ('different bottles for shampoo and conditioner', 'plain_language'),
    ('pump bottle for shampoo', 'plain_language'),
    ('squeeze bottle for body wash', 'plain_language'),
    ('refillable shower bottles', 'common_phrase'),
    ('identify shampoo by bottle shape', 'plain_language'),
    ('tactile bottle shape', 'plain_language'),
    ('shape coded containers', 'synonym'),
    ('shampoo conditioner body wash containers', 'common_phrase'),
    ('blind shower bottle identification', 'plain_language')
) AS terms(term_value, term_kind)
WHERE s.title = 'Use differently shaped containers for similar shower products'
ON CONFLICT DO NOTHING;

COMMIT;