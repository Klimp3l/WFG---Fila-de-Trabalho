CREATE SEQUENCE seq_idwfgtarefa;;

CREATE TABLE WfgTarefa (
                idWfgTarefa INTEGER NOT NULL DEFAULT nextval('seq_idwfgtarefa'),
                apelidoTarefaPai VARCHAR(256) NOT NULL,
                apelidoTarefa VARCHAR(256) NOT NULL,
                ordemExecucao INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER,
                jsonbParametros VARCHAR(64000) NOT NULL,
                CONSTRAINT wfgtarefa_pk PRIMARY KEY (idWfgTarefa)
);;

COMMENT ON TABLE WfgTarefa IS 'Nós do fluxo WFG vinculados à tarefa de execução (apelidoTarefaPai).';;

COMMENT ON COLUMN WfgTarefa.apelidoTarefaPai IS 'Apelido da tarefa CLIENTE-wfg-{codigo}-execucao no datasource2.';;

COMMENT ON COLUMN WfgTarefa.jsonbParametros IS 'JSON: drawflowNodeId, nome, filtros [{key, query, value}], etc.';;

ALTER SEQUENCE seq_idwfgtarefa OWNED BY WfgTarefa.idWfgTarefa;;

CREATE INDEX ix_wfgtarefa_pai_ordem ON WfgTarefa (apelidoTarefaPai, ordemExecucao);;

CREATE SEQUENCE seq_idgrupoprecoproduto;;

CREATE TABLE GrupoPrecoProduto (
                idGrupoPrecoProduto INTEGER NOT NULL DEFAULT nextval('seq_idgrupoprecoproduto'),
                descricao VARCHAR(256) NOT NULL,
                dataInclusao DATE DEFAULT current_date NOT NULL,
                CONSTRAINT grupopreco_pk PRIMARY KEY (idGrupoPrecoProduto)
);;

ALTER SEQUENCE seq_idgrupoprecoproduto OWNED BY GrupoPrecoProduto.idGrupoPrecoProduto;;

CREATE SEQUENCE seq_idnivelsenioridadecolaborador;;

CREATE TABLE NivelSenioridadeColaborador (
                idNivelSenioridadeColaborador INTEGER NOT NULL DEFAULT nextval('seq_idnivelsenioridadecolaborador'),
                descricao VARCHAR(128) NOT NULL,
                situacao CHAR(1),
                idUsuarioCadastro INTEGER,
                dataCadastro DATE,
                CONSTRAINT nivelsenioridadecolaborador_pk PRIMARY KEY (idNivelSenioridadeColaborador)
);;

ALTER SEQUENCE seq_idnivelsenioridadecolaborador OWNED BY NivelSenioridadeColaborador.idNivelSenioridadeColaborador;;

CREATE SEQUENCE seq_idwfinput;;

CREATE TABLE WFInput (
                idWFInput INTEGER NOT NULL DEFAULT nextval('seq_idwfinput'),
                label VARCHAR(255) NOT NULL,
                tipo VARCHAR(50) NOT NULL,
                limite INTEGER,
                input VARCHAR(50) NOT NULL,
                situacao CHAR(1) NOT NULL,
                valorDefault VARCHAR(255),
                CONSTRAINT wfinput_pk PRIMARY KEY (idWFInput)
);;

ALTER SEQUENCE seq_idwfinput OWNED BY WFInput.idWFInput;;

CREATE SEQUENCE seq_idwfcoluna;;

CREATE TABLE WFColuna (
                idWFColuna INTEGER NOT NULL DEFAULT nextval('seq_idwfcoluna'),
                label VARCHAR(255) NOT NULL,
                tipo VARCHAR(50) NOT NULL,
                aliascoluna VARCHAR(64) NOT NULL,
                aliastabela VARCHAR(64) NOT NULL,
                limite INTEGER,
                coluna VARCHAR(50) NOT NULL,
                tabela VARCHAR(50) NOT NULL,
                condicao VARCHAR(255),
                situacao CHAR(1) NOT NULL,
                CONSTRAINT wfcoluna_pk PRIMARY KEY (idWFColuna)
);;

ALTER SEQUENCE seq_idwfcoluna OWNED BY WFColuna.idWFColuna;;

CREATE SEQUENCE seq_idjornadatrabalho;;

CREATE TABLE JornadaTrabalho (
                idJornadaTrabalho INTEGER NOT NULL DEFAULT nextval('seq_idjornadatrabalho'),
                descricao VARCHAR(255) NOT NULL,
                dataInclusao DATE NOT NULL,
                intervaloflexivel CHAR(1),
                tipojornada CHAR(1) DEFAULT 'C',
                idUsuarioInclusao INTEGER,
                horaInclusao VARCHAR(8) NOT NULL,
                CONSTRAINT jornadatrabalho_pk PRIMARY KEY (idJornadaTrabalho)
);;

COMMENT ON TABLE JornadaTrabalho IS 'Jornada de trabalho de Colaboradores.  Ex:  Entrada as 8:30 sai as 12:00 hs. ';;

COMMENT ON COLUMN JornadaTrabalho.tipojornada IS 'E - Empresa C - Colaborador F - Descarga Fornecedor';;

ALTER SEQUENCE seq_idjornadatrabalho OWNED BY JornadaTrabalho.idJornadaTrabalho;;

CREATE TABLE JornadaTrabalhoPeriodo (
                idJornadaTrabalho INTEGER NOT NULL,
                diaSemana VARCHAR(64) NOT NULL,
                periodo INTEGER NOT NULL,
                HoraInicial VARCHAR(8) NOT NULL,
                numerocarga INTEGER,
                horaFinal VARCHAR(8) NOT NULL,
                horaInicialMilis BIGINT NOT NULL,
                horaFinalMilis BIGINT NOT NULL,
                CONSTRAINT jornadatrabalhoperiodo_pk PRIMARY KEY (idJornadaTrabalho, diaSemana, periodo)
);;

COMMENT ON TABLE JornadaTrabalhoPeriodo IS 'O periodo ou Semana não informado, será considerado como descanso. ';;

COMMENT ON COLUMN JornadaTrabalhoPeriodo.diaSemana IS 'domingo, segunda, terca, quarta, quinta, sexta, sabado';;

COMMENT ON COLUMN JornadaTrabalhoPeriodo.periodo IS '1-Manha, 2-Tarde ou 3-Noite.';;

CREATE SEQUENCE seq_idpulafila;;

CREATE TABLE PulaFila (
                idPulaFila INTEGER NOT NULL DEFAULT nextval('seq_idpulafila'),
                idColeta INTEGER NOT NULL,
                idEmpresa INTEGER NOT NULL,
                tipo VARCHAR(10) NOT NULL,
                dataColeta DATE NOT NULL,
                horaColeta VARCHAR(8) NOT NULL,
                horaColetaMilis BIGINT NOT NULL,
                horaFinalColeta VARCHAR(8),
                horaFinalColetaMilis BIGINT,
                usuario VARCHAR(128) NOT NULL,
                exportado CHAR(1),
                CONSTRAINT pulafila_pk PRIMARY KEY (idPulaFila)
);;

COMMENT ON COLUMN PulaFila.tipo IS 'FC-Frente de Caixa';;

COMMENT ON COLUMN PulaFila.exportado IS 'S-Sim, N-Não';;

ALTER SEQUENCE seq_idpulafila OWNED BY PulaFila.idPulaFila;;

CREATE TABLE PulaFilaItens (
                idPulaFila INTEGER NOT NULL,
                idProduto INTEGER NOT NULL,
                sequenciaProduto INTEGER NOT NULL,
                quantidade NUMERIC(15,3) NOT NULL,
                CONSTRAINT pulafilaitens_pk PRIMARY KEY (idPulaFila, idProduto, sequenciaProduto)
);;

CREATE TABLE GrupoUsuarios (
                idGrupoUsuarios INTEGER NOT NULL,
                descricao VARCHAR(128),
                CONSTRAINT grupousuarios_pk PRIMARY KEY (idGrupoUsuarios)
);;

CREATE SEQUENCE seq_idprodutotipo;;

CREATE TABLE ProdutoTipo (
                idProdutoTipo INTEGER NOT NULL DEFAULT nextval('seq_idprodutotipo'),
                descricao VARCHAR(155) NOT NULL,
                CONSTRAINT produtotipo_pk PRIMARY KEY (idProdutoTipo)
);;

COMMENT ON TABLE ProdutoTipo IS 'Armazena dados de tipos de produtos, podendo ser uma caracteristica especifica do produto como em supermercados: Retalho';;

ALTER SEQUENCE seq_idprodutotipo OWNED BY ProdutoTipo.idProdutoTipo;;

CREATE SEQUENCE seq_idwfprioridade;;

CREATE TABLE WFPrioridade (
                idWFPrioridade INTEGER NOT NULL DEFAULT nextval('seq_idwfprioridade'),
                descricao VARCHAR(255),
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                prioridade INTEGER,
                cor CHAR(6),
                CONSTRAINT wfprioridade_pk PRIMARY KEY (idWFPrioridade)
);;

COMMENT ON COLUMN WFPrioridade.situacao IS 'A-Ativo, I-Inativo';;

COMMENT ON COLUMN WFPrioridade.prioridade IS 'Valor numérico indicando qual prioridade é maior';;

COMMENT ON COLUMN WFPrioridade.cor IS 'valor em hexadecimal';;

ALTER SEQUENCE seq_idwfprioridade OWNED BY WFPrioridade.idWFPrioridade;;

CREATE SEQUENCE seq_idwfimpacto;;

CREATE TABLE WFImpacto (
                idWFImpacto INTEGER NOT NULL DEFAULT nextval('seq_idwfimpacto'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                horaAlteracao VARCHAR(8) NOT NULL,
                dataAlteracao DATE NOT NULL,
                idUsuarioAlteracao INTEGER,
                CONSTRAINT wfimpacto_pk PRIMARY KEY (idWFImpacto)
);;

COMMENT ON COLUMN WFImpacto.situacao IS 'A-Ativo, I-Inativo';;

ALTER SEQUENCE seq_idwfimpacto OWNED BY WFImpacto.idWFImpacto;;

CREATE SEQUENCE seq_idwfwfcausa;;

CREATE TABLE WFCausa (
                idWFCausa INTEGER NOT NULL DEFAULT nextval('seq_idwfwfcausa'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                horaAlteracao VARCHAR(8) NOT NULL,
                dataAlteracao DATE NOT NULL,
                idUsuarioAlteracao INTEGER,
                CONSTRAINT wfcausa_pk PRIMARY KEY (idWFCausa)
);;

COMMENT ON COLUMN WFCausa.situacao IS 'A-Ativo, I-Inativo';;

ALTER SEQUENCE seq_idwfwfcausa OWNED BY WFCausa.idWFCausa;;

CREATE SEQUENCE seq_ramoatividade_idramoatividade;;

CREATE TABLE RamoAtividade (
                idRamoAtividade INTEGER NOT NULL DEFAULT nextval('seq_ramoatividade_idramoatividade'),
                descricao VARCHAR(255) NOT NULL,
                CONSTRAINT ramoatividade_pk PRIMARY KEY (idRamoAtividade)
);;

COMMENT ON TABLE RamoAtividade IS 'Identificação do Ramo de atividade.';;

ALTER SEQUENCE seq_ramoatividade_idramoatividade OWNED BY RamoAtividade.idRamoAtividade;;

CREATE SEQUENCE seq_idareaempresa;;

CREATE TABLE AreaEmpresa (
                idAreaEmpresa INTEGER NOT NULL DEFAULT nextval('seq_idareaempresa'),
                descricao VARCHAR(255) NOT NULL,
                CONSTRAINT areaempresa_pk PRIMARY KEY (idAreaEmpresa)
);;

COMMENT ON TABLE AreaEmpresa IS 'Identifica Areas semelhante a departamentos da empresa.  Ex: Departamento Financeiro, Logistico, etc...';;

ALTER SEQUENCE seq_idareaempresa OWNED BY AreaEmpresa.idAreaEmpresa;;

CREATE SEQUENCE seq_idempresaregional;;

CREATE TABLE EmpresaRegional (
                idEmpresaRegional INTEGER NOT NULL DEFAULT nextval('seq_idempresaregional'),
                descricao VARCHAR(255) NOT NULL,
                CONSTRAINT empresaregional_pk PRIMARY KEY (idEmpresaRegional)
);;

ALTER SEQUENCE seq_idempresaregional OWNED BY EmpresaRegional.idEmpresaRegional;;

CREATE SEQUENCE produtofinalidade_idprodutofinalidade_seq;;

CREATE TABLE ProdutoFinalidade (
                idProdutoFinalidade INTEGER NOT NULL DEFAULT nextval('produtofinalidade_idprodutofinalidade_seq'),
                descricao VARCHAR(255) NOT NULL,
                sigla VARCHAR(155) DEFAULT 'R',
                CONSTRAINT produtofinalidade_pk PRIMARY KEY (idProdutoFinalidade)
);;

COMMENT ON TABLE ProdutoFinalidade IS 'Identifica qual finalidade tem o produto, se para revenda, industrialização, imobilizado ';;

ALTER SEQUENCE produtofinalidade_idprodutofinalidade_seq OWNED BY ProdutoFinalidade.idProdutoFinalidade;;

CREATE TABLE Pais (
                idPais INTEGER NOT NULL,
                nomePais VARCHAR(50) NOT NULL,
                continente INTEGER,
                ddi INTEGER,
                CONSTRAINT pais_pk PRIMARY KEY (idPais)
);;

CREATE TABLE Uf (
                idUf INTEGER NOT NULL,
                idPais INTEGER,
                siglaUf CHAR(2) NOT NULL,
                nomeUf VARCHAR(50) NOT NULL,
                regiao INTEGER,
                codibge INTEGER,
                CONSTRAINT uf_pk PRIMARY KEY (idUf)
);;

CREATE TABLE Municipio (
                idMunicipio INTEGER NOT NULL,
                nomeMunicipio VARCHAR(50) NOT NULL,
                idUf INTEGER,
                siglaUf CHAR(2),
                cep VARCHAR(8),
                ddd INTEGER,
                codibge INTEGER,
                latitude NUMERIC(12,6),
                longitude NUMERIC(12,6),
                CONSTRAINT municipio_pk PRIMARY KEY (idMunicipio)
);;

CREATE SEQUENCE seq_idmarca;;

CREATE TABLE Marca (
                idmarca INTEGER NOT NULL DEFAULT nextval('seq_idmarca'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A',
                CONSTRAINT marca_pk PRIMARY KEY (idmarca)
);;

COMMENT ON COLUMN Marca.situacao IS 'A-Ativo, I-Inativo';;

ALTER SEQUENCE seq_idmarca OWNED BY Marca.idmarca;;

CREATE TABLE GrupoEconomico (
                idgrupoeconomico INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                CONSTRAINT grupoeconomico_pk PRIMARY KEY (idgrupoeconomico)
);;

CREATE SEQUENCE seq_idsubfamilia;;

CREATE TABLE SubFamilia (
                idsubfamilia INTEGER NOT NULL DEFAULT nextval('seq_idsubfamilia'),
                descricao VARCHAR(255) NOT NULL,
                tipoPai VARCHAR(1),
                idPai INTEGER,
                situacao CHAR(1) DEFAULT 'A',
                CONSTRAINT subfamilia_pk PRIMARY KEY (idsubfamilia)
);;

COMMENT ON COLUMN SubFamilia.tipoPai IS 'Tipo do Mercadológico PAI se existir. D-DEPARTAMENTO, S-SETOR, G-GRUPO, F-FAMILIA, U-SUBFAMILIA';;

COMMENT ON COLUMN SubFamilia.idPai IS 'Código do Mercadológico PAI se existir. idDepartamento, idSetor, idGrupo, idFamilia idSubFamilia';;

COMMENT ON COLUMN SubFamilia.situacao IS 'A-Ativo , I-Inativo';;

ALTER SEQUENCE seq_idsubfamilia OWNED BY SubFamilia.idsubfamilia;;

CREATE SEQUENCE seq_idfamilia;;

CREATE TABLE Familia (
                idfamilia INTEGER NOT NULL DEFAULT nextval('seq_idfamilia'),
                descricao VARCHAR(255) NOT NULL,
                tipoPai VARCHAR(1),
                idPai INTEGER,
                situacao CHAR(1) DEFAULT 'A',
                CONSTRAINT familia_pk PRIMARY KEY (idfamilia)
);;

COMMENT ON COLUMN Familia.tipoPai IS 'Tipo do Mercadológico PAI se existir. D-DEPARTAMENTO, S-SETOR, G-GRUPO, F-FAMILIA, U-SUBFAMILIA';;

COMMENT ON COLUMN Familia.idPai IS 'Código do Mercadológico PAI se existir. idDepartamento, idSetor, idGrupo, idFamilia idSubFamilia';;

COMMENT ON COLUMN Familia.situacao IS 'A-Ativo , I-Inativo';;

ALTER SEQUENCE seq_idfamilia OWNED BY Familia.idfamilia;;

CREATE SEQUENCE seq_idgrupo;;

CREATE TABLE Grupo (
                idgrupo INTEGER NOT NULL DEFAULT nextval('seq_idgrupo'),
                descricao VARCHAR(255) NOT NULL,
                tipoPai VARCHAR(1),
                idPai INTEGER,
                situacao CHAR(1) DEFAULT 'A',
                CONSTRAINT grupo_pk PRIMARY KEY (idgrupo)
);;

COMMENT ON COLUMN Grupo.tipoPai IS 'Tipo do Mercadológico PAI se existir. D-DEPARTAMENTO, S-SETOR, G-GRUPO, F-FAMILIA, U-SUBFAMILIA';;

COMMENT ON COLUMN Grupo.idPai IS 'Código do Mercadológico PAI se existir. idDepartamento, idSetor, idGrupo, idFamilia idSubFamilia';;

COMMENT ON COLUMN Grupo.situacao IS 'A-Ativo , I-Inativo';;

ALTER SEQUENCE seq_idgrupo OWNED BY Grupo.idgrupo;;

CREATE SEQUENCE seq_idsetor;;

CREATE TABLE Setor (
                idsetor INTEGER NOT NULL DEFAULT nextval('seq_idsetor'),
                descricao VARCHAR(255) NOT NULL,
                tipoPai VARCHAR(1),
                idPai INTEGER,
                situacao CHAR(1) DEFAULT 'A',
                CONSTRAINT setor_pk PRIMARY KEY (idsetor)
);;

COMMENT ON COLUMN Setor.tipoPai IS 'Tipo do Mercadológico PAI se existir. D-DEPARTAMENTO, S-SETOR, G-GRUPO, F-FAMILIA, U-SUBFAMILIA';;

COMMENT ON COLUMN Setor.idPai IS 'Código do Mercadológico PAI se existir. idDepartamento, idSetor, idGrupo, idFamilia idSubFamilia';;

COMMENT ON COLUMN Setor.situacao IS 'A-Ativo , I-Inativo';;

ALTER SEQUENCE seq_idsetor OWNED BY Setor.idsetor;;

CREATE SEQUENCE seq_iddepartamento;;

CREATE TABLE Departamento (
                iddepartamento INTEGER NOT NULL DEFAULT nextval('seq_iddepartamento'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A',
                CONSTRAINT departamento_pk PRIMARY KEY (iddepartamento)
);;

COMMENT ON COLUMN Departamento.situacao IS 'A-Ativo , I-Inativo';;

ALTER SEQUENCE seq_iddepartamento OWNED BY Departamento.iddepartamento;;

CREATE SEQUENCE seq_idempresa;;

CREATE TABLE Empresa (
                idempresa INTEGER NOT NULL DEFAULT nextval('seq_idempresa'),
                nome VARCHAR(255) NOT NULL,
                nomefantasia VARCHAR(255) NOT NULL,
                Apelido VARCHAR(30),
                cnpjcpf VARCHAR(14) NOT NULL,
                municipio VARCHAR(255) NOT NULL,
                uf CHAR(2) NOT NULL,
                endereco VARCHAR(50) NOT NULL,
                numero INTEGER NOT NULL,
                complemento VARCHAR(20),
                bairro VARCHAR(50) NOT NULL,
                cep VARCHAR(8) NOT NULL,
                telefone VARCHAR(20) NOT NULL,
                distrito VARCHAR(40),
                idempresagrupo INTEGER,
                bandeira VARCHAR(50),
                formatoloja VARCHAR(50),
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                controlaVendas CHAR(1) DEFAULT 'S' NOT NULL,
                controlaCompras CHAR(1) DEFAULT 'S' NOT NULL,
                controlaEstoque CHAR(1) DEFAULT 'S' NOT NULL,
                controlaPrecos CHAR(1) DEFAULT 'S' NOT NULL,
                vendasDomingo CHAR(1) DEFAULT 'S' NOT NULL,
                vendasSabado CHAR(1) DEFAULT 'S' NOT NULL,
                idEmpresaRegional INTEGER,
                latitude NUMERIC(12,6),
                longitude NUMERIC(12,6),
                dataSource VARCHAR(255),
                idEmpresaCadastroProduto INTEGER,
                idMunicipio INTEGER,
                idErp VARCHAR(128),
                chavePix VARCHAR(255),
                caminhoCertificadoDigital VARCHAR(255),
                senhaCertificadoDigital VARCHAR(255),
                tipoIntegracao CHAR(3) DEFAULT 'ETL' NOT NULL,
                apiSecretIntegracao VARCHAR(255),
                apiKeyIntegracao VARCHAR(255),
                CONSTRAINT empresa_pk PRIMARY KEY (idempresa)
);;

COMMENT ON COLUMN Empresa.situacao IS 'A-Ativa, I-Inativa';;

COMMENT ON COLUMN Empresa.controlaVendas IS 'N-Não, S-Sim';;

COMMENT ON COLUMN Empresa.controlaCompras IS 'N-Não, S-Sim';;

COMMENT ON COLUMN Empresa.controlaEstoque IS 'N-Não, S-Sim';;

COMMENT ON COLUMN Empresa.controlaPrecos IS 'N-Não, S-Sim';;

COMMENT ON COLUMN Empresa.vendasDomingo IS 'N-Não, S-Sim';;

COMMENT ON COLUMN Empresa.vendasSabado IS 'N-Não, S-Sim';;

COMMENT ON COLUMN Empresa.dataSource IS 'Nome do datasource que está configurado no Bdotools apontando para o banco especifico da empresa. ';;

COMMENT ON COLUMN Empresa.idEmpresaCadastroProduto IS 'Normalmente as empresas possuem um único cadastro para todas as empresas. Esse campo apontará para a empresa padrão de cadastro, ou se possuir mix diferente por empresa, poderá informar o valor igual ao campo idempresa.';;

COMMENT ON COLUMN Empresa.caminhoCertificadoDigital IS 'Caminho onde está o certificado digital';;

COMMENT ON COLUMN Empresa.tipoIntegracao IS 'ETL - Tarefas ETL, ''GAT'' - Geração de Arquivos por Terceiros';;

ALTER SEQUENCE seq_idempresa OWNED BY Empresa.idempresa;;

CREATE TABLE Pessoa (
                idPessoa VARCHAR(128) NOT NULL,
                razaosocial VARCHAR(255),
                nomefantasia VARCHAR(255),
                cnpj VARCHAR(14) NOT NULL,
                gln VARCHAR(20),
                cliente CHAR(1) DEFAULT 'F' NOT NULL,
                fornecedor CHAR(1) DEFAULT 'F',
                transportador CHAR(1) DEFAULT 'F',
                vendedor CHAR(1) DEFAULT 'F',
                funcionario CHAR(1) DEFAULT 'F',
                tipo CHAR(1) DEFAULT 'D',
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                idgrupoeconomico INTEGER,
                email VARCHAR(255),
                idErp INTEGER,
                idempresa INTEGER,
                tipoPessoa CHAR(1) NOT NULL,
                idMunicipio INTEGER,
                endereco VARCHAR(80),
                numero INTEGER,
                complemento VARCHAR(256),
                bairro VARCHAR(256),
                cep VARCHAR(8),
                telefone VARCHAR(256),
                dataCadastro DATE,
                latitude INTEGER,
                longitude INTEGER,
                tipoCadastro VARCHAR(1),
                idRamoAtividade INTEGER,
                sexo CHAR(1),
                representante CHAR(1),
                idPessoaLigacao VARCHAR(128),
                CONSTRAINT pessoa_pk PRIMARY KEY (idPessoa)
);;

COMMENT ON COLUMN Pessoa.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';;

COMMENT ON COLUMN Pessoa.gln IS 'Neste sentido o GLN é o identificador chave do Sistema GS1 que possibilita a identificação única e inequívoca de entidades legais, funcionais e físicas, pré-requisito para a eficiência no comércio eletrônico e na sincronização global de dados, possibilitando outras aplicações, tais como: - See more at: https://www.gs1br.org/codigos-e-padroes/chaves-de-identificacao/gln#sthash.F3giBLwe.dpuf';;

COMMENT ON COLUMN Pessoa.cliente IS 'T-True, F-False';;

COMMENT ON COLUMN Pessoa.fornecedor IS 'T-True, F-False';;

COMMENT ON COLUMN Pessoa.transportador IS 'T-True, F-False';;

COMMENT ON COLUMN Pessoa.vendedor IS 'T-True, F-False';;

COMMENT ON COLUMN Pessoa.funcionario IS 'T-True, F-False';;

COMMENT ON COLUMN Pessoa.tipo IS 'D-Distribuidor, F-Fabricante';;

COMMENT ON COLUMN Pessoa.situacao IS 'A-Ativo, I-Inativo';;

COMMENT ON COLUMN Pessoa.tipoPessoa IS 'F-Fisica, J-Juridica';;

COMMENT ON COLUMN Pessoa.tipoCadastro IS 'C-Aprovado, P-Prospect ';;

COMMENT ON COLUMN Pessoa.sexo IS 'M -> Masculino F -> Feminino';;

COMMENT ON COLUMN Pessoa.representante IS 'Identifica se o cadastro é de um representante. ';;

COMMENT ON COLUMN Pessoa.idPessoaLigacao IS 'Código que o fornecedor pode estar ligado. Ex. Codigo 1010 está ligado a pessoa 1000 ';;

CREATE INDEX fornecedor_idx_cnpj
 ON Pessoa
 ( cnpj );;

CREATE INDEX pessoa_idx_representante
 ON Pessoa
 ( representante );;

CREATE TABLE Usuario (
                idUsuario INTEGER NOT NULL,
                nome VARCHAR(255) NOT NULL,
                idPessoaFornecedor VARCHAR(128),
                idColaborador INTEGER,
                situacao CHAR(1),
                idGrupoUsuarios INTEGER,
                usuario VARCHAR(128),
                CONSTRAINT usuario_pk PRIMARY KEY (idUsuario)
);;

COMMENT ON COLUMN Usuario.idPessoaFornecedor IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';;

COMMENT ON COLUMN Usuario.situacao IS 'A-Ativo, I-Inativo.';;

CREATE SEQUENCE seq_idwfligaprodutofornecedor;;

CREATE TABLE WFLigaProdutoFornecedor (
                idWFLigaProdutoFornecedor INTEGER NOT NULL DEFAULT nextval('seq_idwfligaprodutofornecedor'),
                chaveNfe VARCHAR(255) NOT NULL,
                cnpjFornecedor VARCHAR(14) NOT NULL,
                descricaoProduto VARCHAR(255) NOT NULL,
                codigoBarras NUMERIC(14,0) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                observacao VARCHAR(512),
                situacao CHAR(1) NOT NULL,
                idUsuarioAprovacao INTEGER,
                dataAprovacao DATE,
                horaAprovacao VARCHAR(8),
                observacaoAprovacao VARCHAR(512),
                idEmpresaSolicitante INTEGER NOT NULL,
                erroEncontrado INTEGER,
                CONSTRAINT wfligaprodutofornecedor_pk PRIMARY KEY (idWFLigaProdutoFornecedor)
);;

COMMENT ON TABLE WFLigaProdutoFornecedor IS 'Armazena as solicitações de Associações de Produtos aos Fornecedores.  ';;

COMMENT ON COLUMN WFLigaProdutoFornecedor.situacao IS 'P-Pendente, R-Rejeitado, A-Aprovado.';;

COMMENT ON COLUMN WFLigaProdutoFornecedor.erroEncontrado IS '1-Ean 2-Chave Nfe-e 3-Produto Excluído 4-Produto sem Cadastro 5-Outros.';;

ALTER SEQUENCE seq_idwfligaprodutofornecedor OWNED BY WFLigaProdutoFornecedor.idWFLigaProdutoFornecedor;;

CREATE SEQUENCE seq_idwfprocesso;;

CREATE TABLE WFProcesso (
                idWFProcesso INTEGER NOT NULL DEFAULT nextval('seq_idwfprocesso'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                dataAlteracao DATE NOT NULL,
                idUsuarioAlteracao INTEGER,
                usaFilaTrabalho VARCHAR(1),
                usaNaoConformidade VARCHAR(1),
                observacao VARCHAR(10240),
                CONSTRAINT wfprocesso_pk PRIMARY KEY (idWFProcesso)
);;

COMMENT ON TABLE WFProcesso IS 'Armazenará os processos possíveis na Unidade.';;

COMMENT ON COLUMN WFProcesso.situacao IS 'A-Ativo, I-Inativo';;

COMMENT ON COLUMN WFProcesso.usaFilaTrabalho IS 'S-Sim, N-Não. ';;

COMMENT ON COLUMN WFProcesso.usaNaoConformidade IS 'S-Sim, N-Não. ';;

ALTER SEQUENCE seq_idwfprocesso OWNED BY WFProcesso.idWFProcesso;;

CREATE TABLE WFInputProcesso (
                idWFInput INTEGER NOT NULL,
                idWFProcesso INTEGER NOT NULL,
                CONSTRAINT wfinputprocesso_pk PRIMARY KEY (idWFInput, idWFProcesso)
);;

CREATE TABLE WFColunaProcesso (
                idWFColuna INTEGER NOT NULL,
                idWFProcesso INTEGER NOT NULL,
                CONSTRAINT wfcolunaprocesso_pk PRIMARY KEY (idWFColuna, idWFProcesso)
);;

CREATE TABLE WFProcessoPermissao (
                idWFProcesso INTEGER NOT NULL,
                idGrupoUsuario INTEGER NOT NULL,
                tipoGrupoUsuario CHAR(1) NOT NULL,
                abrir CHAR(1) DEFAULT 'S' NOT NULL,
                receber CHAR(1) DEFAULT 'S' NOT NULL,
                CONSTRAINT wfprocessopermissao_pk PRIMARY KEY (idWFProcesso, idGrupoUsuario, tipoGrupoUsuario)
);;

COMMENT ON COLUMN WFProcessoPermissao.tipoGrupoUsuario IS 'G-Grupo U-Usuário';;

COMMENT ON COLUMN WFProcessoPermissao.abrir IS 'S-Sim N-Não';;

COMMENT ON COLUMN WFProcessoPermissao.receber IS 'S-Sim N-Não';;

CREATE SEQUENCE seq_wfatividade;;

CREATE TABLE WFAtividade (
                idWFAtividade INTEGER NOT NULL DEFAULT nextval('seq_wfatividade'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                idWFProcesso INTEGER,
                dataAlteracao DATE NOT NULL,
                idUsuarioAlteracao INTEGER,
                prioridade INTEGER,
                tempoExpiracao INTEGER,
                tipoTempoExpiracao VARCHAR(32),
                idWFAtividadeRealizadaExpiracao INTEGER,
                ignoraEmpresaWFAtividadeColaborador CHAR(1) DEFAULT 'N' NOT NULL,
                CONSTRAINT wfatividade_pk PRIMARY KEY (idWFAtividade)
);;

COMMENT ON COLUMN WFAtividade.situacao IS 'A-Ativo, I-Inativo';;

COMMENT ON COLUMN WFAtividade.tempoExpiracao IS 'dataInclusão + horaInclusão + tempoExpiracao devem ser menores que dataHoraAtual. Caso exceda deve ser gravado a atividade expiração.';;

COMMENT ON COLUMN WFAtividade.tipoTempoExpiracao IS 'MINUTO,HORA,DIA,SEMANA,MES';;

COMMENT ON COLUMN WFAtividade.ignoraEmpresaWFAtividadeColaborador IS 'S - Sim, N - Não';;

ALTER SEQUENCE seq_wfatividade OWNED BY WFAtividade.idWFAtividade;;

CREATE TABLE WFColunaAtividade (
                idWFColuna INTEGER NOT NULL,
                idWFAtividade INTEGER NOT NULL,
                CONSTRAINT wfcolunaatividade_pk PRIMARY KEY (idWFColuna, idWFAtividade)
);;

CREATE TABLE WFInputAtividade (
                idWFInput INTEGER NOT NULL,
                idWFAtividade INTEGER NOT NULL,
                CONSTRAINT wfinputatividade_pk PRIMARY KEY (idWFInput, idWFAtividade)
);;

CREATE SEQUENCE seq_idwfatividaderealizada;;

CREATE TABLE WFAtividadeRealizada (
                idWFAtividadeRealizada INTEGER NOT NULL DEFAULT nextval('seq_idwfatividaderealizada'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                idWFAtividade INTEGER,
                dataAlteracao DATE NOT NULL,
                tipoSituacao CHAR(1) NOT NULL,
                idWFAtividadeProxima INTEGER,
                idWFImpacto INTEGER,
                idWFCausa INTEGER,
                idAreaEmpresa INTEGER,
                idUsuarioAlteracao INTEGER NOT NULL,
                idWFProcesso INTEGER,
                CONSTRAINT wfatividaderealizada_pk PRIMARY KEY (idWFAtividadeRealizada)
);;

COMMENT ON COLUMN WFAtividadeRealizada.situacao IS 'A-Ativo, I-Inativo';;

COMMENT ON COLUMN WFAtividadeRealizada.tipoSituacao IS 'F-Finalizada, S-Sequencia ';;

COMMENT ON COLUMN WFAtividadeRealizada.idWFAtividadeProxima IS 'Identifica a próxima atividade para gerar nova fila. ';;

ALTER SEQUENCE seq_idwfatividaderealizada OWNED BY WFAtividadeRealizada.idWFAtividadeRealizada;;

CREATE SEQUENCE seq_idwfprocessoevento;;

CREATE TABLE WFProcessoEvento (
                idWFProcessoEvento INTEGER NOT NULL DEFAULT nextval('seq_idwfprocessoevento'),
                idWFProcesso INTEGER,
                descricao VARCHAR(255) NOT NULL,
                idWFAtividadeInicial INTEGER,
                tempoExpiracao INTEGER,
                tipoTempoExpiracao VARCHAR(32),
                idWFAtividadeRealizadaExpiracao INTEGER,
                dataAlteracao DATE NOT NULL,
                idUsuarioAlteracao INTEGER,
                comentariosApenasAtividade CHAR(1) DEFAULT 'S',
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                CONSTRAINT wfprocessoevento_pk PRIMARY KEY (idWFProcessoEvento)
);;

COMMENT ON COLUMN WFProcessoEvento.tempoExpiracao IS 'dataInclusão + horaInclusão + tempoExpiracao devem ser menores que dataHoraAtual. Caso exceda deve ser gravado a atividade expiração.';;

COMMENT ON COLUMN WFProcessoEvento.tipoTempoExpiracao IS 'MINUTO,HORA,DIA,SEMANA,MES';;

ALTER SEQUENCE seq_idwfprocessoevento OWNED BY WFProcessoEvento.idWFProcessoEvento;;

CREATE SEQUENCE seq_wffilatrabalho;;

CREATE TABLE WFFilaTrabalho (
                idWFFilaTrabalho INTEGER NOT NULL DEFAULT nextval('seq_wffilatrabalho'),
                idWFOcorrencia INTEGER,
                idUsuarioResponsavel INTEGER,
                idWFAtividade INTEGER,
                idempresa INTEGER NOT NULL,
                idWFFilaTrabalhoAnterior INTEGER,
                observacao VARCHAR(2048),
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idTarefaExecucaoInclusao INTEGER,
                idWFAtividadeRealizada INTEGER,
                idTarefaExecucaoAtividadeRealizada INTEGER,
                dataAtividadeRealizada DATE,
                horaAtividadeRealizada VARCHAR(8),
                idUsuarioAtividadeRealizada INTEGER,
                idWFImpacto INTEGER,
                idAreaEmpresa INTEGER,
                expirada CHAR(1) DEFAULT 'N' NOT NULL,
                ciente CHAR(1) DEFAULT 'N' NOT NULL,
                dataExpiracao DATE,
                horaExpiracao VARCHAR(8),
                idTarefaExecucaoExpiracao INTEGER,
                dataCiencia DATE,
                horaCiencia VARCHAR(8),
                idTarefaExecucaoCiencia INTEGER,
                CONSTRAINT wffilatrabalho_pk PRIMARY KEY (idWFFilaTrabalho)
);;

COMMENT ON COLUMN WFFilaTrabalho.expirada IS 'S - Sim, N - Não';;

COMMENT ON COLUMN WFFilaTrabalho.ciente IS 'S - Sim, N - Não';;

ALTER SEQUENCE seq_wffilatrabalho OWNED BY WFFilaTrabalho.idWFFilaTrabalho;;

CREATE INDEX wffilatrabalho_datainclusao_idx
 ON WFFilaTrabalho
 ( dataInclusao );;

CREATE INDEX wffilatrabalho_idx_idwfocorrencia
 ON WFFilaTrabalho
 ( idWFOcorrencia );;

CREATE INDEX wffilatrabalho_idx_idempresa_idwfatividade_idusuarioresponsa161
 ON WFFilaTrabalho
 ( idEmpresa, idWFAtividade, idUsuarioResponsavel, idWFAtividadeRealizada );;

CREATE INDEX wffilatrabalho_idx_idresponsavel_idemp_atv_expirada_atvrea
 ON WFFilaTrabalho
 ( idUsuarioResponsavel, idEmpresa, idWFAtividade, expirada, idWFAtividadeRealizada );;

CREATE TABLE WFFilatrabalhoNotificacao (
                idWFFilaTrabalho INTEGER NOT NULL,
                dataNotificacao DATE NOT NULL,
                horaNotificacao VARCHAR(8) NOT NULL,
                CONSTRAINT wffilatrabalhonotificacao_pk PRIMARY KEY (idWFFilaTrabalho)
);;

CREATE SEQUENCE seq_idwffilatrabalhousuariovisualizacao;;

CREATE TABLE WFFilaTrabalhoUsuarioVisualizacao (
                idWFFilaTrabalhoUsuarioVisualizacao INTEGER NOT NULL DEFAULT nextval('seq_idwffilatrabalhousuariovisualizacao'),
                idWFFilaTrabalho INTEGER NOT NULL,
                idUsuario INTEGER NOT NULL,
                dataVisualizacao DATE NOT NULL,
                horaVisualizacao VARCHAR(8) NOT NULL,
                CONSTRAINT wffilatrabalhousuariovisualizacao_pk PRIMARY KEY (idWFFilaTrabalhoUsuarioVisualizacao)
);;

COMMENT ON COLUMN WFFilaTrabalhoUsuarioVisualizacao.dataVisualizacao IS 'Data em que o usuário visualizou a fila no cadastro de minhas ocorrencias.';;

COMMENT ON COLUMN WFFilaTrabalhoUsuarioVisualizacao.horaVisualizacao IS 'hora em que o usuário visualizou a fila de trabalho no cadastro de minhas ocorrencias.';;

ALTER SEQUENCE seq_idwffilatrabalhousuariovisualizacao OWNED BY WFFilaTrabalhoUsuarioVisualizacao.idWFFilaTrabalhoUsuarioVisualizacao;;

CREATE INDEX wffilatrabalhousuariovisualizacao_idusuario_datavisualizacao205
 ON WFFilaTrabalhoUsuarioVisualizacao
 ( idUsuario, dataVisualizacao );;

CREATE TABLE WFFilaTrabalhoCausa (
                idWFFilaTrabalho INTEGER NOT NULL,
                idWFCausa INTEGER NOT NULL,
                descricao VARCHAR(255),
                CONSTRAINT wffilatrabalhocausa_pk PRIMARY KEY (idWFFilaTrabalho, idWFCausa)
);;

CREATE SEQUENCE seq_idwffilatrabalhocomentario;;

CREATE TABLE WFFilaTrabalhoComentario (
                idWFFilaTrabalhoComentario INTEGER NOT NULL DEFAULT nextval('seq_idwffilatrabalhocomentario'),
                texto VARCHAR(8192),
                idWFFilaTrabalho INTEGER NOT NULL,
                docAnexo BYTEA,
                extDocAnexo VARCHAR(32),
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                visualizado CHAR(10) DEFAULT 'N',
                CONSTRAINT wffilatrabalhocomentario_pk PRIMARY KEY (idWFFilaTrabalhoComentario)
);;

COMMENT ON COLUMN WFFilaTrabalhoComentario.texto IS 'Usuário poderá informar uma descrição para o documento anexado.';;

COMMENT ON COLUMN WFFilaTrabalhoComentario.extDocAnexo IS 'Extensao do documento anexado.';;

COMMENT ON COLUMN WFFilaTrabalhoComentario.visualizado IS 'S - Sim N - Não';;

ALTER SEQUENCE seq_idwffilatrabalhocomentario OWNED BY WFFilaTrabalhoComentario.idWFFilaTrabalhoComentario;;

CREATE INDEX wffilatrabalhocomentario_idx_idwffilatrabalho
 ON WFFilaTrabalhoComentario
 ( idWFFilaTrabalho );;

CREATE SEQUENCE seq_idwfocorrencia;;

CREATE TABLE WFOcorrencia (
                idWFOcorrencia INTEGER NOT NULL DEFAULT nextval('seq_idwfocorrencia'),
                descricao VARCHAR(512),
                idWFProcessoEvento INTEGER,
                idempresa INTEGER,
                chave VARCHAR(255),
                chaves VARCHAR(12345),
                tipoInclusao CHAR(1) NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER,
                idTarefaExecucaoInclusao INTEGER,
                idTarefaExecucao INTEGER,
                idWFFilaTrabalhoFinalizacao INTEGER,
                valores VARCHAR(12345),
                tipoEncaminhamento CHAR(1) DEFAULT 'A',
                apelidoTarefaEncaminhamento VARCHAR(255),
                idWFPrioridade INTEGER,
                requerConfirmacao CHAR(1) DEFAULT 'N' NOT NULL,
                idUsuarioConfirmacao INTEGER,
                dataConfirmacao DATE,
                horaConfirmacao VARCHAR(8),
                confirmada CHAR(1) DEFAULT 'N' NOT NULL,
                expirada CHAR(1) DEFAULT 'N' NOT NULL,
                dataExpiracao DATE,
                horaExpiracao VARCHAR(8),
                inativa CHAR(1) DEFAULT 'N',
                dataInativacao DATE,
                horaInativacao VARCHAR(8),
                idUsuarioInativacao INTEGER,
                idTarefaExecucaoExpiracao INTEGER,
                CONSTRAINT wfocorrencia_pk PRIMARY KEY (idWFOcorrencia)
);;

COMMENT ON COLUMN WFOcorrencia.descricao IS 'Usuário poderá informar uma descrição para o documento anexado.';;

COMMENT ON COLUMN WFOcorrencia.chave IS 'campo destinado a ser excluído com o tempo.  27/04/2017 . Marques e Elcio. ';;

COMMENT ON COLUMN WFOcorrencia.tipoInclusao IS 'A-Automatico , M-Manual ';;

COMMENT ON COLUMN WFOcorrencia.idTarefaExecucaoInclusao IS 'Tarefa que incluiu a ocorrencia';;

COMMENT ON COLUMN WFOcorrencia.idTarefaExecucao IS 'Sera trocada com o tempo por idTarefaExecucaoInclusao';;

COMMENT ON COLUMN WFOcorrencia.tipoEncaminhamento IS 'A-Automatico via lógica sequencial de próxima atividade  M-Manual direcionada pelo usuário.  ';;

COMMENT ON COLUMN WFOcorrencia.apelidoTarefaEncaminhamento IS 'Caso necessário de encaminamento automático, a tarefa deverá filtrar por esse campo. ';;

COMMENT ON COLUMN WFOcorrencia.requerConfirmacao IS 'S-Sim,N-Não';;

COMMENT ON COLUMN WFOcorrencia.dataConfirmacao IS 'Quando a ocorrencia foi confirmada como resolvida';;

COMMENT ON COLUMN WFOcorrencia.horaConfirmacao IS 'Quando a ocorrencia foi confirmada como resolvida';;

COMMENT ON COLUMN WFOcorrencia.expirada IS 'S - Sim, N - Não';;

COMMENT ON COLUMN WFOcorrencia.inativa IS 'S - Sim, N - Não';;

ALTER SEQUENCE seq_idwfocorrencia OWNED BY WFOcorrencia.idWFOcorrencia;;

CREATE INDEX wfocorrencia_idx_inativa_tipo_inclusao_usuarioinclusao
 ON WFOcorrencia
 ( tipoInclusao, idUsuarioInclusao, inativa );;

CREATE INDEX wfocorrencia_idx_datainclusao_inativa_tipoinclusao
 ON WFOcorrencia
 ( dataInclusao, inativa, tipoInclusao );;

CREATE INDEX wfocorrencia_idx_idwfprocessoevento_idempresa_idproduto
 ON WFOcorrencia
 ( idWFProcessoEvento, idEmpresa, chaves );;

CREATE SEQUENCE seq_idwfocorrenciapessoa;;

CREATE TABLE WFOcorrenciaPessoa (
                idWFOcorrenciaPessoa INTEGER NOT NULL DEFAULT nextval('seq_idwfocorrenciapessoa'),
                idWFOcorrencia INTEGER NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                tipo CHAR(2) DEFAULT 'OU' NOT NULL,
                CONSTRAINT wfocorrenciapessoa_pk PRIMARY KEY (idWFOcorrenciaPessoa)
);;

COMMENT ON COLUMN WFOcorrenciaPessoa.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';;

COMMENT ON COLUMN WFOcorrenciaPessoa.tipo IS 'RE-RESPONSAVEL, AP-APOIADOR, MO-MONITORADOR, OU-OUTROS';;

ALTER SEQUENCE seq_idwfocorrenciapessoa OWNED BY WFOcorrenciaPessoa.idWFOcorrenciaPessoa;;

CREATE SEQUENCE seq_idwfocorrenciaanexo;;

CREATE TABLE WFOcorrenciaAnexo (
                idWFOcorrenciaAnexo INTEGER NOT NULL DEFAULT nextval('seq_idwfocorrenciaanexo'),
                descricao VARCHAR(255),
                idWFOcorrencia INTEGER NOT NULL,
                docAnexo BYTEA,
                extDocAnexo VARCHAR(32),
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                CONSTRAINT wfocorrenciaanexo_pk PRIMARY KEY (idWFOcorrenciaAnexo)
);;

COMMENT ON TABLE WFOcorrenciaAnexo IS 'Armazenará documentos, imagens, planilhas etc... ligados a Fila de Trabalho aberta.';;

COMMENT ON COLUMN WFOcorrenciaAnexo.descricao IS 'Usuário poderá informar uma descrição para o documento anexado.';;

COMMENT ON COLUMN WFOcorrenciaAnexo.extDocAnexo IS 'Extensao do documento anexado.';;

ALTER SEQUENCE seq_idwfocorrenciaanexo OWNED BY WFOcorrenciaAnexo.idWFOcorrenciaAnexo;;

CREATE SEQUENCE seq_idwfocorrenciadetalhe;;

CREATE TABLE WFOcorrenciaDetalhe (
                idWFOcorrenciaDetalhe INTEGER NOT NULL DEFAULT nextval('seq_idwfocorrenciadetalhe'),
                descricao VARCHAR(2048),
                idWFOcorrencia INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                CONSTRAINT wfocorrenciadetalhe_pk PRIMARY KEY (idWFOcorrenciaDetalhe)
);;

COMMENT ON TABLE WFOcorrenciaDetalhe IS 'Descrição detalhada do Problema. ';;

ALTER SEQUENCE seq_idwfocorrenciadetalhe OWNED BY WFOcorrenciaDetalhe.idWFOcorrenciaDetalhe;;

CREATE SEQUENCE funcaocolaborador_idfuncao_seq;;

CREATE TABLE FuncaoColaborador (
                idFuncao INTEGER NOT NULL DEFAULT nextval('funcaocolaborador_idfuncao_seq'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1),
                idUsuarioCadastro INTEGER,
                dataCadastro DATE,
                idUsuarioAlteracao INTEGER,
                dataAlteracao DATE,
                cargaHorariaDia NUMERIC(15,2),
                horasExtrasLimiteDia NUMERIC(15,2),
                CONSTRAINT funcaocolaborador_pk PRIMARY KEY (idFuncao)
);;

COMMENT ON COLUMN FuncaoColaborador.cargaHorariaDia IS 'Carga horária da função no dia. ';;

COMMENT ON COLUMN FuncaoColaborador.horasExtrasLimiteDia IS 'Qtde de horas extras no dia que serão aceitaveis pra a funcao. ';;

ALTER SEQUENCE funcaocolaborador_idfuncao_seq OWNED BY FuncaoColaborador.idFuncao;;

CREATE INDEX funcaocolaborador_idx_descricao
 ON FuncaoColaborador
 ( descricao );;

CREATE SEQUENCE seq_idcolaborador;;

CREATE TABLE Colaborador (
                idColaborador INTEGER NOT NULL DEFAULT nextval('seq_idcolaborador'),
                nome VARCHAR(255) NOT NULL,
                email VARCHAR(255),
                telefoneFixo VARCHAR(128),
                telefoneCelular VARCHAR(128),
                dataCadastro DATE,
                dataAdmissao DATE,
                idFuncaoPrincipal INTEGER,
                idEmpresaCadastro INTEGER,
                idEmpresaTrabalho INTEGER,
                situacao CHAR(1) NOT NULL,
                dataDesligamento DATE,
                idUsuarioCadastro INTEGER,
                idUsuarioAlteracao INTEGER,
                dataAlteracao DATE,
                foto BYTEA,
                fotoExtensao VARCHAR(16),
                apelido VARCHAR(128),
                cnpjcpf VARCHAR(20),
                pis VARCHAR(20),
                localAtendimento VARCHAR(1024),
                idJornadaTrabalho INTEGER,
                dataNascimento DATE,
                idNivelSenioridade INTEGER,
                idColaboradorRh VARCHAR(128),
                CONSTRAINT colaborador_pk PRIMARY KEY (idColaborador)
);;

COMMENT ON COLUMN Colaborador.situacao IS 'A-Ativo, I-Inativo';;

COMMENT ON COLUMN Colaborador.fotoExtensao IS 'jpg, gif, png, etc.';;

COMMENT ON COLUMN Colaborador.apelido IS 'Nome de identificação resumida do colaborador.';;

COMMENT ON COLUMN Colaborador.localAtendimento IS 'Normalmente utilizado por Compradores para especificar o local onde irão atender ao Vendedor (Fornecedor) incluído na Agenda de Atendimento. ';;

COMMENT ON COLUMN Colaborador.dataNascimento IS 'Data de Nascimento do Colaborador.';;

COMMENT ON COLUMN Colaborador.idColaboradorRh IS 'Código do Colaborador no Software de RH ou origem de importação do cadastro do colaborador.  ';;

ALTER SEQUENCE seq_idcolaborador OWNED BY Colaborador.idColaborador;;

CREATE INDEX colaborador_idx_idcolaboradorrh
 ON Colaborador
 ( idColaboradorRh );;

CREATE SEQUENCE seq_idsenhafilaatendimento;;

CREATE TABLE SenhaFilaAtendimento (
                idSenhaFilaAtendimento INTEGER NOT NULL DEFAULT nextval('seq_idsenhafilaatendimento'),
                dataGeracao DATE NOT NULL,
                horaGeracao VARCHAR(10) NOT NULL,
                senha VARCHAR(255) NOT NULL,
                idUsuarioGravacao INTEGER NOT NULL,
                tipoGeracao VARCHAR(1) NOT NULL,
                idempresa INTEGER NOT NULL,
                senhaChamada CHAR(1) DEFAULT 'N' NOT NULL,
                idColaboradorChamada INTEGER,
                dataChamada DATE,
                horaChamada VARCHAR(10),
                CONSTRAINT senhafilaatendimento_pk PRIMARY KEY (idSenhaFilaAtendimento)
);;

COMMENT ON COLUMN SenhaFilaAtendimento.tipoGeracao IS 'N-Normal P-Prioritaria';;

COMMENT ON COLUMN SenhaFilaAtendimento.senhaChamada IS 'S-Sim N-Não.   ';;

ALTER SEQUENCE seq_idsenhafilaatendimento OWNED BY SenhaFilaAtendimento.idSenhaFilaAtendimento;;

CREATE TABLE ColaboradorFuncao (
                idColaborador INTEGER NOT NULL,
                idFuncao INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                idUsuarioErp VARCHAR(128),
                CONSTRAINT colaboradorfuncao_pk PRIMARY KEY (idColaborador, idFuncao, idempresa)
);;

COMMENT ON TABLE ColaboradorFuncao IS 'Identifica a/as funções do colaborador';;

CREATE SEQUENCE seq_idwfatividadecolaborador;;

CREATE TABLE WFAtividadeColaborador (
                idWFAtividadeColaborador INTEGER NOT NULL DEFAULT nextval('seq_idwfatividadecolaborador'),
                idWFAtividade INTEGER NOT NULL,
                idColaborador INTEGER NOT NULL,
                idFuncao INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                tipo CHAR(1) DEFAULT 'E' NOT NULL,
                ignoraEmpresaWFAtividadeColaborador CHAR(1) DEFAULT 'N' NOT NULL,
                tempoMonitoramento INTEGER,
                CONSTRAINT wfatividadecolaborador_pk PRIMARY KEY (idWFAtividadeColaborador)
);;

COMMENT ON TABLE WFAtividadeColaborador IS 'Liga atividade com o colaborador responsável na empresa.';;

COMMENT ON COLUMN WFAtividadeColaborador.tipo IS 'E-Executor, M-Monitor';;

COMMENT ON COLUMN WFAtividadeColaborador.ignoraEmpresaWFAtividadeColaborador IS 'S - Sim, N - Não';;

COMMENT ON COLUMN WFAtividadeColaborador.tempoMonitoramento IS 'Em dias';;

ALTER SEQUENCE seq_idwfatividadecolaborador OWNED BY WFAtividadeColaborador.idWFAtividadeColaborador;;

CREATE TABLE Produto (
                idproduto BIGINT NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                codigobarras NUMERIC(14,0),
                descricao VARCHAR(255) NOT NULL,
                ncm VARCHAR(20),
                fabricante VARCHAR(50),
                modelo VARCHAR(50),
                iddepartamento INTEGER,
                idsetor INTEGER,
                idgrupo INTEGER,
                idfamilia INTEGER,
                idsubfamilia INTEGER,
                tipomarca CHAR(1) NOT NULL,
                pesavel CHAR(1) DEFAULT 'N',
                qtdUnEntrada NUMERIC(10,2),
                qtdMultiploVenda NUMERIC(10,2),
                unidadeentrada CHAR(2) DEFAULT 'UN',
                unidadesaida CHAR(2) DEFAULT 'UN',
                datacadastro DATE,
                dataalteracao DATE,
                idempresacadastro INTEGER,
                idProdutoBaixaEstoque BIGINT,
                idPessoaFabricante VARCHAR(128),
                idProdutoFinalidade INTEGER,
                pesoBruto NUMERIC(10,3),
                pesoLiquido NUMERIC(10,3),
                aceitaQtdeFracionada CHAR(1),
                descricaoResumida VARCHAR(155),
                foto BYTEA,
                extensao VARCHAR(255),
                descricaoEspecial VARCHAR(255),
                codigoErp VARCHAR(255),
                idProdutoTipo INTEGER,
                tipoBaixaEstoque VARCHAR(255) DEFAULT 'N',
                situacaoCompra VARCHAR(1) DEFAULT 'A',
                idmarca INTEGER,
                idGrupoPrecoProduto INTEGER,
                CONSTRAINT produto_pk PRIMARY KEY (idproduto)
);;

COMMENT ON COLUMN Produto.situacao IS 'A-Ativo, I-Inativo';;

COMMENT ON COLUMN Produto.tipomarca IS 'P-Própria N-Não Própria';;

COMMENT ON COLUMN Produto.pesavel IS 'S-Sim, N-Não';;

COMMENT ON COLUMN Produto.idPessoaFabricante IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';;

COMMENT ON COLUMN Produto.aceitaQtdeFracionada IS 'S-Sim, N-Nao';;

COMMENT ON COLUMN Produto.descricaoEspecial IS 'Campo destinado a utilização em aplicativos ou relatórios especiais, tal como exemplo: Tabela de Açougue, onde a descrição apresentada não se enquadra em nenhum dos outros campos de Descrição. ';;

COMMENT ON COLUMN Produto.codigoErp IS 'Código do Produto dentro do Erp do Cliente. ';;

COMMENT ON COLUMN Produto.tipoBaixaEstoque IS 'Identificação do tipo de movimento de estoque que o produto terá N-Normal, K-Kit, C-Cesta';;

COMMENT ON COLUMN Produto.situacaoCompra IS 'A-Ativo,  I-Inativo.  (geral para todas as empresas). ';;

CREATE INDEX produto_idx_codigobarras
 ON Produto
 ( codigoBarras );;

CREATE INDEX produto_idx_departamento
 ON Produto
 ( idDepartamento );;

CREATE INDEX produto_idx_setor
 ON Produto
 ( idSetor );;

CREATE INDEX produto_idx_grupo
 ON Produto
 ( idGrupo );;

CREATE INDEX produto_idx_familia
 ON Produto
 ( idFamilia );;

CREATE INDEX produto_idx_subfamilia
 ON Produto
 ( idSubFamilia );;

CREATE INDEX produto_idx_codigoerp
 ON Produto
 ( codigoErp );;

CREATE INDEX produto_idx_idprodutobaixaestoque
 ON Produto
 ( idProdutoBaixaEstoque );;

CREATE TABLE WFOcorrenciaProduto (
                idWFOcorrencia INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                CONSTRAINT wfocorrenciaproduto_pk PRIMARY KEY (idWFOcorrencia, idproduto)
);;

ALTER TABLE Produto ADD CONSTRAINT grupoprecoproduto_produto_fk
FOREIGN KEY (idGrupoPrecoProduto)
REFERENCES GrupoPrecoProduto (idGrupoPrecoProduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Colaborador ADD CONSTRAINT nivelsenioridadecolaborador_colaborador_fk
FOREIGN KEY (idNivelSenioridade)
REFERENCES NivelSenioridadeColaborador (idNivelSenioridadeColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFInputProcesso ADD CONSTRAINT wfinput_wfinputprocesso_fk
FOREIGN KEY (idWFInput)
REFERENCES WFInput (idWFInput)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFInputAtividade ADD CONSTRAINT wfinput_wfinputatividade_fk
FOREIGN KEY (idWFInput)
REFERENCES WFInput (idWFInput)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFColunaProcesso ADD CONSTRAINT wfcoluna_wfcolunaprocesso_fk
FOREIGN KEY (idWFColuna)
REFERENCES WFColuna (idWFColuna)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFColunaAtividade ADD CONSTRAINT wfcoluna_wfcolunaatividade_fk
FOREIGN KEY (idWFColuna)
REFERENCES WFColuna (idWFColuna)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE JornadaTrabalhoPeriodo ADD CONSTRAINT jornadatrabalho_jornadatrabalhoperiodo_fk
FOREIGN KEY (idJornadaTrabalho)
REFERENCES JornadaTrabalho (idJornadaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Colaborador ADD CONSTRAINT jornadatrabalho_colaborador_fk
FOREIGN KEY (idJornadaTrabalho)
REFERENCES JornadaTrabalho (idJornadaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE PulaFilaItens ADD CONSTRAINT pulafila_pulafilaitens_fk
FOREIGN KEY (idPulaFila)
REFERENCES PulaFila (idPulaFila)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Usuario ADD CONSTRAINT grupousuarios_usuario_fk
FOREIGN KEY (idGrupoUsuarios)
REFERENCES GrupoUsuarios (idGrupoUsuarios)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Produto ADD CONSTRAINT produtotipo_produto_fk
FOREIGN KEY (idProdutoTipo)
REFERENCES ProdutoTipo (idProdutoTipo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrencia ADD CONSTRAINT wfprioridade_wfocorrencia_fk
FOREIGN KEY (idWFPrioridade)
REFERENCES WFPrioridade (idWFPrioridade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFAtividadeRealizada ADD CONSTRAINT wfimpacto_wfatividaderealizada_fk
FOREIGN KEY (idWFImpacto)
REFERENCES WFImpacto (idWFImpacto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT wfimpacto_wffilatrabalho_fk
FOREIGN KEY (idWFImpacto)
REFERENCES WFImpacto (idWFImpacto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFAtividadeRealizada ADD CONSTRAINT wfcausa_wfatividaderealizada_fk
FOREIGN KEY (idWFCausa)
REFERENCES WFCausa (idWFCausa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFFilaTrabalhoCausa ADD CONSTRAINT wfcausa_wffilatrabalhocausa_fk
FOREIGN KEY (idWFCausa)
REFERENCES WFCausa (idWFCausa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Pessoa ADD CONSTRAINT ramoatividade_pessoa_fk
FOREIGN KEY (idRamoAtividade)
REFERENCES RamoAtividade (idRamoAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFAtividadeRealizada ADD CONSTRAINT areaempresa_wfatividaderealizada_fk
FOREIGN KEY (idAreaEmpresa)
REFERENCES AreaEmpresa (idAreaEmpresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT areaempresa_wffilatrabalho_fk
FOREIGN KEY (idAreaEmpresa)
REFERENCES AreaEmpresa (idAreaEmpresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Empresa ADD CONSTRAINT empresaregional_empresa_fk
FOREIGN KEY (idEmpresaRegional)
REFERENCES EmpresaRegional (idEmpresaRegional)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Produto ADD CONSTRAINT produtofinalidade_produto_fk
FOREIGN KEY (idProdutoFinalidade)
REFERENCES ProdutoFinalidade (idProdutoFinalidade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Uf ADD CONSTRAINT pais_uf_fk
FOREIGN KEY (idPais)
REFERENCES Pais (idPais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Municipio ADD CONSTRAINT uf_municipio_fk
FOREIGN KEY (idUf)
REFERENCES Uf (idUf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Pessoa ADD CONSTRAINT municipio_pessoa_fk
FOREIGN KEY (idMunicipio)
REFERENCES Municipio (idMunicipio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Empresa ADD CONSTRAINT municipio_empresa_fk
FOREIGN KEY (idMunicipio)
REFERENCES Municipio (idMunicipio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Produto ADD CONSTRAINT marca_produto_fk
FOREIGN KEY (idmarca)
REFERENCES Marca (idmarca)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Pessoa ADD CONSTRAINT grupoeconomico_fornecedor_fk
FOREIGN KEY (idgrupoeconomico)
REFERENCES GrupoEconomico (idgrupoeconomico)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Produto ADD CONSTRAINT subfamilia_produto_fk
FOREIGN KEY (idsubfamilia)
REFERENCES SubFamilia (idsubfamilia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Produto ADD CONSTRAINT familia_produto_fk
FOREIGN KEY (idfamilia)
REFERENCES Familia (idfamilia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Produto ADD CONSTRAINT grupo_produto_fk
FOREIGN KEY (idgrupo)
REFERENCES Grupo (idgrupo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Produto ADD CONSTRAINT setor_produto_fk
FOREIGN KEY (idsetor)
REFERENCES Setor (idsetor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Produto ADD CONSTRAINT departamento_produto_fk
FOREIGN KEY (iddepartamento)
REFERENCES Departamento (iddepartamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Empresa ADD CONSTRAINT empresa_empresa_fk
FOREIGN KEY (idempresagrupo)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Produto ADD CONSTRAINT empresa_produto_fk
FOREIGN KEY (idempresacadastro)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Pessoa ADD CONSTRAINT empresa_pessoa_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Colaborador ADD CONSTRAINT empresa_colaborador_fk
FOREIGN KEY (idEmpresaCadastro)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Colaborador ADD CONSTRAINT empresa_colaborador_trabalho_fk
FOREIGN KEY (idEmpresaTrabalho)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrencia ADD CONSTRAINT empresa_wfocorrencia_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT empresa_wffilatrabalho_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE ColaboradorFuncao ADD CONSTRAINT empresa_colaboradorfuncao_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFLigaProdutoFornecedor ADD CONSTRAINT empresa_wfligaprodutofornecedor_fk
FOREIGN KEY (idEmpresaSolicitante)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE SenhaFilaAtendimento ADD CONSTRAINT empresa_senhafilaatendimento_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Produto ADD CONSTRAINT pessoa_produto_fk
FOREIGN KEY (idPessoaFabricante)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Usuario ADD CONSTRAINT pessoa_usuario_fk
FOREIGN KEY (idPessoaFornecedor)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrenciaPessoa ADD CONSTRAINT pessoa_wfocorrenciapessoa_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Colaborador ADD CONSTRAINT usuario_colaborador_cadastro_fk
FOREIGN KEY (idUsuarioCadastro)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE FuncaoColaborador ADD CONSTRAINT usuario_funcaocolaborador_fk
FOREIGN KEY (idUsuarioCadastro)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE FuncaoColaborador ADD CONSTRAINT usuario_funcaocolaborador_alteracao_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Colaborador ADD CONSTRAINT usuario_colaborador_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT usuario_wffilatrabalho_fk
FOREIGN KEY (idUsuarioResponsavel)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFProcessoEvento ADD CONSTRAINT usuario_wfprocessoevento_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrencia ADD CONSTRAINT usuario_wfocorrencia_fk
FOREIGN KEY (idUsuarioInclusao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFAtividade ADD CONSTRAINT usuario_wfatividade_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFProcesso ADD CONSTRAINT usuario_wfprocesso_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFAtividadeRealizada ADD CONSTRAINT usuario_wfatividaderealizada_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrenciaDetalhe ADD CONSTRAINT usuario_wffilatrabalhodetalhe_fk
FOREIGN KEY (idUsuarioInclusao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrenciaAnexo ADD CONSTRAINT usuario_wffilatrabalhoanexo_fk
FOREIGN KEY (idUsuarioInclusao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrencia ADD CONSTRAINT usuarioconfirmacao_wfocorrencia_fk
FOREIGN KEY (idUsuarioConfirmacao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFLigaProdutoFornecedor ADD CONSTRAINT usuario_wfligaprodutofornecedor_fk
FOREIGN KEY (idUsuarioInclusao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFLigaProdutoFornecedor ADD CONSTRAINT usuario_aprovacao_wfligaprodutofornecedor_fk
FOREIGN KEY (idUsuarioAprovacao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrencia ADD CONSTRAINT usuarioinativacao_wfocorrencia_fk
FOREIGN KEY (idUsuarioInativacao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFFilaTrabalhoUsuarioVisualizacao ADD CONSTRAINT usuario_wffilatrabalhousuariovisualizacao_fk
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFProcessoEvento ADD CONSTRAINT processotrabalho_processotrabalhoevento_fk
FOREIGN KEY (idWFProcesso)
REFERENCES WFProcesso (idWFProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFAtividade ADD CONSTRAINT wfprocesso_wfatividade_fk
FOREIGN KEY (idWFProcesso)
REFERENCES WFProcesso (idWFProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFAtividadeRealizada ADD CONSTRAINT wfprocesso_wfatividaderealizada_fk
FOREIGN KEY (idWFProcesso)
REFERENCES WFProcesso (idWFProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFProcessoPermissao ADD CONSTRAINT wfprocesso_wfprocessopermissao_fk
FOREIGN KEY (idWFProcesso)
REFERENCES WFProcesso (idWFProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFColunaProcesso ADD CONSTRAINT wfprocesso_wfcolunaprocesso_fk
FOREIGN KEY (idWFProcesso)
REFERENCES WFProcesso (idWFProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFInputProcesso ADD CONSTRAINT wfprocesso_wfinputprocesso_fk
FOREIGN KEY (idWFProcesso)
REFERENCES WFProcesso (idWFProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT wfatividade_wffilatrabalho_fk
FOREIGN KEY (idWFAtividade)
REFERENCES WFAtividade (idWFAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFAtividadeRealizada ADD CONSTRAINT wfatividade_wfatividaderealizada_fk
FOREIGN KEY (idWFAtividade)
REFERENCES WFAtividade (idWFAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFAtividadeRealizada ADD CONSTRAINT wfatividade_wfatividaderealizada2_fk
FOREIGN KEY (idWFAtividadeProxima)
REFERENCES WFAtividade (idWFAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFAtividadeColaborador ADD CONSTRAINT wfatividade_wfatividadecolaborador_fk
FOREIGN KEY (idWFAtividade)
REFERENCES WFAtividade (idWFAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFProcessoEvento ADD CONSTRAINT wfatividadeinicial_wfprocessoevento_fk
FOREIGN KEY (idWFAtividadeInicial)
REFERENCES WFAtividade (idWFAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFInputAtividade ADD CONSTRAINT wfatividade_wfinputatividade_fk
FOREIGN KEY (idWFAtividade)
REFERENCES WFAtividade (idWFAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFColunaAtividade ADD CONSTRAINT wfatividade_wfcolunaatividade_fk
FOREIGN KEY (idWFAtividade)
REFERENCES WFAtividade (idWFAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT wfatividaderealizada_wffilatrabalho_fk
FOREIGN KEY (idWFAtividadeRealizada)
REFERENCES WFAtividadeRealizada (idWFAtividadeRealizada)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFProcessoEvento ADD CONSTRAINT wfatividaderealizadaexpiracao_wfprocessoevento_fk
FOREIGN KEY (idWFAtividadeRealizadaExpiracao)
REFERENCES WFAtividadeRealizada (idWFAtividadeRealizada)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFAtividade ADD CONSTRAINT wfatividaderealizadaexpiracao_wfatividade_fk
FOREIGN KEY (idWFAtividadeRealizadaExpiracao)
REFERENCES WFAtividadeRealizada (idWFAtividadeRealizada)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrencia ADD CONSTRAINT wfprocessoevento_wfocorrencia_fk
FOREIGN KEY (idWFProcessoEvento)
REFERENCES WFProcessoEvento (idWFProcessoEvento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrencia ADD CONSTRAINT wffilatrabalhofinalizacao_wfocorrencia_fk
FOREIGN KEY (idWFFilaTrabalhoFinalizacao)
REFERENCES WFFilaTrabalho (idWFFilaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT wffilatrabalho_wffilatrabalho_fk
FOREIGN KEY (idWFFilaTrabalhoAnterior)
REFERENCES WFFilaTrabalho (idWFFilaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFFilaTrabalhoComentario ADD CONSTRAINT wffilatrabalho_wffilatrabalhocomentario_fk
FOREIGN KEY (idWFFilaTrabalho)
REFERENCES WFFilaTrabalho (idWFFilaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFFilaTrabalhoCausa ADD CONSTRAINT wffilatrabalho_wffilatrabalhocausa_fk
FOREIGN KEY (idWFFilaTrabalho)
REFERENCES WFFilaTrabalho (idWFFilaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFFilaTrabalhoUsuarioVisualizacao ADD CONSTRAINT wffilatrabalho_wffilatrabalhousuariovisualizacao_fk
FOREIGN KEY (idWFFilaTrabalho)
REFERENCES WFFilaTrabalho (idWFFilaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFFilatrabalhoNotificacao ADD CONSTRAINT wffilatrabalho_wffilatrabalhonotificacao_fk
FOREIGN KEY (idWFFilaTrabalho)
REFERENCES WFFilaTrabalho (idWFFilaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT wfocorrencia_wffilatrabalho_fk
FOREIGN KEY (idWFOcorrencia)
REFERENCES WFOcorrencia (idWFOcorrencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrenciaDetalhe ADD CONSTRAINT wfocorrencia_wffilatrabalhodetalhe_fk
FOREIGN KEY (idWFOcorrencia)
REFERENCES WFOcorrencia (idWFOcorrencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrenciaAnexo ADD CONSTRAINT wfocorrencia_wffilatrabalhoanexo_fk
FOREIGN KEY (idWFOcorrencia)
REFERENCES WFOcorrencia (idWFOcorrencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrenciaProduto ADD CONSTRAINT wfocorrencia_wfocorrenciaproduto_fk
FOREIGN KEY (idWFOcorrencia)
REFERENCES WFOcorrencia (idWFOcorrencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrenciaPessoa ADD CONSTRAINT wfocorrencia_wfocorrenciapessoa_fk
FOREIGN KEY (idWFOcorrencia)
REFERENCES WFOcorrencia (idWFOcorrencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE ColaboradorFuncao ADD CONSTRAINT funcaocolaborador_colaboradorfuncao_fk
FOREIGN KEY (idFuncao)
REFERENCES FuncaoColaborador (idFuncao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Colaborador ADD CONSTRAINT funcaocolaborador_colaborador_fk
FOREIGN KEY (idFuncaoPrincipal)
REFERENCES FuncaoColaborador (idFuncao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE ColaboradorFuncao ADD CONSTRAINT colaborador_colaboradorfuncao_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE Usuario ADD CONSTRAINT colaborador_usuario_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE SenhaFilaAtendimento ADD CONSTRAINT colaborador_senhafilaatendimento_fk
FOREIGN KEY (idColaboradorChamada)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFAtividadeColaborador ADD CONSTRAINT colaboradorfuncao_wfatividadecolaborador_fk
FOREIGN KEY (idColaborador, idFuncao, idempresa)
REFERENCES ColaboradorFuncao (idColaborador, idFuncao, idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;

ALTER TABLE WFOcorrenciaProduto ADD CONSTRAINT produto_wfocorrenciaproduto_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;;
