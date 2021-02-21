const express = require('express');
const app = express();
const jwt = require('jsonwebtoken');

// Configuraciones
app.set('port', process.env.PORT || 3000);

// Middlewares
app.use(express.json({ limit: '52428800b' }));
app.use(express.urlencoded({ limit: '52428800b', extended: true, parameterLimit: 50000 }));
app.use(express.json());


// Rutas
app.get('/api/estado', async function(req, res){
    return res.send({estado: true});
});
app.use(require('./routes/usuarios'));
app.use(require('./routes/publicaciones'));
app.use(require('./routes/comunidades'));
app.use(require('./routes/categorias'));
app.use(require('./routes/tipo_publicacion'));
app.use(require('./routes/comunidad_usuario'));
app.use(require('./routes/solicitudes'));
app.use(require('./routes/solicitud_usuario'));

// Starting the server
app.listen(app.get('port'), () => {
    console.log('Servidor en el puerto', app.get('port'));
});