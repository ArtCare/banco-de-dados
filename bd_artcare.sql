create database artcareTeste;
use artcareTeste;

create table usuario(
id int primary key auto_increment,
nome varchar(30)
);

create table dht11(
id int primary key auto_increment,
temperatura decimal(4, 2),
umidade decimal(4, 2),
dataHora datetime
);

create user 'aluno'@'%'identified by 'sptech100';
grant insert on artcareTeste.dht11 to aluno;
flush privileges; 

select * from dht11;