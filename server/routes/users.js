const express = require('express');
const router = express.Router();

const Users = require('../models/users');

router.get('/', (req, res) => {
    Users.findAll().then((data) => {
        res.json(data);
    })
})
router.get('/single', (req, res) => {
    const email = req.query.email;
    Users.findAll({
        where: {
            email: email,
        }
    }).then((data) => {
        res.json(data);
    })
})
router.post('/', (req, res) => {
    const data = req.body;
    Users.create({
        email: data.email,
        nama: data.nama,
        bookmarks: [],
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
router.put('/', (req, res) => {
    const data = req.body;
    Users.update({
        email: data.email,
        nama: data.nama,
        bookmarks: data.bookmarks,
    },{
        where: {
            id: parseInt(data.id),
        }
    }).then(() => {
        res.json({
            message: "User berhasil diupdate",
            status: "berhasil",
        })
    }).catch((e) => {
        res.json({
            message: "User tidak dapat diupdate",
            error: e,
            status: "gagal",
        })
    })
})
router.delete('/', (req, res) => {
    const data = req.body;
    Users.destroy({
        where: {
            id: data.id,
        }
    }).then(() => {
        res.json({
            message: "User berhasil dihapus",
            status: "berhasil",
        })
    }).catch((e) => (
        res.json({
            message: "User tidak dapat dihapus",
            error: e,
            status: "gagal",
        })
    ))
})

module.exports = router;