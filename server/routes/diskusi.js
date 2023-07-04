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
    data.id = null;
    Diskusi.create(data).then((data) =>
        res.json({
            message: "Diskusi berhasil ditambah",
            status: "berhasil",
            data: data,
        })
    ).catch((e) => {
        res.json({
            message: "Diskusi tidak dapat ditambah",
            status: "gagal",
        })
    })
})
router.put('/', (req, res) => {
    const data = req.body;
    Diskusi.update(data, {
        where: {
            id: data.id,
        }
    }).then(
        res.json({
            message: "Diskusi berhasil diupdate",
            status: "berhasil",
        })
    ).catch((e) => {
        res.json({
            message: "Diskusi tidak dapat diupdate",
            status: "gagal",
        })
    })
})

module.exports = router;