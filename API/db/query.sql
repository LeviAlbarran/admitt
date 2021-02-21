-- -------------------------------------------
-- Creación de tablas
-- -------------------------------------------
 CREATE TABLE IF NOT EXISTS `admitt`.`Comunidad` (
  `id_comunidad` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `nombre_comunidad` VARCHAR(255) NOT NULL,
  `descripcion_comunidad` VARCHAR(255) NOT NULL);

 CREATE TABLE IF NOT EXISTS `admitt`.`Usuario` (
  `id_usuario` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `nombre_usuario` VARCHAR(255) ,
  `apellido_usuario` VARCHAR(255) ,
  `correo_usuario` VARCHAR(255) ,
  `telefono_usuario` VARCHAR(255) ,
  `premium_usuario` CHAR(1) ,
  `usuario_confirmado` char(1),
  `contrasena_usuario` VARCHAR(255),
  `codigo_usuario` varchar(4));

 CREATE TABLE IF NOT EXISTS `admitt`.`comunidad_usuario` (
  `pk_comunidad` INT NOT NULL,
  `pk_usuario` INT NOT NULL,
  `cantidad_flyer` INT,
  `cantidad_muro` INT,
  `cantidad_dato` INT,
  `miembro_comunidad` CHAR(1) ,
  PRIMARY KEY (`pk_comunidad`, `pk_usuario`));

 CREATE TABLE IF NOT EXISTS `admitt`.`Tipo_Publicacion` (
  `id_tipo_publicacion` INT NOT NULL PRIMARY KEY,
  `nombre_tipo_publicacion` VARCHAR(255),
  `cantidad_publicacion_free` INT NOT NULL,
  `cantidad_publicacion_premium` INT NOT NULL);

 CREATE TABLE IF NOT EXISTS `admitt`.`Publicacion` (
  `id_publicacion` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `fk_tipo_publicacion` INT NOT NULL,
  `titulo_publicacion` VARCHAR(255) NOT NULL,
  `descripcion_publicacion` VARCHAR(255) NOT NULL,
  `flyer_publicacion` MEDIUMTEXT,
  `fk_comunidad_publicacion` INT NOT NULL,
  `fk_usuario_publicacion` INT NOT NULL,
  `flyer_link` INT,
  `fk_categoria` INT);

  CREATE TABLE IF NOT EXISTS `admitt`.`categoria` (
  `id_categoria` INT NOT NULL PRIMARY KEY,
  `nombre_categoria` VARCHAR(250) NOT NULL);

 CREATE TABLE IF NOT EXISTS `admitt`.`Solicitud` (
  `id_solicitud` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `descripcion_solicitud` VARCHAR(255),
  `fk_comunidad_solicitud` INT NOT NULL,
  `fk_usuario_solicitud` INT NOT NULL,
  `voto_maximo` INT NOT NULL,
  `negativas_acumuladas` INT NOT NULL,
  `estado_solicitud` VARCHAR(1)
  );

   CREATE TABLE IF NOT EXISTS `admitt`.`solicitud_usuario` (
  `fk_solicitud` INT NOT NULL,
  `fk_usuario` INT NOT NULL,
  `voto` VARCHAR(1),
  PRIMARY KEY (`fk_solicitud`, `fk_usuario`));



-- -------------------------------------------
-- Creación de Foreign Keys 
-- -------------------------------------------

-- -------------------------------------------
-- Relación solicitud - usuario 
-- -------------------------------------------

 ALTER TABLE `admitt`.`solicitud_usuario`
  ADD CONSTRAINT `fk_solicitud`
    FOREIGN KEY (`fk_solicitud`)
    REFERENCES `admitt`.`Solicitud` (`id_solicitud`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_usuario_solicitud_usuario`
    FOREIGN KEY (`fk_usuario`)
    REFERENCES `admitt`.`Usuario` (`id_usuario`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

-- -------------------------------------------
-- Relación comunidad - usuario 
-- -------------------------------------------
 ALTER TABLE `admitt`.`comunidad_usuario`
  ADD CONSTRAINT `fk_comunidad_usuario`
    FOREIGN KEY (`pk_comunidad`)
    REFERENCES `admitt`.`comunidad` (`id_comunidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_usuario`
    FOREIGN KEY (`pk_usuario`)
    REFERENCES `admitt`.`Usuario` (`id_usuario`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


-- -------------------------------------------
-- Relación Publicacion - Tipo Publicacion
-- -------------------------------------------
 ALTER TABLE `admitt`.`Publicacion`
  ADD CONSTRAINT `fk_tipo_publicacion`
    FOREIGN KEY (`fk_tipo_publicacion`)
    REFERENCES `admitt`.`Tipo_Publicacion` (`id_tipo_publicacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

-- -------------------------------------------
-- Relación Publicacion - Categoria
-- -------------------------------------------
 ALTER TABLE `admitt`.`Publicacion`
  ADD CONSTRAINT `fk_categoria`
    FOREIGN KEY (`fk_categoria`)
    REFERENCES `admitt`.`categoria` (`id_categoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

-- -------------------------------------------
-- Relación Publicación - comunidad_usuario
-- -------------------------------------------
 ALTER TABLE `admitt`.`Publicacion`
  ADD CONSTRAINT `fk_comunidad_publicacion`
    FOREIGN KEY (`fk_comunidad_publicacion`)
    REFERENCES `admitt`.`comunidad_Usuario` (`pk_comunidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_usuario_publicacion`
    FOREIGN KEY (`fk_usuario_publicacion`)
    REFERENCES `admitt`.`comunidad_Usuario` (`pk_usuario`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

-- -------------------------------------------
-- Relación Solicitud - comunidad_usuario
-- -------------------------------------------
 ALTER TABLE `admitt`.`Solicitud`
  ADD CONSTRAINT `fk_comunidad_solicitud`
    FOREIGN KEY (`fk_comunidad_solicitud`)
    REFERENCES `admitt`.`comunidad_Usuario` (`pk_comunidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_usuario_solicitud`
    FOREIGN KEY (`fk_usuario_solicitud`)
    REFERENCES `admitt`.`comunidad_Usuario` (`pk_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

-- -------------------------------------------
-- Inserción de Datos
-- -------------------------------------------

-- -------------------------------------------
-- Inserción en tabla Categoría
-- -------------------------------------------
  INSERT INTO `admitt`.`Categoria` values
  (1, 'Accesorios para Vehículos'),
  (2, 'Agro'),
  (3, 'Alimentos y Bebidas'),
  (4, 'Animales y Mascotas'),
  (5, 'Antigüedades y Colecciones'),
  (6, 'Arte, Librería y Cordonería'),
  (7, 'Autos, Motos y Otros'),
  (8, 'Artículos para Bebés'),
  (9, 'Belleza y Cuidado Personal'),
  (10, 'Celulares y Telefonía'),
  (11, 'Computación'),
  (12, 'Consolas y Videojuegos'),
  (13, 'Cámaras y Accesorios'),
  (14, 'Deportes y Fitness'),
  (15, 'Electrodomésticos'),
  (16, 'Electrónica, Audio y Video'),
  (17, 'Entradas para eventos'),
  (18, 'Herramientas y Construcción'),
  (19, 'Hogar y Muebles'),
  (20, 'Industrias y Oficinas'),
  (21, 'Inmuebles'),
  (22, 'Instrumentos Musicales'),
  (23, 'Juegos y Juguetes'),
  (24, 'Libros, Revistas y Comics'),
  (25, 'Música y Películas'),
  (26, 'Relojería y Joyería'),
  (27, 'Salud y Equipamiento Médico'),
  (28, 'Servicios'),
  (29, 'Souvenirs, Cotillón y Fiestas'),
  (30, 'Vestuario y Calzado'),
  (31, 'Otros');

-- -------------------------------------------
-- Inserción en tabla Tipo_Publicacion
-- -------------------------------------------
INSERT INTO `admitt`.`Tipo_Publicacion` values
 -- Flyer
(1, 'Flyer', 2, 6),
-- Publicacion Muro
(2, 'Muro',1, 100),
-- Sección de Datos
(3, 'Datos', 100, 100);

-- -------------------------------------------
-- Inserción en tabla Usuarios
-- -------------------------------------------
INSERT INTO `admitt`.`usuario` (`nombre_usuario`, `apellido_usuario`, `correo_usuario`, `telefono_usuario`, `premium_usuario`, `usuario_confirmado`, `contrasena_usuario`) values
 -- Usuario Sebastián
('Sebastian', 'Santiago', 'sebastian@gmail.com', '+569', 'n', 's', '123456'),
-- Usuario Diego
('Diego', 'Opazo', 'diego@gmail.com', '+569', 'n', 's', '123456'),
-- Usuario Fabián
('Fabian', 'Riquelme', 'fabian@gmail.com', '+569', 'n', 's', '123456');
