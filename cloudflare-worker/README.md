# Cloudflare Worker with D1 & R2

A serverless Cloudflare Worker application with integrated D1 database and R2 object storage.

## Features

- **Cloudflare Workers** - Serverless compute at the edge
- **D1 Database** - SQLite database for storing items and metadata
- **R2 Storage** - Object storage for file uploads
- **TypeScript** - Full TypeScript support
- **Itty-Router** - Lightweight routing framework
- **GitHub Actions** - Automated deployment pipeline

## Project Structure

```
cloudflare-worker/
├── src/
│   └── index.ts           # Main worker application
├── migrations/
│   └── 001_init.sql       # Database schema
├── wrangler.toml          # Wrangler configuration
├── package.json           # Dependencies and scripts
├── tsconfig.json          # TypeScript configuration
└── .env.example           # Environment variables template
```

## Quick Start

### 1. Install Dependencies

```bash
cd cloudflare-worker
npm install
```

### 2. Configure Cloudflare

Create a `.env` file based on `.env.example`:

```bash
cp .env.example .env
```

Add your Cloudflare API token and Account ID:

```bash
CLOUDFLARE_API_TOKEN=your_token_here
CLOUDFLARE_ACCOUNT_ID=your_account_id_here
```

### 3. Local Development

```bash
npm run dev
```

The worker will be available at `http://localhost:8787`

### 4. Create D1 Database

```bash
npm run d1:create
```

### 5. Create R2 Bucket

```bash
npm run r2:create
```

### 6. Apply Database Migrations

```bash
wrangler d1 execute production-db --file=migrations/001_init.sql --remote
```

### 7. Deploy to Production

```bash
npm run deploy
```

## API Endpoints

### Health Check
- `GET /health` - Worker health status

### Items (D1 Database)
- `GET /api/items` - List all items
- `POST /api/items` - Create new item
  ```json
  {
    "title": "Item title",
    "description": "Item description"
  }
  ```

### Files (R2 Storage)
- `GET /api/files` - List all uploaded files
- `POST /api/upload` - Upload new file (form-data)
- `DELETE /api/files/:key` - Delete file by key

### Statistics
- `GET /api/stats` - Get storage and item statistics
  ```json
  {
    "items_count": 10,
    "files_count": 5,
    "storage_used": 1024000
  }
  ```

## Environment Variables

See `.env.example` for all available configuration options.

## GitHub Actions Deployment

The repository includes automated GitHub Actions workflows that:

1. **Setup D1 & R2** - Creates database and bucket if they don't exist
2. **Apply Migrations** - Runs SQL migrations on deployment
3. **Deploy Worker** - Deploys the worker to Cloudflare
4. **Test Endpoints** - Verifies all endpoints are working
5. **Summary** - Creates a deployment summary

### Required Secrets

Add these to GitHub repository secrets:
- `CLOUDFLARE_ACCOUNT_ID` - Your Cloudflare Account ID
- `CLOUDFLARE_API_TOKEN` - Your Cloudflare API Token

## Database Schema

The D1 database includes three tables:

### items
- `id` - Primary key (auto-increment)
- `title` - Item title
- `description` - Item description
- `created_at` - Creation timestamp
- `updated_at` - Last update timestamp

### file_metadata
- `id` - Primary key
- `key` - R2 object key
- `original_name` - Original filename
- `size` - File size in bytes
- `content_type` - MIME type
- `uploaded_by` - User who uploaded
- `uploaded_at` - Upload timestamp
- `metadata` - JSON metadata

### analytics
- `id` - Primary key
- `event_type` - Type of event
- `event_data` - Event details (JSON)
- `user_agent` - User agent string
- `ip_address` - Client IP address
- `timestamp` - Event timestamp

## Useful Commands

```bash
# Development
npm run dev              # Start local development server

# Database
npm run d1:list        # List D1 databases
npm run d1:create      # Create D1 database

# Storage
npm run r2:list        # List R2 buckets
npm run r2:create      # Create R2 bucket

# Deployment
npm run build          # Build TypeScript
npm run deploy         # Deploy to Cloudflare
```

## Troubleshooting

### Database Connection Issues
- Verify `CLOUDFLARE_API_TOKEN` is set
- Check that D1 database ID is in `wrangler.toml`
- Run `npm run d1:list` to confirm database exists

### R2 Upload Errors
- Verify R2 bucket exists: `npm run r2:list`
- Check file size limits (default 100MB)
- Ensure bucket binding in `wrangler.toml` is correct

### Deployment Failures
- Check GitHub Actions logs
- Verify all required secrets are set
- Ensure Cloudflare API token has appropriate permissions

## Security

- Store sensitive credentials in `.env` and GitHub Secrets
- Never commit `.env` file to version control
- Use least-privilege access for API tokens
- Implement authentication for production endpoints

## License

MIT
