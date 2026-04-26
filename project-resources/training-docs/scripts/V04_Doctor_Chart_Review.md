# V04 — Doctor: Reviewing a Patient Chart

**Phase:** 2 — Core Clinical  
**Audience:** DOCTOR  
**Estimated duration:** ~3 minutes  
**Watch first:** V01  
**Prerequisites for viewer:** Basic navigation familiarity

---

## Production Setup

- **Login as:** DOCTOR account
- **Start screen:** `dashboard.php`
- **Test data needed:** At least one case sheet in `INTAKE_COMPLETE` status assigned (or unassigned) to this doctor. Ideally the patient has 1–2 prior closed case sheets so the history tabs are populated.
- **Key flow:** Dashboard → claim case sheet → doctor review form → patient history context

---

## Script

### [0:00–0:15] Opening
> [On screen: dashboard.php logged in as DOCTOR]

"This video walks through the doctor's chart review workflow — how you claim a case sheet from the queue, review what the nurse recorded, and access the patient's full history."

---

### [0:15–0:45] Finding case sheets in the queue
> [On screen: dashboard — show the "Ready for Review" or queue section]

"When you log in as a doctor, your dashboard shows case sheets that are ready for review. These are intakes that the triage nurse has completed and submitted. You'll also see case sheets already in your queue if you've claimed them previously."

> [Action: Locate a case sheet with status "Ready for Doctor" / INTAKE_COMPLETE. Click the Claim / Assign to Me button.]

"I'll click Claim to take ownership of this case sheet. This moves it from the general queue into my active review list and marks it as 'In Review' so other doctors know it's being handled."

---

### [0:45–1:15] Opening the review form
> [Action: Click the case sheet to open the review form — `review.php`]

> [On screen: doctor review form]

"The review form opens with everything the nurse recorded — the chief complaint, visit details, vitals, history, examination notes, and any lab orders. I can scroll through all of this on the left or right side of the form."

> [Action: Scroll through the intake data briefly — point to vitals display, chief complaint, history]

"I can see the patient's vitals at a glance, the chief complaint, and any conditions or allergies flagged during intake."

---

### [1:15–1:50] Accessing patient history
> [Action: Navigate to the patient history tab/section within the review form]

"One of the most useful parts of the review form is the patient's full history. I can see all prior visits for this patient — previous case sheets, diagnoses, and treatment plans from earlier appointments."

> [Action: Expand one prior case sheet entry to show the clinical detail]

"Expanding any prior visit shows the assessment, diagnosis, and plan from that visit. This gives me the context I need without leaving the current review."

---

### [1:50–2:20] Doctor's fields
> [Action: Scroll to the doctor-specific section of the form — Assessment, Diagnosis, Plan, Prescriptions, Follow-Up]

"This section is where I add my clinical findings. I'll fill in the assessment, diagnosis, treatment plan, any prescriptions, and follow-up instructions. These fields are specific to the doctor role — the nurse cannot edit them."

> [Action: Type a brief example in each field]

---

### [2:20–2:45] Viewing the read-only case sheet summary
> [Action: If applicable — open the read-only case sheet view (intake.php?action=view) from the patient profile. Optional step depending on time.]

"If I need to review the full intake in a clean, print-friendly format — all the vitals, history, and examination notes without the edit fields — I can open the read-only case sheet summary from the patient's profile."

---

### [2:45–3:00] Closing
"Once you've completed your clinical notes, the next step is closing the case sheet. That's covered in Video 5. For now, you can save your progress at any point — the case sheet stays in 'In Review' status until you formally close it."
