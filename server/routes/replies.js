const express = require('express');
const router = express.Router();

const Replies = require('../models/replies');

router.get('/', (req, res) => {
    const idDiskusi = parseInt(req.query.id_diskusi)
    Replies.findAll({
        where: {
            idDiskusi: idDiskusi,
        }
    }).then((data) => {
        res.json(data);
    })
})
router.post('/', (req, res) => {
    const data = req.body;
    Replies.create({
        idDiskusi: data.idDiskusi,
        idUser: data.idUser,
        reply: data.reply,
    }).then(() => {
        res.json({
            message: "User berhasil ditambah",
            status: "berhasil",
        })
    }).catch((e) => (
        res.json({
            message: "User tidak dapat ditambah",
            error: e,
            status: "gagal",
        })
    ))
})

module.exports = router;