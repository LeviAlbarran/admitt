const express = require('express');
const router = express.Router();

const mysqlConnection = require('../database');
const { route } = require('./publicaciones');


router.get('/comuser/', (req, res) => {
    mysqlConnection.query('SELECT * FROM comunidad_usuario', (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/comuser/usuarios/:pk_comunidad/:miembro_comunidad', (req, res) => {
    const { pk_comunidad, miembro_comunidad } = req.params;
    mysqlConnection.query('SELECT * FROM comunidad_usuario WHERE pk_comunidad=? AND miembro_comunidad=?', [pk_comunidad, miembro_comunidad],
        (err, rows, fields) => {
            if (!err) {
                res.json(rows);
            } else {
                console.log(err);
            }
        });
});




router.post('/crear_comuser', (req, res) => {
    const { pk_comunidad, pk_usuario } = req.body;
    const query = `INSERT INTO comunidad_usuario (pk_comunidad , pk_usuario , cantidad_flyer , cantidad_muro , cantidad_dato , miembro_comunidad) VALUES (?,?,?,?,?,?)`;
    mysqlConnection.query(query, [pk_comunidad, pk_usuario, '0', '0', '0', 's'],
        (err, rows, fields) => {
            if (!err) {
                res.json({ status: 'Ok' });
            } else {
                console.log(err);
            }
        });
});

router.post('/crear_comuser_solicitud', (req, res) => {
    const { pk_comunidad, pk_usuario } = req.body;
    const query = `INSERT INTO comunidad_usuario (pk_comunidad , pk_usuario , cantidad_flyer , cantidad_muro , cantidad_dato , miembro_comunidad) VALUES (?,?,?,?,?,?)`;
    mysqlConnection.query(query, [pk_comunidad, pk_usuario, '0', '0', '0', 'n'],
        (err, rows, fields) => {
            if (!err) {
                res.json({ status: 'Ok' });
            } else {
                console.log(err);
            }
        });
});


//actualizar cualquier elemento de la tabla

router.put('/update_comuser/:pk_comunidad/:pk_usuario', (req, res) => {
    const { cantidad_flyer, cantidad_muro, cantidad_dato, miembro_comunidad } = req.body;
    const { pk_comunidad, pk_usuario } = req.params;
    const query = `
    UPDATE comunidad_usuario SET  cantidad_flyer = ?, cantidad_muro = ?, cantidad_dato = ?, miembro_comunidad =? WHERE pk_comunidad =? AND pk_usuario=?
      `;
    mysqlConnection.query(query, [cantidad_flyer, cantidad_muro, cantidad_dato, miembro_comunidad, pk_comunidad, pk_usuario], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });

});

//actualizar solo si es miembro
router.put('/update_comuser/miembro/:pk_comunidad/:pk_usuario', (req, res) => {
    const { pk_comunidad, pk_usuario } = req.params;
    const { miembro_comunidad } = req.body;

    const query = `
    UPDATE comunidad_usuario SET  miembro_comunidad =? WHERE pk_comunidad =? AND pk_usuario=?
      `;
    mysqlConnection.query(query, [miembro_comunidad, pk_comunidad, pk_usuario], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });

});



router.delete('/eliminar_publicacion/:id_publicación', (req, res) => {
    const { id_publicacion } = req.params;
    mysqlConnection.query('DELETE FROM publicacion WHERE id_publicacion = ?', [id_publicacion], (err, rows, fields) => {
        if (!err) {
            res.json({ Status: 'Publicación eliminada' });
        } else {
            console.log(err);
        }
    });
});

// Seleccionar comunidades de un usuario por id de usuario

router.get('/comunidad_usuario/usuario/:id_usuario', (req, res) => {
    const { id_usuario } = req.params;
    const query = `
    SELECT * FROM comunidad_usuario INNER JOIN usuario ON pk_usuario = id_usuario INNER JOIN comunidad ON pk_comunidad = id_comunidad WHERE id_usuario = ? 
    `;
    mysqlConnection.query(query, [id_usuario], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});
// Seleccionar comunidades de un usuario por correo
router.get('/comunidad_usuario/correo/:correo_usuario/:miembro_comunidad', (req, res) => {
    const { correo_usuario, miembro_comunidad } = req.params;
    const query = `
    SELECT id_comunidad, nombre_comunidad, descripcion_comunidad FROM comunidad_usuario INNER JOIN usuario ON pk_usuario = id_usuario INNER JOIN comunidad ON pk_comunidad = id_comunidad WHERE correo_usuario = ? AND miembro_comunidad=? 
    `;
    mysqlConnection.query(query, [correo_usuario, miembro_comunidad], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});
// Seleccionar comunidades del usuario a las que pertenece
router.get('/comunidad_usuario/id/:id_usuario', (req, res) => {
    const { id_usuario } = req.params;
    const query = `
    SELECT id_comunidad, nombre_comunidad, descripcion_comunidad FROM comunidad_usuario INNER JOIN usuario ON pk_usuario = id_usuario INNER JOIN comunidad ON pk_comunidad = id_comunidad WHERE id_usuario = ? AND miembro_comunidad=? 
    `;
    mysqlConnection.query(query, [id_usuario, 's'], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});
//Selecciona las columnas con la pk_comunidad dada
router.get('/comunidad_usuario/comuser/:id_comunidad/:id_usuario', (req, res) => {
    const { id_comunidad, id_usuario } = req.params;
    const query = `
    SELECT * FROM comunidad_usuario WHERE pk_comunidad = ? AND pk_usuario = ?
    `;
    mysqlConnection.query(query, [id_comunidad, id_usuario], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

// Seleccionar usuarios de una comunidad
router.get('/comunidad_usuario/comunidad/:id_comunidad', (req, res) => {
    const { id_comunidad } = req.params;
    const query = `
    SELECT id_usuario, nombre_usuario, apellido_usuario, correo_usuario, telefono_usuario, premium_usuario, usuario_confirmado, contrasena_usuario
      FROM comunidad_usuario INNER JOIN usuario ON pk_usuario = id_usuario INNER JOIN comunidad ON pk_comunidad = id_comunidad WHERE id_comunidad = ? 
      AND miembro_comunidad = 's'
    `;
    mysqlConnection.query(query, [id_comunidad], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

// Seleccionar la ultima comunidad 
router.get('/comunidad_usuario/ultima_comunidad', (req, res) => {
    const query = `
    SELECT * FROM comunidad WHERE id_comunidad = (SELECT MAX(id_comunidad) FROM comunidad) 
    `;
    mysqlConnection.query(query, (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

// Seleccionar todos los usuarios que estén en comunidades
router.get('/comunidad_usuario', (req, res) => {
    const { id_comunidad } = req.params;
    const query = `
    SELECT * FROM comunidad_usuario INNER JOIN usuario ON pk_usuario = id_usuario INNER JOIN comunidad ON pk_comunidad = id_comunidad
    `;
    mysqlConnection.query(query, [id_comunidad], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});


router.get('/comunidad_usuario/flyers/:id_usuario/:fk_tipo_publicacion', (req, res) => {
    const { id_usuario, fk_tipo_publicacion } = req.params;
    const query = `
    SELECT id_publicacion, titulo_publicacion, flyer_publicacion, nombre_categoria, nombre_comunidad, descripcion_publicacion FROM publicacion 
    INNER JOIN comunidad ON fk_comunidad_publicacion = id_comunidad 
    INNER JOIN categoria ON fk_categoria = id_categoria 
    WHERE fk_usuario_publicacion = ? AND fk_tipo_publicacion = ?
    `;
    mysqlConnection.query(query, [id_usuario, fk_tipo_publicacion], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/comunidad_usuario/flyers/:id_usuario/:fk_tipo_publicacion/:id_publicacion', (req, res) => {
    const { id_usuario, fk_tipo_publicacion, id_publicacion } = req.params;
    const query = `
    SELECT titulo_publicacion, flyer_publicacion, nombre_categoria, nombre_comunidad, descripcion_publicacion FROM publicacion 
    INNER JOIN comunidad ON fk_comunidad_publicacion = id_comunidad 
    INNER JOIN categoria ON fk_categoria = id_categoria 
    WHERE fk_usuario_publicacion = ? AND fk_tipo_publicacion = ? AND where id_publicacion = ?
    `;
    mysqlConnection.query(query, [id_usuario, fk_tipo_publicacion, id_publicacion], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/comunidad_usuario/flyers_swipper/:fk_comunidad_publicacion/:fk_tipo_publicacion', (req, res) => {
    const { fk_tipo_publicacion, fk_comunidad_publicacion } = req.params;
    const query = `
    SELECT id_publicacion, titulo_publicacion, flyer_publicacion, nombre_categoria, nombre_comunidad, descripcion_publicacion FROM publicacion 
    INNER JOIN comunidad ON fk_comunidad_publicacion = id_comunidad 
    INNER JOIN categoria ON fk_categoria = id_categoria 
    WHERE fk_tipo_publicacion = ? AND fk_comunidad_publicacion = ? 
    `;
    mysqlConnection.query(query, [fk_tipo_publicacion, fk_comunidad_publicacion], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

//Obtiene todos los flyers de comunidades a las que pertenece
router.get('/comunidad_usuario/flyers_swipper_pertenece/:fk_tipo_publicacion/:id_usuario', (req, res) => {
    const { fk_tipo_publicacion, id_usuario, } = req.params;
    const query = `
    SELECT id_publicacion, titulo_publicacion, flyer_publicacion, nombre_categoria, nombre_comunidad, descripcion_publicacion FROM publicacion 
    INNER JOIN comunidad_usuario ON fk_comunidad_publicacion = pk_comunidad 
    INNER JOIN comunidad ON fk_comunidad_publicacion = id_comunidad 
    INNER JOIN categoria ON fk_categoria = id_categoria 
    WHERE fk_tipo_publicacion = ? and miembro_comunidad='s' and pk_usuario=?
    `;
    mysqlConnection.query(query, [fk_tipo_publicacion, id_usuario], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/comunidad_usuario/vermas/:fk_comunidad_publicacion/:fk_categoria/:fk_tipo_publicacion', (req, res) => {
    const { fk_tipo_publicacion, fk_comunidad_publicacion, fk_categoria } = req.params;
    const query = `
    SELECT id_publicacion, titulo_publicacion, flyer_publicacion, nombre_categoria, nombre_comunidad, descripcion_publicacion FROM publicacion 
    INNER JOIN comunidad ON fk_comunidad_publicacion = id_comunidad 
    INNER JOIN categoria ON fk_categoria = id_categoria 
    WHERE fk_tipo_publicacion = ? AND fk_comunidad_publicacion = ?  AND fk_categoria = ?
    `;
    mysqlConnection.query(query, [fk_tipo_publicacion, fk_comunidad_publicacion, fk_categoria], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.delete('/comunidad_usuario/eliminar_usuario/:id_usuario/:id_comunidad', (req, res) => {
    const {id_usuario, id_comunidad} = req.params;
    mysqlConnection.query('DELETE FROM comunidad_usuario WHERE pk_usuario = ? AND pk_comunidad = ?', [id_usuario, id_comunidad], (err, rows, fields) =>{
        if(!err){
            res.json({Status: 'Usuario Eliminad@'});
        }else{
            console.log(err);
        }
    });
});

// Seleccionar los flyers de un usuario por comunidad
module.exports = router;