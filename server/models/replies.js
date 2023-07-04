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
    upVotes: {
        type: DataTypes.JSON,
        allowNull: true,
    },
    downVotes: {
        type: DataTypes.JSON,
        allowNull: true,
    }
}, {
    freezeTableName: true,
})

module.exports = Replies;