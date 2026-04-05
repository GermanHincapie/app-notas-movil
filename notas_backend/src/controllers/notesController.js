const pool = require('../config/db');

const getNotes = async (req, res) => {
  try {
    const userId = req.user.id;

    const [notes] = await pool.query(
      'SELECT * FROM notes WHERE user_id = ? ORDER BY updated_at DESC',
      [userId]
    );

    res.json(notes);
  } catch (error) {
    res.status(500).json({
      message: 'Error al obtener notas',
      error: error.message
    });
  }
};

const createNote = async (req, res) => {
  try {
    const userId = req.user.id;
    const { title, content } = req.body;

    const [result] = await pool.query(
      'INSERT INTO notes (user_id, title, content) VALUES (?, ?, ?)',
      [userId, title, content]
    );

    res.status(201).json({
      message: 'Nota creada correctamente',
      noteId: result.insertId
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error al crear nota',
      error: error.message
    });
  }
};

const updateNote = async (req, res) => {
  try {
    const userId = req.user.id;
    const noteId = req.params.id;
    const { title, content } = req.body;

    await pool.query(
      'UPDATE notes SET title = ?, content = ? WHERE id = ? AND user_id = ?',
      [title, content, noteId, userId]
    );

    res.json({
      message: 'Nota actualizada correctamente'
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error al actualizar nota',
      error: error.message
    });
  }
};

const deleteNote = async (req, res) => {
  try {
    const userId = req.user.id;
    const noteId = req.params.id;

    await pool.query(
      'DELETE FROM notes WHERE id = ? AND user_id = ?',
      [noteId, userId]
    );

    res.json({
      message: 'Nota eliminada correctamente'
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error al eliminar nota',
      error: error.message
    });
  }
};

module.exports = {
  getNotes,
  createNote,
  updateNote,
  deleteNote
};