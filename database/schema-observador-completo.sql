
CREATE SEQUENCE seq_idwfgtarefa;

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
);
COMMENT ON TABLE WfgTarefa IS 'Nós do fluxo WFG vinculados à tarefa de execução (apelidoTarefaPai).';
COMMENT ON COLUMN WfgTarefa.apelidoTarefaPai IS 'Apelido da tarefa CLIENTE-wfg-{codigo}-execucao no datasource2.';
COMMENT ON COLUMN WfgTarefa.jsonbParametros IS 'JSON: drawflowNodeId, nome, filtros [{key, query, value}], etc.';

ALTER SEQUENCE seq_idwfgtarefa OWNED BY WfgTarefa.idWfgTarefa;

CREATE INDEX ix_wfgtarefa_pai_ordem ON WfgTarefa (apelidoTarefaPai, ordemExecucao);

CREATE TABLE TokenApi (
                token VARCHAR(255) NOT NULL,
                descricao VARCHAR(255),
                usuario VARCHAR(128),
                ipsLiberados VARCHAR(1024),
                dataHoraCriacao TIMESTAMP DEFAULT now() NOT NULL,
                dataHoraExpiracao TIMESTAMP NOT NULL,
                datasource VARCHAR(255),
                CONSTRAINT tokenapi_pk PRIMARY KEY (token)
);


CREATE SEQUENCE seq_idtarefaerp;

CREATE TABLE TarefaErp (
                idTarefaErp INTEGER NOT NULL DEFAULT nextval('seq_idtarefaerp'),
                apelido VARCHAR(255) NOT NULL,
                erp VARCHAR(10) NOT NULL,
                tags VARCHAR(1024) NOT NULL,
                CONSTRAINT tarefaerp_pk PRIMARY KEY (idTarefaErp)
);
COMMENT ON COLUMN TarefaErp.tags IS 'estoque|preco|venda|compra|inventario|etc...';


ALTER SEQUENCE seq_idtarefaerp OWNED BY TarefaErp.idTarefaErp;

CREATE SEQUENCE seq_idgrupoprecoproduto;

CREATE TABLE GrupoPrecoProduto (
                idGrupoPrecoProduto INTEGER NOT NULL DEFAULT nextval('seq_idgrupoprecoproduto'),
                descricao VARCHAR(256) NOT NULL,
                dataInclusao DATE DEFAULT current_date NOT NULL,
                CONSTRAINT grupopreco_pk PRIMARY KEY (idGrupoPrecoProduto)
);


ALTER SEQUENCE seq_idgrupoprecoproduto OWNED BY GrupoPrecoProduto.idGrupoPrecoProduto;

CREATE SEQUENCE seq_idrecursobloqueiouso;

CREATE TABLE RecursoBloqueioUso (
                idRecursoBloqueioUso INTEGER NOT NULL DEFAULT nextval('seq_idrecursobloqueiouso'),
                idRecurso VARCHAR(255) NOT NULL,
                descricaoRecurso VARCHAR(255) NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                dataInclusao DATE NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                dataHoraInicialBloqueio TIMESTAMP NOT NULL,
                dataHoraFinalBloqueio TIMESTAMP NOT NULL,
                observacao VARCHAR(1024),
                CONSTRAINT recursobloqueiouso_pk PRIMARY KEY (idRecursoBloqueioUso)
);
COMMENT ON TABLE RecursoBloqueioUso IS 'Tabela destinada para usuário poder informar periodos que determinado recurso e/ou Módulo estarão indisponíveis. ';
COMMENT ON COLUMN RecursoBloqueioUso.idRecurso IS 'Nome do recurso que deverá ser bloqueado uso por determinado periodo.  Ex. Antecipação de Recursos. ';


ALTER SEQUENCE seq_idrecursobloqueiouso OWNED BY RecursoBloqueioUso.idRecursoBloqueioUso;

CREATE SEQUENCE seq_idcontrolenotificacao;

CREATE TABLE ControleNotificacao (
                idControleNotificacao INTEGER NOT NULL DEFAULT nextval('seq_idcontrolenotificacao'),
                recurso VARCHAR(255) NOT NULL,
                apelidoTarefa VARCHAR(255) NOT NULL,
                chaveNotificacao VARCHAR(255) NOT NULL,
                idRegistro VARCHAR(255) NOT NULL,
                tipoNotificacao INTEGER NOT NULL,
                dataNotificacao DATE NOT NULL,
                horaNotificacao VARCHAR(10) NOT NULL,
                CONSTRAINT controlenotificacao_pk PRIMARY KEY (idControleNotificacao)
);
COMMENT ON TABLE ControleNotificacao IS 'Tabela destinada a gravar os controles de notificação de registros. Ex. Saber se um cliente foi ou não cobrado.  ';
COMMENT ON COLUMN ControleNotificacao.recurso IS 'Identificação de Qual Recurso o Registro pertence. Exemplo: Quizzer, NC, etc...';
COMMENT ON COLUMN ControleNotificacao.chaveNotificacao IS 'Exemplo: Chat';
COMMENT ON COLUMN ControleNotificacao.idRegistro IS 'Identificação do registro. Exemplo de chaveNotificacao = ''CHAT'', poderia ser o IdChat';
COMMENT ON COLUMN ControleNotificacao.tipoNotificacao IS '0-Email 1-Mensageiro 2-Sms 3-Client 4-Msn/Whatsapp 5-Mobile App 6-Telegram 7-Webview 8-Webview ou Mobile';


ALTER SEQUENCE seq_idcontrolenotificacao OWNED BY ControleNotificacao.idControleNotificacao;

CREATE INDEX controlenotificacao_idx_chave_idregistro
 ON ControleNotificacao
 ( chaveNotificacao, idRegistro );

CREATE INDEX controlenotificacao_idx_data_hora_chave
 ON ControleNotificacao
 ( dataNotificacao, horaNotificacao, chaveNotificacao );

CREATE SEQUENCE seq_idperfilpessoa;

CREATE TABLE PerfilPessoa (
                idPerfilPessoa INTEGER NOT NULL DEFAULT nextval('seq_idperfilpessoa'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                cliente VARCHAR(1) DEFAULT 'S' NOT NULL,
                fornecedor VARCHAR(1) DEFAULT 'S' NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(10) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                observacao VARCHAR(5120),
                CONSTRAINT perfilpessoa_pk PRIMARY KEY (idPerfilPessoa)
);
COMMENT ON TABLE PerfilPessoa IS 'Cadastro de Caracteristicas de Pessoa que poderão ser ligadas ao registro de Pessoa. ';
COMMENT ON COLUMN PerfilPessoa.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN PerfilPessoa.cliente IS 'S-Sim, N-Não. Irá ser listado quando tarefas tratarem assunto de clientes se tiver S como valor. ';
COMMENT ON COLUMN PerfilPessoa.fornecedor IS 'S-Sim, N-Não.  Irá ser listado quando tarefas tratarem assunto de Fornecedores se tiver S como valor. ';


ALTER SEQUENCE seq_idperfilpessoa OWNED BY PerfilPessoa.idPerfilPessoa;

CREATE TABLE ClasseMercadologico (
                idEmpresa INTEGER NOT NULL,
                tipoMercadologico VARCHAR(255) NOT NULL,
                idMercadologico VARCHAR(255) NOT NULL,
                tipoanalise CHAR(1) NOT NULL,
                classe CHAR(1),
                CONSTRAINT classemercadologico_pk PRIMARY KEY (idEmpresa, tipoMercadologico, idMercadologico, tipoanalise)
);
COMMENT ON TABLE ClasseMercadologico IS 'Classificação ABC,X de Mercadologicos ligados aos Produtos.';
COMMENT ON COLUMN ClasseMercadologico.idEmpresa IS 'Decidido não fazer ligação com idempresa por ser necessário aceitar idempresa com 0, a fim  de identificar se tratar de classificação do Mercadologico somando todas as empresas do grupo. ';
COMMENT ON COLUMN ClasseMercadologico.tipoMercadologico IS 'D-Departamento S-Setor G-Grupo F-Familia U-Subfamilia';
COMMENT ON COLUMN ClasseMercadologico.tipoanalise IS 'V-Valor de vendas, G-Quantidade de vendas (Giro), L-Valor de lucro, M-Margem de lucro';


CREATE SEQUENCE seq_idpublicacao;

CREATE TABLE Publicacao (
                idPublicacao INTEGER NOT NULL DEFAULT nextval('seq_idpublicacao'),
                descricao VARCHAR(128) NOT NULL,
                conteudo VARCHAR(12345) NOT NULL,
                RegraDestinatario VARCHAR(12345),
                dataInicial DATE,
                dataFinal DATE,
                situacao VARCHAR(1) DEFAULT 'C' NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER,
                CONSTRAINT publicacao_pk PRIMARY KEY (idPublicacao)
);
COMMENT ON COLUMN Publicacao.situacao IS 'C-Cobrança, N-Negociado';


ALTER SEQUENCE seq_idpublicacao OWNED BY Publicacao.idPublicacao;

CREATE SEQUENCE seq_idnivelsenioridadecolaborador;

CREATE TABLE NivelSenioridadeColaborador (
                idNivelSenioridadeColaborador INTEGER NOT NULL DEFAULT nextval('seq_idnivelsenioridadecolaborador'),
                descricao VARCHAR(128) NOT NULL,
                situacao CHAR(1),
                idUsuarioCadastro INTEGER,
                dataCadastro DATE,
                CONSTRAINT nivelsenioridadecolaborador_pk PRIMARY KEY (idNivelSenioridadeColaborador)
);


ALTER SEQUENCE seq_idnivelsenioridadecolaborador OWNED BY NivelSenioridadeColaborador.idNivelSenioridadeColaborador;

CREATE SEQUENCE seq_idperiodo;

CREATE TABLE Periodo (
                idPeriodo INTEGER NOT NULL DEFAULT nextval('seq_idperiodo'),
                descricao VARCHAR(128) NOT NULL,
                tipoPeriodo VARCHAR(128) NOT NULL,
                dataInicial DATE NOT NULL,
                dataFinal DATE NOT NULL,
                dataCompetencia DATE NOT NULL,
                situacao VARCHAR(1) DEFAULT 'A' NOT NULL,
                idUsuarioCadastro INTEGER NOT NULL,
                dataCadastro DATE NOT NULL,
                CONSTRAINT periodo_pk PRIMARY KEY (idPeriodo)
);
COMMENT ON TABLE Periodo IS 'Armazenará informações de periodos não convencionais, mas que representem uma lógica de gestão dos clientes. Ex.  Semana que começa no dia 04 e não dia 01.';
COMMENT ON COLUMN Periodo.tipoPeriodo IS 'Nome do atributo da tabela Data.  Ex:   agrupamento diário: = a ddmmaaaa   agrupamento semanal: = a semanaano Salvar portando  mes, ano, semana, quinzena, trimestre...';
COMMENT ON COLUMN Periodo.dataCompetencia IS 'Competencia de gestao. Ex. Cliente pode pedir relatório de Vendas do Mes X separando pelas semanas desse mês. ';
COMMENT ON COLUMN Periodo.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idperiodo OWNED BY Periodo.idPeriodo;

CREATE SEQUENCE seq_idaceite;

CREATE TABLE Aceite (
                idAceite INTEGER NOT NULL DEFAULT nextval('seq_idaceite'),
                tipoPessoa VARCHAR(1) NOT NULL,
                idPessoa VARCHAR(10) NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                apelidoTarefaInclusao VARCHAR(128) NOT NULL,
                textoAceite VARCHAR(5120) NOT NULL,
                ip VARCHAR(128) NOT NULL,
                CONSTRAINT aceite_pk PRIMARY KEY (idAceite)
);
COMMENT ON TABLE Aceite IS 'tabela destinada para gravação de aceite dados por usuários, fornecedores, clientes etc....';
COMMENT ON COLUMN Aceite.tipoPessoa IS 'F-Fornecedor C-Cliente U-Usuario';
COMMENT ON COLUMN Aceite.textoAceite IS 'Guarda o texto que foi dado aceite pela pessoa.';


ALTER SEQUENCE seq_idaceite OWNED BY Aceite.idAceite;

CREATE TABLE TokenAcesso (
                token VARCHAR(255) NOT NULL,
                parametros VARCHAR(12345) NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(10) NOT NULL,
                apelidoTarefa VARCHAR(255),
                dataAcesso DATE,
                horaAcesso VARCHAR(10),
                CONSTRAINT tokenacesso_pk PRIMARY KEY (token)
);
COMMENT ON TABLE TokenAcesso IS 'Armazena informações de Token de acesso geral, em especial parametros em links que usuários clicam para acessar url com parametros enviados. ';
COMMENT ON COLUMN TokenAcesso.parametros IS 'Será convertido para Jsonb';
COMMENT ON COLUMN TokenAcesso.apelidoTarefa IS 'Identifica a tarefa que o token será utilizado. ';
COMMENT ON COLUMN TokenAcesso.dataAcesso IS 'Data que o usuário clicou no link e fez uso do link. ';
COMMENT ON COLUMN TokenAcesso.horaAcesso IS 'Hora que o usuário clicou no link e fez uso do link. ';


CREATE SEQUENCE seq_idcampanhaofertaitenstipooferta;

CREATE TABLE CampanhaOfertaItensTipoOferta (
                idCampanhaOfertaItensTipoOferta INTEGER NOT NULL DEFAULT nextval('seq_idcampanhaofertaitenstipooferta'),
                descricao VARCHAR(255) NOT NULL,
                situacao VARCHAR(1) DEFAULT 'C' NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER,
                CONSTRAINT campanhaofertaitenstipooferta_pk PRIMARY KEY (idCampanhaOfertaItensTipoOferta)
);
COMMENT ON TABLE CampanhaOfertaItensTipoOferta IS 'De Por Normal Leve 3 Pague 2 50% na Segunda Unidade CRM ';
COMMENT ON COLUMN CampanhaOfertaItensTipoOferta.situacao IS 'C-Cobrança, N-Negociado';


ALTER SEQUENCE seq_idcampanhaofertaitenstipooferta OWNED BY CampanhaOfertaItensTipoOferta.idCampanhaOfertaItensTipoOferta;

CREATE SEQUENCE seq_idcampanhaofertatipo;

CREATE TABLE CampanhaOfertaTipo (
                idCampanhaOfertaTipo INTEGER NOT NULL DEFAULT nextval('seq_idcampanhaofertatipo'),
                descricao VARCHAR(255) NOT NULL,
                situacao VARCHAR(1) DEFAULT 'C' NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER,
                CONSTRAINT campanhaofertatipo_pk PRIMARY KEY (idCampanhaOfertaTipo)
);
COMMENT ON TABLE CampanhaOfertaTipo IS 'Uma forma de classificar as campanhas criadas. Ex. Semanal Final de Semana Super V Fecha Mês Segunda da Limpeza CRM Ação Pontual ';
COMMENT ON COLUMN CampanhaOfertaTipo.situacao IS 'C-Cobrança, N-Negociado';


ALTER SEQUENCE seq_idcampanhaofertatipo OWNED BY CampanhaOfertaTipo.idCampanhaOfertaTipo;

CREATE SEQUENCE seq_idprodutotipodetalhe;

CREATE TABLE ProdutoTipoDetalhe (
                idProdutoTipoDetalhe INTEGER NOT NULL DEFAULT nextval('seq_idprodutotipodetalhe'),
                descricao VARCHAR(255) NOT NULL,
                CONSTRAINT produtotipodetalhe_pk PRIMARY KEY (idProdutoTipoDetalhe)
);


ALTER SEQUENCE seq_idprodutotipodetalhe OWNED BY ProdutoTipoDetalhe.idProdutoTipoDetalhe;

CREATE SEQUENCE seq_idcanalpublicidade;

CREATE TABLE CanalPublicidade (
                idCanalPublicidade INTEGER NOT NULL DEFAULT nextval('seq_idcanalpublicidade'),
                descricao VARCHAR(256) NOT NULL,
                situacao VARCHAR(1) DEFAULT 'C' NOT NULL,
                dataInclusao DATE NOT NULL,
                idUsuarioInclusao INTEGER,
                CONSTRAINT canalpublicidade_pk PRIMARY KEY (idCanalPublicidade)
);
COMMENT ON TABLE CanalPublicidade IS 'Para armazenar os canais de divulgação de marketing da empresa.   Tv, Radio, Redes Sociais etc...';
COMMENT ON COLUMN CanalPublicidade.situacao IS 'C-Cobrança, N-Negociado';


ALTER SEQUENCE seq_idcanalpublicidade OWNED BY CanalPublicidade.idCanalPublicidade;

CREATE SEQUENCE seq_idinstituicaofinanceira;

CREATE TABLE InstituicaoFinanceira (
                idInstituicaoFinanceira INTEGER NOT NULL DEFAULT nextval('seq_idinstituicaofinanceira'),
                descricao VARCHAR(256) NOT NULL,
                situacao VARCHAR(1) DEFAULT 'A' NOT NULL,
                dataInclusao DATE NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                midia BYTEA,
                extMidia VARCHAR(32),
                descricaoMidia VARCHAR(1024),
                taxaDescontoAntecipado NUMERIC(15,3),
                CONSTRAINT instituicaofinanceira_pk PRIMARY KEY (idInstituicaoFinanceira)
);
COMMENT ON COLUMN InstituicaoFinanceira.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idinstituicaofinanceira OWNED BY InstituicaoFinanceira.idInstituicaoFinanceira;

CREATE SEQUENCE seq_idregiao;

CREATE TABLE Regiao (
                idRegiao INTEGER NOT NULL DEFAULT nextval('seq_idregiao'),
                descricao VARCHAR(256) NOT NULL,
                situacao VARCHAR(1) NOT NULL,
                CONSTRAINT regiao_pk PRIMARY KEY (idRegiao)
);
COMMENT ON COLUMN Regiao.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idregiao OWNED BY Regiao.idRegiao;

CREATE SEQUENCE seq_idtimeline;

CREATE TABLE Timeline (
                idTimeline INTEGER NOT NULL DEFAULT nextval('seq_idtimeline'),
                tabela VARCHAR(255) NOT NULL,
                chave VARCHAR(12345) NOT NULL,
                dataHora TIMESTAMP NOT NULL,
                latitude NUMERIC(16,8) NOT NULL,
                longitude NUMERIC(16,8) NOT NULL,
                CONSTRAINT timeline_pk PRIMARY KEY (idTimeline)
);
COMMENT ON TABLE Timeline IS 'Inicialmente utilizado no Quizzer para gerar uma timeline em relação as alternativas, imagens e finalizações de questionários, para saber quando e aonde foram feitas determinadas ações.  Armazena não só o tempo, mas o espaço também.';
COMMENT ON COLUMN Timeline.tabela IS 'Define a tabela a qual pertence os dados com base na coluna chave.';
COMMENT ON COLUMN Timeline.chave IS 'Converter para jsonb.  Campo utilizado para definir as chaves "pks" em relação ao campo tabela.  Ex: tabela "alternativaselecionada" chave "{ idalternativa: 1, idaplicacaoquestionario: 1, idquestao: 1 }"';


ALTER SEQUENCE seq_idtimeline OWNED BY Timeline.idTimeline;

CREATE SEQUENCE seq_idveiculocheck;

CREATE TABLE VeiculoCheck (
                idVeiculoCheck INTEGER NOT NULL DEFAULT nextval('seq_idveiculocheck'),
                Descricao VARCHAR(255) NOT NULL,
                saida CHAR(1),
                entrada CHAR(1),
                checkObrigatorio CHAR(1),
                dataInclusao DATE,
                horaInclusao VARCHAR(8),
                idUsuarioInclusao INTEGER,
                situacao CHAR(1),
                CONSTRAINT veiculocheck_pk PRIMARY KEY (idVeiculoCheck)
);
COMMENT ON TABLE VeiculoCheck IS 'Checagens a serem realizadas na movimentação de veículos.';
COMMENT ON COLUMN VeiculoCheck.Descricao IS 'Descrição do item a checar.';
COMMENT ON COLUMN VeiculoCheck.saida IS 'S-Sim, N-Não.';
COMMENT ON COLUMN VeiculoCheck.entrada IS 'S-Sim, N-Não.';
COMMENT ON COLUMN VeiculoCheck.checkObrigatorio IS 'S-Sim, N-Não. ';
COMMENT ON COLUMN VeiculoCheck.situacao IS 'A-Ativo,  I-Inativo.';


ALTER SEQUENCE seq_idveiculocheck OWNED BY VeiculoCheck.idVeiculoCheck;

CREATE SEQUENCE seq_idconteudoapresentacao;

CREATE TABLE ConteudoApresentacao (
                idConteudoApresentacao INTEGER NOT NULL DEFAULT nextval('seq_idconteudoapresentacao'),
                descricao VARCHAR(255) NOT NULL,
                chave VARCHAR(256) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(10) NOT NULL,
                idUsuarioAlteracao INTEGER NOT NULL,
                dataAlteracao DATE NOT NULL,
                horaAlteracao VARCHAR(10) NOT NULL,
                CONSTRAINT conteudoapresentacao_pk PRIMARY KEY (idConteudoApresentacao)
);
COMMENT ON COLUMN ConteudoApresentacao.chave IS 'Chave para identificar e localizar o conteudo nas tarefas. Ex: PAINEL_APRESENTACAO_LEITOR_CODIGO_BARRAS';


ALTER SEQUENCE seq_idconteudoapresentacao OWNED BY ConteudoApresentacao.idConteudoApresentacao;

CREATE SEQUENCE seq_idconteudoapresentacaomidia;

CREATE TABLE ConteudoApresentacaoMidia (
                idConteudoApresentacaoMidia INTEGER NOT NULL DEFAULT nextval('seq_idconteudoapresentacaomidia'),
                idConteudoApresentacao INTEGER NOT NULL,
                midia BYTEA,
                extensaoMidia VARCHAR(32),
                ordemApresentacao INTEGER NOT NULL,
                tempoApresentacao INTEGER NOT NULL,
                CONSTRAINT conteudoapresentacaomidia_pk PRIMARY KEY (idConteudoApresentacaoMidia)
);
COMMENT ON COLUMN ConteudoApresentacaoMidia.ordemApresentacao IS 'Ordem da mídia no conteúo.';
COMMENT ON COLUMN ConteudoApresentacaoMidia.tempoApresentacao IS 'Tempo de apresentação (exibição) em segundos. 60 = 1 minuto.';


ALTER SEQUENCE seq_idconteudoapresentacaomidia OWNED BY ConteudoApresentacaoMidia.idConteudoApresentacaoMidia;

CREATE SEQUENCE seq_idmovimentoveiculomotivo;

CREATE TABLE MovimentoVeiculoMotivo (
                idMovimentoVeiculoMotivo INTEGER NOT NULL DEFAULT nextval('seq_idmovimentoveiculomotivo'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1),
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                CONSTRAINT movimentoveiculomotivo_pk PRIMARY KEY (idMovimentoVeiculoMotivo)
);
COMMENT ON TABLE MovimentoVeiculoMotivo IS 'Motivo da movimentação do Veículo. ';
COMMENT ON COLUMN MovimentoVeiculoMotivo.situacao IS 'A-Ativo,  I-Inativo.';


ALTER SEQUENCE seq_idmovimentoveiculomotivo OWNED BY MovimentoVeiculoMotivo.idMovimentoVeiculoMotivo;

CREATE SEQUENCE seq_idtemplatefabric;

CREATE TABLE TemplateFabric (
                idTemplateFabric INTEGER NOT NULL DEFAULT nextval('seq_idtemplatefabric'),
                descricao VARCHAR(1024) NOT NULL,
                chave VARCHAR(256) NOT NULL,
                templateFabric VARCHAR(12345) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(10) NOT NULL,
                idUsuarioAlteracao INTEGER NOT NULL,
                dataAlteracao DATE NOT NULL,
                horaAlteracao VARCHAR(10) NOT NULL,
                CONSTRAINT templatefabric_pk PRIMARY KEY (idTemplateFabric)
);
COMMENT ON TABLE TemplateFabric IS 'Aramzena os templates criados via biblioteca Fabric JS e pode ser utilizado em muitos recursos via CHAVE.';
COMMENT ON COLUMN TemplateFabric.descricao IS 'Descrição sobre o template fabric que será criado. Ex: Leitor de Código de Barras';
COMMENT ON COLUMN TemplateFabric.chave IS 'Chave para identificar e localizar o template fabric nas tarefas. Ex: LEITOR_CODIGO_BARRAS';
COMMENT ON COLUMN TemplateFabric.templateFabric IS 'O template fabric em si, no formato json. Alterar o script do postgres para gerar como text jsonb.';


ALTER SEQUENCE seq_idtemplatefabric OWNED BY TemplateFabric.idTemplateFabric;

CREATE SEQUENCE seq_idsolicitacaosuprimentotipoetapa;

CREATE TABLE SolicitacaoSuprimentoTipoEtapa (
                idSolicitacaoSuprimentoTipoEtapa INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimentotipoetapa'),
                descricao VARCHAR(255) NOT NULL,
                CONSTRAINT solicitacaosuprimentotipoetapa_pk PRIMARY KEY (idSolicitacaoSuprimentoTipoEtapa)
);


ALTER SEQUENCE seq_idsolicitacaosuprimentotipoetapa OWNED BY SolicitacaoSuprimentoTipoEtapa.idSolicitacaoSuprimentoTipoEtapa;

CREATE SEQUENCE seq_idsolicitacaosuprimentomotivo;

CREATE TABLE SolicitacaoSuprimentoMotivo (
                idSolicitacaoSuprimentoMotivo INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimentomotivo'),
                descricao VARCHAR(255) NOT NULL,
                dataInclusao DATE NOT NULL,
                situacao CHAR(1) NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                CONSTRAINT solicitacaosuprimentomotivo_pk PRIMARY KEY (idSolicitacaoSuprimentoMotivo)
);
COMMENT ON TABLE SolicitacaoSuprimentoMotivo IS 'Motivo da Solicitação. ';


ALTER SEQUENCE seq_idsolicitacaosuprimentomotivo OWNED BY SolicitacaoSuprimentoMotivo.idSolicitacaoSuprimentoMotivo;

CREATE SEQUENCE seq_idsolicitacaosuprimentoitem;

CREATE TABLE SolicitacaoSuprimentoItem (
                idSolicitacaoSuprimentoItem INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimentoitem'),
                descricao VARCHAR(255) NOT NULL,
                dataInclusao DATE NOT NULL,
                situacao CHAR(1) NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                idProdutoErp VARCHAR(255),
                CONSTRAINT solicitacaosuprimentoitem_pk PRIMARY KEY (idSolicitacaoSuprimentoItem)
);
COMMENT ON COLUMN SolicitacaoSuprimentoItem.idProdutoErp IS 'Código Produto no Erp. ';


ALTER SEQUENCE seq_idsolicitacaosuprimentoitem OWNED BY SolicitacaoSuprimentoItem.idSolicitacaoSuprimentoItem;

CREATE SEQUENCE seq_idsolicitacaosuprimentocategoria;

CREATE TABLE SolicitacaoSuprimentoCategoria (
                idSolicitacaoSuprimentoCategoria INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimentocategoria'),
                situacao CHAR(1) NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                CONSTRAINT solicitacaosuprimentocategoria_pk PRIMARY KEY (idSolicitacaoSuprimentoCategoria)
);


ALTER SEQUENCE seq_idsolicitacaosuprimentocategoria OWNED BY SolicitacaoSuprimentoCategoria.idSolicitacaoSuprimentoCategoria;

CREATE SEQUENCE seq_idsolicitacaosuprimentosubcategoria;

CREATE TABLE SolicitacaoSuprimentoSubCategoria (
                idSolicitacaoSuprimentoSubCategoria INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimentosubcategoria'),
                idSolicitacaoSuprimentoCategoria INTEGER NOT NULL,
                situacao CHAR(1) NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                CONSTRAINT solicitacaosuprimentosubcategoria_pk PRIMARY KEY (idSolicitacaoSuprimentoSubCategoria)
);
COMMENT ON TABLE SolicitacaoSuprimentoSubCategoria IS 'Tabela filha da SolicitacaoSuprimentoCategoria';


ALTER SEQUENCE seq_idsolicitacaosuprimentosubcategoria OWNED BY SolicitacaoSuprimentoSubCategoria.idSolicitacaoSuprimentoSubCategoria;

CREATE SEQUENCE seq_idsolicitacaosupitemsubcategoria;

CREATE TABLE SolicitacaoSupItemSubCategoria (
                idSolicitacaoSupItemSubCategoria INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosupitemsubcategoria'),
                idSolicitacaoSuprimentoSubCategoria INTEGER NOT NULL,
                descricao VARCHAR(256) NOT NULL,
                situacao CHAR(1) NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                observacao VARCHAR(5012) NOT NULL,
                CONSTRAINT solicitacaosupitemsubcategoria_pk PRIMARY KEY (idSolicitacaoSupItemSubCategoria)
);


ALTER SEQUENCE seq_idsolicitacaosupitemsubcategoria OWNED BY SolicitacaoSupItemSubCategoria.idSolicitacaoSupItemSubCategoria;

CREATE SEQUENCE seq_idsolicitacaosuprimentoetapa;

CREATE TABLE SolicitacaoSuprimentoEtapa (
                idSolicitacaoSuprimentoEtapa INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimentoetapa'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) NOT NULL,
                idSolicitacaoSuprimentoTipoEtapa INTEGER,
                idSolicitacaoSuprimentoCategoria INTEGER,
                apelidoTarefa VARCHAR(255),
                ordemEtapa INTEGER NOT NULL,
                hierarquia CHAR(1),
                CONSTRAINT solicitacaosuprimentoetapa_pk PRIMARY KEY (idSolicitacaoSuprimentoEtapa)
);
COMMENT ON TABLE SolicitacaoSuprimentoEtapa IS 'Etapas da solicitação: Cadastro, Ciencia do Gestor, Cotação, Aprovação Gestor, Controladoria, Aprovação Gestor Financeiro, Pedido de Compra. ';
COMMENT ON COLUMN SolicitacaoSuprimentoEtapa.idSolicitacaoSuprimentoCategoria IS 'Quando aplicavél a uma categoria especifica. ';
COMMENT ON COLUMN SolicitacaoSuprimentoEtapa.apelidoTarefa IS 'Apelido da Tarefa que será identificada como tarefa da etapa.';
COMMENT ON COLUMN SolicitacaoSuprimentoEtapa.ordemEtapa IS 'Sequencia que a Etapa deverá seguir como fluxo adotado pelo cliete. ';
COMMENT ON COLUMN SolicitacaoSuprimentoEtapa.hierarquia IS 'flag para identificar etapa onde ocorre a hierarquia de aprovação';


ALTER SEQUENCE seq_idsolicitacaosuprimentoetapa OWNED BY SolicitacaoSuprimentoEtapa.idSolicitacaoSuprimentoEtapa;

CREATE TABLE ItMarca (
                idItMarcaErp VARCHAR(128) NOT NULL,
                descricao VARCHAR(128),
                situacao CHAR(1) NOT NULL,
                CONSTRAINT itmarca_pk PRIMARY KEY (idItMarcaErp)
);


CREATE SEQUENCE seq_idobspredefinida;

CREATE TABLE AgendaObsPredefinida (
                IdObsPredefinida INTEGER NOT NULL DEFAULT nextval('seq_idobspredefinida'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) NOT NULL,
                CONSTRAINT agendaobspredefinida_pk PRIMARY KEY (IdObsPredefinida)
);
COMMENT ON COLUMN AgendaObsPredefinida.situacao IS 'A - Ativo I - Inativo';


ALTER SEQUENCE seq_idobspredefinida OWNED BY AgendaObsPredefinida.IdObsPredefinida;

CREATE SEQUENCE seq_iddepara;

CREATE TABLE dePara (
                idDePara INTEGER NOT NULL DEFAULT nextval('seq_iddepara'),
                chaveDado VARCHAR(255) NOT NULL,
                dadoOrigem VARCHAR(255) NOT NULL,
                descricaoOrigem VARCHAR(255),
                dadoDestino VARCHAR(255) NOT NULL,
                descricaoDestino VARCHAR(255),
                tipoDadoOrigem VARCHAR(10),
                tipoDadoDestino VARCHAR(10),
                sistemaOrigem VARCHAR(255),
                sistemaDestino VARCHAR(255),
                CONSTRAINT depara_pk PRIMARY KEY (idDePara)
);
COMMENT ON TABLE dePara IS 'Tabela geral de deParas entre sistemas. ';
COMMENT ON COLUMN dePara.chaveDado IS 'Identificação do dado, exemplo: FUNCAOCOLABORADOR,  IDPRODUTOSITE';
COMMENT ON COLUMN dePara.dadoOrigem IS 'Ex. DESCRICAO DA FUNCAO NO ERP  VENDEDOR ';
COMMENT ON COLUMN dePara.dadoDestino IS 'Exemplo, Código 10 de Vendedor no Bridge. ';
COMMENT ON COLUMN dePara.tipoDadoOrigem IS 'S - String N - Numerico  D - Data ';
COMMENT ON COLUMN dePara.tipoDadoDestino IS 'S - String N - Numerico  D - Data ';
COMMENT ON COLUMN dePara.sistemaOrigem IS 'Ex. Winthor';
COMMENT ON COLUMN dePara.sistemaDestino IS 'Ex. Observador ';


ALTER SEQUENCE seq_iddepara OWNED BY dePara.idDePara;

CREATE SEQUENCE seq_idrefcadastro;

CREATE TABLE RefCadastro (
                idRefCadastro INTEGER NOT NULL DEFAULT nextval('seq_idrefcadastro'),
                descricao VARCHAR(255) NOT NULL,
                valorRefeicao NUMERIC(15,2),
                CONSTRAINT refcadastro_pk PRIMARY KEY (idRefCadastro)
);
COMMENT ON TABLE RefCadastro IS 'Cadastro das refeições';
COMMENT ON COLUMN RefCadastro.descricao IS 'Descrição do turno ';
COMMENT ON COLUMN RefCadastro.valorRefeicao IS 'Valor cobrado por refeição';


ALTER SEQUENCE seq_idrefcadastro OWNED BY RefCadastro.idRefCadastro;

CREATE SEQUENCE seq_idrefturno;

CREATE TABLE RefTurno (
                idRefTurno INTEGER NOT NULL DEFAULT nextval('seq_idrefturno'),
                idRefCadastro INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                horaInicial VARCHAR(10) NOT NULL,
                horaFinal VARCHAR(10) NOT NULL,
                quantidadeRefeicaoPorAcesso INTEGER NOT NULL,
                valorRefeicao NUMERIC(15,2),
                CONSTRAINT refturno_pk PRIMARY KEY (idRefTurno)
);
COMMENT ON TABLE RefTurno IS 'Turnos do recurso de refeição';
COMMENT ON COLUMN RefTurno.descricao IS 'Descrição do turno ';
COMMENT ON COLUMN RefTurno.horaInicial IS 'Hora inicial do Turno';
COMMENT ON COLUMN RefTurno.horaFinal IS 'Hora final do turno';
COMMENT ON COLUMN RefTurno.quantidadeRefeicaoPorAcesso IS 'Quantidade de refeições liberadas no turno por acesso.';
COMMENT ON COLUMN RefTurno.valorRefeicao IS 'Valor cobrado por refeição';


ALTER SEQUENCE seq_idrefturno OWNED BY RefTurno.idRefTurno;

CREATE SEQUENCE seq_idpromocaooferta;

CREATE TABLE PromocaoOferta (
                idPromocaoOferta INTEGER NOT NULL DEFAULT nextval('seq_idpromocaooferta'),
                descricao VARCHAR(256) NOT NULL,
                dataInicioPromocao DATE,
                dataFinalPromocao DATE,
                idUsuarioCadastro INTEGER NOT NULL,
                dataCadastro DATE NOT NULL,
                idUsuarioAlteracao INTEGER,
                dataAlteracao DATE,
                situacao VARCHAR(1) NOT NULL,
                CONSTRAINT promocaooferta_pk PRIMARY KEY (idPromocaoOferta)
);
COMMENT ON COLUMN PromocaoOferta.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idpromocaooferta OWNED BY PromocaoOferta.idPromocaoOferta;

CREATE INDEX promocaooferta_idx_datainio_datafinal
 ON PromocaoOferta
 ( dataInicioPromocao, dataFinalPromocao );

CREATE SEQUENCE seq_idbandeiraadministradora;

CREATE TABLE BandeiraAdministradora (
                idBandeiraAdministradora INTEGER NOT NULL DEFAULT nextval('seq_idbandeiraadministradora'),
                descricao VARCHAR(128) NOT NULL,
                CONSTRAINT bandeiraadministradora_pk PRIMARY KEY (idBandeiraAdministradora)
);
COMMENT ON TABLE BandeiraAdministradora IS 'Bandeira de uma administradora';


ALTER SEQUENCE seq_idbandeiraadministradora OWNED BY BandeiraAdministradora.idBandeiraAdministradora;

CREATE SEQUENCE seq_idadministradora;

CREATE TABLE Administradora (
                idAdministradora INTEGER NOT NULL DEFAULT nextval('seq_idadministradora'),
                descricao VARCHAR(128) NOT NULL,
                CONSTRAINT administradora_pk PRIMARY KEY (idAdministradora)
);
COMMENT ON TABLE Administradora IS 'Administradora de Cartão';


ALTER SEQUENCE seq_idadministradora OWNED BY Administradora.idAdministradora;

CREATE SEQUENCE seq_idmetadinamica;

CREATE TABLE MetaDinamica (
                idMetaDinamica INTEGER NOT NULL DEFAULT nextval('seq_idmetadinamica'),
                descricao VARCHAR(256) NOT NULL,
                chave VARCHAR(12345) NOT NULL,
                tipoIntervalo VARCHAR(128) NOT NULL,
                tipoValor VARCHAR(1) DEFAULT 'V' NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(10) NOT NULL,
                idUsuarioAlteracao INTEGER NOT NULL,
                dataAlteracao DATE NOT NULL,
                horaAlteracao VARCHAR(10) NOT NULL,
                CONSTRAINT metadinamica_pk PRIMARY KEY (idMetaDinamica)
);
COMMENT ON TABLE MetaDinamica IS 'Armazena o cabeçalho das metas dinâmicas.';
COMMENT ON COLUMN MetaDinamica.descricao IS 'Descrição sobre a meta.';
COMMENT ON COLUMN MetaDinamica.chave IS 'Transformar em JSONB (BBBB) define-se um array com as chaves que será lançada depois. Ex: ["empresa", "campanhaoferta", "pessoa"]';
COMMENT ON COLUMN MetaDinamica.tipoIntervalo IS 'Nome do atributo da tabela Data.  Ex:   agrupamento diário: = a ddmmaaaa   agrupamento semanal: = a semanaano';
COMMENT ON COLUMN MetaDinamica.tipoValor IS 'V-Valor Absoluto, P-Percentual';


ALTER SEQUENCE seq_idmetadinamica OWNED BY MetaDinamica.idMetaDinamica;

CREATE SEQUENCE seq_idmetadinamicalancamento;

CREATE TABLE MetaDinamicaLancamento (
                idMetaDinamicaLancamento INTEGER NOT NULL DEFAULT nextval('seq_idmetadinamicalancamento'),
                idMetaDinamica INTEGER NOT NULL,
                chave VARCHAR(12345) NOT NULL,
                dataInicial DATE NOT NULL,
                dataFinal DATE NOT NULL,
                valor NUMERIC(15,3) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(10) NOT NULL,
                idUsuarioAlteracao INTEGER NOT NULL,
                dataAlteracao DATE NOT NULL,
                horaAlteracao VARCHAR(10) NOT NULL,
                CONSTRAINT metadinamicalancamento_pk PRIMARY KEY (idMetaDinamicaLancamento)
);
COMMENT ON TABLE MetaDinamicaLancamento IS 'Lançamentos da meta dinâmica.';
COMMENT ON COLUMN MetaDinamicaLancamento.chave IS 'Transformar em JSONB (BBBB) define-se um object com as chaves que será lançada. Ex: {"empresa": 1, "campanhaoferta": 2, "pessoa": 3}';


ALTER SEQUENCE seq_idmetadinamicalancamento OWNED BY MetaDinamicaLancamento.idMetaDinamicaLancamento;

CREATE SEQUENCE seq_idlogacao;

CREATE TABLE LogAcao (
                idLogAcao INTEGER NOT NULL DEFAULT nextval('seq_idlogacao'),
                acao VARCHAR(1) DEFAULT 'A' NOT NULL,
                modulo VARCHAR(128) DEFAULT 'HEAVEN' NOT NULL,
                tabela VARCHAR(128) NOT NULL,
                chave VARCHAR(12345),
                valores VARCHAR(12345) NOT NULL,
                idUsuarioAcao INTEGER NOT NULL,
                dataAcao DATE NOT NULL,
                horaAcao VARCHAR(10) NOT NULL,
                idTarefaOrigem INTEGER,
                idUsuarioEncaminhamento INTEGER,
                dataEncaminhamento DATE,
                horaEncaminhamento VARCHAR(10),
                encaminhamento VARCHAR(1),
                obsEncaminhamento VARCHAR(512),
                CONSTRAINT logacao_pk PRIMARY KEY (idLogAcao)
);
COMMENT ON TABLE LogAcao IS 'Tabela que registra as alterações e exclusões de registros em tabelas do sistema, tanto heaven, quanto centralizador.';
COMMENT ON COLUMN LogAcao.idLogAcao IS 'Código único.';
COMMENT ON COLUMN LogAcao.acao IS 'Ação realizada. A -> Alteração, I -> Inclusão, E -> Exclusão.';
COMMENT ON COLUMN LogAcao.modulo IS 'Define o modulo da qual está sendo alterado a tabela. Ex: HEAVEN, CENTRAL...';
COMMENT ON COLUMN LogAcao.tabela IS 'Nome da tabela que está ocorrendo a alteração. Ex: produto, produtofornecedor, c1produto, c1produtofornecedor';
COMMENT ON COLUMN LogAcao.chave IS 'Define um json de chaves, ex: { idproduto: 1, idfornecedor: 100 } ou { idproduto: 1 }';
COMMENT ON COLUMN LogAcao.valores IS 'Alterar para jsonb. Campo exibe o que foi feito. Ex: { "atual": { "descricao": "Banana KG" }, "novo": { "descricao": "Banana UN" }}';
COMMENT ON COLUMN LogAcao.idUsuarioAcao IS 'Código do usuário que "inseriu" o registro da alteração.';
COMMENT ON COLUMN LogAcao.dataAcao IS 'Data em que "inseriu" o registro da alteração.';
COMMENT ON COLUMN LogAcao.horaAcao IS 'Hora em que "inseriu" o registro da alteração.';
COMMENT ON COLUMN LogAcao.idTarefaOrigem IS 'Id da Tarefa que usuário utilizou para realizar alteração no dado.';
COMMENT ON COLUMN LogAcao.encaminhamento IS 'A-Aprovado  R-Rejeitado ';


ALTER SEQUENCE seq_idlogacao OWNED BY LogAcao.idLogAcao;

CREATE INDEX logacao_modulo_tabela_acao_idx
 ON LogAcao
 ( modulo, tabela, acao );

CREATE INDEX logacao_modulo_tabela_idx
 ON LogAcao
 ( modulo, tabela );

CREATE INDEX logacao_tabela_idx
 ON LogAcao
 ( tabela );

CREATE SEQUENCE seq_idtextoformatado;

CREATE TABLE TextoFormatado (
                idTextoFormatado INTEGER NOT NULL DEFAULT nextval('seq_idtextoformatado'),
                descricao VARCHAR(1024) NOT NULL,
                chave VARCHAR(256) NOT NULL,
                textoFormatado VARCHAR(1) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(10) NOT NULL,
                idUsuarioAlteracao INTEGER NOT NULL,
                dataAlteracao DATE NOT NULL,
                horaAlteracao VARCHAR(10) NOT NULL,
                CONSTRAINT textoformatado_pk PRIMARY KEY (idTextoFormatado)
);
COMMENT ON COLUMN TextoFormatado.descricao IS 'Descrição sobre o texto formatado que será criado. Ex: Politica de Privacidade Fale Conosco';
COMMENT ON COLUMN TextoFormatado.chave IS 'Chave para identificar e localizar o texto formatado nas tarefas. Ex: POLITICA_PRIVACIDADE_INTEGRACAO_FALE_CONOSCO';
COMMENT ON COLUMN TextoFormatado.textoFormatado IS 'O texto formatado em si, no formato html. Alterar o script do postgres para gerar como text type.';


ALTER SEQUENCE seq_idtextoformatado OWNED BY TextoFormatado.idTextoFormatado;

CREATE TABLE itTabelaPreco (
                idItTabelaPrecoErp VARCHAR(128) NOT NULL,
                descricao VARCHAR(128),
                situacao CHAR(1) NOT NULL,
                CONSTRAINT ittabelapreco_pk PRIMARY KEY (idItTabelaPrecoErp)
);


CREATE TABLE RecursoTipo (
                idRecursoTipo VARCHAR(128) NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                sql VARCHAR(4096) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                propriedades VARCHAR(12345) NOT NULL,
                CONSTRAINT recursotipo_pk PRIMARY KEY (idRecursoTipo)
);
COMMENT ON COLUMN RecursoTipo.situacao IS 'A-Ativo,I-Inativo';


CREATE SEQUENCE seq_idintegracaoterceiro;

CREATE TABLE IntegracaoTerceiro (
                idIntegracaoTerceiro INTEGER NOT NULL DEFAULT nextval('seq_idintegracaoterceiro'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) NOT NULL,
                dataInclusao DATE NOT NULL,
                dataAlteracao DATE NOT NULL,
                CONSTRAINT integracaoterceiro_pk PRIMARY KEY (idIntegracaoTerceiro)
);
COMMENT ON COLUMN IntegracaoTerceiro.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idintegracaoterceiro OWNED BY IntegracaoTerceiro.idIntegracaoTerceiro;

CREATE SEQUENCE seq_idfluxogrupotipo;

CREATE TABLE FluxoGrupoTipo (
                idFluxoGrupoTipo INTEGER NOT NULL DEFAULT nextval('seq_idfluxogrupotipo'),
                descricao VARCHAR(2048) NOT NULL,
                tipoMovimento VARCHAR(1),
                ordemApresentacao INTEGER,
                situacao VARCHAR(1) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(5) NOT NULL,
                idUsuarioAlteracao INTEGER NOT NULL,
                dataAlteracao DATE NOT NULL,
                horaAlteracao VARCHAR(5) NOT NULL,
                CONSTRAINT fluxogrupotipo_pk PRIMARY KEY (idFluxoGrupoTipo)
);
COMMENT ON COLUMN FluxoGrupoTipo.descricao IS 'Descrição do Tipo do Fluxo (Disponivel, entrada, saida...)';
COMMENT ON COLUMN FluxoGrupoTipo.tipoMovimento IS 'Tipo de Movimento (E-ntrada | S-aída)';
COMMENT ON COLUMN FluxoGrupoTipo.ordemApresentacao IS 'Ordem em que deverá ser exibido';
COMMENT ON COLUMN FluxoGrupoTipo.situacao IS 'A-tivo | I-nativo';
COMMENT ON COLUMN FluxoGrupoTipo.idUsuarioInclusao IS 'Código do usuário que criou o registro.';
COMMENT ON COLUMN FluxoGrupoTipo.dataInclusao IS 'Data da criação do registro.';
COMMENT ON COLUMN FluxoGrupoTipo.horaInclusao IS 'Hora em que o registro foi criado';
COMMENT ON COLUMN FluxoGrupoTipo.idUsuarioAlteracao IS 'Código do usuário que realizou a última alteração.';
COMMENT ON COLUMN FluxoGrupoTipo.dataAlteracao IS 'Data da última alteração';
COMMENT ON COLUMN FluxoGrupoTipo.horaAlteracao IS 'Hora da ultima atuaçlizacao do registro';


ALTER SEQUENCE seq_idfluxogrupotipo OWNED BY FluxoGrupoTipo.idFluxoGrupoTipo;

CREATE SEQUENCE seq_idagendaatendimentofornecedorpre;

CREATE TABLE AgendaAtendimentoFornecedorPre (
                idAgendaAtendimentoFornecedorPre INTEGER NOT NULL DEFAULT nextval('seq_idagendaatendimentofornecedorpre'),
                dataAgendamento DATE NOT NULL,
                horaAgendamento VARCHAR(8) NOT NULL,
                usuario VARCHAR(128) NOT NULL,
                situacao CHAR(1) DEFAULT 'P' NOT NULL,
                nome VARCHAR(256),
                cnpj VARCHAR(20),
                email VARCHAR(256),
                telefone VARCHAR(20),
                observacao VARCHAR(1024),
                origem VARCHAR(128) DEFAULT 'OBSERVADOR' NOT NULL,
                valores VARCHAR(12345),
                CONSTRAINT agendaatendimentofornecedorpre_pk PRIMARY KEY (idAgendaAtendimentoFornecedorPre)
);
COMMENT ON COLUMN AgendaAtendimentoFornecedorPre.situacao IS 'P -> Pendente | C -> Cancelado | I -> Importado/Integrado ';
COMMENT ON COLUMN AgendaAtendimentoFornecedorPre.origem IS 'Origem do Pré Agendamento. Ex: PIGEON | OBSERVADOR | FORNECEDOR...';
COMMENT ON COLUMN AgendaAtendimentoFornecedorPre.valores IS 'Valores diversos em formato JSON';


ALTER SEQUENCE seq_idagendaatendimentofornecedorpre OWNED BY AgendaAtendimentoFornecedorPre.idAgendaAtendimentoFornecedorPre;

CREATE SEQUENCE seq_iddemonstrativo;

CREATE TABLE Demonstrativo (
                idDemonstrativo INTEGER NOT NULL DEFAULT nextval('seq_iddemonstrativo'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1),
                dataCadastro DATE NOT NULL,
                idUsuarioCadastro INTEGER NOT NULL,
                idDemonstrativoConfigCabecalho INTEGER,
                CONSTRAINT demonstrativo_pk PRIMARY KEY (idDemonstrativo)
);
COMMENT ON TABLE Demonstrativo IS 'Demonstrativos de resultados como DRE. ';
COMMENT ON COLUMN Demonstrativo.situacao IS 'A-Ativo I-Inativo O-Oculto';
COMMENT ON COLUMN Demonstrativo.idDemonstrativoConfigCabecalho IS 'Demonstrativo que deverá ser apresentado no cabeçalho da planilha como resultado "final"';


ALTER SEQUENCE seq_iddemonstrativo OWNED BY Demonstrativo.idDemonstrativo;

CREATE SEQUENCE seq_iddemonstrativoconfig;

CREATE TABLE DemonstrativoConfig (
                idDemonstrativoConfig INTEGER NOT NULL DEFAULT nextval('seq_iddemonstrativoconfig'),
                idDemonstrativo INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1),
                dataCadastro DATE NOT NULL,
                idUsuarioCadastro INTEGER NOT NULL,
                idDemonstrativoConfigPai INTEGER,
                tipoFormula CHAR(1) NOT NULL,
                idDemonstrativoConfigAV INTEGER,
                formula VARCHAR(32768),
                ordemProcessamento INTEGER,
                ordemVisualizacao VARCHAR(16),
                considerar CHAR(1) DEFAULT 'S' NOT NULL,
                inverterSinal CHAR(1) DEFAULT 'N' NOT NULL,
                CONSTRAINT demonstrativoconfig_pk PRIMARY KEY (idDemonstrativoConfig)
);
COMMENT ON TABLE DemonstrativoConfig IS 'Configuração de como o demonstrativo deverá ser. ';
COMMENT ON COLUMN DemonstrativoConfig.descricao IS 'Descrição do Agrupamento do Demonstrativo. ';
COMMENT ON COLUMN DemonstrativoConfig.situacao IS 'A-Ativo I-Inativo O-Oculto';
COMMENT ON COLUMN DemonstrativoConfig.tipoFormula IS 'S-Sql, F-Fórmula, V-Valor fixo';
COMMENT ON COLUMN DemonstrativoConfig.idDemonstrativoConfigAV IS 'Demonstrativo config que deve ser considerado no calculo de % (AV) Mod: Demonstrativo / Demonstrativo AV';
COMMENT ON COLUMN DemonstrativoConfig.formula IS 'Conterá sqls ou fórmulas apontando para calculos especificos. ';
COMMENT ON COLUMN DemonstrativoConfig.ordemProcessamento IS 'Ordem em que a conta deverá ser processada, considerando situações onde ela precisa rodar antes para ser utilizada em fórmula de outras configurações.';
COMMENT ON COLUMN DemonstrativoConfig.ordemVisualizacao IS 'Ordem em que a conta será apresentada nas análises.';
COMMENT ON COLUMN DemonstrativoConfig.considerar IS 'Flag que identifica se o valor do demonstrativo deve ser considerado no calculo geral ou apenas para visualização S - Sim N - Não';
COMMENT ON COLUMN DemonstrativoConfig.inverterSinal IS 'S-Sim, N-Não';


ALTER SEQUENCE seq_iddemonstrativoconfig OWNED BY DemonstrativoConfig.idDemonstrativoConfig;

CREATE SEQUENCE seq_idwfinput;

CREATE TABLE WFInput (
                idWFInput INTEGER NOT NULL DEFAULT nextval('seq_idwfinput'),
                label VARCHAR(255) NOT NULL,
                tipo VARCHAR(50) NOT NULL,
                limite INTEGER,
                input VARCHAR(50) NOT NULL,
                situacao CHAR(1) NOT NULL,
                valorDefault VARCHAR(255),
                CONSTRAINT wfinput_pk PRIMARY KEY (idWFInput)
);


ALTER SEQUENCE seq_idwfinput OWNED BY WFInput.idWFInput;

CREATE SEQUENCE seq_idwfcoluna;

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
);


ALTER SEQUENCE seq_idwfcoluna OWNED BY WFColuna.idWFColuna;

CREATE SEQUENCE seq_identidadetipo;

CREATE TABLE EntidadeTipo (
                idEntidadeTipo INTEGER NOT NULL DEFAULT nextval('seq_identidadetipo'),
                chave VARCHAR(255) NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                modulo VARCHAR(128) NOT NULL,
                situacao CHAR(1),
                CONSTRAINT entidadetipo_pk PRIMARY KEY (idEntidadeTipo)
);
COMMENT ON TABLE EntidadeTipo IS 'Tabela mae.';
COMMENT ON COLUMN EntidadeTipo.modulo IS 'Identificacao ref. qual módulo é a entidade. Ex. HEAVEN...';
COMMENT ON COLUMN EntidadeTipo.situacao IS 'A-Ativo, I-Inativo. ';


ALTER SEQUENCE seq_identidadetipo OWNED BY EntidadeTipo.idEntidadeTipo;

CREATE INDEX entidadetipo_idx_chave
 ON EntidadeTipo
 ( chave );

CREATE TABLE EntidadeTipoMetaDinamica (
                idEntidadeTipo INTEGER NOT NULL,
                idMetaDinamica INTEGER NOT NULL,
                CONSTRAINT entidadetipometadinamica_pk PRIMARY KEY (idEntidadeTipo, idMetaDinamica)
);


CREATE SEQUENCE seq_identidadetipocampo;

CREATE TABLE EntidadeTipoCampo (
                idEntidadeTipoCampo INTEGER NOT NULL DEFAULT nextval('seq_identidadetipocampo'),
                idEntidadeTipo INTEGER NOT NULL,
                nome VARCHAR(255) NOT NULL,
                tipo VARCHAR(255) NOT NULL,
                tamanho NUMERIC(15,3) NOT NULL,
                mascara VARCHAR(255),
                rotulo VARCHAR(255) NOT NULL,
                ordem INTEGER,
                situacao CHAR(1),
                CONSTRAINT entidadetipocampo_pk PRIMARY KEY (idEntidadeTipoCampo)
);
COMMENT ON COLUMN EntidadeTipoCampo.tipo IS 'Identifica o tipo do Campo padrão Sql.  Varchar, Integer, etc..';
COMMENT ON COLUMN EntidadeTipoCampo.mascara IS 'Ex. ###.###,##, ###.###.###-##, ##';
COMMENT ON COLUMN EntidadeTipoCampo.ordem IS 'Ordem sequencial dos campos. ';
COMMENT ON COLUMN EntidadeTipoCampo.situacao IS 'A-Ativo, I-Inativo. ';


ALTER SEQUENCE seq_identidadetipocampo OWNED BY EntidadeTipoCampo.idEntidadeTipoCampo;

CREATE SEQUENCE seq_identidaderegistro;

CREATE TABLE EntidadeRegistro (
                idEntidadeRegistro INTEGER NOT NULL DEFAULT nextval('seq_identidaderegistro'),
                idEntidadeTipo INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                valor VARCHAR(12345) NOT NULL,
                situacao CHAR(1),
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                CONSTRAINT entidaderegistro_pk PRIMARY KEY (idEntidadeRegistro)
);
COMMENT ON COLUMN EntidadeRegistro.valor IS 'Campo JSON, para armazenar valores dinamicos. ';
COMMENT ON COLUMN EntidadeRegistro.situacao IS 'A-Ativo, I-Inativo. ';


ALTER SEQUENCE seq_identidaderegistro OWNED BY EntidadeRegistro.idEntidadeRegistro;

CREATE SEQUENCE seq_idvalepresente;

CREATE TABLE ValePresente (
                idValePresente INTEGER NOT NULL DEFAULT nextval('seq_idvalepresente'),
                idEntidadeRegistroTipo INTEGER NOT NULL,
                identificacao VARCHAR(128) NOT NULL,
                valorUnitario NUMERIC(15,2) NOT NULL,
                tipoValor VARCHAR(1) DEFAULT 'V' NOT NULL,
                valor NUMERIC(15,2) NOT NULL,
                CONSTRAINT valepresente_pk PRIMARY KEY (idValePresente)
);
COMMENT ON COLUMN ValePresente.idEntidadeRegistroTipo IS 'Tipo de Vale Presente. Ex: NATAL, DOAÇÃO, PRESENTE, ETC...';
COMMENT ON COLUMN ValePresente.identificacao IS 'Identificação do Vale Presente, podendo ser um HASH, inteiro, texto, etc...';
COMMENT ON COLUMN ValePresente.valorUnitario IS 'Preço do Vale (valor de compra, ou seja, valor que o cliente vai pagar para adquirir o mesmo)';
COMMENT ON COLUMN ValePresente.tipoValor IS 'V-Valor, P-Percentual. Qual o tipo de "desconto" que será aplicado com o vale.';


ALTER SEQUENCE seq_idvalepresente OWNED BY ValePresente.idValePresente;

CREATE SEQUENCE seq_idcontacorrentepessoa;

CREATE TABLE ContaCorrentePessoa (
                idContaCorrentePessoa INTEGER NOT NULL DEFAULT nextval('seq_idcontacorrentepessoa'),
                idEntidadeRegistroPessoa INTEGER NOT NULL,
                idEntidadeRegistroTipoContaCorrente INTEGER NOT NULL,
                dataMovimento DATE NOT NULL,
                valor NUMERIC(15,2) NOT NULL,
                tipoLancamento CHAR(1) NOT NULL,
                observacao VARCHAR(255),
                dataLancamento DATE NOT NULL,
                horaLancamento VARCHAR(10) NOT NULL,
                idUsuarioLancamento INTEGER NOT NULL,
                CONSTRAINT contacorrentepessoa_pk PRIMARY KEY (idContaCorrentePessoa)
);
COMMENT ON COLUMN ContaCorrentePessoa.idEntidadeRegistroPessoa IS 'Define a pessoa a qual pertence o lançamento. Obs: caso desejar usar tabela "pessoa", usar ETL para popular tabela entidaderegistro.';
COMMENT ON COLUMN ContaCorrentePessoa.idEntidadeRegistroTipoContaCorrente IS 'DINHEIRO, CHEQUE, BONIFICACAO, OUTROS';
COMMENT ON COLUMN ContaCorrentePessoa.tipoLancamento IS 'D-Débito, C-Crédito';


ALTER SEQUENCE seq_idcontacorrentepessoa OWNED BY ContaCorrentePessoa.idContaCorrentePessoa;

CREATE SEQUENCE seq_idjornadatrabalho;

CREATE TABLE JornadaTrabalho (
                idJornadaTrabalho INTEGER NOT NULL DEFAULT nextval('seq_idjornadatrabalho'),
                descricao VARCHAR(255) NOT NULL,
                dataInclusao DATE NOT NULL,
                intervaloflexivel CHAR(1),
                tipojornada CHAR(1) DEFAULT 'C',
                idUsuarioInclusao INTEGER,
                horaInclusao VARCHAR(8) NOT NULL,
                CONSTRAINT jornadatrabalho_pk PRIMARY KEY (idJornadaTrabalho)
);
COMMENT ON TABLE JornadaTrabalho IS 'Jornada de trabalho de Colaboradores.  Ex:  Entrada as 8:30 sai as 12:00 hs. ';
COMMENT ON COLUMN JornadaTrabalho.tipojornada IS 'E - Empresa C - Colaborador F - Descarga Fornecedor';


ALTER SEQUENCE seq_idjornadatrabalho OWNED BY JornadaTrabalho.idJornadaTrabalho;

CREATE SEQUENCE seq_idagenda;

CREATE TABLE Agenda (
                idAgenda INTEGER NOT NULL DEFAULT nextval('seq_idagenda'),
                idJornadaTrabalho INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                situacao VARCHAR(1) DEFAULT 'A' NOT NULL,
                tipoAgenda VARCHAR(10) NOT NULL,
                CONSTRAINT agenda_pk PRIMARY KEY (idAgenda)
);
COMMENT ON TABLE Agenda IS 'Define a agenda e a forma de utilização. Inicialmente utilizado no recurso de retirada de pedido em balcão por meio de agendamento do cliente.';
COMMENT ON COLUMN Agenda.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN Agenda.tipoAgenda IS 'Tipo da Agenda. Ex: E -> Empresa, C -> Colaborador, PC -> Pedido de Compra, VD -> Venda, P -> Produto, etc...';


ALTER SEQUENCE seq_idagenda OWNED BY Agenda.idAgenda;

CREATE SEQUENCE seq_idagendaentidade;

CREATE TABLE AgendaEntidade (
                idAgendaEntidade INTEGER NOT NULL DEFAULT nextval('seq_idagendaentidade'),
                idAgenda INTEGER NOT NULL,
                idEntidade VARCHAR(128) NOT NULL,
                valores VARCHAR(12345),
                quantidade NUMERIC(15,2),
                email VARCHAR(255),
                telefone VARCHAR(255),
                dataInclusao DATE DEFAULT current_date NOT NULL,
                horaInclusao VARCHAR(10) DEFAULT cast(current_time as varchar(10)) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                CONSTRAINT agendaentidade_pk PRIMARY KEY (idAgendaEntidade)
);
COMMENT ON TABLE AgendaEntidade IS 'Armazena os registros utilizados para gerar o agendamento. Ex: vendas, colaboradores, clientes, produtos, etc...';
COMMENT ON COLUMN AgendaEntidade.idEntidade IS 'Código da entidade para vincular com um determinado recurso. Ex: entidade "E" id "1" (empresa 1). entidade "PC" id "10001" (pedido de compra 10001.';
COMMENT ON COLUMN AgendaEntidade.valores IS 'Alterar para JSONB. Armazena os dados do registro atual que será vinculado ao agendamento. Ex: { "idempresa": 1, "idcliente": 2, "datavenda": "2022-01-01", "quantidade": 10, "valor": 200 } (Vai depender do tipoEntidade da tabela Agenda)';
COMMENT ON COLUMN AgendaEntidade.quantidade IS 'Quantidade utilizada para definir a regra da agenda (carenciaQuantidadeInicial e carenciaQuantidadeFinal)';
COMMENT ON COLUMN AgendaEntidade.email IS 'E-mail, utilizado para notificação';
COMMENT ON COLUMN AgendaEntidade.telefone IS 'Telefone, utilizado para notificação';


ALTER SEQUENCE seq_idagendaentidade OWNED BY AgendaEntidade.idAgendaEntidade;

CREATE SEQUENCE seq_idagendaentidadenotificacao;

CREATE TABLE AgendaEntidadeNotificacao (
                idAgendaEntidadeNotificacao INTEGER NOT NULL DEFAULT nextval('seq_idagendaentidadenotificacao'),
                idAgendaEntidade INTEGER NOT NULL,
                dataNotificacao DATE NOT NULL,
                horaNotificacao VARCHAR(10) NOT NULL,
                tipoNotificacao VARCHAR(128) NOT NULL,
                idTarefaExecucao INTEGER NOT NULL,
                CONSTRAINT agendaentidadenotificacao_pk PRIMARY KEY (idAgendaEntidadeNotificacao)
);
COMMENT ON TABLE AgendaEntidadeNotificacao IS 'Define as notificações dos registros (valor).';
COMMENT ON COLUMN AgendaEntidadeNotificacao.tipoNotificacao IS 'A chave para identificar a notificação enviada. Ex: na agenda de retirada de pedido em balcão, pode definir como SOLICITACAO_AGENDAMENTO ("Cliente XYZ, favor informar data e hora que..."), FINALIZACAO_AGENDAMENTO ("Cliente retirou o Pedido")';
COMMENT ON COLUMN AgendaEntidadeNotificacao.idTarefaExecucao IS 'Código da Tarefa Execução para buscar o conteúdo/anexos se necessário validar.';


ALTER SEQUENCE seq_idagendaentidadenotificacao OWNED BY AgendaEntidadeNotificacao.idAgendaEntidadeNotificacao;

CREATE SEQUENCE seq_idagendaagendamento;

CREATE TABLE AgendaAgendamento (
                idAgendaAgendamento INTEGER NOT NULL DEFAULT nextval('seq_idagendaagendamento'),
                idAgendaEntidade INTEGER NOT NULL,
                dataAgenda DATE NOT NULL,
                horaAgenda VARCHAR(10) NOT NULL,
                situacao VARCHAR(1) DEFAULT 'P' NOT NULL,
                dataSituacao DATE NOT NULL,
                horaSituacao VARCHAR(10) NOT NULL,
                dataInclusao DATE DEFAULT current_date NOT NULL,
                horaInclusao VARCHAR(10) DEFAULT cast(current_time as varchar(10)) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                CONSTRAINT agendaagendamento_pk PRIMARY KEY (idAgendaAgendamento)
);
COMMENT ON TABLE AgendaAgendamento IS 'Define os agendamentos da agenda com base nas regras geradas e a jornada definida.';
COMMENT ON COLUMN AgendaAgendamento.situacao IS 'Situação da Agenda. Ex: P -> Pendente, A -> Aceitada/Confirmada, C -> Cancelada, R -> Realizada';


ALTER SEQUENCE seq_idagendaagendamento OWNED BY AgendaAgendamento.idAgendaAgendamento;

CREATE SEQUENCE seq_idagendaregra;

CREATE TABLE AgendaRegra (
                idAgendaRegra INTEGER NOT NULL DEFAULT nextval('seq_idagendaregra'),
                idAgenda INTEGER NOT NULL,
                carenciaTempo INTEGER,
                carenciaQuantidadeInicial NUMERIC(15,2),
                carenciaQuantidadeFinal NUMERIC(15,2),
                janelaHoraInicial VARCHAR(10),
                janelaHoraFinal VARCHAR(10),
                janelaEntrePeriodo INTEGER,
                janelaQuantidadeAgendamento INTEGER,
                CONSTRAINT agendaregra_pk PRIMARY KEY (idAgendaRegra)
);
COMMENT ON TABLE AgendaRegra IS 'Regras para definir o agendamento de uma determinada agenda.';
COMMENT ON COLUMN AgendaRegra.carenciaTempo IS 'Carência em minutos para criar o agendamento da agenda com base no campo quantidade inicial e final.';
COMMENT ON COLUMN AgendaRegra.carenciaQuantidadeInicial IS 'Quantidade inicial de um determinado campo para definir a carencia. Ex: Inicial 0 Final 10 Carencia 30 minutos. ou então peso inicial de 99.99 e final 999.99 carência 60 min.';
COMMENT ON COLUMN AgendaRegra.carenciaQuantidadeFinal IS 'Quantidade final de um determinado campo para definir a carencia. Ex: Inicial 0 Final 10 Carencia 30 minutos. ou então peso inicial de 99.99 e final 999.99 carência 60 min.';
COMMENT ON COLUMN AgendaRegra.janelaHoraInicial IS 'Define o horário inicial ao qual será considerado a regra de janela. Ex: 08:00';
COMMENT ON COLUMN AgendaRegra.janelaHoraFinal IS 'Define o horário final ao qual será considerado a regra de janela. Ex: 12:00';
COMMENT ON COLUMN AgendaRegra.janelaEntrePeriodo IS 'Define em minutos a janela entre os períodos da jornada da agenda. Ex: 20 minutos, em uma jornada das 08:00 as 12:00, os agendamentos serão definidos da seguinte forma: 08:00, 08:20, 08:40...';
COMMENT ON COLUMN AgendaRegra.janelaQuantidadeAgendamento IS 'Quantidade máxima de agendamento por janela. Ex: 10 a cada 20 minutos.';


ALTER SEQUENCE seq_idagendaregra OWNED BY AgendaRegra.idAgendaRegra;

CREATE SEQUENCE seq_idusojornadadia;

CREATE TABLE UsoJornadaDia (
                idUsoJornadaDia INTEGER NOT NULL DEFAULT nextval('seq_idusojornadadia'),
                chave VARCHAR(128) NOT NULL,
                tipoUso VARCHAR(128) NOT NULL,
                ddmmaaaa DATE NOT NULL,
                idJornadaTrabalho INTEGER NOT NULL,
                CONSTRAINT usojornadadia_pk PRIMARY KEY (idUsoJornadaDia)
);
COMMENT ON COLUMN UsoJornadaDia.chave IS 'Código da entidade de uso, as vezes código da empresa, código do setor de trabalho, da área da Empresa';
COMMENT ON COLUMN UsoJornadaDia.tipoUso IS 'Tipo do Uso: E-Empresa, D-Departamento';


ALTER SEQUENCE seq_idusojornadadia OWNED BY UsoJornadaDia.idUsoJornadaDia;

CREATE SEQUENCE seq_idusojornada;

CREATE TABLE UsoJornada (
                idUsoJornada INTEGER NOT NULL DEFAULT nextval('seq_idusojornada'),
                chave VARCHAR(128) NOT NULL,
                tipoUso VARCHAR(128) NOT NULL,
                idJornadaTrabalho INTEGER NOT NULL,
                CONSTRAINT usojornada_pk PRIMARY KEY (idUsoJornada)
);
COMMENT ON COLUMN UsoJornada.chave IS 'Código da entidade de uso, as vezes código da empresa, código do setor de trabalho, da área da Empresa';
COMMENT ON COLUMN UsoJornada.tipoUso IS 'Tipo do Uso: E-Empresa, D-Departamento';


ALTER SEQUENCE seq_idusojornada OWNED BY UsoJornada.idUsoJornada;

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
);
COMMENT ON TABLE JornadaTrabalhoPeriodo IS 'O periodo ou Semana não informado, será considerado como descanso. ';
COMMENT ON COLUMN JornadaTrabalhoPeriodo.diaSemana IS 'domingo, segunda, terca, quarta, quinta, sexta, sabado';
COMMENT ON COLUMN JornadaTrabalhoPeriodo.periodo IS '1-Manha, 2-Tarde ou 3-Noite.';


CREATE SEQUENCE seq_idpulafila;

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
);
COMMENT ON COLUMN PulaFila.tipo IS 'FC-Frente de Caixa';
COMMENT ON COLUMN PulaFila.exportado IS 'S-Sim, N-Não';


ALTER SEQUENCE seq_idpulafila OWNED BY PulaFila.idPulaFila;

CREATE TABLE PulaFilaItens (
                idPulaFila INTEGER NOT NULL,
                idProduto INTEGER NOT NULL,
                sequenciaProduto INTEGER NOT NULL,
                quantidade NUMERIC(15,3) NOT NULL,
                CONSTRAINT pulafilaitens_pk PRIMARY KEY (idPulaFila, idProduto, sequenciaProduto)
);


CREATE TABLE FormaContato (
                idFormaContato INTEGER NOT NULL,
                idUsuario INTEGER NOT NULL,
                tipo INTEGER NOT NULL,
                destino VARCHAR(4096),
                situacao INTEGER NOT NULL,
                versao INTEGER,
                CONSTRAINT formacontato_pk PRIMARY KEY (idFormaContato)
);


CREATE TABLE GrupoUsuarios (
                idGrupoUsuarios INTEGER NOT NULL,
                descricao VARCHAR(128),
                CONSTRAINT grupousuarios_pk PRIMARY KEY (idGrupoUsuarios)
);


CREATE TABLE CargaEntregaMercadologicoFoto (
                idMercadologico INTEGER NOT NULL,
                tipoMercadologico CHAR(1) NOT NULL,
                numMinimoFotos INTEGER DEFAULT 0 NOT NULL,
                numMaximoFotos INTEGER DEFAULT 0 NOT NULL,
                CONSTRAINT cargaentregamercadologicofoto_pk PRIMARY KEY (idMercadologico, tipoMercadologico)
);
COMMENT ON COLUMN CargaEntregaMercadologicoFoto.tipoMercadologico IS 'D-Departamento,S-Setor,G-Grupo,F-Familia,U-Subfamilia,P-Produto';


CREATE SEQUENCE seq_idcargaentregamotivoretorno;

CREATE TABLE CargaEntregaMotivoRetorno (
                idCargaEntregaMotivoRetorno INTEGER NOT NULL DEFAULT nextval('seq_idcargaentregamotivoretorno'),
                descricao VARCHAR(255) NOT NULL,
                requerObservacao CHAR(1) DEFAULT 'N' NOT NULL,
                requerFoto CHAR(1) DEFAULT 'N' NOT NULL,
                requerDescricaoFoto CHAR(1) DEFAULT 'N' NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                CONSTRAINT cargaentregamotivoretorno_pk PRIMARY KEY (idCargaEntregaMotivoRetorno)
);
COMMENT ON COLUMN CargaEntregaMotivoRetorno.requerObservacao IS 'S-Sim, N-Não';
COMMENT ON COLUMN CargaEntregaMotivoRetorno.requerFoto IS 'S-Sim, N-Não';
COMMENT ON COLUMN CargaEntregaMotivoRetorno.requerDescricaoFoto IS 'S-Sim, N-Não';
COMMENT ON COLUMN CargaEntregaMotivoRetorno.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idcargaentregamotivoretorno OWNED BY CargaEntregaMotivoRetorno.idCargaEntregaMotivoRetorno;

CREATE SEQUENCE seq_idcargaentregaocorrencia;

CREATE TABLE CargaEntregaOcorrencia (
                idCargaEntregaOcorrencia INTEGER NOT NULL DEFAULT nextval('seq_idcargaentregaocorrencia'),
                idCargaEntrega INTEGER NOT NULL,
                idSaidaOrigem VARCHAR(255) NOT NULL,
                dataOcorrencia DATE,
                horaOcorrencia VARCHAR(8),
                observacao VARCHAR(1024),
                latitudeConfirmacaoEntrega NUMERIC(12,6),
                longitudeConfirmacaoEntrega NUMERIC(12,6),
                distanciaConfirmacaoEntrega NUMERIC(12,6),
                idCargaEntregaMotivoRetorno INTEGER,
                CONSTRAINT cargaentregaocorrencia_pk PRIMARY KEY (idCargaEntregaOcorrencia)
);


ALTER SEQUENCE seq_idcargaentregaocorrencia OWNED BY CargaEntregaOcorrencia.idCargaEntregaOcorrencia;

CREATE SEQUENCE seq_idspedreg;

CREATE TABLE sped_reg (
                idSpedReg INTEGER NOT NULL DEFAULT nextval('seq_idspedreg'),
                reg VARCHAR(4) NOT NULL,
                CONSTRAINT sped_reg_pk PRIMARY KEY (idSpedReg)
);


ALTER SEQUENCE seq_idspedreg OWNED BY sped_reg.idSpedReg;

CREATE SEQUENCE seq_idprodutotipo;

CREATE TABLE ProdutoTipo (
                idProdutoTipo INTEGER NOT NULL DEFAULT nextval('seq_idprodutotipo'),
                descricao VARCHAR(155) NOT NULL,
                CONSTRAINT produtotipo_pk PRIMARY KEY (idProdutoTipo)
);
COMMENT ON TABLE ProdutoTipo IS 'Armazena dados de tipos de produtos, podendo ser uma caracteristica especifica do produto como em supermercados: Retalho';


ALTER SEQUENCE seq_idprodutotipo OWNED BY ProdutoTipo.idProdutoTipo;

CREATE SEQUENCE seq_idindicadorgestaovisao;

CREATE TABLE IndicadorGestaoVisao (
                idIndicadorGestaoVisao INTEGER NOT NULL DEFAULT nextval('seq_idindicadorgestaovisao'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1),
                cor VARCHAR(64) NOT NULL,
                icone VARCHAR(32),
                CONSTRAINT indicadorgestaovisao_pk PRIMARY KEY (idIndicadorGestaoVisao)
);
COMMENT ON TABLE IndicadorGestaoVisao IS 'Visões direcionadas para apresentação dos indicadores as pessoas que deverão ter acesso ao mesmos.';
COMMENT ON COLUMN IndicadorGestaoVisao.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN IndicadorGestaoVisao.icone IS 'Armazena o icone que será apresentado nas telas de indicadores. ';


ALTER SEQUENCE seq_idindicadorgestaovisao OWNED BY IndicadorGestaoVisao.idIndicadorGestaoVisao;

CREATE SEQUENCE seq_idindicadorgestaocategoria;

CREATE TABLE IndicadorGestaoCategoria (
                idIndicadorGestaoCategoria INTEGER NOT NULL DEFAULT nextval('seq_idindicadorgestaocategoria'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1),
                CONSTRAINT indicadorgestaocategoria_pk PRIMARY KEY (idIndicadorGestaoCategoria)
);
COMMENT ON TABLE IndicadorGestaoCategoria IS 'Agrupamento dos Indicadores em grupo de Gestão, que chamamos de Categoria do Indicador';
COMMENT ON COLUMN IndicadorGestaoCategoria.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idindicadorgestaocategoria OWNED BY IndicadorGestaoCategoria.idIndicadorGestaoCategoria;

CREATE TABLE EmpresaLigacaoSistema (
                cnpj VARCHAR(14) NOT NULL,
                sistema VARCHAR(255) NOT NULL,
                idEmpresaSistema INTEGER NOT NULL,
                CONSTRAINT empresaligacaosistema_pk PRIMARY KEY (cnpj, sistema, idEmpresaSistema)
);
COMMENT ON TABLE EmpresaLigacaoSistema IS 'Armazena dados de ligação entre os vários Softwares da empresa, ligando os IDs pelos cnpj de cada unidade.';
COMMENT ON COLUMN EmpresaLigacaoSistema.sistema IS 'Nome do Sistema. ';
COMMENT ON COLUMN EmpresaLigacaoSistema.idEmpresaSistema IS 'Id da empresa dentro do banco do Sistema. ';


CREATE SEQUENCE seq_idlogpesquisaremovida;

CREATE TABLE LogPesquisaRemovida (
                idLogPesquisaRemovida INTEGER NOT NULL DEFAULT nextval('seq_idlogpesquisaremovida'),
                idPesquisaPreco INTEGER NOT NULL,
                data DATE NOT NULL,
                hora VARCHAR(8) NOT NULL,
                idUsuario INTEGER,
                dadosPesquisa VARCHAR(12345),
                CONSTRAINT logpesquisaremovida_pk PRIMARY KEY (idLogPesquisaRemovida)
);


ALTER SEQUENCE seq_idlogpesquisaremovida OWNED BY LogPesquisaRemovida.idLogPesquisaRemovida;

CREATE TABLE recursoPerm (
                idRecursoPerm INTEGER NOT NULL,
                idRecurso INTEGER NOT NULL,
                tipoRecurso INTEGER NOT NULL,
                idGrupoUsuario INTEGER NOT NULL,
                tipoGrupoUsuario INTEGER NOT NULL,
                CONSTRAINT recursoperm_pk PRIMARY KEY (idRecursoPerm)
);


CREATE TABLE Processo (
                idProcesso INTEGER NOT NULL,
                descProcesso VARCHAR(255) NOT NULL,
                obs VARCHAR(255) NOT NULL,
                versao INTEGER NOT NULL,
                CONSTRAINT processo_pk PRIMARY KEY (idProcesso)
);


CREATE TABLE Tarefa (
                idTarefa INTEGER NOT NULL,
                idProcesso INTEGER,
                descTarefa VARCHAR(255) NOT NULL,
                apelido VARCHAR(255) NOT NULL,
                codigoTarefa INTEGER NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                CONSTRAINT tarefa_pk PRIMARY KEY (idTarefa)
);
COMMENT ON COLUMN Tarefa.situacao IS 'A-Ativo, I-Inativo';


CREATE INDEX tarefa_idx_apelido
 ON Tarefa
 ( apelido );

CREATE SEQUENCE seq_idcategoriafavorito;

CREATE TABLE CategoriaFavorito (
                idCategoriaFavorito INTEGER NOT NULL DEFAULT nextval('seq_idcategoriafavorito'),
                descricao VARCHAR(255),
                ordem INTEGER NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                icone VARCHAR(32),
                CONSTRAINT categoriafavorito_pk PRIMARY KEY (idCategoriaFavorito)
);
COMMENT ON COLUMN CategoriaFavorito.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idcategoriafavorito OWNED BY CategoriaFavorito.idCategoriaFavorito;

CREATE SEQUENCE seq_idfavorito;

CREATE TABLE Favorito (
                idFavorito INTEGER NOT NULL DEFAULT nextval('seq_idfavorito'),
                idCategoriaFavorito INTEGER NOT NULL,
                idTarefa INTEGER,
                descricao VARCHAR(255),
                ordem INTEGER NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                CONSTRAINT favorito_pk PRIMARY KEY (idFavorito)
);
COMMENT ON COLUMN Favorito.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idfavorito OWNED BY Favorito.idFavorito;

CREATE SEQUENCE seq_entidade_identidade;

CREATE TABLE Entidade (
                idEntidade INTEGER NOT NULL DEFAULT nextval('seq_entidade_identidade'),
                entidade VARCHAR(128) NOT NULL,
                chave VARCHAR(128) NOT NULL,
                chave2 VARCHAR(128),
                chave3 VARCHAR(128),
                descricao VARCHAR(128) NOT NULL,
                valor NUMERIC(18,4),
                texto VARCHAR(128),
                valor2 NUMERIC(18,4),
                texto2 VARCHAR(128),
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                dado VARCHAR(12345),
                CONSTRAINT entidade_pk PRIMARY KEY (idEntidade)
);
COMMENT ON TABLE Entidade IS 'Armazenar dados que não necessitam de uma tabela especificamente.  ';


ALTER SEQUENCE seq_entidade_identidade OWNED BY Entidade.idEntidade;

CREATE TABLE localdescargafornecedor (
                localdescargafornecedor VARCHAR(64) NOT NULL,
                CONSTRAINT localdescargafornecedor_pk PRIMARY KEY (localdescargafornecedor)
);
COMMENT ON TABLE localdescargafornecedor IS 'Tabela fora do padrao. Aproveitado já rodando nos clientes, e migrado para HEAVEN em abril de 2017.';


CREATE TABLE tipoAutorizacaoAgendaAtendimento (
                tipoAutorizacao CHAR(1) NOT NULL,
                descricao CHAR(64) NOT NULL,
                CONSTRAINT tipoautorizacaoagendaatendimento_pk PRIMARY KEY (tipoAutorizacao)
);
COMMENT ON TABLE tipoAutorizacaoAgendaAtendimento IS 'Tabela fora do padrao. Aproveitado já rodando nos clientes, e migrado para HEAVEN em abril de 2017.';


CREATE TABLE AgendaAtendimentoFornecedor (
                dataAgendamento DATE NOT NULL,
                horaAgendamento VARCHAR(8) NOT NULL,
                usuario VARCHAR(128) NOT NULL,
                representante VARCHAR(256),
                idFornecedor INTEGER,
                nome VARCHAR(256),
                cnpj VARCHAR(20),
                email VARCHAR(256),
                situacao CHAR(1) DEFAULT 'P' NOT NULL,
                dataChegada DATE,
                horaChegada VARCHAR(8),
                horaChegadaMilis BIGINT,
                observacao VARCHAR(1024),
                dataSaida DATE,
                horaSaida VARCHAR(8),
                horaAgendamentoFinal VARCHAR(8),
                telefone VARCHAR(20),
                idAgendaAtendimentoFornecedorPre INTEGER,
                valores VARCHAR(12345),
                CONSTRAINT agendaatendimentofornecedor_pk PRIMARY KEY (dataAgendamento, horaAgendamento, usuario)
);
COMMENT ON TABLE AgendaAtendimentoFornecedor IS 'Tabela fora do padrao. Aproveitado já rodando nos clientes, e migrado para HEAVEN em abril de 2017.';
COMMENT ON COLUMN AgendaAtendimentoFornecedor.situacao IS 'P-Pendente, F-Finalizado, C-Cancelado, N-Não  Agendado   ';
COMMENT ON COLUMN AgendaAtendimentoFornecedor.valores IS 'Valores diversos em formato JSON';


CREATE SEQUENCE seq_idagendaatendimentofornecedorchamado;

CREATE TABLE AgendaAtendimentoFornecedorChamado (
                idAgendaAtendimentoFornecedorChamado INTEGER NOT NULL DEFAULT nextval('seq_idagendaatendimentofornecedorchamado'),
                dataAgendamento DATE NOT NULL,
                horaAgendamento VARCHAR(8) NOT NULL,
                usuario VARCHAR(128) NOT NULL,
                dataChamada DATE NOT NULL,
                horaChamada VARCHAR(8),
                horaChamadaMilis BIGINT,
                horaInicioAtendimentoMilis BIGINT,
                horaFinalAtendimentoMilis BIGINT,
                horaInicialAtendimento VARCHAR(8),
                horaFinalAtendimento VARCHAR(8),
                Observacao VARCHAR(1024),
                pedido VARCHAR(1024),
                situacao CHAR(1) DEFAULT 'N',
                CONSTRAINT agendaatendimentofornecedorchamado_pk PRIMARY KEY (idAgendaAtendimentoFornecedorChamado)
);
COMMENT ON COLUMN AgendaAtendimentoFornecedorChamado.dataChamada IS 'Data em que o comprador chamou o vendedor. ';
COMMENT ON COLUMN AgendaAtendimentoFornecedorChamado.pedido IS 'Para inserir um ou mais pedidos fechados no contrato.';
COMMENT ON COLUMN AgendaAtendimentoFornecedorChamado.situacao IS 'N-Normal e C-Cancelado';


ALTER SEQUENCE seq_idagendaatendimentofornecedorchamado OWNED BY AgendaAtendimentoFornecedorChamado.idAgendaAtendimentoFornecedorChamado;

CREATE TABLE AgendaAtendimentoAutorizacao (
                dataAgendamento DATE NOT NULL,
                usuario VARCHAR(128) NOT NULL,
                horaAgendamento VARCHAR(8) NOT NULL,
                tipoAutorizacao CHAR(1) NOT NULL,
                usuarioAutorizado VARCHAR(128) NOT NULL,
                observacao VARCHAR(64) NOT NULL,
                CONSTRAINT agendaatendimentoautorizacao_pk PRIMARY KEY (dataAgendamento, usuario, horaAgendamento, tipoAutorizacao, usuarioAutorizado)
);
COMMENT ON TABLE AgendaAtendimentoAutorizacao IS 'Tabela fora do padrao. Aproveitado já rodando nos clientes, e migrado para HEAVEN em abril de 2017.';


CREATE SEQUENCE seq_idwfprioridade;

CREATE TABLE WFPrioridade (
                idWFPrioridade INTEGER NOT NULL DEFAULT nextval('seq_idwfprioridade'),
                descricao VARCHAR(255),
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                prioridade INTEGER,
                cor CHAR(6),
                CONSTRAINT wfprioridade_pk PRIMARY KEY (idWFPrioridade)
);
COMMENT ON COLUMN WFPrioridade.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN WFPrioridade.prioridade IS 'Valor numérico indicando qual prioridade é maior';
COMMENT ON COLUMN WFPrioridade.cor IS 'valor em hexadecimal';


ALTER SEQUENCE seq_idwfprioridade OWNED BY WFPrioridade.idWFPrioridade;

CREATE SEQUENCE seq_idwfimpacto;

CREATE TABLE WFImpacto (
                idWFImpacto INTEGER NOT NULL DEFAULT nextval('seq_idwfimpacto'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                horaAlteracao VARCHAR(8) NOT NULL,
                dataAlteracao DATE NOT NULL,
                idUsuarioAlteracao INTEGER,
                CONSTRAINT wfimpacto_pk PRIMARY KEY (idWFImpacto)
);
COMMENT ON COLUMN WFImpacto.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idwfimpacto OWNED BY WFImpacto.idWFImpacto;

CREATE SEQUENCE seq_idwfwfcausa;

CREATE TABLE WFCausa (
                idWFCausa INTEGER NOT NULL DEFAULT nextval('seq_idwfwfcausa'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                horaAlteracao VARCHAR(8) NOT NULL,
                dataAlteracao DATE NOT NULL,
                idUsuarioAlteracao INTEGER,
                CONSTRAINT wfcausa_pk PRIMARY KEY (idWFCausa)
);
COMMENT ON COLUMN WFCausa.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idwfwfcausa OWNED BY WFCausa.idWFCausa;

CREATE SEQUENCE seq_portador_idportador;

CREATE TABLE Portador (
                idPortador INTEGER NOT NULL DEFAULT nextval('seq_portador_idportador'),
                descricao VARCHAR(255) NOT NULL,
                CONSTRAINT portador_pk PRIMARY KEY (idPortador)
);
COMMENT ON TABLE Portador IS 'Portador de Documentos. ';


ALTER SEQUENCE seq_portador_idportador OWNED BY Portador.idPortador;

CREATE SEQUENCE seq_idjustificativaprecadastroproduto;

CREATE TABLE JustificativaPreCadastroProduto (
                idJustificativaPreCadastroProduto INTEGER NOT NULL DEFAULT nextval('seq_idjustificativaprecadastroproduto'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                CONSTRAINT justificativaprecadastroproduto_pk PRIMARY KEY (idJustificativaPreCadastroProduto)
);
COMMENT ON COLUMN JustificativaPreCadastroProduto.situacao IS 'A-Ativo,I-Inativo';


ALTER SEQUENCE seq_idjustificativaprecadastroproduto OWNED BY JustificativaPreCadastroProduto.idJustificativaPreCadastroProduto;

CREATE TABLE ncm (
                idNCM VARCHAR(16) NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                CONSTRAINT ncm_pk PRIMARY KEY (idNCM)
);


CREATE SEQUENCE seq_idcaracteristicaprecadastroproduto;

CREATE TABLE CaracteristicaPreCadastroProduto (
                idCaracteristicaPreCadastroProduto INTEGER NOT NULL DEFAULT nextval('seq_idcaracteristicaprecadastroproduto'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                vantagemDesvantagem CHAR(1) NOT NULL,
                CONSTRAINT caracteristicaprecadastroproduto_pk PRIMARY KEY (idCaracteristicaPreCadastroProduto)
);
COMMENT ON COLUMN CaracteristicaPreCadastroProduto.situacao IS 'A-Ativo,I-Inativo';
COMMENT ON COLUMN CaracteristicaPreCadastroProduto.vantagemDesvantagem IS 'V-Vantagem, D-Desvantagem, N-Neutro';


ALTER SEQUENCE seq_idcaracteristicaprecadastroproduto OWNED BY CaracteristicaPreCadastroProduto.idCaracteristicaPreCadastroProduto;

CREATE SEQUENCE seq_idformaabastecimentoproduto;

CREATE TABLE FormaAbastecimentoProduto (
                idFormaAbastecimentoProduto INTEGER NOT NULL DEFAULT nextval('seq_idformaabastecimentoproduto'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                deveJustificar CHAR(1) DEFAULT 'N' NOT NULL,
                CONSTRAINT formaabastecimentoproduto_pk PRIMARY KEY (idFormaAbastecimentoProduto)
);
COMMENT ON COLUMN FormaAbastecimentoProduto.situacao IS 'A-Ativo,I-Inativo';
COMMENT ON COLUMN FormaAbastecimentoProduto.deveJustificar IS 'S-Sim, N-Não';


ALTER SEQUENCE seq_idformaabastecimentoproduto OWNED BY FormaAbastecimentoProduto.idFormaAbastecimentoProduto;

CREATE SEQUENCE seq_idsensibilidadeconcorrenciaproduto;

CREATE TABLE SensibilidadeConcorrenciaProduto (
                idSensibilidadeConcorrenciaProduto INTEGER NOT NULL DEFAULT nextval('seq_idsensibilidadeconcorrenciaproduto'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                CONSTRAINT sensibilidadeconcorrenciaproduto_pk PRIMARY KEY (idSensibilidadeConcorrenciaProduto)
);
COMMENT ON COLUMN SensibilidadeConcorrenciaProduto.situacao IS 'A-Ativo,I-Inativo';


ALTER SEQUENCE seq_idsensibilidadeconcorrenciaproduto OWNED BY SensibilidadeConcorrenciaProduto.idSensibilidadeConcorrenciaProduto;

CREATE TABLE FormaPagamento (
                idFormaPagamento INTEGER NOT NULL,
                descricao VARCHAR(128) NOT NULL,
                idErp VARCHAR(255),
                CONSTRAINT formapagamento_pk PRIMARY KEY (idFormaPagamento)
);
COMMENT ON TABLE FormaPagamento IS 'Identifica a forma de pagamento ou recebimento de compras ou vendas.  Ex: Dinheiro, Cartao etc...';


CREATE SEQUENCE seq_ramoatividade_idramoatividade;

CREATE TABLE RamoAtividade (
                idRamoAtividade INTEGER NOT NULL DEFAULT nextval('seq_ramoatividade_idramoatividade'),
                descricao VARCHAR(255) NOT NULL,
                CONSTRAINT ramoatividade_pk PRIMARY KEY (idRamoAtividade)
);
COMMENT ON TABLE RamoAtividade IS 'Identificação do Ramo de atividade.';


ALTER SEQUENCE seq_ramoatividade_idramoatividade OWNED BY RamoAtividade.idRamoAtividade;

CREATE SEQUENCE seq_tipoequipamento_idtipoequipamento;

CREATE TABLE TipoEquipamento (
                idTipoEquipamento INTEGER NOT NULL DEFAULT nextval('seq_tipoequipamento_idtipoequipamento'),
                descricao VARCHAR(255) NOT NULL,
                CONSTRAINT tipoequipamento_pk PRIMARY KEY (idTipoEquipamento)
);
COMMENT ON TABLE TipoEquipamento IS 'Identificação se o equipamento é Computador, Tablet, Tv, etc... ';


ALTER SEQUENCE seq_tipoequipamento_idtipoequipamento OWNED BY TipoEquipamento.idTipoEquipamento;

CREATE SEQUENCE seq_idafdmarcacao;

CREATE TABLE AFDMarcacaoPonto (
                idAFDMarcacao INTEGER NOT NULL DEFAULT nextval('seq_idafdmarcacao'),
                nsr VARCHAR(9),
                tipoRegistro INTEGER NOT NULL,
                dataMarcacao DATE NOT NULL,
                horaMarcacao VARCHAR(8) NOT NULL,
                numeroPis VARCHAR(12),
                cnpjUnidade VARCHAR(14) NOT NULL,
                horaMarcacaoMilis BIGINT,
                cpfColaborador VARCHAR(12) NOT NULL,
                crc VARCHAR(4),
                CONSTRAINT afdmarcacaoponto_pk PRIMARY KEY (idAFDMarcacao)
);
COMMENT ON TABLE AFDMarcacaoPonto IS 'Importa movimento padrao do arquivo AFD de marcação de Ponto dos Colaboradores nas unidades. ';


ALTER SEQUENCE seq_idafdmarcacao OWNED BY AFDMarcacaoPonto.idAFDMarcacao;

CREATE INDEX afdmarcacaoponto_idx_cnpjunidade
 ON AFDMarcacaoPonto
 ( cnpjUnidade );

CREATE INDEX afdmarcacaoponto_idx_numeropis
 ON AFDMarcacaoPonto
 ( numeroPis );

CREATE INDEX afdmarcacaoponto_idx_datamarcacao
 ON AFDMarcacaoPonto
 ( dataMarcacao );

CREATE SEQUENCE seq_idconcorrente;

CREATE TABLE Concorrente (
                idConcorrente INTEGER NOT NULL DEFAULT nextval('seq_idconcorrente'),
                nome VARCHAR(255) NOT NULL,
                situacao CHAR(1),
                CONSTRAINT concorrente_pk PRIMARY KEY (idConcorrente)
);
COMMENT ON TABLE Concorrente IS 'Cadastro de Concorrentes. ';
COMMENT ON COLUMN Concorrente.nome IS 'Nome do Concorrente';
COMMENT ON COLUMN Concorrente.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idconcorrente OWNED BY Concorrente.idConcorrente;

CREATE SEQUENCE seq_idmaterialalmoxarifadolocalestoque;

CREATE TABLE MaterialAlmoxarifadoLocalEstoque (
                idMaterialAlmoxarifadoLocalEstoque INTEGER NOT NULL DEFAULT nextval('seq_idmaterialalmoxarifadolocalestoque'),
                descricao VARCHAR(255) NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER,
                CONSTRAINT materialalmoxarifadolocalestoque_pk PRIMARY KEY (idMaterialAlmoxarifadoLocalEstoque)
);
COMMENT ON TABLE MaterialAlmoxarifadoLocalEstoque IS 'Locais de Estoque de Materiais. ';


ALTER SEQUENCE seq_idmaterialalmoxarifadolocalestoque OWNED BY MaterialAlmoxarifadoLocalEstoque.idMaterialAlmoxarifadoLocalEstoque;

CREATE SEQUENCE seq_idmaterialalmoxarifadocategoria;

CREATE TABLE MaterialAlmoxarifadoCategoria (
                idMaterialAlmoxarifadoCategoria INTEGER NOT NULL DEFAULT nextval('seq_idmaterialalmoxarifadocategoria'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER,
                CONSTRAINT materialalmoxarifadocategoria_pk PRIMARY KEY (idMaterialAlmoxarifadoCategoria)
);
COMMENT ON TABLE MaterialAlmoxarifadoCategoria IS 'Armazenará uma classificação em visão de categoria dos Materiais cadastrados.';
COMMENT ON COLUMN MaterialAlmoxarifadoCategoria.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idmaterialalmoxarifadocategoria OWNED BY MaterialAlmoxarifadoCategoria.idMaterialAlmoxarifadoCategoria;

CREATE SEQUENCE seq_idtipoquestionario;

CREATE TABLE tipoquestionario (
                idtipoquestionario INTEGER NOT NULL DEFAULT nextval('seq_idtipoquestionario'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) NOT NULL,
                CONSTRAINT tipoquestionario_pk PRIMARY KEY (idtipoquestionario)
);
COMMENT ON COLUMN tipoquestionario.situacao IS 'A-Ativa, I-Inativa';


ALTER SEQUENCE seq_idtipoquestionario OWNED BY tipoquestionario.idtipoquestionario;

CREATE SEQUENCE seq_idprojeto;

CREATE TABLE projeto (
                idprojeto INTEGER NOT NULL DEFAULT nextval('seq_idprojeto'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) NOT NULL,
                datainicial DATE,
                datafinal DATE,
                extensaodocumentacao VARCHAR(32),
                documentacao BYTEA,
                CONSTRAINT projeto_pk PRIMARY KEY (idprojeto)
);
COMMENT ON COLUMN projeto.situacao IS 'A-Ativa, I-Inativa, E-Espera, P-Parado, G-Aguardando, F-Finalizado, C-Cancelado';


ALTER SEQUENCE seq_idprojeto OWNED BY projeto.idprojeto;

CREATE SEQUENCE seq_idtopico;

CREATE TABLE topico (
                idtopico INTEGER NOT NULL DEFAULT nextval('seq_idtopico'),
                descricao VARCHAR(255) NOT NULL,
                codigo VARCHAR(255),
                situacao CHAR(1) NOT NULL,
                idprojeto INTEGER,
                idtopicopai INTEGER,
                CONSTRAINT topico_pk PRIMARY KEY (idtopico)
);
COMMENT ON TABLE topico IS 'Topica da Questão.';
COMMENT ON COLUMN topico.situacao IS 'A - Ativa, I - Inativa';


ALTER SEQUENCE seq_idtopico OWNED BY topico.idtopico;

CREATE SEQUENCE seq_idquestao;

CREATE TABLE questao (
                idquestao INTEGER NOT NULL DEFAULT nextval('seq_idquestao'),
                descricao VARCHAR(255) NOT NULL,
                idprojeto INTEGER,
                enunciado VARCHAR(255) NOT NULL,
                complemento VARCHAR(2048),
                extensaoimagem VARCHAR(32),
                imagem BYTEA,
                situacao CHAR(1) NOT NULL,
                tiporesposta CHAR(1) NOT NULL,
                numMaxImagens INTEGER,
                CONSTRAINT questao_pk PRIMARY KEY (idquestao)
);
COMMENT ON COLUMN questao.situacao IS 'A - Ativa, I - Inativa';
COMMENT ON COLUMN questao.tiporesposta IS 'U-Única Escolha, M-Múltipla Escolha, D-Descritiva';
COMMENT ON COLUMN questao.numMaxImagens IS 'Número máximo de imagens ao responder';


ALTER SEQUENCE seq_idquestao OWNED BY questao.idquestao;

CREATE TABLE topicoquestao (
                idtopico INTEGER NOT NULL,
                idquestao INTEGER NOT NULL,
                CONSTRAINT topicoquestao_pk PRIMARY KEY (idtopico, idquestao)
);


CREATE SEQUENCE seq_idalternativa;

CREATE TABLE alternativa (
                idalternativa INTEGER NOT NULL DEFAULT nextval('seq_idalternativa'),
                idquestao INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                complemento VARCHAR(2048),
                preavaliacao CHAR(1),
                situacao CHAR(1) NOT NULL,
                respostadescritiva CHAR(1) NOT NULL,
                avaliacaoPeso INTEGER,
                ordem INTEGER,
                fotoupload CHAR(1) DEFAULT 'O',
                CONSTRAINT alternativa_pk PRIMARY KEY (idalternativa)
);
COMMENT ON TABLE alternativa IS 'alternativa da questao';
COMMENT ON COLUMN alternativa.preavaliacao IS 'B-Boa, M-Media, R-Ruim, C-Correta, I-Incorreta, D-Desconhecida';
COMMENT ON COLUMN alternativa.situacao IS 'A - Ativa, I - Inativa';
COMMENT ON COLUMN alternativa.respostadescritiva IS 'O-Opcional, R-Requerida, N-Nao Aplicado';
COMMENT ON COLUMN alternativa.avaliacaoPeso IS 'Nota livre para usuário informar.  ';
COMMENT ON COLUMN alternativa.ordem IS 'Ordem para apresentação nas pesquisas e/ou relatorios. ';
COMMENT ON COLUMN alternativa.fotoupload IS 'O-Opcional, R-Requerida, N-Nao Aplicado';


ALTER SEQUENCE seq_idalternativa OWNED BY alternativa.idalternativa;

CREATE SEQUENCE seq_idpontoexposicao;

CREATE TABLE PontoExposicao (
                idPontoExposicao INTEGER NOT NULL DEFAULT nextval('seq_idpontoexposicao'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) NOT NULL,
                pontoPrincipal CHAR(1) NOT NULL,
                CONSTRAINT pontoexposicao_pk PRIMARY KEY (idPontoExposicao)
);
COMMENT ON TABLE PontoExposicao IS 'Locais de exposição do produto no ambiente da loja.   Ex: Gondola, Ponto extra...';
COMMENT ON COLUMN PontoExposicao.situacao IS 'A-Ativo, I-Inativo.';
COMMENT ON COLUMN PontoExposicao.pontoPrincipal IS 'S-Sim, N-Não';


ALTER SEQUENCE seq_idpontoexposicao OWNED BY PontoExposicao.idPontoExposicao;

CREATE SEQUENCE seq_idareaempresa;

CREATE TABLE AreaEmpresa (
                idAreaEmpresa INTEGER NOT NULL DEFAULT nextval('seq_idareaempresa'),
                descricao VARCHAR(255) NOT NULL,
                CONSTRAINT areaempresa_pk PRIMARY KEY (idAreaEmpresa)
);
COMMENT ON TABLE AreaEmpresa IS 'Identifica Areas semelhante a departamentos da empresa.  Ex: Departamento Financeiro, Logistico, etc...';


ALTER SEQUENCE seq_idareaempresa OWNED BY AreaEmpresa.idAreaEmpresa;

CREATE SEQUENCE seq_idquestionario;

CREATE TABLE questionario (
                idquestionario INTEGER NOT NULL DEFAULT nextval('seq_idquestionario'),
                descricao VARCHAR(255) NOT NULL,
                complemento VARCHAR(2048),
                situacao CHAR(1) NOT NULL,
                datainicialdisponibilidade DATE,
                horaInicialDisponibilidade VARCHAR(10),
                datafinaldisponibilidade DATE,
                horaFinalDisponibilidade VARCHAR(10),
                diassemanadisponibilidade VARCHAR(255),
                diasmesdisponibilidade VARCHAR(255),
                mesesdisponibilidade VARCHAR(255),
                anosdisponibilidade VARCHAR(255),
                tipovisualizacaomobile CHAR(1) NOT NULL,
                tipovisualizacaodesktop CHAR(1) NOT NULL,
                extensaodocumentacao VARCHAR(32),
                documentacao BYTEA,
                idprojeto INTEGER,
                idtipoquestionario INTEGER,
                idLocalAplicacao INTEGER,
                idareaempresa INTEGER,
                quantidadeAplicacoes INTEGER DEFAULT 1,
                CONSTRAINT questionario_pk PRIMARY KEY (idquestionario)
);
COMMENT ON COLUMN questionario.situacao IS 'A-Ativa, I-Inativa';
COMMENT ON COLUMN questionario.horaInicialDisponibilidade IS 'Hora Inicial para geração das aplicações automaticamente.';
COMMENT ON COLUMN questionario.horaFinalDisponibilidade IS 'Hora Final para geração das aplicações automaticamente.';
COMMENT ON COLUMN questionario.tipovisualizacaomobile IS 'P-Paginada, S-Sequencial, N-Navegada';
COMMENT ON COLUMN questionario.tipovisualizacaodesktop IS 'P-Paginada, S-Sequencial, N-Navegada';
COMMENT ON COLUMN questionario.quantidadeAplicacoes IS 'Quantidade de aplicações que o questionário deverá gerar em casos de respondentes. ';


ALTER SEQUENCE seq_idquestionario OWNED BY questionario.idquestionario;

CREATE TABLE AreaEmpresaMercadologico (
                idAreaEmpresa INTEGER NOT NULL,
                idMercadologico INTEGER NOT NULL,
                tipoMercadologico CHAR(1) NOT NULL,
                CONSTRAINT areaempresamercadologico_pk PRIMARY KEY (idAreaEmpresa, idMercadologico, tipoMercadologico)
);
COMMENT ON TABLE AreaEmpresaMercadologico IS 'Ligação da Area empresa com o mercadologico de produtos, para identificação de movimentações de produtos. ';
COMMENT ON COLUMN AreaEmpresaMercadologico.tipoMercadologico IS 'D-Departamento, S-Seção, G-Grupo, B-Subgrupo, P-Produto';


CREATE TABLE Cfop (
                idCfop INTEGER NOT NULL,
                descricao VARCHAR(512) NOT NULL,
                descricaoDetalhada VARCHAR(1024),
                CONSTRAINT cfop_pk PRIMARY KEY (idCfop)
);


CREATE SEQUENCE seq_idveiculotipo;

CREATE TABLE VeiculoTipo (
                idVeiculoTipo INTEGER NOT NULL DEFAULT nextval('seq_idveiculotipo'),
                descricao VARCHAR(255) NOT NULL,
                dataInclusao DATE,
                horaInclusao VARCHAR(8),
                idUsuarioInclusao INTEGER,
                situacao CHAR(1),
                CONSTRAINT veiculotipo_pk PRIMARY KEY (idVeiculoTipo)
);
COMMENT ON COLUMN VeiculoTipo.situacao IS 'A-Ativo,  I-Inativo.';


ALTER SEQUENCE seq_idveiculotipo OWNED BY VeiculoTipo.idVeiculoTipo;

CREATE SEQUENCE seq_idveiculo;

CREATE TABLE Veiculo (
                idVeiculo INTEGER NOT NULL DEFAULT nextval('seq_idveiculo'),
                idVeiculoTipo INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                placa VARCHAR(10),
                ano INTEGER,
                marca VARCHAR(255),
                modelo VARCHAR(255),
                dataInclusao DATE,
                horaInclusao VARCHAR(8),
                idUsuarioInclusao INTEGER,
                situacao CHAR(1),
                rastreado CHAR(1),
                chassi VARCHAR(255),
                frotaPropria CHAR(1),
                observacao VARCHAR(255),
                CONSTRAINT veiculo_pk PRIMARY KEY (idVeiculo)
);
COMMENT ON COLUMN Veiculo.situacao IS 'A-Ativo,  I-Inativo.';
COMMENT ON COLUMN Veiculo.rastreado IS 'S-Sim, N-Não';
COMMENT ON COLUMN Veiculo.frotaPropria IS 'S-Sim, N-Não.';


ALTER SEQUENCE seq_idveiculo OWNED BY Veiculo.idVeiculo;

CREATE SEQUENCE seq_idmercadologicodepara;

CREATE TABLE MercadologicoDePara (
                idMercadologicoDePara INTEGER NOT NULL DEFAULT nextval('seq_idmercadologicodepara'),
                idDepartamentoErp VARCHAR(128),
                IdSetorErp VARCHAR(128),
                idGrupoErp VARCHAR(128),
                idFamiliaErp VARCHAR(128),
                idDepartamentoObs INTEGER,
                idSetorObs INTEGER,
                idGrupoObs INTEGER,
                idFamiliaObs INTEGER,
                CONSTRAINT mercadologicodepara_pk PRIMARY KEY (idMercadologicoDePara)
);
COMMENT ON TABLE MercadologicoDePara IS 'Armazena o DePara para utilização nas ETLs.';


ALTER SEQUENCE seq_idmercadologicodepara OWNED BY MercadologicoDePara.idMercadologicoDePara;

CREATE SEQUENCE seq_idcotacaofornecedor;

CREATE TABLE CotacaoFornecedor (
                idCotacaoFornecedor INTEGER NOT NULL DEFAULT nextval('seq_idcotacaofornecedor'),
                descricao VARCHAR(255) NOT NULL,
                dataInicial DATE,
                dataFinal DATE,
                horaInicial VARCHAR(8) NOT NULL,
                horaFinal VARCHAR(8) NOT NULL,
                dataCadastro DATE NOT NULL,
                idUsuarioCadastro INTEGER NOT NULL,
                dataAlteracao DATE NOT NULL,
                idUsuarioAlteracao INTEGER,
                situacao VARCHAR(32) DEFAULT 'A' NOT NULL,
                dataEnvioConvite DATE,
                horaEnvioConvite VARCHAR(8),
                idUsuarioEnvioConvite INTEGER,
                idExecucaoConvite INTEGER,
                CONSTRAINT cotacaofornecedor_pk PRIMARY KEY (idCotacaoFornecedor)
);
COMMENT ON COLUMN CotacaoFornecedor.dataInicial IS 'Data em que o produto entrará em cotação.';
COMMENT ON COLUMN CotacaoFornecedor.dataFinal IS 'Data em que o produto sairá de cotação.';
COMMENT ON COLUMN CotacaoFornecedor.horaInicial IS 'Horário que normalmente a cotação deverá ser iniciada.';
COMMENT ON COLUMN CotacaoFornecedor.horaFinal IS 'Horário que normalmente a cotação deverá ser encerrada.';
COMMENT ON COLUMN CotacaoFornecedor.situacao IS 'A-Ativa, I-Inativa';


ALTER SEQUENCE seq_idcotacaofornecedor OWNED BY CotacaoFornecedor.idCotacaoFornecedor;

CREATE TABLE CotacaoFornecedorValor (
                idCotacaoFornecedor INTEGER NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                idproduto BIGINT NOT NULL,
                valorUnitarioBruto NUMERIC(15,2) DEFAULT 0 NOT NULL,
                valorComSt NUMERIC(15,2) DEFAULT 0 NOT NULL,
                valorUnitarioLiquido NUMERIC(15,2) DEFAULT 0 NOT NULL,
                observacao VARCHAR(255),
                dataCadastro DATE NOT NULL,
                horaCadastro VARCHAR(8) NOT NULL,
                dataAlteracao DATE NOT NULL,
                horaAlteracao VARCHAR(8) NOT NULL,
                idUsuarioAlteracao INTEGER,
                CONSTRAINT cotacaofornecedorvalor_pk PRIMARY KEY (idCotacaoFornecedor, idPessoa, idproduto)
);
COMMENT ON TABLE CotacaoFornecedorValor IS 'Retorno do Fornecedor informando valor de cotação dos produtos.';
COMMENT ON COLUMN CotacaoFornecedorValor.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN CotacaoFornecedorValor.valorUnitarioBruto IS 'Valor Bruto é considerado como o valor de partida do Fornecedor, ou valor de Tabela, o qual consta apenas e tão somente o Preço de Venda do Fornecedor. ';
COMMENT ON COLUMN CotacaoFornecedorValor.valorComSt IS 'Valor do Produto com o valor da Substituição Tributária já Embutido no valor do produto. ';
COMMENT ON COLUMN CotacaoFornecedorValor.valorUnitarioLiquido IS 'Valor considerado como custo de aquisição ou Ultima compra, o qual considera o preço de venda do fornecedor - impostos dedutíveis + impostos. ';


CREATE SEQUENCE seq_idtarefaresultado;

CREATE TABLE TarefaResultado (
                idTarefaResultado BIGINT NOT NULL DEFAULT nextval('seq_idtarefaresultado'),
                apelidoTarefa VARCHAR(255) NOT NULL,
                dataMovimento DATE NOT NULL,
                idTarefaExecucao INTEGER NOT NULL,
                chave VARCHAR(123456) NOT NULL,
                valor VARCHAR(123456) NOT NULL,
                CONSTRAINT tarefaresultado_pk PRIMARY KEY (idTarefaResultado)
);
COMMENT ON TABLE TarefaResultado IS 'Armazenará o resultado das tarefas, buscando permitir acompanhamento se o número de itens está evoluindo positivamente ou negativamente. ';


ALTER SEQUENCE seq_idtarefaresultado OWNED BY TarefaResultado.idTarefaResultado;

CREATE INDEX tarefaresultado_idx_apelidotarefa_datamovimento
 ON TarefaResultado
 ( apelidoTarefa, dataMovimento );

CREATE SEQUENCE seq_idempresaregional;

CREATE TABLE EmpresaRegional (
                idEmpresaRegional INTEGER NOT NULL DEFAULT nextval('seq_idempresaregional'),
                descricao VARCHAR(255) NOT NULL,
                CONSTRAINT empresaregional_pk PRIMARY KEY (idEmpresaRegional)
);


ALTER SEQUENCE seq_idempresaregional OWNED BY EmpresaRegional.idEmpresaRegional;

CREATE SEQUENCE seq_idquebradestino;

CREATE TABLE QuebraDestino (
                idQuebraDestino INTEGER NOT NULL DEFAULT nextval('seq_idquebradestino'),
                horaInclusao VARCHAR(8) NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                dataInclusao DATE NOT NULL,
                idUsuarioInclusao INTEGER,
                idQuebraDestinoErp VARCHAR(128),
                idQuebraDestinoAgrupamento INTEGER,
                CONSTRAINT quebradestino_pk PRIMARY KEY (idQuebraDestino)
);
COMMENT ON TABLE QuebraDestino IS 'Destino da Quebra. ';
COMMENT ON COLUMN QuebraDestino.idQuebraDestinoErp IS 'Codigo do cadastro de Quebra Destino no Erp.';
COMMENT ON COLUMN QuebraDestino.idQuebraDestinoAgrupamento IS 'Código do Destino para agrupamento.   Ex: Codigo erp 10, agrupando no codigo 5 do cadastro. ';


ALTER SEQUENCE seq_idquebradestino OWNED BY QuebraDestino.idQuebraDestino;

CREATE INDEX quebradestino_idx_destinoerp
 ON QuebraDestino
 ( idQuebraDestinoErp );

CREATE INDEX quebradestino_idx_destinoagrupamento
 ON QuebraDestino
 ( idQuebraDestinoAgrupamento );

CREATE SEQUENCE seq_idquebramotivo;

CREATE TABLE QuebraMotivo (
                idQuebraMotivo INTEGER NOT NULL DEFAULT nextval('seq_idquebramotivo'),
                descricao VARCHAR(255) NOT NULL,
                dataInclusao DATE NOT NULL,
                idUsuarioInclusao INTEGER,
                horaInclusao VARCHAR(8) NOT NULL,
                idQuebraMotivoErp VARCHAR(128),
                idQuebraMotivoAgrupamento INTEGER,
                CONSTRAINT quebramotivo_pk PRIMARY KEY (idQuebraMotivo)
);
COMMENT ON TABLE QuebraMotivo IS 'Cadastro de Motivos de Quebras de produtos.';
COMMENT ON COLUMN QuebraMotivo.idQuebraMotivoErp IS 'Codigo do cadastro de Quebra Motivo no Erp.';
COMMENT ON COLUMN QuebraMotivo.idQuebraMotivoAgrupamento IS 'Código do Motivo para agrupamento.   Ex: Codigo erp 10, agrupando no codigo 5 do cadastro. ';


ALTER SEQUENCE seq_idquebramotivo OWNED BY QuebraMotivo.idQuebraMotivo;

CREATE INDEX quebramotivo_motivoerp
 ON QuebraMotivo
 ( idQuebraMotivoErp );

CREATE INDEX quebramotivo_idx_motivoagrupamento
 ON QuebraMotivo
 ( idQuebraMotivoAgrupamento );

CREATE SEQUENCE seq_idindicadorgestao;

CREATE TABLE IndicadorGestao (
                idIndicadorGestao INTEGER NOT NULL DEFAULT nextval('seq_idindicadorgestao'),
                descricao VARCHAR(255) NOT NULL,
                tipoIntervalo VARCHAR(128) NOT NULL,
                apelidoTarefaAnalise VARCHAR(255),
                apelidoTarefaValorAtual VARCHAR(255),
                situacao CHAR(1),
                idUsuarioInclusao INTEGER,
                tipoResultado VARCHAR(1),
                tipoAplicacao VARCHAR(1),
                dataInclusao DATE,
                horaInclusao VARCHAR(8),
                imagemPadraoIndicador BYTEA,
                extImagemPadraoIndicador VARCHAR(32),
                idIndicadorGestaoCategoria INTEGER,
                observacao VARCHAR(2048),
                sqlCalculaIndicador VARCHAR(8192),
                tipoVisualizacao VARCHAR(1) DEFAULT 'P',
                CONSTRAINT indicadorgestao_pk PRIMARY KEY (idIndicadorGestao)
);
COMMENT ON TABLE IndicadorGestao IS '  Destinada a armazenar os tipos de Indicador de Gestão que a empresa utilizará. Exemplo: Indice de Inadimplencia, Ticket Medio. ';
COMMENT ON COLUMN IndicadorGestao.tipoIntervalo IS 'Nome do atributo da tabela Data.  Ex:   agrupamento diário: = a ddmmaaaa   agrupamento semanal: = a semanaano';
COMMENT ON COLUMN IndicadorGestao.apelidoTarefaAnalise IS '  Permitirá ao usuário disparar uma tarefa de análise do indicador, podendo personalizar para cada cliente. ';
COMMENT ON COLUMN IndicadorGestao.apelidoTarefaValorAtual IS 'Apelido da tarefa, que irá calcular o valor do Indicador no periodo atual, ou periodo informado como parametro para a tarefa que será invocada no momento da apresentação do indicdor em paineis gráficos. ';
COMMENT ON COLUMN IndicadorGestao.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN IndicadorGestao.tipoResultado IS 'M-Meio, F-Fim.  ';
COMMENT ON COLUMN IndicadorGestao.tipoAplicacao IS 'Q-Qualidade, C-Custo, E-Entrega, M-Mão de Obra, S-Segurança.';
COMMENT ON COLUMN IndicadorGestao.imagemPadraoIndicador IS 'Imagem que será apresentada nos painéis que visualizarão tal indicador. ';
COMMENT ON COLUMN IndicadorGestao.extImagemPadraoIndicador IS 'Extensao do documento anexado.';
COMMENT ON COLUMN IndicadorGestao.observacao IS 'Observações complementares. ';
COMMENT ON COLUMN IndicadorGestao.sqlCalculaIndicador IS 'Campo destinado para armazenar comando de sql que irão calcular o indicador. ';
COMMENT ON COLUMN IndicadorGestao.tipoVisualizacao IS 'P-% V-Valor em Reais N-Numero simples. ';


ALTER SEQUENCE seq_idindicadorgestao OWNED BY IndicadorGestao.idIndicadorGestao;

CREATE SEQUENCE seq_idindicadorgestaonotificacaoreferencia;

CREATE TABLE IndicadorGestaoNotificacaoReferencia (
                idIndicadorGestaoNotificacaoReferencia INTEGER NOT NULL DEFAULT nextval('seq_idindicadorgestaonotificacaoreferencia'),
                idIndicadorGestao INTEGER NOT NULL,
                chave VARCHAR(255) NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                valorInicial NUMERIC(15,3) NOT NULL,
                valorFinal NUMERIC(15,3) NOT NULL,
                CONSTRAINT indicadorgestaonotificacaoreferencia_pk PRIMARY KEY (idIndicadorGestaoNotificacaoReferencia)
);
COMMENT ON COLUMN IndicadorGestaoNotificacaoReferencia.chave IS 'Identifica o tipo de agrupamento da referencia, que pode ser Geral, idEmpresa, Tamanho, Atividade etc..';


ALTER SEQUENCE seq_idindicadorgestaonotificacaoreferencia OWNED BY IndicadorGestaoNotificacaoReferencia.idIndicadorGestaoNotificacaoReferencia;

CREATE SEQUENCE seq_idindicadorgestaonotificacaoreferenciadestinatario;

CREATE TABLE IndicadorGestaoNotificacaoReferenciaDestinatario (
                idIndicadorGestaoNotificacaoReferenciaDestinatario INTEGER NOT NULL DEFAULT nextval('seq_idindicadorgestaonotificacaoreferenciadestinatario'),
                idIndicadorGestaoNotificacaoReferencia INTEGER NOT NULL,
                tipoDestinatario VARCHAR(3) NOT NULL,
                idDestinatario INTEGER NOT NULL,
                CONSTRAINT indicadorgestaonotificacaoreferenciadestinatario_pk PRIMARY KEY (idIndicadorGestaoNotificacaoReferenciaDestinatario)
);
COMMENT ON COLUMN IndicadorGestaoNotificacaoReferenciaDestinatario.tipoDestinatario IS 'FC - Forma Contato C - Colaborador F - Função';


ALTER SEQUENCE seq_idindicadorgestaonotificacaoreferenciadestinatario OWNED BY IndicadorGestaoNotificacaoReferenciaDestinatario.idIndicadorGestaoNotificacaoReferenciaDestinatario;

CREATE TABLE IndicadorGestaoReferencia (
                chave VARCHAR(255) NOT NULL,
                idIndicadorGestao INTEGER NOT NULL,
                referencias VARCHAR(1234) NOT NULL,
                CONSTRAINT indicadorgestaoreferencia_pk PRIMARY KEY (chave, idIndicadorGestao)
);
COMMENT ON TABLE IndicadorGestaoReferencia IS 'Armazenará as referencias consideradas como Otimas, Boas ou Ruins.';
COMMENT ON COLUMN IndicadorGestaoReferencia.chave IS 'Identifica o tipo de agrupamento da referencia, que pode ser Geral, idEmpresa, Tamanho, Atividade etc..';
COMMENT ON COLUMN IndicadorGestaoReferencia.referencias IS 'Informar valores (intervalos) iniciais e finais para identificação dos indicadores como Bom, Alerta ou Ruim.   Descrição, Cor, Inicio e Fim.   Campo deve ser alterado para JSON.';


CREATE INDEX indicadorgestaoreferencia_idx_idindicadorgestao
 ON IndicadorGestaoReferencia
 ( idIndicadorGestao );

CREATE SEQUENCE seq_idindicadorgestaovisaoindicadorgestao;

CREATE TABLE IndicadorGestaoVisaoIndicadorGestao (
                idIndicadorGestaoVisaoIndicadorGestao INTEGER NOT NULL DEFAULT nextval('seq_idindicadorgestaovisaoindicadorgestao'),
                idIndicadorGestaoVisao INTEGER NOT NULL,
                idIndicadorGestao INTEGER NOT NULL,
                CONSTRAINT indicadorgestaovisaoindicadorgestao_pk PRIMARY KEY (idIndicadorGestaoVisaoIndicadorGestao)
);
COMMENT ON TABLE IndicadorGestaoVisaoIndicadorGestao IS 'Tabela de ligação de Visões com Indicadores de Gestão.';


ALTER SEQUENCE seq_idindicadorgestaovisaoindicadorgestao OWNED BY IndicadorGestaoVisaoIndicadorGestao.idIndicadorGestaoVisaoIndicadorGestao;

CREATE TABLE EtlValidacao (
                dataMovimento DATE NOT NULL,
                tipoEtl VARCHAR(128) NOT NULL,
                valor NUMERIC(15,4) NOT NULL,
                quantidade NUMERIC(15,4) NOT NULL,
                CONSTRAINT etlvalidacao_pk PRIMARY KEY (dataMovimento, tipoEtl)
);


CREATE SEQUENCE seqidprodutorank;

CREATE TABLE ProdutoRank (
                idProdutoRank INTEGER NOT NULL DEFAULT nextval('seqidprodutorank'),
                descricao VARCHAR(128) NOT NULL,
                tipoRank VARCHAR(128) NOT NULL,
                numeroProdutos INTEGER NOT NULL,
                tipoIntervalo VARCHAR(128) NOT NULL,
                CONSTRAINT produtorank_pk PRIMARY KEY (idProdutoRank)
);
COMMENT ON COLUMN ProdutoRank.tipoRank IS 'V-Vendas, C-Compras, E-Estoque, P-Perdas, Q-Quebras, R-Ruptura';
COMMENT ON COLUMN ProdutoRank.numeroProdutos IS 'Guarda o número de produtos que farão parte do TOP, exemplo, TOP 10, deverá ser igual a 10. ';
COMMENT ON COLUMN ProdutoRank.tipoIntervalo IS 'Diaria, Mensal, Anual, etc...';


ALTER SEQUENCE seqidprodutorank OWNED BY ProdutoRank.idProdutoRank;

CREATE SEQUENCE seq_idindicadoravaliacao;

CREATE TABLE IndicadorAvaliacao (
                idIndicadorAvaliacao INTEGER NOT NULL DEFAULT nextval('seq_idindicadoravaliacao'),
                descricao VARCHAR(255) NOT NULL,
                peso NUMERIC(15,4) DEFAULT 1.00 NOT NULL,
                tipoIntervalor VARCHAR(128) NOT NULL,
                chave VARCHAR(128) NOT NULL,
                documentacao VARCHAR(255),
                CONSTRAINT indicadoravaliacao_pk PRIMARY KEY (idIndicadorAvaliacao)
);
COMMENT ON COLUMN IndicadorAvaliacao.tipoIntervalor IS 'Nome do atributo da tabela Data.  Ex:   agrupamento diário: = a ddmmaaaa   agrupamento semanal: = a semanaano';


ALTER SEQUENCE seq_idindicadoravaliacao OWNED BY IndicadorAvaliacao.idIndicadorAvaliacao;

CREATE TABLE FluxoGrupo (
                idFluxoGrupo INTEGER NOT NULL,
                idFluxoGrupoTipo INTEGER,
                descricao VARCHAR(255) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(5) NOT NULL,
                idUsuarioAlteracao INTEGER NOT NULL,
                dataAlteracao DATE NOT NULL,
                horaAlteracao VARCHAR(5) NOT NULL,
                tipoFluxoGrupo CHAR(1) NOT NULL,
                CONSTRAINT fluxogrupo_pk PRIMARY KEY (idFluxoGrupo)
);
COMMENT ON COLUMN FluxoGrupo.idUsuarioInclusao IS 'Código do usuário que criou o registro.';
COMMENT ON COLUMN FluxoGrupo.dataInclusao IS 'Data da criação do registro.';
COMMENT ON COLUMN FluxoGrupo.horaInclusao IS 'Hora em que o registro foi criado';
COMMENT ON COLUMN FluxoGrupo.idUsuarioAlteracao IS 'Código do usuário que realizou a última alteração.';
COMMENT ON COLUMN FluxoGrupo.dataAlteracao IS 'Data da última alteração';
COMMENT ON COLUMN FluxoGrupo.horaAlteracao IS 'Hora da ultima atuaçlizacao do registro';
COMMENT ON COLUMN FluxoGrupo.tipoFluxoGrupo IS 'R-Receitas D-Despesas F- I- P-Patrimonial';


CREATE SEQUENCE configtarefa_idconfigtarefa_seq;

CREATE TABLE ConfigTarefa (
                idConfigTarefa INTEGER NOT NULL DEFAULT nextval('configtarefa_idconfigtarefa_seq'),
                apelidoTarefa VARCHAR(255) NOT NULL,
                chave VARCHAR(255) NOT NULL,
                descricao VARCHAR(255),
                valor VARCHAR(64000) NOT NULL,
                dataAlteracao DATE,
                idUsuarioAlteracao INTEGER,
                informacoesAdicionais VARCHAR(12345),
                CONSTRAINT configtarefa_pk PRIMARY KEY (idConfigTarefa)
);
COMMENT ON TABLE ConfigTarefa IS 'Objetivo de armazenar configurações de variaveis utilizadas nas tarefas. ';


ALTER SEQUENCE configtarefa_idconfigtarefa_seq OWNED BY ConfigTarefa.idConfigTarefa;

CREATE INDEX configtarefa_idx
 ON ConfigTarefa
 ( apelidoTarefa, chave );

CREATE TABLE pgVendasEmpresaMercadologico (
                idempresa INTEGER NOT NULL,
                idmercadologico INTEGER NOT NULL,
                tipoMercadologico VARCHAR(155) NOT NULL,
                dataMovimento DATE NOT NULL,
                valorVenda NUMERIC(15,2) NOT NULL,
                valorLucro NUMERIC(15,2) DEFAULT 0 NOT NULL,
                CONSTRAINT pgvendasempresamercadologico_pk PRIMARY KEY (idempresa, idmercadologico, tipoMercadologico, dataMovimento)
);
COMMENT ON COLUMN pgVendasEmpresaMercadologico.tipoMercadologico IS 'D-Departamento, S-Seção, G-Grupo, B-Subgrupo, P-Produto, V-Vendedor';


CREATE INDEX pgvendasempresamercadologico_idx
 ON pgVendasEmpresaMercadologico
 ( idempresa, idmercadologico, dataMovimento );

CREATE INDEX pgvendasempresamercadologico_idx1
 ON pgVendasEmpresaMercadologico
 ( idmercadologico );

CREATE INDEX pgvendasempresamercadologico_idx2
 ON pgVendasEmpresaMercadologico
 ( dataMovimento );

CREATE TABLE Indice (
                idIndice INTEGER NOT NULL,
                descricao VARCHAR(128) NOT NULL,
                sigla VARCHAR(128) DEFAULT ' ',
                intervaloIndice VARCHAR(10) DEFAULT 'M' NOT NULL,
                idMoedaBancoCentral VARCHAR(255),
                quantidadeConversao NUMERIC(15,4),
                grupo VARCHAR(255),
                CONSTRAINT indice_pk PRIMARY KEY (idIndice)
);
COMMENT ON TABLE Indice IS 'Armazena cadastro de moedas/indices....';
COMMENT ON COLUMN Indice.intervaloIndice IS 'M-Mensal, D-Diario , T-Trimestre, S-Semestre , A-Anual';
COMMENT ON COLUMN Indice.idMoedaBancoCentral IS 'Código da Moeda dentro do WebService do Banco Central.  189 - IGPM 188 - INPC etc...';
COMMENT ON COLUMN Indice.quantidadeConversao IS 'Quantidade utilizada para atualizar o valor da cotação com base no formato que o cliente utiliza, exemplo de moedas de agronegócios, como: Milho tem cotação em valor da Saca de 60 km, mas o cliente utiliza o valor do kilo, logo, deverá ser dividido o valor da cotação da saca por 60. ';


CREATE INDEX indice_idx
 ON Indice
 ( descricao );

CREATE INDEX indice_idx1
 ON Indice
 ( sigla );

CREATE TABLE IndiceCotacao (
                idIndice INTEGER NOT NULL,
                dataIndice DATE NOT NULL,
                valor NUMERIC(15,6) DEFAULT 0 NOT NULL,
                valores VARCHAR(12345),
                dataAlteracao DATE,
                CONSTRAINT indicecotacao_pk PRIMARY KEY (idIndice, dataIndice)
);
COMMENT ON COLUMN IndiceCotacao.valores IS 'Valores diversos em formato JSON';


CREATE TABLE Intervalo (
                idIntervalo VARCHAR(128) NOT NULL,
                descricao VARCHAR(128),
                atributosAgrupamento VARCHAR(255),
                CONSTRAINT intervalo_pk PRIMARY KEY (idIntervalo)
);
COMMENT ON TABLE Intervalo IS 'Utiliza para armazenar os possiveis tipos de agrupamento de periodos ex: Semanal, mensal etc...';


CREATE TABLE Data (
                ddmmaaaa DATE NOT NULL,
                dia INTEGER NOT NULL,
                mes INTEGER NOT NULL,
                ano INTEGER NOT NULL,
                mesSigla CHAR(3) NOT NULL,
                mesDescricao VARCHAR(20) NOT NULL,
                diaSemana INTEGER NOT NULL,
                diaSemanaSigla CHAR(3) NOT NULL,
                diaSemanaDescricao VARCHAR(20) NOT NULL,
                diaAno INTEGER NOT NULL,
                semanaAno INTEGER NOT NULL,
                semanaMes INTEGER NOT NULL,
                bimestre VARCHAR(20) NOT NULL,
                trimestre VARCHAR(20) NOT NULL,
                semestre VARCHAR(20) NOT NULL,
                quadrimestre VARCHAR(20) NOT NULL,
                estacaoAno VARCHAR(20) NOT NULL,
                CONSTRAINT data_pk PRIMARY KEY (ddmmaaaa)
);


CREATE TABLE DataEquivalente (
                ddmmaaaa DATE NOT NULL,
                tipoEquivalencia VARCHAR(128) NOT NULL,
                diaEquivalente DATE NOT NULL,
                CONSTRAINT dataequivalente_pk PRIMARY KEY (ddmmaaaa, tipoEquivalencia)
);
COMMENT ON COLUMN DataEquivalente.tipoEquivalencia IS 'MES_ATUAL_ANO_ANTERIOR MES_ANTERIOR ';


CREATE SEQUENCE produtofinalidade_idprodutofinalidade_seq;

CREATE TABLE ProdutoFinalidade (
                idProdutoFinalidade INTEGER NOT NULL DEFAULT nextval('produtofinalidade_idprodutofinalidade_seq'),
                descricao VARCHAR(255) NOT NULL,
                sigla VARCHAR(155) DEFAULT 'R',
                CONSTRAINT produtofinalidade_pk PRIMARY KEY (idProdutoFinalidade)
);
COMMENT ON TABLE ProdutoFinalidade IS 'Identifica qual finalidade tem o produto, se para revenda, industrialização, imobilizado ';


ALTER SEQUENCE produtofinalidade_idprodutofinalidade_seq OWNED BY ProdutoFinalidade.idProdutoFinalidade;

CREATE SEQUENCE seq_idmercadologicoinfo;

CREATE TABLE MercadologicoInfo (
                idMercadologicoInfo INTEGER NOT NULL DEFAULT nextval('seq_idmercadologicoinfo'),
                tipoMercadologico CHAR(1) NOT NULL,
                idMercadologico VARCHAR(255) NOT NULL,
                idEmpresa INTEGER,
                qtdeMixProdutoIdeal INTEGER,
                horaInclusao VARCHAR(8) NOT NULL,
                dataInclusao DATE NOT NULL,
                idUsuarioInclusao INTEGER,
                idProdutoFinalidade INTEGER,
                margemLucroDesejada NUMERIC(15,2),
                CONSTRAINT mercadologicoinfo_pk PRIMARY KEY (idMercadologicoInfo)
);
COMMENT ON TABLE MercadologicoInfo IS 'Informações Gerais sobre O mercadologico. Dados como Quantidades, % etc... ';
COMMENT ON COLUMN MercadologicoInfo.tipoMercadologico IS 'D-Departamento, S-Setor, G-Grupo, F-Familia, U-SubFamilia';
COMMENT ON COLUMN MercadologicoInfo.idEmpresa IS 'Id da empresa ou 0 (zero) para apontar como todos os registros. ';


ALTER SEQUENCE seq_idmercadologicoinfo OWNED BY MercadologicoInfo.idMercadologicoInfo;

CREATE TABLE Pais (
                idPais INTEGER NOT NULL,
                nomePais VARCHAR(50) NOT NULL,
                continente INTEGER,
                ddi INTEGER,
                CONSTRAINT pais_pk PRIMARY KEY (idPais)
);


CREATE TABLE Uf (
                idUf INTEGER NOT NULL,
                idPais INTEGER,
                siglaUf CHAR(2) NOT NULL,
                nomeUf VARCHAR(50) NOT NULL,
                regiao INTEGER,
                codibge INTEGER,
                CONSTRAINT uf_pk PRIMARY KEY (idUf)
);


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
);


CREATE SEQUENCE seq_idevento;

CREATE TABLE Evento (
                idEvento INTEGER NOT NULL DEFAULT nextval('seq_idevento'),
                descricao VARCHAR(255) NOT NULL,
                dataInicial DATE NOT NULL,
                dataFinal DATE NOT NULL,
                horario VARCHAR(255) NOT NULL,
                idMunicipio INTEGER NOT NULL,
                endereco VARCHAR(255),
                latitude NUMERIC(12,6),
                longitude NUMERIC(12,6),
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                descricaoDetalhada VARCHAR(8192),
                urlPrincipal VARCHAR(1024),
                CONSTRAINT evento_pk PRIMARY KEY (idEvento)
);
COMMENT ON TABLE Evento IS 'Qualquer evento que a empresa desejar controlar. Festa, Evento aos Clientes, etc...';


ALTER SEQUENCE seq_idevento OWNED BY Evento.idEvento;

CREATE SEQUENCE seq_ideventomedia;

CREATE TABLE EventoMidia (
                idEventoMedia INTEGER NOT NULL DEFAULT nextval('seq_ideventomedia'),
                idEvento INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                url VARCHAR(1024),
                CONSTRAINT eventomidia_pk PRIMARY KEY (idEventoMedia)
);


ALTER SEQUENCE seq_ideventomedia OWNED BY EventoMidia.idEventoMedia;

CREATE TABLE MunicipioDePara (
                idMunicipio INTEGER NOT NULL,
                sistema VARCHAR(1024) NOT NULL,
                idMunicipioSistema VARCHAR(1024) NOT NULL,
                CONSTRAINT municipiodepara_pk PRIMARY KEY (idMunicipio, sistema)
);
COMMENT ON TABLE MunicipioDePara IS 'Ligação do nosso cadastro de cidades com outros sistemas. ';
COMMENT ON COLUMN MunicipioDePara.sistema IS 'Nome do sistema, podendo ser padronizado como webservice ou apis.  Ex: Tray, HgBrasil';


CREATE SEQUENCE seq_idclimatempo;

CREATE TABLE ClimaTempo (
                idClimaTempo INTEGER NOT NULL DEFAULT nextval('seq_idclimatempo'),
                idMunicipio INTEGER NOT NULL,
                dataClima DATE NOT NULL,
                horaClima VARCHAR(5),
                temperaturaAtual NUMERIC(15,2),
                temperaturaMaxima NUMERIC(15,2) NOT NULL,
                temperaturaMinima NUMERIC(15,2) NOT NULL,
                observacao VARCHAR(1024),
                umidadeAr NUMERIC(15,2),
                horaNascerSol VARCHAR(5),
                horaPorSol VARCHAR(5),
                velocidadeVento NUMERIC(15,2),
                statusClima VARCHAR(255),
                CONSTRAINT climatempo_pk PRIMARY KEY (idClimaTempo)
);
COMMENT ON COLUMN ClimaTempo.dataClima IS 'Dia referente à temperatura.';
COMMENT ON COLUMN ClimaTempo.horaClima IS 'Quando nulo, será considerado a temperatura do dia, e quando preenchido será considera a temperatura do dia e hora.  Exemplo:  dataClima: 01/01/2000 horaClima: null min: 15.00 max: 28.60  dataClima: 01/01/2000 horaClima: 09:00 min: 21.15 max: 22.30  Obs: Autorizado pelo Douglas.';
COMMENT ON COLUMN ClimaTempo.temperaturaAtual IS 'Temperatura Atual, sendo populada no próprio dia.';
COMMENT ON COLUMN ClimaTempo.temperaturaMaxima IS 'Temperatura Máxima do Dia, não do filme.';
COMMENT ON COLUMN ClimaTempo.temperaturaMinima IS 'Temperatura Mínima do Dia.';
COMMENT ON COLUMN ClimaTempo.observacao IS 'Observação sobre o clima.  Exemplo:  Parcialmente nulbado.';
COMMENT ON COLUMN ClimaTempo.umidadeAr IS 'Umidade do Ar.';
COMMENT ON COLUMN ClimaTempo.horaNascerSol IS 'Horário do Nascer do Sol.';
COMMENT ON COLUMN ClimaTempo.horaPorSol IS 'Horário do pôr do Sol.';
COMMENT ON COLUMN ClimaTempo.velocidadeVento IS 'Velocidade do Vento em km/h';
COMMENT ON COLUMN ClimaTempo.statusClima IS 'Condição do clima.  Exemplo:   ''TEMPESTADE'', ''NEVE'', ''GRANIZO'', ''CHUVA'', ''NEBLINA'', ''DIA_LIMPO'', ''NOITE_LIMPA'', ''NUBLADO'', ''DIA_NUBLADO'', ''NOITE_NUBLADA''';


ALTER SEQUENCE seq_idclimatempo OWNED BY ClimaTempo.idClimaTempo;

CREATE TABLE UsuarioErp (
                idUsuario INTEGER NOT NULL,
                nome VARCHAR(60) NOT NULL,
                email VARCHAR(255),
                idComprador INTEGER,
                CONSTRAINT usuarioerp_pk PRIMARY KEY (idUsuario)
);


CREATE TABLE TipoOperacao (
                idTipoOperacao INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                tipo CHAR(1) NOT NULL,
                categoria VARCHAR(10) NOT NULL,
                FlagMovimentaEstoque CHAR(1) NOT NULL,
                CONSTRAINT tipooperacao_pk PRIMARY KEY (idTipoOperacao)
);
COMMENT ON COLUMN TipoOperacao.tipo IS 'E-Entrada S-Saida';
COMMENT ON COLUMN TipoOperacao.categoria IS 'CMP-Compras  VEN-Vendas  BON-Bonificação DVV -Devolução de Vendas    DVC-Devolucao Compras TRA - Saidas Por Transferencia de Mercadorias entre Lojas  TRE - Entradas Por Transferencia de Mercadorias entre Lojas QBR - Quebra OUT - Outros CON - Consumo. ';
COMMENT ON COLUMN TipoOperacao.FlagMovimentaEstoque IS 'Sim ou Não';


CREATE INDEX tipooperacao_idx
 ON TipoOperacao
 ( tipo );

CREATE INDEX tipooperacao_idx1
 ON TipoOperacao
 ( tipo, categoria );

CREATE INDEX tipooperacao_idx2
 ON TipoOperacao
 ( tipo, categoria );

CREATE SEQUENCE seq_idmarca;

CREATE TABLE Marca (
                idmarca INTEGER NOT NULL DEFAULT nextval('seq_idmarca'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A',
                CONSTRAINT marca_pk PRIMARY KEY (idmarca)
);
COMMENT ON COLUMN Marca.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idmarca OWNED BY Marca.idmarca;

CREATE TABLE GrupoEconomico (
                idgrupoeconomico INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                CONSTRAINT grupoeconomico_pk PRIMARY KEY (idgrupoeconomico)
);


CREATE SEQUENCE seq_idsubfamilia;

CREATE TABLE SubFamilia (
                idsubfamilia INTEGER NOT NULL DEFAULT nextval('seq_idsubfamilia'),
                descricao VARCHAR(255) NOT NULL,
                tipoPai VARCHAR(1),
                idPai INTEGER,
                situacao CHAR(1) DEFAULT 'A',
                CONSTRAINT subfamilia_pk PRIMARY KEY (idsubfamilia)
);
COMMENT ON COLUMN SubFamilia.tipoPai IS 'Tipo do Mercadológico PAI se existir. D-DEPARTAMENTO, S-SETOR, G-GRUPO, F-FAMILIA, U-SUBFAMILIA';
COMMENT ON COLUMN SubFamilia.idPai IS 'Código do Mercadológico PAI se existir. idDepartamento, idSetor, idGrupo, idFamilia idSubFamilia';
COMMENT ON COLUMN SubFamilia.situacao IS 'A-Ativo , I-Inativo';


ALTER SEQUENCE seq_idsubfamilia OWNED BY SubFamilia.idsubfamilia;

CREATE SEQUENCE seq_idfamilia;

CREATE TABLE Familia (
                idfamilia INTEGER NOT NULL DEFAULT nextval('seq_idfamilia'),
                descricao VARCHAR(255) NOT NULL,
                tipoPai VARCHAR(1),
                idPai INTEGER,
                situacao CHAR(1) DEFAULT 'A',
                CONSTRAINT familia_pk PRIMARY KEY (idfamilia)
);
COMMENT ON COLUMN Familia.tipoPai IS 'Tipo do Mercadológico PAI se existir. D-DEPARTAMENTO, S-SETOR, G-GRUPO, F-FAMILIA, U-SUBFAMILIA';
COMMENT ON COLUMN Familia.idPai IS 'Código do Mercadológico PAI se existir. idDepartamento, idSetor, idGrupo, idFamilia idSubFamilia';
COMMENT ON COLUMN Familia.situacao IS 'A-Ativo , I-Inativo';


ALTER SEQUENCE seq_idfamilia OWNED BY Familia.idfamilia;

CREATE SEQUENCE seq_idgrupo;

CREATE TABLE Grupo (
                idgrupo INTEGER NOT NULL DEFAULT nextval('seq_idgrupo'),
                descricao VARCHAR(255) NOT NULL,
                tipoPai VARCHAR(1),
                idPai INTEGER,
                situacao CHAR(1) DEFAULT 'A',
                CONSTRAINT grupo_pk PRIMARY KEY (idgrupo)
);
COMMENT ON COLUMN Grupo.tipoPai IS 'Tipo do Mercadológico PAI se existir. D-DEPARTAMENTO, S-SETOR, G-GRUPO, F-FAMILIA, U-SUBFAMILIA';
COMMENT ON COLUMN Grupo.idPai IS 'Código do Mercadológico PAI se existir. idDepartamento, idSetor, idGrupo, idFamilia idSubFamilia';
COMMENT ON COLUMN Grupo.situacao IS 'A-Ativo , I-Inativo';


ALTER SEQUENCE seq_idgrupo OWNED BY Grupo.idgrupo;

CREATE SEQUENCE seq_idsetor;

CREATE TABLE Setor (
                idsetor INTEGER NOT NULL DEFAULT nextval('seq_idsetor'),
                descricao VARCHAR(255) NOT NULL,
                tipoPai VARCHAR(1),
                idPai INTEGER,
                situacao CHAR(1) DEFAULT 'A',
                CONSTRAINT setor_pk PRIMARY KEY (idsetor)
);
COMMENT ON COLUMN Setor.tipoPai IS 'Tipo do Mercadológico PAI se existir. D-DEPARTAMENTO, S-SETOR, G-GRUPO, F-FAMILIA, U-SUBFAMILIA';
COMMENT ON COLUMN Setor.idPai IS 'Código do Mercadológico PAI se existir. idDepartamento, idSetor, idGrupo, idFamilia idSubFamilia';
COMMENT ON COLUMN Setor.situacao IS 'A-Ativo , I-Inativo';


ALTER SEQUENCE seq_idsetor OWNED BY Setor.idsetor;

CREATE SEQUENCE seq_iddepartamento;

CREATE TABLE Departamento (
                iddepartamento INTEGER NOT NULL DEFAULT nextval('seq_iddepartamento'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A',
                CONSTRAINT departamento_pk PRIMARY KEY (iddepartamento)
);
COMMENT ON COLUMN Departamento.situacao IS 'A-Ativo , I-Inativo';


ALTER SEQUENCE seq_iddepartamento OWNED BY Departamento.iddepartamento;

CREATE SEQUENCE fornecedorprodutocadastro_idfornecedorprodutocad_seq;

CREATE TABLE FornecedorProdutoCadastro (
                idFornecedorProdutoCad INTEGER NOT NULL DEFAULT nextval('fornecedorprodutocadastro_idfornecedorprodutocad_seq'),
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                codigobarras NUMERIC(14,0),
                descricao VARCHAR(255) NOT NULL,
                ncm VARCHAR(20),
                modelo VARCHAR(50),
                pesavel CHAR(1) DEFAULT 'N',
                qtdUnEntrada NUMERIC(10,2),
                qtdMultiploVenda NUMERIC(10,2),
                unidadeentrada CHAR(2) DEFAULT 'UN',
                unidadesaida CHAR(2) DEFAULT 'UN',
                datacadastro DATE,
                dataalteracao DATE,
                idPessoaFabricante VARCHAR(128),
                idUsuarioCadastro INTEGER,
                pesoBruto NUMERIC(10,3),
                pesoLiquido NUMERIC(10,3),
                iddepartamento INTEGER,
                idsetor INTEGER,
                idgrupo INTEGER,
                idfamilia INTEGER,
                idmarca INTEGER NOT NULL,
                CONSTRAINT fornecedorprodutocadastro_pk PRIMARY KEY (idFornecedorProdutoCad)
);
COMMENT ON TABLE FornecedorProdutoCadastro IS 'Tabela com objetivo de guardar informações de cadastro de produtos novos do fornecedor.';
COMMENT ON COLUMN FornecedorProdutoCadastro.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN FornecedorProdutoCadastro.pesavel IS 'S-Sim, N-Não';
COMMENT ON COLUMN FornecedorProdutoCadastro.idPessoaFabricante IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';


ALTER SEQUENCE fornecedorprodutocadastro_idfornecedorprodutocad_seq OWNED BY FornecedorProdutoCadastro.idFornecedorProdutoCad;

CREATE INDEX fornecedorproduto_idx_codigobarras
 ON FornecedorProdutoCadastro
 ( codigoBarras );

CREATE SEQUENCE fornecedorprodutocademb_idfornecedorprodutocademb_seq;

CREATE TABLE FornecedorProdutoCadEmb (
                idFornecedorProdutoCadEmb INTEGER NOT NULL DEFAULT nextval('fornecedorprodutocademb_idfornecedorprodutocademb_seq'),
                idFornecedorProdutoCad INTEGER NOT NULL,
                codigoBarras VARCHAR(255) NOT NULL,
                unidadeEntrada VARCHAR(155),
                qtdUnEntrada NUMERIC(10,2),
                pesoBruto NUMERIC(10,3),
                pesoLiquido NUMERIC(10,3),
                CONSTRAINT fornecedorprodutocademb_pk PRIMARY KEY (idFornecedorProdutoCadEmb)
);


ALTER SEQUENCE fornecedorprodutocademb_idfornecedorprodutocademb_seq OWNED BY FornecedorProdutoCadEmb.idFornecedorProdutoCadEmb;

CREATE SEQUENCE seq_idempresa;

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
);
COMMENT ON COLUMN Empresa.situacao IS 'A-Ativa, I-Inativa';
COMMENT ON COLUMN Empresa.controlaVendas IS 'N-Não, S-Sim';
COMMENT ON COLUMN Empresa.controlaCompras IS 'N-Não, S-Sim';
COMMENT ON COLUMN Empresa.controlaEstoque IS 'N-Não, S-Sim';
COMMENT ON COLUMN Empresa.controlaPrecos IS 'N-Não, S-Sim';
COMMENT ON COLUMN Empresa.vendasDomingo IS 'N-Não, S-Sim';
COMMENT ON COLUMN Empresa.vendasSabado IS 'N-Não, S-Sim';
COMMENT ON COLUMN Empresa.dataSource IS 'Nome do datasource que está configurado no Bdotools apontando para o banco especifico da empresa. ';
COMMENT ON COLUMN Empresa.idEmpresaCadastroProduto IS 'Normalmente as empresas possuem um único cadastro para todas as empresas. Esse campo apontará para a empresa padrão de cadastro, ou se possuir mix diferente por empresa, poderá informar o valor igual ao campo idempresa.';
COMMENT ON COLUMN Empresa.caminhoCertificadoDigital IS 'Caminho onde está o certificado digital';
COMMENT ON COLUMN Empresa.tipoIntegracao IS 'ETL - Tarefas ETL, ''GAT'' - Geração de Arquivos por Terceiros';


ALTER SEQUENCE seq_idempresa OWNED BY Empresa.idempresa;

CREATE SEQUENCE seq_idlogimportacao;

CREATE TABLE LogImportacao (
                idLogImportacao INTEGER NOT NULL DEFAULT nextval('seq_idlogimportacao'),
                idempresa INTEGER NOT NULL,
                dataMovimento DATE NOT NULL,
                dataRecepArquivo DATE NOT NULL,
                horaRecepArquivo VARCHAR(6) NOT NULL,
                dataInicioImport DATE,
                horaInicioImport VARCHAR(6),
                dataFinalImport DATE,
                horaFinalImport VARCHAR(6),
                quantRegistros INTEGER DEFAULT 0 NOT NULL,
                tiposRegistros VARCHAR(1024),
                arquivo VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'N' NOT NULL,
                idExecucao INTEGER,
                mensagem VARCHAR(16384),
                CONSTRAINT logimportacao_pk PRIMARY KEY (idLogImportacao)
);
COMMENT ON COLUMN LogImportacao.situacao IS 'N-Não Importado, P-Processando, I-Importado, E-Erro na Importação, C-Cancelado';


ALTER SEQUENCE seq_idlogimportacao OWNED BY LogImportacao.idLogImportacao;

CREATE INDEX logimportacao_idx1
 ON LogImportacao
 ( idEmpresa, dataMovimento );

CREATE SEQUENCE seq_idlogreenvio;

CREATE TABLE LogReenvio (
                idLogReenvio INTEGER NOT NULL DEFAULT nextval('seq_idlogreenvio'),
                dataSolicitacao DATE NOT NULL,
                horaSolicitacao VARCHAR(6) NOT NULL,
                apelidoTarefaSolicitacao VARCHAR(255),
                idUsuarioSolicitacao INTEGER,
                situacao CHAR(1) DEFAULT 'P' NOT NULL,
                idempresa INTEGER NOT NULL,
                tipoRegistro VARCHAR(255) NOT NULL,
                dataParaReenvio DATE,
                idLogImportacao INTEGER NOT NULL,
                CONSTRAINT logreenvio_pk PRIMARY KEY (idLogReenvio)
);
COMMENT ON COLUMN LogReenvio.situacao IS 'P-Pendente, R-Reenviado';


ALTER SEQUENCE seq_idlogreenvio OWNED BY LogReenvio.idLogReenvio;

CREATE SEQUENCE seq_idsolicitacaosuprimentoetapacfg;

CREATE TABLE SolicitacaoSuprimentoEtapaCfg (
                idSolicitacaoSuprimentoEtapaCfg INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimentoetapacfg'),
                idSolicitacaoSuprimentoEtapa INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                horasLimite NUMERIC(15,2),
                CONSTRAINT solicitacaosuprimentoetapacfg_pk PRIMARY KEY (idSolicitacaoSuprimentoEtapaCfg)
);


ALTER SEQUENCE seq_idsolicitacaosuprimentoetapacfg OWNED BY SolicitacaoSuprimentoEtapaCfg.idSolicitacaoSuprimentoEtapaCfg;

CREATE SEQUENCE seq_idittabelaprecointegracao;

CREATE TABLE ItTabelaPrecoIntegracao (
                idItTabelaPrecoIntegracao INTEGER NOT NULL DEFAULT nextval('seq_idittabelaprecointegracao'),
                idIntegracaoTerceiro INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                idItTabelaPrecoErp VARCHAR(128) NOT NULL,
                codigoItTabelaPrecoIntegracao VARCHAR(128),
                CONSTRAINT ittabelaprecointegracao_pk PRIMARY KEY (idItTabelaPrecoIntegracao)
);
COMMENT ON TABLE ItTabelaPrecoIntegracao IS 'Armazena as tabelas de preço por integração e empresa';
COMMENT ON COLUMN ItTabelaPrecoIntegracao.codigoItTabelaPrecoIntegracao IS 'Código da Tabela de Preço na Integração (API)';


ALTER SEQUENCE seq_idittabelaprecointegracao OWNED BY ItTabelaPrecoIntegracao.idItTabelaPrecoIntegracao;

CREATE SEQUENCE seq_idvalepresentemovimento;

CREATE TABLE ValePresenteMovimento (
                idValePresenteMovimento INTEGER NOT NULL DEFAULT nextval('seq_idvalepresentemovimento'),
                idValePresente INTEGER NOT NULL,
                valorUnitario NUMERIC(15,2) NOT NULL,
                tipoValor VARCHAR(1) DEFAULT 'V' NOT NULL,
                valor NUMERIC(15,2) NOT NULL,
                situacao VARCHAR(1) DEFAULT 'I' NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(10) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                dataAtivacao DATE,
                horaAtivacao VARCHAR(10),
                idUsuarioAtivacao INTEGER,
                idEmpresaAtivacao INTEGER,
                integradoAtivacao VARCHAR(1),
                dataUtilizacao DATE,
                horaUtilizacao VARCHAR(10),
                idUsuarioUtilizacao INTEGER,
                idEmpresaUtilizacao INTEGER,
                CONSTRAINT valepresentemovimento_pk PRIMARY KEY (idValePresenteMovimento)
);
COMMENT ON TABLE ValePresenteMovimento IS 'Um vale presente em certos casos podem ser reutilizados, então essa tabela registra todo o histórico de um vale presente.';
COMMENT ON COLUMN ValePresenteMovimento.valorUnitario IS 'Preço do Vale (valor de compra, ou seja, valor que o cliente vai pagar para adquirir o mesmo)';
COMMENT ON COLUMN ValePresenteMovimento.tipoValor IS 'V-Valor, P-Percentual. Qual o tipo de "desconto" que será aplicado com o vale.';
COMMENT ON COLUMN ValePresenteMovimento.situacao IS 'I-Incluído, A-Ativado, U-Utilizado';
COMMENT ON COLUMN ValePresenteMovimento.integradoAtivacao IS 'Se foi integrado a ativação. S ou N.';


ALTER SEQUENCE seq_idvalepresentemovimento OWNED BY ValePresenteMovimento.idValePresenteMovimento;

CREATE SEQUENCE seq_idvalepresentemovimentoformapagamento;

CREATE TABLE ValePresenteMovimentoFormaPagamento (
                idValePresenteMovimentoFormaPagamento INTEGER NOT NULL DEFAULT nextval('seq_idvalepresentemovimentoformapagamento'),
                idValePresenteMovimento INTEGER NOT NULL,
                idFormaPagamento INTEGER NOT NULL,
                valor NUMERIC(15,2) NOT NULL,
                nsu VARCHAR(128),
                CONSTRAINT valepresentemovimentoformapagamento_pk PRIMARY KEY (idValePresenteMovimentoFormaPagamento)
);
COMMENT ON TABLE ValePresenteMovimentoFormaPagamento IS 'Uma venda de vale presente pode ser paga com muitas formas de pagamento.';
COMMENT ON COLUMN ValePresenteMovimentoFormaPagamento.valor IS 'Valor pago em cada forma de pagamento para totalizar o valor do vale presente.';
COMMENT ON COLUMN ValePresenteMovimentoFormaPagamento.nsu IS 'Sendo necessário, pode-se informar o NSU da compra quando feito via cartão de crédito ou débito.';


ALTER SEQUENCE seq_idvalepresentemovimentoformapagamento OWNED BY ValePresenteMovimentoFormaPagamento.idValePresenteMovimentoFormaPagamento;

CREATE TABLE PromocaoOfertaEmpresa (
                idPromocaoOferta INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                situacao VARCHAR(1) NOT NULL,
                idUsuarioCadastro INTEGER NOT NULL,
                dataCadastro DATE NOT NULL,
                idUsuarioAlteracao INTEGER,
                dataAlteracao DATE,
                CONSTRAINT promocaoofertaempresa_pk PRIMARY KEY (idPromocaoOferta, idempresa)
);
COMMENT ON TABLE PromocaoOfertaEmpresa IS 'Empresas que participarão da promoção. ';
COMMENT ON COLUMN PromocaoOfertaEmpresa.situacao IS 'A-Ativo, I-Inativo';


CREATE SEQUENCE seq_idarquivogedtipodoc;

CREATE TABLE ArquivoGedTipoDoc (
                idArquivoGedTipoDoc INTEGER NOT NULL DEFAULT nextval('seq_idarquivogedtipodoc'),
                descricao VARCHAR(256) NOT NULL,
                situacao CHAR(1) NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                idempresa INTEGER,
                CONSTRAINT arquivogedtipodoc_pk PRIMARY KEY (idArquivoGedTipoDoc)
);
COMMENT ON TABLE ArquivoGedTipoDoc IS 'Tipos de Documentos: Recibo, Duplicada, Boleto, Nota Fiscal, Imagem ';
COMMENT ON COLUMN ArquivoGedTipoDoc.situacao IS 'A-Ativo ou I-Inativo';


ALTER SEQUENCE seq_idarquivogedtipodoc OWNED BY ArquivoGedTipoDoc.idArquivoGedTipoDoc;

CREATE SEQUENCE seq_idarquivoged;

CREATE TABLE ArquivoGed (
                idArquivoGed INTEGER NOT NULL DEFAULT nextval('seq_idarquivoged'),
                descricao VARCHAR(256) NOT NULL,
                chave VARCHAR(512),
                situacao CHAR(1) NOT NULL,
                origemRegistro VARCHAR(256) NOT NULL,
                idempresa INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                CONSTRAINT arquivoged_pk PRIMARY KEY (idArquivoGed)
);
COMMENT ON TABLE ArquivoGed IS 'Arquivamento de Documentos Eletronicos.';
COMMENT ON COLUMN ArquivoGed.chave IS 'Identificação do registro de origem no Erp ou em outro sistema ou plataforma.  ';
COMMENT ON COLUMN ArquivoGed.situacao IS 'A-Ativo ou I-Inativo';
COMMENT ON COLUMN ArquivoGed.origemRegistro IS 'Identificação de qual Tarefa ou Recurso veio a inclusão dessas informações. ';


ALTER SEQUENCE seq_idarquivoged OWNED BY ArquivoGed.idArquivoGed;

CREATE INDEX arquivoged_idx_chave
 ON ArquivoGed
 ( chave );

CREATE SEQUENCE seq_idarquivogedmidia;

CREATE TABLE ArquivoGedMidia (
                idArquivoGedMidia INTEGER NOT NULL DEFAULT nextval('seq_idarquivogedmidia'),
                idArquivoGed INTEGER NOT NULL,
                chave VARCHAR(512),
                descricao VARCHAR(255) NOT NULL,
                nomeMidia VARCHAR(255) NOT NULL,
                midia BYTEA,
                extensaoMidia VARCHAR(32),
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                situacao CHAR(1) NOT NULL,
                idArquivoGedTipoDoc INTEGER NOT NULL,
                CONSTRAINT arquivogedmidia_pk PRIMARY KEY (idArquivoGedMidia)
);
COMMENT ON COLUMN ArquivoGedMidia.chave IS 'Identificação do registro de origem no Erp ou em outro sistema ou plataforma.  ';
COMMENT ON COLUMN ArquivoGedMidia.situacao IS 'A-Ativo ou I-Inativo';


ALTER SEQUENCE seq_idarquivogedmidia OWNED BY ArquivoGedMidia.idArquivoGedMidia;

CREATE INDEX arquivogedmidia_idx_datainclusao_tipodoc
 ON ArquivoGedMidia
 ( dataInclusao, idArquivoGedTipoDoc );

CREATE INDEX arquivogedmidia_idx_chave
 ON ArquivoGedMidia
 ( chave );

CREATE TABLE ItMercadologico (
                idempresa INTEGER NOT NULL,
                idItMercadologicoErp VARCHAR(128) NOT NULL,
                nivelMercadologico INTEGER NOT NULL,
                descricao VARCHAR(1024) NOT NULL,
                idItMercadologicoErpPai VARCHAR(128),
                nivelMercadologicoPai INTEGER,
                CONSTRAINT itmercadologico_pk PRIMARY KEY (idempresa, idItMercadologicoErp, nivelMercadologico)
);
COMMENT ON COLUMN ItMercadologico.nivelMercadologico IS '1-Departamento, 2-Setor, 3-Grupo,  4-Familia,  5-Subfamilia ';
COMMENT ON COLUMN ItMercadologico.idItMercadologicoErpPai IS 'Caso existir informação do mercadológico acima (pai).';
COMMENT ON COLUMN ItMercadologico.nivelMercadologicoPai IS 'Caso existir informação do mercadológico acima (pai).';


CREATE SEQUENCE seq_iditmercadologicointegracao;

CREATE TABLE ItMercadologicoIntegracao (
                idItMercadologicoIntegracao INTEGER NOT NULL DEFAULT nextval('seq_iditmercadologicointegracao'),
                idIntegracaoTerceiro INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                idItMercadologicoErp VARCHAR(128) NOT NULL,
                nivelMercadologico INTEGER NOT NULL,
                codigoItMercadologicoIntegracao VARCHAR(128) NOT NULL,
                CONSTRAINT itmercadologicointegracao_pk PRIMARY KEY (idItMercadologicoIntegracao)
);
COMMENT ON COLUMN ItMercadologicoIntegracao.nivelMercadologico IS '1-Departamento, 2-Setor, 3-Grupo,  4-Familia,  5-Subfamilia ';


ALTER SEQUENCE seq_iditmercadologicointegracao OWNED BY ItMercadologicoIntegracao.idItMercadologicoIntegracao;

CREATE SEQUENCE seq_idressupdiasreposicao;

CREATE TABLE RessupDiasReposicao (
                idRessupDiasReposicao INTEGER NOT NULL DEFAULT nextval('seq_idressupdiasreposicao'),
                idempresa INTEGER NOT NULL,
                idMercadologico VARCHAR(255) NOT NULL,
                tipoMercadologico CHAR(1) NOT NULL,
                semanaExecucao INTEGER,
                tipoIntervalo VARCHAR(128) NOT NULL,
                diaExecucao VARCHAR(12345),
                CONSTRAINT ressupdiasreposicao_pk PRIMARY KEY (idRessupDiasReposicao)
);
COMMENT ON TABLE RessupDiasReposicao IS 'Dias/Periodo para gerar reposição (geracao de pedidos)';
COMMENT ON COLUMN RessupDiasReposicao.tipoMercadologico IS 'D-Departamento, S-Seção, G-Grupo, B-Subgrupo, P-Produto, V-Vendedor';
COMMENT ON COLUMN RessupDiasReposicao.tipoIntervalo IS 'Nome do atributo da tabela Data.  Ex:   agrupamento diário: = a ddmmaaaa   agrupamento semanal: = a semanaano';


ALTER SEQUENCE seq_idressupdiasreposicao OWNED BY RessupDiasReposicao.idRessupDiasReposicao;

CREATE SEQUENCE seq_idressupparammercadologico;

CREATE TABLE RessupParamMercadologico (
                idRessupParamMercadologico INTEGER NOT NULL DEFAULT nextval('seq_idressupparammercadologico'),
                idempresa INTEGER NOT NULL,
                idMercadologico VARCHAR(255) NOT NULL,
                tipoMercadologico CHAR(1) NOT NULL,
                quantEstoqueMinimo NUMERIC(15,3),
                diasEstoqueReposicao INTEGER,
                diasEstoqueMaximo INTEGER,
                gramaturaentrada NUMERIC(15,3),
                perCrescimento NUMERIC(10,2),
                processaGramatura CHAR(1),
                CONSTRAINT ressupparammercadologico_pk PRIMARY KEY (idRessupParamMercadologico)
);
COMMENT ON COLUMN RessupParamMercadologico.tipoMercadologico IS 'D-Departamento, S-Seção, G-Grupo, B-Subgrupo, P-Produto, V-Vendedor';
COMMENT ON COLUMN RessupParamMercadologico.processaGramatura IS 'N - NAO S - SIM';


ALTER SEQUENCE seq_idressupparammercadologico OWNED BY RessupParamMercadologico.idRessupParamMercadologico;

CREATE INDEX ressupparammercadologico_idx_tipomercadologico
 ON RessupParamMercadologico
 ( idEmpresa, tipoMercadologico );

CREATE INDEX ressupparammercadologico_idx
 ON RessupParamMercadologico
 ( idMercadologico );

CREATE SEQUENCE seq_iditformapagamento;

CREATE TABLE ItFormaPagamento (
                idItFormaPagamento INTEGER NOT NULL DEFAULT nextval('seq_iditformapagamento'),
                idempresa INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                idItFormaPagamentoErp VARCHAR(128),
                codigoItFormaPagamentoIntegracao VARCHAR(1024),
                dataInclusao DATE NOT NULL,
                dataAlteracao DATE,
                situacao CHAR(1),
                idIntegracaoTerceiro INTEGER NOT NULL,
                CONSTRAINT itformapagamento_pk PRIMARY KEY (idItFormaPagamento)
);
COMMENT ON COLUMN ItFormaPagamento.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_iditformapagamento OWNED BY ItFormaPagamento.idItFormaPagamento;

CREATE SEQUENCE seq_iditempresa;

CREATE TABLE ItEmpresa (
                idItEmpresa INTEGER NOT NULL DEFAULT nextval('seq_iditempresa'),
                idempresa INTEGER NOT NULL,
                codigoItEmpresaIntegracao VARCHAR(255),
                idIntegracaoTerceiro INTEGER NOT NULL,
                urlIntegracao VARCHAR(1024),
                tokenIntegracao VARCHAR(12345),
                urlErp VARCHAR(1024),
                tokenErp VARCHAR(12345),
                situacao CHAR(1) DEFAULT 'A',
                tipoErp VARCHAR(128),
                CONSTRAINT itempresa_pk PRIMARY KEY (idItEmpresa)
);
COMMENT ON COLUMN ItEmpresa.codigoItEmpresaIntegracao IS 'Código da Empresa ref. na Integracao. ';
COMMENT ON COLUMN ItEmpresa.situacao IS 'A -> Ativo | I -> Inativo';
COMMENT ON COLUMN ItEmpresa.tipoErp IS 'ERP que será utilizado na integração da empresa em si, podendo uma empresa ter mais que uma integração com outros erps.';


ALTER SEQUENCE seq_iditempresa OWNED BY ItEmpresa.idItEmpresa;

CREATE SEQUENCE seq_iditpessoa;

CREATE TABLE ItPessoa (
                idItPessoa INTEGER NOT NULL DEFAULT nextval('seq_iditpessoa'),
                idempresa INTEGER NOT NULL,
                cpfcnpj VARCHAR(14),
                nome VARCHAR(255) NOT NULL,
                dataAlteracao DATE,
                dataInclusao DATE NOT NULL,
                idItPessoaErp VARCHAR(128),
                fornecedor CHAR(1),
                cliente CHAR(1),
                tipoPessoa CHAR(1) NOT NULL,
                email VARCHAR(255),
                cep VARCHAR(8),
                endereco VARCHAR(255),
                numero VARCHAR(128),
                complemento VARCHAR(255),
                bairro VARCHAR(255),
                cidade VARCHAR(255),
                estado VARCHAR(2),
                telefone VARCHAR(32),
                CONSTRAINT itpessoa_pk PRIMARY KEY (idItPessoa)
);
COMMENT ON COLUMN ItPessoa.tipoPessoa IS 'F-Física,  J-Jurídica. ';
COMMENT ON COLUMN ItPessoa.estado IS 'uf';


ALTER SEQUENCE seq_iditpessoa OWNED BY ItPessoa.idItPessoa;

CREATE SEQUENCE seq_iditcobranca;

CREATE TABLE ItCobranca (
                idItCobranca INTEGER NOT NULL DEFAULT nextval('seq_iditcobranca'),
                idIntegracaoTerceiro INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                idItPessoa INTEGER NOT NULL,
                idItCobrancaErp VARCHAR(128),
                idItCobrancaIntegracao VARCHAR(128),
                tipoCobranca VARCHAR(32) DEFAULT 'BOLETO' NOT NULL,
                dataEmissao DATE,
                dataVencimento DATE,
                dataRecebimento DATE,
                valorOriginal NUMERIC(15,2),
                valorAbatimento NUMERIC(15,2),
                valorRecebido NUMERIC(15,2),
                valorMultaRecebido NUMERIC(15,2),
                mensagemBloquetoOcorrencia VARCHAR(255),
                codigoBarras VARCHAR(128),
                nossoNumeroBanco VARCHAR(128),
                codigoLinhaDigitavel VARCHAR(255),
                situacao VARCHAR(1) DEFAULT 'A' NOT NULL,
                percJuros NUMERIC(15,4),
                percMulta NUMERIC(15,4),
                pixChave VARCHAR(255),
                qrCodeUrl VARCHAR(255),
                qrCodeTxId VARCHAR(255),
                qrCodeEmv VARCHAR(255),
                dataGeracaoQrCode DATE,
                horaGeracaoQrCode VARCHAR(10),
                pixTextoRetorno VARCHAR(255),
                notificado VARCHAR(1) DEFAULT 'N',
                dataNotificacao DATE,
                horaNotificacao VARCHAR(10),
                idInstituicaoFinanceira INTEGER,
                CONSTRAINT itcobranca_pk PRIMARY KEY (idItCobranca)
);
COMMENT ON TABLE ItCobranca IS 'Tabela contendo as cobranças vindas do ERP (Boleto, Cartão, etc..) que serão destinadas as APIs.';
COMMENT ON COLUMN ItCobranca.idItCobrancaErp IS 'Código da cobrança no ERP';
COMMENT ON COLUMN ItCobranca.idItCobrancaIntegracao IS 'Código da cobrança na API';
COMMENT ON COLUMN ItCobranca.tipoCobranca IS 'Tipo da Cobrança. Ex: BOLETO, PIX.';
COMMENT ON COLUMN ItCobranca.dataEmissao IS 'Descrição feita com base na API do BB: ';
COMMENT ON COLUMN ItCobranca.dataVencimento IS 'Descrição feita com base na API do BB: Data de vencimento do boleto  ';
COMMENT ON COLUMN ItCobranca.dataRecebimento IS 'Descrição feita com base na API do BB: Data para a qual foi agendado o recebimento/pagamento do título.';
COMMENT ON COLUMN ItCobranca.valorOriginal IS 'Descrição feita com base na API do BB: Valor do boleto no registro.';
COMMENT ON COLUMN ItCobranca.valorAbatimento IS 'Descrição feita com base na API do BB: Valor de dedução da cobrança  ';
COMMENT ON COLUMN ItCobranca.valorRecebido IS 'Descrição feita com base na API do BB: Valor pago pelo pagador/sacado';
COMMENT ON COLUMN ItCobranca.valorMultaRecebido IS 'Valor de multa recebido.  ';
COMMENT ON COLUMN ItCobranca.mensagemBloquetoOcorrencia IS 'Descrição feita com base na API do BB: Mensagem definida pelo beneficiário para ser impressa no boleto. (Limitado a 30 caracteres na API BB)';
COMMENT ON COLUMN ItCobranca.codigoBarras IS 'Código de barras do boleto. Ex: 00191856400000199000000001557684000009481917';
COMMENT ON COLUMN ItCobranca.nossoNumeroBanco IS 'Descrição feita com base na API do BB: Número de identificação do boleto (correspondente ao NOSSO NÚMERO), no formato STRING, com 20 dígitos, que deverá ser formatado da seguinte forma: “000” + (número do convênio com 7 dígitos) + (10 algarismos - se necessário, completar com zeros à esquerda).';
COMMENT ON COLUMN ItCobranca.codigoLinhaDigitavel IS 'Campo correpondente à linha digitável do boleto.  ';
COMMENT ON COLUMN ItCobranca.situacao IS 'A->Aberto | F->Fechado';
COMMENT ON COLUMN ItCobranca.notificado IS 'Se foi notificado sobre a cobrança. S,N';
COMMENT ON COLUMN ItCobranca.dataNotificacao IS 'Data em que foi notificado sobre a cobrança.';
COMMENT ON COLUMN ItCobranca.horaNotificacao IS 'Hora em que foi notificado sobre a cobrança.';


ALTER SEQUENCE seq_iditcobranca OWNED BY ItCobranca.idItCobranca;

CREATE SEQUENCE seq_iditpessoaintegracao;

CREATE TABLE ItPessoaIntegracao (
                idItPessoaIntegracao INTEGER NOT NULL DEFAULT nextval('seq_iditpessoaintegracao'),
                idItPessoa INTEGER NOT NULL,
                idIntegracaoTerceiro INTEGER NOT NULL,
                codigoItPessoaIntegracao VARCHAR(128),
                CONSTRAINT itpessoaintegracao_pk PRIMARY KEY (idItPessoaIntegracao)
);


ALTER SEQUENCE seq_iditpessoaintegracao OWNED BY ItPessoaIntegracao.idItPessoaIntegracao;

CREATE SEQUENCE seq_iditpedidovenda;

CREATE TABLE itPedidoVenda (
                idItPedidoVenda BIGINT NOT NULL DEFAULT nextval('seq_iditpedidovenda'),
                idempresa INTEGER NOT NULL,
                codigoItPedidoVendaIntegracao VARCHAR(128) NOT NULL,
                codigoItPedidoVendaIntegracaoLegivel VARCHAR(128),
                idItPedidoVendaErp VARCHAR(128),
                dataMovimento DATE NOT NULL,
                horaMovimento VARCHAR(10),
                dataAlteracao DATE,
                idItPessoa INTEGER,
                cpfcnpj VARCHAR(14),
                situacao VARCHAR(10),
                situacaoErp VARCHAR(128),
                idIntegracaoTerceiro INTEGER NOT NULL,
                integrado CHAR(1) DEFAULT 'N',
                cepEntrega VARCHAR(8),
                enderecoEntrega VARCHAR(255),
                numeroEntrega VARCHAR(128),
                complementoEntrega VARCHAR(255),
                bairroEntrega VARCHAR(255),
                cidadeEntrega VARCHAR(255),
                estadoEntrega VARCHAR(2),
                valorFrete NUMERIC(15,2),
                conferido CHAR(1),
                observacao VARCHAR(2048),
                valorTotalLiquido NUMERIC(15,2),
                dataPrevisaoEntrega DATE,
                horaPrevisaoEntregaInicial VARCHAR(10),
                datasituacao DATE,
                horasituacao VARCHAR(10),
                horaPrevisaoEntregaFinal VARCHAR(10),
                cpfCnpjObrigatorio VARCHAR(1),
                retirada VARCHAR(1),
                dataNotificacao DATE,
                horaNotificacao VARCHAR(10),
                quantidadeNotificacao INTEGER DEFAULT 0,
                usuarioGravacao VARCHAR(100),
                idUsuarioVendedorErp VARCHAR(100),
                CONSTRAINT itpedidovenda_pk PRIMARY KEY (idItPedidoVenda)
);
COMMENT ON TABLE itPedidoVenda IS 'Pedidos de vendas quando e-commerce';
COMMENT ON COLUMN itPedidoVenda.codigoItPedidoVendaIntegracaoLegivel IS 'Em algumas integrações é comum ter o código principal um hash UHDASD8ASE28EH12980128WJ1JSX01US08U120S102J08S12JS12012, mas o código exibido para o cliente e usuário sendo um simples 2258, este deve ser informado aqui. Obs: caso o "2258" seja o código utilizado nas requisições da API, pode-se informar no codigoItPedidoVendaIntegracao.';
COMMENT ON COLUMN itPedidoVenda.idItPedidoVendaErp IS 'Numero do pedido de que foi gerado no Erp após exportação do Site para o Bridge, e Bridge para o Erp. ';
COMMENT ON COLUMN itPedidoVenda.horaMovimento IS 'Hora em que foi feito o pedido';
COMMENT ON COLUMN itPedidoVenda.cpfcnpj IS 'Documento da pessoa destinada a venda.';
COMMENT ON COLUMN itPedidoVenda.situacao IS 'A-Aberto (não usar mais este campo, considere P), C-Cancelado, P-Pendente, F->Finalizado, NE-> Nota Emitida';
COMMENT ON COLUMN itPedidoVenda.situacaoErp IS 'Situação do pedido no ERP (palavras chaves internas), quando necessário.';
COMMENT ON COLUMN itPedidoVenda.integrado IS 'S-Sim, N-Não.   ';
COMMENT ON COLUMN itPedidoVenda.estadoEntrega IS 'uf';
COMMENT ON COLUMN itPedidoVenda.valorFrete IS 'Valor do Frete cobrado no e-commerce. Frete de entrega. ';
COMMENT ON COLUMN itPedidoVenda.conferido IS 'S-Sim, N-Não';
COMMENT ON COLUMN itPedidoVenda.valorTotalLiquido IS 'Valor total liquido dos produtos já com desconto. ';
COMMENT ON COLUMN itPedidoVenda.cpfCnpjObrigatorio IS 'Considera-se como CPF na Nota? S-Sim, N-Não, vale para obrigatoriedade do CNPJ também.';
COMMENT ON COLUMN itPedidoVenda.retirada IS 'Se é retirada na loja. S-Sim, N-Não.';
COMMENT ON COLUMN itPedidoVenda.dataNotificacao IS 'Data em que foi notificado o pedido para o cliente.';
COMMENT ON COLUMN itPedidoVenda.quantidadeNotificacao IS 'Quantidade de vezes que foi notificado o cliente. Caso haja alteração no status do pedido, podemos notificar mais de uma vez, comparando a data e hora notificação, com isso este campo vai conter valores como 1, 2, 3, 4..........';


ALTER SEQUENCE seq_iditpedidovenda OWNED BY itPedidoVenda.idItPedidoVenda;

CREATE SEQUENCE seq_iditpedidovendaformapagamento;

CREATE TABLE ItPedidoVendaFormaPagamento (
                idItPedidoVendaFormaPagamento INTEGER NOT NULL DEFAULT nextval('seq_iditpedidovendaformapagamento'),
                idItPedidoVenda BIGINT NOT NULL,
                idItFormaPagamento INTEGER NOT NULL,
                valor NUMERIC(15,2),
                dataVencimento DATE,
                CONSTRAINT itpedidovendaformapagamento_pk PRIMARY KEY (idItPedidoVendaFormaPagamento)
);
COMMENT ON TABLE ItPedidoVendaFormaPagamento IS 'Formas de Pagamentos do Pedido de Venda. ';


ALTER SEQUENCE seq_iditpedidovendaformapagamento OWNED BY ItPedidoVendaFormaPagamento.idItPedidoVendaFormaPagamento;

CREATE TABLE ItProduto (
                idempresa INTEGER NOT NULL,
                idItProdutoErp VARCHAR(255) NOT NULL,
                idItMarcaErp VARCHAR(128),
                situacao CHAR(1) NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                valorPrecoVenda NUMERIC(15,3) NOT NULL,
                valorPrecoVendaPromocao NUMERIC(15,3),
                dataInclusao DATE NOT NULL,
                dataAlteracao DATE NOT NULL,
                horaAlteracao VARCHAR(10),
                codigoBarras NUMERIC(14,0),
                modelo VARCHAR(255),
                saldoEstoque NUMERIC(15,3) NOT NULL,
                pesoBruto NUMERIC(15,4) NOT NULL,
                pesoLiquido NUMERIC(15,4) NOT NULL,
                unidadeSaida VARCHAR(2) NOT NULL,
                caminhoImagens VARCHAR(1024),
                quantidadeEmbalagemSaida NUMERIC(10,3),
                dataAlteracaoPrecoVenda DATE,
                horaAlteracaoPrecoVenda VARCHAR(10),
                dataAlteracaoEstoque DATE,
                horaAlteracaoEstoque VARCHAR(10),
                altura INTEGER,
                largura INTEGER,
                comprimento INTEGER,
                CONSTRAINT itproduto_pk PRIMARY KEY (idempresa, idItProdutoErp)
);
COMMENT ON COLUMN ItProduto.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN ItProduto.altura IS 'Em centímetros';
COMMENT ON COLUMN ItProduto.largura IS 'Em centímetros';
COMMENT ON COLUMN ItProduto.comprimento IS 'Em centímetros';


CREATE TABLE itTabelaPrecoItProduto (
                idItTabelaPrecoErp VARCHAR(128) NOT NULL,
                idempresa INTEGER NOT NULL,
                idItProdutoErp VARCHAR(255) NOT NULL,
                valorPrecoVenda NUMERIC(15,3) NOT NULL,
                precoVendaPromocao NUMERIC(15,3),
                mensagem1 VARCHAR(255),
                dataValidade DATE,
                codigoItTabelaPrecoItProdutoIntegracao VARCHAR(128),
                CONSTRAINT ittabelaprecoitproduto_pk PRIMARY KEY (idItTabelaPrecoErp, idempresa, idItProdutoErp)
);
COMMENT ON COLUMN itTabelaPrecoItProduto.codigoItTabelaPrecoItProdutoIntegracao IS 'Código da Tabela de Preço Produto na Integração (API).';


CREATE TABLE ItProdutoMercadologico (
                idItProdutoErp VARCHAR(255) NOT NULL,
                idItMercadologicoErp VARCHAR(128) NOT NULL,
                nivelItMercadologico INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                CONSTRAINT itprodutomercadologico_pk PRIMARY KEY (idItProdutoErp, idItMercadologicoErp, nivelItMercadologico, idempresa)
);
COMMENT ON TABLE ItProdutoMercadologico IS 'Ligacao do produto com o mercadologico ';
COMMENT ON COLUMN ItProdutoMercadologico.nivelItMercadologico IS '1-Departamento, 2-Setor, 3-Grupo,  4-Familia,  5-Subfamilia ';


CREATE SEQUENCE seq_iditprodutointegracao;

CREATE TABLE ItProdutoIntegracao (
                idItProdutoIntegracao BIGINT NOT NULL DEFAULT nextval('seq_iditprodutointegracao'),
                idIntegracaoTerceiro INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                idItProdutoErp VARCHAR(255) NOT NULL,
                codigoItProdutoIntegracao VARCHAR(255),
                integrado CHAR(1) DEFAULT 'N' NOT NULL,
                codigoItCategoriaIntegracao VARCHAR(128),
                descricaoEspecialProduto VARCHAR(255),
                percPrecoNormal NUMERIC(15,6),
                precoEspecialProduto NUMERIC(15,3),
                precoEspecialPromocaoProduto NUMERIC(15,3),
                dataInicioPromocao DATE,
                dataFimPromocao DATE,
                dataAlteracao DATE,
                horaAlteracao VARCHAR(10),
                usuarioAlteracao VARCHAR(128),
                informacoesAdicionais VARCHAR(12345),
                dataAlteracaoPrecoEspecialProduto DATE,
                horaAlteracaoPrecoEspecialProduto VARCHAR(10),
                CONSTRAINT itprodutointegracao_pk PRIMARY KEY (idItProdutoIntegracao)
);
COMMENT ON TABLE ItProdutoIntegracao IS 'Lista de Produtos que serão enviados para integracao. ';
COMMENT ON COLUMN ItProdutoIntegracao.codigoItProdutoIntegracao IS 'Código do Produto ref. na Integracao. ';
COMMENT ON COLUMN ItProdutoIntegracao.integrado IS 'S-Sim, N-Nao. Identifica se já foi integrado ou NÃO. ';
COMMENT ON COLUMN ItProdutoIntegracao.descricaoEspecialProduto IS 'Descrição utilizada para produtos que possuem uma gramatura diferente do produto que está no Erp e é vendido em loja. Ex. Laranja na loja é vendido por Kg, já no site é unidade de x gramas.  Essa descrição se for informada, deverá subir para o Site sobrepondo a descrição do Erp. ';
COMMENT ON COLUMN ItProdutoIntegracao.percPrecoNormal IS 'Se informado pelo usuário, deverá subir o preco para o site, realizando o calculo de proporção sobre o preco que for localizado no ERP. ';
COMMENT ON COLUMN ItProdutoIntegracao.precoEspecialProduto IS 'Preco utilizado para atender produtos que possuem um preco diferente do Erp, e que não é possível registrar tal valor direto no Erp do cliente. ';
COMMENT ON COLUMN ItProdutoIntegracao.precoEspecialPromocaoProduto IS 'Preco utilizado para atender produtos que possuem um preco diferente do Erp, que esteja em promoção, e que não é possível registrar tal valor direto no Erp do cliente. ';
COMMENT ON COLUMN ItProdutoIntegracao.informacoesAdicionais IS 'Campo destinado a utilização de demais regras presenciadas pela integração  Ex: DBJStore, será utilizado campos para definir a integração das chamadas.';


ALTER SEQUENCE seq_iditprodutointegracao OWNED BY ItProdutoIntegracao.idItProdutoIntegracao;

CREATE SEQUENCE seq_iditpedidovendaitens;

CREATE TABLE itPedidoVendaItens (
                idItPedidoVendaItens BIGINT NOT NULL DEFAULT nextval('seq_iditpedidovendaitens'),
                idItPedidoVenda BIGINT NOT NULL,
                idItProdutoIntegracao BIGINT NOT NULL,
                quantidade NUMERIC(16,4) NOT NULL,
                valorTabela NUMERIC(15,2),
                percDesconto NUMERIC(15,2),
                valorDesconto NUMERIC(15,2),
                valorTotal NUMERIC(16,2) NOT NULL,
                CONSTRAINT itpedidovendaitens_pk PRIMARY KEY (idItPedidoVendaItens)
);


ALTER SEQUENCE seq_iditpedidovendaitens OWNED BY itPedidoVendaItens.idItPedidoVendaItens;

CREATE SEQUENCE seq_iditpedidovendaitensgrade;

CREATE TABLE ItPedidoVendaItensGrade (
                idItPedidoVendaItensGrade INTEGER NOT NULL DEFAULT nextval('seq_iditpedidovendaitensgrade'),
                idItPedidoVendaItens BIGINT NOT NULL,
                idItProdutoIntegracao BIGINT NOT NULL,
                quantidade NUMERIC(16,4) NOT NULL,
                valorTotal NUMERIC(16,2) NOT NULL,
                CONSTRAINT itpedidovendaitensgrade_pk PRIMARY KEY (idItPedidoVendaItensGrade)
);
COMMENT ON TABLE ItPedidoVendaItensGrade IS 'Tecnicamante, os subitens dos itens. Ex: Item Refri, grade Coca, Guarana, Fanta, etc...';


ALTER SEQUENCE seq_iditpedidovendaitensgrade OWNED BY ItPedidoVendaItensGrade.idItPedidoVendaItensGrade;

CREATE SEQUENCE seq_iditpedidovendaitensconferencia;

CREATE TABLE ItPedidoVendaItensConferencia (
                idItPedidoVendaItensConferencia INTEGER NOT NULL DEFAULT nextval('seq_iditpedidovendaitensconferencia'),
                idItPedidoVendaItens BIGINT NOT NULL,
                dataInclusao DATE NOT NULL,
                usuarioInclusao VARCHAR(128),
                horaInclusao VARCHAR(10) NOT NULL,
                quantidade NUMERIC(15,3),
                CONSTRAINT itpedidovendaitensconferencia_pk PRIMARY KEY (idItPedidoVendaItensConferencia)
);
COMMENT ON TABLE ItPedidoVendaItensConferencia IS 'Conferencia e Separação de produtos ';


ALTER SEQUENCE seq_iditpedidovendaitensconferencia OWNED BY ItPedidoVendaItensConferencia.idItPedidoVendaItensConferencia;

CREATE SEQUENCE seq_iditprodutomidia;

CREATE TABLE ItProdutoMidia (
                idItProdutoMidia INTEGER NOT NULL DEFAULT nextval('seq_iditprodutomidia'),
                idempresa INTEGER NOT NULL,
                idItProdutoErp VARCHAR(255) NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                midia BYTEA,
                extensaoMidia VARCHAR(32),
                ordemApresentacao INTEGER NOT NULL,
                url VARCHAR(1024),
                CONSTRAINT itprodutomidia_pk PRIMARY KEY (idItProdutoMidia)
);
COMMENT ON COLUMN ItProdutoMidia.url IS 'Algumas integrações demandam uma ou mais imagens do produto. ';


ALTER SEQUENCE seq_iditprodutomidia OWNED BY ItProdutoMidia.idItProdutoMidia;

CREATE SEQUENCE seq_iditprodutomidiaintegracao;

CREATE TABLE ItProdutoMidiaIntegracao (
                idItProdutoMidiaIntegracao INTEGER NOT NULL DEFAULT nextval('seq_iditprodutomidiaintegracao'),
                idItProdutoMidia INTEGER NOT NULL,
                idIntegracaoTerceiro INTEGER NOT NULL,
                codigoItProdutoMidiaIntegracao VARCHAR(128) NOT NULL,
                CONSTRAINT itprodutomidiaintegracao_pk PRIMARY KEY (idItProdutoMidiaIntegracao)
);
COMMENT ON TABLE ItProdutoMidiaIntegracao IS 'Armazenará os códigos das imagens das apis. ';
COMMENT ON COLUMN ItProdutoMidiaIntegracao.codigoItProdutoMidiaIntegracao IS 'Código da imagem em sí da integração. ';


ALTER SEQUENCE seq_iditprodutomidiaintegracao OWNED BY ItProdutoMidiaIntegracao.idItProdutoMidiaIntegracao;

CREATE TABLE VendaPDV (
                idVendaPDV VARCHAR(255) NOT NULL,
                idempresa INTEGER NOT NULL,
                idPdv INTEGER NOT NULL,
                idCupom INTEGER NOT NULL,
                dataHoraMovimento TIMESTAMP NOT NULL,
                dataHoraFechamento TIMESTAMP,
                cnpjcpf VARCHAR(14),
                CONSTRAINT vendapdv_pk PRIMARY KEY (idVendaPDV)
);
COMMENT ON TABLE VendaPDV IS 'Armazenará dados analiticos de Cupons de vendas. ';
COMMENT ON COLUMN VendaPDV.idVendaPDV IS 'Será união dos campos chaves de cupom: Empresa,IDPDV, Numcupom , diaMesAno';
COMMENT ON COLUMN VendaPDV.idPdv IS 'Numero do Caixa/PDV';
COMMENT ON COLUMN VendaPDV.idCupom IS 'Numero documento de Venda';
COMMENT ON COLUMN VendaPDV.cnpjcpf IS 'CNPJ ou CPF da VENDA';


CREATE INDEX vendapdv_idx_datahoramovimento
 ON VendaPDV
 ( dataHoraMovimento );

CREATE SEQUENCE seq_idmalote;

CREATE TABLE Malote (
                idMalote BIGINT NOT NULL DEFAULT nextval('seq_idmalote'),
                identificacao VARCHAR(255),
                descricao VARCHAR(255) NOT NULL,
                observacao VARCHAR(512),
                idEmpresaOrigem INTEGER NOT NULL,
                idAreaEmpresaOrigem INTEGER,
                idEmpresaDestino INTEGER NOT NULL,
                idAreaEmpresaDestino INTEGER,
                prazoEntregaData DATE NOT NULL,
                prazoEntregaHora CHAR(8) NOT NULL,
                tipoEnvio CHAR(1) DEFAULT 'N' NOT NULL,
                recibo VARCHAR(255),
                CONSTRAINT malote_pk PRIMARY KEY (idMalote)
);
COMMENT ON COLUMN Malote.tipoEnvio IS 'N - Normal, E - Expresso';
COMMENT ON COLUMN Malote.recibo IS 'Localização do arquivo recibo';


ALTER SEQUENCE seq_idmalote OWNED BY Malote.idMalote;

CREATE SEQUENCE seq_idobprevisaofluxo;

CREATE TABLE OBPrevisaoFluxo (
                idobPrevisaoFluxo INTEGER NOT NULL DEFAULT nextval('seq_idobprevisaofluxo'),
                seqplaendereco VARCHAR(16) NOT NULL,
                idFilial INTEGER NOT NULL,
                idEmpresa INTEGER NOT NULL,
                documento VARCHAR(20) NOT NULL,
                aCreditarOrigem VARCHAR(16) NOT NULL,
                aCreditarReais NUMERIC(15,2) NOT NULL,
                seqplacontagerencial VARCHAR(16) NOT NULL,
                seqplafazenda VARCHAR(16) NOT NULL,
                aDebitarReais NUMERIC(15,2) NOT NULL,
                aDebitarOrigem NUMERIC(15,2) NOT NULL,
                seqplamoeda VARCHAR(16) NOT NULL,
                observacoes VARCHAR(255) NOT NULL,
                tipo CHAR(2) NOT NULL,
                datavencimento DATE NOT NULL,
                datalancamento DATE NOT NULL,
                CONSTRAINT obprevisaofluxo_pk PRIMARY KEY (idobPrevisaoFluxo)
);


ALTER SEQUENCE seq_idobprevisaofluxo OWNED BY OBPrevisaoFluxo.idobPrevisaoFluxo;

CREATE SEQUENCE seq_enderecoredeip_idenderecorederedeip;

CREATE TABLE EnderecoRede (
                idEnderecoRedeIp INTEGER NOT NULL DEFAULT nextval('seq_enderecoredeip_idenderecorederedeip'),
                descricao VARCHAR(255) NOT NULL,
                enderecoIp VARCHAR(255) NOT NULL,
                idTipoEquipamento INTEGER NOT NULL,
                idempresa INTEGER,
                idDispositivoMidiaInDoor INTEGER,
                urlParametroDispositivoMidiaInDoor VARCHAR(2048),
                dataInclusao DATE,
                horaInclusao VARCHAR(8),
                idUsuarioInclusao INTEGER,
                situacao CHAR(1) DEFAULT 'A',
                monitora VARCHAR(1) DEFAULT 'S',
                porta VARCHAR(32),
                usuarioConexao VARCHAR(128),
                senhaConexao VARCHAR(128),
                driveConexao VARCHAR(256),
                nomeSistemaConexao VARCHAR(128),
                urlConexao VARCHAR(256),
                CONSTRAINT enderecorede_pk PRIMARY KEY (idEnderecoRedeIp)
);
COMMENT ON TABLE EnderecoRede IS 'Tabela destinada para guardar dados ref. a enderecos de redes, e caracteristicas de validação de ip. ';
COMMENT ON COLUMN EnderecoRede.enderecoIp IS 'Deverá armazenar o endereco de ip da rede.  ex: 192.168.1.1 ';
COMMENT ON COLUMN EnderecoRede.idempresa IS 'Empresa que o Endereco de Rede Pertence.';
COMMENT ON COLUMN EnderecoRede.idDispositivoMidiaInDoor IS 'Código do Cadastro de Dispositivo no projeto MidiaInDoor, o qual será utilizado para passar como parametro na utilização em tarefas, a fim de identificar a empresa e o dispositivo em uso.';
COMMENT ON COLUMN EnderecoRede.urlParametroDispositivoMidiaInDoor IS 'Parâmetros a serem passadas nas tarefas de mídia show com base no aparelho. Utilizar da seguinte forma: "idSetor=1&idColaborador=10&parametro=valor&parametro2=valor2"';
COMMENT ON COLUMN EnderecoRede.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN EnderecoRede.monitora IS 'S-Sim, N-Não ';
COMMENT ON COLUMN EnderecoRede.porta IS 'Como o IP pode ser utilizado para Pingar, o campo PORTA, será utilizado em aplicações de conexão com bancos por exemplo. ';
COMMENT ON COLUMN EnderecoRede.usuarioConexao IS 'Usuário (código ou nome) que poderá ser utilizado para conexões com sistemas, exemplo de conexão com banco de dados, onde precisa passar url, entre os dados contidos na url está o usuário.';
COMMENT ON COLUMN EnderecoRede.senhaConexao IS 'Senha do usuário que poderá ser utilizado para conexões com sistemas, exemplo de conexão com banco de dados, onde precisa passar url, entre os dados contidos na url está o usuário e a senha.';
COMMENT ON COLUMN EnderecoRede.driveConexao IS 'Drive usado pelo Observador para conectar ao sistema. Exemplo: Drive do Jdbc com.mysql.jdbc.Driver';
COMMENT ON COLUMN EnderecoRede.nomeSistemaConexao IS 'Nome do sistema que será conectado. Ex: Nome do banco de dados que foi levantado.  ';
COMMENT ON COLUMN EnderecoRede.urlConexao IS 'Endereço completo ou apenas inicio da Url, uma vez que os demais dados como ip, porta, usuario e senha estão em campos especificos. exemplo: jdbc:mysql://';


ALTER SEQUENCE seq_enderecoredeip_idenderecorederedeip OWNED BY EnderecoRede.idEnderecoRedeIp;

CREATE SEQUENCE seq_idempresaconexao;

CREATE TABLE EmpresaConexao (
                idEmpresaConexao INTEGER NOT NULL DEFAULT nextval('seq_idempresaconexao'),
                idempresa INTEGER NOT NULL,
                numeroPdv INTEGER NOT NULL,
                url VARCHAR(255) NOT NULL,
                usuario VARCHAR(255) NOT NULL,
                senhaUsuario VARCHAR(255) NOT NULL,
                driver VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A',
                CONSTRAINT empresaconexao_pk PRIMARY KEY (idEmpresaConexao)
);
COMMENT ON TABLE EmpresaConexao IS 'Armazena enderecos de Ip de equipamentos da empresa.';
COMMENT ON COLUMN EmpresaConexao.url IS 'Endereco de ip e conexao com o banco de dados.';
COMMENT ON COLUMN EmpresaConexao.usuario IS 'Usuario que será utilizado na conexão com o banco de dados.';
COMMENT ON COLUMN EmpresaConexao.senhaUsuario IS 'Senha do usuário';
COMMENT ON COLUMN EmpresaConexao.driver IS 'Drive de conexão com o banco. ';
COMMENT ON COLUMN EmpresaConexao.situacao IS 'A - Ativo I - Inativo';


ALTER SEQUENCE seq_idempresaconexao OWNED BY EmpresaConexao.idEmpresaConexao;

CREATE TABLE empresaprojeto (
                idempresa INTEGER NOT NULL,
                idprojeto INTEGER NOT NULL,
                datainicialparticipacao DATE NOT NULL,
                datafinalparticipacao DATE,
                CONSTRAINT empresaprojeto_pk PRIMARY KEY (idempresa, idprojeto, datainicialparticipacao)
);


CREATE SEQUENCE seq_idindicadorgestaomovimento;

CREATE TABLE IndicadorGestaoMovimento (
                idIndicadorGestaoMovimento INTEGER NOT NULL DEFAULT nextval('seq_idindicadorgestaomovimento'),
                idIndicadorGestao INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                dataInicial DATE NOT NULL,
                dataFinal DATE NOT NULL,
                chave VARCHAR(12345) NOT NULL,
                valor VARCHAR(12345) NOT NULL,
                apelidoTarefaGeracao VARCHAR(255),
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                CONSTRAINT indicadorgestaomovimento_pk PRIMARY KEY (idIndicadorGestaoMovimento)
);
COMMENT ON COLUMN IndicadorGestaoMovimento.valor IS 'Valor do Indicador já calculado. ';
COMMENT ON COLUMN IndicadorGestaoMovimento.apelidoTarefaGeracao IS '  Identifica qual a tarefa que gerou o indicador.';


ALTER SEQUENCE seq_idindicadorgestaomovimento OWNED BY IndicadorGestaoMovimento.idIndicadorGestaoMovimento;

CREATE INDEX indicadorgestaomovimento_idx_datainicial
 ON IndicadorGestaoMovimento
 ( idIndicadorGestao, dataInicial );

CREATE INDEX indicadorgestaomovimento_idx_indicadorgestao_datainicial
 ON IndicadorGestaoMovimento
 ( idIndicadorGestao, dataFinal );

CREATE INDEX indicadorgestaomovimento_idx_idempresa_idindicadorgestao
 ON IndicadorGestaoMovimento
 ( idIndicadorGestao, idEmpresa );

CREATE TABLE FluxoCaixaSaldo (
                idempresa INTEGER NOT NULL,
                tipoPeriodo VARCHAR(128) NOT NULL,
                dataGeracao DATE NOT NULL,
                valor NUMERIC(15,2) NOT NULL,
                CONSTRAINT fluxocaixasaldo_pk PRIMARY KEY (idempresa, tipoPeriodo, dataGeracao)
);
COMMENT ON COLUMN FluxoCaixaSaldo.tipoPeriodo IS 'D-Dia, M-Mes, A-Ano';


CREATE INDEX fluxocaixasaldo_idx_datageracao_tipoperiodo
 ON FluxoCaixaSaldo
 ( dataGeracao, tipoPeriodo );

CREATE TABLE Feriado (
                idempresa INTEGER NOT NULL,
                data DATE NOT NULL,
                descricao VARCHAR(255),
                tipoFeriado VARCHAR(155),
                feriado CHAR(1),
                CONSTRAINT feriado_pk PRIMARY KEY (idempresa, data)
);
COMMENT ON COLUMN Feriado.tipoFeriado IS 'E-Estadual, F-Federal, M-Municipal  ';
COMMENT ON COLUMN Feriado.feriado IS 'S-Sim, N-Não';


CREATE TABLE FluxoCaixa (
                idempresa INTEGER NOT NULL,
                tipoMovimento VARCHAR(155) NOT NULL,
                CONSTRAINT fluxocaixa_pk PRIMARY KEY (idempresa, tipoMovimento)
);
COMMENT ON COLUMN FluxoCaixa.tipoMovimento IS 'CR-Contas a Receber, CP-Contas a Pagar, MB - Movimento Bancario';


CREATE TABLE EstoqueLocal (
                idLocalEstoque INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                localVenda CHAR(1),
                localTroca CHAR(10),
                idempresa INTEGER,
                CONSTRAINT estoquelocal_pk PRIMARY KEY (idLocalEstoque)
);
COMMENT ON COLUMN EstoqueLocal.localVenda IS 'S-Sim ou N-Não';
COMMENT ON COLUMN EstoqueLocal.localTroca IS 'S-Sim ou N-Não';


CREATE SEQUENCE seq_idinventarioagenda;

CREATE TABLE InventarioAgenda (
                idInventarioAgenda INTEGER NOT NULL DEFAULT nextval('seq_idinventarioagenda'),
                dataAgenda DATE NOT NULL,
                descricao VARCHAR(256),
                dataInclusao DATE NOT NULL,
                idUsuarioInclusao INTEGER,
                idUsuarioAlteracao INTEGER,
                dataAlteracao DATE,
                idLocalEstoque INTEGER,
                CONSTRAINT inventarioagenda_pk PRIMARY KEY (idInventarioAgenda)
);
COMMENT ON TABLE InventarioAgenda IS 'Tabela destinada a armazenar programações de Inventários/Balancos de estoques a serem realizados.';
COMMENT ON COLUMN InventarioAgenda.dataAgenda IS 'Dia em que o Inventário deverá ser realizado.';


ALTER SEQUENCE seq_idinventarioagenda OWNED BY InventarioAgenda.idInventarioAgenda;

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
);
COMMENT ON COLUMN Pessoa.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN Pessoa.gln IS 'Neste sentido o GLN é o identificador chave do Sistema GS1 que possibilita a identificação única e inequívoca de entidades legais, funcionais e físicas, pré-requisito para a eficiência no comércio eletrônico e na sincronização global de dados, possibilitando outras aplicações, tais como: - See more at: https://www.gs1br.org/codigos-e-padroes/chaves-de-identificacao/gln#sthash.F3giBLwe.dpuf';
COMMENT ON COLUMN Pessoa.cliente IS 'T-True, F-False';
COMMENT ON COLUMN Pessoa.fornecedor IS 'T-True, F-False';
COMMENT ON COLUMN Pessoa.transportador IS 'T-True, F-False';
COMMENT ON COLUMN Pessoa.vendedor IS 'T-True, F-False';
COMMENT ON COLUMN Pessoa.funcionario IS 'T-True, F-False';
COMMENT ON COLUMN Pessoa.tipo IS 'D-Distribuidor, F-Fabricante';
COMMENT ON COLUMN Pessoa.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN Pessoa.tipoPessoa IS 'F-Fisica, J-Juridica';
COMMENT ON COLUMN Pessoa.tipoCadastro IS 'C-Aprovado, P-Prospect ';
COMMENT ON COLUMN Pessoa.sexo IS 'M -> Masculino F -> Feminino';
COMMENT ON COLUMN Pessoa.representante IS 'Identifica se o cadastro é de um representante. ';
COMMENT ON COLUMN Pessoa.idPessoaLigacao IS 'Código que o fornecedor pode estar ligado. Ex. Codigo 1010 está ligado a pessoa 1000 ';


CREATE INDEX fornecedor_idx_cnpj
 ON Pessoa
 ( cnpj );

CREATE INDEX pessoa_idx_representante
 ON Pessoa
 ( representante );

CREATE SEQUENCE seq_idpessoainstituicaofinanceira;

CREATE TABLE PessoaInstituicaoFinanceira (
                idPessoaInstituicaoFinanceira INTEGER NOT NULL DEFAULT nextval('seq_idpessoainstituicaofinanceira'),
                idInstituicaoFinanceira INTEGER NOT NULL,
                conta VARCHAR(256) NOT NULL,
                agencia VARCHAR(10) NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                dataAlteracao DATE NOT NULL,
                idUsuarioAlteracao INTEGER NOT NULL,
                CONSTRAINT pessoainstituicaofinanceira_pk PRIMARY KEY (idPessoaInstituicaoFinanceira)
);
COMMENT ON TABLE PessoaInstituicaoFinanceira IS 'Desinado para salvar dados de Contas de Pessoas ligadas as instituições Financeiras. Decidido não usar PessoaContaBancaria, pois está ligada a Antecipação de Recebiveis.';
COMMENT ON COLUMN PessoaInstituicaoFinanceira.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';


ALTER SEQUENCE seq_idpessoainstituicaofinanceira OWNED BY PessoaInstituicaoFinanceira.idPessoaInstituicaoFinanceira;

CREATE SEQUENCE seq_idmovimentopessoainstituicaofinanceira;

CREATE TABLE MovimentoPessoaInstituicaoFinanceira (
                idMovimentoPessoaInstituicaoFinanceira INTEGER NOT NULL DEFAULT nextval('seq_idmovimentopessoainstituicaofinanceira'),
                idPessoaInstituicaoFinanceira INTEGER NOT NULL,
                idTransacaoMovimentoInstituicao VARCHAR(256) NOT NULL,
                tipoLancamento CHAR(10) NOT NULL,
                dataLancamento DATE NOT NULL,
                horaLancamento VARCHAR(10) NOT NULL,
                valorLancamento NUMERIC(15,2) NOT NULL,
                detalheLancamento VARCHAR(1024),
                estornoLancamento CHAR(1) DEFAULT 'N' NOT NULL,
                saldoPessoaInstituicao NUMERIC(15,2) NOT NULL,
                dataGravacao DATE NOT NULL,
                horaGravacao VARCHAR(10) NOT NULL,
                jsonbRegistroOriginal VARCHAR(12345) NOT NULL,
                jsonbPagador VARCHAR(12345),
                jsonbPagamento VARCHAR(12345),
                conciliadoErp CHAR(1) DEFAULT 'N',
                jsonbidRegistroERp VARCHAR(12345),
                CONSTRAINT movimentopessoainstituicaofinanceira_pk PRIMARY KEY (idMovimentoPessoaInstituicaoFinanceira)
);
COMMENT ON TABLE MovimentoPessoaInstituicaoFinanceira IS 'Extrato de banco, financeiras....';
COMMENT ON COLUMN MovimentoPessoaInstituicaoFinanceira.idTransacaoMovimentoInstituicao IS 'Identificador do movimento da transação da Instituição financeira. Dado que virá da instituição. ';
COMMENT ON COLUMN MovimentoPessoaInstituicaoFinanceira.tipoLancamento IS 'Movimentação Financeira. Importante saber que não é a movimentação Contábil.   C-Credito   (Entrada)   D-Debito    (Debito) ';
COMMENT ON COLUMN MovimentoPessoaInstituicaoFinanceira.horaLancamento IS 'Data, Hora, Minuto';
COMMENT ON COLUMN MovimentoPessoaInstituicaoFinanceira.detalheLancamento IS 'Historico também conhecido como complemento de informação do lançamento.  Ex. Pix recebido xpto. ';
COMMENT ON COLUMN MovimentoPessoaInstituicaoFinanceira.estornoLancamento IS 'Identificar se é um Esterno de lançamento anterior, ou se é um lançamento original.  S para Sim, e N para Não. ';
COMMENT ON COLUMN MovimentoPessoaInstituicaoFinanceira.jsonbPagador IS 'Grava objeto de informações dos pagadores. ';
COMMENT ON COLUMN MovimentoPessoaInstituicaoFinanceira.jsonbPagamento IS 'Grava Objeto com informações de pagamentos, como se é pix, doc, etc...';
COMMENT ON COLUMN MovimentoPessoaInstituicaoFinanceira.conciliadoErp IS 'S-Para Sim.  N-Para Não.  Default N. Sim indicará que a linha/registro já foi conciliado com lançamento no Erp.  ';
COMMENT ON COLUMN MovimentoPessoaInstituicaoFinanceira.jsonbidRegistroERp IS 'Campo Json para armazenar informações sobre o registro de conciliação no Erp.  Pode ser a tabela, campo, valor, etc...';


ALTER SEQUENCE seq_idmovimentopessoainstituicaofinanceira OWNED BY MovimentoPessoaInstituicaoFinanceira.idMovimentoPessoaInstituicaoFinanceira;

CREATE INDEX movimentopessoainstituicaofinanceira_idx_datalancamento_idpe107
 ON MovimentoPessoaInstituicaoFinanceira
 ( dataLancamento, idPessoaInstituicaoFinanceira );

CREATE SEQUENCE seq_idpessoaperfil;

CREATE TABLE PessoaPerfil (
                idPessoaPerfil INTEGER NOT NULL DEFAULT nextval('seq_idpessoaperfil'),
                idPessoa VARCHAR(128) NOT NULL,
                idPerfilPessoa INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(10) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                observacao VARCHAR(5120),
                CONSTRAINT pessoaperfil_pk PRIMARY KEY (idPessoaPerfil)
);
COMMENT ON TABLE PessoaPerfil IS 'Tabela destinada para armazenar informações de quais os perfils ligados a pessoa. Podendo ser Fornecedor, Cliente ou outro tipo aceito na tabela de pessoas.';
COMMENT ON COLUMN PessoaPerfil.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';


ALTER SEQUENCE seq_idpessoaperfil OWNED BY PessoaPerfil.idPessoaPerfil;

CREATE SEQUENCE seq_idpessoacliente;

CREATE TABLE PessoaCliente (
                idPessoaCliente INTEGER NOT NULL DEFAULT nextval('seq_idpessoacliente'),
                idPessoa VARCHAR(128) NOT NULL,
                idPessoaVendedor VARCHAR(128),
                idRegiao INTEGER,
                CONSTRAINT pessoacliente_pk PRIMARY KEY (idPessoaCliente)
);
COMMENT ON TABLE PessoaCliente IS 'Armazena dados ligados ao cliente Pessoa.';
COMMENT ON COLUMN PessoaCliente.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN PessoaCliente.idPessoaVendedor IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';


ALTER SEQUENCE seq_idpessoacliente OWNED BY PessoaCliente.idPessoaCliente;

CREATE INDEX pessoacliente_idx_idpessoa_idpessoavendedor
 ON PessoaCliente
 ( idPessoa, idPessoaVendedor );

CREATE SEQUENCE seq_idcampanhaoferta;

CREATE TABLE CampanhaOferta (
                idCampanhaOferta BIGINT NOT NULL DEFAULT nextval('seq_idcampanhaoferta'),
                idempresa INTEGER,
                descricao VARCHAR(255) NOT NULL,
                dataInicial DATE,
                dataFinal DATE,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER,
                dataInicialComparativo DATE,
                dataFinalComparativo DATE,
                idPessoa VARCHAR(128),
                idUsuarioAlteracao INTEGER,
                situacao VARCHAR(1) DEFAULT 'A' NOT NULL,
                consideraValorST VARCHAR(1) DEFAULT 'N',
                pervariacaocomparativo NUMERIC(15,4),
                idCampanhaOfertaTipo INTEGER,
                CONSTRAINT campanhaoferta_pk PRIMARY KEY (idCampanhaOferta)
);
COMMENT ON COLUMN CampanhaOferta.dataInicialComparativo IS 'Data para busca de vendas a ser comparada com o periodo normal da campanha. ';
COMMENT ON COLUMN CampanhaOferta.dataFinalComparativo IS 'Data para busca de vendas a ser comparada com o periodo normal da campanha. ';
COMMENT ON COLUMN CampanhaOferta.idPessoa IS 'Armazena o fornecedor da camapnha';
COMMENT ON COLUMN CampanhaOferta.situacao IS 'Situação da Camapanha A-tivo I-nativo';
COMMENT ON COLUMN CampanhaOferta.consideraValorST IS 'S-sim ou N-não';
COMMENT ON COLUMN CampanhaOferta.pervariacaocomparativo IS '% de crescimento esperado entre Periodo Comparativo e o periodo atual. ';


ALTER SEQUENCE seq_idcampanhaoferta OWNED BY CampanhaOferta.idCampanhaOferta;

CREATE SEQUENCE seq_idcampanhacanais;

CREATE TABLE CampanhaCanais (
                idCampanhaCanais INTEGER NOT NULL DEFAULT nextval('seq_idcampanhacanais'),
                idCampanhaOferta BIGINT NOT NULL,
                idempresa INTEGER NOT NULL,
                idCanalPublicidade INTEGER NOT NULL,
                CONSTRAINT campanhacanais_pk PRIMARY KEY (idCampanhaCanais)
);


ALTER SEQUENCE seq_idcampanhacanais OWNED BY CampanhaCanais.idCampanhaCanais;

CREATE SEQUENCE seq_idcampanhaofertaempresa;

CREATE TABLE CampanhaOfertaEmpresa (
                idCampanhaOfertaEmpresa INTEGER NOT NULL DEFAULT nextval('seq_idcampanhaofertaempresa'),
                idCampanhaOferta BIGINT NOT NULL,
                idempresa INTEGER NOT NULL,
                CONSTRAINT campanhaofertaempresa_pk PRIMARY KEY (idCampanhaOfertaEmpresa)
);
COMMENT ON TABLE CampanhaOfertaEmpresa IS 'Define as empresas da campanha.';


ALTER SEQUENCE seq_idcampanhaofertaempresa OWNED BY CampanhaOfertaEmpresa.idCampanhaOfertaEmpresa;

CREATE SEQUENCE seq_idcampanhaofertapontuacao;

CREATE TABLE CampanhaOfertaPontuacao (
                idCampanhaOfertaPontuacao INTEGER NOT NULL DEFAULT nextval('seq_idcampanhaofertapontuacao'),
                idCampanhaOferta BIGINT NOT NULL,
                tipo VARCHAR(128) NOT NULL,
                quantidade INTEGER NOT NULL,
                CONSTRAINT campanhaofertapontuacao_pk PRIMARY KEY (idCampanhaOfertaPontuacao)
);
COMMENT ON TABLE CampanhaOfertaPontuacao IS 'Define assa pontuações que ocorrem no resultado de uma campanha';
COMMENT ON COLUMN CampanhaOfertaPontuacao.tipo IS 'Chave que define o tipo da pontuação. Ex: REAL_VENDIDO, PRODUTO_POSITIVADO, CLIENTE_POSITIVADO...';
COMMENT ON COLUMN CampanhaOfertaPontuacao.quantidade IS 'Quantidade de pontos que se ganha com base o tipo da pontuação.';


ALTER SEQUENCE seq_idcampanhaofertapontuacao OWNED BY CampanhaOfertaPontuacao.idCampanhaOfertaPontuacao;

CREATE SEQUENCE seq_idcampanhaofertamidia;

CREATE TABLE CampanhaOfertaMidia (
                idCampanhaOfertaMidia INTEGER NOT NULL DEFAULT nextval('seq_idcampanhaofertamidia'),
                idCampanhaOferta BIGINT NOT NULL,
                midia BYTEA NOT NULL,
                extMidia VARCHAR(32) NOT NULL,
                descricaoMidia VARCHAR(1024),
                CONSTRAINT campanhaofertamidia_pk PRIMARY KEY (idCampanhaOfertaMidia)
);
COMMENT ON TABLE CampanhaOfertaMidia IS 'Armazena as mídias da campanha ';


ALTER SEQUENCE seq_idcampanhaofertamidia OWNED BY CampanhaOfertaMidia.idCampanhaOfertaMidia;

CREATE SEQUENCE seq_idpessoarepresentantemercadologico;

CREATE TABLE PessoaRepresentanteMercadologico (
                idPessoaRepresentanteMercadologico INTEGER NOT NULL DEFAULT nextval('seq_idpessoarepresentantemercadologico'),
                idPessoaRepresentante VARCHAR(128) NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                tipoMercadologico VARCHAR(128) NOT NULL,
                idMercadologico VARCHAR(128) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                CONSTRAINT pessoarepresentantemercadologico_pk PRIMARY KEY (idPessoaRepresentanteMercadologico)
);
COMMENT ON TABLE PessoaRepresentanteMercadologico IS 'Produtos ou Mercadologico que representa do Fornecedor';
COMMENT ON COLUMN PessoaRepresentanteMercadologico.idPessoaRepresentante IS 'Código do Representante da Pessoa.';
COMMENT ON COLUMN PessoaRepresentanteMercadologico.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN PessoaRepresentanteMercadologico.tipoMercadologico IS 'D-Departamento, S-Seção, G-Grupo, B-Subgrupo, P-Produto, V-Vendedor';
COMMENT ON COLUMN PessoaRepresentanteMercadologico.idMercadologico IS 'Código do Mercadologico, as vezes Depto, Setor... Produto.';
COMMENT ON COLUMN PessoaRepresentanteMercadologico.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idpessoarepresentantemercadologico OWNED BY PessoaRepresentanteMercadologico.idPessoaRepresentanteMercadologico;

CREATE INDEX pessoarepresentantemercadologico_idx_representante
 ON PessoaRepresentanteMercadologico
 ( idPessoaRepresentante );

CREATE INDEX pessoarepresentantemercadologico_idx_pessoa
 ON PessoaRepresentanteMercadologico
 ( idPessoa );

CREATE SEQUENCE seq_idpessoacontabancaria;

CREATE TABLE PessoaContaBancaria (
                idPessoaContaBancaria INTEGER NOT NULL DEFAULT nextval('seq_idpessoacontabancaria'),
                idPessoa VARCHAR(128) NOT NULL,
                banco VARCHAR(255) NOT NULL,
                conta VARCHAR(15) NOT NULL,
                agencia VARCHAR(15) NOT NULL,
                chavePix VARCHAR(1024),
                CONSTRAINT pessoacontabancaria_pk PRIMARY KEY (idPessoaContaBancaria)
);
COMMENT ON COLUMN PessoaContaBancaria.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN PessoaContaBancaria.banco IS 'Descrição do banco';


ALTER SEQUENCE seq_idpessoacontabancaria OWNED BY PessoaContaBancaria.idPessoaContaBancaria;

CREATE SEQUENCE seq_idpessoacontrato;

CREATE TABLE PessoaContrato (
                idPessoaContrato INTEGER NOT NULL DEFAULT nextval('seq_idpessoacontrato'),
                contrato VARCHAR(128) NOT NULL,
                descricao VARCHAR(512) NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                idempresa INTEGER NOT NULL,
                tipoNegociacao CHAR(1) NOT NULL,
                tipoContratoPessoa CHAR(1) NOT NULL,
                dataInicialContrato DATE,
                dataFinalContrato DATE,
                valor NUMERIC(15,2),
                tipoIntervalo VARCHAR(128) NOT NULL,
                diaVctoInicial INTEGER,
                diaVctoFinal INTEGER,
                CONSTRAINT pessoacontrato_pk PRIMARY KEY (idPessoaContrato)
);
COMMENT ON TABLE PessoaContrato IS 'Negociações e Contratos de Fornecimento de produtos e Serviços. ';
COMMENT ON COLUMN PessoaContrato.contrato IS 'Identificação do documento, podendo ser numero do contrato ou nota fiscal. ';
COMMENT ON COLUMN PessoaContrato.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN PessoaContrato.tipoNegociacao IS 'S-Servico, P-Produto';
COMMENT ON COLUMN PessoaContrato.tipoContratoPessoa IS 'C-Cliente,  F-Fornecedor';
COMMENT ON COLUMN PessoaContrato.dataInicialContrato IS 'Data Inicio do contrato.';
COMMENT ON COLUMN PessoaContrato.dataFinalContrato IS 'Data final da negociacao.';
COMMENT ON COLUMN PessoaContrato.valor IS 'Valor normalmente mensal. ';
COMMENT ON COLUMN PessoaContrato.tipoIntervalo IS 'Nome do atributo da tabela Data.  Ex:   agrupamento diário: = a ddmmaaaa   agrupamento semanal: = a semanaano';
COMMENT ON COLUMN PessoaContrato.diaVctoInicial IS 'Dia vencimento inicial. Utilizado para situações de contratos que podem ter dias variados entre o mes.';
COMMENT ON COLUMN PessoaContrato.diaVctoFinal IS 'Dia vencimento Final. Utilizado para situações de contratos que podem ter dias variados entre o mes.';


ALTER SEQUENCE seq_idpessoacontrato OWNED BY PessoaContrato.idPessoaContrato;

CREATE SEQUENCE seq_contaspagar_idcontaspagar;

CREATE TABLE ContasPagar (
                idContasPagar INTEGER NOT NULL DEFAULT nextval('seq_contaspagar_idcontaspagar'),
                idempresa INTEGER NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                dataMovimento DATE NOT NULL,
                dataVencimento DATE NOT NULL,
                valorTitulo NUMERIC(20,2) NOT NULL,
                valorPago NUMERIC(20,2),
                observacao VARCHAR(255),
                valorDesconto NUMERIC(15,2),
                valorJurosPendente NUMERIC(15,2),
                valorSaldoPendente NUMERIC(20,2),
                documento VARCHAR(255),
                idFormaPagamento INTEGER,
                idPortador INTEGER,
                idIndice INTEGER,
                parcela VARCHAR(10),
                dataUltimoPagamento DATE,
                idPlanilha INTEGER,
                chaveMovimento VARCHAR(255),
                CONSTRAINT contaspagar_pk PRIMARY KEY (idContasPagar)
);
COMMENT ON COLUMN ContasPagar.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN ContasPagar.valorJurosPendente IS 'Valor calculo do Juros até o momento.';
COMMENT ON COLUMN ContasPagar.idIndice IS 'Moeda que originou o registro.';
COMMENT ON COLUMN ContasPagar.parcela IS 'Normalmente os erps salva numeros sequencias, sendo 1 para primeiro vencimento, 2 para segundo ...  porem alguns erps, colocam Letras, portanto criamos o campo varchar para aceitar essas aberrações de análises. ';
COMMENT ON COLUMN ContasPagar.dataUltimoPagamento IS 'Data ultimo pagamento da parcela. ';
COMMENT ON COLUMN ContasPagar.chaveMovimento IS 'Dado que identifica o documento origem de movimentação. ';


ALTER SEQUENCE seq_contaspagar_idcontaspagar OWNED BY ContasPagar.idContasPagar;

CREATE INDEX contaspagar_idx_idempresa_idpessoa_datamovimento_documento
 ON ContasPagar
 ( idEmpresa, idPessoa, dataMovimento, documento );

CREATE INDEX contaspagar_idx_idplanilha
 ON ContasPagar
 ( idPlanilha );

CREATE INDEX contaspagar_idx_chavemovimento
 ON ContasPagar
 ( chaveMovimento );

CREATE SEQUENCE seq_contasreceber_idcontasreceber;

CREATE TABLE ContasReceber (
                idContasReceber INTEGER NOT NULL DEFAULT nextval('seq_contasreceber_idcontasreceber'),
                idempresa INTEGER NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                valorDesconto NUMERIC(15,2),
                dataMovimento DATE NOT NULL,
                dataVencimento DATE NOT NULL,
                valorTitulo NUMERIC(20,2) NOT NULL,
                valorRecebido NUMERIC(20,2),
                observacao VARCHAR(255),
                valorJurosPendente NUMERIC(15,2),
                valorSaldoPendente NUMERIC(20,2),
                documento VARCHAR(255),
                idFormaPagamento INTEGER,
                idPortador INTEGER,
                idIndice INTEGER,
                parcela VARCHAR(10),
                dataUltimoPagamento DATE,
                idPlanilha INTEGER,
                idAdministradora INTEGER,
                idBandeiraAdministradora INTEGER,
                chaveMovimento VARCHAR(255),
                idContasReceberUltimaCobranca INTEGER,
                codcobrancaerp VARCHAR(255),
                CONSTRAINT contasreceber_pk PRIMARY KEY (idContasReceber)
);
COMMENT ON COLUMN ContasReceber.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN ContasReceber.valorJurosPendente IS 'Valor calculo do Juros até o momento.';
COMMENT ON COLUMN ContasReceber.idIndice IS 'Moeda que originou o registro.';
COMMENT ON COLUMN ContasReceber.parcela IS 'Normalmente os erps salva numeros sequencias, sendo 1 para primeiro vencimento, 2 para segundo ...  porem alguns erps, colocam Letras, portanto criamos o campo varchar para aceitar essas aberrações de análises. ';
COMMENT ON COLUMN ContasReceber.dataUltimoPagamento IS 'Data ultimo pagamento da parcela. ';
COMMENT ON COLUMN ContasReceber.chaveMovimento IS 'Dado que identifica o documento origem de movimentação. ';
COMMENT ON COLUMN ContasReceber.idContasReceberUltimaCobranca IS 'Armazena a última cobrança realizada pelo contas a receber para facilitar o join e buscar os dados da cobrança me si.';


ALTER SEQUENCE seq_contasreceber_idcontasreceber OWNED BY ContasReceber.idContasReceber;

CREATE INDEX contasreceber_idx_vencimento
 ON ContasReceber
 ( dataVencimento );

CREATE INDEX contasreceber_idx_empresa_vencimento
 ON ContasReceber
 ( idEmpresa, dataVencimento );

CREATE INDEX contasreceber_idx_idpessoa
 ON ContasReceber
 ( idPessoa );

CREATE INDEX contasreceber_idx_idempresa_idpessoa_datamovimento_documento
 ON ContasReceber
 ( idEmpresa, idPessoa, documento, dataMovimento );

CREATE INDEX contasreceber_idx_idplanilha
 ON ContasReceber
 ( idPlanilha );

CREATE INDEX contasreceber_idx_chavemovimento
 ON ContasReceber
 ( chaveMovimento );

CREATE SEQUENCE seq_idcontasrecebercobranca;

CREATE TABLE ContasReceberCobranca (
                idContasReceberCobranca INTEGER NOT NULL DEFAULT nextval('seq_idcontasrecebercobranca'),
                idContasReceber INTEGER NOT NULL,
                dataCobranca DATE NOT NULL,
                horaCobranca VARCHAR(10) NOT NULL,
                idUsuarioCobranca INTEGER NOT NULL,
                situacao VARCHAR(1) DEFAULT 'C' NOT NULL,
                observacao VARCHAR(1024) NOT NULL,
                dataVencimento DATE,
                CONSTRAINT contasrecebercobranca_pk PRIMARY KEY (idContasReceberCobranca)
);
COMMENT ON TABLE ContasReceberCobranca IS 'Utilizado para definir os logs das cobranças das contas a receber vencidas.';
COMMENT ON COLUMN ContasReceberCobranca.situacao IS 'C-Cobrança, N-Negociado';
COMMENT ON COLUMN ContasReceberCobranca.observacao IS 'Sobre a cobrança.';
COMMENT ON COLUMN ContasReceberCobranca.dataVencimento IS 'Nova data de vencimento quando negociado. Utilizado para reabrir uma cobrança quando o título continua vencido após essa nova data.';


ALTER SEQUENCE seq_idcontasrecebercobranca OWNED BY ContasReceberCobranca.idContasReceberCobranca;

CREATE SEQUENCE seq_idcontasrecebercobrancamidia;

CREATE TABLE ContasReceberCobrancaMidia (
                idContasReceberCobrancaMidia INTEGER NOT NULL DEFAULT nextval('seq_idcontasrecebercobrancamidia'),
                idContasReceberCobranca INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                midia BYTEA NOT NULL,
                extensao VARCHAR(32) NOT NULL,
                CONSTRAINT contasrecebercobrancamidia_pk PRIMARY KEY (idContasReceberCobrancaMidia)
);


ALTER SEQUENCE seq_idcontasrecebercobrancamidia OWNED BY ContasReceberCobrancaMidia.idContasReceberCobrancaMidia;

CREATE SEQUENCE seq_idpessoacontato;

CREATE TABLE PessoaContato (
                idPessoaContato INTEGER NOT NULL DEFAULT nextval('seq_idpessoacontato'),
                idPessoa VARCHAR(128) NOT NULL,
                tipoContato VARCHAR(1) NOT NULL,
                email VARCHAR(255),
                telefone VARCHAR(40),
                telefoneCelular VARCHAR(40),
                skype VARCHAR(128),
                nome VARCHAR(255) NOT NULL,
                observacao VARCHAR(255),
                CONSTRAINT pessoacontato_pk PRIMARY KEY (idPessoaContato)
);
COMMENT ON TABLE PessoaContato IS 'Identificar os contatos externos de cada cargo no cliente ou fornecedor. ';
COMMENT ON COLUMN PessoaContato.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN PessoaContato.tipoContato IS 'V-Vendedor F-Financeiro G-Gerente  L-Logistica F-Fiscal C-Contabil';
COMMENT ON COLUMN PessoaContato.nome IS 'Nome do dono do email.';


ALTER SEQUENCE seq_idpessoacontato OWNED BY PessoaContato.idPessoaContato;

CREATE INDEX pessoacontato_idx_pessoa_tipo
 ON PessoaContato
 ( idPessoa, tipoContato );

CREATE TABLE CotacaoFornecedorMarcado (
                idCotacaoFornecedor INTEGER NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                email VARCHAR(2048) NOT NULL,
                CONSTRAINT cotacaofornecedormarcado_pk PRIMARY KEY (idCotacaoFornecedor, idPessoa)
);
COMMENT ON TABLE CotacaoFornecedorMarcado IS 'Fornecedores que foram marcados para participar da cotação. ';
COMMENT ON COLUMN CotacaoFornecedorMarcado.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN CotacaoFornecedorMarcado.situacao IS 'A-Ativo, I-Inativo';


CREATE TABLE ValidacaoRecorrenciaFinanceira (
                idempresa INTEGER NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                tipoDocumento VARCHAR(155) NOT NULL,
                dataInicioValidacao DATE NOT NULL,
                observacao VARCHAR(255) NOT NULL,
                tipoPeriodo VARCHAR(128) NOT NULL,
                dataFinalValidacao DATE NOT NULL,
                diaInicialVencimento INTEGER NOT NULL,
                diaFinalVencimento INTEGER NOT NULL,
                prioridade INTEGER NOT NULL,
                todasEmpresas CHAR(1),
                valorInicial NUMERIC(15,2),
                valorFinal NUMERIC(15,2),
                CONSTRAINT validacaorecorrenciafinanceira_pk PRIMARY KEY (idempresa, idPessoa, tipoDocumento, dataInicioValidacao, observacao)
);
COMMENT ON TABLE ValidacaoRecorrenciaFinanceira IS '  Nessa tabela o cliente irá informar os registros que deseja validar periodicamente no financeiro, seja contas a pagar , receber, etc...';
COMMENT ON COLUMN ValidacaoRecorrenciaFinanceira.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN ValidacaoRecorrenciaFinanceira.tipoDocumento IS 'CR - Contas a Receber,  CP - Contas a Pagar';
COMMENT ON COLUMN ValidacaoRecorrenciaFinanceira.dataInicioValidacao IS 'Data em que se dará inicio a validação.';
COMMENT ON COLUMN ValidacaoRecorrenciaFinanceira.observacao IS 'Campo que poderá ser utilizado nas tarefas de auditoria para identificar por nome de conta de destino. ';
COMMENT ON COLUMN ValidacaoRecorrenciaFinanceira.tipoPeriodo IS 'D-Dia, M-Mes, A-Ano';
COMMENT ON COLUMN ValidacaoRecorrenciaFinanceira.prioridade IS '1-Não Pode Vencer 2-Sem validação de Vencimento';
COMMENT ON COLUMN ValidacaoRecorrenciaFinanceira.todasEmpresas IS 'S-Sim , N-Não.  Identifica se o lançamento de recorrencia deverá valer para todas as empresas, ou apenas para a empresa lançada.';


CREATE TABLE RecepcaoMercadorias (
                idempresa INTEGER NOT NULL,
                numeroNotaFiscal INTEGER NOT NULL,
                serieNotaFiscal VARCHAR(128) NOT NULL,
                idPedido INTEGER NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                dataRecepcao DATE NOT NULL,
                CONSTRAINT recepcaomercadorias_pk PRIMARY KEY (idempresa, numeroNotaFiscal, serieNotaFiscal, idPedido, idPessoa)
);
COMMENT ON COLUMN RecepcaoMercadorias.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';


CREATE TABLE PessoaIndicador (
                idPessoa VARCHAR(128) NOT NULL,
                IndicadorAvaliacao INTEGER NOT NULL,
                dataProcessamento DATE NOT NULL,
                valor NUMERIC(15,4) NOT NULL,
                CONSTRAINT pessoaindicador_pk PRIMARY KEY (idPessoa, IndicadorAvaliacao, dataProcessamento)
);
COMMENT ON TABLE PessoaIndicador IS 'Essa tabela deverá armazenar os valores dos indicadores pre-processados ';
COMMENT ON COLUMN PessoaIndicador.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';


CREATE TABLE Usuario (
                idUsuario INTEGER NOT NULL,
                nome VARCHAR(255) NOT NULL,
                idPessoaFornecedor VARCHAR(128),
                idColaborador INTEGER,
                situacao CHAR(1),
                idGrupoUsuarios INTEGER,
                usuario VARCHAR(128),
                CONSTRAINT usuario_pk PRIMARY KEY (idUsuario)
);
COMMENT ON COLUMN Usuario.idPessoaFornecedor IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN Usuario.situacao IS 'A-Ativo, I-Inativo.';


CREATE SEQUENCE seq_idusuariopessoa;

CREATE TABLE UsuarioPessoa (
                idUsuarioPessoa INTEGER NOT NULL DEFAULT nextval('seq_idusuariopessoa'),
                idUsuario INTEGER NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                CONSTRAINT usuariopessoa_pk PRIMARY KEY (idUsuarioPessoa)
);
COMMENT ON TABLE UsuarioPessoa IS 'Armazena as Pessoas que um Usuário possui ligação. Ex: clientes de um usuário. ';
COMMENT ON COLUMN UsuarioPessoa.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';


ALTER SEQUENCE seq_idusuariopessoa OWNED BY UsuarioPessoa.idUsuarioPessoa;

CREATE TABLE AgendaDescargaFornecedor (
                dataAgendamento DATE NOT NULL,
                horaAgendamento VARCHAR(8) NOT NULL,
                idFornecedor VARCHAR(256) NOT NULL,
                idempresa INTEGER NOT NULL,
                localdescargafornecedor VARCHAR(64) NOT NULL,
                dataInicioDescarga DATE,
                horaInicioDescarga VARCHAR(8),
                dataFinalDescarga DATE,
                horaFinalDescarga VARCHAR(8),
                notasFiscais VARCHAR(256),
                situacao CHAR(1) DEFAULT 'P' NOT NULL,
                observacao VARCHAR(1024),
                dataChegada DATE,
                horaChegada VARCHAR(8),
                horaEntrada VARCHAR(8),
                horaAgendamentoFinal VARCHAR(8),
                ordemcompraatendida CHAR(1) DEFAULT 'T' NOT NULL,
                divergencia CHAR(1) DEFAULT 'N' NOT NULL,
                nomeAgendador VARCHAR(128),
                telefoneAgendador VARCHAR(32),
                volume VARCHAR(32),
                tipoVolume VARCHAR(32),
                pesoTotal VARCHAR(32),
                numeroAutorizacao VARCHAR(32),
                dataGravacao DATE DEFAULT CURRENT_DATE,
                horaGravacao VARCHAR(20) DEFAULT CURRENT_TIME,
                idUsuarioGravacao INTEGER,
                idTransportador VARCHAR(255),
                pedidos VARCHAR(256),
                valorTotalEntrega NUMERIC(16,6),
                CONSTRAINT agendadescargafornecedor_pk PRIMARY KEY (dataAgendamento, horaAgendamento, idFornecedor, idempresa, localdescargafornecedor)
);
COMMENT ON TABLE AgendaDescargaFornecedor IS 'Tabela fora do padrao. Aproveitado já rodando nos clientes, e migrado para HEAVEN em abril de 2017.';
COMMENT ON COLUMN AgendaDescargaFornecedor.situacao IS 'P-Pendente, F-Finalizada, C-Cancelada, O-Outras, N-Não Agendado';
COMMENT ON COLUMN AgendaDescargaFornecedor.ordemcompraatendida IS 'T-Sim, F-Nao  ';
COMMENT ON COLUMN AgendaDescargaFornecedor.divergencia IS 'N-Nenhuma, C-Carga, M-Motorista, O-Outros';


CREATE SEQUENCE seq_idagendadescargafornecedornotas;

CREATE TABLE AgendaDescargaFornecedorNotas (
                idAgendaDescargaFornecedorNotas INTEGER NOT NULL DEFAULT nextval('seq_idagendadescargafornecedornotas'),
                dataAgendamento DATE NOT NULL,
                horaAgendamento VARCHAR(8) NOT NULL,
                nomefornecedor VARCHAR(255) NOT NULL,
                cnpjfornecedor VARCHAR(14) NOT NULL,
                notasfiscais VARCHAR(255) NOT NULL,
                volume CHAR(32),
                tipovolume CHAR(32),
                tipoDocumetno VARCHAR(1),
                localdescargafornecedor VARCHAR(64) NOT NULL,
                idempresa INTEGER NOT NULL,
                idFornecedor VARCHAR(256) NOT NULL,
                CONSTRAINT agendadescargafornecedornotas_pk PRIMARY KEY (idAgendaDescargaFornecedorNotas)
);
COMMENT ON COLUMN AgendaDescargaFornecedorNotas.tipoDocumetno IS 'N-Nota,  P-Pedido';


ALTER SEQUENCE seq_idagendadescargafornecedornotas OWNED BY AgendaDescargaFornecedorNotas.idAgendaDescargaFornecedorNotas;

CREATE SEQUENCE seq_idagendadescargafornecedormidia;

CREATE TABLE AgendaDescargaFornecedorMidia (
                idAgendaDescargaFornecedorMidia INTEGER NOT NULL DEFAULT nextval('seq_idagendadescargafornecedormidia'),
                dataAgendamento DATE NOT NULL,
                horaAgendamento VARCHAR(8) NOT NULL,
                nomeMidia VARCHAR(255) NOT NULL,
                midia BYTEA,
                extensaoMidia VARCHAR(32),
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                situacao CHAR(1) NOT NULL,
                localdescargafornecedor VARCHAR(64) NOT NULL,
                idempresa INTEGER NOT NULL,
                idFornecedor VARCHAR(256) NOT NULL,
                CONSTRAINT agendadescargafornecedormidia_pk PRIMARY KEY (idAgendaDescargaFornecedorMidia)
);
COMMENT ON COLUMN AgendaDescargaFornecedorMidia.situacao IS 'A-Ativo ou I-Inativo';


ALTER SEQUENCE seq_idagendadescargafornecedormidia OWNED BY AgendaDescargaFornecedorMidia.idAgendaDescargaFornecedorMidia;

CREATE SEQUENCE seq_idcoletaproduto;

CREATE TABLE ColetaProduto (
                idColetaProduto INTEGER NOT NULL DEFAULT nextval('seq_idcoletaproduto'),
                descricao VARCHAR(256) NOT NULL,
                dataColeta DATE NOT NULL,
                idUsuarioColeta INTEGER NOT NULL,
                tipoColeta VARCHAR(255) DEFAULT '01',
                idempresa INTEGER,
                CONSTRAINT coletaproduto_pk PRIMARY KEY (idColetaProduto)
);
COMMENT ON COLUMN ColetaProduto.tipoColeta IS 'Identifica o tipo de coleta.  01-Inventário 02-Validade ';


ALTER SEQUENCE seq_idcoletaproduto OWNED BY ColetaProduto.idColetaProduto;

CREATE SEQUENCE seq_idinventarioagendacoletaproduto;

CREATE TABLE InventarioAgendaColetaProduto (
                idInventarioAgendaColetaProduto INTEGER NOT NULL DEFAULT nextval('seq_idinventarioagendacoletaproduto'),
                idInventarioAgenda INTEGER NOT NULL,
                idColetaProduto INTEGER NOT NULL,
                CONSTRAINT inventarioagendacoletaproduto_pk PRIMARY KEY (idInventarioAgendaColetaProduto)
);
COMMENT ON TABLE InventarioAgendaColetaProduto IS 'Armazena a ligação entre o planejamento do inventário e a coleta realizada. ';


ALTER SEQUENCE seq_idinventarioagendacoletaproduto OWNED BY InventarioAgendaColetaProduto.idInventarioAgendaColetaProduto;

CREATE SEQUENCE seq_idcoletaprodutoitem;

CREATE TABLE ColetaProdutoItem (
                idColetaProdutoItem INTEGER NOT NULL DEFAULT nextval('seq_idcoletaprodutoitem'),
                idColetaProduto INTEGER NOT NULL,
                codigoBarras VARCHAR(14) NOT NULL,
                dataInformada DATE,
                quantidade NUMERIC(15,4),
                dataInclusao DATE,
                horaInclusao VARCHAR(10),
                idUsuarioInclusao INTEGER,
                idLocalEstoque INTEGER,
                CONSTRAINT coletaprodutoitem_pk PRIMARY KEY (idColetaProdutoItem)
);
COMMENT ON COLUMN ColetaProdutoItem.dataInformada IS 'Data Genérica, podendo ser Data de Validade do Produto, Data de Planejamento';
COMMENT ON COLUMN ColetaProdutoItem.quantidade IS 'Quantidade de Produtos. ';
COMMENT ON COLUMN ColetaProdutoItem.dataInclusao IS 'Data que a Coleta foi Realizada.';


ALTER SEQUENCE seq_idcoletaprodutoitem OWNED BY ColetaProdutoItem.idColetaProdutoItem;

CREATE SEQUENCE seq_idamostragem;

CREATE TABLE Amostragem (
                idAmostragem INTEGER NOT NULL DEFAULT nextval('seq_idamostragem'),
                idempresa INTEGER NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                numDocumento VARCHAR(35),
                idUsuarioInclusao INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                tipoAmostragem CHAR(3),
                CONSTRAINT amostragem_pk PRIMARY KEY (idAmostragem)
);
COMMENT ON COLUMN Amostragem.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';


ALTER SEQUENCE seq_idamostragem OWNED BY Amostragem.idAmostragem;

CREATE SEQUENCE recursopermissao_idrecursopermissao_seq;

CREATE TABLE RecursoPermissao (
                idRecursoPermissao INTEGER NOT NULL DEFAULT nextval('recursopermissao_idrecursopermissao_seq'),
                idRecursoTipo VARCHAR(128) NOT NULL,
                idRecurso VARCHAR(255) NOT NULL,
                tipoGrupoUsuario CHAR(1) NOT NULL,
                idempresa INTEGER,
                tipoPermissao CHAR(1) NOT NULL,
                permissoes VARCHAR(12345) NOT NULL,
                dataAlteracao DATE NOT NULL,
                horaAlteracao VARCHAR(10) NOT NULL,
                idUsuarioAlteracao INTEGER,
                descricaoRecurso VARCHAR(255) NOT NULL,
                idGrupoUsuario INTEGER NOT NULL,
                CONSTRAINT recursopermissao_pk PRIMARY KEY (idRecursoPermissao)
);
COMMENT ON COLUMN RecursoPermissao.idRecurso IS 'ID do Registro. Ex.  1020-Rendimento Acougue, 15-Grupo de Produtos Limpeza';
COMMENT ON COLUMN RecursoPermissao.tipoGrupoUsuario IS 'G-Grupo U-Usuário';
COMMENT ON COLUMN RecursoPermissao.tipoPermissao IS 'L-Liberacao, R-Restricao';


ALTER SEQUENCE recursopermissao_idrecursopermissao_seq OWNED BY RecursoPermissao.idRecursoPermissao;

CREATE SEQUENCE seq_idressuppedidocompra;

CREATE TABLE RessupPedidoCompra (
                idRessupPedidoCompra INTEGER NOT NULL DEFAULT nextval('seq_idressuppedidocompra'),
                idempresa INTEGER NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                dataEmissao DATE NOT NULL,
                horaEmissao VARCHAR(10) NOT NULL,
                idPedidoErp VARCHAR(10),
                dataIntegracao DATE,
                horaIntegracao VARCHAR(10),
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                idUsuarioGravacao INTEGER NOT NULL,
                tipoPedido VARCHAR(10) NOT NULL,
                observacao VARCHAR(2048),
                idPessoaRepresentante VARCHAR(128),
                dataDemandaPedido DATE,
                CONSTRAINT ressuppedidocompra_pk PRIMARY KEY (idRessupPedidoCompra)
);
COMMENT ON TABLE RessupPedidoCompra IS 'Pedido de Compra de reposição de lojas';
COMMENT ON COLUMN RessupPedidoCompra.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN RessupPedidoCompra.dataIntegracao IS 'Data que o Pedido subiu para o ERP';
COMMENT ON COLUMN RessupPedidoCompra.horaIntegracao IS 'Hora que o Pedido subiu para o ERP';
COMMENT ON COLUMN RessupPedidoCompra.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN RessupPedidoCompra.tipoPedido IS 'Tipo de Pedido, podendo ser Reposicao ou Compra direta.  R-Reposicao    |  C-Compras';
COMMENT ON COLUMN RessupPedidoCompra.idPessoaRepresentante IS 'Código do Representante ligado ao Fornecedor. ';
COMMENT ON COLUMN RessupPedidoCompra.dataDemandaPedido IS 'O pedido pode ter sido gravado dia 5, mas foi com base na Demanda (Necessidade) do dia 4.';


ALTER SEQUENCE seq_idressuppedidocompra OWNED BY RessupPedidoCompra.idRessupPedidoCompra;

CREATE INDEX ressuppedidocompra_idx_dataemissao
 ON RessupPedidoCompra
 ( dataEmissao );

CREATE INDEX ressuppedidocompra_idx_idpessoa_idempresa
 ON RessupPedidoCompra
 ( idPessoa, idEmpresa );

CREATE INDEX ressuppedidocompra_idx_empresa_idpessoa
 ON RessupPedidoCompra
 ( idEmpresa, idPessoa );

CREATE INDEX ressuppedidocompra_idx_idpedidoerp_idempresa
 ON RessupPedidoCompra
 ( idPedidoErp, idEmpresa );

CREATE TABLE IndicadorGestaoAuxiliar (
                idIndicadorGestao INTEGER NOT NULL,
                apelidoTarefaAuxiliar VARCHAR(255) NOT NULL,
                ordemPainel INTEGER,
                idUsuarioAlteracao INTEGER,
                dataAlteracao DATE,
                exibirPainel VARCHAR(10) DEFAULT 'S',
                CONSTRAINT indicadorgestaoauxiliar_pk PRIMARY KEY (idIndicadorGestao, apelidoTarefaAuxiliar)
);
COMMENT ON TABLE IndicadorGestaoAuxiliar IS 'Informações ref. Tarefas Auxiliares das kpis';
COMMENT ON COLUMN IndicadorGestaoAuxiliar.apelidoTarefaAuxiliar IS 'Tarefa Auxiliar';
COMMENT ON COLUMN IndicadorGestaoAuxiliar.ordemPainel IS 'Identifica a posição da tarefa auxiliar dentro do painel da kpi Mae. ';
COMMENT ON COLUMN IndicadorGestaoAuxiliar.exibirPainel IS 'S-> Sim exibe no Painel | N-> Não exibe no Painel.';


CREATE SEQUENCE seq_idimpressaoprecolayout;

CREATE TABLE ImpressaoPrecoLayout (
                idImpressaoPrecoLayout INTEGER NOT NULL DEFAULT nextval('seq_idimpressaoprecolayout'),
                descricao VARCHAR(128) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                formLayout VARCHAR(1234) NOT NULL,
                CONSTRAINT impressaoprecolayout_pk PRIMARY KEY (idImpressaoPrecoLayout)
);


ALTER SEQUENCE seq_idimpressaoprecolayout OWNED BY ImpressaoPrecoLayout.idImpressaoPrecoLayout;

CREATE SEQUENCE seq_idsolicitacaoantecipacaorecebiveis;

CREATE TABLE SolicitacaoAntecipacaoRecebiveis (
                idSolicitacaoAntecipacaoRecebiveis INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaoantecipacaorecebiveis'),
                dataSolicitacao DATE NOT NULL,
                dataCredito DATE NOT NULL,
                percTaxaAplicada NUMERIC(15,6) NOT NULL,
                horaSolicitacao VARCHAR(8) NOT NULL,
                idempresa INTEGER NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                valorAbatimento NUMERIC(15,2),
                dataSituacao DATE,
                horaSituacao VARCHAR(8),
                situacao CHAR(1) NOT NULL,
                documento VARCHAR(255) NOT NULL,
                observacao VARCHAR(255),
                parcela VARCHAR(10) NOT NULL,
                idUsuarioSituacao INTEGER,
                idPessoaContaBancaria INTEGER,
                idInstituicaoFinanceira INTEGER,
                abatimentoRealizado CHAR(1) DEFAULT 'N',
                dataAbatimento DATE,
                horaAbatimento VARCHAR(10),
                CONSTRAINT solicitacaoantecipacaorecebiveis_pk PRIMARY KEY (idSolicitacaoAntecipacaoRecebiveis)
);
COMMENT ON COLUMN SolicitacaoAntecipacaoRecebiveis.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN SolicitacaoAntecipacaoRecebiveis.situacao IS 'P - Pendente, A - Aprovado, R - Reprovado';
COMMENT ON COLUMN SolicitacaoAntecipacaoRecebiveis.abatimentoRealizado IS 'S-Sim para abatimento realizado no Contas a Pagar. N-Não para Não. ';
COMMENT ON COLUMN SolicitacaoAntecipacaoRecebiveis.dataAbatimento IS 'Data em que aconteceu o abatimento.';
COMMENT ON COLUMN SolicitacaoAntecipacaoRecebiveis.horaAbatimento IS 'Hora que aconteceu o Abatimento.';


ALTER SEQUENCE seq_idsolicitacaoantecipacaorecebiveis OWNED BY SolicitacaoAntecipacaoRecebiveis.idSolicitacaoAntecipacaoRecebiveis;

CREATE TABLE UsuarioConfig (
                idUsuario INTEGER NOT NULL,
                questoesContinuadas CHAR(1) DEFAULT 'N' NOT NULL,
                esconderRespostas CHAR(1) DEFAULT 'N' NOT NULL,
                finalizarRespostas CHAR(1) DEFAULT 'N' NOT NULL,
                localizacaoObrigatoria CHAR(1) DEFAULT 'N',
                CONSTRAINT usuarioconfig_pk PRIMARY KEY (idUsuario)
);
COMMENT ON COLUMN UsuarioConfig.questoesContinuadas IS 'S-Sim, N-Não';
COMMENT ON COLUMN UsuarioConfig.esconderRespostas IS 'S-Sim, N-Não';
COMMENT ON COLUMN UsuarioConfig.finalizarRespostas IS 'S-Sim, N-Não';
COMMENT ON COLUMN UsuarioConfig.localizacaoObrigatoria IS 'S-Sim, N-Não';


CREATE SEQUENCE seq_idspedimportacao;

CREATE TABLE sped_importacao (
                idSpedImportacao INTEGER NOT NULL DEFAULT nextval('seq_idspedimportacao'),
                idempresa INTEGER NOT NULL,
                idUsuario INTEGER NOT NULL,
                dataImportacao DATE NOT NULL,
                horaImportacao VARCHAR(8) NOT NULL,
                cod_ver INTEGER NOT NULL,
                cod_fin INTEGER NOT NULL,
                dt_ini DATE NOT NULL,
                dt_fin DATE NOT NULL,
                nome VARCHAR(100) NOT NULL,
                cnpj VARCHAR(14),
                cpf VARCHAR(11),
                nomearquivo VARCHAR(128),
                extarquivo VARCHAR(3),
                tamanhoarquivo INTEGER,
                CONSTRAINT sped_importacao_pk PRIMARY KEY (idSpedImportacao)
);
COMMENT ON COLUMN sped_importacao.cod_ver IS 'Código da versão do leiaute conforme a tabela indicado no Ato COTEPE.';
COMMENT ON COLUMN sped_importacao.cod_fin IS 'Código da finalidade do arquivo: 0 -  Remessa do arquivo original 1 - Remessa do arquivo substituto';
COMMENT ON COLUMN sped_importacao.dt_ini IS 'Data inicial das informações contidas no arquivo';
COMMENT ON COLUMN sped_importacao.dt_fin IS 'Data final das informações contidas no arquivo';
COMMENT ON COLUMN sped_importacao.nome IS 'Nome empresarial da entidade';
COMMENT ON COLUMN sped_importacao.cnpj IS 'Número de inscrição da entidade no CNPJ';
COMMENT ON COLUMN sped_importacao.cpf IS 'Número de inscrição da entidade no CPF';


ALTER SEQUENCE seq_idspedimportacao OWNED BY sped_importacao.idSpedImportacao;

CREATE SEQUENCE seq_idspedentradasaida;

CREATE TABLE sped_entradasaida (
                idSpedEntradaSaida INTEGER NOT NULL DEFAULT nextval('seq_idspedentradasaida'),
                idSpedImportacao INTEGER NOT NULL,
                reg VARCHAR(4) NOT NULL,
                ind_oper CHAR(1) NOT NULL,
                cod_part VARCHAR(60),
                cod_mod VARCHAR(2),
                cod_sit INTEGER,
                ser VARCHAR(3),
                num_doc INTEGER,
                chv_nfe VARCHAR(100),
                dt_doc DATE,
                dt_e_s DATE,
                num_item INTEGER,
                cod_item VARCHAR(60) NOT NULL,
                qtd NUMERIC(15,5),
                unid VARCHAR(6),
                vl_item NUMERIC(15,2),
                vl_desc NUMERIC(15,2),
                cfop INTEGER,
                vl_icms NUMERIC(15,2),
                vl_icms_st NUMERIC(15,2),
                vl_ipi NUMERIC(15,2),
                vl_pis NUMERIC(15,2),
                vl_cofins NUMERIC(15,2),
                cod_cta VARCHAR(100),
                CONSTRAINT sped_entradasaida_pk PRIMARY KEY (idSpedEntradaSaida)
);
COMMENT ON COLUMN sped_entradasaida.ind_oper IS '0 - Entrada 1 - Saída';
COMMENT ON COLUMN sped_entradasaida.cod_part IS 'Codigo do participante - do emitente do documento ou do remetente das mercadorias, no caso de entradas - do adquirente, no caso de saídas';
COMMENT ON COLUMN sped_entradasaida.cod_mod IS 'Código do modelo do documento fiscal';
COMMENT ON COLUMN sped_entradasaida.cod_sit IS 'Código da situação do documento fiscal';
COMMENT ON COLUMN sped_entradasaida.ser IS 'Série do documento fiscal';
COMMENT ON COLUMN sped_entradasaida.num_doc IS 'Número do documento fiscal';
COMMENT ON COLUMN sped_entradasaida.chv_nfe IS 'Chave da Nota Fiscal Eletrônica';
COMMENT ON COLUMN sped_entradasaida.dt_doc IS 'Data da emissão do documento fiscal';
COMMENT ON COLUMN sped_entradasaida.dt_e_s IS 'Data da entrada ou da saída';
COMMENT ON COLUMN sped_entradasaida.num_item IS 'Número sequencial do item no documento fiscal';
COMMENT ON COLUMN sped_entradasaida.cod_item IS 'Código do item';
COMMENT ON COLUMN sped_entradasaida.qtd IS 'Quantidade do item';
COMMENT ON COLUMN sped_entradasaida.unid IS 'Unidade do item';
COMMENT ON COLUMN sped_entradasaida.vl_item IS 'Valor total do item';
COMMENT ON COLUMN sped_entradasaida.vl_desc IS 'Valor do desconto comercial';
COMMENT ON COLUMN sped_entradasaida.cfop IS 'Código Fiscal de Operações e Prestação';
COMMENT ON COLUMN sped_entradasaida.vl_icms IS 'Valor do ICMS creditado/debitado';
COMMENT ON COLUMN sped_entradasaida.vl_ipi IS 'Valor do IPI creditado/debitado';
COMMENT ON COLUMN sped_entradasaida.vl_pis IS 'Valor do PIS';


ALTER SEQUENCE seq_idspedentradasaida OWNED BY sped_entradasaida.idSpedEntradaSaida;

CREATE INDEX sped_entradasaida_idx_dt_e_s
 ON sped_entradasaida
 ( dt_e_s );

CREATE SEQUENCE seq_idspedinventario;

CREATE TABLE sped_inventario (
                idSpedInventario INTEGER NOT NULL DEFAULT nextval('seq_idspedinventario'),
                cod_item VARCHAR(60) NOT NULL,
                dt_inv DATE NOT NULL,
                idSpedImportacao INTEGER NOT NULL,
                reg VARCHAR(4) NOT NULL,
                unid VARCHAR(6),
                qtd NUMERIC(15,3),
                vl_unit NUMERIC(15,6),
                vl_item NUMERIC(15,2),
                ind_prop CHAR(1),
                cod_part VARCHAR(60),
                txt_compl VARCHAR(255),
                cod_cta VARCHAR(10),
                vl_item_ir NUMERIC(15,2),
                CONSTRAINT sped_inventario_pk PRIMARY KEY (idSpedInventario)
);
COMMENT ON COLUMN sped_inventario.cod_item IS 'código do item';
COMMENT ON COLUMN sped_inventario.dt_inv IS 'Data do inventário';
COMMENT ON COLUMN sped_inventario.reg IS 'Tipo do registro';
COMMENT ON COLUMN sped_inventario.unid IS 'Unidade do item';
COMMENT ON COLUMN sped_inventario.qtd IS 'quantidade do item';
COMMENT ON COLUMN sped_inventario.vl_unit IS 'valor unitário do item';
COMMENT ON COLUMN sped_inventario.vl_item IS 'Valor do item';
COMMENT ON COLUMN sped_inventario.ind_prop IS 'Indicador de propriedade/posse do item: 0- Item de propriedade do informante e em seu poder 1- Item de propriedade do informante em posse de terceiros 2- Item de propriedade de terceiros em posse do informante';
COMMENT ON COLUMN sped_inventario.cod_part IS 'Código do participante';
COMMENT ON COLUMN sped_inventario.txt_compl IS 'Descrição complementar';
COMMENT ON COLUMN sped_inventario.cod_cta IS 'Código da conta analítica contábil debitada/creditada';
COMMENT ON COLUMN sped_inventario.vl_item_ir IS 'Valor do item para efeitos do imposto de renda.';


ALTER SEQUENCE seq_idspedinventario OWNED BY sped_inventario.idSpedInventario;

CREATE INDEX sped_inventario_idx_cod_item
 ON sped_inventario
 ( cod_item );

CREATE INDEX sped_inventario_idx_dt_inv
 ON sped_inventario
 ( dt_inv );

CREATE SEQUENCE seq_idnoticia;

CREATE TABLE noticia (
                idNoticia INTEGER NOT NULL DEFAULT nextval('seq_idnoticia'),
                idUsuarioCadastro INTEGER NOT NULL,
                dataCadastro DATE NOT NULL,
                dataAlteracao DATE NOT NULL,
                descricao VARCHAR(2048) NOT NULL,
                dataInicial DATE NOT NULL,
                dataFinal DATE NOT NULL,
                arquivo BYTEA,
                extensaoarquivo VARCHAR(32),
                CONSTRAINT noticia_pk PRIMARY KEY (idNoticia)
);


ALTER SEQUENCE seq_idnoticia OWNED BY noticia.idNoticia;

CREATE SEQUENCE seq_idwfligaprodutofornecedor;

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
);
COMMENT ON TABLE WFLigaProdutoFornecedor IS 'Armazena as solicitações de Associações de Produtos aos Fornecedores.  ';
COMMENT ON COLUMN WFLigaProdutoFornecedor.situacao IS 'P-Pendente, R-Rejeitado, A-Aprovado.';
COMMENT ON COLUMN WFLigaProdutoFornecedor.erroEncontrado IS '1-Ean 2-Chave Nfe-e 3-Produto Excluído 4-Produto sem Cadastro 5-Outros.';


ALTER SEQUENCE seq_idwfligaprodutofornecedor OWNED BY WFLigaProdutoFornecedor.idWFLigaProdutoFornecedor;

CREATE SEQUENCE seq_idindicadorgestaomovimentodoc;

CREATE TABLE IndicadorGestaoMovimentoDoc (
                idIndicadorGestaoMovimentoDoc INTEGER NOT NULL DEFAULT nextval('seq_idindicadorgestaomovimentodoc'),
                idIndicadorGestaoMovimento INTEGER NOT NULL,
                idUsuario INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                observacao VARCHAR(2048),
                CONSTRAINT indicadorgestaomovimentodoc_pk PRIMARY KEY (idIndicadorGestaoMovimentoDoc)
);
COMMENT ON TABLE IndicadorGestaoMovimentoDoc IS 'Registrar observacoes do indicador de cada usuário.';


ALTER SEQUENCE seq_idindicadorgestaomovimentodoc OWNED BY IndicadorGestaoMovimentoDoc.idIndicadorGestaoMovimentoDoc;

CREATE TABLE FornecedorMonitorado (
                idempresa INTEGER NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                tipoMonitoramento VARCHAR(3) NOT NULL,
                descricao VARCHAR(255),
                dataInicio DATE,
                dataFinal DATE,
                dataCadastro DATE NOT NULL,
                idUsuarioCadastro INTEGER NOT NULL,
                CONSTRAINT fornecedormonitorado_pk PRIMARY KEY (idempresa, idPessoa, tipoMonitoramento)
);
COMMENT ON COLUMN FornecedorMonitorado.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN FornecedorMonitorado.tipoMonitoramento IS 'PED-Pedidos de Compras';
COMMENT ON COLUMN FornecedorMonitorado.dataInicio IS 'Data em que o Produto entrará em Monitoramento.';
COMMENT ON COLUMN FornecedorMonitorado.dataFinal IS 'Data em que o Produto Sairá em Monitoramento.';


CREATE SEQUENCE seq_idwfprocesso;

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
);
COMMENT ON TABLE WFProcesso IS 'Armazenará os processos possíveis na Unidade.';
COMMENT ON COLUMN WFProcesso.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN WFProcesso.usaFilaTrabalho IS 'S-Sim, N-Não. ';
COMMENT ON COLUMN WFProcesso.usaNaoConformidade IS 'S-Sim, N-Não. ';


ALTER SEQUENCE seq_idwfprocesso OWNED BY WFProcesso.idWFProcesso;

CREATE TABLE WFInputProcesso (
                idWFInput INTEGER NOT NULL,
                idWFProcesso INTEGER NOT NULL,
                CONSTRAINT wfinputprocesso_pk PRIMARY KEY (idWFInput, idWFProcesso)
);


CREATE TABLE WFColunaProcesso (
                idWFColuna INTEGER NOT NULL,
                idWFProcesso INTEGER NOT NULL,
                CONSTRAINT wfcolunaprocesso_pk PRIMARY KEY (idWFColuna, idWFProcesso)
);


CREATE TABLE WFProcessoPermissao (
                idWFProcesso INTEGER NOT NULL,
                idGrupoUsuario INTEGER NOT NULL,
                tipoGrupoUsuario CHAR(1) NOT NULL,
                abrir CHAR(1) DEFAULT 'S' NOT NULL,
                receber CHAR(1) DEFAULT 'S' NOT NULL,
                CONSTRAINT wfprocessopermissao_pk PRIMARY KEY (idWFProcesso, idGrupoUsuario, tipoGrupoUsuario)
);
COMMENT ON COLUMN WFProcessoPermissao.tipoGrupoUsuario IS 'G-Grupo U-Usuário';
COMMENT ON COLUMN WFProcessoPermissao.abrir IS 'S-Sim N-Não';
COMMENT ON COLUMN WFProcessoPermissao.receber IS 'S-Sim N-Não';


CREATE SEQUENCE seq_wfatividade;

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
);
COMMENT ON COLUMN WFAtividade.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN WFAtividade.tempoExpiracao IS 'dataInclusão + horaInclusão + tempoExpiracao devem ser menores que dataHoraAtual. Caso exceda deve ser gravado a atividade expiração.';
COMMENT ON COLUMN WFAtividade.tipoTempoExpiracao IS 'MINUTO,HORA,DIA,SEMANA,MES';
COMMENT ON COLUMN WFAtividade.ignoraEmpresaWFAtividadeColaborador IS 'S - Sim, N - Não';


ALTER SEQUENCE seq_wfatividade OWNED BY WFAtividade.idWFAtividade;

CREATE TABLE WFColunaAtividade (
                idWFColuna INTEGER NOT NULL,
                idWFAtividade INTEGER NOT NULL,
                CONSTRAINT wfcolunaatividade_pk PRIMARY KEY (idWFColuna, idWFAtividade)
);


CREATE TABLE WFInputAtividade (
                idWFInput INTEGER NOT NULL,
                idWFAtividade INTEGER NOT NULL,
                CONSTRAINT wfinputatividade_pk PRIMARY KEY (idWFInput, idWFAtividade)
);


CREATE SEQUENCE seq_idwfatividaderealizada;

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
);
COMMENT ON COLUMN WFAtividadeRealizada.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN WFAtividadeRealizada.tipoSituacao IS 'F-Finalizada, S-Sequencia ';
COMMENT ON COLUMN WFAtividadeRealizada.idWFAtividadeProxima IS 'Identifica a próxima atividade para gerar nova fila. ';


ALTER SEQUENCE seq_idwfatividaderealizada OWNED BY WFAtividadeRealizada.idWFAtividadeRealizada;

CREATE SEQUENCE seq_idwfprocessoevento;

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
);
COMMENT ON COLUMN WFProcessoEvento.tempoExpiracao IS 'dataInclusão + horaInclusão + tempoExpiracao devem ser menores que dataHoraAtual. Caso exceda deve ser gravado a atividade expiração.';
COMMENT ON COLUMN WFProcessoEvento.tipoTempoExpiracao IS 'MINUTO,HORA,DIA,SEMANA,MES';


ALTER SEQUENCE seq_idwfprocessoevento OWNED BY WFProcessoEvento.idWFProcessoEvento;

CREATE SEQUENCE seq_idalternativaintegracaonf;

CREATE TABLE AlternativaIntegracaoNF (
                idAlternativaIntegracaoNF INTEGER NOT NULL DEFAULT nextval('seq_idalternativaintegracaonf'),
                idalternativa INTEGER NOT NULL,
                idWFProcesso INTEGER NOT NULL,
                idWFProcessoEvento INTEGER NOT NULL,
                idUsuarioResponsavel INTEGER NOT NULL,
                quantidadeOcorrencia INTEGER NOT NULL,
                CONSTRAINT alternativaintegracaonf_pk PRIMARY KEY (idAlternativaIntegracaoNF)
);
COMMENT ON TABLE AlternativaIntegracaoNF IS 'Integração com Não Conformidade. ';


ALTER SEQUENCE seq_idalternativaintegracaonf OWNED BY AlternativaIntegracaoNF.idAlternativaIntegracaoNF;

CREATE SEQUENCE seq_wffilatrabalho;

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
);
COMMENT ON COLUMN WFFilaTrabalho.expirada IS 'S - Sim, N - Não';
COMMENT ON COLUMN WFFilaTrabalho.ciente IS 'S - Sim, N - Não';


ALTER SEQUENCE seq_wffilatrabalho OWNED BY WFFilaTrabalho.idWFFilaTrabalho;

CREATE INDEX wffilatrabalho_datainclusao_idx
 ON WFFilaTrabalho
 ( dataInclusao );

CREATE INDEX wffilatrabalho_idx_idwfocorrencia
 ON WFFilaTrabalho
 ( idWFOcorrencia );

CREATE INDEX wffilatrabalho_idx_idempresa_idwfatividade_idusuarioresponsa161
 ON WFFilaTrabalho
 ( idEmpresa, idWFAtividade, idUsuarioResponsavel, idWFAtividadeRealizada );

CREATE INDEX wffilatrabalho_idx_idresponsavel_idemp_atv_expirada_atvrea
 ON WFFilaTrabalho
 ( idUsuarioResponsavel, idEmpresa, idWFAtividade, expirada, idWFAtividadeRealizada );

CREATE TABLE WFFilatrabalhoNotificacao (
                idWFFilaTrabalho INTEGER NOT NULL,
                dataNotificacao DATE NOT NULL,
                horaNotificacao VARCHAR(8) NOT NULL,
                CONSTRAINT wffilatrabalhonotificacao_pk PRIMARY KEY (idWFFilaTrabalho)
);


CREATE SEQUENCE seq_idwffilatrabalhousuariovisualizacao;

CREATE TABLE WFFilaTrabalhoUsuarioVisualizacao (
                idWFFilaTrabalhoUsuarioVisualizacao INTEGER NOT NULL DEFAULT nextval('seq_idwffilatrabalhousuariovisualizacao'),
                idWFFilaTrabalho INTEGER NOT NULL,
                idUsuario INTEGER NOT NULL,
                dataVisualizacao DATE NOT NULL,
                horaVisualizacao VARCHAR(8) NOT NULL,
                CONSTRAINT wffilatrabalhousuariovisualizacao_pk PRIMARY KEY (idWFFilaTrabalhoUsuarioVisualizacao)
);
COMMENT ON COLUMN WFFilaTrabalhoUsuarioVisualizacao.dataVisualizacao IS 'Data em que o usuário visualizou a fila no cadastro de minhas ocorrencias.';
COMMENT ON COLUMN WFFilaTrabalhoUsuarioVisualizacao.horaVisualizacao IS 'hora em que o usuário visualizou a fila de trabalho no cadastro de minhas ocorrencias.';


ALTER SEQUENCE seq_idwffilatrabalhousuariovisualizacao OWNED BY WFFilaTrabalhoUsuarioVisualizacao.idWFFilaTrabalhoUsuarioVisualizacao;

CREATE INDEX wffilatrabalhousuariovisualizacao_idusuario_datavisualizacao205
 ON WFFilaTrabalhoUsuarioVisualizacao
 ( idUsuario, dataVisualizacao );

CREATE TABLE WFFilaTrabalhoCausa (
                idWFFilaTrabalho INTEGER NOT NULL,
                idWFCausa INTEGER NOT NULL,
                descricao VARCHAR(255),
                CONSTRAINT wffilatrabalhocausa_pk PRIMARY KEY (idWFFilaTrabalho, idWFCausa)
);


CREATE SEQUENCE seq_idwffilatrabalhocomentario;

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
);
COMMENT ON COLUMN WFFilaTrabalhoComentario.texto IS 'Usuário poderá informar uma descrição para o documento anexado.';
COMMENT ON COLUMN WFFilaTrabalhoComentario.extDocAnexo IS 'Extensao do documento anexado.';
COMMENT ON COLUMN WFFilaTrabalhoComentario.visualizado IS 'S - Sim N - Não';


ALTER SEQUENCE seq_idwffilatrabalhocomentario OWNED BY WFFilaTrabalhoComentario.idWFFilaTrabalhoComentario;

CREATE INDEX wffilatrabalhocomentario_idx_idwffilatrabalho
 ON WFFilaTrabalhoComentario
 ( idWFFilaTrabalho );

CREATE SEQUENCE seq_idwfocorrencia;

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
);
COMMENT ON COLUMN WFOcorrencia.descricao IS 'Usuário poderá informar uma descrição para o documento anexado.';
COMMENT ON COLUMN WFOcorrencia.chave IS 'campo destinado a ser excluído com o tempo.  27/04/2017 . Marques e Elcio. ';
COMMENT ON COLUMN WFOcorrencia.tipoInclusao IS 'A-Automatico , M-Manual ';
COMMENT ON COLUMN WFOcorrencia.idTarefaExecucaoInclusao IS 'Tarefa que incluiu a ocorrencia';
COMMENT ON COLUMN WFOcorrencia.idTarefaExecucao IS 'Sera trocada com o tempo por idTarefaExecucaoInclusao';
COMMENT ON COLUMN WFOcorrencia.tipoEncaminhamento IS 'A-Automatico via lógica sequencial de próxima atividade  M-Manual direcionada pelo usuário.  ';
COMMENT ON COLUMN WFOcorrencia.apelidoTarefaEncaminhamento IS 'Caso necessário de encaminamento automático, a tarefa deverá filtrar por esse campo. ';
COMMENT ON COLUMN WFOcorrencia.requerConfirmacao IS 'S-Sim,N-Não';
COMMENT ON COLUMN WFOcorrencia.dataConfirmacao IS 'Quando a ocorrencia foi confirmada como resolvida';
COMMENT ON COLUMN WFOcorrencia.horaConfirmacao IS 'Quando a ocorrencia foi confirmada como resolvida';
COMMENT ON COLUMN WFOcorrencia.expirada IS 'S - Sim, N - Não';
COMMENT ON COLUMN WFOcorrencia.inativa IS 'S - Sim, N - Não';


ALTER SEQUENCE seq_idwfocorrencia OWNED BY WFOcorrencia.idWFOcorrencia;

CREATE INDEX wfocorrencia_idx_inativa_tipo_inclusao_usuarioinclusao
 ON WFOcorrencia
 ( tipoInclusao, idUsuarioInclusao, inativa );

CREATE INDEX wfocorrencia_idx_datainclusao_inativa_tipoinclusao
 ON WFOcorrencia
 ( dataInclusao, inativa, tipoInclusao );

CREATE INDEX wfocorrencia_idx_idwfprocessoevento_idempresa_idproduto
 ON WFOcorrencia
 ( idWFProcessoEvento, idEmpresa, chaves );

CREATE SEQUENCE seq_idwfocorrenciapessoa;

CREATE TABLE WFOcorrenciaPessoa (
                idWFOcorrenciaPessoa INTEGER NOT NULL DEFAULT nextval('seq_idwfocorrenciapessoa'),
                idWFOcorrencia INTEGER NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                tipo CHAR(2) DEFAULT 'OU' NOT NULL,
                CONSTRAINT wfocorrenciapessoa_pk PRIMARY KEY (idWFOcorrenciaPessoa)
);
COMMENT ON COLUMN WFOcorrenciaPessoa.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN WFOcorrenciaPessoa.tipo IS 'RE-RESPONSAVEL, AP-APOIADOR, MO-MONITORADOR, OU-OUTROS';


ALTER SEQUENCE seq_idwfocorrenciapessoa OWNED BY WFOcorrenciaPessoa.idWFOcorrenciaPessoa;

CREATE SEQUENCE seq_idwfocorrenciaanexo;

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
);
COMMENT ON TABLE WFOcorrenciaAnexo IS 'Armazenará documentos, imagens, planilhas etc... ligados a Fila de Trabalho aberta.';
COMMENT ON COLUMN WFOcorrenciaAnexo.descricao IS 'Usuário poderá informar uma descrição para o documento anexado.';
COMMENT ON COLUMN WFOcorrenciaAnexo.extDocAnexo IS 'Extensao do documento anexado.';


ALTER SEQUENCE seq_idwfocorrenciaanexo OWNED BY WFOcorrenciaAnexo.idWFOcorrenciaAnexo;

CREATE SEQUENCE seq_idwfocorrenciadetalhe;

CREATE TABLE WFOcorrenciaDetalhe (
                idWFOcorrenciaDetalhe INTEGER NOT NULL DEFAULT nextval('seq_idwfocorrenciadetalhe'),
                descricao VARCHAR(2048),
                idWFOcorrencia INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                CONSTRAINT wfocorrenciadetalhe_pk PRIMARY KEY (idWFOcorrenciaDetalhe)
);
COMMENT ON TABLE WFOcorrenciaDetalhe IS 'Descrição detalhada do Problema. ';


ALTER SEQUENCE seq_idwfocorrenciadetalhe OWNED BY WFOcorrenciaDetalhe.idWFOcorrenciaDetalhe;

CREATE SEQUENCE funcaocolaborador_idfuncao_seq;

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
);
COMMENT ON COLUMN FuncaoColaborador.cargaHorariaDia IS 'Carga horária da função no dia. ';
COMMENT ON COLUMN FuncaoColaborador.horasExtrasLimiteDia IS 'Qtde de horas extras no dia que serão aceitaveis pra a funcao. ';


ALTER SEQUENCE funcaocolaborador_idfuncao_seq OWNED BY FuncaoColaborador.idFuncao;

CREATE INDEX funcaocolaborador_idx_descricao
 ON FuncaoColaborador
 ( descricao );

CREATE SEQUENCE seq_idsolicitacaosuprimentoetapafuncao;

CREATE TABLE SolicitacaoSuprimentoEtapaFuncao (
                idSolicitacaoSuprimentoEtapaFuncao INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimentoetapafuncao'),
                idSolicitacaoSuprimentoEtapa INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                idFuncao INTEGER NOT NULL,
                CONSTRAINT solicitacaosuprimentoetapafuncao_pk PRIMARY KEY (idSolicitacaoSuprimentoEtapaFuncao)
);
COMMENT ON TABLE SolicitacaoSuprimentoEtapaFuncao IS 'Funcoes que terão acesso em acesso e/ou liberações da Etapa. ';


ALTER SEQUENCE seq_idsolicitacaosuprimentoetapafuncao OWNED BY SolicitacaoSuprimentoEtapaFuncao.idSolicitacaoSuprimentoEtapaFuncao;

CREATE TABLE questionariofuncaocolaborador (
                idquestionario INTEGER NOT NULL,
                idfuncao INTEGER NOT NULL,
                tipo CHAR(1) NOT NULL,
                CONSTRAINT questionariofuncaocolaborador_pk PRIMARY KEY (idquestionario, idfuncao, tipo)
);
COMMENT ON COLUMN questionariofuncaocolaborador.tipo IS 'V-Avaliador,P-Aplicador';


CREATE SEQUENCE seq_idcolaborador;

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
);
COMMENT ON COLUMN Colaborador.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN Colaborador.fotoExtensao IS 'jpg, gif, png, etc.';
COMMENT ON COLUMN Colaborador.apelido IS 'Nome de identificação resumida do colaborador.';
COMMENT ON COLUMN Colaborador.localAtendimento IS 'Normalmente utilizado por Compradores para especificar o local onde irão atender ao Vendedor (Fornecedor) incluído na Agenda de Atendimento. ';
COMMENT ON COLUMN Colaborador.dataNascimento IS 'Data de Nascimento do Colaborador.';
COMMENT ON COLUMN Colaborador.idColaboradorRh IS 'Código do Colaborador no Software de RH ou origem de importação do cadastro do colaborador.  ';


ALTER SEQUENCE seq_idcolaborador OWNED BY Colaborador.idColaborador;

CREATE INDEX colaborador_idx_idcolaboradorrh
 ON Colaborador
 ( idColaboradorRh );

CREATE SEQUENCE seq_idsenhafilaatendimento;

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
);
COMMENT ON COLUMN SenhaFilaAtendimento.tipoGeracao IS 'N-Normal P-Prioritaria';
COMMENT ON COLUMN SenhaFilaAtendimento.senhaChamada IS 'S-Sim N-Não.   ';


ALTER SEQUENCE seq_idsenhafilaatendimento OWNED BY SenhaFilaAtendimento.idSenhaFilaAtendimento;

CREATE SEQUENCE seq_idacessorapidoauxiliar;

CREATE TABLE acessorapidoauxiliar (
                idacessorapidoauxiliar INTEGER NOT NULL DEFAULT nextval('seq_idacessorapidoauxiliar'),
                painel VARCHAR(256) NOT NULL,
                empresa VARCHAR(256) NOT NULL,
                colaborador VARCHAR(256) NOT NULL,
                acessorapido VARCHAR(256) NOT NULL,
                idempresa INTEGER NOT NULL,
                idColaborador INTEGER NOT NULL,
                CONSTRAINT acessorapidoauxiliar_pk PRIMARY KEY (idacessorapidoauxiliar)
);


ALTER SEQUENCE seq_idacessorapidoauxiliar OWNED BY acessorapidoauxiliar.idacessorapidoauxiliar;

CREATE SEQUENCE seq_idmovimentoveiculo;

CREATE TABLE MovimentoVeiculo (
                idMovimentoVeiculo INTEGER NOT NULL DEFAULT nextval('seq_idmovimentoveiculo'),
                idempresa INTEGER NOT NULL,
                idVeiculo INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                idColaboradorMotorista INTEGER NOT NULL,
                idMovimentoVeiculoMotivo INTEGER NOT NULL,
                dataSaida DATE NOT NULL,
                horaSaida VARCHAR(8) NOT NULL,
                kmSaida INTEGER NOT NULL,
                dataRetorno DATE,
                horaRetorno VARCHAR(8),
                kmRetorno INTEGER,
                dataRetornoPrevisao DATE,
                horaRetornoPrevisao VARCHAR(8),
                CONSTRAINT movimentoveiculo_pk PRIMARY KEY (idMovimentoVeiculo)
);
COMMENT ON TABLE MovimentoVeiculo IS 'Tabela para armazenar movimentações de Entrada e Saída de Veículos na portaria. ';


ALTER SEQUENCE seq_idmovimentoveiculo OWNED BY MovimentoVeiculo.idMovimentoVeiculo;

CREATE SEQUENCE seq_idmovimentoveiculoajudante;

CREATE TABLE MovimentoVeiculoAjudante (
                idMovimentoVeiculoAjudante INTEGER NOT NULL DEFAULT nextval('seq_idmovimentoveiculoajudante'),
                idMovimentoVeiculo INTEGER NOT NULL,
                tipoAjudante CHAR(1),
                idColaboradorAjudante INTEGER NOT NULL,
                CONSTRAINT movimentoveiculoajudante_pk PRIMARY KEY (idMovimentoVeiculoAjudante)
);
COMMENT ON TABLE MovimentoVeiculoAjudante IS 'Destinado para registrar os ajudantes da entrega. ';
COMMENT ON COLUMN MovimentoVeiculoAjudante.tipoAjudante IS 'A-Ajudante de Descarga, M-Motorista Auxiliar. ';


ALTER SEQUENCE seq_idmovimentoveiculoajudante OWNED BY MovimentoVeiculoAjudante.idMovimentoVeiculoAjudante;

CREATE SEQUENCE seq_idmovimentoveiculocheck;

CREATE TABLE MovimentoVeiculoCheck (
                idMovimentoVeiculoCheck INTEGER NOT NULL DEFAULT nextval('seq_idmovimentoveiculocheck'),
                idMovimentoVeiculo INTEGER NOT NULL,
                idVeiculoCheck INTEGER NOT NULL,
                checkValor VARCHAR(255) NOT NULL,
                dataInclusao DATE,
                horaInclusao VARCHAR(8),
                idUsuarioInclusao INTEGER,
                CONSTRAINT movimentoveiculocheck_pk PRIMARY KEY (idMovimentoVeiculoCheck)
);
COMMENT ON TABLE MovimentoVeiculoCheck IS 'Armazena as respostas de Checagens. ';
COMMENT ON COLUMN MovimentoVeiculoCheck.checkValor IS 'Valor informado pelo usuário no momento da checagem. ';


ALTER SEQUENCE seq_idmovimentoveiculocheck OWNED BY MovimentoVeiculoCheck.idMovimentoVeiculoCheck;

CREATE SEQUENCE seq_idsolicitacaosuprimentorangeaprovacoes;

CREATE TABLE SolicitacaoSuprimentoRangeAprovacoes (
                idSolicitacaoSuprimentoRangeAprovacoes INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimentorangeaprovacoes'),
                idColaborador INTEGER NOT NULL,
                valorInicial NUMERIC(15,2) NOT NULL,
                valorFinal NUMERIC(15,2),
                CONSTRAINT solicitacaosuprimentorangeaprovacoes_pk PRIMARY KEY (idSolicitacaoSuprimentoRangeAprovacoes)
);
COMMENT ON TABLE SolicitacaoSuprimentoRangeAprovacoes IS 'Armazena os colaboradores e faixa de valor inicial e final que ele terá autorização para realizar aprovações das solicitaçoes. ';


ALTER SEQUENCE seq_idsolicitacaosuprimentorangeaprovacoes OWNED BY SolicitacaoSuprimentoRangeAprovacoes.idSolicitacaoSuprimentoRangeAprovacoes;

CREATE SEQUENCE seq_idinventarioagendaitens;

CREATE TABLE InventarioAgendaItens (
                idInventarioAgendaItens INTEGER NOT NULL DEFAULT nextval('seq_idinventarioagendaitens'),
                idInventarioAgenda INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                tipoMercadologico CHAR(1) NOT NULL,
                idMercadologico VARCHAR(255) NOT NULL,
                idColaborador INTEGER NOT NULL,
                idPessoaFornecedor VARCHAR(128),
                idPessoaFuncionario VARCHAR(128),
                CONSTRAINT inventarioagendaitens_pk PRIMARY KEY (idInventarioAgendaItens)
);
COMMENT ON TABLE InventarioAgendaItens IS 'Tabela destinada ao armazenamento das variações de programação de inventário, podendo ser por Empresa, por Mercadologico e Colaborador.';
COMMENT ON COLUMN InventarioAgendaItens.tipoMercadologico IS 'D-Departamento, S-Seção, G-Grupo, B-Subgrupo, P-Produto, V-Vendedor';
COMMENT ON COLUMN InventarioAgendaItens.idPessoaFornecedor IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN InventarioAgendaItens.idPessoaFuncionario IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';


ALTER SEQUENCE seq_idinventarioagendaitens OWNED BY InventarioAgendaItens.idInventarioAgendaItens;

CREATE SEQUENCE seq_idrefacesso;

CREATE TABLE RefAcesso (
                idRefAcesso INTEGER NOT NULL DEFAULT nextval('seq_idrefacesso'),
                idRefCadastro INTEGER NOT NULL,
                idColaborador INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                codigoAcesso VARCHAR(128) NOT NULL,
                permiteRegistroAvulso VARCHAR(1) DEFAULT 'N' NOT NULL,
                permiteRegistroTerceiros VARCHAR(1) DEFAULT 'N' NOT NULL,
                CONSTRAINT refacesso_pk PRIMARY KEY (idRefAcesso)
);
COMMENT ON TABLE RefAcesso IS 'Define os acessos e vinculo com colaborador, se hovuer.';
COMMENT ON COLUMN RefAcesso.codigoAcesso IS 'Código de acesso ao refeitório (lançamento da refeição)';
COMMENT ON COLUMN RefAcesso.permiteRegistroAvulso IS 'S->Sim | N->Não';
COMMENT ON COLUMN RefAcesso.permiteRegistroTerceiros IS 'S->Sim | N->Não';


ALTER SEQUENCE seq_idrefacesso OWNED BY RefAcesso.idRefAcesso;

CREATE SEQUENCE seq_idrefturnoexcecao;

CREATE TABLE RefTurnoExcecao (
                idRefExcecao INTEGER NOT NULL DEFAULT nextval('seq_idrefturnoexcecao'),
                idRefTurno INTEGER,
                idRefAcesso INTEGER NOT NULL,
                quantidadeRefeicaoPorAcesso INTEGER NOT NULL,
                CONSTRAINT refturnoexcecao_pk PRIMARY KEY (idRefExcecao)
);
COMMENT ON TABLE RefTurnoExcecao IS 'Exceções do recurso de refeição no registro do lançamento no turno.';
COMMENT ON COLUMN RefTurnoExcecao.idRefTurno IS 'Se a exceção é de um turno';
COMMENT ON COLUMN RefTurnoExcecao.quantidadeRefeicaoPorAcesso IS 'Quantidade de refeições liberadas no turno por acesso.';


ALTER SEQUENCE seq_idrefturnoexcecao OWNED BY RefTurnoExcecao.idRefExcecao;

CREATE SEQUENCE seq_idcampanhaofertacolaborador;

CREATE TABLE CampanhaOfertaColaborador (
                idCampanhaOfertaColaborador INTEGER NOT NULL DEFAULT nextval('seq_idcampanhaofertacolaborador'),
                idCampanhaOferta BIGINT NOT NULL,
                idColaborador INTEGER NOT NULL,
                idEntidadeRegistroAgrupamento INTEGER,
                CONSTRAINT campanhaofertacolaborador_pk PRIMARY KEY (idCampanhaOfertaColaborador)
);
COMMENT ON TABLE CampanhaOfertaColaborador IS 'Colaboradores ligados a campanha (Vendedor, Funcionário, etc...) ';
COMMENT ON COLUMN CampanhaOfertaColaborador.idEntidadeRegistroAgrupamento IS 'Define o agrupamento em que o colaborador pertence. Informe nulo para ele mesmo.';


ALTER SEQUENCE seq_idcampanhaofertacolaborador OWNED BY CampanhaOfertaColaborador.idCampanhaOfertaColaborador;

CREATE SEQUENCE seq_idrefmovimento;

CREATE TABLE RefMovimento (
                idRefMovimento INTEGER NOT NULL DEFAULT nextval('seq_idrefmovimento'),
                idRefTurno INTEGER,
                idRefCadastro INTEGER,
                idColaborador INTEGER,
                idempresa INTEGER,
                origem INTEGER NOT NULL,
                dataRefeicao DATE NOT NULL,
                horaRefeicao VARCHAR(10) NOT NULL,
                valores VARCHAR(12345),
                valorRefeicao NUMERIC(15,2),
                idUsuarioInclusao INTEGER NOT NULL,
                CONSTRAINT refmovimento_pk PRIMARY KEY (idRefMovimento)
);
COMMENT ON TABLE RefMovimento IS 'Tabela para registrar as refeições do refeitorio.';
COMMENT ON COLUMN RefMovimento.idRefTurno IS 'Permite nulo pois este recurso já está rodando hoje e será atualizado, sendo assim não zoa os clientes atuais.';
COMMENT ON COLUMN RefMovimento.idRefCadastro IS 'Permite nulo pois este recurso já está rodando hoje e será atualizado, sendo assim não zoa os clientes atuais.';
COMMENT ON COLUMN RefMovimento.idColaborador IS 'Quando origem 1 ou 2, informa-se o colaborador.';
COMMENT ON COLUMN RefMovimento.idempresa IS 'Quando origem 1 ou 2, informa-se a empresa de trabalho do colaborador no dia da refeição, caso ele mude de empresa, vai ter o histórico.';
COMMENT ON COLUMN RefMovimento.origem IS 'Origem da Entrada da Pessoa no Refeitorio. 1 -> Código de Barras / Cartão / Crachá (Sendo Colaborador) | 2 -> Avulso (Quando o sistema fica fora o ar, o lançamento é feito depois, porém vincula-se o colaborador) | 3 -> Terceiros (Identificação da pessoa no campo json valores)';
COMMENT ON COLUMN RefMovimento.dataRefeicao IS 'Data em que foi realizada a refeição';
COMMENT ON COLUMN RefMovimento.horaRefeicao IS 'Hora em que foi realizada a refeição.';
COMMENT ON COLUMN RefMovimento.valores IS 'Campo json, inicialmente utilizado para armazenar informações quando a origem é 3 (terceiros)';
COMMENT ON COLUMN RefMovimento.valorRefeicao IS 'Valor cobrado por refeição';
COMMENT ON COLUMN RefMovimento.idUsuarioInclusao IS 'Cód. Usuário que registrou a refeição.';


ALTER SEQUENCE seq_idrefmovimento OWNED BY RefMovimento.idRefMovimento;

CREATE SEQUENCE seq_idcolaboradorhierarquiahist;

CREATE TABLE ColaboradorHierarquiaHist (
                idColaboradorHierarquiaHist INTEGER NOT NULL DEFAULT nextval('seq_idcolaboradorhierarquiahist'),
                idColaborador INTEGER NOT NULL,
                idColaboradorLiderado INTEGER NOT NULL,
                dataInicioLiderado DATE NOT NULL,
                dataFimLiderado DATE NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(10) NOT NULL,
                CONSTRAINT colaboradorhierarquiahist_pk PRIMARY KEY (idColaboradorHierarquiaHist)
);
COMMENT ON TABLE ColaboradorHierarquiaHist IS 'Histórico sobre a tarefa colaboradorhierarquia.';
COMMENT ON COLUMN ColaboradorHierarquiaHist.idColaborador IS 'Este é o colaborador principal, o que lidera os demais (campo idColaboradorHierarquia)';
COMMENT ON COLUMN ColaboradorHierarquiaHist.idColaboradorLiderado IS 'Colaborador que é liderado pelo idColaborador ';
COMMENT ON COLUMN ColaboradorHierarquiaHist.dataInicioLiderado IS 'Data em que o liderado começou a atender ao seu "líder"';
COMMENT ON COLUMN ColaboradorHierarquiaHist.dataFimLiderado IS 'Data em que o liderado parou de atender ao seu "líder"';


ALTER SEQUENCE seq_idcolaboradorhierarquiahist OWNED BY ColaboradorHierarquiaHist.idColaboradorHierarquiaHist;

CREATE SEQUENCE seq_idcolaboradorhierarquia;

CREATE TABLE ColaboradorHierarquia (
                idColaboradorHierarquia INTEGER NOT NULL DEFAULT nextval('seq_idcolaboradorhierarquia'),
                idColaborador INTEGER NOT NULL,
                idColaboradorLiderado INTEGER NOT NULL,
                dataInicioLiderado DATE NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(10) NOT NULL,
                idUsuarioAlteracao INTEGER NOT NULL,
                dataAlteracao DATE NOT NULL,
                horaAlteracao VARCHAR(10) NOT NULL,
                CONSTRAINT colaboradorhierarquia_pk PRIMARY KEY (idColaboradorHierarquia)
);
COMMENT ON TABLE ColaboradorHierarquia IS 'Define-se a hierarquia de um colaborador, utilizado principalmente em hierarquia de liderança (1 colaborador lidera muitos colaboradores), mas também pode-se utilizar para agrupamento de colaboradores.';
COMMENT ON COLUMN ColaboradorHierarquia.idColaborador IS 'Este é o colaborador principal, o que lidera os demais (campo idColaboradorHierarquia)';
COMMENT ON COLUMN ColaboradorHierarquia.idColaboradorLiderado IS 'Colaborador que é liderado pelo idColaborador ';
COMMENT ON COLUMN ColaboradorHierarquia.dataInicioLiderado IS 'Data em que o liderado começou a atender ao seu "líder"';


ALTER SEQUENCE seq_idcolaboradorhierarquia OWNED BY ColaboradorHierarquia.idColaboradorHierarquia;

CREATE SEQUENCE seq_ideventocomercial;

CREATE TABLE EventoComercial (
                idEventoComercial INTEGER NOT NULL DEFAULT nextval('seq_ideventocomercial'),
                tipoEventoComercial CHAR(1) NOT NULL,
                idempresa INTEGER NOT NULL,
                idEntidadeRegistroTipo INTEGER NOT NULL,
                idColaboradorConsultor INTEGER,
                dataRealizacao DATE NOT NULL,
                horaRealizacao CHAR(5),
                localRealizacao VARCHAR(255),
                idMunicipio INTEGER NOT NULL,
                idEntidadeRegistroComunidade INTEGER,
                fazenda VARCHAR(255),
                idPessoaCliente VARCHAR(128),
                informacoesAdicionais VARCHAR(12345),
                objetivoEvento VARCHAR(8192),
                necessitaConvite CHAR(1),
                solicitante VARCHAR(255),
                valorInvestimento NUMERIC(12,2) NOT NULL,
                aprovacao CHAR(1),
                aprovacaoObservacao VARCHAR(4096),
                idUsuarioAprovacao INTEGER,
                situacao CHAR(1) DEFAULT 'A' NOT NULL,
                eventoComercialFinalizado CHAR(1),
                divulgacaoMarca CHAR(1),
                vigencia VARCHAR(255),
                idEntidadeRegistroMeioDivulgacao INTEGER,
                idEntidadeRegistroCentroCusto INTEGER,
                idUsuarioInclusao INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8),
                estimativa VARCHAR(1024),
                realizado VARCHAR(1024),
                dataAlteracao DATE,
                CONSTRAINT eventocomercial_pk PRIMARY KEY (idEventoComercial)
);
COMMENT ON COLUMN EventoComercial.tipoEventoComercial IS 'E-Evento, P-Patrocínio';
COMMENT ON COLUMN EventoComercial.idPessoaCliente IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN EventoComercial.informacoesAdicionais IS 'Ex 1: [ { culturaCultivada: "a", area: "1000ha" }, ... ] Ex 2: { areaTotal: "1000ha" } ';
COMMENT ON COLUMN EventoComercial.necessitaConvite IS 'N-Não, S-Sim';
COMMENT ON COLUMN EventoComercial.aprovacao IS 'A-Aprovado, R-Recusado';
COMMENT ON COLUMN EventoComercial.situacao IS 'A-Em Aberto, F-Finalizado';
COMMENT ON COLUMN EventoComercial.eventoComercialFinalizado IS 'S -> Sim N -> Não  Quando destinado ao usuário criador do Evento Comercial, ao final de tudo finalizar o evento, para então o usuário liberado poder finalizar ou acusar divergência.';
COMMENT ON COLUMN EventoComercial.divulgacaoMarca IS 'N-Não, S-Sim';
COMMENT ON COLUMN EventoComercial.estimativa IS 'Campo genérico Ex: Foi estimado 10 produtos.';
COMMENT ON COLUMN EventoComercial.realizado IS 'Campo generico Ex: Foi confirmado 7 produtos. ';
COMMENT ON COLUMN EventoComercial.dataAlteracao IS 'Data em que foi realizado a última alteração do controle do evento comercial.';


ALTER SEQUENCE seq_ideventocomercial OWNED BY EventoComercial.idEventoComercial;

CREATE SEQUENCE seq_ideventocomercialhistoricodivergencia;

CREATE TABLE EventoComercialHistoricoDivergencia (
                idEventoComercialHistoricoDivergencia INTEGER NOT NULL DEFAULT nextval('seq_ideventocomercialhistoricodivergencia'),
                idEventoComercial INTEGER NOT NULL,
                observacao VARCHAR(1024) NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(5) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                CONSTRAINT eventocomercialhistoricodivergencia_pk PRIMARY KEY (idEventoComercialHistoricoDivergencia)
);
COMMENT ON COLUMN EventoComercialHistoricoDivergencia.observacao IS 'Comentário sobre a divergência ';


ALTER SEQUENCE seq_ideventocomercialhistoricodivergencia OWNED BY EventoComercialHistoricoDivergencia.idEventoComercialHistoricoDivergencia;

CREATE SEQUENCE seq_ideventocomercialmidia;

CREATE TABLE EventoComercialMidia (
                idEventoComercialMidia INTEGER NOT NULL DEFAULT nextval('seq_ideventocomercialmidia'),
                idEventoComercial INTEGER NOT NULL,
                idEntidadeRegistroMidia INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                midia BYTEA,
                extensaoMidia VARCHAR(32),
                CONSTRAINT eventocomercialmidia_pk PRIMARY KEY (idEventoComercialMidia)
);


ALTER SEQUENCE seq_ideventocomercialmidia OWNED BY EventoComercialMidia.idEventoComercialMidia;

CREATE TABLE EventoComercialParceiro (
                idEventoComercial INTEGER NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                CONSTRAINT eventocomercialparceiro_pk PRIMARY KEY (idEventoComercial, idPessoa)
);
COMMENT ON COLUMN EventoComercialParceiro.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';


CREATE SEQUENCE seq_idpainelsenha;

CREATE TABLE PainelSenha (
                idPainelSenha INTEGER NOT NULL DEFAULT nextval('seq_idpainelsenha'),
                idEmpresa INTEGER NOT NULL,
                numeroSenha VARCHAR(255) NOT NULL,
                caixa VARCHAR(255),
                dataChamada DATE NOT NULL,
                horaChamada VARCHAR(8) NOT NULL,
                horaChamadaMilis BIGINT NOT NULL,
                situacao CHAR(1) DEFAULT 'N' NOT NULL,
                tipoSenha CHAR(1),
                idColaborador INTEGER,
                CONSTRAINT painelsenha_pk PRIMARY KEY (idPainelSenha)
);
COMMENT ON COLUMN PainelSenha.situacao IS 'N -> Normal C -> Cancelado';
COMMENT ON COLUMN PainelSenha.tipoSenha IS 'N -> Senha Normal P -> Senha Preferencial';


ALTER SEQUENCE seq_idpainelsenha OWNED BY PainelSenha.idPainelSenha;

CREATE INDEX painelsenha_idx_datachamada_idempresa
 ON PainelSenha
 ( dataChamada, idEmpresa );

CREATE SEQUENCE seq_idcolaboradorlog;

CREATE TABLE ColaboradorLog (
                idColaboradorLog INTEGER NOT NULL DEFAULT nextval('seq_idcolaboradorlog'),
                dataAlteracao DATE NOT NULL,
                horaAlteracao VARCHAR(8) NOT NULL,
                idUsuarioAlteracao INTEGER,
                idColaborador INTEGER NOT NULL,
                dataCadastro DATE,
                idFuncaoPrincipal INTEGER,
                idEmpresaTrabalho INTEGER,
                situacao CHAR(1) NOT NULL,
                CONSTRAINT colaboradorlog_pk PRIMARY KEY (idColaboradorLog)
);
COMMENT ON TABLE ColaboradorLog IS 'Armazena alterações realizadas em colaboradores.';
COMMENT ON COLUMN ColaboradorLog.dataAlteracao IS 'Data Alteração de dados do Colaborador.';
COMMENT ON COLUMN ColaboradorLog.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idcolaboradorlog OWNED BY ColaboradorLog.idColaboradorLog;

CREATE SEQUENCE seq_idindicadorgestaovisaocolaborador;

CREATE TABLE IndicadorGestaoVisaoColaborador (
                idIndicadorGestaoVisaoColaborador INTEGER NOT NULL DEFAULT nextval('seq_idindicadorgestaovisaocolaborador'),
                idIndicadorGestaoVisao INTEGER NOT NULL,
                idColaborador INTEGER NOT NULL,
                CONSTRAINT indicadorgestaovisaocolaborador_pk PRIMARY KEY (idIndicadorGestaoVisaoColaborador)
);
COMMENT ON TABLE IndicadorGestaoVisaoColaborador IS 'Colaborador com acesso a visão que será agrupado os indicadores. ';


ALTER SEQUENCE seq_idindicadorgestaovisaocolaborador OWNED BY IndicadorGestaoVisaoColaborador.idIndicadorGestaoVisaoColaborador;

CREATE TABLE ColaboradorAreaEmpresa (
                idColaborador INTEGER NOT NULL,
                idAreaEmpresa INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                CONSTRAINT colaboradorareaempresa_pk PRIMARY KEY (idColaborador, idAreaEmpresa, idempresa)
);
COMMENT ON TABLE ColaboradorAreaEmpresa IS 'Areas da Empresa que o Colaborador Atua ou Gerencia.';


CREATE SEQUENCE seq_idmidiashowtelasenhaatendimento;

CREATE TABLE MidiaShowTelaSenhaAtendimento (
                idMidiaShowTelaSenhaAtendimento INTEGER NOT NULL DEFAULT nextval('seq_idmidiashowtelasenhaatendimento'),
                idColaborador INTEGER,
                dataInicial DATE,
                horaInicial VARCHAR(8),
                idempresa INTEGER,
                tipoAtendimento CHAR(1),
                idSenha INTEGER,
                dataHoraSenha TIMESTAMP,
                dataHoraAtendimento TIMESTAMP,
                CONSTRAINT midiashowtelasenhaatendimento_pk PRIMARY KEY (idMidiaShowTelaSenhaAtendimento)
);
COMMENT ON COLUMN MidiaShowTelaSenhaAtendimento.tipoAtendimento IS 'A-Açougue, P-Padaria, R-Rotisseria';
COMMENT ON COLUMN MidiaShowTelaSenhaAtendimento.idSenha IS 'Senha Impressa pelo programa';
COMMENT ON COLUMN MidiaShowTelaSenhaAtendimento.dataHoraAtendimento IS 'Hora que a senha foi marcada como atendida na tela de Atendimento do Setor. ';


ALTER SEQUENCE seq_idmidiashowtelasenhaatendimento OWNED BY MidiaShowTelaSenhaAtendimento.idMidiaShowTelaSenhaAtendimento;

CREATE INDEX midiashowtelasenhaatendimento_idx_datainicial_idempresa
 ON MidiaShowTelaSenhaAtendimento
 ( dataInicial, idEmpresa );

CREATE INDEX midiashowtelasenhaatendimento_idx_idempresa
 ON MidiaShowTelaSenhaAtendimento
 ( idEmpresa );

CREATE INDEX midiashowtelasenhaatendimento_idx_idcolaborador_datainicial
 ON MidiaShowTelaSenhaAtendimento
 ( idColaborador, dataInicial );

CREATE INDEX midiashowtelasenhaatendimento_idx_datahorasenha_idempresa
 ON MidiaShowTelaSenhaAtendimento
 ( dataHoraSenha );

CREATE SEQUENCE seq_idmalotemovimento;

CREATE TABLE MaloteMovimento (
                idMaloteMovimento BIGINT NOT NULL DEFAULT nextval('seq_idmalotemovimento'),
                idMalote BIGINT NOT NULL,
                datamovimento DATE DEFAULT current_date NOT NULL,
                horamovimento CHAR(8) DEFAULT cast(current_time as char(8)) NOT NULL,
                tipo CHAR(1) NOT NULL,
                observacao VARCHAR(512),
                idUsuario INTEGER,
                idColaborador INTEGER,
                CONSTRAINT malotemovimento_pk PRIMARY KEY (idMaloteMovimento)
);
COMMENT ON COLUMN MaloteMovimento.tipo IS 'E - Emissão, R - Recebimento, C - Cancelamento, D - Devolução, E - Transferência Entrada';


ALTER SEQUENCE seq_idmalotemovimento OWNED BY MaloteMovimento.idMaloteMovimento;

CREATE SEQUENCE seq_idpesquisapreco;

CREATE TABLE PesquisaPreco (
                idPesquisaPreco INTEGER NOT NULL DEFAULT nextval('seq_idpesquisapreco'),
                descricao VARCHAR(255) NOT NULL,
                idColaboradorColeta INTEGER,
                dataProgramadaColeta DATE NOT NULL,
                situacao CHAR(1),
                CONSTRAINT pesquisapreco_pk PRIMARY KEY (idPesquisaPreco)
);
COMMENT ON COLUMN PesquisaPreco.idColaboradorColeta IS 'Colabordor responsável pela realização da coleta. ';
COMMENT ON COLUMN PesquisaPreco.situacao IS 'A-Ativo, I-Inativo';


ALTER SEQUENCE seq_idpesquisapreco OWNED BY PesquisaPreco.idPesquisaPreco;

CREATE SEQUENCE seq_idpesquisaprecoconcorrente;

CREATE TABLE PesquisaPrecoConcorrente (
                idPesquisaPrecoConcorrente INTEGER NOT NULL DEFAULT nextval('seq_idpesquisaprecoconcorrente'),
                idPesquisaPreco INTEGER NOT NULL,
                idConcorrente INTEGER NOT NULL,
                CONSTRAINT pesquisaprecoconcorrente_pk PRIMARY KEY (idPesquisaPrecoConcorrente)
);


ALTER SEQUENCE seq_idpesquisaprecoconcorrente OWNED BY PesquisaPrecoConcorrente.idPesquisaPrecoConcorrente;

CREATE SEQUENCE seq_idprodutoprecadastro;

CREATE TABLE ProdutoPreCadastro (
                idProdutoPreCadastro INTEGER NOT NULL DEFAULT nextval('seq_idprodutoprecadastro'),
                codigoBarrasProduto NUMERIC(14,0) NOT NULL,
                descricaoIndustria VARCHAR(255) NOT NULL,
                marca VARCHAR(256),
                codigoProdutoIndustria VARCHAR(128),
                unidadesaida CHAR(2) DEFAULT 'UN',
                qtdMultiploVenda NUMERIC(10,2),
                tipo VARCHAR(512),
                gramatura NUMERIC(15,3),
                pesoBruto NUMERIC(10,3),
                pesoLiquido NUMERIC(10,3),
                ncm VARCHAR(128),
                datacadastro DATE,
                dataalteracao DATE,
                idUsuarioInclusao INTEGER,
                idUsuarioAlteracao INTEGER NOT NULL,
                idPessoaFornecedor VARCHAR(128),
                tipoFrete CHAR(1),
                situacao CHAR(1) NOT NULL,
                dataSituacao DATE,
                percIPI NUMERIC(7,4),
                percICME NUMERIC(7,4),
                diasCondPagamento INTEGER,
                alturaUnidade NUMERIC(15,3),
                larguraUnidade NUMERIC(15,3),
                comprimentoUnidade NUMERIC(15,3),
                justificativaFormaAbastecimento VARCHAR(255),
                idSensibilidadeConcorrencia INTEGER,
                idFormaAbastecimento INTEGER,
                idColaboradorComprador INTEGER,
                idJustificativaPreCadastroProduto INTEGER,
                justificativaDescritiva VARCHAR(512) DEFAULT '' NOT NULL,
                aplicacao VARCHAR(4096),
                composicaoproduto VARCHAR(4096),
                cest VARCHAR(255),
                mva VARCHAR(255),
                cst VARCHAR(255),
                valorCustoUnitario NUMERIC(15,3),
                CONSTRAINT produtoprecadastro_pk PRIMARY KEY (idProdutoPreCadastro)
);
COMMENT ON COLUMN ProdutoPreCadastro.tipo IS 'fragrancia, sabor';
COMMENT ON COLUMN ProdutoPreCadastro.idPessoaFornecedor IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN ProdutoPreCadastro.tipoFrete IS 'F-Fob e C-Cif';
COMMENT ON COLUMN ProdutoPreCadastro.situacao IS 'A-Incluido, I-Inativado , C-Confirmado, E-Exportado   ';
COMMENT ON COLUMN ProdutoPreCadastro.alturaUnidade IS 'Em centímetros';
COMMENT ON COLUMN ProdutoPreCadastro.larguraUnidade IS 'Em centímetros';
COMMENT ON COLUMN ProdutoPreCadastro.comprimentoUnidade IS 'Em centímetros';


ALTER SEQUENCE seq_idprodutoprecadastro OWNED BY ProdutoPreCadastro.idProdutoPreCadastro;

CREATE SEQUENCE seq_idprodutoprecadastrotributo;

CREATE TABLE ProdutoPreCadastroTributo (
                idProdutoPreCadastroTributo INTEGER NOT NULL DEFAULT nextval('seq_idprodutoprecadastrotributo'),
                idProdutoPreCadastro INTEGER NOT NULL,
                tipo VARCHAR(32) NOT NULL,
                valor VARCHAR(128) NOT NULL,
                CONSTRAINT produtoprecadastrotributo_pk PRIMARY KEY (idProdutoPreCadastroTributo)
);
COMMENT ON COLUMN ProdutoPreCadastroTributo.tipo IS 'Tipo: CST, CEST, CODBARRAS';
COMMENT ON COLUMN ProdutoPreCadastroTributo.valor IS 'Valor relacionado ao tipo.';


ALTER SEQUENCE seq_idprodutoprecadastrotributo OWNED BY ProdutoPreCadastroTributo.idProdutoPreCadastroTributo;

CREATE SEQUENCE seq_idprodutoprecadastromidia;

CREATE TABLE ProdutoPreCadastroMidia (
                idProdutoPreCadastroMidia INTEGER NOT NULL DEFAULT nextval('seq_idprodutoprecadastromidia'),
                idProdutoPreCadastro INTEGER NOT NULL,
                midia BYTEA NOT NULL,
                extMidia VARCHAR(32) NOT NULL,
                descricaoMidia VARCHAR(1024),
                CONSTRAINT produtoprecadastromidia_pk PRIMARY KEY (idProdutoPreCadastroMidia)
);
COMMENT ON TABLE ProdutoPreCadastroMidia IS 'Armazena as mídias do pré cadastro ';


ALTER SEQUENCE seq_idprodutoprecadastromidia OWNED BY ProdutoPreCadastroMidia.idProdutoPreCadastroMidia;

CREATE SEQUENCE seq_idprodutoprecadastroempresa;

CREATE TABLE ProdutoPreCadastroEmpresa (
                idProdutoPreCadastroEmpresa INTEGER NOT NULL DEFAULT nextval('seq_idprodutoprecadastroempresa'),
                idProdutoPreCadastro INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                CONSTRAINT produtoprecadastroempresa_pk PRIMARY KEY (idProdutoPreCadastroEmpresa)
);


ALTER SEQUENCE seq_idprodutoprecadastroempresa OWNED BY ProdutoPreCadastroEmpresa.idProdutoPreCadastroEmpresa;

CREATE SEQUENCE seq_idprodutoprecadastrocaracteristica;

CREATE TABLE ProdutoPreCadastroCaracteristica (
                idProdutoPreCadastroCaracteristica INTEGER NOT NULL DEFAULT nextval('seq_idprodutoprecadastrocaracteristica'),
                idProdutoPreCadastro INTEGER NOT NULL,
                idCaracteristicaProduto INTEGER NOT NULL,
                CONSTRAINT produtoprecadastrocaracteristica_pk PRIMARY KEY (idProdutoPreCadastroCaracteristica)
);


ALTER SEQUENCE seq_idprodutoprecadastrocaracteristica OWNED BY ProdutoPreCadastroCaracteristica.idProdutoPreCadastroCaracteristica;

CREATE SEQUENCE seq_idprodutoprecadastrograde;

CREATE TABLE ProdutoPreCadastroGrade (
                idProdutoPreCadastroGrade INTEGER NOT NULL DEFAULT nextval('seq_idprodutoprecadastrograde'),
                idProdutoPreCadastro INTEGER NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                codigoProdutoFornecedor VARCHAR(128),
                codigoBarras NUMERIC(14,0) NOT NULL,
                idNCM VARCHAR(16),
                valorCustoAquisicao NUMERIC(15,2) NOT NULL,
                valorPrecoVenda NUMERIC(15,2),
                CONSTRAINT produtoprecadastrograde_pk PRIMARY KEY (idProdutoPreCadastroGrade)
);


ALTER SEQUENCE seq_idprodutoprecadastrograde OWNED BY ProdutoPreCadastroGrade.idProdutoPreCadastroGrade;

CREATE SEQUENCE produto_unidadeentrada_seq;

CREATE TABLE ProdutoPreCadastroEmb (
                idProdutoPreCadastro INTEGER NOT NULL,
                codigoBarrasEmbalagem NUMERIC(14,0) NOT NULL,
                unidadeEntrada CHAR(2) DEFAULT nextval('produto_unidadeentrada_seq'),
                qtdUnEntrada NUMERIC(10,3),
                altura NUMERIC(10,2),
                largura NUMERIC(10,0),
                comprimento NUMERIC(10,0),
                lastro INTEGER,
                camadas INTEGER,
                pesoBruto NUMERIC(10,30),
                pesoLiquido NUMERIC(10,3),
                CONSTRAINT produtoprecadastroemb_pk PRIMARY KEY (idProdutoPreCadastro, codigoBarrasEmbalagem)
);
COMMENT ON COLUMN ProdutoPreCadastroEmb.altura IS 'Em centímetros';
COMMENT ON COLUMN ProdutoPreCadastroEmb.largura IS 'Em centímetros';
COMMENT ON COLUMN ProdutoPreCadastroEmb.comprimento IS 'Em centímetros';


ALTER SEQUENCE produto_unidadeentrada_seq OWNED BY ProdutoPreCadastroEmb.unidadeEntrada;

CREATE TABLE ProdutoPreCadastroValor (
                idProdutoPreCadastro INTEGER NOT NULL,
                codigoBarrasEmbalagem NUMERIC(14,0) NOT NULL,
                dataInclusao DATE NOT NULL,
                valorCustocomImposto NUMERIC(15,2) NOT NULL,
                valorCustosemImposto NUMERIC(15,2) NOT NULL,
                dataValidadePreco DATE,
                idUsuarioInclusao INTEGER,
                CONSTRAINT produtoprecadastrovalor_pk PRIMARY KEY (idProdutoPreCadastro, codigoBarrasEmbalagem, dataInclusao)
);


CREATE SEQUENCE seq_idaplicacaoquestionario;

CREATE TABLE aplicacaoquestionario (
                idaplicacaoquestionario INTEGER NOT NULL DEFAULT nextval('seq_idaplicacaoquestionario'),
                idquestionarioaplicado INTEGER NOT NULL,
                idpessoarespondente VARCHAR(128),
                situacao CHAR(1) NOT NULL,
                datainicial DATE,
                horainicial VARCHAR(10),
                datafinal DATE,
                horafinal VARCHAR(10),
                datainicialdisponibilidade DATE,
                horainicialdisponibilidade VARCHAR(10),
                datafinaldisponibilidade DATE,
                horafinaldisponibilidade VARCHAR(10),
                idempresa INTEGER NOT NULL,
                idcolaboradoravaliador INTEGER,
                idcolaboradoraplicador INTEGER,
                CONSTRAINT aplicacaoquestionario_pk PRIMARY KEY (idaplicacaoquestionario)
);
COMMENT ON COLUMN aplicacaoquestionario.situacao IS 'L-Liberado, E-Em Andamento, C-Cancelado, F-Finalizado';


ALTER SEQUENCE seq_idaplicacaoquestionario OWNED BY aplicacaoquestionario.idaplicacaoquestionario;

CREATE TABLE respostaaplicacaoquestionario (
                idaplicacaoquestionario INTEGER NOT NULL,
                idquestao INTEGER NOT NULL,
                observacaoaplicador VARCHAR(2048),
                observacaorespondente VARCHAR(2048),
                observacaoavaliador VARCHAR(2048),
                avaliacao CHAR(1),
                peso INTEGER,
                data DATE NOT NULL,
                hora VARCHAR(10) NOT NULL,
                CONSTRAINT respostaaplicacaoquestionario_pk PRIMARY KEY (idaplicacaoquestionario, idquestao)
);
COMMENT ON COLUMN respostaaplicacaoquestionario.avaliacao IS 'B-Boa, M-Media, R-Ruim, C-Correta, I-Incorreta';


CREATE SEQUENCE seq_idrespostaaplicacaoquestionarioimagem;

CREATE TABLE respostaaplicacaoquestionarioimagem (
                idrespostaaplicacaoquestionarioimagem INTEGER NOT NULL DEFAULT nextval('seq_idrespostaaplicacaoquestionarioimagem'),
                extensaoimagem VARCHAR(32),
                imagem BYTEA NOT NULL,
                data DATE,
                hora VARCHAR(10),
                legendaimagem VARCHAR(2048),
                idaplicacaoquestionario INTEGER NOT NULL,
                idquestao INTEGER NOT NULL,
                CONSTRAINT respostaaplicacaoquestionarioimagem_pk PRIMARY KEY (idrespostaaplicacaoquestionarioimagem)
);


ALTER SEQUENCE seq_idrespostaaplicacaoquestionarioimagem OWNED BY respostaaplicacaoquestionarioimagem.idrespostaaplicacaoquestionarioimagem;

CREATE INDEX respostaaplicacaoquestionarioimagem_idaplicacaoquestionario_idx
 ON respostaaplicacaoquestionarioimagem USING BTREE
 ( idaplicacaoquestionario );

CREATE INDEX respostaaplicacaoquestionarioimagem_idquestao_idx
 ON respostaaplicacaoquestionarioimagem USING BTREE
 ( idquestao );

CREATE TABLE alternativaselecionada (
                idalternativa INTEGER NOT NULL,
                idaplicacaoquestionario INTEGER NOT NULL,
                idquestao INTEGER NOT NULL,
                resposta VARCHAR(2048),
                CONSTRAINT alternativaselecionada_pk PRIMARY KEY (idalternativa, idaplicacaoquestionario, idquestao)
);
COMMENT ON TABLE alternativaselecionada IS 'Alternativas da Questão. ';


CREATE TABLE questionarioquestao (
                idquestionario INTEGER NOT NULL,
                idquestao INTEGER NOT NULL,
                peso INTEGER DEFAULT 1 NOT NULL,
                ordem INTEGER,
                respostaobrigatoria CHAR(1) DEFAULT 'S'::bpchar NOT NULL,
                fotoupload CHAR(1) DEFAULT 'O'::bpchar NOT NULL,
                tempomaximopararesposta INTEGER,
                idaplicacaoquestionarioorigem INTEGER,
                situacao CHAR(1) DEFAULT 'A',
                CONSTRAINT questionarioquestao_pk PRIMARY KEY (idquestionario, idquestao)
);
COMMENT ON COLUMN questionarioquestao.respostaobrigatoria IS 'S-Sim,N-Não';
COMMENT ON COLUMN questionarioquestao.fotoupload IS 'O-Opcional, R-Requerida, N-Nao Aplicado';
COMMENT ON COLUMN questionarioquestao.tempomaximopararesposta IS 'Tempo em segundos.';
COMMENT ON COLUMN questionarioquestao.situacao IS 'A-Ativo, I-Inativo';


CREATE SEQUENCE seq_idcargaentrega;

CREATE TABLE CargaEntrega (
                idCargaEntrega INTEGER NOT NULL DEFAULT nextval('seq_idcargaentrega'),
                idempresa INTEGER NOT NULL,
                idCarga VARCHAR(128) NOT NULL,
                datamovimento DATE NOT NULL,
                observacao VARCHAR(512),
                kmInicial INTEGER,
                kmFinal INTEGER,
                idColaboradorMotorista INTEGER NOT NULL,
                idVeiculoEntrega INTEGER,
                CONSTRAINT cargaentrega_pk PRIMARY KEY (idCargaEntrega)
);
COMMENT ON TABLE CargaEntrega IS 'Armazena Montagem de cargas para entrega de mercadoligica na expedição. ';


ALTER SEQUENCE seq_idcargaentrega OWNED BY CargaEntrega.idCargaEntrega;

CREATE INDEX cargaentrega_idx_datamovimento
 ON CargaEntrega
 ( dataMovimento );

CREATE TABLE CargaEntregaCliente (
                idCargaEntrega INTEGER NOT NULL,
                idSaidaOrigem VARCHAR(255) NOT NULL,
                datamovimento DATE NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                razaosocial VARCHAR(255),
                email VARCHAR(255),
                idMunicipio INTEGER,
                endereco VARCHAR(80),
                numero INTEGER,
                complemento VARCHAR(40),
                bairro VARCHAR(255),
                cep VARCHAR(8),
                telefone VARCHAR(40),
                observacao VARCHAR(512),
                latitudeEntrega NUMERIC(12,6),
                longitudeEntrega NUMERIC(12,6),
                distanciaEntrega INTEGER,
                dataConfirmacaoEntrega DATE,
                horaConfirmacaoEntrega VARCHAR(10),
                latitudeConfirmacaoEntrega NUMERIC(12,6),
                longitudeConfirmacaoEntrega NUMERIC(12,6),
                distanciaConfirmacaoEntrega NUMERIC(12,6),
                docConfirmacaoEntrega BYTEA,
                extDocConfirmacaoEntrega VARCHAR(32),
                numeroNotaFiscal INTEGER,
                serieNotaFiscal VARCHAR(128),
                reconfirmacao CHAR(1),
                datareconfirmacao DATE,
                horaReconfirmacao VARCHAR(8),
                usuarioReconfirmacao VARCHAR(256),
                CONSTRAINT cargaentregacliente_pk PRIMARY KEY (idCargaEntrega, idSaidaOrigem)
);
COMMENT ON TABLE CargaEntregaCliente IS ' Armazena Montagem de cargas para entrega de mercadoligica na expedição por cliente.';
COMMENT ON COLUMN CargaEntregaCliente.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN CargaEntregaCliente.distanciaEntrega IS 'Distancia em Km. ';
COMMENT ON COLUMN CargaEntregaCliente.docConfirmacaoEntrega IS 'Documento que confirme a entrega.';
COMMENT ON COLUMN CargaEntregaCliente.extDocConfirmacaoEntrega IS 'Extensao do documento da confirmação de entrega.';
COMMENT ON COLUMN CargaEntregaCliente.numeroNotaFiscal IS 'Numero da Nota fiscal de Saida ou Cupom fiscal. ';
COMMENT ON COLUMN CargaEntregaCliente.reconfirmacao IS '''S'' entrega foi confirmada novamente '''' Ou ''N'' entrega não foi confirmada novamente';


CREATE INDEX cargaentregacliente_idx_dataconfirmacaoentrega
 ON CargaEntregaCliente
 ( dataConfirmacaoEntrega );

CREATE INDEX cargaentregacliente_idx_datamovimento
 ON CargaEntregaCliente
 ( dataMovimento );

CREATE TABLE ColaboradorFuncao (
                idColaborador INTEGER NOT NULL,
                idFuncao INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                idUsuarioErp VARCHAR(128),
                CONSTRAINT colaboradorfuncao_pk PRIMARY KEY (idColaborador, idFuncao, idempresa)
);
COMMENT ON TABLE ColaboradorFuncao IS 'Identifica a/as funções do colaborador';


CREATE SEQUENCE seq_idwfatividadecolaborador;

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
);
COMMENT ON TABLE WFAtividadeColaborador IS 'Liga atividade com o colaborador responsável na empresa.';
COMMENT ON COLUMN WFAtividadeColaborador.tipo IS 'E-Executor, M-Monitor';
COMMENT ON COLUMN WFAtividadeColaborador.ignoraEmpresaWFAtividadeColaborador IS 'S - Sim, N - Não';
COMMENT ON COLUMN WFAtividadeColaborador.tempoMonitoramento IS 'Em dias';


ALTER SEQUENCE seq_idwfatividadecolaborador OWNED BY WFAtividadeColaborador.idWFAtividadeColaborador;

CREATE TABLE FuncaoMercadologico (
                idMercadologico VARCHAR(128) NOT NULL,
                tipoMercadologico CHAR(1) NOT NULL,
                idColaborador INTEGER NOT NULL,
                idFuncao INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                idUsuarioAlteracao INTEGER,
                dataAlteracao DATE,
                horaAlteracao VARCHAR(5),
                CONSTRAINT funcaomercadologico_pk PRIMARY KEY (idMercadologico, tipoMercadologico, idColaborador, idFuncao, idempresa)
);
COMMENT ON TABLE FuncaoMercadologico IS 'Identifica a relação dos produtos com o Comprador. Essa relação se dá pelo mercadologico, que pode ser Depto, Setor,Grupo,Familia,Produto todos unificados ou individualmente cfe. for o melhor modelo da empresa. ';
COMMENT ON COLUMN FuncaoMercadologico.idMercadologico IS 'Dependendo da lógica da empresa, poderá o mercadologico representar Empresa + Mercadologico, ou apenas mercadologico caso o comprador for responsavel geral por todas as lojas. ';
COMMENT ON COLUMN FuncaoMercadologico.tipoMercadologico IS 'D-Departamento,S-Setor,G-Grupo,F-Familia,P-Produto, U-SubFamilia.';
COMMENT ON COLUMN FuncaoMercadologico.idUsuarioAlteracao IS 'Código do usuário que realizou a última alteração.';
COMMENT ON COLUMN FuncaoMercadologico.dataAlteracao IS 'Data da última alteração';
COMMENT ON COLUMN FuncaoMercadologico.horaAlteracao IS 'Hora da ultima atuaçlizacao do registro';


CREATE SEQUENCE meta_idmeta_seq;

CREATE TABLE Meta (
                idMeta INTEGER NOT NULL DEFAULT nextval('meta_idmeta_seq'),
                descricao VARCHAR(255) NOT NULL,
                tipoMercadologico CHAR(1) NOT NULL,
                tipoMeta VARCHAR(128) NOT NULL,
                tipoIntervalo VARCHAR(128) NOT NULL,
                idUsuarioCadastro INTEGER,
                dataCadastro DATE,
                idUsuarioAlteracao INTEGER,
                dataAlteracao DATE,
                tipoValor VARCHAR(10) DEFAULT 'V' NOT NULL,
                idMetaCalculo INTEGER,
                CONSTRAINT meta_pk PRIMARY KEY (idMeta)
);
COMMENT ON COLUMN Meta.tipoMercadologico IS 'D-Departamento, S-Seção, G-Grupo, B-Subgrupo, P-Produto, V-Vendedor';
COMMENT ON COLUMN Meta.tipoMeta IS 'VEN-Vendas, CMP-Compras ';
COMMENT ON COLUMN Meta.tipoIntervalo IS 'Nome do atributo da tabela Data.  Ex:   agrupamento diário: = a ddmmaaaa   agrupamento semanal: = a semanaano';
COMMENT ON COLUMN Meta.tipoValor IS 'V-Valor Absoluto, P-Percentual';
COMMENT ON COLUMN Meta.idMetaCalculo IS 'Identifica a Meta que será buscado subsidios para geração dos valores na meta em questão.  ';


ALTER SEQUENCE meta_idmeta_seq OWNED BY Meta.idMeta;

CREATE SEQUENCE seq_idmetaaporte;

CREATE TABLE MetaAporte (
                idMetaAporte INTEGER NOT NULL DEFAULT nextval('seq_idmetaaporte'),
                idMeta INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                chave VARCHAR(1024) NOT NULL,
                valor NUMERIC(15,2) NOT NULL,
                observacao VARCHAR(1024),
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(10) NOT NULL,
                idUsuarioInclusao INTEGER,
                CONSTRAINT metaaporte_pk PRIMARY KEY (idMetaAporte)
);


ALTER SEQUENCE seq_idmetaaporte OWNED BY MetaAporte.idMetaAporte;

CREATE TABLE MetaResultadoEcommerce (
                idempresa INTEGER NOT NULL,
                idMeta INTEGER NOT NULL,
                chave VARCHAR(128) NOT NULL,
                dataMovimento DATE NOT NULL,
                tipoMeta VARCHAR(128) NOT NULL,
                tipoEquivalencia VARCHAR(128) NOT NULL,
                dataEquivalente DATE NOT NULL,
                valorMeta NUMERIC(18,4) NOT NULL,
                valorRealizado NUMERIC(18,4),
                valorDataEquivalente NUMERIC(18,4) NOT NULL,
                percDataEquivalente NUMERIC(15,4) NOT NULL,
                apelidoTarefa VARCHAR(128),
                quantidadeRealizada NUMERIC(15,4),
                quantidadeDataEquivalente NUMERIC(15,4),
                valorProjetado NUMERIC(15,2),
                perCrescimento NUMERIC(15,4),
                valorCrescimento NUMERIC(18,4),
                valorMetaAjustada NUMERIC(18,4),
                valorMetaAjustadaEmpresa NUMERIC(18,4),
                CONSTRAINT metaresultadoecommerce_pk PRIMARY KEY (idempresa, idMeta, chave, dataMovimento, tipoMeta, tipoEquivalencia)
);
COMMENT ON TABLE MetaResultadoEcommerce IS 'Armazenará resultados da meta após processamento sobre dados que originam ou se comparam a meta.';
COMMENT ON COLUMN MetaResultadoEcommerce.chave IS 'Identificação do tipo de Meta, exemplo: Mercadologico, Vendedor,etc..';
COMMENT ON COLUMN MetaResultadoEcommerce.dataMovimento IS 'Dia do movimento, seja ele venda, compra, quebra, etc...';
COMMENT ON COLUMN MetaResultadoEcommerce.tipoMeta IS 'VEN-Vendas, CMP-Compras ';
COMMENT ON COLUMN MetaResultadoEcommerce.tipoEquivalencia IS 'MES_ATUAL_ANO_ANTERIOR MES_ANTERIOR ';
COMMENT ON COLUMN MetaResultadoEcommerce.dataEquivalente IS 'Dia equivalente cfe. a regra de busca de dias equivalentes. ';
COMMENT ON COLUMN MetaResultadoEcommerce.percDataEquivalente IS '% de participação que a meta teve no periodo equivalente. ';
COMMENT ON COLUMN MetaResultadoEcommerce.apelidoTarefa IS 'Apelido da tarefa que gerou o resultado. ';
COMMENT ON COLUMN MetaResultadoEcommerce.quantidadeRealizada IS 'Quantidade do item realizado na meta.';
COMMENT ON COLUMN MetaResultadoEcommerce.quantidadeDataEquivalente IS 'Quantidade do item na Data Equivalente';
COMMENT ON COLUMN MetaResultadoEcommerce.valorProjetado IS 'Valor projetado de vendas para os dias seguintes até fechar o mes. ';
COMMENT ON COLUMN MetaResultadoEcommerce.perCrescimento IS '% de crescimento apurado ref. o periodo atual e data equivalente. ';
COMMENT ON COLUMN MetaResultadoEcommerce.valorCrescimento IS 'Valor do crescimento periodo atual em relação ao Equivalente. ';
COMMENT ON COLUMN MetaResultadoEcommerce.valorMetaAjustada IS 'Valor ajustado da meta em casos não alcançados.  Exemplo: Faltam ainda x reais para alcançar a Meta, porem o valor previamente distribuido de Meta não irá ser o suficiente, então, o campo valorMetaAjustada recebe um ajuste considerando um valor aumentado a fim de que a meta do mes seja atingida. ';
COMMENT ON COLUMN MetaResultadoEcommerce.valorMetaAjustadaEmpresa IS 'Valor ajustado da meta em casos não alcançados.  Exemplo: Faltam ainda x reais para alcançar a Meta, porem o valor previamente distribuido de Meta não irá ser o suficiente, então, o campo valorMetaAjustada recebe um ajuste considerando um valor aumentado a fim de que a meta do mes seja atingida.   Esta meta ajustada é calculada por dia e empresa, desconsiderando a chave. O responsavel por isso é o valorMetaAjustada';


CREATE SEQUENCE seq_idmetaentidade;

CREATE TABLE MetaEntidade (
                idMetaEntidade INTEGER NOT NULL DEFAULT nextval('seq_idmetaentidade'),
                idEntidade INTEGER NOT NULL,
                idMeta INTEGER NOT NULL,
                chave VARCHAR(255) NOT NULL,
                dataInicial DATE NOT NULL,
                dataFinal DATE NOT NULL,
                valor NUMERIC(15,3) NOT NULL,
                CONSTRAINT metaentidade_pk PRIMARY KEY (idMetaEntidade)
);
COMMENT ON COLUMN MetaEntidade.chave IS 'Armazenará informações unificadas de Chaves que representaram multiplas visões. ';


ALTER SEQUENCE seq_idmetaentidade OWNED BY MetaEntidade.idMetaEntidade;

CREATE INDEX metaentidade_idx_entidade_chave
 ON MetaEntidade
 ( chave );

CREATE TABLE MetaResultado (
                idempresa INTEGER NOT NULL,
                idMeta INTEGER NOT NULL,
                chave VARCHAR(128) NOT NULL,
                dataMovimento DATE NOT NULL,
                tipoMeta VARCHAR(128) NOT NULL,
                tipoEquivalencia VARCHAR(128) NOT NULL,
                dataEquivalente DATE NOT NULL,
                valorMeta NUMERIC(18,4) NOT NULL,
                valorRealizado NUMERIC(18,4),
                valorDataEquivalente NUMERIC(18,4) NOT NULL,
                percDataEquivalente NUMERIC(15,4) NOT NULL,
                apelidoTarefa VARCHAR(128),
                quantidadeRealizada NUMERIC(15,4),
                quantidadeDataEquivalente NUMERIC(15,4),
                valorProjetado NUMERIC(15,2),
                perCrescimento NUMERIC(15,4),
                valorCrescimento NUMERIC(18,4),
                valorMetaAjustada NUMERIC(18,4),
                valorMetaAjustadaEmpresa NUMERIC(18,4),
                CONSTRAINT metaresultado_pk PRIMARY KEY (idempresa, idMeta, chave, dataMovimento, tipoMeta, tipoEquivalencia)
);
COMMENT ON TABLE MetaResultado IS 'Armazenará resultados da meta após processamento sobre dados que originam ou se comparam a meta.';
COMMENT ON COLUMN MetaResultado.chave IS 'Identificação do tipo de Meta, exemplo: Mercadologico, Vendedor,etc..';
COMMENT ON COLUMN MetaResultado.dataMovimento IS 'Dia do movimento, seja ele venda, compra, quebra, etc...';
COMMENT ON COLUMN MetaResultado.tipoMeta IS 'VEN-Vendas, CMP-Compras ';
COMMENT ON COLUMN MetaResultado.tipoEquivalencia IS 'MES_ATUAL_ANO_ANTERIOR MES_ANTERIOR ';
COMMENT ON COLUMN MetaResultado.dataEquivalente IS 'Dia equivalente cfe. a regra de busca de dias equivalentes. ';
COMMENT ON COLUMN MetaResultado.percDataEquivalente IS '% de participação que a meta teve no periodo equivalente. ';
COMMENT ON COLUMN MetaResultado.apelidoTarefa IS 'Apelido da tarefa que gerou o resultado. ';
COMMENT ON COLUMN MetaResultado.quantidadeRealizada IS 'Quantidade do item realizado na meta.';
COMMENT ON COLUMN MetaResultado.quantidadeDataEquivalente IS 'Quantidade do item na Data Equivalente';
COMMENT ON COLUMN MetaResultado.valorProjetado IS 'Valor projetado de vendas para os dias seguintes até fechar o mes. ';
COMMENT ON COLUMN MetaResultado.perCrescimento IS '% de crescimento apurado ref. o periodo atual e data equivalente. ';
COMMENT ON COLUMN MetaResultado.valorCrescimento IS 'Valor do crescimento periodo atual em relação ao Equivalente. ';
COMMENT ON COLUMN MetaResultado.valorMetaAjustada IS 'Valor ajustado da meta em casos não alcançados.  Exemplo: Faltam ainda x reais para alcançar a Meta, porem o valor previamente distribuido de Meta não irá ser o suficiente, então, o campo valorMetaAjustada recebe um ajuste considerando um valor aumentado a fim de que a meta do mes seja atingida. ';
COMMENT ON COLUMN MetaResultado.valorMetaAjustadaEmpresa IS 'Valor ajustado da meta em casos não alcançados.  Exemplo: Faltam ainda x reais para alcançar a Meta, porem o valor previamente distribuido de Meta não irá ser o suficiente, então, o campo valorMetaAjustada recebe um ajuste considerando um valor aumentado a fim de que a meta do mes seja atingida.   Esta meta ajustada é calculada por dia e empresa, desconsiderando a chave. O responsavel por isso é o valorMetaAjustada';


CREATE INDEX metaresultado_idx_chave_idmeta_idempresa
 ON MetaResultado
 ( chave, idMeta, idEmpresa );

CREATE TABLE MetaMercadologico (
                idEmpresa INTEGER NOT NULL,
                idMeta INTEGER NOT NULL,
                idMercadologico VARCHAR(255) NOT NULL,
                dataInicial DATE NOT NULL,
                dataFinal DATE NOT NULL,
                valor NUMERIC(15,3),
                dataCadastro DATE,
                idUsuarioCadastro INTEGER,
                valorAnterior NUMERIC(15,3) DEFAULT 0,
                percParticipacaoAnterior NUMERIC(7,4) DEFAULT 0,
                CONSTRAINT metamercadologico_pk PRIMARY KEY (idEmpresa, idMeta, idMercadologico, dataInicial, dataFinal)
);
COMMENT ON COLUMN MetaMercadologico.percParticipacaoAnterior IS '% de participação ';


CREATE INDEX metamercadologico_idx_datainicial_idmeta_idempresa
 ON MetaMercadologico
 ( idMeta, idEmpresa );

CREATE SEQUENCE inventarioestoque_idinventario_seq;

CREATE TABLE InventarioEstoque (
                idInventario INTEGER NOT NULL DEFAULT nextval('inventarioestoque_idinventario_seq'),
                descricao VARCHAR(255),
                idLocalEstoque INTEGER NOT NULL,
                dataInventario DATE NOT NULL,
                idempresa INTEGER NOT NULL,
                idUsuarioCadastro INTEGER,
                dataCadastro DATE NOT NULL,
                idUsuarioAlteracao INTEGER,
                dataAlteracao DATE,
                idInventarioAnterior INTEGER,
                dataEncerramento DATE,
                CONSTRAINT inventarioestoque_pk PRIMARY KEY (idInventario)
);
COMMENT ON TABLE InventarioEstoque IS 'Carrega Balanco/Inventário Estoque do Erp. ';
COMMENT ON COLUMN InventarioEstoque.idInventarioAnterior IS 'Informar o inventário anterior para definir o período da movimentação entre os inventários.';


ALTER SEQUENCE inventarioestoque_idinventario_seq OWNED BY InventarioEstoque.idInventario;

CREATE TABLE PessoaFornecedor (
                idPessoa VARCHAR(128) NOT NULL,
                numDiasEntrega INTEGER,
                qtdePromotorCompartilhado INTEGER,
                qtdePromotorExclusivo INTEGER,
                realizaTrocas CHAR(1),
                parceiro CHAR(1),
                logo BYTEA,
                extLogo VARCHAR(32),
                permiteDescarteProduto CHAR(1) DEFAULT 'N' NOT NULL,
                CONSTRAINT pessoafornecedor_pk PRIMARY KEY (idPessoa)
);
COMMENT ON COLUMN PessoaFornecedor.numDiasEntrega IS 'Número de Dias que normalmente o Fornecedor demora para entrega do produto uma vez comprado.   Também chamado de "LeadTime"';
COMMENT ON COLUMN PessoaFornecedor.realizaTrocas IS '[S]im, [N]ão.';
COMMENT ON COLUMN PessoaFornecedor.parceiro IS 'S -> Sim N -> Não';


CREATE SEQUENCE seq_idb2bpessoafornecedor;

CREATE TABLE B2BPessoaFornecedor (
                idB2BPessoaFornecedor INTEGER NOT NULL DEFAULT nextval('seq_idb2bpessoafornecedor'),
                idPessoa VARCHAR(128) NOT NULL,
                idempresa INTEGER NOT NULL,
                situacaoAbastecimento CHAR(1) NOT NULL,
                CONSTRAINT b2bpessoafornecedor_pk PRIMARY KEY (idB2BPessoaFornecedor)
);
COMMENT ON COLUMN B2BPessoaFornecedor.situacaoAbastecimento IS 'A-Ativo I-Inativo';


ALTER SEQUENCE seq_idb2bpessoafornecedor OWNED BY B2BPessoaFornecedor.idB2BPessoaFornecedor;

CREATE INDEX b2bpessoafornecedor_idx_idpessoa
 ON B2BPessoaFornecedor
 ( idPessoa );

CREATE TABLE FornecedorMarca (
                idfornecedor VARCHAR(128) NOT NULL,
                idmarca INTEGER NOT NULL,
                CONSTRAINT fornecedormarca_pk PRIMARY KEY (idfornecedor, idmarca)
);


CREATE TABLE PlanoContas (
                idempresa INTEGER NOT NULL,
                idConta BIGINT NOT NULL,
                tipoPlanoContas CHAR(1) NOT NULL,
                descricao VARCHAR(255) NOT NULL,
                tipoConta CHAR(1) DEFAULT 'A' NOT NULL,
                classificacao VARCHAR(32),
                tipoRateio CHAR(1),
                situacao CHAR(1),
                classificacaoNivelAnterior VARCHAR(255),
                idFluxoGrupo INTEGER,
                tipoNaturezaConta VARCHAR(16),
                observacao VARCHAR(1024),
                CONSTRAINT planocontas_pk PRIMARY KEY (idempresa, idConta, tipoPlanoContas)
);
COMMENT ON COLUMN PlanoContas.tipoPlanoContas IS 'C-Contabil F-Financeiro G-Gerencial M-Marketing   R-Resultado  T-Monitorado ';
COMMENT ON COLUMN PlanoContas.tipoConta IS 'A-Analitica S-Sintetica';
COMMENT ON COLUMN PlanoContas.tipoRateio IS 'F-Conta Fixa, que mesmo variando a receita, a conta permanece com valor igual.   V-Conta Variavel, que varia cfe. a receita. ';
COMMENT ON COLUMN PlanoContas.situacao IS 'A-Ativo I-Inativo O-Oculto';
COMMENT ON COLUMN PlanoContas.tipoNaturezaConta IS 'Natureza D-Devedora ou C-Credora';
COMMENT ON COLUMN PlanoContas.observacao IS 'Campo destinado para observações ref. a conta, algo ligado a quais operações ou lançamentos deverão ser registrados na conta, assim direcionando os gestores e/ou operadores a saber oque deveria ser lançado. ';


CREATE INDEX planocontas_idx_classificacao
 ON PlanoContas
 ( classificacao );

CREATE SEQUENCE seq_idcolaboradorfuncaocentroresultado;

CREATE TABLE ColaboradorFuncaoCentroResultado (
                idColaboradorFuncaoCentroResultado INTEGER NOT NULL DEFAULT nextval('seq_idcolaboradorfuncaocentroresultado'),
                tipoLigacao CHAR(1) NOT NULL,
                idLigacao INTEGER NOT NULL,
                idEmpresaPlanoContas INTEGER NOT NULL,
                idConta BIGINT NOT NULL,
                tipoPlanoContas CHAR(1) NOT NULL,
                CONSTRAINT colaboradorfuncaocentroresultado_pk PRIMARY KEY (idColaboradorFuncaoCentroResultado)
);
COMMENT ON TABLE ColaboradorFuncaoCentroResultado IS 'Tabela para armazenar a ligação do Colaborador ou Função aos Centros de Custos ou também conhecidos como Centros de Resultados.';
COMMENT ON COLUMN ColaboradorFuncaoCentroResultado.tipoLigacao IS 'F-Função, C-Colaborador';
COMMENT ON COLUMN ColaboradorFuncaoCentroResultado.idLigacao IS 'Código da Função ou Código do Colaborador.';
COMMENT ON COLUMN ColaboradorFuncaoCentroResultado.tipoPlanoContas IS 'C-Contabil F-Financeiro G-Gerencial ';


ALTER SEQUENCE seq_idcolaboradorfuncaocentroresultado OWNED BY ColaboradorFuncaoCentroResultado.idColaboradorFuncaoCentroResultado;

CREATE SEQUENCE seq_idsolicitacaosuprimento;

CREATE TABLE SolicitacaoSuprimento (
                idSolicitacaoSuprimento INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimento'),
                idEmpresa INTEGER NOT NULL,
                dataSolicitacao DATE NOT NULL,
                horaSolicitacao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                idEmpresaPlanoContas INTEGER NOT NULL,
                idConta BIGINT NOT NULL,
                tipoPlanoContas CHAR(1) NOT NULL,
                idEmpresaPlanoContasGerencial INTEGER,
                idContaGerencial BIGINT,
                tipoPlanoContasGerencial CHAR(1),
                idSolicitacaoSuprimentoCategoria INTEGER NOT NULL,
                idSolicitacaoSuprimentoEtapa INTEGER NOT NULL,
                situacao CHAR(1) NOT NULL,
                formulario VARCHAR(12345),
                idSolicitacaoSuprimentoSubCategoria INTEGER,
                CONSTRAINT solicitacaosuprimento_pk PRIMARY KEY (idSolicitacaoSuprimento)
);
COMMENT ON TABLE SolicitacaoSuprimento IS 'Tabela destinada ao armazenamento dos dados de solicitações de provisões que podem ser: Suprimentos, autorizações de despesas, edificações etc.... ';
COMMENT ON COLUMN SolicitacaoSuprimento.tipoPlanoContas IS 'C-Contabil F-Financeiro G-Gerencial ';
COMMENT ON COLUMN SolicitacaoSuprimento.tipoPlanoContasGerencial IS 'C-Contabil F-Financeiro G-Gerencial M-Marketing   R-Resultado  T-Monitorado ';


ALTER SEQUENCE seq_idsolicitacaosuprimento OWNED BY SolicitacaoSuprimento.idSolicitacaoSuprimento;

CREATE SEQUENCE seq_idsolicitacaosuprimentologs;

CREATE TABLE SolicitacaoSuprimentoLogs (
                idSolicitacaoSuprimentoLogs INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimentologs'),
                idSolicitacaoSuprimento INTEGER NOT NULL,
                idSolicitacaoSuprimentoEtapa INTEGER NOT NULL,
                dataAlteracao DATE NOT NULL,
                horaAlteracao VARCHAR(8) NOT NULL,
                idUsuarioAlteracao INTEGER NOT NULL,
                observacao VARCHAR(8192),
                CONSTRAINT solicitacaosuprimentologs_pk PRIMARY KEY (idSolicitacaoSuprimentoLogs)
);
COMMENT ON TABLE SolicitacaoSuprimentoLogs IS 'Armazena todas as movimentações das Solicitações de Provisões. ';


ALTER SEQUENCE seq_idsolicitacaosuprimentologs OWNED BY SolicitacaoSuprimentoLogs.idSolicitacaoSuprimentoLogs;

CREATE SEQUENCE seq_idsolicitacaosuprimentoitens;

CREATE TABLE SolicitacaoSuprimentoItens (
                idSolicitacaoSuprimentoItens INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimentoitens'),
                idSolicitacaoSuprimento INTEGER NOT NULL,
                idSolicitacaoSuprimentoItemSolicitacao INTEGER NOT NULL,
                quantidade NUMERIC(15,2) NOT NULL,
                descricao VARCHAR(8192),
                idSolicitacaoSuprimentoMotivo INTEGER,
                motivoComplemento VARCHAR(8192),
                idCotacaoEscolhaGestor INTEGER,
                motivoEscolhaGestor VARCHAR(8192),
                situacaoerp CHAR(1) DEFAULT 'P',
                datalimite DATE,
                serienotafiscal VARCHAR(255),
                numeronotafiscal INTEGER,
                CONSTRAINT solicitacaosuprimentoitens_pk PRIMARY KEY (idSolicitacaoSuprimentoItens)
);
COMMENT ON COLUMN SolicitacaoSuprimentoItens.descricao IS 'Usuário poderá informar detalhes da solicitação. ';
COMMENT ON COLUMN SolicitacaoSuprimentoItens.idSolicitacaoSuprimentoMotivo IS 'Aceita nulo pois o cliente poderá optar em apenas descrever o motivo. ';
COMMENT ON COLUMN SolicitacaoSuprimentoItens.idCotacaoEscolhaGestor IS 'Aponta para a cotação do item com sugestão de escolha realizada pelo Gestor. ';
COMMENT ON COLUMN SolicitacaoSuprimentoItens.motivoEscolhaGestor IS 'Descrição realizada pelo gestor a fim de apontar as razões pelas quais escolher tal cotação. ';


ALTER SEQUENCE seq_idsolicitacaosuprimentoitens OWNED BY SolicitacaoSuprimentoItens.idSolicitacaoSuprimentoItens;

CREATE SEQUENCE seq_idsolicitacaosuprimentoitenscotacao;

CREATE TABLE SolicitacaoSuprimentoItensCotacao (
                idSolicitacaoSuprimentoItensCotacao INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimentoitenscotacao'),
                idSolicitacaoSuprimentoItens INTEGER NOT NULL,
                idPessoaFornecedor VARCHAR(128),
                valorUnitario NUMERIC(15,2) NOT NULL,
                quantidade NUMERIC(15,2),
                observacao VARCHAR(8192),
                valorFrete NUMERIC(15,2),
                fornecedor VARCHAR(512),
                CONSTRAINT solicitacaosuprimentoitenscotacao_pk PRIMARY KEY (idSolicitacaoSuprimentoItensCotacao)
);
COMMENT ON TABLE SolicitacaoSuprimentoItensCotacao IS 'Armazena dados cotados com fornecedores ref. a solicitação. ';
COMMENT ON COLUMN SolicitacaoSuprimentoItensCotacao.idPessoaFornecedor IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';


ALTER SEQUENCE seq_idsolicitacaosuprimentoitenscotacao OWNED BY SolicitacaoSuprimentoItensCotacao.idSolicitacaoSuprimentoItensCotacao;

CREATE SEQUENCE seq_idsolicitacaosuprimentoitenscotacaomidia;

CREATE TABLE SolicitacaoSuprimentoItensCotacaoMidia (
                idSolicitacaoSuprimentoItensCotacaoMidia INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimentoitenscotacaomidia'),
                idSolicitacaoSuprimentoItensCotacao INTEGER NOT NULL,
                midia BYTEA NOT NULL,
                extMidia VARCHAR(32) NOT NULL,
                descricaoMidia VARCHAR(1024),
                CONSTRAINT solicitacaosuprimentoitenscotacaomidia_pk PRIMARY KEY (idSolicitacaoSuprimentoItensCotacaoMidia)
);
COMMENT ON TABLE SolicitacaoSuprimentoItensCotacaoMidia IS 'Armazena as midias da cotação recebidas do fornecedor.';


ALTER SEQUENCE seq_idsolicitacaosuprimentoitenscotacaomidia OWNED BY SolicitacaoSuprimentoItensCotacaoMidia.idSolicitacaoSuprimentoItensCotacaoMidia;

CREATE SEQUENCE seq_idsolicitacaosuprimentomidia;

CREATE TABLE SolicitacaoSuprimentoMidia (
                idSolicitacaoSuprimentoMidia INTEGER NOT NULL DEFAULT nextval('seq_idsolicitacaosuprimentomidia'),
                idSolicitacaoSuprimentoItens INTEGER NOT NULL,
                midia BYTEA NOT NULL,
                extMidia VARCHAR(32) NOT NULL,
                descricaoMidia VARCHAR(1024),
                CONSTRAINT solicitacaosuprimentomidia_pk PRIMARY KEY (idSolicitacaoSuprimentoMidia)
);


ALTER SEQUENCE seq_idsolicitacaosuprimentomidia OWNED BY SolicitacaoSuprimentoMidia.idSolicitacaoSuprimentoMidia;

CREATE TABLE DemonstrativoConfigPlanoContas (
                idDemonstrativoConfig INTEGER NOT NULL,
                idConta BIGINT NOT NULL,
                tipoPlanoContas CHAR(1) NOT NULL,
                idEmpresaPlanoContas INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                layout CHAR(1),
                inverterSinal CHAR(1) DEFAULT 'N',
                CONSTRAINT demonstrativoconfigplanocontas_pk PRIMARY KEY (idDemonstrativoConfig, idConta, tipoPlanoContas, idEmpresaPlanoContas, idempresa)
);
COMMENT ON TABLE DemonstrativoConfigPlanoContas IS 'Plano contas que somados irão gerar o valor para o agrupamento. ';
COMMENT ON COLUMN DemonstrativoConfigPlanoContas.tipoPlanoContas IS 'C-Contabil F-Financeiro G-Gerencial ';
COMMENT ON COLUMN DemonstrativoConfigPlanoContas.layout IS 'V-Visivel , I-Invisível ';


CREATE SEQUENCE seq_iddemonstrativoresumo;

CREATE TABLE DemonstrativoResumo (
                idDemonstrativoResumo INTEGER NOT NULL DEFAULT nextval('seq_iddemonstrativoresumo'),
                idEmpresaPlanoContas INTEGER NOT NULL,
                idDemonstrativoConfig INTEGER NOT NULL,
                ano VARCHAR(4) NOT NULL,
                mes VARCHAR(2) NOT NULL,
                dataInicial DATE NOT NULL,
                dataFinal DATE NOT NULL,
                valor NUMERIC(15,4) NOT NULL,
                valorOrcado NUMERIC(15,2),
                idConta BIGINT,
                tipoPlanoContas CHAR(1),
                idempresa INTEGER NOT NULL,
                CONSTRAINT demonstrativoresumo_pk PRIMARY KEY (idDemonstrativoResumo)
);
COMMENT ON TABLE DemonstrativoResumo IS 'Contas processadas mensalmente. ';
COMMENT ON COLUMN DemonstrativoResumo.tipoPlanoContas IS 'C-Contabil F-Financeiro G-Gerencial ';


ALTER SEQUENCE seq_iddemonstrativoresumo OWNED BY DemonstrativoResumo.idDemonstrativoResumo;

CREATE INDEX demonstrativoresumo_idx_datainicial_idempresa
 ON DemonstrativoResumo
 ( dataInicial, idEmpresaPlanoContas );

CREATE INDEX demonstrativoresumo_idx_ano_mes_idempresa
 ON DemonstrativoResumo
 ( ano, mes );

CREATE SEQUENCE seq_idmovimento;

CREATE TABLE ContabilMovimento (
                idMovimento INTEGER NOT NULL DEFAULT nextval('seq_idmovimento'),
                dataMovimento DATE NOT NULL,
                idContaErp NUMERIC(15,0) NOT NULL,
                tipoNaturezaLcto CHAR(1) NOT NULL,
                sequencia INTEGER NOT NULL,
                valorLancamento NUMERIC(12,2) NOT NULL,
                complemento VARCHAR(512),
                idEmpresaPlanoContas INTEGER NOT NULL,
                idConta BIGINT NOT NULL,
                tipoPlanoContas CHAR(1) NOT NULL,
                idempresa INTEGER NOT NULL,
                idPlanilha INTEGER,
                codigoCentroResultado INTEGER,
                CONSTRAINT contabilmovimento_pk PRIMARY KEY (idMovimento)
);
COMMENT ON COLUMN ContabilMovimento.tipoNaturezaLcto IS 'D-Debito C-Credito';
COMMENT ON COLUMN ContabilMovimento.tipoPlanoContas IS 'C-Contabil F-Financeiro G-Gerencial ';


ALTER SEQUENCE seq_idmovimento OWNED BY ContabilMovimento.idMovimento;

CREATE INDEX contabilmovimento_idx_datamovimento
 ON ContabilMovimento
 ( dataMovimento );

CREATE INDEX contabilmovimento_idx_idplanilha
 ON ContabilMovimento
 ( idPlanilha );

CREATE INDEX contabilmovimento_idx_datamovimento_idempresa_idconta
 ON ContabilMovimento
 ( dataMovimento, idEmpresa, idConta );

CREATE SEQUENCE seq_idorcamentomovimentoresumo;

CREATE TABLE OrcamentoMovimentoResumo (
                idOrcamentoMovimentoResumo INTEGER NOT NULL DEFAULT nextval('seq_idorcamentomovimentoresumo'),
                idempresa INTEGER NOT NULL,
                idEmpresaPlanoContas INTEGER NOT NULL,
                idConta BIGINT NOT NULL,
                tipoPlanoContas CHAR(1) NOT NULL,
                tipoMovimento CHAR(10) NOT NULL,
                dataMovimento DATE NOT NULL,
                valor NUMERIC(15,2) NOT NULL,
                quantidadeIndice NUMERIC(15,3),
                complemento VARCHAR(512),
                idIndice INTEGER NOT NULL,
                CONSTRAINT orcamentomovimentoresumo_pk PRIMARY KEY (idOrcamentoMovimentoResumo)
);
COMMENT ON TABLE OrcamentoMovimentoResumo IS 'Visão orcamentária por regime de Competencia. ';
COMMENT ON COLUMN OrcamentoMovimentoResumo.tipoPlanoContas IS 'C-Contabil F-Financeiro G-Gerencial ';
COMMENT ON COLUMN OrcamentoMovimentoResumo.tipoMovimento IS 'O-Orcamento, P-Previsto, R-Realizado';
COMMENT ON COLUMN OrcamentoMovimentoResumo.quantidadeIndice IS 'Quantidade do Indice. Exemplo indice dolar:  Embora o campo valor vai estar convertido em reais, o campo quantidadeIndice estará originalmente na quantidade da moeda. ';
COMMENT ON COLUMN OrcamentoMovimentoResumo.complemento IS 'Campo destinado para informações adicionais tal como fornecedor por exemplo ou numero do titulo.';


ALTER SEQUENCE seq_idorcamentomovimentoresumo OWNED BY OrcamentoMovimentoResumo.idOrcamentoMovimentoResumo;

CREATE INDEX orcamentomovimentoresumo_idx_datamovimento
 ON OrcamentoMovimentoResumo
 ( dataMovimento );

CREATE INDEX orcamentomovimentoresumo_idx_idempresa_datamovimento
 ON OrcamentoMovimentoResumo
 ( idEmpresa, dataMovimento );

CREATE TABLE ContasMovimentoFinanceiro (
                idContasMovimentoFinanceiro INTEGER NOT NULL,
                idContasReceber INTEGER,
                idContasPagar INTEGER,
                idempresa INTEGER NOT NULL,
                idConta BIGINT NOT NULL,
                tipoPlanoContas CHAR(1) NOT NULL,
                valor NUMERIC(15,2) NOT NULL,
                dataMovimento DATE NOT NULL,
                CONSTRAINT contasmovimentofinanceiro_pk PRIMARY KEY (idContasMovimentoFinanceiro)
);
COMMENT ON TABLE ContasMovimentoFinanceiro IS ' Movimentação financeira de Contas a Receber e Contas a Pagar distribuidas em Plano de Contas.';
COMMENT ON COLUMN ContasMovimentoFinanceiro.tipoPlanoContas IS 'C-Contabil F-Financeiro G-Gerencial ';


CREATE INDEX contasmovimentofinanceiro_idx_datamovimento
 ON ContasMovimentoFinanceiro
 ( dataMovimento );

CREATE INDEX contasmovimentofinanceiro_idx_empresa_conta
 ON ContasMovimentoFinanceiro
 ( idEmpresa, idConta, tipoPlanoContas );

CREATE INDEX contasmovimentofinanceiro_idx_idcontsareceber
 ON ContasMovimentoFinanceiro
 ( idContasReceber );

CREATE INDEX contasmovimentofinanceiro_idx_idcontaspagar
 ON ContasMovimentoFinanceiro
 ( idContasPagar );

CREATE SEQUENCE seq_fluxocaixamovimentoresumo_idfluxocaixamovimentoresumo;

CREATE TABLE FluxoCaixaMovimentoResumo (
                idFluxoCaixaMovimentoResumo INTEGER NOT NULL DEFAULT nextval('seq_fluxocaixamovimentoresumo_idfluxocaixamovimentoresumo'),
                idempresa INTEGER NOT NULL,
                idEmpresaPlanoContas INTEGER NOT NULL,
                idConta BIGINT NOT NULL,
                tipoPlanoContas CHAR(1) NOT NULL,
                tipoMovimento CHAR(10) NOT NULL,
                dataMovimento DATE NOT NULL,
                idIndice INTEGER,
                valor NUMERIC(15,2) NOT NULL,
                quantidadeIndice NUMERIC(15,3),
                complemento VARCHAR(512),
                CONSTRAINT fluxocaixamovimentoresumo_pk PRIMARY KEY (idFluxoCaixaMovimentoResumo)
);
COMMENT ON COLUMN FluxoCaixaMovimentoResumo.tipoPlanoContas IS 'C-Contabil F-Financeiro G-Gerencial ';
COMMENT ON COLUMN FluxoCaixaMovimentoResumo.tipoMovimento IS 'O-Orcamento, P-Previsto, R-Realizado';
COMMENT ON COLUMN FluxoCaixaMovimentoResumo.quantidadeIndice IS 'Quantidade do Indice. Exemplo indice dolar:  Embora o campo valor vai estar convertido em reais, o campo quantidadeIndice estará originalmente na quantidade da moeda. ';
COMMENT ON COLUMN FluxoCaixaMovimentoResumo.complemento IS 'Campo destinado para informações adicionais tal como fornecedor por exemplo ou numero do titulo.';


ALTER SEQUENCE seq_fluxocaixamovimentoresumo_idfluxocaixamovimentoresumo OWNED BY FluxoCaixaMovimentoResumo.idFluxoCaixaMovimentoResumo;

CREATE TABLE FluxoCaixaPrevisao (
                idempresa INTEGER NOT NULL,
                idConta BIGINT NOT NULL,
                tipoPlanoContas CHAR(1) NOT NULL,
                dataVencimento DATE NOT NULL,
                idEmpresaMovimento INTEGER NOT NULL,
                valor NUMERIC(15,2) NOT NULL,
                dataInclusao DATE NOT NULL,
                idUsuarioInclusao INTEGER,
                idIndice INTEGER,
                valorMoeda2 NUMERIC(15,2),
                idIndice2 INTEGER,
                CONSTRAINT fluxocaixaprevisao_pk PRIMARY KEY (idempresa, idConta, tipoPlanoContas, dataVencimento, idEmpresaMovimento)
);
COMMENT ON COLUMN FluxoCaixaPrevisao.tipoPlanoContas IS 'C-Contabil F-Financeiro G-Gerencial ';
COMMENT ON COLUMN FluxoCaixaPrevisao.idEmpresaMovimento IS 'Id da empresa do qual o movimento pertence.';
COMMENT ON COLUMN FluxoCaixaPrevisao.valorMoeda2 IS 'Valor destinado para registro de valor ref. a segunda moeda. ';


CREATE INDEX fluxocaixaprevisao_idx_empresamovimento_data
 ON FluxoCaixaPrevisao
 ( idEmpresaMovimento, dataVencimento );

CREATE INDEX fluxocaixaprevisao_idx_datavencimento
 ON FluxoCaixaPrevisao
 ( dataVencimento );

CREATE TABLE PlanoContasSaldo (
                idEmpresaPlanoContas INTEGER NOT NULL,
                idConta BIGINT NOT NULL,
                tipoPlanoContas CHAR(1) NOT NULL,
                dataMovimento DATE NOT NULL,
                idempresa INTEGER NOT NULL,
                valorSaldo NUMERIC(15,2) NOT NULL,
                dataAtualizacao DATE NOT NULL,
                horaAtualizacao VARCHAR(10) NOT NULL,
                CONSTRAINT planocontassaldo_pk PRIMARY KEY (idEmpresaPlanoContas, idConta, tipoPlanoContas, dataMovimento, idempresa)
);
COMMENT ON COLUMN PlanoContasSaldo.tipoPlanoContas IS 'C-Contabil F-Financeiro G-Gerencial ';


CREATE INDEX planocontassaldo_idx_datamovimento_idempresa
 ON PlanoContasSaldo
 ( dataMovimento, idEmpresa );

CREATE TABLE PlanoContasDePara (
                idempresa INTEGER NOT NULL,
                idConta BIGINT NOT NULL,
                tipoPlanoContas CHAR(1) NOT NULL,
                idempresaPara INTEGER NOT NULL,
                idContaPara BIGINT NOT NULL,
                tipoPlanoContasPara CHAR(1) NOT NULL,
                CONSTRAINT planocontasdepara_pk PRIMARY KEY (idempresa, idConta, tipoPlanoContas)
);
COMMENT ON COLUMN PlanoContasDePara.tipoPlanoContas IS 'C-Contabil F-Financeiro G-Gerencial ';
COMMENT ON COLUMN PlanoContasDePara.tipoPlanoContasPara IS 'C-Contabil F-Financeiro G-Gerencial ';


CREATE TABLE VendaMeta (
                idempresa INTEGER NOT NULL,
                data DATE NOT NULL,
                tipo CHAR(1) NOT NULL,
                codigoMercadologico INTEGER NOT NULL,
                valor NUMERIC(12,2),
                perLucro NUMERIC(10,4),
                perCrescimento NUMERIC(10,4),
                perCmv NUMERIC(10,4),
                CONSTRAINT vendameta_pk PRIMARY KEY (idempresa, data, tipo, codigoMercadologico)
);
COMMENT ON COLUMN VendaMeta.tipo IS 'D-Departamento S-Setor G-Grupo F-Familia L-SubFamilia';
COMMENT ON COLUMN VendaMeta.codigoMercadologico IS 'Código do mercadologico escolhido:Ex. Se o Tipo for = ''D'', será o código do departamento.';
COMMENT ON COLUMN VendaMeta.valor IS 'valor da meta';


CREATE TABLE MetaPlanoContasValor (
                idConta BIGINT NOT NULL,
                dataMeta DATE NOT NULL,
                tipoPlanoContas CHAR(1) NOT NULL,
                idempresa INTEGER NOT NULL,
                valor NUMERIC(12,2) NOT NULL,
                CONSTRAINT metaplanocontasvalor_pk PRIMARY KEY (idConta, dataMeta, tipoPlanoContas, idempresa)
);
COMMENT ON COLUMN MetaPlanoContasValor.tipoPlanoContas IS 'C-Contabil F-Financeiro G-Gerencial ';


CREATE TABLE EmpresaEstrutura (
                idempresa INTEGER NOT NULL,
                data DATE NOT NULL,
                idAreaEmpresa INTEGER NOT NULL,
                areaTotalM2 NUMERIC(10,2),
                areaVendasM2 NUMERIC(10,2),
                numCheckouts INTEGER,
                numFuncionarios INTEGER,
                CONSTRAINT empresaestrutura_pk PRIMARY KEY (idempresa, data, idAreaEmpresa)
);


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
);
COMMENT ON COLUMN Produto.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN Produto.tipomarca IS 'P-Própria N-Não Própria';
COMMENT ON COLUMN Produto.pesavel IS 'S-Sim, N-Não';
COMMENT ON COLUMN Produto.idPessoaFabricante IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN Produto.aceitaQtdeFracionada IS 'S-Sim, N-Nao';
COMMENT ON COLUMN Produto.descricaoEspecial IS 'Campo destinado a utilização em aplicativos ou relatórios especiais, tal como exemplo: Tabela de Açougue, onde a descrição apresentada não se enquadra em nenhum dos outros campos de Descrição. ';
COMMENT ON COLUMN Produto.codigoErp IS 'Código do Produto dentro do Erp do Cliente. ';
COMMENT ON COLUMN Produto.tipoBaixaEstoque IS 'Identificação do tipo de movimento de estoque que o produto terá N-Normal, K-Kit, C-Cesta';
COMMENT ON COLUMN Produto.situacaoCompra IS 'A-Ativo,  I-Inativo.  (geral para todas as empresas). ';


CREATE INDEX produto_idx_codigobarras
 ON Produto
 ( codigoBarras );

CREATE INDEX produto_idx_departamento
 ON Produto
 ( idDepartamento );

CREATE INDEX produto_idx_setor
 ON Produto
 ( idSetor );

CREATE INDEX produto_idx_grupo
 ON Produto
 ( idGrupo );

CREATE INDEX produto_idx_familia
 ON Produto
 ( idFamilia );

CREATE INDEX produto_idx_subfamilia
 ON Produto
 ( idSubFamilia );

CREATE INDEX produto_idx_codigoerp
 ON Produto
 ( codigoErp );

CREATE INDEX produto_idx_idprodutobaixaestoque
 ON Produto
 ( idProdutoBaixaEstoque );

CREATE SEQUENCE seq_idproducao;

CREATE TABLE Producao (
                idProducao INTEGER NOT NULL DEFAULT nextval('seq_idproducao'),
                idProdutoPai BIGINT NOT NULL,
                idProdutoFilho BIGINT NOT NULL,
                quantidade NUMERIC(15,4) NOT NULL,
                tipoProducao CHAR(1) NOT NULL,
                CONSTRAINT producao_pk PRIMARY KEY (idProducao)
);
COMMENT ON COLUMN Producao.tipoProducao IS 'P-Produção de Um produto Especificamente E-Baixa de Estoque em Produto Pai  ';


ALTER SEQUENCE seq_idproducao OWNED BY Producao.idProducao;

CREATE INDEX producao_idx_idprodutopai_idprodutofilho
 ON Producao
 ( idProdutoPai, idProdutoFilho );

CREATE INDEX producao_idx_idprodutofilho_idprodutopai
 ON Producao
 ( idProdutoFilho, idProdutoPai );

CREATE SEQUENCE seq_idprodutoprecadastrosimilar;

CREATE TABLE ProdutoPreCadastroSimilar (
                idProdutoPreCadastroSimilar INTEGER NOT NULL DEFAULT nextval('seq_idprodutoprecadastrosimilar'),
                idProdutoPreCadastro INTEGER NOT NULL,
                idprodutoSimilar BIGINT NOT NULL,
                CONSTRAINT produtoprecadastrosimilar_pk PRIMARY KEY (idProdutoPreCadastroSimilar)
);


ALTER SEQUENCE seq_idprodutoprecadastrosimilar OWNED BY ProdutoPreCadastroSimilar.idProdutoPreCadastroSimilar;

CREATE SEQUENCE seq_idprodutodetalhe;

CREATE TABLE ProdutoDetalhe (
                idProdutoDetalhe INTEGER NOT NULL DEFAULT nextval('seq_idprodutodetalhe'),
                idproduto BIGINT NOT NULL,
                idProdutoTipoDetalhe INTEGER NOT NULL,
                valor VARCHAR(255) NOT NULL,
                situacao CHAR(1) DEFAULT 'A',
                dataInclusao DATE NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                CONSTRAINT produtodetalhe_pk PRIMARY KEY (idProdutoDetalhe)
);
COMMENT ON TABLE ProdutoDetalhe IS 'Destinado para armazenar dados ligados a produtos. Dados que não são sempre utilizados pelos clientes, logo não estar como registros no cadastro principal do produto na tabela produto.';
COMMENT ON COLUMN ProdutoDetalhe.valor IS 'Valor do detalhe do produto. ';
COMMENT ON COLUMN ProdutoDetalhe.situacao IS 'A-Ativo , I-Inativo';


ALTER SEQUENCE seq_idprodutodetalhe OWNED BY ProdutoDetalhe.idProdutoDetalhe;

CREATE INDEX produtodetalhe_idx_idproduto
 ON ProdutoDetalhe
 ( idProduto );

CREATE SEQUENCE seq_idprodutoendereco;

CREATE TABLE ProdutoEndereco (
                idProdutoEndereco INTEGER NOT NULL DEFAULT nextval('seq_idprodutoendereco'),
                idproduto BIGINT NOT NULL,
                idempresa INTEGER NOT NULL,
                nomeArmazem VARCHAR(256) NOT NULL,
                rua VARCHAR(256) NOT NULL,
                corredor VARCHAR(256) NOT NULL,
                gondola VARCHAR(256) NOT NULL,
                prateleira VARCHAR(256) NOT NULL,
                nivel INTEGER NOT NULL,
                posicao INTEGER NOT NULL,
                capacidadeMaxima NUMERIC(15,3) NOT NULL,
                CONSTRAINT produtoendereco_pk PRIMARY KEY (idProdutoEndereco)
);


ALTER SEQUENCE seq_idprodutoendereco OWNED BY ProdutoEndereco.idProdutoEndereco;

CREATE INDEX produtoendereco_idx_idproduto_idempresa
 ON ProdutoEndereco
 ( idProduto, idEmpresa );

CREATE TABLE WFOcorrenciaProduto (
                idWFOcorrencia INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                CONSTRAINT wfocorrenciaproduto_pk PRIMARY KEY (idWFOcorrencia, idproduto)
);


CREATE SEQUENCE seq_idmaterialalmoxarifado;

CREATE TABLE MaterialAlmoxarifado (
                idMaterialAlmoxarifado INTEGER NOT NULL DEFAULT nextval('seq_idmaterialalmoxarifado'),
                descricao VARCHAR(255) NOT NULL,
                situacao CHAR(1) NOT NULL,
                idMaterialAlmoxarifadoCategoria INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER,
                codigoBarras NUMERIC(14,0),
                observacao VARCHAR(4096),
                dataInativacao DATE,
                dataAquisicao DATE,
                situacaoMaterial VARCHAR(1),
                idPessoaFabricante VARCHAR(128),
                idproduto BIGINT,
                etiqueta VARCHAR(255),
                modelo VARCHAR(255),
                idsetor INTEGER,
                idgrupo INTEGER,
                idfamilia INTEGER,
                tipodepreciacao VARCHAR(10),
                taxaanualdepreciacao NUMERIC(16,2),
                custoreposicao NUMERIC(16,2),
                CONSTRAINT materialalmoxarifado_pk PRIMARY KEY (idMaterialAlmoxarifado)
);
COMMENT ON TABLE MaterialAlmoxarifado IS 'Tabela que armazenará cadastro de Materiais que terão controle como exemplo: Uniformes, equipamentos, etc...';
COMMENT ON COLUMN MaterialAlmoxarifado.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN MaterialAlmoxarifado.observacao IS 'Gerais sobre o produto, como caracteristicas que não possuam campos especificos.  ';
COMMENT ON COLUMN MaterialAlmoxarifado.dataInativacao IS 'Dia em que foi inativado, caso situação fora igual a I.';
COMMENT ON COLUMN MaterialAlmoxarifado.situacaoMaterial IS 'Última definição da situação do material com base no movimento ou cadastro do mesmo. N -> Novo | C -> Conservador | D -> Danificado  ';
COMMENT ON COLUMN MaterialAlmoxarifado.idPessoaFabricante IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN MaterialAlmoxarifado.idproduto IS 'Ligação do Produto que pode ser emitido nota fiscal, ou seja, produto cadastrado em Produtos correspondente ao Bem. ';
COMMENT ON COLUMN MaterialAlmoxarifado.etiqueta IS 'Código para registrar emissão da etiqueta que normalmente é colado junto ao bem. ';
COMMENT ON COLUMN MaterialAlmoxarifado.tipodepreciacao IS 'L - Linear | H - Horas';


ALTER SEQUENCE seq_idmaterialalmoxarifado OWNED BY MaterialAlmoxarifado.idMaterialAlmoxarifado;

CREATE SEQUENCE seq_idmovimentoveiculomaterial;

CREATE TABLE MovimentoVeiculoMaterial (
                idMovimentoVeiculoMaterial INTEGER NOT NULL DEFAULT nextval('seq_idmovimentoveiculomaterial'),
                idMovimentoVeiculo INTEGER NOT NULL,
                idMaterialAlmoxarifado INTEGER NOT NULL,
                quantidadeSaida INTEGER NOT NULL,
                quantidadeRetorno INTEGER,
                CONSTRAINT movimentoveiculomaterial_pk PRIMARY KEY (idMovimentoVeiculoMaterial)
);
COMMENT ON TABLE MovimentoVeiculoMaterial IS 'Material de Almoxarifado (utilizados para apoiar as entregas) utilizados na entrega.';


ALTER SEQUENCE seq_idmovimentoveiculomaterial OWNED BY MovimentoVeiculoMaterial.idMovimentoVeiculoMaterial;

CREATE TABLE MaterialAlmoxarifadoDepreciacao (
                idMaterialAlmoxarifado INTEGER NOT NULL,
                idempresaCredito INTEGER,
                idContaCredito BIGINT,
                tipoPlanoContasCredito CHAR(1),
                idempresaDebito INTEGER,
                idContaDebito BIGINT,
                tipoPlanoContasDebito CHAR(1),
                CONSTRAINT materialalmoxarifadodepreciacao_pk PRIMARY KEY (idMaterialAlmoxarifado)
);
COMMENT ON COLUMN MaterialAlmoxarifadoDepreciacao.tipoPlanoContasCredito IS 'C-Contabil F-Financeiro G-Gerencial ';
COMMENT ON COLUMN MaterialAlmoxarifadoDepreciacao.tipoPlanoContasDebito IS 'C-Contabil F-Financeiro G-Gerencial ';


CREATE SEQUENCE seq_idmaterialalmoxarifadomidia;

CREATE TABLE MaterialAlmoxarifadoMidia (
                idMaterialAlmoxarifadoMidia INTEGER NOT NULL DEFAULT nextval('seq_idmaterialalmoxarifadomidia'),
                idMaterialAlmoxarifado INTEGER NOT NULL,
                midia BYTEA NOT NULL,
                extensaoMidia VARCHAR(32) NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER,
                CONSTRAINT materialalmoxarifadomidia_pk PRIMARY KEY (idMaterialAlmoxarifadoMidia)
);
COMMENT ON TABLE MaterialAlmoxarifadoMidia IS 'Guarda midias como arquivos de imagens e outros. ';


ALTER SEQUENCE seq_idmaterialalmoxarifadomidia OWNED BY MaterialAlmoxarifadoMidia.idMaterialAlmoxarifadoMidia;

CREATE SEQUENCE seq_idmaterialalmoxarifadocompras;

CREATE TABLE MaterialAlmoxarifadoCompras (
                idMaterialAlmoxarifadoCompras INTEGER NOT NULL DEFAULT nextval('seq_idmaterialalmoxarifadocompras'),
                quantidadeEstoqueMinimo NUMERIC(15,3) NOT NULL,
                idempresa INTEGER,
                idMaterialAlmoxarifadoLocalEstoque INTEGER NOT NULL,
                tipoRegistro CHAR(1),
                idMaterialAlmoxarifado INTEGER NOT NULL,
                CONSTRAINT materialalmoxarifadocompras_pk PRIMARY KEY (idMaterialAlmoxarifadoCompras)
);
COMMENT ON COLUMN MaterialAlmoxarifadoCompras.tipoRegistro IS 'A = Automatico, M = Manual Informa qual foi o tipo do registro, para o cadastro automatico não sobscrever o manual.';


ALTER SEQUENCE seq_idmaterialalmoxarifadocompras OWNED BY MaterialAlmoxarifadoCompras.idMaterialAlmoxarifadoCompras;

CREATE TABLE MaterialAlmoxarifadoEstoque (
                idempresa INTEGER NOT NULL,
                idMaterialAlmoxarifado INTEGER NOT NULL,
                idMaterialAlmoxarifadoLocalEstoque INTEGER NOT NULL,
                quantidadeAtual NUMERIC(15,3) NOT NULL,
                CONSTRAINT materialalmoxarifadoestoque_pk PRIMARY KEY (idempresa, idMaterialAlmoxarifado, idMaterialAlmoxarifadoLocalEstoque)
);
COMMENT ON TABLE MaterialAlmoxarifadoEstoque IS 'Armazenara o Saldo de estoque do Produto.';


CREATE SEQUENCE seq_idmaterialalmoxarifadomovimento;

CREATE TABLE MaterialAlmoxarifadoMovimento (
                idMaterialAlmoxarifadoMovimento INTEGER NOT NULL DEFAULT nextval('seq_idmaterialalmoxarifadomovimento'),
                idempresa INTEGER NOT NULL,
                idMaterialAlmoxarifado INTEGER NOT NULL,
                dataMovimento DATE NOT NULL,
                idColaboradorAlmoxarifado INTEGER,
                idColaborador INTEGER,
                idMaterialAlmoxarifadoLocalEstoque INTEGER NOT NULL,
                tipoMovimento CHAR(1) NOT NULL,
                tipoOperacao VARCHAR(10) NOT NULL,
                observacao VARCHAR(255),
                valorOperacao NUMERIC(15,2),
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER,
                quantidade NUMERIC(15,3),
                idEmpresaBaixaEstoque INTEGER,
                situacaoMaterial VARCHAR(1),
                idAreaEmpresa INTEGER,
                CONSTRAINT materialalmoxarifadomovimento_pk PRIMARY KEY (idMaterialAlmoxarifadoMovimento)
);
COMMENT ON TABLE MaterialAlmoxarifadoMovimento IS 'Armazenará as movimentações de Entradas e Saídas dos Materiais.';
COMMENT ON COLUMN MaterialAlmoxarifadoMovimento.idColaboradorAlmoxarifado IS 'Id do colaborador que faz a entrega ou recebe como retorno. ';
COMMENT ON COLUMN MaterialAlmoxarifadoMovimento.idColaborador IS 'Id do colaborador que recebe ou devolve o material.';
COMMENT ON COLUMN MaterialAlmoxarifadoMovimento.tipoMovimento IS 'E-Entrada, S-Saida, N-Neutro';
COMMENT ON COLUMN MaterialAlmoxarifadoMovimento.tipoOperacao IS 'C-Compras, D-Devolução, DD-Doação, P-Perdas';
COMMENT ON COLUMN MaterialAlmoxarifadoMovimento.situacaoMaterial IS 'Última definição da situação do material com base no movimento ou cadastro do mesmo. N -> Novo | C -> Conservador | D -> Danificado  ';
COMMENT ON COLUMN MaterialAlmoxarifadoMovimento.idAreaEmpresa IS 'Area em que o material foi movimentado. ';


ALTER SEQUENCE seq_idmaterialalmoxarifadomovimento OWNED BY MaterialAlmoxarifadoMovimento.idMaterialAlmoxarifadoMovimento;

CREATE INDEX materialalmoxarifadomovimento_idx_idempresa
 ON MaterialAlmoxarifadoMovimento
 ( idEmpresa );

CREATE INDEX materialalmoxarifadomovimento_idx_idmaterialalmoxarifado
 ON MaterialAlmoxarifadoMovimento
 ( idMaterialAlmoxarifado );

CREATE INDEX materialalmoxarifadomovimento_idx_datamovimento
 ON MaterialAlmoxarifadoMovimento
 ( dataMovimento );

CREATE TABLE PromocaoOfertaItens (
                idPromocaoOferta INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                valorPrecoPromocao NUMERIC(15,2),
                situacao VARCHAR(1) NOT NULL,
                idUsuarioCadastro INTEGER NOT NULL,
                dataCadastro DATE NOT NULL,
                idUsuarioAlteracao INTEGER,
                dataAlteracao DATE,
                valorDesconto NUMERIC(15,2),
                percDesconto NUMERIC(15,4),
                quantidadeMinima NUMERIC(15,4),
                quantidadeMaxima NUMERIC(15,4),
                CONSTRAINT promocaoofertaitens_pk PRIMARY KEY (idPromocaoOferta, idproduto)
);
COMMENT ON TABLE PromocaoOfertaItens IS 'Produtos ligados a promoção/oferta.';
COMMENT ON COLUMN PromocaoOfertaItens.situacao IS 'A-Ativo, I-Inativo';
COMMENT ON COLUMN PromocaoOfertaItens.quantidadeMinima IS 'Quantidade minima de venda do produto para entrar na promoção. ';
COMMENT ON COLUMN PromocaoOfertaItens.quantidadeMaxima IS 'Quantidade máxima de venda do produto para entrar na promoção. ';


CREATE TABLE AmostragemItens (
                idAmostragem INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                pesoPadrao NUMERIC(15,3) NOT NULL,
                pesoLiquido NUMERIC(15,3) NOT NULL,
                quantidadeCaixa INTEGER NOT NULL,
                CONSTRAINT amostragemitens_pk PRIMARY KEY (idAmostragem, idproduto)
);


CREATE TABLE RessupPedidoCompraItens (
                idRessupPedidoCompra INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                quantidade NUMERIC(15,4) NOT NULL,
                valorUnitario NUMERIC(20,6) NOT NULL,
                CONSTRAINT ressuppedidocompraitens_pk PRIMARY KEY (idRessupPedidoCompra, idproduto)
);


CREATE SEQUENCE seq_idestoqueinformacaoempresa;

CREATE TABLE EstoqueInformacaoEmpresa (
                idEstoqueInformacaoEmpresa INTEGER NOT NULL DEFAULT nextval('seq_idestoqueinformacaoempresa'),
                tipoInformacao VARCHAR(10) NOT NULL,
                idempresa INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                idUsuarioInclusao INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                quantidade NUMERIC(15,3) NOT NULL,
                situacao VARCHAR(10) NOT NULL,
                CONSTRAINT estoqueinformacaoempresa_pk PRIMARY KEY (idEstoqueInformacaoEmpresa)
);
COMMENT ON TABLE EstoqueInformacaoEmpresa IS 'Armazenará informações levantadas pelo responsável de estoque da unidade (empresa).';
COMMENT ON COLUMN EstoqueInformacaoEmpresa.tipoInformacao IS 'ED-Estoque Disponível ES-Estoque Solicitado EI-Estoque Inventário ';
COMMENT ON COLUMN EstoqueInformacaoEmpresa.situacao IS 'P-Pendente E-Exportado ';


ALTER SEQUENCE seq_idestoqueinformacaoempresa OWNED BY EstoqueInformacaoEmpresa.idEstoqueInformacaoEmpresa;

CREATE INDEX estoqueinformacaoempresa_idx_datainclusao_idempresa_idproduto
 ON EstoqueInformacaoEmpresa
 ( dataInclusao, idEmpresa, idProduto );

CREATE INDEX estoqueinformacaoempresa_idx_datainclusao_idproduto_idempresa
 ON EstoqueInformacaoEmpresa
 ( dataInclusao, idProduto, idEmpresa );

CREATE INDEX estoqueinformacaoempresa_idx_idproduto_datainclusao
 ON EstoqueInformacaoEmpresa
 ( idProduto, dataInclusao );

CREATE SEQUENCE seq_idcargaentregaocorrenciamidia;

CREATE TABLE CargaEntregaOcorrenciaMidia (
                idCargaEntregaOcorrenciaMidia INTEGER NOT NULL DEFAULT nextval('seq_idcargaentregaocorrenciamidia'),
                idCargaEntregaOcorrencia INTEGER NOT NULL,
                tipoMidia CHAR(3),
                midia BYTEA,
                extMidia VARCHAR(32),
                descricao VARCHAR(1024),
                idproduto BIGINT,
                CONSTRAINT cargaentregaocorrenciamidia_pk PRIMARY KEY (idCargaEntregaOcorrenciaMidia)
);
COMMENT ON COLUMN CargaEntregaOcorrenciaMidia.tipoMidia IS 'rec - Foto do Recibo, pro - Foto do Produto, ret - Foto do Retorno';


ALTER SEQUENCE seq_idcargaentregaocorrenciamidia OWNED BY CargaEntregaOcorrenciaMidia.idCargaEntregaOcorrenciaMidia;

CREATE TABLE CargaEntregaClienteItem (
                idCargaEntrega INTEGER NOT NULL,
                idSaidaOrigem VARCHAR(255) NOT NULL,
                idproduto BIGINT NOT NULL,
                quantidade NUMERIC(16,3) DEFAULT 0 NOT NULL,
                requerFoto CHAR(1) DEFAULT 'N' NOT NULL,
                CONSTRAINT cargaentregaclienteitem_pk PRIMARY KEY (idCargaEntrega, idSaidaOrigem, idproduto)
);
COMMENT ON COLUMN CargaEntregaClienteItem.requerFoto IS 'S-Sim, N-Não';


CREATE TABLE VendaPDVItens (
                idVendaPDV VARCHAR(255) NOT NULL,
                idproduto BIGINT NOT NULL,
                promocao CHAR(1) NOT NULL,
                idempresa INTEGER NOT NULL,
                idPdv INTEGER NOT NULL,
                idCupom INTEGER NOT NULL,
                dataHoraMovimento TIMESTAMP NOT NULL,
                quantidade NUMERIC(15,3) NOT NULL,
                valorTotalLiquido NUMERIC(16,3) DEFAULT 0 NOT NULL,
                CONSTRAINT vendapdvitens_pk PRIMARY KEY (idVendaPDV, idproduto, promocao)
);
COMMENT ON COLUMN VendaPDVItens.promocao IS 'S-Sim, N-Não';
COMMENT ON COLUMN VendaPDVItens.idPdv IS 'Numero do Caixa/PDV';


CREATE SEQUENCE seq_idcancelamentocupom;

CREATE TABLE CancelamentoCupom (
                idCancelamentoCupom INTEGER NOT NULL DEFAULT nextval('seq_idcancelamentocupom'),
                idempresa INTEGER NOT NULL,
                idUsuarioOperadorErp INTEGER,
                idUsuarioLiberadorErp INTEGER,
                sequenciaProduto INTEGER DEFAULT 1,
                dataCancelamento DATE NOT NULL,
                horaCancelamento VARCHAR(255) NOT NULL,
                documento VARCHAR(255) NOT NULL,
                idPdv INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                valorProduto NUMERIC(15,2) NOT NULL,
                quantidade NUMERIC(15,3) NOT NULL,
                tipoCancelamento CHAR(1) NOT NULL,
                CONSTRAINT cancelamentocupom_pk PRIMARY KEY (idCancelamentoCupom)
);
COMMENT ON COLUMN CancelamentoCupom.idUsuarioLiberadorErp IS 'Liberador de Cancealmento. Normalmente chamado de Fiscal de Caixa. ';
COMMENT ON COLUMN CancelamentoCupom.sequenciaProduto IS 'Sequência de cancelamento do produto no cupom';
COMMENT ON COLUMN CancelamentoCupom.documento IS 'Numero do Cupom Fiscal. ';
COMMENT ON COLUMN CancelamentoCupom.idPdv IS 'Numero do Caixa/PDV';
COMMENT ON COLUMN CancelamentoCupom.quantidade IS 'Quantidade de unidades do produto que foram canceladas.';
COMMENT ON COLUMN CancelamentoCupom.tipoCancelamento IS 'T-Total,  P-Parcial.  Total - Cancelado todo o Documento/Cupom de Venda  Parcial - Cancelado Itens';


ALTER SEQUENCE seq_idcancelamentocupom OWNED BY CancelamentoCupom.idCancelamentoCupom;

CREATE INDEX cancelamentocupom_idx_datacancelamento
 ON CancelamentoCupom
 ( dataCancelamento );

CREATE INDEX cancelamentocupom_idx_idproduto
 ON CancelamentoCupom
 ( idProduto );

CREATE SEQUENCE seq_idpesquisaprecorealizada;

CREATE TABLE PesquisaPrecoRealizada (
                idPesquisaPrecoRealizada INTEGER NOT NULL DEFAULT nextval('seq_idpesquisaprecorealizada'),
                idPesquisaPreco INTEGER NOT NULL,
                idConcorrente INTEGER NOT NULL,
                idproduto BIGINT,
                precoVenda NUMERIC(15,2) NOT NULL,
                tipoPreco CHAR(1) DEFAULT 'N' NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                observacao VARCHAR(255),
                codigoBarras VARCHAR(255),
                CONSTRAINT pesquisaprecorealizada_pk PRIMARY KEY (idPesquisaPrecoRealizada)
);
COMMENT ON COLUMN PesquisaPrecoRealizada.precoVenda IS 'Preco de Venda do Produto Vigente na Campanha. ';
COMMENT ON COLUMN PesquisaPrecoRealizada.tipoPreco IS 'P-Promoção, N-Normal';


ALTER SEQUENCE seq_idpesquisaprecorealizada OWNED BY PesquisaPrecoRealizada.idPesquisaPrecoRealizada;

CREATE INDEX pesquisaprecorealizada_idx_datainclusao_idproduto
 ON PesquisaPrecoRealizada
 ( dataInclusao, idProduto );

CREATE INDEX pesquisaprecorealizada_idx_idproduto
 ON PesquisaPrecoRealizada
 ( idProduto );

CREATE INDEX pesquisaprecorealizada_idx_codigobarras
 ON PesquisaPrecoRealizada
 ( codigoBarras );

CREATE SEQUENCE seq_idpesquisaprecoproduto;

CREATE TABLE PesquisaPrecoProduto (
                idPesquisaPrecoProduto INTEGER NOT NULL DEFAULT nextval('seq_idpesquisaprecoproduto'),
                descricaoProduto VARCHAR(255) NOT NULL,
                idPesquisaPreco INTEGER NOT NULL,
                idproduto BIGINT,
                codigoBarras VARCHAR(255),
                valorCusto NUMERIC(16,4),
                CONSTRAINT pesquisaprecoproduto_pk PRIMARY KEY (idPesquisaPrecoProduto)
);
COMMENT ON COLUMN PesquisaPrecoProduto.descricaoProduto IS 'descrição para produtos não cadastrados.';


ALTER SEQUENCE seq_idpesquisaprecoproduto OWNED BY PesquisaPrecoProduto.idPesquisaPrecoProduto;

CREATE SEQUENCE seq_desossaacougue_iddesossaacougue;

CREATE TABLE DesossaAcougue (
                idDesossaAcougue INTEGER NOT NULL DEFAULT nextval('seq_desossaacougue_iddesossaacougue'),
                idempresa INTEGER NOT NULL,
                idprodutoOrigem BIGINT NOT NULL,
                idprodutoDestino BIGINT NOT NULL,
                idProdutoDestinoVenda BIGINT,
                quantidadePerdasPrevista NUMERIC(15,3),
                tipoMovimento VARCHAR(1),
                percRendimentoEntrada NUMERIC(15,3),
                percRendimentoSaida NUMERIC(15,3),
                percRendimentoVenda NUMERIC(15,3),
                idEntidadeRegistroTipoDesossa INTEGER,
                CONSTRAINT desossaacougue_pk PRIMARY KEY (idDesossaAcougue)
);
COMMENT ON COLUMN DesossaAcougue.idprodutoOrigem IS 'Produto comprado para Desossa.  Ex: Traseiro Bovino. ';
COMMENT ON COLUMN DesossaAcougue.idprodutoDestino IS 'Produto que será rateado a Desossa. Ex: Picanha. ';
COMMENT ON COLUMN DesossaAcougue.idProdutoDestinoVenda IS 'Cód. do Produto que referencia a venda. Ex: Produto A é Orgem, Produto B é Desitno, Produto C é Destino de Venda do Produto B.';
COMMENT ON COLUMN DesossaAcougue.quantidadePerdasPrevista IS 'Quantidade estimada de perda no corte da carne. ';
COMMENT ON COLUMN DesossaAcougue.tipoMovimento IS 'P-Perdas R-Rateio. Sendo perdas entenderá que é movimentação de Perdas. ';
COMMENT ON COLUMN DesossaAcougue.percRendimentoEntrada IS '% Rendimento de Entrada dos produtos. ';
COMMENT ON COLUMN DesossaAcougue.percRendimentoSaida IS '% Rendimento Saida  ';
COMMENT ON COLUMN DesossaAcougue.percRendimentoVenda IS '% Rendimento de Venda. ';


ALTER SEQUENCE seq_desossaacougue_iddesossaacougue OWNED BY DesossaAcougue.idDesossaAcougue;

CREATE TABLE ProdutoCustoHistorico (
                idempresa INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                dataMovimento DATE NOT NULL,
                horaMovimento VARCHAR(8) NOT NULL,
                valorUnitarioBrutoAtual NUMERIC(15,2),
                valorUnitarioBrutoAnterior NUMERIC(15,2),
                valorUnitarioLiquidoAtual NUMERIC(15,2),
                valorUnitarioLiquidoAnterior NUMERIC(15,2),
                CONSTRAINT produtocustohistorico_pk PRIMARY KEY (idempresa, idproduto, dataMovimento, horaMovimento)
);
COMMENT ON TABLE ProdutoCustoHistorico IS 'Armazena as alterações do Custo do Produto.';
COMMENT ON COLUMN ProdutoCustoHistorico.valorUnitarioBrutoAtual IS 'Valor Bruto, normalmente considerado um valor de Nota fiscal, sem considerar impostos embutidos.';
COMMENT ON COLUMN ProdutoCustoHistorico.valorUnitarioLiquidoAtual IS 'Valor já deduzindo impostos e demais despesas contidas na composição do custo.  ';


CREATE INDEX produtocustohistorico_datamovimento
 ON ProdutoCustoHistorico
 ( dataMovimento );

CREATE SEQUENCE seq_idpontoexposicaomovimento;

CREATE TABLE PontoExposicaoMovimento (
                idPontoExposicaoMovimento INTEGER NOT NULL DEFAULT nextval('seq_idpontoexposicaomovimento'),
                idproduto BIGINT NOT NULL,
                idPontoExposicao INTEGER NOT NULL,
                idempresa INTEGER NOT NULL,
                tipoOperacao CHAR(2) NOT NULL,
                tipoMovimento CHAR(1) NOT NULL,
                quantidade NUMERIC(12,3) NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                dataInclusao DATE NOT NULL,
                idUsuarioInclusao INTEGER,
                situacao CHAR(1) NOT NULL,
                idusuarioSituacao INTEGER,
                situacaoMovimento CHAR(10),
                CONSTRAINT pontoexposicaomovimento_pk PRIMARY KEY (idPontoExposicaoMovimento)
);
COMMENT ON TABLE PontoExposicaoMovimento IS 'Armazena as movimentações de saidas e reposições do ponto de Exposição do Produto.';
COMMENT ON COLUMN PontoExposicaoMovimento.tipoOperacao IS 'P-Perdas, Q-Quebras, B-Roubo V-Vendas, S-Separação, C-Compras, R-Reposição, ';
COMMENT ON COLUMN PontoExposicaoMovimento.tipoMovimento IS 'E-Entrada, S-Saida, N-Neutro (identifica movimentação que não somará no saldo).';
COMMENT ON COLUMN PontoExposicaoMovimento.quantidade IS 'Quantidade do movimento. ';
COMMENT ON COLUMN PontoExposicaoMovimento.situacao IS 'P-Pendente, R-Rejeitado, A-Aprovado.';
COMMENT ON COLUMN PontoExposicaoMovimento.idusuarioSituacao IS 'Id do usuário que marcou a situacao.';
COMMENT ON COLUMN PontoExposicaoMovimento.situacaoMovimento IS 'U-Utilizado';


ALTER SEQUENCE seq_idpontoexposicaomovimento OWNED BY PontoExposicaoMovimento.idPontoExposicaoMovimento;

CREATE INDEX pontoexposicaomovimento_idx_datainclusaoproduto
 ON PontoExposicaoMovimento
 ( dataInclusao, idProduto );

CREATE INDEX pontoexposicaomovimento_idx_produto_empresa
 ON PontoExposicaoMovimento
 ( idProduto, idEmpresa );

CREATE TABLE ProdutoPontoExposicao (
                idempresa INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                idPontoExposicao INTEGER NOT NULL,
                quantidadeFrente INTEGER NOT NULL,
                capacidade INTEGER NOT NULL,
                percentualAbastecimento NUMERIC(15,4) NOT NULL,
                tipoAbastecimento CHAR(1),
                qtdeEmbalagemVenda NUMERIC(15,4) DEFAULT 0,
                qtdeVendaGatilhoReposicao NUMERIC(15,4) DEFAULT 0 NOT NULL,
                CONSTRAINT produtopontoexposicao_pk PRIMARY KEY (idempresa, idproduto, idPontoExposicao)
);
COMMENT ON TABLE ProdutoPontoExposicao IS 'Armazena informações de endereco e perfil de armazenagem do produto. ';
COMMENT ON COLUMN ProdutoPontoExposicao.percentualAbastecimento IS 'Meta de % em relação a capacidade de armazenagem, cujo será o gatílho de identificação de necessidade de reposição de produto.';
COMMENT ON COLUMN ProdutoPontoExposicao.tipoAbastecimento IS 'I-Individual, E-Embalagem Entrada';
COMMENT ON COLUMN ProdutoPontoExposicao.qtdeVendaGatilhoReposicao IS 'Alguns produtos possuem regras de abastecimento de venda quando atingir uma quantidade X de Vendas. ';


CREATE TABLE ProdutoMercadologicoLoja (
                idproduto BIGINT NOT NULL,
                idDepartamentoErp VARCHAR(128),
                IdSetorErp VARCHAR(128),
                idGrupoErp VARCHAR(128),
                idFamiliaErp VARCHAR(128),
                CONSTRAINT produtomercadologicoloja_pk PRIMARY KEY (idproduto)
);
COMMENT ON TABLE ProdutoMercadologicoLoja IS '  Traz o mercadologico padrao da loja como os códigos tal como está no cadastro do cliente. ';


CREATE TABLE CotacaoFornecedorItem (
                idCotacaoFornecedor INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                quantidade NUMERIC(10,2) DEFAULT 0 NOT NULL,
                observacao VARCHAR(255),
                CONSTRAINT cotacaofornecedoritem_pk PRIMARY KEY (idCotacaoFornecedor, idproduto)
);


CREATE TABLE MovimentoResumo (
                idempresa INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                idTipoOperacao INTEGER NOT NULL,
                dataMovimento DATE NOT NULL,
                quantidade NUMERIC(16,3) DEFAULT 0,
                valorBruto NUMERIC(16,3) DEFAULT 0,
                valorLiquido NUMERIC(16,3) DEFAULT 0,
                valorLucro NUMERIC(18,6) DEFAULT 0,
                valorCusto NUMERIC(16,3),
                CONSTRAINT movimentoresumo_pk PRIMARY KEY (idempresa, idproduto, idTipoOperacao, dataMovimento)
);


CREATE INDEX movimentoresumo_datamovimento_idx
 ON MovimentoResumo
 ( dataMovimento );

CREATE INDEX movimentoresumo_idproduto_idx
 ON MovimentoResumo
 ( idProduto );

CREATE TABLE ProdutoEstoque (
                idproduto BIGINT NOT NULL,
                idempresa INTEGER NOT NULL,
                idLocalEstoque INTEGER NOT NULL,
                qtdeEstoqueMinimo NUMERIC(15,3),
                qtdeEstoqueMaximo NUMERIC(15,2),
                diasEstoqueDesejado NUMERIC(15,2),
                diasEstoqueMaximo NUMERIC(15,2),
                qtdeEstoqueMinimoCalculado NUMERIC(15,2),
                qtdeEstoqueMaximoCalculado NUMERIC(15,2),
                dataCalculoAutomatico DATE,
                CONSTRAINT produtoestoque_pk PRIMARY KEY (idproduto, idempresa, idLocalEstoque)
);
COMMENT ON TABLE ProdutoEstoque IS 'Guarda informações ligadas ao estoque e reposição.';
COMMENT ON COLUMN ProdutoEstoque.dataCalculoAutomatico IS 'Data em que foi calculado o estoque minimo e maximo.';


CREATE TABLE ProdutoRankItem (
                idProdutoRank INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                dataInicial DATE NOT NULL,
                dataFinal DATE NOT NULL,
                tipoChave VARCHAR(128) NOT NULL,
                chave VARCHAR(128) NOT NULL,
                valor NUMERIC(15,2) NOT NULL,
                quantidade NUMERIC(15,3) NOT NULL,
                dataGravacao DATE NOT NULL,
                participacaoVendas NUMERIC(15,8),
                CONSTRAINT produtorankitem_pk PRIMARY KEY (idProdutoRank, idproduto, dataInicial, dataFinal, tipoChave, chave)
);


CREATE TABLE CampanhaOfertaItens (
                idCampanhaOferta BIGINT NOT NULL,
                idproduto BIGINT NOT NULL,
                prazoPagamento INTEGER,
                precoVenda NUMERIC(15,2) NOT NULL,
                valorCustoNegociado NUMERIC(15,2),
                idPessoa VARCHAR(128),
                tipoCompensacao CHAR(1),
                percIcmsEntrada NUMERIC(7,4),
                percIcmsSaida NUMERIC(7,4),
                valorBonificacaoDesc NUMERIC(15,2),
                tipoProduto CHAR(2),
                valorVerbaFixa NUMERIC(15,2),
                valorVerbaEstimada NUMERIC(15,2),
                contrato CHAR(1),
                dataInicialFaturamento DATE,
                dataFinalFaturamento DATE,
                produtos CHAR(1),
                volumeNegociado VARCHAR(128),
                quantidadeMinima NUMERIC(15,3),
                quantidadeMaxima NUMERIC(15,3),
                precoVendaVigente NUMERIC(15,2),
                idCampanhaOfertaItensTipoOferta INTEGER,
                CONSTRAINT campanhaofertaitens_pk PRIMARY KEY (idCampanhaOferta, idproduto)
);
COMMENT ON COLUMN CampanhaOfertaItens.precoVenda IS 'Preco de venda que deverá ser praticado nas lojas associadas. ';
COMMENT ON COLUMN CampanhaOfertaItens.valorCustoNegociado IS 'Valor unitário do custo do produto o qual foi devidamente negociado com o fornecedor, e que será direito das lojas efetuarem compras com tal valor. ';
COMMENT ON COLUMN CampanhaOfertaItens.idPessoa IS 'Fornecedor responsavel pelo produto. ';
COMMENT ON COLUMN CampanhaOfertaItens.tipoCompensacao IS 'Tipo da compensação a Central, ou seja, como o Fornecedor irá retornar o beneficio.   B-Bonificação S-Sell Out ';
COMMENT ON COLUMN CampanhaOfertaItens.tipoProduto IS 'CB - Cesta Básica ST - ?';
COMMENT ON COLUMN CampanhaOfertaItens.valorVerbaFixa IS 'Valor de repasse de verba do fornecedor ref. o item, o qual foi negociado com o comprador da Central. ';
COMMENT ON COLUMN CampanhaOfertaItens.contrato IS 'S - Sim, N - Não';
COMMENT ON COLUMN CampanhaOfertaItens.produtos IS 'E - Encartados F - Fidelizados';
COMMENT ON COLUMN CampanhaOfertaItens.precoVendaVigente IS 'Preco de venda do Produto vigente no momento. Não é obrigatório ao usuário informar, mas poderá utilizar para geração de relatórios, mostrando qual era o preco normal do produto no periodo da campanha. ';


CREATE SEQUENCE seq_idcampanhaofertaitenspontuacao;

CREATE TABLE CampanhaOfertaItensPontuacao (
                idCampanhaOfertaItensPontuacao INTEGER NOT NULL DEFAULT nextval('seq_idcampanhaofertaitenspontuacao'),
                idCampanhaOferta BIGINT NOT NULL,
                tipo VARCHAR(128) NOT NULL,
                quantidade INTEGER NOT NULL,
                dataInclusao DATE NOT NULL,
                horaInclusao VARCHAR(8) NOT NULL,
                idUsuarioInclusao INTEGER,
                idproduto BIGINT NOT NULL,
                CONSTRAINT campanhaofertaitenspontuacao_pk PRIMARY KEY (idCampanhaOfertaItensPontuacao)
);
COMMENT ON TABLE CampanhaOfertaItensPontuacao IS 'Define assa pontuações que ocorrem no resultado de uma campanha em relação ao produto. ';
COMMENT ON COLUMN CampanhaOfertaItensPontuacao.tipo IS 'Chave que define o tipo da pontuação. Ex: REAL_VENDIDO, PRODUTO_POSITIVADO, CLIENTE_POSITIVADO...';
COMMENT ON COLUMN CampanhaOfertaItensPontuacao.quantidade IS 'Quantidade de pontos que se ganha com base o tipo da pontuação.';


ALTER SEQUENCE seq_idcampanhaofertaitenspontuacao OWNED BY CampanhaOfertaItensPontuacao.idCampanhaOfertaItensPontuacao;

CREATE TABLE ProdutoEmpresa (
                idproduto BIGINT NOT NULL,
                idempresa INTEGER NOT NULL,
                situacaoCompra CHAR(1) NOT NULL,
                situacaoVenda CHAR(1) NOT NULL,
                CONSTRAINT produtoempresa_pk PRIMARY KEY (idproduto, idempresa)
);
COMMENT ON COLUMN ProdutoEmpresa.situacaoCompra IS 'A-Ativo , I-Inativo';
COMMENT ON COLUMN ProdutoEmpresa.situacaoVenda IS 'A-Ativo , I-Inativo';


CREATE TABLE ProdutoMonitorado (
                idempresa INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                tipoMonitoramento CHAR(3) NOT NULL,
                descricao VARCHAR(255),
                dataInicio DATE,
                dataFinal DATE,
                dataCadastro DATE NOT NULL,
                idUsuarioCadastro INTEGER NOT NULL,
                CONSTRAINT produtomonitorado_pk PRIMARY KEY (idempresa, idproduto, tipoMonitoramento)
);
COMMENT ON TABLE ProdutoMonitorado IS 'Tabela para Incluir produtos monitorados por algum projeto em aplicação. ';
COMMENT ON COLUMN ProdutoMonitorado.tipoMonitoramento IS 'RUP-Ruptura, INV-Inventário , PER-Perdas , OUT-Outros';
COMMENT ON COLUMN ProdutoMonitorado.dataInicio IS 'Data em que o Produto entrará em Monitoramento.';
COMMENT ON COLUMN ProdutoMonitorado.dataFinal IS 'Data em que o Produto Sairá em Monitoramento.';


CREATE TABLE ProdutoGiro (
                idempresa INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                tipoGiro CHAR(1) NOT NULL,
                dias INTEGER NOT NULL,
                quantidadeReal NUMERIC(10,3),
                quantidadeNormal NUMERIC(10,3),
                quantidadeComEstoque NUMERIC(10,3),
                giroDiaReal NUMERIC(10,3),
                giroDiaNormal NUMERIC(10,3),
                giroDiaComEstoque NUMERIC(10,3),
                dataAtualizacao DATE,
                CONSTRAINT produtogiro_pk PRIMARY KEY (idempresa, idproduto, tipoGiro, dias)
);
COMMENT ON COLUMN ProdutoGiro.tipoGiro IS 'C-Compras, V-Vendas, E-Entradas, S-Saidas';
COMMENT ON COLUMN ProdutoGiro.quantidadeReal IS 'Considera quantidades vendidas, seja preco normal, preço promoção, com ou sem estoque no dia. ';
COMMENT ON COLUMN ProdutoGiro.quantidadeNormal IS 'Quantidades Desconsiderando preco em ofertas. ';
COMMENT ON COLUMN ProdutoGiro.quantidadeComEstoque IS 'Quantidade vendida apenas em dias com saldo de  estoque';


CREATE TABLE ProdutoFornecedor (
                idPessoa VARCHAR(128) NOT NULL,
                idproduto BIGINT NOT NULL,
                embalagemEntrada VARCHAR(128),
                quantidadeEmbalagem NUMERIC(10,3),
                codigoProdutoIndustria VARCHAR(128),
                ressuprimentoAutomatico VARCHAR(1),
                dataInclusao DATE,
                fornecedorPadrao CHAR(1),
                valorPrecoLista NUMERIC(15,2) DEFAULT 0,
                CONSTRAINT produtofornecedor_pk PRIMARY KEY (idPessoa, idproduto)
);
COMMENT ON COLUMN ProdutoFornecedor.idPessoa IS 'Varchar para suportar os vários modelos de dados dos Erps importados.';
COMMENT ON COLUMN ProdutoFornecedor.ressuprimentoAutomatico IS 'A-Ativo, I-Inativo  Confirmação pelo gestor, se o produto do Fornecedor, terá ou não Ressuprimento realizado automaticamente pelo Fornecedor. ';
COMMENT ON COLUMN ProdutoFornecedor.dataInclusao IS 'Data inclusão para log e auditoria de produtos relacionados com XX fornecedor.';
COMMENT ON COLUMN ProdutoFornecedor.fornecedorPadrao IS 'S-Sim, N-Não.  Identifica se o fornecedor é padrão de compras ou não. ';


CREATE INDEX produtofornecedor_idx_idproduto_idpessoa
 ON ProdutoFornecedor
 ( idProduto, idPessoa );

CREATE TABLE ProdutoResumo (
                idempresa INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                idUltimaVenda VARCHAR(255),
                dataUltimaVenda DATE,
                qtdeUltimaVenda NUMERIC(16,3),
                idUltimaSaida VARCHAR(255),
                dataUltimaSaida DATE,
                qtdeUltimaSaida NUMERIC(16,3),
                idUltimaCompra VARCHAR(255),
                dataUltimaCompra DATE,
                qtdeUltimaCompra NUMERIC(16,3),
                idUltimaEntrada VARCHAR(255),
                dataUltimaEntrada DATE,
                qtdeUltimaEntrada NUMERIC(16,3),
                valorUltimoImposto NUMERIC(15,2),
                CONSTRAINT produtoresumo_pk PRIMARY KEY (idempresa, idproduto)
);
COMMENT ON COLUMN ProdutoResumo.valorUltimoImposto IS 'Valor Líquido de Pis, cofins e Icms (Debito - Credito) ';


CREATE INDEX produtoresumo_idx_dataultimavenda
 ON ProdutoResumo
 ( dataUltimaVenda );

CREATE INDEX produtoresumo_idx_dataultimacompra
 ON ProdutoResumo
 ( dataUltimaCompra );

CREATE TABLE PrecoVendaHistorico (
                idempresa INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                dataAlteracao DATE NOT NULL,
                horaAlteracao VARCHAR(155) NOT NULL,
                valPrecoAnterior NUMERIC(15,2) NOT NULL,
                valPrecoAtual NUMERIC(15,2) NOT NULL,
                valPromocaoAnterior NUMERIC(15,2) NOT NULL,
                valPromocaoAtual NUMERIC(15,2) NOT NULL,
                rotinaAlteracao VARCHAR(100),
                usuarioAlteracao VARCHAR(255),
                CONSTRAINT precovendahistorico_pk PRIMARY KEY (idempresa, idproduto, dataAlteracao, horaAlteracao)
);


CREATE TABLE EstoqueSaldoAtual (
                idempresa INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                idLocalEstoque INTEGER NOT NULL,
                quantidade NUMERIC(12,3) NOT NULL,
                dataSaldo DATE NOT NULL,
                valCustoMedio NUMERIC(15,2) NOT NULL,
                valorAtualEstoque NUMERIC(15,3),
                CONSTRAINT estoquesaldoatual_pk PRIMARY KEY (idempresa, idproduto, idLocalEstoque)
);
COMMENT ON COLUMN EstoqueSaldoAtual.valorAtualEstoque IS 'Valor Atual do Estoque. Dependendo do Erp, pode ser avaliado por Custo Medio ou outro tipo de custo. ';


CREATE INDEX estoquesaldoatual_idx_idproduto_idempresa
 ON EstoqueSaldoAtual
 ( idProduto, idEmpresa );

CREATE TABLE ProdutoMargem (
                idempresa INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                perMargemLucro NUMERIC(15,2) NOT NULL,
                CONSTRAINT produtomargem_pk PRIMARY KEY (idempresa, idproduto)
);


CREATE TABLE InventarioEstoqueItem (
                idInventario INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                idLocalEstoque INTEGER NOT NULL,
                quantidadeContada NUMERIC(16,4) NOT NULL,
                quantidadeEstoque NUMERIC(16,4) NOT NULL,
                valorUnitario NUMERIC(16,4) NOT NULL,
                idUsuarioCadastro INTEGER NOT NULL,
                dataCadastro DATE NOT NULL,
                idUsuarioAlteracao INTEGER,
                dataAlteracao DATE,
                CONSTRAINT inventarioestoqueitem_pk PRIMARY KEY (idInventario, idproduto, idLocalEstoque)
);


CREATE INDEX inventarioestoqueitem_idx_idproduto
 ON InventarioEstoqueItem
 ( idProduto );

CREATE TABLE ProdutoPrecoCusto (
                idempresa INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                valorPrecoVenda NUMERIC(12,2),
                valorPrecoPromocao NUMERIC(12,2),
                dataInicioPromocao DATE,
                dataFinalPromocao DATE,
                valorCustoAquisicao NUMERIC(12,4),
                valorCustoPmz NUMERIC(12,2),
                valorCustoNotaFiscal NUMERIC(12,2),
                dataAlteracaoPreco DATE,
                horaAlteracaoPreco VARCHAR(255),
                CONSTRAINT produtoprecocusto_pk PRIMARY KEY (idempresa, idproduto)
);


CREATE TABLE ClasseProdutoHist (
                idEmpresa INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                tipoanalise CHAR(1) NOT NULL,
                data DATE NOT NULL,
                idMercadologico VARCHAR(128) NOT NULL,
                classe CHAR(1),
                CONSTRAINT classeprodutohist_pk PRIMARY KEY (idEmpresa, idproduto, tipoanalise, data, idMercadologico)
);
COMMENT ON COLUMN ClasseProdutoHist.tipoanalise IS 'V-Valor de vendas, G-Quantidade de vendas (Giro), L-Valor de lucro, M-Margem de lucro';


CREATE TABLE ClasseProduto (
                idEmpresa INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                idMercadologico VARCHAR(128) NOT NULL,
                tipoanalise CHAR(1) NOT NULL,
                classe CHAR(1),
                CONSTRAINT classeproduto_pk PRIMARY KEY (idEmpresa, idproduto, idMercadologico, tipoanalise)
);
COMMENT ON COLUMN ClasseProduto.tipoanalise IS 'V-Valor de vendas, G-Quantidade de vendas (Giro), L-Valor de lucro, M-Margem de lucro';


CREATE TABLE ProdutoEmbalagem (
                idproduto BIGINT NOT NULL,
                codigobarras NUMERIC(14,0) NOT NULL,
                quantidade NUMERIC(10,3) NOT NULL,
                pesoBruto NUMERIC(10,3),
                pesoLiquido NUMERIC(10,3),
                CONSTRAINT produtoembalagem_pk PRIMARY KEY (idproduto, codigobarras)
);


CREATE TABLE PedidoCompra (
                idempresa INTEGER NOT NULL,
                idpedido BIGINT NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                dataemissao DATE,
                situacao CHAR(1) DEFAULT 'N',
                dataprevisaoentrega DATE,
                idUsuario INTEGER,
                tipopedido CHAR(1) DEFAULT 'C' NOT NULL,
                pedidoOriginal VARCHAR(255),
                dataCadastro DATE,
                dataRecebimento DATE,
                idColaboradorComprador INTEGER,
                horaEmissao VARCHAR(256),
                idCompradorErp INTEGER,
                CONSTRAINT pedidocompra_pk PRIMARY KEY (idempresa, idpedido, idPessoa)
);
COMMENT ON COLUMN PedidoCompra.situacao IS 'N-Normal, C-Cancelado , R-Recebido , P-Parcialmente Atendido';
COMMENT ON COLUMN PedidoCompra.tipopedido IS 'C-Compra, R-Reposição, B-Bonificação';
COMMENT ON COLUMN PedidoCompra.dataCadastro IS 'Data em que foi cadastrado o pedido no erp.';
COMMENT ON COLUMN PedidoCompra.dataRecebimento IS 'Data em que o pedido foi recebido no erp.';
COMMENT ON COLUMN PedidoCompra.horaEmissao IS 'Hora em que o Pedido foi gravado no Erp. ';
COMMENT ON COLUMN PedidoCompra.idCompradorErp IS 'Alguns erps possuem cadastro especifico do comprador diferente do cadastro de usuário. Importante subirmos essa informação também. ';


CREATE INDEX pedidocompra_idx_dataemissao
 ON PedidoCompra
 ( dataEmissao );

CREATE INDEX pedidocompra_idx_idempresa_dataemissao
 ON PedidoCompra
 ( idEmpresa, dataEmissao );

CREATE TABLE PedidoCompraEdi (
                idempresa INTEGER NOT NULL,
                idpedido BIGINT NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                edi VARCHAR(255) NOT NULL,
                dataEnvio DATE NOT NULL,
                horaEnvio VARCHAR(8) NOT NULL,
                CONSTRAINT pedidocompraedi_pk PRIMARY KEY (idempresa, idpedido, idPessoa, edi)
);
COMMENT ON TABLE PedidoCompraEdi IS 'Armazena informações do Pedido de compras em relação as integrações de dados EDI com empresas como NEOGRID, NIELSEN';
COMMENT ON COLUMN PedidoCompraEdi.edi IS 'Identificação da Integração: Exemplo: Neogrid';


CREATE TABLE PedidoCompraVcto (
                idempresa INTEGER NOT NULL,
                idpedido BIGINT NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                dataVencimento DATE NOT NULL,
                valorParcela NUMERIC(15,2) NOT NULL,
                CONSTRAINT pedidocompravcto_pk PRIMARY KEY (idempresa, idpedido, idPessoa, dataVencimento)
);


CREATE TABLE PedidoCompraItens (
                idempresa INTEGER NOT NULL,
                idpedido BIGINT NOT NULL,
                idPessoa VARCHAR(128) NOT NULL,
                idproduto BIGINT NOT NULL,
                quantidadesolicitada NUMERIC(12,3),
                quantidadependente NUMERIC(12,3),
                valorUnitario NUMERIC(15,6) NOT NULL,
                quantidadeEmbalagem NUMERIC(10,3),
                valorUnitarioEmbalagem NUMERIC(15,6),
                valorUnitarioLiquido NUMERIC(15,6),
                CONSTRAINT pedidocompraitens_pk PRIMARY KEY (idempresa, idpedido, idPessoa, idproduto)
);
COMMENT ON COLUMN PedidoCompraItens.quantidadesolicitada IS 'Soma de todos os produtos pendentes na loja.';
COMMENT ON COLUMN PedidoCompraItens.valorUnitario IS 'Valor Bruto do produto.  Normalmente o valor de pauta impresso na Nota fiscal.  (Valor da unidade do Produto)  ';
COMMENT ON COLUMN PedidoCompraItens.valorUnitarioEmbalagem IS 'Valor total da embalagem.  Exemplo: Cx com 10 unidades.  O valor deverá ser o valor total da caixa.';
COMMENT ON COLUMN PedidoCompraItens.valorUnitarioLiquido IS 'é igual ao liquido do entradaitens, ou seja, valor final pago do produto, já com impostos dedutíveis e creditáveis.';


CREATE TABLE EstoqueDia (
                idempresa INTEGER NOT NULL,
                idproduto BIGINT NOT NULL,
                idLocalEstoque INTEGER NOT NULL,
                datamovimento DATE NOT NULL,
                quantidade NUMERIC(12,3) NOT NULL,
                valCustoMedio NUMERIC(15,6),
                dataMovimentoFinal DATE,
                CONSTRAINT estoquedia_pk PRIMARY KEY (idempresa, idproduto, idLocalEstoque, datamovimento)
);
COMMENT ON COLUMN EstoqueDia.dataMovimentoFinal IS 'Permite nulo. Implementado em 02/08/2022 com objetivo de facilitar a buscar de estoque de um determinado período. Ex: um produto que tenha 10 de estoque dia 01/01/2022 e somente foi alterado para 25 de estoque dia 15/03/2022, ao tentar buscar o estoque do dia 10/02/2022, por exemplo, é necessário fazer uma subquery para buscar a última data de movimento do produto, que antes do dia 10/02 é a 01/01. Bom, com dataMovimentoFinal preenchiada até 14/03/2022, basta fazer um b e t w e e n, por exemplo: 10/02/2022 está entre 01/01/2022 e 14/03/2022. Caso esteja nulo, considerar sempre a data atual como final, porém é necessário validar se este recurso já foi implementando no cliente o qual você deseja usar.';


CREATE INDEX estoque_idx_empresa_produto
 ON EstoqueDia
 ( idEmpresa, idProduto );

CREATE INDEX estoque_idx_produto_data
 ON EstoqueDia
 ( idProduto, dataMovimento );

CREATE INDEX estoquedia_datamovimento_datamovimentofinal_idx
 ON EstoqueDia
 ( dataMovimento, dataMovimentoFinal );

CREATE TABLE Entrada (
                idEntrada VARCHAR(255) NOT NULL,
                idempresa INTEGER NOT NULL,
                datamovimento DATE NOT NULL,
                cnpj VARCHAR(18) NOT NULL,
                dataEmissaoNF DATE,
                numeroNF BIGINT,
                serieNF VARCHAR(3),
                idTipoOperacao INTEGER NOT NULL,
                idUsuario INTEGER,
                idPessoa VARCHAR(128),
                hora VARCHAR(10),
                CONSTRAINT entrada_pk PRIMARY KEY (idEntrada)
);


CREATE INDEX entrada_idx_datamovimento_idempresa
 ON Entrada
 ( dataMovimento, idEmpresa );

CREATE INDEX entrada_idx_cnpj
 ON Entrada
 ( cnpj );

CREATE INDEX entrada_idx_idempresa
 ON Entrada
 ( idEmpresa );

CREATE INDEX entrada_idx_dtmov_codbar_idemp
 ON Entrada
 ( dataMovimento, idEmpresa );

CREATE INDEX entrada_idx_dataemissaonf
 ON Entrada
 ( dataEmissaoNF );

CREATE SEQUENCE seq_identradaitemvcto;

CREATE TABLE EntradaItemVcto (
                idEntradaItemVcto INTEGER NOT NULL DEFAULT nextval('seq_identradaitemvcto'),
                idproduto BIGINT NOT NULL,
                idEntrada VARCHAR(255) NOT NULL,
                idempresa INTEGER NOT NULL,
                dataVencimento DATE NOT NULL,
                CONSTRAINT entradaitemvcto_pk PRIMARY KEY (idEntradaItemVcto)
);


ALTER SEQUENCE seq_identradaitemvcto OWNED BY EntradaItemVcto.idEntradaItemVcto;

CREATE INDEX entradaitemvcto_idx
 ON EntradaItemVcto
 ( idProduto, idEntrada, idEmpresa );

CREATE INDEX entradaitemvcto_idx_datavencimento
 ON EntradaItemVcto
 ( dataVencimento );

CREATE TABLE EntradaItens (
                idEntrada VARCHAR(255) NOT NULL,
                idproduto BIGINT NOT NULL,
                idempresa INTEGER NOT NULL,
                dataMovimento DATE NOT NULL,
                quantidade NUMERIC(16,3) DEFAULT 0 NOT NULL,
                valorUnitarioBruto NUMERIC(16,3) DEFAULT 0 NOT NULL,
                valorUnitarioLiquido NUMERIC(16,3) DEFAULT 0 NOT NULL,
                valorTotalBruto NUMERIC(16,3) DEFAULT 0 NOT NULL,
                valorTotalLiquido NUMERIC(16,3) DEFAULT 0 NOT NULL,
                valorComST NUMERIC(12,2) DEFAULT 0 NOT NULL,
                valorSTEnt NUMERIC(12,2) DEFAULT 0 NOT NULL,
                valorCredICMSEnt NUMERIC(12,2) DEFAULT 0 NOT NULL,
                percICMSEnt NUMERIC(15,4) DEFAULT 0 NOT NULL,
                valorIPIEnt NUMERIC(12,2) DEFAULT 0 NOT NULL,
                percIPIEnt NUMERIC(15,4) DEFAULT 0 NOT NULL,
                valorPISEnt NUMERIC(12,2) DEFAULT 0 NOT NULL,
                percPISEnt NUMERIC(15,4) DEFAULT 0 NOT NULL,
                valorCOFINSEnt NUMERIC(12,2) DEFAULT 0 NOT NULL,
                percCOFINSEnt NUMERIC(15,4) DEFAULT 0 NOT NULL,
                valorDesc NUMERIC(12,2) DEFAULT 0 NOT NULL,
                valorAcresc NUMERIC(12,2) DEFAULT 0 NOT NULL,
                valorFreteConhec NUMERIC(12,2) DEFAULT 0 NOT NULL,
                valorFreteNF NUMERIC(12,2) DEFAULT 0 NOT NULL,
                valorDebICMSSai NUMERIC(12,2) DEFAULT 0 NOT NULL,
                percICMSSai NUMERIC(15,4) DEFAULT 0 NOT NULL,
                quantidadeEmb NUMERIC(10,3),
                idcfop INTEGER,
                idTipoOperacao INTEGER,
                valorLucroUnitario NUMERIC(18,6),
                idVendedorErp VARCHAR(255),
                valorIcmsSt NUMERIC(15,2),
                CONSTRAINT entradaitens_pk PRIMARY KEY (idEntrada, idproduto)
);
COMMENT ON COLUMN EntradaItens.valorLucroUnitario IS 'Devolução de Venda. ';
COMMENT ON COLUMN EntradaItens.idVendedorErp IS 'ID do Vendedor no ERP que realizou a venda ';


CREATE INDEX entradaitens_idx_prod_idempresa_dtmovi
 ON EntradaItens
 ( idProduto, idEmpresa, dataMovimento );

CREATE INDEX entradaitens_idx_prod_dtmovi
 ON EntradaItens
 ( idProduto, dataMovimento );

CREATE INDEX entradaitens_idx_datamovimento
 ON EntradaItens
 ( dataMovimento );

CREATE TABLE Saida (
                idSaida VARCHAR(255) NOT NULL,
                idempresa INTEGER NOT NULL,
                idVendedorErp VARCHAR(255),
                datamovimento DATE NOT NULL,
                numDocumento INTEGER NOT NULL,
                idPessoa VARCHAR(128),
                hora VARCHAR(10),
                idTipoOperacao INTEGER NOT NULL,
                idCaixa INTEGER,
                idUsuario INTEGER,
                cancelado CHAR(1) DEFAULT 'N' NOT NULL,
                chaveMovimento VARCHAR(255),
                CONSTRAINT saida_pk PRIMARY KEY (idSaida)
);
COMMENT ON COLUMN Saida.idVendedorErp IS 'ID do Vendedor no ERP que realizou a venda. ';
COMMENT ON COLUMN Saida.numDocumento IS 'Número do Cupom ou Nota Fiscal de Venda.';
COMMENT ON COLUMN Saida.cancelado IS 'S-Sim, N-Não';
COMMENT ON COLUMN Saida.chaveMovimento IS 'Dado que identifica o documento de origem que gerou o registro. ';


CREATE INDEX saida_idx_data_empresa
 ON Saida
 ( dataMovimento, idEmpresa );

CREATE INDEX saida_idx_idempresa_numdocumento
 ON Saida
 ( idEmpresa, numDocumento );

CREATE INDEX saida_idx_chavemovimento
 ON Saida
 ( chaveMovimento );

CREATE TABLE SaidaItens (
                idSaida VARCHAR(255) NOT NULL,
                idproduto BIGINT NOT NULL,
                tipopreco CHAR(1) DEFAULT 'N' NOT NULL,
                idempresa INTEGER NOT NULL,
                dataMovimento DATE,
                quantidade NUMERIC(16,3) DEFAULT 0 NOT NULL,
                valorUnitarioBruto NUMERIC(16,3) DEFAULT 0 NOT NULL,
                valorUnitarioLiquido NUMERIC(16,3) DEFAULT 0 NOT NULL,
                valorTotalBruto NUMERIC(16,3) DEFAULT 0 NOT NULL,
                valorTotalLiquido NUMERIC(16,3) DEFAULT 0 NOT NULL,
                perDesconto NUMERIC(10,6) DEFAULT 0 NOT NULL,
                valorcustoproduto NUMERIC(16,3) DEFAULT 0 NOT NULL,
                idcfop INTEGER,
                valorLucroVenda NUMERIC(18,6) DEFAULT 0 NOT NULL,
                margemLucroVenda NUMERIC(10,3) DEFAULT 0 NOT NULL,
                cancelado CHAR(1) DEFAULT 'N' NOT NULL,
                idTipoOperacao INTEGER,
                valorDescontoItem NUMERIC(15,4),
                valorDescontoVendaGeral NUMERIC(15,4),
                valorSt NUMERIC(16,3) DEFAULT 0,
                idEmpresaBaixaEstoque INTEGER,
                percIcms NUMERIC(15,4),
                valorIcms NUMERIC(15,2),
                percPis NUMERIC(15,4),
                valorPis NUMERIC(15,2),
                percCofins NUMERIC(15,4),
                valorCofins NUMERIC(15,2),
                valorIcmsSt NUMERIC(15,2),
                CONSTRAINT saidaitens_pk PRIMARY KEY (idSaida, idproduto, tipopreco)
);
COMMENT ON COLUMN SaidaItens.tipopreco IS 'O-Oferta, N-Normal';
COMMENT ON COLUMN SaidaItens.valorcustoproduto IS 'Valor custo última compra. Valor compras + impostos.';
COMMENT ON COLUMN SaidaItens.valorLucroVenda IS 'Valor total de lucro do produto na venda. ';
COMMENT ON COLUMN SaidaItens.cancelado IS 'S-Sim, N-Não';
COMMENT ON COLUMN SaidaItens.valorDescontoVendaGeral IS 'Valor desconto aplicado na nota/cupom. ';


CREATE INDEX saidaitens_idx_pro_emp_dt
 ON SaidaItens
 ( idProduto, idEmpresa, dataMovimento );

CREATE INDEX saidaitens_idx_pro_dt
 ON SaidaItens
 ( idProduto, dataMovimento );

CREATE INDEX saidaitens_idx_dtmovimento
 ON SaidaItens
 ( dataMovimento );

CREATE TABLE QuebraMovimento (
                idSaida VARCHAR(255) NOT NULL,
                idproduto BIGINT NOT NULL,
                tipopreco CHAR(1) DEFAULT 'N' NOT NULL,
                idempresa INTEGER,
                dataMovimento DATE,
                idTipoOperacao INTEGER,
                valor NUMERIC(16,4),
                quantidade NUMERIC(16,4),
                idQuebraMotivo INTEGER,
                idQuebraDestino INTEGER,
                idLocalEstoque INTEGER,
                CONSTRAINT quebramovimento_pk PRIMARY KEY (idSaida, idproduto, tipopreco)
);
COMMENT ON TABLE QuebraMovimento IS 'Armazena movimentação de lancamentos de quebras registrado no estoque como saidaitens. ';
COMMENT ON COLUMN QuebraMovimento.tipopreco IS 'O-Oferta, N-Normal';
COMMENT ON COLUMN QuebraMovimento.dataMovimento IS 'Dia que aconteceu ou foi lancado a quebra.';
COMMENT ON COLUMN QuebraMovimento.valor IS 'Valor monetário da quebra. (Valor unitário do Produto) ';


CREATE INDEX quebramovimento_empresadatamovimento
 ON QuebraMovimento
 ( idEmpresa, dataMovimento );

CREATE INDEX quebramovimento_datamovimento
 ON QuebraMovimento
 ( dataMovimento );

CREATE INDEX quebramovimento_idx_tipooperacao
 ON QuebraMovimento
 ( idTipoOperacao );

ALTER TABLE Produto ADD CONSTRAINT grupoprecoproduto_produto_fk
FOREIGN KEY (idGrupoPrecoProduto)
REFERENCES GrupoPrecoProduto (idGrupoPrecoProduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaPerfil ADD CONSTRAINT perfilpessoa_pessoaperfil_fk
FOREIGN KEY (idPerfilPessoa)
REFERENCES PerfilPessoa (idPerfilPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Colaborador ADD CONSTRAINT nivelsenioridadecolaborador_colaborador_fk
FOREIGN KEY (idNivelSenioridade)
REFERENCES NivelSenioridadeColaborador (idNivelSenioridadeColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOfertaItens ADD CONSTRAINT campanhaofertaitenstipooferta_campanhaofertaitens_fk
FOREIGN KEY (idCampanhaOfertaItensTipoOferta)
REFERENCES CampanhaOfertaItensTipoOferta (idCampanhaOfertaItensTipoOferta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOferta ADD CONSTRAINT campanhaofertatipo_campanhaoferta_fk
FOREIGN KEY (idCampanhaOfertaTipo)
REFERENCES CampanhaOfertaTipo (idCampanhaOfertaTipo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoDetalhe ADD CONSTRAINT produtotipodetalhe_produtodetalhe_fk
FOREIGN KEY (idProdutoTipoDetalhe)
REFERENCES ProdutoTipoDetalhe (idProdutoTipoDetalhe)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaCanais ADD CONSTRAINT canalpublicidade_campanhacanais_fk
FOREIGN KEY (idCanalPublicidade)
REFERENCES CanalPublicidade (idCanalPublicidade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoAntecipacaoRecebiveis ADD CONSTRAINT instituicaofinanceira_solicitacaoantecipacaorecebiveis_fk
FOREIGN KEY (idInstituicaoFinanceira)
REFERENCES InstituicaoFinanceira (idInstituicaoFinanceira)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaInstituicaoFinanceira ADD CONSTRAINT instituicaofinanceira_pessoainstituicaofinanceira_fk
FOREIGN KEY (idInstituicaoFinanceira)
REFERENCES InstituicaoFinanceira (idInstituicaoFinanceira)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItCobranca ADD CONSTRAINT instituicaofinanceira_itcobranca_fk
FOREIGN KEY (idInstituicaoFinanceira)
REFERENCES InstituicaoFinanceira (idInstituicaoFinanceira)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaCliente ADD CONSTRAINT regiao_pessoacliente_fk
FOREIGN KEY (idRegiao)
REFERENCES Regiao (idRegiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MovimentoVeiculoCheck ADD CONSTRAINT veiculocheck_movimentoveiculocheck_fk
FOREIGN KEY (idVeiculoCheck)
REFERENCES VeiculoCheck (idVeiculoCheck)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ConteudoApresentacaoMidia ADD CONSTRAINT conteudoapresentacao_conteudoapresentacaomidia_fk
FOREIGN KEY (idConteudoApresentacao)
REFERENCES ConteudoApresentacao (idConteudoApresentacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MovimentoVeiculo ADD CONSTRAINT movimentoveiculomotivo_movimentoveiculo_fk
FOREIGN KEY (idMovimentoVeiculoMotivo)
REFERENCES MovimentoVeiculoMotivo (idMovimentoVeiculoMotivo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoEtapa ADD CONSTRAINT solicitacaosuprimentotipoetapa_solicitacaosuprimentoetapa_fk
FOREIGN KEY (idSolicitacaoSuprimentoTipoEtapa)
REFERENCES SolicitacaoSuprimentoTipoEtapa (idSolicitacaoSuprimentoTipoEtapa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoItens ADD CONSTRAINT solicitacaosuprimentomotivo_solicitacaosuprimentoitens_fk
FOREIGN KEY (idSolicitacaoSuprimentoMotivo)
REFERENCES SolicitacaoSuprimentoMotivo (idSolicitacaoSuprimentoMotivo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoItens ADD CONSTRAINT solicitacaosuprimentoitemsolicitacao_solicitacaosuprimentoit472
FOREIGN KEY (idSolicitacaoSuprimentoItemSolicitacao)
REFERENCES SolicitacaoSuprimentoItem (idSolicitacaoSuprimentoItem)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimento ADD CONSTRAINT solicitacaosuprimentocategoria_solicitacaosuprimento_fk
FOREIGN KEY (idSolicitacaoSuprimentoCategoria)
REFERENCES SolicitacaoSuprimentoCategoria (idSolicitacaoSuprimentoCategoria)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoEtapa ADD CONSTRAINT solicitacaosuprimentocategoria_solicitacaosuprimentoetapa_fk
FOREIGN KEY (idSolicitacaoSuprimentoCategoria)
REFERENCES SolicitacaoSuprimentoCategoria (idSolicitacaoSuprimentoCategoria)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoSubCategoria ADD CONSTRAINT solicitacaosuprimentocategoria_solicitacaosuprimentosubcateg733
FOREIGN KEY (idSolicitacaoSuprimentoCategoria)
REFERENCES SolicitacaoSuprimentoCategoria (idSolicitacaoSuprimentoCategoria)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSupItemSubCategoria ADD CONSTRAINT solicitacaosuprimentosubcategoria_solicitacaosupitemsubcateg122
FOREIGN KEY (idSolicitacaoSuprimentoSubCategoria)
REFERENCES SolicitacaoSuprimentoSubCategoria (idSolicitacaoSuprimentoSubCategoria)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimento ADD CONSTRAINT solicitacaosuprimentosubcategoria_solicitacaosuprimento_fk
FOREIGN KEY (idSolicitacaoSuprimentoSubCategoria)
REFERENCES SolicitacaoSuprimentoSubCategoria (idSolicitacaoSuprimentoSubCategoria)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimento ADD CONSTRAINT solicitacaosuprimentoetapa_solicitacaosuprimento_fk
FOREIGN KEY (idSolicitacaoSuprimentoEtapa)
REFERENCES SolicitacaoSuprimentoEtapa (idSolicitacaoSuprimentoEtapa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoLogs ADD CONSTRAINT solicitacaosuprimentoetapa_solicitacaosuprimentologs_fk
FOREIGN KEY (idSolicitacaoSuprimentoEtapa)
REFERENCES SolicitacaoSuprimentoEtapa (idSolicitacaoSuprimentoEtapa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoEtapaFuncao ADD CONSTRAINT solicitacaosuprimentoetapa_solicitacaosuprimentoetapafuncao_fk
FOREIGN KEY (idSolicitacaoSuprimentoEtapa)
REFERENCES SolicitacaoSuprimentoEtapa (idSolicitacaoSuprimentoEtapa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoEtapaCfg ADD CONSTRAINT solicitacaosuprimentoetapa_solicitacaosuprimentoetapasla_fk
FOREIGN KEY (idSolicitacaoSuprimentoEtapa)
REFERENCES SolicitacaoSuprimentoEtapa (idSolicitacaoSuprimentoEtapa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItProduto ADD CONSTRAINT itmarca_itproduto_fk
FOREIGN KEY (idItMarcaErp)
REFERENCES ItMarca (idItMarcaErp)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RefTurno ADD CONSTRAINT refcadastro_refturno_fk
FOREIGN KEY (idRefCadastro)
REFERENCES RefCadastro (idRefCadastro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RefMovimento ADD CONSTRAINT refcadastro_refmovimento_fk
FOREIGN KEY (idRefCadastro)
REFERENCES RefCadastro (idRefCadastro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RefAcesso ADD CONSTRAINT refcadastro_refacesso_fk
FOREIGN KEY (idRefCadastro)
REFERENCES RefCadastro (idRefCadastro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RefTurnoExcecao ADD CONSTRAINT refturno_refexcecao_fk
FOREIGN KEY (idRefTurno)
REFERENCES RefTurno (idRefTurno)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RefMovimento ADD CONSTRAINT refturno_refmovimento_fk
FOREIGN KEY (idRefTurno)
REFERENCES RefTurno (idRefTurno)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PromocaoOfertaEmpresa ADD CONSTRAINT promocaooferta_promocaoofertaempresa_fk
FOREIGN KEY (idPromocaoOferta)
REFERENCES PromocaoOferta (idPromocaoOferta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PromocaoOfertaItens ADD CONSTRAINT promocaooferta_promocaoofertaitens_fk
FOREIGN KEY (idPromocaoOferta)
REFERENCES PromocaoOferta (idPromocaoOferta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasReceber ADD CONSTRAINT bandeiraadministradora_contasreceber_fk
FOREIGN KEY (idBandeiraAdministradora)
REFERENCES BandeiraAdministradora (idBandeiraAdministradora)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasReceber ADD CONSTRAINT administradora_contasreceber_fk
FOREIGN KEY (idAdministradora)
REFERENCES Administradora (idAdministradora)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MetaDinamicaLancamento ADD CONSTRAINT metadinamica_metadinamicalancamento_fk
FOREIGN KEY (idMetaDinamica)
REFERENCES MetaDinamica (idMetaDinamica)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EntidadeTipoMetaDinamica ADD CONSTRAINT metadinamica_entidadetipometadinamica_fk
FOREIGN KEY (idMetaDinamica)
REFERENCES MetaDinamica (idMetaDinamica)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE itTabelaPrecoItProduto ADD CONSTRAINT ittabelapreco_ittabelaprecoitproduto_fk
FOREIGN KEY (idItTabelaPrecoErp)
REFERENCES itTabelaPreco (idItTabelaPrecoErp)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItTabelaPrecoIntegracao ADD CONSTRAINT ittabelapreco_ittabelaprecointegracao_fk
FOREIGN KEY (idItTabelaPrecoErp)
REFERENCES itTabelaPreco (idItTabelaPrecoErp)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RecursoPermissao ADD CONSTRAINT recursotipo_recursopermissao_fk
FOREIGN KEY (idRecursoTipo)
REFERENCES RecursoTipo (idRecursoTipo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItProdutoIntegracao ADD CONSTRAINT integracaoterceiro_itprodutointegracao_fk
FOREIGN KEY (idIntegracaoTerceiro)
REFERENCES IntegracaoTerceiro (idIntegracaoTerceiro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE itPedidoVenda ADD CONSTRAINT integracaoterceiro_itpedidovenda_fk
FOREIGN KEY (idIntegracaoTerceiro)
REFERENCES IntegracaoTerceiro (idIntegracaoTerceiro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItPessoaIntegracao ADD CONSTRAINT integracaoterceiro_itpessoaintegracao_fk
FOREIGN KEY (idIntegracaoTerceiro)
REFERENCES IntegracaoTerceiro (idIntegracaoTerceiro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItEmpresa ADD CONSTRAINT integracaoterceiro_itempresa_fk
FOREIGN KEY (idIntegracaoTerceiro)
REFERENCES IntegracaoTerceiro (idIntegracaoTerceiro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItFormaPagamento ADD CONSTRAINT integracaoterceiro_itformapagamento_fk
FOREIGN KEY (idIntegracaoTerceiro)
REFERENCES IntegracaoTerceiro (idIntegracaoTerceiro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItCobranca ADD CONSTRAINT integracaoterceiro_itcobranca_fk
FOREIGN KEY (idIntegracaoTerceiro)
REFERENCES IntegracaoTerceiro (idIntegracaoTerceiro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItTabelaPrecoIntegracao ADD CONSTRAINT integracaoterceiro_ittabelaprecointegracao_fk
FOREIGN KEY (idIntegracaoTerceiro)
REFERENCES IntegracaoTerceiro (idIntegracaoTerceiro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItMercadologicoIntegracao ADD CONSTRAINT integracaoterceiro_itmercadologicointegracao_fk
FOREIGN KEY (idIntegracaoTerceiro)
REFERENCES IntegracaoTerceiro (idIntegracaoTerceiro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItProdutoMidiaIntegracao ADD CONSTRAINT integracaoterceiro_itprodutomidiaintegracao_fk
FOREIGN KEY (idIntegracaoTerceiro)
REFERENCES IntegracaoTerceiro (idIntegracaoTerceiro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FluxoGrupo ADD CONSTRAINT fluxogrupotipo_fluxogrupo_fk
FOREIGN KEY (idFluxoGrupoTipo)
REFERENCES FluxoGrupoTipo (idFluxoGrupoTipo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AgendaAtendimentoFornecedor ADD CONSTRAINT agendaatendimentofornecedorpre_agendaatendimentofornecedor_fk
FOREIGN KEY (idAgendaAtendimentoFornecedorPre)
REFERENCES AgendaAtendimentoFornecedorPre (idAgendaAtendimentoFornecedorPre)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DemonstrativoConfig ADD CONSTRAINT demonstrativo_demonstrativoconfig_fk
FOREIGN KEY (idDemonstrativo)
REFERENCES Demonstrativo (idDemonstrativo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DemonstrativoConfig ADD CONSTRAINT demonstrativoconfig_demonstrativoconfig_fk
FOREIGN KEY (idDemonstrativoConfigPai)
REFERENCES DemonstrativoConfig (idDemonstrativoConfig)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DemonstrativoConfigPlanoContas ADD CONSTRAINT demonstrativoconfig_demonstrativoconfigplanocontas_fk
FOREIGN KEY (idDemonstrativoConfig)
REFERENCES DemonstrativoConfig (idDemonstrativoConfig)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DemonstrativoResumo ADD CONSTRAINT demonstrativoconfig_demonstrativoresumo_fk
FOREIGN KEY (idDemonstrativoConfig)
REFERENCES DemonstrativoConfig (idDemonstrativoConfig)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Demonstrativo ADD CONSTRAINT demonstrativoconfig_demonstrativo_fk
FOREIGN KEY (idDemonstrativoConfigCabecalho)
REFERENCES DemonstrativoConfig (idDemonstrativoConfig)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFInputProcesso ADD CONSTRAINT wfinput_wfinputprocesso_fk
FOREIGN KEY (idWFInput)
REFERENCES WFInput (idWFInput)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFInputAtividade ADD CONSTRAINT wfinput_wfinputatividade_fk
FOREIGN KEY (idWFInput)
REFERENCES WFInput (idWFInput)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFColunaProcesso ADD CONSTRAINT wfcoluna_wfcolunaprocesso_fk
FOREIGN KEY (idWFColuna)
REFERENCES WFColuna (idWFColuna)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFColunaAtividade ADD CONSTRAINT wfcoluna_wfcolunaatividade_fk
FOREIGN KEY (idWFColuna)
REFERENCES WFColuna (idWFColuna)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EntidadeTipoCampo ADD CONSTRAINT entidadetipo_entidadetipocampo_fk
FOREIGN KEY (idEntidadeTipo)
REFERENCES EntidadeTipo (idEntidadeTipo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EntidadeRegistro ADD CONSTRAINT entidadetipo_entidaderegistro_fk
FOREIGN KEY (idEntidadeTipo)
REFERENCES EntidadeTipo (idEntidadeTipo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EntidadeTipoMetaDinamica ADD CONSTRAINT entidadetipo_entidadetipometadinamica_fk
FOREIGN KEY (idEntidadeTipo)
REFERENCES EntidadeTipo (idEntidadeTipo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EventoComercial ADD CONSTRAINT entidaderegistro_eventocomercial_tipo_fk
FOREIGN KEY (idEntidadeRegistroTipo)
REFERENCES EntidadeRegistro (idEntidadeRegistro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EventoComercial ADD CONSTRAINT entidaderegistro_eventocomercial_comunidade_fk
FOREIGN KEY (idEntidadeRegistroComunidade)
REFERENCES EntidadeRegistro (idEntidadeRegistro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EventoComercial ADD CONSTRAINT entidaderegistro_eventocomercial_meiodivuldacao_fk
FOREIGN KEY (idEntidadeRegistroMeioDivulgacao)
REFERENCES EntidadeRegistro (idEntidadeRegistro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EventoComercial ADD CONSTRAINT entidaderegistro_eventocomercial_centrocusto_fk
FOREIGN KEY (idEntidadeRegistroCentroCusto)
REFERENCES EntidadeRegistro (idEntidadeRegistro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EventoComercialMidia ADD CONSTRAINT entidaderegistro_eventocomercialmidia_fk
FOREIGN KEY (idEntidadeRegistroMidia)
REFERENCES EntidadeRegistro (idEntidadeRegistro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DesossaAcougue ADD CONSTRAINT entidaderegistrotipo_desossaacougue_fk
FOREIGN KEY (idEntidadeRegistroTipoDesossa)
REFERENCES EntidadeRegistro (idEntidadeRegistro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOfertaColaborador ADD CONSTRAINT entidaderegistroagrupamento_campanhaofertacolaborador_fk
FOREIGN KEY (idEntidadeRegistroAgrupamento)
REFERENCES EntidadeRegistro (idEntidadeRegistro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContaCorrentePessoa ADD CONSTRAINT entidaderegistro_tipocontacorrente_contacorrentepessoa_fk
FOREIGN KEY (idEntidadeRegistroTipoContaCorrente)
REFERENCES EntidadeRegistro (idEntidadeRegistro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContaCorrentePessoa ADD CONSTRAINT entidaderegistro_pessoa_contacorrentepessoa_fk
FOREIGN KEY (idEntidadeRegistroPessoa)
REFERENCES EntidadeRegistro (idEntidadeRegistro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ValePresente ADD CONSTRAINT entidaderegistro_tipo_valepresente_fk
FOREIGN KEY (idEntidadeRegistroTipo)
REFERENCES EntidadeRegistro (idEntidadeRegistro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ValePresenteMovimento ADD CONSTRAINT valepresente_valepresentemovimento_fk
FOREIGN KEY (idValePresente)
REFERENCES ValePresente (idValePresente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE JornadaTrabalhoPeriodo ADD CONSTRAINT jornadatrabalho_jornadatrabalhoperiodo_fk
FOREIGN KEY (idJornadaTrabalho)
REFERENCES JornadaTrabalho (idJornadaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Colaborador ADD CONSTRAINT jornadatrabalho_colaborador_fk
FOREIGN KEY (idJornadaTrabalho)
REFERENCES JornadaTrabalho (idJornadaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE UsoJornada ADD CONSTRAINT jornadatrabalho_usoperiodo_fk
FOREIGN KEY (idJornadaTrabalho)
REFERENCES JornadaTrabalho (idJornadaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE UsoJornadaDia ADD CONSTRAINT jornadatrabalho_usoperiododia_fk
FOREIGN KEY (idJornadaTrabalho)
REFERENCES JornadaTrabalho (idJornadaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Agenda ADD CONSTRAINT jornadatrabalho_agenda_fk
FOREIGN KEY (idJornadaTrabalho)
REFERENCES JornadaTrabalho (idJornadaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AgendaRegra ADD CONSTRAINT agenda_agendaregra_fk
FOREIGN KEY (idAgenda)
REFERENCES Agenda (idAgenda)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AgendaEntidade ADD CONSTRAINT agenda_agendaentidade_fk
FOREIGN KEY (idAgenda)
REFERENCES Agenda (idAgenda)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AgendaAgendamento ADD CONSTRAINT agendaentidade_agendaagendamento_fk
FOREIGN KEY (idAgendaEntidade)
REFERENCES AgendaEntidade (idAgendaEntidade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AgendaEntidadeNotificacao ADD CONSTRAINT agendaentidade_agendaagendamentonotificacao_fk
FOREIGN KEY (idAgendaEntidade)
REFERENCES AgendaEntidade (idAgendaEntidade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PulaFilaItens ADD CONSTRAINT pulafila_pulafilaitens_fk
FOREIGN KEY (idPulaFila)
REFERENCES PulaFila (idPulaFila)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Usuario ADD CONSTRAINT grupousuarios_usuario_fk
FOREIGN KEY (idGrupoUsuarios)
REFERENCES GrupoUsuarios (idGrupoUsuarios)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CargaEntregaOcorrencia ADD CONSTRAINT cargaentregamotivoretorno_cargaentregaretorno_fk
FOREIGN KEY (idCargaEntregaMotivoRetorno)
REFERENCES CargaEntregaMotivoRetorno (idCargaEntregaMotivoRetorno)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CargaEntregaOcorrenciaMidia ADD CONSTRAINT cargaentregaocorrencia_cargaentregaocorrenciamidia_fk
FOREIGN KEY (idCargaEntregaOcorrencia)
REFERENCES CargaEntregaOcorrencia (idCargaEntregaOcorrencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Produto ADD CONSTRAINT produtotipo_produto_fk
FOREIGN KEY (idProdutoTipo)
REFERENCES ProdutoTipo (idProdutoTipo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndicadorGestaoVisaoIndicadorGestao ADD CONSTRAINT indicadorgestaovisao_indicadorgestaovisaoindicadorgestao_fk
FOREIGN KEY (idIndicadorGestaoVisao)
REFERENCES IndicadorGestaoVisao (idIndicadorGestaoVisao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndicadorGestaoVisaoColaborador ADD CONSTRAINT indicadorgestaovisao_indicadorgestaovisaocolaborador_fk
FOREIGN KEY (idIndicadorGestaoVisao)
REFERENCES IndicadorGestaoVisao (idIndicadorGestaoVisao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndicadorGestao ADD CONSTRAINT indicadorgestaocategoria_indicadorgestao_fk
FOREIGN KEY (idIndicadorGestaoCategoria)
REFERENCES IndicadorGestaoCategoria (idIndicadorGestaoCategoria)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Tarefa ADD CONSTRAINT processo_tarefa_fk
FOREIGN KEY (idProcesso)
REFERENCES Processo (idProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Favorito ADD CONSTRAINT tarefa_favorito_fk
FOREIGN KEY (idTarefa)
REFERENCES Tarefa (idTarefa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Favorito ADD CONSTRAINT categoriafavorito_favoritos_fk
FOREIGN KEY (idCategoriaFavorito)
REFERENCES CategoriaFavorito (idCategoriaFavorito)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MetaEntidade ADD CONSTRAINT entidade_metaentidade_fk
FOREIGN KEY (idEntidade)
REFERENCES Entidade (idEntidade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AgendaDescargaFornecedor ADD CONSTRAINT localdescargafornecedor_agendadescargafornecedor_fk
FOREIGN KEY (localdescargafornecedor)
REFERENCES localdescargafornecedor (localdescargafornecedor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AgendaAtendimentoAutorizacao ADD CONSTRAINT tipoautorizacaoagendaatendimento_agendaatendimentoautorizaca57
FOREIGN KEY (tipoAutorizacao)
REFERENCES tipoAutorizacaoAgendaAtendimento (tipoAutorizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AgendaAtendimentoAutorizacao ADD CONSTRAINT agendaatendimentofornecedor_agendaatendimentoautorizacao_fk
FOREIGN KEY (dataAgendamento, horaAgendamento, usuario)
REFERENCES AgendaAtendimentoFornecedor (dataAgendamento, horaAgendamento, usuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AgendaAtendimentoFornecedorChamado ADD CONSTRAINT agendaatendimentofornecedor_agendaatendimentofornecedorchama572
FOREIGN KEY (dataAgendamento, horaAgendamento, usuario)
REFERENCES AgendaAtendimentoFornecedor (dataAgendamento, horaAgendamento, usuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrencia ADD CONSTRAINT wfprioridade_wfocorrencia_fk
FOREIGN KEY (idWFPrioridade)
REFERENCES WFPrioridade (idWFPrioridade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFAtividadeRealizada ADD CONSTRAINT wfimpacto_wfatividaderealizada_fk
FOREIGN KEY (idWFImpacto)
REFERENCES WFImpacto (idWFImpacto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT wfimpacto_wffilatrabalho_fk
FOREIGN KEY (idWFImpacto)
REFERENCES WFImpacto (idWFImpacto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFAtividadeRealizada ADD CONSTRAINT wfcausa_wfatividaderealizada_fk
FOREIGN KEY (idWFCausa)
REFERENCES WFCausa (idWFCausa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFFilaTrabalhoCausa ADD CONSTRAINT wfcausa_wffilatrabalhocausa_fk
FOREIGN KEY (idWFCausa)
REFERENCES WFCausa (idWFCausa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasReceber ADD CONSTRAINT portador_contasreceber_fk
FOREIGN KEY (idPortador)
REFERENCES Portador (idPortador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasPagar ADD CONSTRAINT portador_contaspagar_fk
FOREIGN KEY (idPortador)
REFERENCES Portador (idPortador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastro ADD CONSTRAINT justificativaprecadastroproduto_produtoprecadastro_fk
FOREIGN KEY (idJustificativaPreCadastroProduto)
REFERENCES JustificativaPreCadastroProduto (idJustificativaPreCadastroProduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastroGrade ADD CONSTRAINT ncm_produtoprecadastrograde_fk
FOREIGN KEY (idNCM)
REFERENCES ncm (idNCM)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastroCaracteristica ADD CONSTRAINT caracteristicaproduto_produtoprecadastrocaracteristica_fk
FOREIGN KEY (idCaracteristicaProduto)
REFERENCES CaracteristicaPreCadastroProduto (idCaracteristicaPreCadastroProduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastro ADD CONSTRAINT formaabastecimentoproduto_produtoprecadastro_fk
FOREIGN KEY (idFormaAbastecimento)
REFERENCES FormaAbastecimentoProduto (idFormaAbastecimentoProduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastro ADD CONSTRAINT sensibilidadeconcorrenciaproduto_produtoprecadastro_fk
FOREIGN KEY (idSensibilidadeConcorrencia)
REFERENCES SensibilidadeConcorrenciaProduto (idSensibilidadeConcorrenciaProduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasReceber ADD CONSTRAINT formapagamento_contasreceber_fk
FOREIGN KEY (idFormaPagamento)
REFERENCES FormaPagamento (idFormaPagamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasPagar ADD CONSTRAINT formapagamento_contaspagar_fk
FOREIGN KEY (idFormaPagamento)
REFERENCES FormaPagamento (idFormaPagamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ValePresenteMovimentoFormaPagamento ADD CONSTRAINT formapagamento_valepresenteformapagamento_fk
FOREIGN KEY (idFormaPagamento)
REFERENCES FormaPagamento (idFormaPagamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Pessoa ADD CONSTRAINT ramoatividade_pessoa_fk
FOREIGN KEY (idRamoAtividade)
REFERENCES RamoAtividade (idRamoAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EnderecoRede ADD CONSTRAINT tipoequipamento_enderecorede_fk
FOREIGN KEY (idTipoEquipamento)
REFERENCES TipoEquipamento (idTipoEquipamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PesquisaPrecoConcorrente ADD CONSTRAINT concorrente_pesquisaprecoconcorrente_fk
FOREIGN KEY (idConcorrente)
REFERENCES Concorrente (idConcorrente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PesquisaPrecoRealizada ADD CONSTRAINT concorrente_pesquisaprecorealizada_fk
FOREIGN KEY (idConcorrente)
REFERENCES Concorrente (idConcorrente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoMovimento ADD CONSTRAINT materialalmoxarifadolocalestoque_materialalmoxarifadomovimen418
FOREIGN KEY (idMaterialAlmoxarifadoLocalEstoque)
REFERENCES MaterialAlmoxarifadoLocalEstoque (idMaterialAlmoxarifadoLocalEstoque)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoEstoque ADD CONSTRAINT materialalmoxarifadolocalestoque_materialalmoxarifadoestoque_fk
FOREIGN KEY (idMaterialAlmoxarifadoLocalEstoque)
REFERENCES MaterialAlmoxarifadoLocalEstoque (idMaterialAlmoxarifadoLocalEstoque)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoCompras ADD CONSTRAINT materialalmoxarifadolocalestoque_materialalmoxarifadocompras_fk
FOREIGN KEY (idMaterialAlmoxarifadoLocalEstoque)
REFERENCES MaterialAlmoxarifadoLocalEstoque (idMaterialAlmoxarifadoLocalEstoque)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifado ADD CONSTRAINT materialalmoxarifadocategoria_materialalmoxarifado_fk
FOREIGN KEY (idMaterialAlmoxarifadoCategoria)
REFERENCES MaterialAlmoxarifadoCategoria (idMaterialAlmoxarifadoCategoria)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE questionario ADD CONSTRAINT tipoquestionario_questionario_fk
FOREIGN KEY (idtipoquestionario)
REFERENCES tipoquestionario (idtipoquestionario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE empresaprojeto ADD CONSTRAINT projeto_empresaprojeto_fk
FOREIGN KEY (idprojeto)
REFERENCES projeto (idprojeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE questao ADD CONSTRAINT projeto_questao_fk
FOREIGN KEY (idprojeto)
REFERENCES projeto (idprojeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE questionario ADD CONSTRAINT projeto_questionario_fk
FOREIGN KEY (idprojeto)
REFERENCES projeto (idprojeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE topico ADD CONSTRAINT projeto_topico_fk
FOREIGN KEY (idprojeto)
REFERENCES projeto (idprojeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE topico ADD CONSTRAINT topico_topico_fk
FOREIGN KEY (idtopicopai)
REFERENCES topico (idtopico)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE topicoquestao ADD CONSTRAINT topico_topicoquestao_fk
FOREIGN KEY (idtopico)
REFERENCES topico (idtopico)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE alternativa ADD CONSTRAINT questao_alternativa_fk
FOREIGN KEY (idquestao)
REFERENCES questao (idquestao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE questionarioquestao ADD CONSTRAINT questao_questionarioquestao_fk
FOREIGN KEY (idquestao)
REFERENCES questao (idquestao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE respostaaplicacaoquestionario ADD CONSTRAINT questao_respostaaplicacaoquestionario_fk
FOREIGN KEY (idquestao)
REFERENCES questao (idquestao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE topicoquestao ADD CONSTRAINT questao_topicoquestao_fk
FOREIGN KEY (idquestao)
REFERENCES questao (idquestao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE alternativaselecionada ADD CONSTRAINT alternativa_respostaalternativa_fk
FOREIGN KEY (idalternativa)
REFERENCES alternativa (idalternativa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AlternativaIntegracaoNF ADD CONSTRAINT alternativa_alternativaintegracaonf_fk
FOREIGN KEY (idalternativa)
REFERENCES alternativa (idalternativa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPontoExposicao ADD CONSTRAINT pontoexposicao_produtoplanograma_fk
FOREIGN KEY (idPontoExposicao)
REFERENCES PontoExposicao (idPontoExposicao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PontoExposicaoMovimento ADD CONSTRAINT pontoexposicao_pontoexposicaomovimento_fk
FOREIGN KEY (idPontoExposicao)
REFERENCES PontoExposicao (idPontoExposicao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EmpresaEstrutura ADD CONSTRAINT areaempresa_empresaestrutura_fk
FOREIGN KEY (idAreaEmpresa)
REFERENCES AreaEmpresa (idAreaEmpresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AreaEmpresaMercadologico ADD CONSTRAINT areaempresa_areaempresamercadologico_fk
FOREIGN KEY (idAreaEmpresa)
REFERENCES AreaEmpresa (idAreaEmpresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE questionario ADD CONSTRAINT areaempresa_questionario_fk
FOREIGN KEY (idareaempresa)
REFERENCES AreaEmpresa (idAreaEmpresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFAtividadeRealizada ADD CONSTRAINT areaempresa_wfatividaderealizada_fk
FOREIGN KEY (idAreaEmpresa)
REFERENCES AreaEmpresa (idAreaEmpresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT areaempresa_wffilatrabalho_fk
FOREIGN KEY (idAreaEmpresa)
REFERENCES AreaEmpresa (idAreaEmpresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Malote ADD CONSTRAINT areaempresaorigem_malote_fk
FOREIGN KEY (idAreaEmpresaOrigem)
REFERENCES AreaEmpresa (idAreaEmpresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Malote ADD CONSTRAINT areaempresadestino_malote_fk
FOREIGN KEY (idAreaEmpresaDestino)
REFERENCES AreaEmpresa (idAreaEmpresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColaboradorAreaEmpresa ADD CONSTRAINT areaempresa_colaboradorareaempresa_fk
FOREIGN KEY (idAreaEmpresa)
REFERENCES AreaEmpresa (idAreaEmpresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoMovimento ADD CONSTRAINT areaempresa_materialalmoxarifadomovimento_fk
FOREIGN KEY (idAreaEmpresa)
REFERENCES AreaEmpresa (idAreaEmpresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE aplicacaoquestionario ADD CONSTRAINT questionario_aplicacaoquestionario_fk
FOREIGN KEY (idquestionarioaplicado)
REFERENCES questionario (idquestionario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE questionariofuncaocolaborador ADD CONSTRAINT questionario_questionariofuncaocolaborador_fk
FOREIGN KEY (idquestionario)
REFERENCES questionario (idquestionario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE questionarioquestao ADD CONSTRAINT questionario_questionarioquestao_fk
FOREIGN KEY (idquestionario)
REFERENCES questionario (idquestionario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Veiculo ADD CONSTRAINT veiculotipo_veiculo_fk
FOREIGN KEY (idVeiculoTipo)
REFERENCES VeiculoTipo (idVeiculoTipo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CargaEntrega ADD CONSTRAINT veiculo_cargaentrega_fk
FOREIGN KEY (idVeiculoEntrega)
REFERENCES Veiculo (idVeiculo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MovimentoVeiculo ADD CONSTRAINT veiculo_movimentoveiculo_fk
FOREIGN KEY (idVeiculo)
REFERENCES Veiculo (idVeiculo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CotacaoFornecedorItem ADD CONSTRAINT cotacaofornecedor_cotacaofornecedoritem_fk
FOREIGN KEY (idCotacaoFornecedor)
REFERENCES CotacaoFornecedor (idCotacaoFornecedor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CotacaoFornecedorMarcado ADD CONSTRAINT cotacaofornecedor_cotacaofornecedormarcado_fk
FOREIGN KEY (idCotacaoFornecedor)
REFERENCES CotacaoFornecedor (idCotacaoFornecedor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CotacaoFornecedorValor ADD CONSTRAINT cotacaofornecedor_cotacaofornecedorvalor_fk
FOREIGN KEY (idCotacaoFornecedor)
REFERENCES CotacaoFornecedor (idCotacaoFornecedor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Empresa ADD CONSTRAINT empresaregional_empresa_fk
FOREIGN KEY (idEmpresaRegional)
REFERENCES EmpresaRegional (idEmpresaRegional)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE QuebraMovimento ADD CONSTRAINT quebradestino_quebramovimento_fk
FOREIGN KEY (idQuebraDestino)
REFERENCES QuebraDestino (idQuebraDestino)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE QuebraMovimento ADD CONSTRAINT quebramotivo_quebramovimento_fk
FOREIGN KEY (idQuebraMotivo)
REFERENCES QuebraMotivo (idQuebraMotivo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndicadorGestaoMovimento ADD CONSTRAINT indicadorgestao_indicadorgestaomovimento_fk
FOREIGN KEY (idIndicadorGestao)
REFERENCES IndicadorGestao (idIndicadorGestao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndicadorGestaoVisaoIndicadorGestao ADD CONSTRAINT indicadorgestao_indicadorgestaovisaoindicadorgestao_fk
FOREIGN KEY (idIndicadorGestao)
REFERENCES IndicadorGestao (idIndicadorGestao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndicadorGestaoReferencia ADD CONSTRAINT indicadorgestao_indicadorgestaoreferencia_fk
FOREIGN KEY (idIndicadorGestao)
REFERENCES IndicadorGestao (idIndicadorGestao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndicadorGestaoAuxiliar ADD CONSTRAINT indicadorgestao_indicadorgestaoauxiliar_fk
FOREIGN KEY (idIndicadorGestao)
REFERENCES IndicadorGestao (idIndicadorGestao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndicadorGestaoNotificacaoReferencia ADD CONSTRAINT indicadorgestao_indicadorgestaonotificacaoreferencia_fk
FOREIGN KEY (idIndicadorGestao)
REFERENCES IndicadorGestao (idIndicadorGestao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndicadorGestaoNotificacaoReferenciaDestinatario ADD CONSTRAINT indicadorgestaonotificacaoreferencia_indicadorgestaonotifica804
FOREIGN KEY (idIndicadorGestaoNotificacaoReferencia)
REFERENCES IndicadorGestaoNotificacaoReferencia (idIndicadorGestaoNotificacaoReferencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoRankItem ADD CONSTRAINT produtotop_produtotopitens_fk
FOREIGN KEY (idProdutoRank)
REFERENCES ProdutoRank (idProdutoRank)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaIndicador ADD CONSTRAINT indicadoravaliacao_pessoaindicador_fk
FOREIGN KEY (IndicadorAvaliacao)
REFERENCES IndicadorAvaliacao (idIndicadorAvaliacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PlanoContas ADD CONSTRAINT fluxogrupo_planocontas_fk
FOREIGN KEY (idFluxoGrupo)
REFERENCES FluxoGrupo (idFluxoGrupo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndiceCotacao ADD CONSTRAINT indice_indicecotacao_fk
FOREIGN KEY (idIndice)
REFERENCES Indice (idIndice)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FluxoCaixaPrevisao ADD CONSTRAINT indice_fluxocaixaprevisao_fk
FOREIGN KEY (idIndice)
REFERENCES Indice (idIndice)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FluxoCaixaPrevisao ADD CONSTRAINT indice_fluxocaixaprevisao_fk2
FOREIGN KEY (idIndice2)
REFERENCES Indice (idIndice)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FluxoCaixaMovimentoResumo ADD CONSTRAINT indice_fluxocaixamovimentoresumo_fk
FOREIGN KEY (idIndice)
REFERENCES Indice (idIndice)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasPagar ADD CONSTRAINT indice_contaspagar_fk
FOREIGN KEY (idIndice)
REFERENCES Indice (idIndice)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasReceber ADD CONSTRAINT indice_contasreceber_fk
FOREIGN KEY (idIndice)
REFERENCES Indice (idIndice)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE OrcamentoMovimentoResumo ADD CONSTRAINT indice_orcamentomovimentoresumo_fk
FOREIGN KEY (idIndice)
REFERENCES Indice (idIndice)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DataEquivalente ADD CONSTRAINT data_dataequivalente_fk
FOREIGN KEY (ddmmaaaa)
REFERENCES Data (ddmmaaaa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Produto ADD CONSTRAINT produtofinalidade_produto_fk
FOREIGN KEY (idProdutoFinalidade)
REFERENCES ProdutoFinalidade (idProdutoFinalidade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MercadologicoInfo ADD CONSTRAINT produtofinalidade_mercadologicoinfo_fk
FOREIGN KEY (idProdutoFinalidade)
REFERENCES ProdutoFinalidade (idProdutoFinalidade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Uf ADD CONSTRAINT pais_uf_fk
FOREIGN KEY (idPais)
REFERENCES Pais (idPais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Municipio ADD CONSTRAINT uf_municipio_fk
FOREIGN KEY (idUf)
REFERENCES Uf (idUf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Pessoa ADD CONSTRAINT municipio_pessoa_fk
FOREIGN KEY (idMunicipio)
REFERENCES Municipio (idMunicipio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EventoComercial ADD CONSTRAINT municipio_eventocomercial_fk
FOREIGN KEY (idMunicipio)
REFERENCES Municipio (idMunicipio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ClimaTempo ADD CONSTRAINT municipio_climatempo_fk
FOREIGN KEY (idMunicipio)
REFERENCES Municipio (idMunicipio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MunicipioDePara ADD CONSTRAINT municipio_municipiodepara_fk
FOREIGN KEY (idMunicipio)
REFERENCES Municipio (idMunicipio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Empresa ADD CONSTRAINT municipio_empresa_fk
FOREIGN KEY (idMunicipio)
REFERENCES Municipio (idMunicipio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Evento ADD CONSTRAINT municipio_evento_fk
FOREIGN KEY (idMunicipio)
REFERENCES Municipio (idMunicipio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EventoMidia ADD CONSTRAINT evento_eventomidia_fk
FOREIGN KEY (idEvento)
REFERENCES Evento (idEvento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PedidoCompra ADD CONSTRAINT idusuarioerp_pedidocompra_fk
FOREIGN KEY (idUsuario)
REFERENCES UsuarioErp (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Entrada ADD CONSTRAINT idusuarioerp_entrada_fk
FOREIGN KEY (idUsuario)
REFERENCES UsuarioErp (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Saida ADD CONSTRAINT idusuarioerp_saida_fk
FOREIGN KEY (idUsuario)
REFERENCES UsuarioErp (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CancelamentoCupom ADD CONSTRAINT usuarioerp_operador_cancelamentocupom_fk
FOREIGN KEY (idUsuarioOperadorErp)
REFERENCES UsuarioErp (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CancelamentoCupom ADD CONSTRAINT usuarioerp_liberador_cancelamentocupom_fk
FOREIGN KEY (idUsuarioLiberadorErp)
REFERENCES UsuarioErp (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Entrada ADD CONSTRAINT tipooperacao_compra_fk
FOREIGN KEY (idTipoOperacao)
REFERENCES TipoOperacao (idTipoOperacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Saida ADD CONSTRAINT tipooperacao_venda_fk
FOREIGN KEY (idTipoOperacao)
REFERENCES TipoOperacao (idTipoOperacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SaidaItens ADD CONSTRAINT tipooperacao_saidaitens_fk
FOREIGN KEY (idTipoOperacao)
REFERENCES TipoOperacao (idTipoOperacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EntradaItens ADD CONSTRAINT tipooperacao_entradaitens_fk
FOREIGN KEY (idTipoOperacao)
REFERENCES TipoOperacao (idTipoOperacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MovimentoResumo ADD CONSTRAINT tipooperacao_movimentoresumo_fk
FOREIGN KEY (idTipoOperacao)
REFERENCES TipoOperacao (idTipoOperacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE QuebraMovimento ADD CONSTRAINT tipooperacao_quebramovimento_fk
FOREIGN KEY (idTipoOperacao)
REFERENCES TipoOperacao (idTipoOperacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Produto ADD CONSTRAINT marca_produto_fk
FOREIGN KEY (idmarca)
REFERENCES Marca (idmarca)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FornecedorMarca ADD CONSTRAINT marca_fonecedormarca_fk
FOREIGN KEY (idmarca)
REFERENCES Marca (idmarca)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FornecedorProdutoCadastro ADD CONSTRAINT marca_fornecedorprodutocadastro_fk
FOREIGN KEY (idmarca)
REFERENCES Marca (idmarca)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Pessoa ADD CONSTRAINT grupoeconomico_fornecedor_fk
FOREIGN KEY (idgrupoeconomico)
REFERENCES GrupoEconomico (idgrupoeconomico)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Produto ADD CONSTRAINT subfamilia_produto_fk
FOREIGN KEY (idsubfamilia)
REFERENCES SubFamilia (idsubfamilia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Produto ADD CONSTRAINT familia_produto_fk
FOREIGN KEY (idfamilia)
REFERENCES Familia (idfamilia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FornecedorProdutoCadastro ADD CONSTRAINT familia_fornecedorprodutocadastro_fk
FOREIGN KEY (idfamilia)
REFERENCES Familia (idfamilia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifado ADD CONSTRAINT familia_materialalmoxarifado_fk
FOREIGN KEY (idfamilia)
REFERENCES Familia (idfamilia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Produto ADD CONSTRAINT grupo_produto_fk
FOREIGN KEY (idgrupo)
REFERENCES Grupo (idgrupo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FornecedorProdutoCadastro ADD CONSTRAINT grupo_fornecedorprodutocadastro_fk
FOREIGN KEY (idgrupo)
REFERENCES Grupo (idgrupo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifado ADD CONSTRAINT grupo_materialalmoxarifado_fk
FOREIGN KEY (idgrupo)
REFERENCES Grupo (idgrupo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Produto ADD CONSTRAINT setor_produto_fk
FOREIGN KEY (idsetor)
REFERENCES Setor (idsetor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FornecedorProdutoCadastro ADD CONSTRAINT setor_fornecedorprodutocadastro_fk
FOREIGN KEY (idsetor)
REFERENCES Setor (idsetor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifado ADD CONSTRAINT setor_materialalmoxarifado_fk
FOREIGN KEY (idsetor)
REFERENCES Setor (idsetor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Produto ADD CONSTRAINT departamento_produto_fk
FOREIGN KEY (iddepartamento)
REFERENCES Departamento (iddepartamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FornecedorProdutoCadastro ADD CONSTRAINT departamento_fornecedorprodutocadastro_fk
FOREIGN KEY (iddepartamento)
REFERENCES Departamento (iddepartamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FornecedorProdutoCadEmb ADD CONSTRAINT fornecedorprodutocadastro_fornecedorprodutocademb_fk
FOREIGN KEY (idFornecedorProdutoCad)
REFERENCES FornecedorProdutoCadastro (idFornecedorProdutoCad)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Saida ADD CONSTRAINT empresa_venda_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Entrada ADD CONSTRAINT empresa_compra_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EstoqueDia ADD CONSTRAINT empresa_estoque_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Empresa ADD CONSTRAINT empresa_empresa_fk
FOREIGN KEY (idempresagrupo)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PedidoCompra ADD CONSTRAINT empresa_pedidocompra_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Produto ADD CONSTRAINT empresa_produto_fk
FOREIGN KEY (idempresacadastro)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPrecoCusto ADD CONSTRAINT empresa_produtoprecocusto_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EmpresaEstrutura ADD CONSTRAINT empresa_empresaestrutura_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MetaPlanoContasValor ADD CONSTRAINT empresa_metaplanocontasvalor_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE VendaMeta ADD CONSTRAINT empresa_vendameta_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PlanoContas ADD CONSTRAINT empresa_planocontas_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoMargem ADD CONSTRAINT empresa_produtomargem_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EstoqueSaldoAtual ADD CONSTRAINT empresa_estoquesaldoatual_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PrecoVendaHistorico ADD CONSTRAINT empresa_precovendahistorico_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EntradaItens ADD CONSTRAINT empresa_entradaitens_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SaidaItens ADD CONSTRAINT empresa_saidaitens_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoResumo ADD CONSTRAINT empresa_produtoresumo_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Pessoa ADD CONSTRAINT empresa_pessoa_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoGiro ADD CONSTRAINT empresa_produtogiro_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Colaborador ADD CONSTRAINT empresa_colaborador_fk
FOREIGN KEY (idEmpresaCadastro)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Colaborador ADD CONSTRAINT empresa_colaborador_trabalho_fk
FOREIGN KEY (idEmpresaTrabalho)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoMonitorado ADD CONSTRAINT empresa_produtomonitorado_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EstoqueLocal ADD CONSTRAINT empresa_estoquelocal_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioEstoque ADD CONSTRAINT empresa_inventarioestoque_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoEmpresa ADD CONSTRAINT empresa_produtoempresa_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FluxoCaixa ADD CONSTRAINT empresa_fluxocaixa_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrencia ADD CONSTRAINT empresa_wfocorrencia_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT empresa_wffilatrabalho_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColaboradorFuncao ADD CONSTRAINT empresa_colaboradorfuncao_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Feriado ADD CONSTRAINT empresa_feriado_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOferta ADD CONSTRAINT empresa_campanhaoferta_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RecepcaoMercadorias ADD CONSTRAINT empresa_recepcaomercadorias_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FluxoCaixaSaldo ADD CONSTRAINT empresa_fluxocaixasaldo_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndicadorGestaoMovimento ADD CONSTRAINT empresa_indicadorgestaomovimento_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoEstoque ADD CONSTRAINT empresa_produtoestoque_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ValidacaoRecorrenciaFinanceira ADD CONSTRAINT empresa_validacaorecorrenciafinanceira_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FornecedorMonitorado ADD CONSTRAINT empresa_fornecedormonitorado_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MovimentoResumo ADD CONSTRAINT empresa_movimentoresumo_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CargaEntrega ADD CONSTRAINT empresa_cargaentrega_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE QuebraMovimento ADD CONSTRAINT empresa_quebramovimento_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPontoExposicao ADD CONSTRAINT empresa_produtoplanograma_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE aplicacaoquestionario ADD CONSTRAINT empresa_aplicacaoquestionario_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE empresaprojeto ADD CONSTRAINT empresa_empresaprojeto_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PontoExposicaoMovimento ADD CONSTRAINT empresa_pontoexposicaomovimento_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoCustoHistorico ADD CONSTRAINT empresa_produtocustohistorico_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoMovimento ADD CONSTRAINT empresa_materialalmoxarifadomovimento_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoEstoque ADD CONSTRAINT empresa_materialalmoxarifadoestoque_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EmpresaConexao ADD CONSTRAINT empresa_empresaip_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FluxoCaixaMovimentoResumo ADD CONSTRAINT empresa_fluxocaixamovimentoresumo_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasReceber ADD CONSTRAINT empresa_contasreceber_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasPagar ADD CONSTRAINT empresa_contaspagar_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EnderecoRede ADD CONSTRAINT empresa_enderecorede_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastroEmpresa ADD CONSTRAINT empresa_produtoprecadastroempresa_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DesossaAcougue ADD CONSTRAINT empresa_desossaacougue_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE OBPrevisaoFluxo ADD CONSTRAINT empresa_obprevisaofluxo_fk
FOREIGN KEY (idEmpresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoCompras ADD CONSTRAINT empresa_materialalmoxarifadocompras_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaContrato ADD CONSTRAINT empresa_pessoanegociacao_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MetaResultado ADD CONSTRAINT empresameta_metaresultado_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFLigaProdutoFornecedor ADD CONSTRAINT empresa_wfligaprodutofornecedor_fk
FOREIGN KEY (idEmpresaSolicitante)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE B2BPessoaFornecedor ADD CONSTRAINT empresa_pessoafornecedoredi_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CancelamentoCupom ADD CONSTRAINT empresa_cancelamentocupom_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EntradaItemVcto ADD CONSTRAINT empresa_entradaitemvcto_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE OrcamentoMovimentoResumo ADD CONSTRAINT empresa_orcamentomovimentoresumo_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Malote ADD CONSTRAINT empresaorigem_malote_fk
FOREIGN KEY (idEmpresaOrigem)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Malote ADD CONSTRAINT empresadestino_malote_fk
FOREIGN KEY (idEmpresaDestino)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoMovimento ADD CONSTRAINT empresa_materialalmoxarifadomovimento_baixa_estoque_fk
FOREIGN KEY (idEmpresaBaixaEstoque)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MidiaShowTelaSenhaAtendimento ADD CONSTRAINT empresa_midiashowtelasenhaatendimento_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColaboradorAreaEmpresa ADD CONSTRAINT empresa_colaboradorareaempresa_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE VendaPDV ADD CONSTRAINT empresa_vendapdv_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE VendaPDVItens ADD CONSTRAINT empresa_vendapdvitens_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sped_importacao ADD CONSTRAINT empresa_sped_importacao_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContabilMovimento ADD CONSTRAINT empresa_contabilmovimento_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AgendaDescargaFornecedor ADD CONSTRAINT empresa_agendadescargafornecedor_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoAntecipacaoRecebiveis ADD CONSTRAINT empresa_solicitacaoantecipacaorecebiveis_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PlanoContasSaldo ADD CONSTRAINT empresa_planocontassaldo_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EventoComercial ADD CONSTRAINT empresa_eventocomercial_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DemonstrativoResumo ADD CONSTRAINT empresaplanocontas_demonstrativoresumo_fk
FOREIGN KEY (idEmpresaPlanoContas)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EstoqueInformacaoEmpresa ADD CONSTRAINT empresa_estoqueinformacaoempresa_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MetaResultadoEcommerce ADD CONSTRAINT empresa_metaresultado_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DemonstrativoConfigPlanoContas ADD CONSTRAINT empresa_demonstrativoconfigplanocontas_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DemonstrativoResumo ADD CONSTRAINT empresa_demonstrativoresumo_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItProduto ADD CONSTRAINT empresa_itproduto_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE itPedidoVenda ADD CONSTRAINT empresa_itpedidovenda_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItPessoa ADD CONSTRAINT empresa_itpessoa_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItEmpresa ADD CONSTRAINT empresa_itempresa_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItFormaPagamento ADD CONSTRAINT empresa_itformapagamento_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RessupParamMercadologico ADD CONSTRAINT empresa_ressupparammercadologico_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RessupDiasReposicao ADD CONSTRAINT empresa_ressupdiasreposicao_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItMercadologico ADD CONSTRAINT empresa_itmercadologico_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RessupPedidoCompra ADD CONSTRAINT empresa_ressuppedidocompra_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RecursoPermissao ADD CONSTRAINT empresa_recursopermissao_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Amostragem ADD CONSTRAINT empresa_amostragem_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ArquivoGed ADD CONSTRAINT empresa_arquivoged_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ArquivoGedTipoDoc ADD CONSTRAINT empresa_arquivogedtipodoc_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RefMovimento ADD CONSTRAINT empresa_refmovimento_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOfertaEmpresa ADD CONSTRAINT empresa_campanhaofertaempresa_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItCobranca ADD CONSTRAINT empresa_itcobranca_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PromocaoOfertaEmpresa ADD CONSTRAINT empresa_promocaoofertaempresa_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RefAcesso ADD CONSTRAINT empresa_refacesso_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ValePresenteMovimento ADD CONSTRAINT empresa_utilizacao_valepresentemovimento_fk
FOREIGN KEY (idEmpresaUtilizacao)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ValePresenteMovimento ADD CONSTRAINT empresa_valepresentemovimento_fk
FOREIGN KEY (idEmpresaAtivacao)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItTabelaPrecoIntegracao ADD CONSTRAINT empresa_ittabelaprecointegracao_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioAgendaItens ADD CONSTRAINT empresa_inventarioagendaitens_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimento ADD CONSTRAINT empresa_solicitacaosuprimento_fk
FOREIGN KEY (idEmpresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MovimentoVeiculo ADD CONSTRAINT empresa_movimentoveiculo_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColetaProduto ADD CONSTRAINT empresa_coletaproduto_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE acessorapidoauxiliar ADD CONSTRAINT empresa_acessorapidoauxiliar_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoEtapaCfg ADD CONSTRAINT empresa_solicitacaosuprimentoetapacfg_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SenhaFilaAtendimento ADD CONSTRAINT empresa_senhafilaatendimento_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoEndereco ADD CONSTRAINT empresa_produtoendereco_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaCanais ADD CONSTRAINT empresa_campanhacanais_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SaidaItens ADD CONSTRAINT empresa_saidaitens_baixaestoque_fk
FOREIGN KEY (idEmpresaBaixaEstoque)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE LogImportacao ADD CONSTRAINT empresa_idlogimportacao_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE LogReenvio ADD CONSTRAINT empresa_logreenvio_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MetaAporte ADD CONSTRAINT empresa_metaaporte_fk
FOREIGN KEY (idempresa)
REFERENCES Empresa (idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE LogReenvio ADD CONSTRAINT logimportacao_logreenvio_fk
FOREIGN KEY (idLogImportacao)
REFERENCES LogImportacao (idLogImportacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ValePresenteMovimentoFormaPagamento ADD CONSTRAINT valepresentemovimento_valepresenteformapagamento_fk
FOREIGN KEY (idValePresenteMovimento)
REFERENCES ValePresenteMovimento (idValePresenteMovimento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ArquivoGedMidia ADD CONSTRAINT arquivogedtipodoc_arquivogedmidia_fk
FOREIGN KEY (idArquivoGedTipoDoc)
REFERENCES ArquivoGedTipoDoc (idArquivoGedTipoDoc)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ArquivoGedMidia ADD CONSTRAINT arquivoged_arquivogedmidia_fk
FOREIGN KEY (idArquivoGed)
REFERENCES ArquivoGed (idArquivoGed)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItProdutoMercadologico ADD CONSTRAINT itmercadologico_itprodutomercadologico_fk
FOREIGN KEY (idempresa, idItMercadologicoErp, nivelItMercadologico)
REFERENCES ItMercadologico (idempresa, idItMercadologicoErp, nivelMercadologico)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItMercadologicoIntegracao ADD CONSTRAINT itmercadologico_itmercadologicointegracao_fk
FOREIGN KEY (idempresa, idItMercadologicoErp, nivelMercadologico)
REFERENCES ItMercadologico (idempresa, idItMercadologicoErp, nivelMercadologico)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItPedidoVendaFormaPagamento ADD CONSTRAINT itformapagamento_itpedidovendaformapagamento_fk
FOREIGN KEY (idItFormaPagamento)
REFERENCES ItFormaPagamento (idItFormaPagamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE itPedidoVenda ADD CONSTRAINT itpessoa_itpedidovenda_fk
FOREIGN KEY (idItPessoa)
REFERENCES ItPessoa (idItPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItPessoaIntegracao ADD CONSTRAINT itpessoa_itpessoaintegracao_fk
FOREIGN KEY (idItPessoa)
REFERENCES ItPessoa (idItPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItCobranca ADD CONSTRAINT itpessoa_itcobranca_fk
FOREIGN KEY (idItPessoa)
REFERENCES ItPessoa (idItPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE itPedidoVendaItens ADD CONSTRAINT itpedidovenda_itpedidovendaitens_fk
FOREIGN KEY (idItPedidoVenda)
REFERENCES itPedidoVenda (idItPedidoVenda)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItPedidoVendaFormaPagamento ADD CONSTRAINT itpedidovenda_itpedidovendaformapagamento_fk
FOREIGN KEY (idItPedidoVenda)
REFERENCES itPedidoVenda (idItPedidoVenda)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItProdutoMidia ADD CONSTRAINT itproduto_itprodutomidia_fk
FOREIGN KEY (idempresa, idItProdutoErp)
REFERENCES ItProduto (idempresa, idItProdutoErp)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItProdutoIntegracao ADD CONSTRAINT itproduto_itprodutointegracao_fk
FOREIGN KEY (idempresa, idItProdutoErp)
REFERENCES ItProduto (idempresa, idItProdutoErp)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItProdutoMercadologico ADD CONSTRAINT itproduto_itprodutomercadologico_fk
FOREIGN KEY (idempresa, idItProdutoErp)
REFERENCES ItProduto (idempresa, idItProdutoErp)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE itTabelaPrecoItProduto ADD CONSTRAINT itproduto_ittabelaprecoitproduto_fk
FOREIGN KEY (idempresa, idItProdutoErp)
REFERENCES ItProduto (idempresa, idItProdutoErp)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE itPedidoVendaItens ADD CONSTRAINT itprodutointegracao_itpedidovendaitens_fk
FOREIGN KEY (idItProdutoIntegracao)
REFERENCES ItProdutoIntegracao (idItProdutoIntegracao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItPedidoVendaItensGrade ADD CONSTRAINT itprodutointegracao_itpedidovendaitensgrade_fk
FOREIGN KEY (idItProdutoIntegracao)
REFERENCES ItProdutoIntegracao (idItProdutoIntegracao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItPedidoVendaItensConferencia ADD CONSTRAINT itpedidovendaitens_itpedidovendaitensconferencia_fk
FOREIGN KEY (idItPedidoVendaItens)
REFERENCES itPedidoVendaItens (idItPedidoVendaItens)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItPedidoVendaItensGrade ADD CONSTRAINT itpedidovendaitens_itpedidovendaitensgrade_fk
FOREIGN KEY (idItPedidoVendaItens)
REFERENCES itPedidoVendaItens (idItPedidoVendaItens)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ItProdutoMidiaIntegracao ADD CONSTRAINT itprodutomidia_itprodutomidiaintegracao_fk
FOREIGN KEY (idItProdutoMidia)
REFERENCES ItProdutoMidia (idItProdutoMidia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE VendaPDVItens ADD CONSTRAINT vendapdv_vendapdvitens_fk
FOREIGN KEY (idVendaPDV)
REFERENCES VendaPDV (idVendaPDV)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaloteMovimento ADD CONSTRAINT malote_malotemovimento_fk
FOREIGN KEY (idMalote)
REFERENCES Malote (idMalote)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndicadorGestaoMovimentoDoc ADD CONSTRAINT indicadorgestaomovimento_indicadorgestaomovimentodoc_fk
FOREIGN KEY (idIndicadorGestaoMovimento)
REFERENCES IndicadorGestaoMovimento (idIndicadorGestaoMovimento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EstoqueDia ADD CONSTRAINT estoquelocal_estoque_fk
FOREIGN KEY (idLocalEstoque)
REFERENCES EstoqueLocal (idLocalEstoque)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EstoqueSaldoAtual ADD CONSTRAINT estoquelocal_estoquesaldoatual_fk
FOREIGN KEY (idLocalEstoque)
REFERENCES EstoqueLocal (idLocalEstoque)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioEstoqueItem ADD CONSTRAINT estoquelocal_inventarioestoqueitem_fk
FOREIGN KEY (idLocalEstoque)
REFERENCES EstoqueLocal (idLocalEstoque)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioEstoque ADD CONSTRAINT estoquelocal_inventarioestoque_fk
FOREIGN KEY (idLocalEstoque)
REFERENCES EstoqueLocal (idLocalEstoque)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoEstoque ADD CONSTRAINT estoquelocal_produtoestoque_fk
FOREIGN KEY (idLocalEstoque)
REFERENCES EstoqueLocal (idLocalEstoque)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE QuebraMovimento ADD CONSTRAINT estoquelocal_quebramovimento_fk
FOREIGN KEY (idLocalEstoque)
REFERENCES EstoqueLocal (idLocalEstoque)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioAgenda ADD CONSTRAINT estoquelocal_inventarioagenda_fk
FOREIGN KEY (idLocalEstoque)
REFERENCES EstoqueLocal (idLocalEstoque)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColetaProdutoItem ADD CONSTRAINT estoquelocal_coletaprodutoitem_fk
FOREIGN KEY (idLocalEstoque)
REFERENCES EstoqueLocal (idLocalEstoque)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioAgendaItens ADD CONSTRAINT inventarioagenda_inventarioagendaitens_fk
FOREIGN KEY (idInventarioAgenda)
REFERENCES InventarioAgenda (idInventarioAgenda)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioAgendaColetaProduto ADD CONSTRAINT inventarioagenda_inventarioagendacoletaproduto_fk
FOREIGN KEY (idInventarioAgenda)
REFERENCES InventarioAgenda (idInventarioAgenda)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FornecedorMarca ADD CONSTRAINT fornecedor_fonecedormarca_fk
FOREIGN KEY (idfornecedor)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaFornecedor ADD CONSTRAINT pessoa_pessoafornecedor_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PedidoCompra ADD CONSTRAINT pessoa_pedidocompra_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoFornecedor ADD CONSTRAINT pessoa_produtofornecedor_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Produto ADD CONSTRAINT pessoa_produto_fk
FOREIGN KEY (idPessoaFabricante)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Usuario ADD CONSTRAINT pessoa_usuario_fk
FOREIGN KEY (idPessoaFornecedor)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaIndicador ADD CONSTRAINT pessoa_fornecedorindicador_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RecepcaoMercadorias ADD CONSTRAINT pessoa_recepcaomercadorias_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ValidacaoRecorrenciaFinanceira ADD CONSTRAINT pessoa_validacaorecorrenciafinanceira_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FornecedorMonitorado ADD CONSTRAINT pessoa_fornecedormonitorado_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CotacaoFornecedorMarcado ADD CONSTRAINT pessoa_cotacaofornecedormarcado_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaContato ADD CONSTRAINT pessoa_pessoacontato_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CargaEntregaCliente ADD CONSTRAINT pessoa_cargaentregacliente_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE aplicacaoquestionario ADD CONSTRAINT pessoarespondente_aplicacaoquestionario_fk
FOREIGN KEY (idpessoarespondente)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasReceber ADD CONSTRAINT pessoa_contasreceber_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasPagar ADD CONSTRAINT pessoa_contaspagar_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaContrato ADD CONSTRAINT pessoa_pessoanegociacao_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoAntecipacaoRecebiveis ADD CONSTRAINT pessoa_solicitacaoantecipacaorecebiveis_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaContaBancaria ADD CONSTRAINT pessoa_pessoacontabancaria_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EventoComercial ADD CONSTRAINT pessoa_eventocomercial_fk
FOREIGN KEY (idPessoaCliente)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EventoComercialParceiro ADD CONSTRAINT pessoa_eventocomercialparceiro_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaRepresentanteMercadologico ADD CONSTRAINT pessoarepresentante_pessoarepresentantemercadologico_fk
FOREIGN KEY (idPessoaRepresentante)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaRepresentanteMercadologico ADD CONSTRAINT pessoa_pessoarepresentantemercadologico_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RessupPedidoCompra ADD CONSTRAINT pessoa_ressuppedidocompra_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RessupPedidoCompra ADD CONSTRAINT pessoarepresentante_ressuppedidocompra_fk
FOREIGN KEY (idPessoaRepresentante)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifado ADD CONSTRAINT pessoa_materialalmoxarifado_fk
FOREIGN KEY (idPessoaFabricante)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Amostragem ADD CONSTRAINT pessoa_amostragem_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOferta ADD CONSTRAINT pessoa_campanhaoferta_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOfertaItens ADD CONSTRAINT pessoa_campanhaofertaitens_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE UsuarioPessoa ADD CONSTRAINT pessoa_usuariopessoa_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaCliente ADD CONSTRAINT pessoa_pessoavendedor_fk
FOREIGN KEY (idPessoaVendedor)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaCliente ADD CONSTRAINT pessoa_pessoacliente_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoItensCotacao ADD CONSTRAINT pessoa_solicitacaosuprimentoitenscotacao_fk
FOREIGN KEY (idPessoaFornecedor)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioAgendaItens ADD CONSTRAINT pessoa_fornecedor_inventarioagendaitens_fk
FOREIGN KEY (idPessoaFornecedor)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioAgendaItens ADD CONSTRAINT pessoa_funcionario_inventarioagendaitens_fk
FOREIGN KEY (idPessoaFuncionario)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrenciaPessoa ADD CONSTRAINT pessoa_wfocorrenciapessoa_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaPerfil ADD CONSTRAINT pessoa_pessoaperfil_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PessoaInstituicaoFinanceira ADD CONSTRAINT pessoa_pessoainstituicaofinanceira_fk
FOREIGN KEY (idPessoa)
REFERENCES Pessoa (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MovimentoPessoaInstituicaoFinanceira ADD CONSTRAINT pessoainstituicaofinanceira_movimentopessoainstituicaofinanc673
FOREIGN KEY (idPessoaInstituicaoFinanceira)
REFERENCES PessoaInstituicaoFinanceira (idPessoaInstituicaoFinanceira)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOfertaItens ADD CONSTRAINT campanhaoferta_campanhaofertaitens_fk
FOREIGN KEY (idCampanhaOferta)
REFERENCES CampanhaOferta (idCampanhaOferta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOfertaMidia ADD CONSTRAINT campanhaoferta_campanhaofertamidia_fk
FOREIGN KEY (idCampanhaOferta)
REFERENCES CampanhaOferta (idCampanhaOferta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOfertaPontuacao ADD CONSTRAINT campanhaoferta_campanhaofertapontuacao_fk
FOREIGN KEY (idCampanhaOferta)
REFERENCES CampanhaOferta (idCampanhaOferta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOfertaColaborador ADD CONSTRAINT campanhaoferta_campanhaofertacolaborador_fk
FOREIGN KEY (idCampanhaOferta)
REFERENCES CampanhaOferta (idCampanhaOferta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOfertaEmpresa ADD CONSTRAINT campanhaoferta_campanhaofertaempresa_fk
FOREIGN KEY (idCampanhaOferta)
REFERENCES CampanhaOferta (idCampanhaOferta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaCanais ADD CONSTRAINT campanhaoferta_campanhacanais_fk
FOREIGN KEY (idCampanhaOferta)
REFERENCES CampanhaOferta (idCampanhaOferta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoAntecipacaoRecebiveis ADD CONSTRAINT pessoacontabancaria_solicitacaoantecipacaorecebiveis_fk
FOREIGN KEY (idPessoaContaBancaria)
REFERENCES PessoaContaBancaria (idPessoaContaBancaria)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasMovimentoFinanceiro ADD CONSTRAINT contaspagar_contasmovimentofinanceiro_fk
FOREIGN KEY (idContasPagar)
REFERENCES ContasPagar (idContasPagar)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasMovimentoFinanceiro ADD CONSTRAINT contasreceber_contasmovimentofinanceiro_fk
FOREIGN KEY (idContasReceber)
REFERENCES ContasReceber (idContasReceber)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasReceberCobranca ADD CONSTRAINT contasreceber_contasrecebercobranca_fk
FOREIGN KEY (idContasReceber)
REFERENCES ContasReceber (idContasReceber)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasReceber ADD CONSTRAINT contasreceberultimacobranca_contasreceber_fk
FOREIGN KEY (idContasReceberUltimaCobranca)
REFERENCES ContasReceberCobranca (idContasReceberCobranca)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasReceberCobrancaMidia ADD CONSTRAINT contasrecebercobranca_contasrecebercobrancamidia_fk
FOREIGN KEY (idContasReceberCobranca)
REFERENCES ContasReceberCobranca (idContasReceberCobranca)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioEstoque ADD CONSTRAINT usuario_inventarioestoque_fk
FOREIGN KEY (idUsuarioCadastro)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Meta ADD CONSTRAINT usuario_meta_cadastro_fk
FOREIGN KEY (idUsuarioCadastro)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Meta ADD CONSTRAINT usuario_meta_ateracao_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioEstoque ADD CONSTRAINT usuario_inventarioestoque_alteracao_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MetaMercadologico ADD CONSTRAINT usuario_metamercadologico_fk
FOREIGN KEY (idUsuarioCadastro)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoMonitorado ADD CONSTRAINT usuario_produtomonitorado_fk
FOREIGN KEY (idUsuarioCadastro)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioEstoqueItem ADD CONSTRAINT usuario_inventarioestoqueitem_cadastro_fk
FOREIGN KEY (idUsuarioCadastro)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioEstoqueItem ADD CONSTRAINT usuario_inventarioestoqueitem_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Colaborador ADD CONSTRAINT usuario_colaborador_cadastro_fk
FOREIGN KEY (idUsuarioCadastro)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FuncaoColaborador ADD CONSTRAINT usuario_funcaocolaborador_fk
FOREIGN KEY (idUsuarioCadastro)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FuncaoColaborador ADD CONSTRAINT usuario_funcaocolaborador_alteracao_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Colaborador ADD CONSTRAINT usuario_colaborador_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT usuario_wffilatrabalho_fk
FOREIGN KEY (idUsuarioResponsavel)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFProcessoEvento ADD CONSTRAINT usuario_wfprocessoevento_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrencia ADD CONSTRAINT usuario_wfocorrencia_fk
FOREIGN KEY (idUsuarioInclusao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFAtividade ADD CONSTRAINT usuario_wfatividade_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFProcesso ADD CONSTRAINT usuario_wfprocesso_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFAtividadeRealizada ADD CONSTRAINT usuario_wfatividaderealizada_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastro ADD CONSTRAINT usuario_produtoprecadastro_fk
FOREIGN KEY (idUsuarioInclusao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FornecedorMonitorado ADD CONSTRAINT usuario_fornecedormonitorado_fk
FOREIGN KEY (idUsuarioCadastro)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndicadorGestaoMovimentoDoc ADD CONSTRAINT usuario_indicadorgestaomovimentodoc_fk
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrenciaDetalhe ADD CONSTRAINT usuario_wffilatrabalhodetalhe_fk
FOREIGN KEY (idUsuarioInclusao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrenciaAnexo ADD CONSTRAINT usuario_wffilatrabalhoanexo_fk
FOREIGN KEY (idUsuarioInclusao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrencia ADD CONSTRAINT usuarioconfirmacao_wfocorrencia_fk
FOREIGN KEY (idUsuarioConfirmacao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFLigaProdutoFornecedor ADD CONSTRAINT usuario_wfligaprodutofornecedor_fk
FOREIGN KEY (idUsuarioInclusao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFLigaProdutoFornecedor ADD CONSTRAINT usuario_aprovacao_wfligaprodutofornecedor_fk
FOREIGN KEY (idUsuarioAprovacao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrencia ADD CONSTRAINT usuarioinativacao_wfocorrencia_fk
FOREIGN KEY (idUsuarioInativacao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaloteMovimento ADD CONSTRAINT usuario_malotemovimento_fk
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE noticia ADD CONSTRAINT usuario_noticia_fk
FOREIGN KEY (idUsuarioCadastro)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sped_importacao ADD CONSTRAINT usuario_sped_importacao_fk
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE UsuarioConfig ADD CONSTRAINT usuario_usuarioconfig_fk
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoAntecipacaoRecebiveis ADD CONSTRAINT usuario_solicitacaoantecipacaorecebiveis_fk
FOREIGN KEY (idUsuarioSituacao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ImpressaoPrecoLayout ADD CONSTRAINT usuario_impressaoprecolayout_fk
FOREIGN KEY (idUsuarioInclusao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndicadorGestaoAuxiliar ADD CONSTRAINT usuario_indicadorgestaoauxiliar_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EstoqueInformacaoEmpresa ADD CONSTRAINT usuario_estoqueinformacaoempresa_fk
FOREIGN KEY (idUsuarioInclusao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFFilaTrabalhoUsuarioVisualizacao ADD CONSTRAINT usuario_wffilatrabalhousuariovisualizacao_fk
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RessupPedidoCompra ADD CONSTRAINT usuario_ressuppedidocompra_fk
FOREIGN KEY (idUsuarioGravacao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RecursoPermissao ADD CONSTRAINT usuarioalteracao_recursopermissao_fk
FOREIGN KEY (idUsuarioAlteracao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Amostragem ADD CONSTRAINT usuario_amostragem_fk
FOREIGN KEY (idUsuarioInclusao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColetaProduto ADD CONSTRAINT usuario_coletaproduto_fk
FOREIGN KEY (idUsuarioColeta)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AgendaDescargaFornecedor ADD CONSTRAINT usuario_agendadescargafornecedor_fk
FOREIGN KEY (idUsuarioGravacao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RefMovimento ADD CONSTRAINT usuario_refmovimento_fk
FOREIGN KEY (idUsuarioInclusao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE UsuarioPessoa ADD CONSTRAINT usuario_usuariopessoa_fk
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AlternativaIntegracaoNF ADD CONSTRAINT usuario_alternativaintegracaonf_fk
FOREIGN KEY (idUsuarioResponsavel)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AgendaDescargaFornecedorMidia ADD CONSTRAINT agendadescargafornecedor_agendadescargafornecedormidia_fk
FOREIGN KEY (dataAgendamento, horaAgendamento, localdescargafornecedor, idempresa, idFornecedor)
REFERENCES AgendaDescargaFornecedor (dataAgendamento, horaAgendamento, localdescargafornecedor, idempresa, idFornecedor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AgendaDescargaFornecedorNotas ADD CONSTRAINT agendadescargafornecedor_agendadescargafornecedornotas_fk
FOREIGN KEY (dataAgendamento, horaAgendamento, localdescargafornecedor, idempresa, idFornecedor)
REFERENCES AgendaDescargaFornecedor (dataAgendamento, horaAgendamento, localdescargafornecedor, idempresa, idFornecedor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColetaProdutoItem ADD CONSTRAINT coletaproduto_coletaprodutoitem_fk
FOREIGN KEY (idColetaProduto)
REFERENCES ColetaProduto (idColetaProduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioAgendaColetaProduto ADD CONSTRAINT coletaproduto_inventarioagendacoletaproduto_fk
FOREIGN KEY (idColetaProduto)
REFERENCES ColetaProduto (idColetaProduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AmostragemItens ADD CONSTRAINT amostragem_amostragemitens_fk
FOREIGN KEY (idAmostragem)
REFERENCES Amostragem (idAmostragem)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RessupPedidoCompraItens ADD CONSTRAINT ressuppedidocompra_ressuppedidocompraitens_fk
FOREIGN KEY (idRessupPedidoCompra)
REFERENCES RessupPedidoCompra (idRessupPedidoCompra)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sped_inventario ADD CONSTRAINT sped_importacao_sped_inventario_fk
FOREIGN KEY (idSpedImportacao)
REFERENCES sped_importacao (idSpedImportacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sped_entradasaida ADD CONSTRAINT sped_importacao_sped_entradasaida_fk
FOREIGN KEY (idSpedImportacao)
REFERENCES sped_importacao (idSpedImportacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFProcessoEvento ADD CONSTRAINT processotrabalho_processotrabalhoevento_fk
FOREIGN KEY (idWFProcesso)
REFERENCES WFProcesso (idWFProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFAtividade ADD CONSTRAINT wfprocesso_wfatividade_fk
FOREIGN KEY (idWFProcesso)
REFERENCES WFProcesso (idWFProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFAtividadeRealizada ADD CONSTRAINT wfprocesso_wfatividaderealizada_fk
FOREIGN KEY (idWFProcesso)
REFERENCES WFProcesso (idWFProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFProcessoPermissao ADD CONSTRAINT wfprocesso_wfprocessopermissao_fk
FOREIGN KEY (idWFProcesso)
REFERENCES WFProcesso (idWFProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFColunaProcesso ADD CONSTRAINT wfprocesso_wfcolunaprocesso_fk
FOREIGN KEY (idWFProcesso)
REFERENCES WFProcesso (idWFProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFInputProcesso ADD CONSTRAINT wfprocesso_wfinputprocesso_fk
FOREIGN KEY (idWFProcesso)
REFERENCES WFProcesso (idWFProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AlternativaIntegracaoNF ADD CONSTRAINT wfprocesso_alternativaintegracaonf_fk
FOREIGN KEY (idWFProcesso)
REFERENCES WFProcesso (idWFProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT wfatividade_wffilatrabalho_fk
FOREIGN KEY (idWFAtividade)
REFERENCES WFAtividade (idWFAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFAtividadeRealizada ADD CONSTRAINT wfatividade_wfatividaderealizada_fk
FOREIGN KEY (idWFAtividade)
REFERENCES WFAtividade (idWFAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFAtividadeRealizada ADD CONSTRAINT wfatividade_wfatividaderealizada2_fk
FOREIGN KEY (idWFAtividadeProxima)
REFERENCES WFAtividade (idWFAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFAtividadeColaborador ADD CONSTRAINT wfatividade_wfatividadecolaborador_fk
FOREIGN KEY (idWFAtividade)
REFERENCES WFAtividade (idWFAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFProcessoEvento ADD CONSTRAINT wfatividadeinicial_wfprocessoevento_fk
FOREIGN KEY (idWFAtividadeInicial)
REFERENCES WFAtividade (idWFAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFInputAtividade ADD CONSTRAINT wfatividade_wfinputatividade_fk
FOREIGN KEY (idWFAtividade)
REFERENCES WFAtividade (idWFAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFColunaAtividade ADD CONSTRAINT wfatividade_wfcolunaatividade_fk
FOREIGN KEY (idWFAtividade)
REFERENCES WFAtividade (idWFAtividade)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT wfatividaderealizada_wffilatrabalho_fk
FOREIGN KEY (idWFAtividadeRealizada)
REFERENCES WFAtividadeRealizada (idWFAtividadeRealizada)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFProcessoEvento ADD CONSTRAINT wfatividaderealizadaexpiracao_wfprocessoevento_fk
FOREIGN KEY (idWFAtividadeRealizadaExpiracao)
REFERENCES WFAtividadeRealizada (idWFAtividadeRealizada)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFAtividade ADD CONSTRAINT wfatividaderealizadaexpiracao_wfatividade_fk
FOREIGN KEY (idWFAtividadeRealizadaExpiracao)
REFERENCES WFAtividadeRealizada (idWFAtividadeRealizada)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrencia ADD CONSTRAINT wfprocessoevento_wfocorrencia_fk
FOREIGN KEY (idWFProcessoEvento)
REFERENCES WFProcessoEvento (idWFProcessoEvento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AlternativaIntegracaoNF ADD CONSTRAINT wfprocessoevento_alternativaintegracaonf_fk
FOREIGN KEY (idWFProcessoEvento)
REFERENCES WFProcessoEvento (idWFProcessoEvento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrencia ADD CONSTRAINT wffilatrabalhofinalizacao_wfocorrencia_fk
FOREIGN KEY (idWFFilaTrabalhoFinalizacao)
REFERENCES WFFilaTrabalho (idWFFilaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT wffilatrabalho_wffilatrabalho_fk
FOREIGN KEY (idWFFilaTrabalhoAnterior)
REFERENCES WFFilaTrabalho (idWFFilaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFFilaTrabalhoComentario ADD CONSTRAINT wffilatrabalho_wffilatrabalhocomentario_fk
FOREIGN KEY (idWFFilaTrabalho)
REFERENCES WFFilaTrabalho (idWFFilaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFFilaTrabalhoCausa ADD CONSTRAINT wffilatrabalho_wffilatrabalhocausa_fk
FOREIGN KEY (idWFFilaTrabalho)
REFERENCES WFFilaTrabalho (idWFFilaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFFilaTrabalhoUsuarioVisualizacao ADD CONSTRAINT wffilatrabalho_wffilatrabalhousuariovisualizacao_fk
FOREIGN KEY (idWFFilaTrabalho)
REFERENCES WFFilaTrabalho (idWFFilaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFFilatrabalhoNotificacao ADD CONSTRAINT wffilatrabalho_wffilatrabalhonotificacao_fk
FOREIGN KEY (idWFFilaTrabalho)
REFERENCES WFFilaTrabalho (idWFFilaTrabalho)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFFilaTrabalho ADD CONSTRAINT wfocorrencia_wffilatrabalho_fk
FOREIGN KEY (idWFOcorrencia)
REFERENCES WFOcorrencia (idWFOcorrencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrenciaDetalhe ADD CONSTRAINT wfocorrencia_wffilatrabalhodetalhe_fk
FOREIGN KEY (idWFOcorrencia)
REFERENCES WFOcorrencia (idWFOcorrencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrenciaAnexo ADD CONSTRAINT wfocorrencia_wffilatrabalhoanexo_fk
FOREIGN KEY (idWFOcorrencia)
REFERENCES WFOcorrencia (idWFOcorrencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrenciaProduto ADD CONSTRAINT wfocorrencia_wfocorrenciaproduto_fk
FOREIGN KEY (idWFOcorrencia)
REFERENCES WFOcorrencia (idWFOcorrencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrenciaPessoa ADD CONSTRAINT wfocorrencia_wfocorrenciapessoa_fk
FOREIGN KEY (idWFOcorrencia)
REFERENCES WFOcorrencia (idWFOcorrencia)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColaboradorFuncao ADD CONSTRAINT funcaocolaborador_colaboradorfuncao_fk
FOREIGN KEY (idFuncao)
REFERENCES FuncaoColaborador (idFuncao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Colaborador ADD CONSTRAINT funcaocolaborador_colaborador_fk
FOREIGN KEY (idFuncaoPrincipal)
REFERENCES FuncaoColaborador (idFuncao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE questionariofuncaocolaborador ADD CONSTRAINT funcao_questionariofuncaocolaborador_fk
FOREIGN KEY (idfuncao)
REFERENCES FuncaoColaborador (idFuncao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoEtapaFuncao ADD CONSTRAINT funcaocolaborador_solicitacaosuprimentoetapafuncao_fk
FOREIGN KEY (idFuncao)
REFERENCES FuncaoColaborador (idFuncao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColaboradorFuncao ADD CONSTRAINT colaborador_colaboradorfuncao_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Usuario ADD CONSTRAINT colaborador_usuario_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CargaEntrega ADD CONSTRAINT colaborador_cargaentrega_fk
FOREIGN KEY (idColaboradorMotorista)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE aplicacaoquestionario ADD CONSTRAINT colaboradoraplicador_aplicacaoquestionario_fk
FOREIGN KEY (idcolaboradoravaliador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE aplicacaoquestionario ADD CONSTRAINT colaborador_quizzer_aplicacaoquestionario_fk
FOREIGN KEY (idcolaboradoraplicador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoMovimento ADD CONSTRAINT colaborador_almoxarifado_materialalmoxarifadomovimento_fk
FOREIGN KEY (idColaboradorAlmoxarifado)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoMovimento ADD CONSTRAINT colaborador_materialalmoxarifadomovimento_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastro ADD CONSTRAINT colaboradorcomprador_produtoprecadastro_fk
FOREIGN KEY (idColaboradorComprador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PesquisaPreco ADD CONSTRAINT colaborador_pesquisaprecoconcorrente_fk
FOREIGN KEY (idColaboradorColeta)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaloteMovimento ADD CONSTRAINT colaborador_malotemovimento_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MidiaShowTelaSenhaAtendimento ADD CONSTRAINT colaborador_midiashowtelasenhaatendimento_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColaboradorAreaEmpresa ADD CONSTRAINT colaborador_colaboradorareaempresa_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE IndicadorGestaoVisaoColaborador ADD CONSTRAINT colaborador_indicadorgestaovisaocolaborador_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColaboradorLog ADD CONSTRAINT colaborador_colaboradorlog_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PainelSenha ADD CONSTRAINT colaborador_painelsenha_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EventoComercial ADD CONSTRAINT colaborador_eventocomercial_fk
FOREIGN KEY (idColaboradorConsultor)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColaboradorHierarquia ADD CONSTRAINT colaborador_colaboradorhierarquia_colaboradorliderado_fk
FOREIGN KEY (idColaboradorLiderado)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColaboradorHierarquia ADD CONSTRAINT colaborador_colaboradorhierarquia_colaborador_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColaboradorHierarquiaHist ADD CONSTRAINT colaborador_colaboradorhierarquiahist_colaborador_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColaboradorHierarquiaHist ADD CONSTRAINT colaborador_colaboradorhierarquiahist_colaboradorliderado_fk
FOREIGN KEY (idColaboradorLiderado)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RefMovimento ADD CONSTRAINT colaborador_refmovimento_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOfertaColaborador ADD CONSTRAINT colaborador_campanhaofertacolaborador_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RefAcesso ADD CONSTRAINT colaborador_refacesso_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioAgendaItens ADD CONSTRAINT colaborador_inventarioagendaitens_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoRangeAprovacoes ADD CONSTRAINT colaborador_solicitacaosuprimentorangepermissoes_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MovimentoVeiculo ADD CONSTRAINT colaborador_motorista_movimentoveiculo_fk
FOREIGN KEY (idColaboradorMotorista)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MovimentoVeiculoAjudante ADD CONSTRAINT colaborador_movimentoveiculoajudante_fk
FOREIGN KEY (idColaboradorAjudante)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE acessorapidoauxiliar ADD CONSTRAINT colaborador_acessorapidoauxiliar_fk
FOREIGN KEY (idColaborador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SenhaFilaAtendimento ADD CONSTRAINT colaborador_senhafilaatendimento_fk
FOREIGN KEY (idColaboradorChamada)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PedidoCompra ADD CONSTRAINT colaborador_pedidocompra_fk
FOREIGN KEY (idColaboradorComprador)
REFERENCES Colaborador (idColaborador)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MovimentoVeiculoMaterial ADD CONSTRAINT movimentoveiculo_movimentoveiculomaterial_fk
FOREIGN KEY (idMovimentoVeiculo)
REFERENCES MovimentoVeiculo (idMovimentoVeiculo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MovimentoVeiculoCheck ADD CONSTRAINT movimentoveiculo_movimentoveiculocheck_fk
FOREIGN KEY (idMovimentoVeiculo)
REFERENCES MovimentoVeiculo (idMovimentoVeiculo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MovimentoVeiculoAjudante ADD CONSTRAINT movimentoveiculo_movimentoveiculoajudante_fk
FOREIGN KEY (idMovimentoVeiculo)
REFERENCES MovimentoVeiculo (idMovimentoVeiculo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RefTurnoExcecao ADD CONSTRAINT refacesso_refturnoexcecao_fk
FOREIGN KEY (idRefAcesso)
REFERENCES RefAcesso (idRefAcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EventoComercialParceiro ADD CONSTRAINT eventocomercial_eventocomercialparceiro_fk
FOREIGN KEY (idEventoComercial)
REFERENCES EventoComercial (idEventoComercial)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EventoComercialMidia ADD CONSTRAINT eventocomercial_eventocomercialmidia_fk
FOREIGN KEY (idEventoComercial)
REFERENCES EventoComercial (idEventoComercial)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EventoComercialHistoricoDivergencia ADD CONSTRAINT eventocomercial_eventocomercialhistoricodivergencia_fk
FOREIGN KEY (idEventoComercial)
REFERENCES EventoComercial (idEventoComercial)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PesquisaPrecoConcorrente ADD CONSTRAINT pesquisapreco_pesquisaprecoconcorrente_fk
FOREIGN KEY (idPesquisaPreco)
REFERENCES PesquisaPreco (idPesquisaPreco)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PesquisaPrecoRealizada ADD CONSTRAINT pesquisapreco_pesquisaprecorealizada_fk
FOREIGN KEY (idPesquisaPreco)
REFERENCES PesquisaPreco (idPesquisaPreco)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PesquisaPrecoProduto ADD CONSTRAINT pesquisapreco_pesquisaprecoproduto_fk
FOREIGN KEY (idPesquisaPreco)
REFERENCES PesquisaPreco (idPesquisaPreco)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastroEmb ADD CONSTRAINT produtoprecadastro_produtoprecadastroemb_fk
FOREIGN KEY (idProdutoPreCadastro)
REFERENCES ProdutoPreCadastro (idProdutoPreCadastro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastroGrade ADD CONSTRAINT produtoprecadastro_produtoprecadastrograde_fk
FOREIGN KEY (idProdutoPreCadastro)
REFERENCES ProdutoPreCadastro (idProdutoPreCadastro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastroCaracteristica ADD CONSTRAINT produtoprecadastro_produtoprecadastrocaracteristica_fk
FOREIGN KEY (idProdutoPreCadastro)
REFERENCES ProdutoPreCadastro (idProdutoPreCadastro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastroEmpresa ADD CONSTRAINT produtoprecadastro_produtoprecadastroempresa_fk
FOREIGN KEY (idProdutoPreCadastro)
REFERENCES ProdutoPreCadastro (idProdutoPreCadastro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastroMidia ADD CONSTRAINT produtoprecadastro_produtoprecadastromidia_fk
FOREIGN KEY (idProdutoPreCadastro)
REFERENCES ProdutoPreCadastro (idProdutoPreCadastro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastroTributo ADD CONSTRAINT produtoprecadastro_produtoprecadastrotributo_fk
FOREIGN KEY (idProdutoPreCadastro)
REFERENCES ProdutoPreCadastro (idProdutoPreCadastro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastroSimilar ADD CONSTRAINT produtoprecadastro_produtoprecadastrosimilar_fk
FOREIGN KEY (idProdutoPreCadastro)
REFERENCES ProdutoPreCadastro (idProdutoPreCadastro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastroValor ADD CONSTRAINT produtoprecadastroemb_produtoprecadastrovalor_fk
FOREIGN KEY (idProdutoPreCadastro, codigoBarrasEmbalagem)
REFERENCES ProdutoPreCadastroEmb (idProdutoPreCadastro, codigoBarrasEmbalagem)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE questionarioquestao ADD CONSTRAINT aplicacaoquestionario_questionarioquestao_fk
FOREIGN KEY (idaplicacaoquestionarioorigem)
REFERENCES aplicacaoquestionario (idaplicacaoquestionario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE respostaaplicacaoquestionario ADD CONSTRAINT aplicacaoquestionario_respostaaplicacaoquestionario_fk
FOREIGN KEY (idaplicacaoquestionario)
REFERENCES aplicacaoquestionario (idaplicacaoquestionario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE alternativaselecionada ADD CONSTRAINT respostaaplicacaoquestionario_respostaalternativa_fk
FOREIGN KEY (idaplicacaoquestionario, idquestao)
REFERENCES respostaaplicacaoquestionario (idaplicacaoquestionario, idquestao)
ON DELETE CASCADE
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE respostaaplicacaoquestionarioimagem ADD CONSTRAINT respostaaplicacaoquestionarioimagem_fk
FOREIGN KEY (idaplicacaoquestionario, idquestao)
REFERENCES respostaaplicacaoquestionario (idaplicacaoquestionario, idquestao)
ON DELETE CASCADE
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CargaEntregaCliente ADD CONSTRAINT cargaentrega_cargaentregacliente_fk
FOREIGN KEY (idCargaEntrega)
REFERENCES CargaEntrega (idCargaEntrega)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CargaEntregaClienteItem ADD CONSTRAINT cargaentregacliente_cargaentregaclienteitem_fk
FOREIGN KEY (idCargaEntrega, idSaidaOrigem)
REFERENCES CargaEntregaCliente (idCargaEntrega, idSaidaOrigem)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FuncaoMercadologico ADD CONSTRAINT colaboradorfuncao_funcaomercadologico_fk
FOREIGN KEY (idColaborador, idFuncao, idempresa)
REFERENCES ColaboradorFuncao (idColaborador, idFuncao, idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFAtividadeColaborador ADD CONSTRAINT colaboradorfuncao_wfatividadecolaborador_fk
FOREIGN KEY (idColaborador, idFuncao, idempresa)
REFERENCES ColaboradorFuncao (idColaborador, idFuncao, idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MetaMercadologico ADD CONSTRAINT meta_metalancamento_fk
FOREIGN KEY (idMeta)
REFERENCES Meta (idMeta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Meta ADD CONSTRAINT meta_meta_fk
FOREIGN KEY (idMetaCalculo)
REFERENCES Meta (idMeta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MetaResultado ADD CONSTRAINT meta_metaresultadometa_fk
FOREIGN KEY (idMeta)
REFERENCES Meta (idMeta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MetaEntidade ADD CONSTRAINT meta_metaentidade_fk
FOREIGN KEY (idMeta)
REFERENCES Meta (idMeta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MetaResultadoEcommerce ADD CONSTRAINT meta_metaresultado_fk
FOREIGN KEY (idMeta)
REFERENCES Meta (idMeta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MetaAporte ADD CONSTRAINT meta_metaaporte_fk
FOREIGN KEY (idMeta)
REFERENCES Meta (idMeta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioEstoqueItem ADD CONSTRAINT inventarioestoque_inventarioestoqueitem_fk
FOREIGN KEY (idInventario)
REFERENCES InventarioEstoque (idInventario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioEstoque ADD CONSTRAINT inventarioestoque_inventarioestoqueanterior_fk
FOREIGN KEY (idInventarioAnterior)
REFERENCES InventarioEstoque (idInventario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE B2BPessoaFornecedor ADD CONSTRAINT pessoafornecedor_pessoafornecedoredi_fk
FOREIGN KEY (idPessoa)
REFERENCES PessoaFornecedor (idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MetaPlanoContasValor ADD CONSTRAINT planocontas_metaplanocontasvalor_fk
FOREIGN KEY (idConta, tipoPlanoContas, idempresa)
REFERENCES PlanoContas (idConta, tipoPlanoContas, idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PlanoContasDePara ADD CONSTRAINT planocontas_planocontasdepara_fk
FOREIGN KEY (idConta, tipoPlanoContas, idempresa)
REFERENCES PlanoContas (idConta, tipoPlanoContas, idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PlanoContasSaldo ADD CONSTRAINT planocontas_planocontassaldo_fk
FOREIGN KEY (idEmpresaPlanoContas, idConta, tipoPlanoContas)
REFERENCES PlanoContas (idempresa, idConta, tipoPlanoContas)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FluxoCaixaPrevisao ADD CONSTRAINT planocontas_fluxocaixaprevisao_fk
FOREIGN KEY (idempresa, idConta, tipoPlanoContas)
REFERENCES PlanoContas (idempresa, idConta, tipoPlanoContas)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FluxoCaixaMovimentoResumo ADD CONSTRAINT planocontas_fluxocaixamovimentoresumo_fk
FOREIGN KEY (idEmpresaPlanoContas, idConta, tipoPlanoContas)
REFERENCES PlanoContas (idempresa, idConta, tipoPlanoContas)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContasMovimentoFinanceiro ADD CONSTRAINT planocontas_contasmovimentofinanceiro_fk
FOREIGN KEY (idempresa, idConta, tipoPlanoContas)
REFERENCES PlanoContas (idempresa, idConta, tipoPlanoContas)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE OrcamentoMovimentoResumo ADD CONSTRAINT planocontas_orcamentomovimentoresumo_fk
FOREIGN KEY (idEmpresaPlanoContas, idConta, tipoPlanoContas)
REFERENCES PlanoContas (idempresa, idConta, tipoPlanoContas)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ContabilMovimento ADD CONSTRAINT planocontas_contabilmovimento_fk
FOREIGN KEY (idEmpresaPlanoContas, idConta, tipoPlanoContas)
REFERENCES PlanoContas (idempresa, idConta, tipoPlanoContas)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PlanoContasDePara ADD CONSTRAINT planocontaspara_planocontasdepara_fk
FOREIGN KEY (idContaPara, tipoPlanoContasPara, idempresaPara)
REFERENCES PlanoContas (idConta, tipoPlanoContas, idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DemonstrativoConfigPlanoContas ADD CONSTRAINT planocontas_demonstrativoconfigplanocontas_fk
FOREIGN KEY (idEmpresaPlanoContas, idConta, tipoPlanoContas)
REFERENCES PlanoContas (idempresa, idConta, tipoPlanoContas)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoDepreciacao ADD CONSTRAINT planocontas_credito_materialalmoxarifadodepreciacao_fk
FOREIGN KEY (idempresaCredito, tipoPlanoContasCredito, idContaCredito)
REFERENCES PlanoContas (idempresa, tipoPlanoContas, idConta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoDepreciacao ADD CONSTRAINT planocontas_debito_materialalmoxarifadodepreciacao_fk
FOREIGN KEY (idempresaDebito, tipoPlanoContasDebito, idContaDebito)
REFERENCES PlanoContas (idempresa, tipoPlanoContas, idConta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimento ADD CONSTRAINT planocontas_solicitacaosuprimento_fk
FOREIGN KEY (idEmpresaPlanoContas, tipoPlanoContas, idConta)
REFERENCES PlanoContas (idempresa, tipoPlanoContas, idConta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ColaboradorFuncaoCentroResultado ADD CONSTRAINT planocontas_colaboradorfuncaocentroresultado_fk
FOREIGN KEY (idEmpresaPlanoContas, tipoPlanoContas, idConta)
REFERENCES PlanoContas (idempresa, tipoPlanoContas, idConta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimento ADD CONSTRAINT planocontas_gerencial_solicitacaosuprimento_fk
FOREIGN KEY (idEmpresaPlanoContasGerencial, tipoPlanoContasGerencial, idContaGerencial)
REFERENCES PlanoContas (idempresa, tipoPlanoContas, idConta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoItens ADD CONSTRAINT solicitacaosuprimento_solicitacaosuprimentoitens_fk
FOREIGN KEY (idSolicitacaoSuprimento)
REFERENCES SolicitacaoSuprimento (idSolicitacaoSuprimento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoLogs ADD CONSTRAINT solicitacaosuprimento_solicitacaosuprimentologs_fk
FOREIGN KEY (idSolicitacaoSuprimento)
REFERENCES SolicitacaoSuprimento (idSolicitacaoSuprimento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoMidia ADD CONSTRAINT solicitacaosuprimentoitens_solicitacaosuprimentomidia_fk
FOREIGN KEY (idSolicitacaoSuprimentoItens)
REFERENCES SolicitacaoSuprimentoItens (idSolicitacaoSuprimentoItens)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoItensCotacao ADD CONSTRAINT solicitacaosuprimentoitens_solicitacaosuprimentoitenscotacao_fk
FOREIGN KEY (idSolicitacaoSuprimentoItens)
REFERENCES SolicitacaoSuprimentoItens (idSolicitacaoSuprimentoItens)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoItensCotacaoMidia ADD CONSTRAINT solicitacaosuprimentoitenscotacao_solicitacaosuprimentoitens505
FOREIGN KEY (idSolicitacaoSuprimentoItensCotacao)
REFERENCES SolicitacaoSuprimentoItensCotacao (idSolicitacaoSuprimentoItensCotacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SolicitacaoSuprimentoItens ADD CONSTRAINT solicitacaosuprimentoitenscotacao_solicitacaosuprimentoitens_fk
FOREIGN KEY (idCotacaoEscolhaGestor)
REFERENCES SolicitacaoSuprimentoItensCotacao (idSolicitacaoSuprimentoItensCotacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DemonstrativoResumo ADD CONSTRAINT demonstrativoconfigplanocontas_demonstrativoresumo_fk
FOREIGN KEY (idDemonstrativoConfig, idConta, tipoPlanoContas, idEmpresaPlanoContas, idempresa)
REFERENCES DemonstrativoConfigPlanoContas (idDemonstrativoConfig, idConta, tipoPlanoContas, idEmpresaPlanoContas, idempresa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoEmbalagem ADD CONSTRAINT produto_produtoembalagem_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ClasseProduto ADD CONSTRAINT produto_bdoclasseproduto_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ClasseProdutoHist ADD CONSTRAINT produto_bdoclasseprodutohist_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EstoqueDia ADD CONSTRAINT produto_estoque_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPrecoCusto ADD CONSTRAINT produto_produtoprecocusto_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SaidaItens ADD CONSTRAINT produto_vendaitens_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EntradaItens ADD CONSTRAINT produto_entradaitens_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PedidoCompraItens ADD CONSTRAINT produto_pedidocompraitens_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE InventarioEstoqueItem ADD CONSTRAINT produto_inventarioestoqueitem_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoMargem ADD CONSTRAINT produto_produtomargem_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EstoqueSaldoAtual ADD CONSTRAINT produto_estoquesaldoatual_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PrecoVendaHistorico ADD CONSTRAINT produto_precovendahistorico_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoResumo ADD CONSTRAINT produto_produtoresumo_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoFornecedor ADD CONSTRAINT produto_produtofornecedor_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoGiro ADD CONSTRAINT produto_produtogiro_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoMonitorado ADD CONSTRAINT produto_produtomonitorado_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoEmpresa ADD CONSTRAINT produto_produtoempresa_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOfertaItens ADD CONSTRAINT produto_campanhaofertaitens_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoRankItem ADD CONSTRAINT produto_produtotopitens_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoEstoque ADD CONSTRAINT produto_produtoestoque_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MovimentoResumo ADD CONSTRAINT produto_movimentoresumo_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CotacaoFornecedorItem ADD CONSTRAINT produto_cotacaofornecedoritem_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoMercadologicoLoja ADD CONSTRAINT produto_produtomercadologicoloja_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPontoExposicao ADD CONSTRAINT produto_produtoplanograma_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PontoExposicaoMovimento ADD CONSTRAINT produto_pontoexposicaomovimento_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoCustoHistorico ADD CONSTRAINT produto_produtocustohistorico_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DesossaAcougue ADD CONSTRAINT produtoorigem_desossaacougue_fk
FOREIGN KEY (idprodutoOrigem)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DesossaAcougue ADD CONSTRAINT produtodestino_desossaacougue_fk
FOREIGN KEY (idprodutoDestino)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PesquisaPrecoProduto ADD CONSTRAINT produto_precoconcorrente_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PesquisaPrecoRealizada ADD CONSTRAINT produto_pesquisaprecorealizada_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CancelamentoCupom ADD CONSTRAINT produto_cancelamentocupom_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EntradaItemVcto ADD CONSTRAINT produto_entradaitemvcto_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE VendaPDVItens ADD CONSTRAINT produto_vendapdvitens_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CargaEntregaClienteItem ADD CONSTRAINT produto_cargaentregaclienteitem_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CargaEntregaOcorrenciaMidia ADD CONSTRAINT produto_cargaentregaocorrenciamidia_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EstoqueInformacaoEmpresa ADD CONSTRAINT produto_estoqueinformacaoempresa_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DesossaAcougue ADD CONSTRAINT produto_desossaacougue_fk
FOREIGN KEY (idProdutoDestinoVenda)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE RessupPedidoCompraItens ADD CONSTRAINT produto_ressuppedidocompraitens_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE AmostragemItens ADD CONSTRAINT produto_amostragemitens_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PromocaoOfertaItens ADD CONSTRAINT produto_promocaoofertaitens_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifado ADD CONSTRAINT produto_materialalmoxarifado_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE WFOcorrenciaProduto ADD CONSTRAINT produto_wfocorrenciaproduto_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoEndereco ADD CONSTRAINT produto_produtoendereco_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoDetalhe ADD CONSTRAINT produto_produtodetalhe_fk
FOREIGN KEY (idproduto)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ProdutoPreCadastroSimilar ADD CONSTRAINT produto_produtoprecadastrosimilar_fk
FOREIGN KEY (idprodutoSimilar)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Producao ADD CONSTRAINT produto_pai_producao_fk
FOREIGN KEY (idProdutoPai)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Producao ADD CONSTRAINT produto_filho_producao_fk
FOREIGN KEY (idProdutoFilho)
REFERENCES Produto (idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoMovimento ADD CONSTRAINT materialalmoxarifado_materialalmoxarifadomovimento_fk
FOREIGN KEY (idMaterialAlmoxarifado)
REFERENCES MaterialAlmoxarifado (idMaterialAlmoxarifado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoEstoque ADD CONSTRAINT materialalmoxarifado_materialalmoxarifadoestoque_fk
FOREIGN KEY (idMaterialAlmoxarifado)
REFERENCES MaterialAlmoxarifado (idMaterialAlmoxarifado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoCompras ADD CONSTRAINT materialalmoxarifado_materialalmoxarifadocompras_fk
FOREIGN KEY (idMaterialAlmoxarifado)
REFERENCES MaterialAlmoxarifado (idMaterialAlmoxarifado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoMidia ADD CONSTRAINT materialalmoxarifado_materialalmoxarifadomidia_fk
FOREIGN KEY (idMaterialAlmoxarifado)
REFERENCES MaterialAlmoxarifado (idMaterialAlmoxarifado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MaterialAlmoxarifadoDepreciacao ADD CONSTRAINT materialalmoxarifado_materialalmoxarifadodepreciacao_fk
FOREIGN KEY (idMaterialAlmoxarifado)
REFERENCES MaterialAlmoxarifado (idMaterialAlmoxarifado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MovimentoVeiculoMaterial ADD CONSTRAINT materialalmoxarifado_movimentoveiculomaterial_fk
FOREIGN KEY (idMaterialAlmoxarifado)
REFERENCES MaterialAlmoxarifado (idMaterialAlmoxarifado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE CampanhaOfertaItensPontuacao ADD CONSTRAINT campanhaofertaitens_campanhaofertaitenspontuacao_fk
FOREIGN KEY (idCampanhaOferta, idproduto)
REFERENCES CampanhaOfertaItens (idCampanhaOferta, idproduto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PedidoCompraItens ADD CONSTRAINT pedidocompra_pedidocompraitens_fk
FOREIGN KEY (idempresa, idpedido, idPessoa)
REFERENCES PedidoCompra (idempresa, idpedido, idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PedidoCompraVcto ADD CONSTRAINT pedidocompra_pedidocompravcto_fk
FOREIGN KEY (idempresa, idpedido, idPessoa)
REFERENCES PedidoCompra (idempresa, idpedido, idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PedidoCompraEdi ADD CONSTRAINT pedidocompra_pedidocompraedi_fk
FOREIGN KEY (idempresa, idpedido, idPessoa)
REFERENCES PedidoCompra (idempresa, idpedido, idPessoa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EntradaItens ADD CONSTRAINT entrada_entradaitens_fk
FOREIGN KEY (idEntrada)
REFERENCES Entrada (idEntrada)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE EntradaItemVcto ADD CONSTRAINT entrada_entradaitemvcto_fk
FOREIGN KEY (idEntrada)
REFERENCES Entrada (idEntrada)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE SaidaItens ADD CONSTRAINT venda_vendaitens_fk
FOREIGN KEY (idSaida)
REFERENCES Saida (idSaida)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE QuebraMovimento ADD CONSTRAINT saidaitens_quebramovimento_fk
FOREIGN KEY (idSaida, idproduto, tipopreco)
REFERENCES SaidaItens (idSaida, idproduto, tipopreco)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;