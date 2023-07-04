const { DataTypes } = require('sequelize');
const koneksi = require('../koneksi');

const Users = require('./users');

const Diskusi = koneksi.define('diskusi', {
    idUser: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    judul: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    konten: {
        type: DataTypes.STRING,
        allowNull: false,
    },
}, {
    freezeTableName: true,
})

// Diskusi.belongsTo(Users, {foreignKey: 'idUser'});

module.exports = Diskusi;