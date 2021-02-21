const express = require('express');
const router = express.Router();

const mysqlConnection = require('../database');

router.get('/solicitud_comunidad/:fk_comunidad_solicitud/:estado_solicitud', (req, res) => {
    const { fk_comunidad_solicitud, estado_solicitud } = req.params;
    mysqlConnection.query('SELECT * FROM solicitud WHERE fk_comunidad_solicitud=? AND estado_solicitud=?', [fk_comunidad_solicitud, estado_solicitud], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});
// solicitudes de un usuario a una comunidad (en caso de haber sido rechazado puede er una lista)
router.get('/solicitud_comunidad/usuario/:fk_comunidad_solicitud/:fk_usuario_solicitud', (req, res) => {
    const { fk_comunidad_solicitud, fk_usuario_solicitud } = req.params;
    mysqlConnection.query('SELECT * FROM solicitud WHERE fk_comunidad_solicitud=? AND fk_usuario_solicitud=?', [fk_comunidad_solicitud, fk_usuario_solicitud], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});



router.post('/crear_solicitud', (req, res) => {
    const { fk_comunidad_solicitud, fk_usuario_solicitud, voto_maximo, descripcion_solicitud } = req.body;
    const query = `
        INSERT INTO Solicitud (fk_comunidad_solicitud, fk_usuario_solicitud, voto_maximo, 
            negativas_acumuladas, estado_solicitud, descripcion_solicitud)
        VALUES
        (?,?,?,?,?,?)
    `;
    mysqlConnection.query(query, [fk_comunidad_solicitud, fk_usuario_solicitud, voto_maximo,
            '0', 'p', descripcion_solicitud
        ],
        (err, rows, fields) => {
            if (!err) {
                res.json({ status: 'Ok' });
            } else {
                console.log(err);
            }
        });
});



router.put('/modificar_solicitud_voto/:idSolicitud', (req, res) => {
    const { idSolicitud } = req.params;
    const { estado_solicitud } = req.body;
    const query = 'UPDATE solicitud SET estado_solicitud = ? WHERE id_solicitud =? ;';
    mysqlConnection.query(query, [estado_solicitud, idSolicitud], (err, rows, fields) => {
        if (!err) {
            res.json(rows);

        } else {
            console.log(err);
        }
    });
});

router.put('/modificar_solicitud_estado/:idSolicitud', (req, res) => {
    const { idSolicitud } = req.params;
    const { negativas_acumuladas, estado_solicitud } = req.body;
    const query = 'UPDATE solicitud SET negativas_acumuladas=? , estado_solicitud = ? WHERE id_solicitud =? ;';
    mysqlConnection.query(query, [negativas_acumuladas, estado_solicitud, idSolicitud], (err, rows, fields) => {
        if (!err) {
            res.json(rows);

        } else {
            console.log(err);
        }
    });
});



module.exports = router;