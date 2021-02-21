const express = require('express');
const router = express.Router();

const mysqlConnection = require('../database');

var findComunidadByName = function(nombre_comunidad, callback) {

    mysqlConnection.query('select * from comunidad where ')
    if (!comunidad[username])
        return callback(new Error(
            'No user matching ' +
            username
        ));
    return callback(null, users[username]);
};


router.get('/comunidades', (req, res) => {
    mysqlConnection.query('SELECT * FROM comunidad', (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/comunidades/id/:id_comunidad', (req, res) => {
    const { id_comunidad } = req.params;
    mysqlConnection.query('SELECT * FROM comunidad WHERE id_comunidad = ?', [id_comunidad], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/comunidades/nombre/:nombre_comunidad', (req, res) => {
    const { nombre_comunidad } = req.params;
    mysqlConnection.query('SELECT * FROM comunidad WHERE nombre_comunidad = ?', [nombre_comunidad], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.post('/crear_comunidad', (req, res) => {
    const { nombre_comunidad, descripcion_comunidad } = req.body;
    mysqlConnection.query('INSERT INTO comunidad (nombre_comunidad, descripcion_comunidad) values (?,?)', [nombre_comunidad, descripcion_comunidad],
        (err, rows, fields) => {
            if (!err) {
                res.json({ status: 'Ok' });
            } else {
                console.log(err);
            }
        });
});



module.exports = router;