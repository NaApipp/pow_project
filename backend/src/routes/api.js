const { Router } = require('express');

const router = Router();

// Contoh data in-memory
let items = [
  { id: 1, name: 'Item A' },
  { id: 2, name: 'Item B' },
];

router.get('/items', (req, res) => {
  res.json({ success: true, data: items });
});

router.post('/items', (req, res) => {
  const { name } = req.body;
  if (!name) return res.status(400).json({ error: 'Name is required' });

  const newItem = { id: Date.now(), name };
  items.push(newItem);
  res.status(201).json({ success: true, data: newItem });
});

router.delete('/items/:id', (req, res) => {
  const id = Number(req.params.id);
  items = items.filter(item => item.id !== id);
  res.json({ success: true, message: 'Item deleted' });
});

module.exports = router;