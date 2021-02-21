const express = require('express');
const router = express.Router();
const mysqlConnection = require('../database');


// Ver las publicaciones dependiendo de un tipo de publicacion
router.get('/publicaciones/:fk_tipo_publicacion', (req, res) => {
    const { fk_tipo_publicacion } = req.params;
    mysqlConnection.query('SELECT * FROM publicacion WHERE fk_tipo_publicacion = ?', [fk_tipo_publicacion], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/publicaciones/', (req, res) => {
    mysqlConnection.query('SELECT * FROM publicacion', (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});


// Ver las publicaciones de un usuario por tipo de publicacion
router.get('/publicaciones/usuario/:fk_usuario_publicacion/:fk_tipo_publicacion', (req, res) => {
    const { fk_usuario_publicacion, fk_tipo_publicacion } = req.params;
    mysqlConnection.query('SELECT * FROM publicacion WHERE fk_usuario_publicacion = ? AND fk_tipo_publicacion = ?', [fk_usuario_publicacion, fk_tipo_publicacion], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/publicaciones/comunidad/:fk_comunidad_publicacion/:fk_tipo_publicacion', (req, res) => {
    const { fk_comunidad_publicacion, fk_tipo_publicacion } = req.params;
    mysqlConnection.query('SELECT * FROM publicacion WHERE fk_comunidad_publicacion = ? AND fk_tipo_publicacion = ?', [fk_comunidad_publicacion, fk_tipo_publicacion], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/publicaciones/flyer/:fk_comunidad_publicacion/:fk_usuario_publicacion/:fk_tipo_publicacion', (req, res) => {
    const { fk_comunidad_publicacion, fk_tipo_publicacion, fk_usuario_publicacion } = req.params;
    mysqlConnection.query('SELECT * FROM publicacion WHERE fk_comunidad_publicacion = ? AND fk_tipo_publicacion = ? AND fk_usuario_publicacion = ?', [fk_comunidad_publicacion, fk_tipo_publicacion, fk_usuario_publicacion], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

// Ver las publicaciones de un usuario
router.get('/publicaciones/usuario/:fk_usuario_publicacion', (req, res) => {
    const { fk_usuario_publicacion } = req.params;
    mysqlConnection.query('SELECT * FROM publicacion WHERE fk_usuario_publicacion = ?', [fk_usuario_publicacion], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});


router.post('/crear_publicacion', (req, res) => {
    const { fk_tipo_publicacion, titulo_publicacion, descripcion_publicacion, flyer_publicacion, fk_comunidad_publicacion, fk_usuario_publicacion, flyer_link, fk_categoria } = req.body;
    
    // realFile = Buffer.from(flyer_publicacion, "base64");
    const query = `
        INSERT INTO Publicacion (fk_tipo_publicacion, titulo_publicacion, descripcion_publicacion, 
            flyer_publicacion, fk_comunidad_publicacion, fk_usuario_publicacion,flyer_link, fk_categoria)
        VALUES
        (?,?,?,?,?,?,?,?)
    `;
    mysqlConnection.query(query, [fk_tipo_publicacion, titulo_publicacion, descripcion_publicacion, flyer_publicacion, fk_comunidad_publicacion, fk_usuario_publicacion, flyer_link, fk_categoria],
        (err, rows, fields) => {
            if (!err) {
                res.json({ status: 'Ok' });
            } else {
                console.log(err);
            }
        });
});


router.delete('/eliminar_publicacion/:id_publicacion', (req, res) => {
    const {id_publicacion} = req.params;
    mysqlConnection.query('DELETE FROM publicacion WHERE id_publicacion = ?', [id_publicacion], (err, rows, fields) =>{
        if(!err){
            res.json({Status: 'Publicación Eliminada'});
        }else{
            console.log(err);
        }
    });
});


router.put('/modificar_publicacion/:id_publicacion', (req, res) =>{
    const {id_publicacion} = req.params;
    const {titulo_publicacion, descripcion_publicacion, flyer_publicacion} = req.body;
    const query = 'UPDATE publicacion SET titulo_publicacion = ?, descripcion_publicacion=?, flyer_publicacion=? where id_publicacion =?;';
    mysqlConnection.query(query, [titulo_publicacion, descripcion_publicacion, flyer_publicacion, id_publicacion], (err, rows, fields) =>{
        if(!err){
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

module.exports = router;