const mongoose = require('mongoose');

const AlbumSchema = new mongoose.Schema({
    name: { type: String, required: true, unique: true },
    songs: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Song' }],
});

module.exports = mongoose.model('Album', AlbumSchema);
