const { Sequelize } = require('sequelize');
const sequelize = new Sequelize('overtalk', 'root', '', {
    host: 'localhost',
    dialect: 'mysql',
});

try {
    sequelize.sync({alter: true});
    console.log("Koneksi Berhasil");
} catch (error) {
    console.log("Koneksi Gagal: ", error);
}

module.exports = sequelize;