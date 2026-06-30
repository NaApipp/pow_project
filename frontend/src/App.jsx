import { useEffect, useState } from 'react';
import { apiFetch } from './api/client';

export default function App() {
  const [items, setItems] = useState([]);
  const [name, setName] = useState('');
  const [error, setError] = useState('');

  const fetchItems = async () => {
    const res = await apiFetch('/items');
    setItems(res.data);
  };

  useEffect(() => { fetchItems(); }, []);

  const handleAdd = async () => {
    try {
      await apiFetch('/items', {
        method: 'POST',
        body: JSON.stringify({ name }),
      });
      setName('');
      setError('');
      fetchItems();
    } catch (err) {
      setError(err.message);
    }
  };

  const handleDelete = async (id) => {
    await apiFetch(`/items/${id}`, { method: 'DELETE' });
    fetchItems();
  };

  return (
    <div style={{ padding: '2rem', fontFamily: 'sans-serif' }}>
      <h1>Items</h1>

      <div>
        <input
          value={name}
          onChange={e => setName(e.target.value)}
          placeholder="Nama item..."
        />
        <button onClick={handleAdd}>Tambah</button>
        {error && <p style={{ color: 'red' }}>{error}</p>}
      </div>

      <ul>
        {items.map(item => (
          <li key={item.id}>
            {item.name}{' '}
            <button onClick={() => handleDelete(item.id)}>Hapus</button>
          </li>
        ))}
      </ul>
    </div>
  );
}