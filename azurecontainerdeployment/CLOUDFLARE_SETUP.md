# Cloudflare Workers Setup Guide

## ✅ What's Been Created

### 1. **Cloudflare Worker Application** (`/cloudflare-worker/`)
A complete serverless application with TypeScript, Wrangler, and edge computing capabilities.

**Files:**
- `src/index.ts` - Main worker with API endpoints
- `wrangler.toml` - Worker configuration
- `package.json` - Dependencies and scripts
- `tsconfig.json` - TypeScript configuration
- `.env.example` - Environment variables template
- `.gitignore` - Git configuration
- `README.md` - Worker documentation

### 2. **D1 Database**
SQLite database with three tables:
- `items` - Stores database records
- `file_metadata` - Tracks R2 uploads
- `analytics` - Records events

**Files:**
- `migrations/001_init.sql` - Database schema

### 3. **R2 Storage**
Object storage bucket (`my-uploads`) for file uploads.

### 4. **GitHub Actions Pipeline** (`.github/workflows/deploy-cloudflare-workers.yml`)
Automated deployment with 4 jobs:
1. **Setup D1 & R2** - Creates database and bucket
2. **Apply Migrations** - Runs SQL schema
3. **Deploy Worker** - Deploys to Cloudflare
4. **Test Endpoints** - Verifies all endpoints
5. **Summary** - Generates deployment report

---

## 🚀 Getting Started

### Step 1: Install Dependencies
```bash
cd cloudflare-worker
npm install
```

### Step 2: Set Up Cloudflare Credentials
```bash
cp .env.example .env
```

Edit `.env` with your Cloudflare details:
```
CLOUDFLARE_API_TOKEN=your_token_here
CLOUDFLARE_ACCOUNT_ID=your_account_id_here
```

### Step 3: Local Development
```bash
npm run dev
```

Visit: `http://localhost:8787`

### Step 4: Create D1 Database
```bash
npm run d1:create
```

### Step 5: Create R2 Bucket
```bash
npm run r2:create
```

### Step 6: Apply Database Schema
```bash
wrangler d1 execute production-db --file=migrations/001_init.sql --remote
```

### Step 7: Deploy to Production
```bash
npm run deploy
```

---

## 📡 API Endpoints

### Health & Status
- `GET /health` - Health check

### Database (D1)
- `GET /api/items` - List all items
- `POST /api/items` - Create item
  ```json
  { "title": "...", "description": "..." }
  ```

### File Storage (R2)
- `GET /api/files` - List uploaded files
- `POST /api/upload` - Upload file (multipart/form-data)
- `DELETE /api/files/:key` - Delete file

### Analytics
- `GET /api/stats` - Storage statistics

---

## 🔑 GitHub Secrets Required

Add these to your GitHub repository:

1. **CLOUDFLARE_ACCOUNT_ID**
   - Found at: https://dash.cloudflare.com/account/api/overview
   - Label: "Account ID"

2. **CLOUDFLARE_API_TOKEN**
   - Create at: https://dash.cloudflare.com/account/api-tokens
   - Permissions needed: Workers, D1 Database, R2

### Steps to Add Secrets:
1. Go to GitHub repo → Settings → Secrets and Variables → Actions
2. Click "New repository secret"
3. Add `CLOUDFLARE_ACCOUNT_ID` value
4. Add `CLOUDFLARE_API_TOKEN` value
5. Save

---

## 📊 Database Schema

### items table
```sql
id INTEGER PRIMARY KEY AUTOINCREMENT
title TEXT NOT NULL
description TEXT NOT NULL
created_at DATETIME
updated_at DATETIME
```

### file_metadata table
```sql
id INTEGER PRIMARY KEY AUTOINCREMENT
key TEXT NOT NULL UNIQUE
original_name TEXT
size INTEGER
content_type TEXT
uploaded_by TEXT
uploaded_at DATETIME
metadata TEXT
```

### analytics table
```sql
id INTEGER PRIMARY KEY AUTOINCREMENT
event_type TEXT NOT NULL
event_data TEXT
user_agent TEXT
ip_address TEXT
timestamp DATETIME
```

---

## 🛠️ Useful Commands

```bash
# Development
npm run dev              # Start local dev server

# Database Management
npm run d1:list        # List all D1 databases
npm run d1:create      # Create D1 database

# Storage Management
npm run r2:list        # List R2 buckets
npm run r2:create      # Create R2 bucket

# Deployment
npm run build          # Build TypeScript
npm run deploy         # Deploy to Cloudflare
```

---

## 🔄 Deployment Flow

### Push to Main Branch
```
Push to main → GitHub Actions triggered
  ├─ Job 1: Setup D1 & R2
  ├─ Job 2: Deploy Worker
  ├─ Job 3: Test Endpoints
  └─ Job 4: Summary Report
```

The workflow automatically:
1. Creates D1 database if it doesn't exist
2. Creates R2 bucket if it doesn't exist
3. Applies database migrations
4. Deploys the worker
5. Tests all endpoints
6. Generates a summary

---

## 🚨 Troubleshooting

### "D1 Database Error"
```bash
# Check if database exists
npm run d1:list

# Re-create database
npm run d1:create

# Apply migrations
wrangler d1 execute production-db --file=migrations/001_init.sql --remote
```

### "R2 Bucket Not Found"
```bash
# List buckets
npm run r2:list

# Create bucket
npm run r2:create
```

### "Deployment Fails"
1. Check GitHub Actions logs for details
2. Verify `CLOUDFLARE_ACCOUNT_ID` and `CLOUDFLARE_API_TOKEN` in secrets
3. Ensure API token has required permissions
4. Check that wrangler.toml has correct database_id

### "Local Dev Server Won't Start"
```bash
# Clear Wrangler cache
rm -rf .wrangler

# Reinstall dependencies
npm install

# Start dev server
npm run dev
```

---

## 📁 Project Structure

```
/
├── .github/
│   └── workflows/
│       └── deploy-cloudflare-workers.yml   ← Automated deployment
├── cloudflare-worker/                      ← Main worker app
│   ├── src/
│   │   └── index.ts                       ← Worker code
│   ├── migrations/
│   │   └── 001_init.sql                   ← Database schema
│   ├── wrangler.toml                      ← Configuration
│   ├── package.json                       ← Dependencies
│   ├── tsconfig.json                      ← TypeScript config
│   └── README.md                          ← Worker docs
├── main.tf                                ← Terraform (ACA)
├── provider.tf                            ← Terraform provider
├── variables.tf                           ← Terraform variables
└── CLOUDFLARE_SETUP.md                    ← This file
```

---

## 🔐 Security Best Practices

1. **Never commit `.env`** - Use `.env.example` as template
2. **Use GitHub Secrets** - Store sensitive tokens there
3. **Rotate API tokens** - Periodically update tokens
4. **Limit permissions** - Use least-privilege API tokens
5. **Monitor deployments** - Check GitHub Actions logs
6. **Enable 2FA** - Secure your Cloudflare account

---

## 📚 Resources

- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [D1 Documentation](https://developers.cloudflare.com/d1/)
- [R2 Documentation](https://developers.cloudflare.com/r2/)
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/)
- [GitHub Actions Docs](https://docs.github.com/en/actions)

---

## ✨ Next Steps

1. ✅ Install dependencies: `npm install`
2. ✅ Set up `.env` file
3. ✅ Test locally: `npm run dev`
4. ✅ Create D1 & R2: `npm run d1:create && npm run r2:create`
5. ✅ Add GitHub secrets
6. ✅ Deploy: `npm run deploy` or push to main

---

**All components are now set up and ready to use!**
