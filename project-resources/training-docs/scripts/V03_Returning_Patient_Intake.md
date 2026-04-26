# V03 — Triage Nurse: Returning Patient Intake

**Phase:** 2 — Core Clinical  
**Audience:** TRIAGE_NURSE, NURSE  
**Estimated duration:** ~2 minutes  
**Watch first:** V01, V02  
**Prerequisites for viewer:** Has completed V02 (New Patient Intake)

---

## Production Setup

- **Login as:** TRIAGE_NURSE account
- **Start screen:** `dashboard.php`
- **Test data needed:** An existing patient who has at least one prior closed case sheet. Ideally use one of the seeded test patients (patient IDs 1, 2, or 3).
- **Note:** The key story here is speed — returning patient intake is faster because the system knows the patient. Emphasize pre-population.

---

## Script

### [0:00–0:15] Opening
> [On screen: dashboard.php]

"When a patient has been seen before, starting their intake is much faster. The system already knows who they are and can pull in their prior history. Let's walk through it."

---

### [0:15–0:40] Patient search — existing patient found
> [Action: Click New Intake. In the patient search, type the name of an existing patient (e.g., "Ravi Kumar").]

"I'll click New Intake and search for the patient by name. This time there's a match — I can see the patient's name, ID code, and date of birth listed."

> [Action: Click the patient's name in the search results to select them]

"I'll click their name to select them. The system loads their case and opens the intake form."

---

### [0:40–1:05] Pre-populated fields
> [On screen: intake form loaded with patient selected — Tab 1 visible]

"Notice that the patient's demographics are already filled in — we don't need to re-enter their name, date of birth, or contact information."

> [Action: Click to Tab 2 — History]

"On the History tab, any conditions, family history, and allergies recorded from previous visits are already shown. You only need to update what's changed — for example, if the patient reports a new allergy."

---

### [1:05–1:25] Prior visit context
> [Action: If visible, point to the "previous visits" or history summary area]

"The system also shows prior visits. This gives you context — when was this patient last seen, what was their chief complaint, who was their doctor. You don't need to ask the patient to repeat their full history every time."

---

### [1:25–1:45] Completing the intake
> [Action: Enter today's chief complaint on Tab 1. Click through the remaining tabs briefly.]

"For today's visit, I just enter the new chief complaint and update any vitals. The historical data stays in the record automatically. When everything is filled in, I complete the intake the same way as a new patient."

> [Action: Click Complete Intake]

---

### [1:45–2:00] Closing
"Returning patient intakes are significantly faster because you're only entering what's new or changed. The full prior record is always accessible to the assigned doctor during their review."
