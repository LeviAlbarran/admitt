-- -------------------------------------------
-- Creación de tablas
-- -------------------------------------------
 CREATE TABLE IF NOT EXISTS `admitt`.`Comunidad` (
  `id_comunidad` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `nombre_comunidad` VARCHAR(255) NOT NULL,
  `descripcion_comunidad` VARCHAR(255) NOT NULL);

 CREATE TABLE IF NOT EXISTS `admitt`.`Subcomunidad` (
  `id_subcomunidad` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `nombre_subcomunidad` VARCHAR(255) NOT NULL,
  `descripcion_subcomunidad` VARCHAR(255) NOT NULL,
  `fk_comunidad` INT NOT NULL);

 CREATE TABLE IF NOT EXISTS `admitt`.`Usuario` (
  `id_usuario` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `nombre_usuario` VARCHAR(255) ,
  `apellido_usuario` VARCHAR(255) ,
  `rut_usuario` VARCHAR(50) ,
  `correo_usuario` VARCHAR(255) ,
  `num_usuario` VARCHAR(255) ,
  `premium_usuario` CHAR(1) ,
  `contrasena_usuario` VARCHAR(255));

 CREATE TABLE IF NOT EXISTS `admitt`.`Subcomunidad_Usuario` (
  `pk_subcomunidad` INT NOT NULL,
  `pk_usuario` INT NOT NULL,
  `cantidad_flyer` INT,
  `cantidad_muro` INT,
  `cantidad_dato` INT,
  `miembro_subcomunidad` CHAR(1) ,
  PRIMARY KEY (`pk_subcomunidad`, `pk_usuario`));

 CREATE TABLE IF NOT EXISTS `admitt`.`Tipo_Publicacion` (
  `id_tipo_publicacion` INT NOT NULL PRIMARY KEY,
  `cantidad_publicacion_free` INT NOT NULL,
  `cantidad_publicacion_premium` INT NOT NULL);

 CREATE TABLE IF NOT EXISTS `admitt`.`Publicacion` (
  `id_publicacion` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `fk_tipo_publicacion` INT NOT NULL,
  `titulo_publicacion` VARCHAR(255) NOT NULL,
  `descripcion_publicacion` VARCHAR(255) NOT NULL,
  `flyer_publicacion` BLOB NOT NULL,
  `fk_subcomunidad_publicacion` INT NOT NULL,
  `fk_usuario_publicacion` INT NOT NULL);

 CREATE TABLE IF NOT EXISTS `admitt`.`Solicitud` (
  `id_solicitud` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `descripcion_solicitud` VARCHAR(255),
  `fk_subcomunidad_solicitud` INT NOT NULL,
  `fk_usuario_solicitud` INT NOT NULL);

  CREATE TABLE IF NOT EXISTS `admitt`.`Categoria` (
  `id_categoria` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `nombre_categoria` VARCHAR(255),
  `fk_subcomunidad_solicitud` INT NOT NULL,
  `fk_usuario_solicitud` INT NOT NULL);


-- -------------------------------------------
-- Creación de Foreign Keys 
-- -------------------------------------------

-- -------------------------------------------
-- Relación Comunidad - Subcomunidad 
-- -------------------------------------------
 ALTER TABLE `admitt`.`Subcomunidad` 
    ADD CONSTRAINT `fk_comunidad`
    FOREIGN KEY (`fk_comunidad`)
    REFERENCES `admitt`.`Comunidad` (`id_comunidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
    
-- -------------------------------------------
-- Relación Subcomunidad - Usuario 
-- -------------------------------------------
 ALTER TABLE `admitt`.`Subcomunidad_Usuario`
  ADD CONSTRAINT `fk_subcomunidad_usuario`
    FOREIGN KEY (`pk_subcomunidad`)
    REFERENCES `admitt`.`Subcomunidad` (`id_subcomunidad`)
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
-- Relación Publicación - Subcomunidad_Usuario
-- -------------------------------------------
 ALTER TABLE `admitt`.`Publicacion`
  ADD CONSTRAINT `fk_subcomunidad_publicacion`
    FOREIGN KEY (`fk_subcomunidad_publicacion`)
    REFERENCES `admitt`.`Subcomunidad_Usuario` (`pk_subcomunidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_usuario_publicacion`
    FOREIGN KEY (`fk_usuario_publicacion`)
    REFERENCES `admitt`.`Subcomunidad_Usuario` (`pk_usuario`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


-- -------------------------------------------
-- Relación Solicitud - Subcomunidad_Usuario
-- -------------------------------------------
 ALTER TABLE `admitt`.`Solicitud`
  ADD CONSTRAINT `fk_subcomunidad_solicitud`
    FOREIGN KEY (`fk_subcomunidad_solicitud`)
    REFERENCES `admitt`.`Subcomunidad_Usuario` (`pk_subcomunidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_usuario_solicitud`
    FOREIGN KEY (`fk_usuario_solicitud`)
    REFERENCES `admitt`.`Subcomunidad_Usuario` (`pk_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;