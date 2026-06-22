# Schema v0.1 Design Notes

## Purpose

This database is intended to store assistive technology strategies, adaptations, tools, products, workflows, and related knowledge in a way that supports flexible discovery across overlapping needs.

The goal is not to organize entries only by disability category, diagnosis, product type, or environment. Instead, the database is designed around functional fit:

* What is the person trying to do?
* What makes the task difficult?
* What access channels are available?
* What environment or context matters?
* What strategies support, require, conflict with, or caution against certain conditions?

This allows a single solution to be found from many different directions.

For example, a strategy like “use rubber bands as tactile markers on bottles” may be relevant to:

* distinguishing shampoo from body wash in the shower
* nonvisual identification
* wet environments
* low-cost DIY adaptation
* routines for people with recent vision loss
* people who shower with eyes closed
* people who shower in the dark
* people who benefit from tactile organization

## Core Design Principle

The schema is organized around solutions and fit rules rather than fixed scenarios.

A curated scenario such as “reach and identify shower products while blind” may be useful later as a guide or saved search, but the database should still work even when that exact scenario does not already exist.

This matters because real access needs often overlap in unique ways. For example:

* a little person may need reachable shower toiletries that are easy to dispense
* a blind person with cerebral palsy may want to code but cannot use a regular keyboard or standard voice dictation
* a person with SMA may need low-fatigue Russian-English dictation
* a power wheelchair user may need battery strategies that match long periods between charging

The database should support matching across these dimensions without requiring every combination to be manually prewritten.

## Tables

## `solutions`

The `solutions` table stores the main things the database knows about.

A solution may be:

* a DIY adaptation
* a strategy
* a workflow
* a commercial product example
* a software tool
* a maintenance practice
* an environmental setup
* a communication method
* a device-access technique

Examples:

* Use rubber bands as tactile markers on shower bottles
* Keep shower products in a fixed left-to-right order
* Use wall-mounted dispensers at reachable height
* Use a custom command grammar for coding by voice
* Use lithium ion batteries for devices that don't get recharged on a daily schedule.

Important fields include:

* `title`: human-readable name
* `summary`: short description
* `body`: longer explanation
* `solution_type`: broad kind of solution
* `cost_level`: free, low, moderate, high, or unknown
* `effort_level`: low, moderate, high, or unknown
* `technical_level`: low, moderate, high, or unknown
* `reversibility`: how easy it is to undo
* `status`: draft, review, published, or archived

The `solutions` table is intentionally broad. More specific meaning comes from fit rules, dimensions, sources, and search terms.

## `dimensions`

The `dimensions` table stores reusable access-related concepts.

A dimension can describe a barrier, access need, environment, task context, language, sensory condition, motor constraint, technology requirement, or other meaningful condition.

Examples:

* no vision
* low vision
* blurry vision
* no glasses during task
* no hearing aid during task
* wet environment
* dark environment
* limited reach
* seated reach
* short stature
* limited hand use
* speech recognition unreliable
* Russian language
* English language
* programming syntax
* screen reader required
* power wheelchair
* battery range concern
* renter / no drilling
* shared household

Important fields include:

* `name`: the dimension label
* `dimension_type`: the category of dimension
* `description`: explanation of what the dimension means

Dimensions are the reusable vocabulary that make flexible matching possible.

## `solution_fit_rules`

The `solution_fit_rules` table connects solutions to dimensions.

This is the most important table in the design. It describes how well a solution fits a particular access need, context, barrier, or constraint.

A solution can:

* support a dimension
* require a dimension
* be a poor fit for a dimension
* require caution for a dimension
* work well with another concept
* conflict with another concept
* be an alternative to another concept

Examples:

Rubber bands as tactile markers:

* supports: no vision
* supports: low-cost adaptation
* caution_for: wet environment
* caution_for: shared household

Color-coded labels:

* supports: visual identification
* requires: usable vision
* poor_fit_for: no vision
* poor_fit_for: dark environment

Wall-mounted dispenser:

* supports: limited reach
* supports: spatial consistency
* supports: wet environment
* caution_for: renter / no drilling
* caution_for: limited hand strength, depending on pump style

Important fields include:

* `solution_id`: the solution being described
* `relation`: the type of fit relationship
* `dimension_id`: the relevant dimension
* `strength`: weak, moderate, or strong
* `confidence`: low, medium, or high
* `notes`: explanation of the fit rule

This table allows the database to answer flexible questions such as:

* What works in a wet environment without relying on vision?
* What supports limited reach and tactile identification?
* What tools support coding without a standard keyboard?
* What dictation tools might support Russian-English communication?
* What power wheelchair battery strategies require caution?

## `sources`

The `sources` table stores where information came from.

Sources may include:

* personal notes
* lived experience
* professional experience
* manuals
* product pages
* articles
* research papers
* videos
* repair notes
* other documentation

Important fields include:

* `title`: source name
* `url`: optional link
* `source_type`: kind of source
* `notes`: context or reliability notes

This project may include information from many kinds of sources. Not all useful assistive technology knowledge comes from formal research. However, source type and notes should make the origin of information clear.

## `entity_sources`

The `entity_sources` table links sources to specific records.

A source may support a solution, a dimension, a fit rule, or another entity.

Examples:

* A manufacturer manual may support a power wheelchair battery caution.
* A lived experience note may support a shower organization strategy.
* A professional experience note may support a repair or configuration tip.
* A product page may support a product-specific claim.

Important fields include:

* `entity_type`: what kind of record is being sourced
* `entity_id`: the ID of that record
* `source_id`: the source
* `notes`: explanation of how the source relates to the entity

This design allows source links to be added without putting source columns on every table.

## `search_terms`

The `search_terms` table stores human search language.

This is separate from formal dimensions because people do not always search using controlled vocabulary.

For example, the formal dimension might be:

* no vision

But people may search:

* blind
* newly blind
* can’t see
* showering in the dark
* eyes closed
* can’t tell bottles apart
* shampoo vs conditioner
* identify by touch

Important fields include:

* `entity_type`: whether the term points to a solution or dimension
* `entity_id`: the related record
* `term`: the searchable phrase
* `term_type`: synonym, plain-language phrase, common phrase, misspelling, or related term

Search terms are meant to improve findability without making the controlled vocabulary messy.

## Why Not Start With Disability Categories?

Disability categories are useful, but they should not be the main organizing system.

A solution may be useful to many people for different reasons. For example, tactile shampoo identification may help:

* people who are blind
* people with low vision
* people with recent vision loss
* people who shower without glasses
* people who shower with eyes closed
* people who shower in the dark
* people with body dysmorphia who prefer low-light showering
* people who benefit from routine and error prevention

Organizing only by diagnosis or disability category would hide these overlaps.

The database should instead prioritize functional questions:

* What task is involved?
* What access channel is available?
* What constraints are present?
* What solution properties matter?
* What risks or cautions apply?

## Future Tables Not Included in v0.1

The v0.1 schema is intentionally small. Possible future tables include:

* `goals`: tasks or activities people are trying to accomplish
* `products`: commercial items, brands, or models
* `implementations`: specific how-to versions of a broader solution
* `scenarios`: curated bundles of common overlapping needs
* `strategy_relationships`: links between solutions that work well together or conflict
* `validation_notes`: editorial review and data quality notes
* `attachments`: files, images, manuals, or diagrams
* `organizations`: vendors, repair shops, nonprofits, or service providers

These are postponed until the core solution/dimension/fit-rule model has been tested with real entries.

## Current MVP Goal

The v0.1 schema should make it possible to:

1. Add a solution.
2. Add dimensions describing barriers, contexts, access needs, and constraints.
3. Link solutions to dimensions using fit rules.
4. Add source notes.
5. Add plain-language search terms.
6. Query for solutions that match overlapping needs.
7. Revise the schema based on real examples.

This version is not intended to be perfect. It is intended to be flexible enough to test with real assistive technology examples.
