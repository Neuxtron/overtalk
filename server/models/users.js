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
    fotoUrl: {
        type: DataTypes.TEXT,
        allowNull: false,
    },
    bookmarks: {
        type: DataTypes.JSON,
        allowNull: false,
    },
    token: {
        type: DataTypes.STRING,
        allowNull: true,
    },
    role: {
        type: DataTypes.STRING,
        allowNull: false,
        defaultValue: "user"
    },
    adminPass: {
        type: DataTypes.STRING,
        allowNull: false,
        defaultValue: ""
    },
}, {
    freezeTableName: true,
})

module.exports = Users;