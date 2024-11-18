const mongoose = require('mongoose');

const SongSchema = new mongoose.Schema({
    title: { type: String, required: true },
    artist: { type: String, required: true },
    duration: { type: Number, required: true }, // Duration in seconds
    filePath: { type: String, required: true }, // Path of the song file
});

module.exports = mongoose.model('Song', SongSchema);
