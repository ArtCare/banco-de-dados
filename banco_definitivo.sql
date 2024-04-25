create database ArtCare;
use ArtCare;

create table verificacao (
	idVerificacao int primary key auto_increment,
    tempMax decimal(4,2) not null,
    tempMin decimal(4,2) not null,
    umiMax decimal(4,2) not null,
    umiMin decimal(4,2) not null
);

create table endereco (
	idEndereco int primary key auto_increment,
    cep char(9) not null,
    numEnd varchar(45) not null,
    complemento varchar(60)
);

create table cliente (
	idCliente int auto_increment,
    fkEndereco int,
    nome varchar(45) not null,
    cnpj char(14) not null unique,
    rm varchar(45) not null unique,
    email varchar(264) not null unique,
    senha varchar(45) not null,
    constraint pkCompostaCliente primary key (idCliente, fkEndereco),
    constraint fkEnderecoCliente foreign key (fkEndereco) references endereco (idEndereco)
);

create table sensor (
	idSensor int auto_increment,
    fkVerificacao int,
    nome char(5) default 'dht11',
    tipo varchar(45) default 'temperatura, umidade',
    constraint chkNomeSensor check (nome in ('dht11')),
    constraint pkCompostaSensor primary key (idSensor, fkVerificacao),
    constraint fkVerificacaoSensor foreign key (fkVerificacao) references verificacao (idVerificacao)
);

create table supervisor (
	idSupervisor int auto_increment,
    fkCliente int,
    nome varchar(45) not null,
    permissao char(3) not null default 'não',
    constraint chkPermissaoSupervisor check (permissao in ('sim', 'não')),
    constraint pkCompostaSupervisor primary key (idSupervisor, fkCliente),
    constraint fkClienteSupervisor foreign key (fkCliente) references cliente (idCliente)
);