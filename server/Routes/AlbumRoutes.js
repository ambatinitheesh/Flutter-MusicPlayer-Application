const express = require('express');
const router = express.Router();
const AlbumController = require('../Controller/AlbumController')

// Route to add a song
router.post('/songs', AlbumController.addSong);

// Route to add a song to an album
router.post('/albums/add-song', AlbumController.addSongToAlbum);

// Route to get songs in an album
router.get('/albums/:albumId/songs', AlbumController.getAlbumSongs);

module.exports = router;
