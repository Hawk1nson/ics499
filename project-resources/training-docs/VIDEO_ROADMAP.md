# D3S3 CareSystem — Training Video Roadmap

**Total videos:** 23  
**Total estimated content:** ~57 minutes  
**Target max per video:** 5 minutes (most are 2–3 min)

---

## Production Phases

Videos are grouped into six production phases. Record in phase order — later phases assume
earlier videos exist and can be linked/referenced.

---

### Phase 1 — Foundation
Record first. Every other video assumes the viewer has watched V01.

| ID  | Title                               | Audience     | Est. Duration | Script |
|-----|-------------------------------------|--------------|---------------|--------|
| V01 | System Login & Dashboard Overview   | All staff    | ~2 min        | [script](scripts/V01_Login_Dashboard.md) |

---

### Phase 2 — Core Clinical Workflows
Highest priority. Most complex. Require test patients and case sheets to be set up in advance.
Record V02 before V03 (V03 references the patient created in V02 conceptually).

| ID  | Title                                        | Primary Audience              | Est. Duration | Script |
|-----|----------------------------------------------|-------------------------------|---------------|--------|
| V02 | Triage Nurse: New Patient Intake             | TRIAGE_NURSE, NURSE           | ~4 min        | [script](scripts/V02_New_Patient_Intake.md) |
| V03 | Triage Nurse: Returning Patient Intake       | TRIAGE_NURSE, NURSE           | ~2 min        | [script](scripts/V03_Returning_Patient_Intake.md) |
| V04 | Doctor: Reviewing a Patient Chart            | DOCTOR                        | ~3 min        | [script](scripts/V04_Doctor_Chart_Review.md) |
| V05 | Ordering & Completing Lab Tests              | TRIAGE_NURSE, NURSE, DOCTOR   | ~3 min        | [script](scripts/V06_Lab_Tests.md) |
| V06 | Scheduling Appointments                      | TRIAGE_NURSE, NURSE           | ~3 min        | [script](scripts/V07_Appointments.md) |

---

### Phase 3 — Communication & Support
Mostly standalone — can be recorded in any order within this phase.

| ID  | Title                                     | Primary Audience                | Est. Duration | Script |
|-----|-------------------------------------------|---------------------------------|---------------|--------|
| V07 | Internal Staff Messaging                  | All staff                       | ~2 min        | [script](scripts/V08_Internal_Messaging.md) |
| V08 | Tasks: Personal To-Do List                | All staff                       | ~2 min        | [script](scripts/V09_Tasks.md) |
| V09 | Grievance Officer: Feedback Management    | GRIEVANCE_OFFICER, ADMIN        | ~3 min        | [script](scripts/V10_Feedback_Grievances.md) |

---

### Phase 4 — Admin Workflows
Record V11 (registration) before V12 (user management) — the user created in V11 can appear in V12.

| ID  | Title                                        | Primary Audience          | Est. Duration | Script |
|-----|----------------------------------------------|---------------------------|---------------|--------|
| V10 | Admin: Employee Registration                 | SUPER_ADMIN, ADMIN        | ~2 min        | [script](scripts/V11_Employee_Registration.md) |
| V11 | Admin: Managing Users & Roles                | SUPER_ADMIN, ADMIN        | ~3 min        | [script](scripts/V12_User_Management.md) |
| V12 | Admin: Asset Library & Patient Delivery      | SUPER_ADMIN, ADMIN        | ~3 min        | [script](scripts/V13_Assets.md) |
| V13 | Admin: Patient Portal Account Management     | SUPER_ADMIN, ADMIN        | ~2 min        | [script](scripts/V14_Portal_Account_Management.md) |
| V14 | Admin: Reports & Data Export                 | SUPER_ADMIN, ADMIN        | ~2 min        | [script](scripts/V15_Reports.md) |
| V15 | Analytics Dashboard                          | SUPER_ADMIN, ADMIN, DOCTOR| ~3 min        | [script](scripts/V16_Analytics.md) |

---

### Phase 5 — Personal & Role Orientation
Standalone. Can be recorded any time after Phase 1.

| ID  | Title                                                          | Primary Audience                              | Est. Duration | Script |
|-----|----------------------------------------------------------------|-----------------------------------------------|---------------|--------|
| V16 | Your Profile & Settings                                        | All staff                                     | ~2 min        | [script](scripts/V17_Profile_Settings.md) |
| V17 | Role Orientation: Paramedic, Education Team & Data Entry       | PARAMEDIC, EDUCATION_TEAM, DATA_ENTRY_OPERATOR| ~3 min        | [script](scripts/V18_Role_Orientation.md) |

---

### Phase 6 — Patient Portal
Record V19 first (login/dashboard). V23 (staff side) can be recorded alongside V21.

| ID  | Title                                            | Primary Audience                        | Est. Duration | Script |
|-----|--------------------------------------------------|-----------------------------------------|---------------|--------|
| V18 | Patient Portal: Getting Started                  | Patients                                | ~2 min        | [script](scripts/V19_Portal_Getting_Started.md) |
| V19 | Patient Portal: Health Record & Lab Results      | Patients                                | ~3 min        | [script](scripts/V20_Portal_Health_Record.md) |
| V20 | Patient Portal: Messaging & Feedback             | Patients                                | ~3 min        | [script](scripts/V21_Portal_Messaging_Feedback.md) |
| V21 | Patient Portal: Resources                        | Patients                                | ~2 min        | [script](scripts/V22_Portal_Resources.md) |
| V22 | Staff: Responding to Patient Portal Messages     | All staff with patient_data access      | ~2 min        | [script](scripts/V23_Staff_Portal_Messages.md) |

---

## Recommended Viewing Paths by Role

| Role                  | Watch in this order |
|-----------------------|---------------------|
| Triage Nurse / Nurse  | V01 → V02 → V03 → V05 → V06 → V07 → V08 → V16 → V17 → V22 |
| Doctor                | V01 → V04 → V05 → V07 → V08 → V15 → V22 |
| Super Admin / Admin   | V01 → V10 → V11 → V12 → V13 → V14 → V15 → V16 → V17 → V22 |
| Grievance Officer     | V01 → V07 → V08 → V09 → V16 → V17 |
| Paramedic / Education Team / Data Entry | V01 → V17 → V07 → V08 → V16 |
| Patients (Portal)     | V18 → V19 → V20 → V21 |

---

## Production Checklist (Before Recording Any Video)

- [ ] All test data is loaded (`sql/test_data_phase3.sql`)
- [ ] At least one patient with 2+ closed case sheets exists for chart review demos
- [ ] At least one case sheet in `INTAKE_COMPLETE` status for doctor demo
- [ ] Portal test accounts active (patient IDs 1, 2, 3 — password: `Portal@1234`)
- [ ] Screen recorder set to 1080p, microphone tested
- [ ] Browser zoom at 100%, no personal bookmarks visible, browser in full-screen
- [ ] Dark mode OFF for recording (higher contrast on most displays)
- [ ] Sidebar expanded (not collapsed) at the start of each video
