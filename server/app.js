const express = require("express");
const mongoose = require("mongoose");
const userRoutes=require('./Routes/userRoutes')
const albumRoutes = require('./Routes/AlbumRoutes');
const app = express();
app.use(express.json());
app.get("/", (req, res) => {
  res.send("Helloworld!!!!!");
});
app.use('/api',userRoutes)
const URI ="mongodb+srv://2200032344cseh:nitheesh@cluster0.ypqkmbr.mongodb.net/musicmp3?retryWrites=true&w=majority&appName=Cluster0"
mongoose
  .connect(URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(console.log("Mongodb Connected Successfully......"))
  .catch((err) => {
    console.log(err);
  });

app.use('/api', albumRoutes);
    
app.listen(5000, () => {
  console.log("Server Run on 5000");
});