const express = require('express');
const router = express.Router();

const Diskusi = require('../models/diskusi');

router.get('/', (req, res) => {
    Diskusi.findAll({
        order: [
            ['createdAt', 'DESC'],
        ]
    }).then((data) => {
        res.json(data);
    })
})
router.post('/', (req, res) => {
    const data = req.body;
    Diskusi.create({
        idUser: data.idUser,
        judul: data.judul,
        konten: data.konten,
    }).then(
        res.json({
            message: "Diskusi berhasil ditambah",
            status: "berhasil",
        })
    ).catch((e) => {
        res.json({
            message: "Diskusi tidak dapat ditambah",
            status: "gagal",
        })
    })
})

module.exports = router;