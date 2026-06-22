BEGIN;

INSERT INTO dimensions (name, dimension_type, description)
VALUES

-- Vision
('no vision', 'vision', 'Vision is unavailable or not useful for the task.'),
('color blindness', 'vision', 'Vision is available but certain colors are not distinguishable for the task.'),
('low vision', 'vision', 'Vision is available but limited or unreliable for the task.'),
('low contrast sensitivity', 'vision', 'Difficulty distinguishing objects with low visual contrast.'),
('dark environment', 'vision', 'The task happens in darkness or low light.'),
('no glasses during task', 'vision', 'The person does not wear glasses during the task.'),

-- Hearing
('no hearing aid during task', 'hearing', 'The person removes or cannot use hearing aids during the task.'),
('deaf or hard of hearing', 'hearing', 'Auditory information may be unavailable or limited.'),
('noisy environment', 'hearing', 'Background noise may interfere with hearing or speech recognition.'),
('audio cues unavailable', 'hearing', 'Audio cues are not usable or reliable in this context.'),

-- Touch / tactile access
('tactile identification', 'tactile', 'Objects can be identified by touch.'),
('texture differentiation', 'tactile', 'Objects can be distinguished by different textures.'),
('shape differentiation', 'tactile', 'Objects can be distinguished by different shapes.'),
('raised tactile marker', 'tactile', 'A raised marker, bump, band, or label provides tactile information.'),

-- Reach / positioning
('limited reach', 'reach', 'The person cannot comfortably reach the object or location.'),
('short stature', 'reach', 'The person’s height affects access to objects, controls, or surfaces.'),
('seated reach', 'reach', 'The task must be possible from a seated position.'),
('limited overhead reach', 'reach', 'Reaching above shoulder or head height is difficult or unsafe.'),
('limited trunk movement', 'reach', 'Trunk movement, leaning, bending, or twisting is limited.'),
('one-handed reach', 'reach', 'The task must be possible using one hand.'),

-- Motor / physical access
('limited hand use', 'motor', 'Hand use is limited for grasping, pressing, typing, or manipulation.'),
('limited grip strength', 'motor', 'Grip strength is limited.'),
('tremor', 'motor', 'Tremor may affect precision, stability, or control.'),
('spasticity', 'motor', 'Spasticity may affect movement, positioning, or control.'),
('fatigue', 'motor', 'Fatigue limits how long or how often a task can be performed.'),
('one-handed use', 'motor', 'The task or tool must be usable with one hand.'),

-- Speech / voice input
('speech recognition unreliable', 'speech', 'Standard speech recognition may not understand the person reliably.'),
('nonstandard speech', 'speech', 'Speech differs from what standard systems expect.'),
('low volume speech', 'speech', 'Speech volume may be too low for standard microphones or dictation tools.'),
('speech fatigue', 'speech', 'Speaking for long periods is tiring or unsustainable.'),
('voice input preferred', 'speech', 'Voice input is preferred or useful for the task.'),

-- Language / communication
('Russian language', 'language', 'The solution may need to support Russian.'),
('English language', 'language', 'The solution may need to support English.'),
('multilingual communication', 'language', 'The solution may need to support more than one language.'),
('translation needed', 'language', 'Translation between languages is part of the task.'),

-- Technology / computer access
('screen reader required', 'technology', 'The solution must work with a screen reader.'),
('switch compatible', 'technology', 'The solution should work with switch access.'),
('eye gaze compatible', 'technology', 'The solution should work with eye-gaze access.'),
('programming syntax', 'technology', 'The task involves writing or editing programming syntax.'),
('custom vocabulary needed', 'technology', 'The solution may need custom words, phrases, commands, or domain-specific vocabulary.'),
('offline use required', 'technology', 'The solution must work without internet access.'),

-- Environment
('wet environment', 'environment', 'The solution must work in a wet or damp environment.'),
('bathroom', 'environment', 'The task occurs in a bathroom.'),
('shower', 'environment', 'The task occurs in a shower.'),
('shared household', 'environment', 'Other people may move, use, or modify the setup.'),
('renter or no drilling', 'environment', 'Permanent installation, drilling, or wall modification may not be allowed.'),
('public environment', 'environment', 'The task occurs in a public or semi-public place.'),

-- Cognitive / routine support
('memory support', 'cognitive', 'The solution helps reduce memory burden.'),
('sequencing support', 'cognitive', 'The solution helps with doing steps in the right order.'),
('error prevention', 'cognitive', 'The solution helps prevent mistakes.'),
('reduce cognitive load', 'cognitive', 'The solution reduces decision-making or mental effort.'),
('consistent routine', 'cognitive', 'The solution depends on or supports a stable routine.'),

-- Cost / implementation constraints
('low cost', 'implementation', 'The solution should be inexpensive.'),
('no tools required', 'implementation', 'The solution should not require tools.'),
('easy to reverse', 'implementation', 'The solution can be undone easily.'),
('requires installation', 'implementation', 'The solution requires installation or setup.'),
('requires maintenance', 'implementation', 'The solution requires upkeep, refilling, charging, cleaning, or review.'),

-- Mobility / wheelchair
('power wheelchair', 'mobility', 'The person uses a power wheelchair.'),
('battery range concern', 'mobility', 'Battery life, charging access, or travel range is a concern.'),
('long time between charging', 'mobility', 'The person may need to go long periods between charging opportunities.'),
('manufacturer compatibility concern', 'mobility', 'Compatibility with manufacturer parts, chargers, software, or service rules matters.'),

-- Safety / risk
('slip risk', 'safety', 'The solution may affect fall or slip risk.'),
('skin sensitivity', 'safety', 'Skin irritation, scent sensitivity, allergies, or product sensitivity may matter.'),
('electrical safety concern', 'safety', 'Electrical safety must be considered.'),
('battery safety concern', 'safety', 'Battery chemistry, charging, replacement, or fire risk must be considered.'),
('high consequence error', 'safety', 'A mistake could cause significant harm or loss of access.')

ON CONFLICT (name, dimension_type) DO UPDATE
SET
  description = EXCLUDED.description,
  updated_at = now();

COMMIT;