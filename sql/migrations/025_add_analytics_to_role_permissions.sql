-- Migration 025: Add analytics resource to role_permissions
--
-- Adds the 'analytics' resource to the live permission matrix so admins
-- can control which roles can access the Analytics & Reporting page through
-- the Permissions Management UI.
--
-- Default access:
--   SUPER_ADMIN, ADMIN   -> R   (full clinic-wide analytics)
--   DOCTOR               -> R   (scoped to own cases via buildScope())
--   TRIAGE_NURSE, NURSE,
--   PARAMEDIC,
--   GRIEVANCE_OFFICER,
--   EDUCATION_TEAM,
--   DATA_ENTRY_OPERATOR  -> N   (no access)
--
-- Run AFTER migration 024.

INSERT IGNORE INTO role_permissions (role, resource, permission) VALUES
  ('SUPER_ADMIN',          'analytics', 'R'),
  ('ADMIN',                'analytics', 'R'),
  ('DOCTOR',               'analytics', 'R'),
  ('TRIAGE_NURSE',         'analytics', 'N'),
  ('NURSE',                'analytics', 'N'),
  ('PARAMEDIC',            'analytics', 'N'),
  ('GRIEVANCE_OFFICER',    'analytics', 'N'),
  ('EDUCATION_TEAM',       'analytics', 'N'),
  ('DATA_ENTRY_OPERATOR',  'analytics', 'N');
