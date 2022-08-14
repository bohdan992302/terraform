const express = require('express');
const app = express();

app.get("/healthcheck", async(req,res) => {
        res.sendStatus(200);
});

app.get('*', function(req, res){
    res.status(404).send('Not found');
  });

//running server
const PORT = process.env.PORT || 5000;
app.listen(PORT, ()=> console.log(`Server is running on port ${PORT}`));