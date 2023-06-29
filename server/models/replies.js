const { DataTypes } = require('sequelize');
const koneksi = require('../koneksi');

const Replies = koneksi.define('replies', {
    idDiskusi: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    idUser: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    reply: {
        type: DataTypes.TEXT,
        allowNull: false,
    },
}, {
    freezeTableName: true,
})

module.exports = Replies;