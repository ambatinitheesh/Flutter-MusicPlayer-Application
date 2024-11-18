const Song = require('../Model/Song');
const Album = require('../Model/Album');

// Add a new song to the database
exports.addSong = async (req, res) => {
    try {
        const { title, artist, duration, filePath } = req.body;
        const song = new Song({ title, artist, duration, filePath });
        await song.save();
        res.status(201).json({ message: 'Song added successfully!', song });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Add a song to an album
exports.addSongToAlbum = async (req, res) => {
    try {
        const { albumId, songId } = req.body;

        const album = await Album.findById(albumId);
        if (!album) {
            return res.status(404).json({ message: 'Album not found!' });
        }

        album.songs.push(songId);
        await album.save();

        res.status(200).json({ message: 'Song added to album successfully!', album });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Get all songs in an album
exports.getAlbumSongs = async (req, res) => {
    try {
        const { albumId } = req.params;

        const album = await Album.findById(albumId).populate('songs');
        if (!album) {
            return res.status(404).json({ message: 'Album not found!' });
        }

        res.status(200).json({ album, songs: album.songs });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Add default songs to the database on app startup
exports.addDefaultSongs = async () => {
    const defaultSongs = [
        { title: 'Song 1', artist: 'Artist 1', duration: 240, filePath: '/path/song1.mp3' },
        { title: 'Song 2', artist: 'Artist 2', duration: 300, filePath: '/path/song2.mp3' },
    ];

    for (const songData of defaultSongs) {
        const existingSong = await Song.findOne({ title: songData.title });
        if (!existingSong) {
            const song = new Song(songData);
            await song.save();
        }
    }
};
