BEGIN;

CREATE OR REPLACE VIEW solution_search_view AS
SELECT
  s.id AS solution_id,
  s.title,
  s.summary,
  s.body,
  s.solution_type,
  s.cost_level,
  s.effort_level,
  s.technical_level,
  s.reversibility,
  s.status,

  string_agg(DISTINCT d.name, ' | ') AS dimensions,
  string_agg(DISTINCT d.dimension_type, ' | ') AS dimension_types,
  string_agg(DISTINCT st.term, ' | ') AS search_terms,

  concat_ws(
    ' ',
    s.title,
    s.summary,
    s.body,
    string_agg(DISTINCT d.name, ' '),
    string_agg(DISTINCT d.dimension_type, ' '),
    string_agg(DISTINCT st.term, ' ')
  ) AS searchable_text

FROM solutions s

LEFT JOIN solution_fit_rules r
  ON r.solution_id = s.id

LEFT JOIN dimensions d
  ON d.id = r.dimension_id

LEFT JOIN search_terms st
  ON st.entity_type = 'solution'
 AND st.entity_id = s.id

GROUP BY
  s.id,
  s.title,
  s.summary,
  s.body,
  s.solution_type,
  s.cost_level,
  s.effort_level,
  s.technical_level,
  s.reversibility,
  s.status;

COMMIT;