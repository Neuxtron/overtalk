const express = require('express');
const app = express();
const PORT = 3000;

const usersRouter = require('./routes/users');
const diskusiRouter = require('./routes/diskusi');
const repliesRouter = require('./routes/replies');

app.use(express.json());

app.use('/users', usersRouter);
app.use('/diskusi', diskusiRouter);
app.use('/replies', repliesRouter);

app.listen(PORT, () => {console.log(`Listening on port ${PORT}`)});