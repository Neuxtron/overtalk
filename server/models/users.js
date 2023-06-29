const { DataTypes } = require('sequelize');
const koneksi = require('../koneksi');

const Users = koneksi.define('users', {
    email: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    nama: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    bookmarks: {
        type: DataTypes.JSON,
        allowNull: false,
    }
}, {
    freezeTableName: true,
})

module.exports = Users;