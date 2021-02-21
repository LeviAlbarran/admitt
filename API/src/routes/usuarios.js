const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const verifyToken = require('../controllers/verifyToken');
const config = require('../config');
const nodemailer = require("nodemailer");

function secuencia(length) {
    var result = '';
    var characters = '0123456789';
    var charactersLength = characters.length;
    for (var i = 0; i < length; i++) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}

const mysqlConnection = require('../database');


router.get('/usuarios', (req, res) => {
    mysqlConnection.query('SELECT * FROM usuario', (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.get('/usuarios/id/:id_usuario', (req, res) => {
    const { id_usuario } = req.params;
    mysqlConnection.query('SELECT * FROM usuario WHERE id_usuario = ?', [id_usuario], (err, rows, fields) => {
        if (!err) {
            2
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});


// Get usuario by correo
router.get('/usuarios/correo/:correo_usuario', (req, res) => {
    const { correo_usuario } = req.params;
    mysqlConnection.query('SELECT * FROM usuario WHERE correo_usuario = ?', [correo_usuario], (err, rows, fields) => {
        if (!err) {
            2
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});


router.get('/usuarios/nombre/:nombre_usuario', (req, res) => {
    const { nombre_usuario } = req.params;
    mysqlConnection.query('SELECT * FROM usuario WHERE nombre_usuario = ?', [nombre_usuario], (err, rows, fields) => {
        if (!err) {
            res.json(rows);
        } else {
            console.log(err);
        }
    });
});

router.post('/crear_usuario', (req, res) => {
    console.log(req.body);
    const { nombre_usuario, apellido_usuario, correo_usuario, telefono_usuario, contrasena_usuario, codigo_usuario } = req.body;
    mysqlConnection.query('INSERT INTO usuario (nombre_usuario, apellido_usuario, correo_usuario, telefono_usuario, premium_usuario, contrasena_usuario, usuario_confirmado, codigo_usuario) values (?,?,?,?,?,?,?,?)', [nombre_usuario, apellido_usuario, correo_usuario, telefono_usuario, 'n', contrasena_usuario, 'n', codigo_usuario],
        (err, rows, fields) => {
            if (!err) {
                res.json({ status: 'Ok' });
            } else {
                console.log(err);
            }
        });
});

router.delete('/eliminar_usuario/:id_usuario', (req, res) => {
    const { id_usuario } = req.params;
    mysqlConnection.query('DELETE FROM usuario WHERE id_usuario = ?', [id_usuario], (err, rows, fields) => {
        if (!err) {
            res.json({ Status: 'Usuario Eliminado' });
        } else {
            console.log(err);
        }
    });
});

router.post('/login', async(req, res) => {
    const { correo_usuario, contrasena_usuario } = req.body;

    mysqlConnection.query('SELECT * FROM usuario WHERE correo_usuario = ? AND contrasena_usuario = ?', [correo_usuario, contrasena_usuario],
        (err, rows, fields) => {
            if (!err) {
                const token = jwt.sign({ correo_usuario }, config.secret, {
                    expiresIn: '24h'
                });
                res.status(200).json({ auth: true, token });
            } else {
                console.log(err);
            }
        });
});


router.get('/logout', function(req, res) {
    res.status(200).send({ auth: false, token: null });
});

router.post("/send_email/:codigo_usuario", (req, res) => {
    const { codigo_usuario } = req.params;
    const { correo_usuario } = req.body;
    const query = 'SELECT codigo_usuario FROM usuario WHERE correo_usuario = ?';
    console.log(correo_usuario)

    var transporter = nodemailer.createTransport({
        host: "smtp.gmail.com",
        port: 587,
        service: 'Gmail',
        secure: false,
        auth: {
            user: "admitt.dev@gmail.com",
            pass: "miclave2020"
        },
        tls: {
            rejectUnauthorized: false
        }
    });
    var mailOptions = {
        from: "admitt.dev@gmail.com",
        to: correo_usuario,
        subject: "Código de confirmación ADMITT",
        text: "Tu código de confirmación es: " + codigo_usuario
    }

    mysqlConnection.query(query, [correo_usuario], (err, rows, fields) => {
        if (!err) {
            transporter.sendMail(mailOptions, (error, info) => {
                if (error) {
                    console.log(error);
                    res.status(500).send(error.message);
                } else {
                    console.log("Email enviado!")
                    res.json({ Status: 'Email enviado' });
                }
            })
        } else {
            console.log(err);
        }
    });
});

router.put('/modificar_usuario/:correo_usuario', (req, res) => {
    const { correo_usuario } = req.params;
    const { usuario_confirmado } = req.body;
    const query = 'UPDATE usuario SET usuario_confirmado = ? where correo_usuario =?;';
    mysqlConnection.query(query, [usuario_confirmado, correo_usuario], (err, rows, fields) => {
        if (!err) {
            res.json(rows);

        } else {
            console.log(err);
        }
    });
});

module.exports = router;