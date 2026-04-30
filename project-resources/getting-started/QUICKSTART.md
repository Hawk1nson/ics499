# D3S3 CareSystem — Quick Start Guide

Get the app running on a fresh XAMPP installation in about ten minutes.

---

## What's in this folder

| File | Purpose |
|------|---------|
| `QUICKSTART.md` | This guide |
| `d3s3_database.sql` | Full database dump — schema + all test data |
| `.env.example` | Environment template to copy into the project root |

---

## Prerequisites

- **XAMPP 8.x** (bundles PHP 8.x, Apache, and MariaDB) — download from https://www.apachefriends.org/
- **Git** (optional — only needed if you're cloning the repo instead of downloading a zip)

No Composer, no Node, no build step required.

---

## Step 1 — Install XAMPP

Run the XAMPP installer and accept the defaults.

**macOS:** XAMPP installs to `/Applications/XAMPP/`  
**Windows:** XAMPP installs to `C:\xampp\`

---

## Step 2 — Place the project files

The app **must** live in a folder called `d3s3` directly inside XAMPP's `htdocs` directory. Any other path will break asset references.

**Option A — Clone with Git:**

```bash
# macOS
cd /Applications/XAMPP/xamppfiles/htdocs
git clone <repo-url> d3s3

# Windows
cd C:\xampp\htdocs
git clone <repo-url> d3s3
```

**Option B — Download and extract:**

1. Download the project zip from your source (GitHub, email, etc.)
2. Extract it
3. Rename the extracted folder to `d3s3`
4. Move it into `htdocs/` so the path is `htdocs/d3s3/`

---

## Step 3 — Fix the .htaccess for local development

The production `.htaccess` forces HTTPS. XAMPP doesn't have HTTPS configured by default, which causes a redirect loop or "connection refused" error in the browser.

Open `htdocs/d3s3/.htaccess` in any text editor and **comment out** the Force HTTPS block at the top:

```apache
# ─── Force HTTPS ─────────────────────────────────────────────────────
# <IfModule mod_rewrite.c>
#     RewriteEngine On
#     RewriteCond %{HTTPS} off
#     RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
# </IfModule>
```

Add a `#` at the start of each line inside the block, as shown above.

> This only affects your local copy. Do not commit this change — the HTTPS redirect should stay enabled in production.

---

## Step 4 — Create the environment file

Copy `.env.example` from this folder into the project root and rename it `.env`:

```bash
# macOS — from inside htdocs/d3s3/
cp project-resources/getting-started/.env.example .env

# Windows (Command Prompt) — from inside htdocs\d3s3\
copy project-resources\getting-started\.env.example .env
```

The default values work for a standard XAMPP installation with no MySQL password set:

```
DB_HOST=localhost
DB_PORT=3306
DB_NAME=core_app
DB_USER=root
DB_PASS=            ← leave blank (XAMPP default has no root password)
APP_ENV=development
REGISTRATION_CODE=devcode123
```

If you set a MySQL root password during XAMPP setup, enter it on the `DB_PASS=` line.

---

## Step 5 — Start XAMPP

Open the **XAMPP Control Panel** and start both **Apache** and **MySQL**.

Both modules must show a green "Running" status before you continue.

**Windows users:** If Apache fails to start, port 80 is in use (commonly IIS or Skype). Either stop the conflicting service, or change Apache's port in the XAMPP control panel.

---

## Step 6 — Create the database

1. Open a browser and go to `http://localhost/phpmyadmin`
2. In the left panel, click **New**
3. Enter the database name: `core_app`
4. Set the collation to `utf8mb4_unicode_ci`
5. Click **Create**

---

## Step 7 — Import the database

1. In phpMyAdmin, click `core_app` in the left panel to select it
2. Click the **Import** tab at the top
3. Click **Choose File** and select `d3s3_database.sql` from this folder
4. Scroll down and click **Import**

This loads the full schema and all test data (staff accounts, patients, case sheets, lab orders, appointments, portal accounts, and more). It should complete in a few seconds with no errors.

---

## Step 8 — Open the app

Navigate to:

```
http://localhost/d3s3/
```

You should see the D3S3 CareSystem landing page with links to the staff login and the patient portal.

---

## Test Credentials

### Staff login — `http://localhost/d3s3/login.php`

All test staff accounts use the password **`Test1234!`**

| Name | Username | Email | Role |
|------|----------|-------|------|
| Anita Gupta | `agupta` | `a.gupta@d3s3.com` | ADMIN |
| Priya Desai | `pdesai` | `p.desai@d3s3.com` | DOCTOR |
| Amit Patel | `apatel` | `a.patel@d3s3.com` | DOCTOR |
| Kiran Rao | `krao` | `k.rao@d3s3.com` | DOCTOR |
| Nandita Krishnan | `nkrishnan` | `n.krishnan@d3s3.com` | TRIAGE_NURSE |
| Sunil Varma | `svarma` | `s.varma@d3s3.com` | TRIAGE_NURSE |
| Sneha Kulkarni | `skulkarni` | `s.kulkarni@d3s3.com` | NURSE |
| Rohan Mehta | `rmehta` | `r.mehta@d3s3.com` | NURSE |
| Ravi Shankar | `rshankar` | `r.shankar@d3s3.com` | PARAMEDIC |
| Fatima Siddiqui | `fsiddiqui` | `f.siddiqui@d3s3.com` | GRIEVANCE_OFFICER |
| Chitra Nair | `cnair` | `c.nair@d3s3.com` | EDUCATION_TEAM |
| Meena Rao | `mrao` | `m.rao@d3s3.com` | DATA_ENTRY_OPERATOR |
| Vikram Singh | `vsingh` | `v.singh@d3s3.com` | DATA_ENTRY_OPERATOR |

Start with **Anita Gupta** (`agupta` / `Test1234!`) — she has ADMIN access and can reach every feature.

### Patient portal login — `http://localhost/d3s3/patient_login.php`

All three portal test accounts use the password **`Portal@1234`**

| Username | Email |
|----------|-------|
| `patient_priya` | `priya.patient@example.com` |
| `patient_rahul` | `rahul.patient@example.com` |
| `patient_ananya` | `ananya.patient@example.com` |

---

## Feature Tour

Once logged in as **Anita Gupta (ADMIN)**, here is a suggested order for exploring the system:

| Feature | URL | What to try |
|---------|-----|-------------|
| Dashboard | `dashboard.php` | Overview tiles and quick stats |
| Patients | `patients.php` | Search for a patient; open a profile |
| Intake / Queue | `intake.php` | Open a case sheet; move through triage tabs |
| Appointments | `appointments.php` | View scheduled visits; assign doctors |
| Labwork | `lab_results.php` | See pending lab orders; mark one complete |
| Messages | `messages.php` | Send an internal message; archive a message from your inbox |
| Tasks | `tasks.php` | Create a task; mark it done |
| Feedback | `feedback.php` | Review submitted grievances |
| Assets | `assets.php` | Browse the resource library; send an asset to a patient |
| Patient Messages | `portal_messages.php` | Reply to a patient portal message thread |
| Analytics | `analytics.php` | View visit trends and case distribution charts |
| User Management | `users.php` | View all staff accounts |
| Calendar | `calendar.php` | View camp/event schedule |

To see the **patient side**, open a second browser tab at `http://localhost/d3s3/patient_login.php` and log in as `patient_priya`.

---

## Registering a new staff account

If you want to create a new staff account through the self-registration form:

1. Go to `http://localhost/d3s3/emp_register.php`
2. Fill in the form — when prompted for a **Registration Code**, enter the value you set in `.env` (default: `devcode123`)
3. New accounts default to the `DATA_ENTRY_OPERATOR` role; an ADMIN can promote them from User Management

Alternatively, an ADMIN or SUPER_ADMIN can create accounts directly via the admin dashboard without a registration code.

---

## Troubleshooting

**Blank page or PHP errors**

- Confirm Apache and MySQL are running in the XAMPP control panel
- Check that the project is at `htdocs/d3s3/` (not `htdocs/d3s3-main/` or similar)
- Open `http://localhost/phpmyadmin` and verify the `core_app` database exists and has tables

**Redirect loop / "too many redirects"**

- You forgot Step 3. Open `d3s3/.htaccess` and comment out the Force HTTPS block.

**"Connection refused" when opening the app**

- Apache is not running. Open the XAMPP control panel and click Start next to Apache.

**"Access denied for user 'root'"**

- Your XAMPP MySQL has a root password set. Edit `d3s3/.env` and add it to `DB_PASS=`.

**phpMyAdmin import fails with a foreign key error**

- Click `core_app` in the left panel first (so it's selected as the active database) before importing. If you imported into the wrong database, drop it and reimport into a fresh `core_app`.

**Staff login says "Incorrect username or password"**

- Verify the import completed without errors in phpMyAdmin
- Check that you're logging in at `login.php`, not `patient_login.php`
- Staff password is `Test1234!` (capital T, exclamation mark)

**Patient portal login fails**

- Patient portal is at `patient_login.php`, not the staff `login.php`
- Portal password is `Portal@1234` (capital P, at-sign, no spaces)

**mod_rewrite / 404 errors on any page**

- macOS XAMPP: confirm Apache is running and that `mod_rewrite` is enabled in `httpd.conf` (it is by default in XAMPP 8.x)
- Windows XAMPP: check that `AllowOverride All` is set for the `htdocs` directory in `httpd.conf`

---

## What the database includes

The included `d3s3_database.sql` is a complete snapshot of the development database:

- Full schema (all tables, constraints, triggers, indexes)
- 2 SUPER_ADMIN accounts (Andrew Hawkinson, Gary Marks)
- 13 test staff accounts across all 9 roles
- 30 patients with varied demographics and medical histories
- Case sheets with clinical notes, diagnoses, prescriptions
- Appointments (scheduled, in-progress, completed)
- Lab orders (pending and completed)
- Internal messages (with per-recipient archive) and tasks
- Feedback/grievance entries
- 3 patient portal accounts linked to patients 1–3
- Sample portal message threads
- Analytics seed data (case sheets across April 2026)
- Asset library entries (URL-based; no local files needed)

---

*Exported from a working XAMPP 8.2 / MariaDB 10.4 environment — 2026-04-30*
