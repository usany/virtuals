import { Router } from 'itty-router';

interface Env {
  DB: D1Database;
  BUCKET: R2Bucket;
  ANALYTICS: AnalyticsEngineDataset;
}

interface Item {
  id: number;
  title: string;
  description: string;
  created_at: string;
}

interface FileObject {
  key: string;
  size: number;
  uploaded: string;
}

const router = Router();

// Health check endpoint
router.get('/health', () => {
  return new Response(JSON.stringify({ status: 'ok' }), {
    headers: { 'Content-Type': 'application/json' },
  });
});

// GET all items from D1
router.get('/api/items', async (req, env: Env) => {
  try {
    const { results } = await env.DB.prepare(
      'SELECT id, title, description, created_at FROM items ORDER BY created_at DESC'
    ).all();

    return new Response(JSON.stringify({ items: results }), {
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: 'Failed to fetch items' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
});

// POST new item to D1
router.post('/api/items', async (req, env: Env) => {
  try {
    const { title, description } = (await req.json()) as { title: string; description: string };

    if (!title || !description) {
      return new Response(JSON.stringify({ error: 'Title and description required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    const result = await env.DB.prepare(
      'INSERT INTO items (title, description, created_at) VALUES (?, ?, datetime("now")) RETURNING *'
    )
      .bind(title, description)
      .first();

    return new Response(JSON.stringify({ item: result }), {
      status: 201,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: 'Failed to create item' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
});

// GET all files from R2
router.get('/api/files', async (req, env: Env) => {
  try {
    const list = await env.BUCKET.list();
    const files: FileObject[] = list.objects.map((obj) => ({
      key: obj.key,
      size: obj.size,
      uploaded: obj.uploaded?.toISOString() || '',
    }));

    return new Response(JSON.stringify({ files }), {
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: 'Failed to list files' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
});

// POST file upload to R2
router.post('/api/upload', async (req, env: Env) => {
  try {
    const formData = await req.formData();
    const file = formData.get('file') as File;

    if (!file) {
      return new Response(JSON.stringify({ error: 'File required' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    const key = `${Date.now()}-${file.name}`;
    const buffer = await file.arrayBuffer();

    await env.BUCKET.put(key, buffer, {
      httpMetadata: {
        contentType: file.type,
      },
    });

    return new Response(JSON.stringify({ key, size: file.size, name: file.name }), {
      status: 201,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: 'Failed to upload file' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
});

// DELETE file from R2
router.delete('/api/files/:key', async (req, env: Env) => {
  try {
    const key = req.params.key as string;
    await env.BUCKET.delete(key);

    return new Response(JSON.stringify({ success: true, key }), {
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: 'Failed to delete file' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
});

// GET statistics
router.get('/api/stats', async (req, env: Env) => {
  try {
    const itemsResult = await env.DB.prepare('SELECT COUNT(*) as count FROM items').first();
    const filesResult = await env.BUCKET.list();

    return new Response(
      JSON.stringify({
        items_count: itemsResult?.count || 0,
        files_count: filesResult.objects.length,
        storage_used: filesResult.objects.reduce((sum, obj) => sum + obj.size, 0),
      }),
      {
        headers: { 'Content-Type': 'application/json' },
      }
    );
  } catch (error) {
    return new Response(JSON.stringify({ error: 'Failed to get stats' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
});

// 404 handler
router.all('*', () => {
  return new Response(JSON.stringify({ error: 'Not found' }), {
    status: 404,
    headers: { 'Content-Type': 'application/json' },
  });
});

export default {
  fetch: router.handle,
};
