# V02 — Triage Nurse: New Patient Intake

**Phase:** 2 — Core Clinical  
**Audience:** TRIAGE_NURSE, NURSE  
**Estimated duration:** ~4 minutes  
**Watch first:** V01 (Login & Dashboard Overview)  
**Prerequisites for viewer:** Understands basic navigation

---

## Production Setup

- **Login as:** TRIAGE_NURSE account
- **Start screen:** `dashboard.php`
- **Test data needed:** No existing patient for the demo patient (you will create one live). Have a fictional patient's info ready to type: name, DOB, phone, chief complaint.
- **Suggested demo patient:** "Priya Sharma", DOB 15-Mar-1985, phone, complaint: "persistent headache for 3 days"
- **Note:** The intake form has 6 tabs. You do not need to fill every field — fill enough to demonstrate each tab's purpose, then move on.

---

## Script

### [0:00–0:15] Opening
> [On screen: dashboard.php]

"In this video I'll walk through creating a brand new intake for a patient who has never been seen in the system before. This is the most common workflow for triage nurses."

---

### [0:15–0:35] Starting a new intake
> [Action: Click "New Intake" in the quick-action strip or from the sidebar under Clinical]

"Click New Intake from your dashboard or the sidebar. The first thing you'll see is the patient search — always search before registering, to avoid creating duplicates."

---

### [0:35–1:00] Patient search — no result
> [Action: Type the patient's name in the search box. Pause to show no results found.]

"I'll type the patient's name. No results come back — this is a new patient. I'll click Register New Patient to open the registration form."

> [Action: Click "Register New Patient" button — modal opens]

---

### [1:00–1:40] Registering a new patient
> [On screen: new patient registration modal]

"Fill in the required fields — first name, last name, date of birth, and phone number. Sex, blood group, and address are optional but worth capturing when available."

> [Action: Fill in: First Name = Priya, Last Name = Sharma, DOB = 15/03/1985, Phone = demo number]

"Once you save, the patient is registered and automatically selected for this intake."

> [Action: Click Save / Register — modal closes, patient populates in the intake form]

---

### [1:40–1:55] Tab 1 — Visit Details
> [On screen: Tab 1 of intake form — Visit Details / Chief Complaint]

"Tab one captures the reason for today's visit. Select the visit type, assign a doctor if you know who will be seeing this patient, and enter the chief complaint."

> [Action: Select visit type, type chief complaint: "Persistent headache for 3 days"]

---

### [1:55–2:15] Tab 2 — History
> [Action: Click Tab 2 — History]

"Tab two is the patient's medical history — current and past conditions, family history, and allergies. For a brand new patient, you'll fill this from the intake form. On return visits, this is often pre-populated from prior records."

> [Action: Check one condition (e.g., Hypertension - CURRENT), add one allergy row]

---

### [2:15–2:35] Tab 3 — Vitals
> [Action: Click Tab 3 — Vitals / General Examination]

"Tab three is vitals. Enter blood pressure, pulse, temperature, weight, height, and SpO2 as measured. BMI calculates automatically from weight and height."

> [Action: Fill in BP, pulse, temperature fields]

---

### [2:35–2:50] Tab 4 — Examination Notes
> [Action: Click Tab 4 — Examination]

"Tab four captures physical examination findings — oral, throat, and for female patients, breast and gynaecological examination fields. Fill in what's relevant for this visit."

---

### [2:50–3:05] Tab 5 — Plan / Summary
> [Action: Click Tab 5 — Plan]

"Tab five is the disposition summary — risk level, referral decision, and patient acceptance. This is typically completed at the end of the intake before handing off to the doctor."

---

### [3:05–3:20] Tab 6 — Labs
> [Action: Click Tab 6 — Labs]

"Tab six shows any lab tests ordered for this visit. We have a separate video on ordering lab tests, so we'll skip that here."

---

### [3:20–3:45] Completing the intake
> [Action: Navigate back to Tab 5 or wherever the Complete Intake button is visible. Click Complete Intake.]

"Once all tabs are filled, click Complete Intake at the bottom of the Plan tab. This marks the case sheet as ready for doctor review and removes it from your active queue."

> [On screen: success message or redirect back to dashboard]

"The case sheet status changes to 'Ready for Doctor' and will appear in the doctor's review queue."

---

### [3:45–4:00] Closing
"That's the full new patient intake flow. For returning patients — where the patient already exists in the system — watch Video 3, which shows how prior information pre-populates and speeds up the process."
