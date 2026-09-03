drop database if exists SpaceSurvivors;
create database SpaceSurvivors;
use SpaceSurvivors;

create table Jugadores(
    id_jugador int primary key auto_increment,
    nombre varchar(50) not null,
    email varchar(100) not null,
    fecha_registro date
);

create table Sesiones(
    id_sesion int primary key auto_increment,
    id_jugador int not null,
    fecha_inicio date,
    fecha_fin date,
    dificultad varchar(20),
    puntaje_final int,
    foreign key (id_jugador) references Jugadores(id_jugador)
);

create table TiposEventos(
    id_tipo_evento int primary key auto_increment,
    nombre varchar(50),
    descripcion varchar(200)
);

create table RegistrosCombates(
    id_registro int primary key auto_increment,
    id_sesion int not null,
    id_tipo_evento int not null,
    frame int,
    dano float,
    puntos int,
    foreign key (id_sesion) references Sesiones(id_sesion),
    foreign key (id_tipo_evento) references TiposEventos(id_tipo_evento)
);

create table TiposEnemigos(
    id_tipo_enemigo int primary key auto_increment,
    nombre varchar(50),
    vida_base float,
    dano float,
    velocidad float
);

create table EnemigosInstancias(
    id_enemigo_instancia int primary key auto_increment,
    id_sesion int not null,
    id_tipo_enemigo int not null,
    coor_x float,
    coor_y float,
    vida_actual float,
    foreign key (id_sesion) references Sesiones(id_sesion),
    foreign key (id_tipo_enemigo) references TiposEnemigos(id_tipo_enemigo)
);

create table TiposPowerUps(
    id_tipo_powerup int primary key auto_increment,
    nombre varchar(50),
    efecto varchar(100),
    duracion float
);

create table PowerUpsInstancias(
    id_powerup_instancia int primary key auto_increment,
    id_sesion int not null,
    id_tipo_powerup int not null,
    coor_x float,
    coor_y float,
    recolectado bool,
    foreign key (id_sesion) references Sesiones(id_sesion),
    foreign key (id_tipo_powerup) references TiposPowerUps(id_tipo_powerup)
);

create table Armas(
    id_arma int primary key auto_increment,
    nombre varchar(50),
    dano float,
    cadencia float,
    municion_max int
);

create table InventarioMunicion(
    id_sesion int not null,
    id_arma int not null,
    cantidad_actual int,
    foreign key (id_sesion) references Sesiones(id_sesion),
    foreign key (id_arma) references Armas(id_arma)
);

insert into TiposEventos (nombre, descripcion) values 
('Nave Enemiga Destruida', 'El jugador elimino un asteroide'),
('PowerUp Recogido', 'La nave obtuvo una mejora'),
('Impacto Recibido', 'El escudo sufrio daño');

insert into TiposEnemigos (nombre, vida_base, dano, velocidad) values 
('Mini Alien', 30, 15, 5),
('Nodriza Boss', 800, 50, 1);

insert into TiposPowerUps (nombre, efecto, duracion) values 
('Escudo', 'Absorbe disparos entrantes', 8),
('Propulsor Lokisimo', 'Aumenta la velocidad', 6);

insert into Armas (nombre, dano, cadencia, municion_max) values 
('Cañon Doble', 20, 5, 100),
('Lanzamisiles', 150, 0.5, 8);

insert into Jugadores (nombre, email, fecha_registro) values 
('StarLord', 'pilot@galaxy.com', CURDATE());

insert into Sesiones (id_jugador, fecha_inicio, fecha_fin, dificultad, puntaje_final) values 
(1, CURDATE(), CURDATE(), 'Normal', 3450);

insert into InventarioMunicion (id_sesion, id_arma, cantidad_actual) values 
(1, 1, 85),
(1, 2, 3);

insert into EnemigosInstancias (id_sesion, id_tipo_enemigo, coor_x, coor_y, vida_actual) values 
(1, 1, 450.12, 120.12, 0),
(1, 2, 800.12, 300.12, 650);

insert into PowerUpsInstancias (id_sesion, id_tipo_powerup, coor_x, coor_y, recolectado) values 
(1, 1, 300, 200, true),
(1, 2, 600, 400, false);

insert into RegistrosCombates (id_sesion, id_tipo_evento, frame, dano, puntos) values 
(1, 1, 180, 50, 500),
(1, 3, 320, 15, 0),
(1, 2, 450, 0, 150);