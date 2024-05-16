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

create table museu (
	idMuseu int primary key auto_increment,
    fkEndereco int,
    nome varchar(45) not null,
    cnpj char(14) not null unique,
    rm char(9) not null unique,
    constraint fkEnderecoCliente foreign key (fkEndereco) references endereco (idEndereco)
);

create table representante (
idRepresentante int,
fkMuseu int,
	constraint pkRepresentanteMuseu primary key (idRepresentante, fkMuseu),
    constraint fkMuseuRepresentante foreign key (fkMuseu)
		references museu(idMuseu),
nome varchar(45) not null,
email varchar(256) not null,
senha varchar(45) not null
);

create table sensor (
	idSensor int primary key auto_increment,
    nome char(5) default 'dht11',
    tipo varchar(45) default 'temperatura, umidade',
    constraint chkNomeSensor check (nome in ('dht11'))
);

create table supervisor (
	idSupervisor int primary key auto_increment,
    nome varchar(45) not null,
    email varchar(256) not null,
    senha varchar(45) not null,
    permissao char(3) not null default 'não',
    constraint chkPermissaoSupervisor check (permissao in ('sim', 'não'))
);

create table setor (
	idSetor int auto_increment,
    fkSensor int,
    fkMuseu int,
    fkVerificacao int,
    nome varchar(45) not null,
    andar int not null,
    constraint pkCompostaSetor primary key (idSetor, fkSensor, fkMuseu, fkVerificacao),
    constraint fkSensorDoSetor foreign key (fkSensor) references sensor (idSensor),
    constraint fkMuseuDoSetor foreign key (fkMuseu) references museu (idMuseu),
    constraint fkVerificacaoDoSetor foreign key (fkVerificacao) references verificacao (idVerificacao)
);

create table visualizacao (
idVisualizacao int auto_increment,
fkSetor int,
fkSensor int,
fkMuseu int,
fkSupervisor int,
	constraint pkCompostaVisualizacao primary key (idVisualizacao, fkSetor, fkSensor, fkMuseu, fkSupervisor),
    constraint fkSetorVisualizacao foreign key (fkSetor) references setor(idSetor),
    constraint fkSensorVisualizacao foreign key (fkSensor) references sensor(idSensor),
    constraint fkMuseuVisualizacao foreign key (fkMuseu) references museu(idMuseu),
    constraint fkSupervisor foreign key (fkSupervisor) references supervisor(idSupervisor)
);

create table registro (
	idRegistro int auto_increment,
    fkSensor int,
    umidade decimal(4,2),
    temperatura decimal(4,2),
    dtRegistro timestamp not null default current_timestamp,
    constraint pkCompostaRegistro primary key (idRegistro, fkSensor),
    constraint fkSensorRegistro foreign key (fkSensor) references sensor (idSensor)
);


-- Necessário alterar INSERTS e SELECTS
insert into verificacao (tempMax, tempMin, umiMax, umiMin) values
(20.00, 18.00, 45.00, 40.00);

insert into endereco (cep, numEnd, complemento) values
('08140-060', '979', 'próximo à avenida paulista');

insert into cliente (fkEndereco, nome, cnpj, rm, email, senha) values
(1, 'masp', '12345678909876', 'M4$P', 'maspmuseu@outlook.com.br', 'senhamaspmuseu');

insert into sensor (fkVerificacao, nome, tipo) values
(1, 'dht11', 'temperatura, umidade');

insert into supervisor (fkCliente, nome, permissao) values
(1, 'bruno', 'sim');

insert into setor (fkSensorSetor, fkSupervisorSetor, nome, andar) values
(1, 1, 'galeria de arte', 12);

insert into registro (fkSensor, umidade, temperatura) values
(1, 20.00, 42.00);

select * from cliente;
select * from endereco;
select * from supervisor;
select * from setor;
select * from sensor;
select * from registro;
select * from verificacao;

select * from cliente join endereco on idEndereco = fkEndereco
join supervisor on idCliente = fkCliente
join setor on idSupervisor = fkSupervisorSetor
join sensor on idSensor = fkSensorSetor
join registro on idSensor = fkSensor
join verificacao on idVerificacao = fkVerificacao;

select cliente.nome as 'Nome do Museu', supervisor.nome as 'Nome do supervisor',
supervisor.permissao as 'Supervisor tem acesso aos dados?' 
from cliente JOIN supervisor ON cliente.idCliente = supervisor.fkCliente;

select cliente.nome as 'Nome do Museu', cep as 'CEP do Museu', supervisor.nome as 'Nome do supervisor',
supervisor.permissao as 'Supervisor tem acesso aos dados?', setor.nome as 'Nome do setor do museu',
setor.andar as 'Andar do setor', sensor.nome as 'Nome do sensor utilizado',
registro.temperatura as 'Temperatura registrada',
registro.umidade as 'Umidade registrada',
registro.dtRegistro as 'Data e hora do registro feito pelo sensor',
verificacao.tempMax as 'Temperatura máxima permitida',
verificacao.umiMax as 'Umidade máxima permitida' from cliente
join endereco on idEndereco = fkEndereco
join supervisor on idCliente = fkCliente
join setor on idSupervisor = fkSupervisorSetor
join sensor on idSensor = fkSensorSetor
join registro on idSensor = fkSensor
join verificacao on idVerificacao = fkVerificacao;

select r.idRegistro as 'ID do registro', r.fkSensor as 'ID do sensor',
r.temperatura as 'Temperatura registrada', r.umidade as 'Umidade registrada',
r.dtRegistro as 'Data do registro', s.idSensor as 'ID do sensor',
v.idVerificacao as 'ID da verificação', v.tempMax as 'Temperatura máxima permitida',
v.umiMax as 'Umidade máxima permitida' from registro as r join sensor as s on s.idSensor = r.fkSensor
join verificacao as v on v.idVerificacao = s.fkVerificacao;

select idRegistro as 'ID do registro', fkSensor as 'ID do sensor',
umidade as 'Umidade registrada', temperatura as 'Temperatura registrada',
dtRegistro as 'Data do registro' from registro;

alter table verificacao
add column alertaTempMax decimal(4,2);

alter table verificacao
add column alertaTempMin decimal(4,2);

alter table verificacao
add column alertaUmiMax decimal(4,2);

alter table verificacao
add column alertaUmiMin decimal(4,2);