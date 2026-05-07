
CREATE TABLE ShortUrlMap (
                shortUrl VARCHAR(255) NOT NULL,
                fullUrl VARCHAR(4096) NOT NULL,
                versao INTEGER,
                CONSTRAINT shorturlmap_pk PRIMARY KEY (shortUrl)
);


CREATE TABLE BdoTable (
                idBdoTable INTEGER NOT NULL,
                name VARCHAR(255) NOT NULL,
                sqlBackup VARCHAR(4096),
                backupOrder INTEGER DEFAULT 0 NOT NULL,
                restoreOrder INTEGER DEFAULT 0 NOT NULL,
                hasSequence CHAR(1) DEFAULT 'T' NOT NULL,
                doBackup CHAR(1) DEFAULT 'T' NOT NULL,
                versions VARCHAR(1024) NOT NULL,
                CONSTRAINT bdotable_pk PRIMARY KEY (idBdoTable)
);
COMMENT ON COLUMN BdoTable.hasSequence IS 'T-True, F-False';
COMMENT ON COLUMN BdoTable.doBackup IS 'T-True, F-False';


CREATE TABLE BdoInfo (
                versao VARCHAR(32)
);


CREATE TABLE LoginEndereco (
                idLoginEndereco INTEGER NOT NULL,
                descLoginEndereco VARCHAR(256) NOT NULL,
                versao INTEGER,
                CONSTRAINT loginendereco_pk PRIMARY KEY (idLoginEndereco)
);


CREATE TABLE LoginEnderecoRegra (
                idLoginEnderecoRegra INTEGER NOT NULL,
                idLoginEndereco INTEGER NOT NULL,
                acao CHAR(1) NOT NULL,
                regra CHAR(1) NOT NULL,
                endereco VARCHAR(128),
                regrasAdicionais VARCHAR(32000),
                situacao INTEGER DEFAULT 0 NOT NULL,
                versao INTEGER,
                CONSTRAINT loginenderecoregra_pk PRIMARY KEY (idLoginEnderecoRegra)
);
COMMENT ON COLUMN LoginEnderecoRegra.acao IS 'P-Permitir, N-Negar';
COMMENT ON COLUMN LoginEnderecoRegra.regra IS 'E-Equals, S-StartsWith, C-Contains, R-Regex';
COMMENT ON COLUMN LoginEnderecoRegra.situacao IS '0-Ativo, 1-Inativo';


CREATE TABLE Token (
                token VARCHAR(128) NOT NULL,
                tipo CHAR(3) NOT NULL,
                remoteAddress VARCHAR(128),
                device VARCHAR(128),
                tipoApp INTEGER NOT NULL,
                chave VARCHAR(128),
                valores VARCHAR(32000),
                codigo VARCHAR(128),
                dataCriacao DATE NOT NULL,
                horaCriacao VARCHAR(8) NOT NULL,
                dataHoraCriacao TIMESTAMP NOT NULL,
                dataHoraExpiracao TIMESTAMP,
                dataAcesso DATE,
                horaAcesso VARCHAR(8),
                remoteAddressAcesso VARCHAR(128),
                deviceAcesso VARCHAR(128),
                situacaoAcesso VARCHAR(3) DEFAULT 'NA' NOT NULL,
                dataUtilizacao DATE,
                horaUtilizacao VARCHAR(8),
                remoteAddressUtilizacao VARCHAR(128),
                deviceUtilizacao VARCHAR(128),
                situacaoUtilizacao VARCHAR(3) DEFAULT 'NU' NOT NULL,
                versao INTEGER,
                CONSTRAINT token_pk PRIMARY KEY (token)
);
COMMENT ON COLUMN Token.tipo IS 'A2E-Autenticação em 2 etapas, RSE-Recuperação de senha';
COMMENT ON COLUMN Token.tipoApp IS '0-Client, 1-Web View, 2-Mobile App';
COMMENT ON COLUMN Token.situacaoAcesso IS 'NA-Não Acessado, A-Acessado, EXP-Expirado, UNE-Usuário Não Encontrado, UI-Usuário Inativo, UB-Usuário Bloqueado';
COMMENT ON COLUMN Token.situacaoUtilizacao IS 'NU-Não Utilizado, U-Utilizado, EXP-Expirado, UNE-Usuário Não Encontrado, UI-Usuário Inativo, UB-Usuário Bloqueado';


CREATE INDEX token_idx_datahoracriacao
 ON Token
 ( dataCriacao, horaCriacao );

CREATE INDEX token_idx_chave_codigo_criacao
 ON Token
 ( chave, codigo, dataCriacao, horaCriacao );

CREATE TABLE LoginCalendario (
                idLoginCalendario INTEGER NOT NULL,
                descLoginCalendario VARCHAR(256) NOT NULL,
                versao INTEGER,
                CONSTRAINT logincalendario_pk PRIMARY KEY (idLoginCalendario)
);


CREATE TABLE LoginPolitica (
                idLoginPolitica INTEGER NOT NULL,
                descLoginPolitica VARCHAR(256) NOT NULL,
                tempoSessao INTEGER DEFAULT 0 NOT NULL,
                diasExpiracaoSenha INTEGER DEFAULT 0,
                numTentativasAcesso INTEGER DEFAULT 0 NOT NULL,
                tempoNumTentativasAcesso INTEGER DEFAULT 0 NOT NULL,
                tempoBloqueioTentativasAcesso INTEGER DEFAULT 0 NOT NULL,
                tamanhoMinimoSenha INTEGER DEFAULT 4 NOT NULL,
                tamanhoMaximoSenha INTEGER DEFAULT 128 NOT NULL,
                requerMaiusculas INTEGER DEFAULT 0 NOT NULL,
                requerMinusculas INTEGER DEFAULT 0 NOT NULL,
                requerNumeros INTEGER DEFAULT 0 NOT NULL,
                requerCaracteresEspeciais INTEGER DEFAULT 0 NOT NULL,
                caracteresEspeciaisValidos VARCHAR(128),
                descCaracteresEspeciais VARCHAR(256),
                regrasAdicionais VARCHAR(32000),
                descRegrasAdicionais VARCHAR(1024),
                autenticacao2Etapas INTEGER DEFAULT 0 NOT NULL,
                idLoginCalendario INTEGER,
                versao INTEGER,
                CONSTRAINT loginpolitica_pk PRIMARY KEY (idLoginPolitica)
);
COMMENT ON COLUMN LoginPolitica.tempoSessao IS '0-Padrão, N-Tempo em Segundos';
COMMENT ON COLUMN LoginPolitica.diasExpiracaoSenha IS '0-Não Controla, N-Tempo em Dias';
COMMENT ON COLUMN LoginPolitica.numTentativasAcesso IS '0-Não Controla, N-Número de Tentativas para Bloqueio';
COMMENT ON COLUMN LoginPolitica.tempoNumTentativasAcesso IS '0-Não Controla, N-Tempo em segundos';
COMMENT ON COLUMN LoginPolitica.tempoBloqueioTentativasAcesso IS '-1-Bloquear usuário até Admin desbloquear, 0-Não Bloquear, N-Bloquear login por N segundos';
COMMENT ON COLUMN LoginPolitica.requerMaiusculas IS '0-Não, 1-Sim';
COMMENT ON COLUMN LoginPolitica.requerMinusculas IS '0-Não, 1-Sim';
COMMENT ON COLUMN LoginPolitica.requerNumeros IS '0-Não, 1-Sim';
COMMENT ON COLUMN LoginPolitica.requerCaracteresEspeciais IS '0-Não, 1-Sim';
COMMENT ON COLUMN LoginPolitica.autenticacao2Etapas IS '0-Não, 1-Sim';


CREATE TABLE LoginCalendarioDia (
                idLoginCalendarioDia INTEGER NOT NULL,
                idCalendarioLogin INTEGER NOT NULL,
                dia INTEGER NOT NULL,
                horaInicial VARCHAR(8) NOT NULL,
                horaFinal VARCHAR(8) NOT NULL,
                situacao INTEGER DEFAULT 0 NOT NULL,
                versao INTEGER,
                CONSTRAINT logincalendariodia_pk PRIMARY KEY (idLoginCalendarioDia)
);
COMMENT ON COLUMN LoginCalendarioDia.horaInicial IS 'HH:mm:ss';
COMMENT ON COLUMN LoginCalendarioDia.horaFinal IS 'HH:mm:ss';
COMMENT ON COLUMN LoginCalendarioDia.situacao IS '0-Ativo, 1-Inativo';


CREATE TABLE Dominio (
                idDominio INTEGER NOT NULL,
                descDominio VARCHAR(255) NOT NULL,
                apelidoTarefa VARCHAR(64) NOT NULL,
                tipo CHAR(1) DEFAULT 'N' NOT NULL,
                sql VARCHAR(16384),
                CONSTRAINT dominio_pk PRIMARY KEY (idDominio)
);
COMMENT ON COLUMN Dominio.tipo IS 'N-Normal, U-União';


CREATE TABLE DominioUniao (
                idDominioUniao INTEGER NOT NULL,
                idDominio INTEGER NOT NULL,
                idDominioUnido INTEGER NOT NULL,
                ordem INTEGER NOT NULL,
                tipo CHAR(1) DEFAULT 'N' NOT NULL,
                CONSTRAINT dominiouniao_pk PRIMARY KEY (idDominioUniao)
);
COMMENT ON COLUMN DominioUniao.tipo IS 'N-Normal, A-All';


CREATE TABLE DominioAgrupamento (
                idDominioAgrupamento INTEGER NOT NULL,
                idDominio INTEGER NOT NULL,
                coluna VARCHAR(255) NOT NULL,
                ordem INTEGER NOT NULL,
                CONSTRAINT dominioagrupamento_pk PRIMARY KEY (idDominioAgrupamento)
);


CREATE TABLE DominioOrdem (
                idDominioOrdem INTEGER NOT NULL,
                idDominio INTEGER NOT NULL,
                coluna VARCHAR(255) NOT NULL,
                tipo CHAR(1) DEFAULT 'A' NOT NULL,
                ordem INTEGER NOT NULL,
                CONSTRAINT dominioordem_pk PRIMARY KEY (idDominioOrdem)
);
COMMENT ON COLUMN DominioOrdem.tipo IS 'A-Ascendente, D-Descendente';


CREATE TABLE DominioFiltro (
                idDominioFiltro INTEGER NOT NULL,
                idDominio INTEGER NOT NULL,
                tipo CHAR(1) DEFAULT 'W' NOT NULL,
                elemento1 VARCHAR(255) NOT NULL,
                expressao VARCHAR(32) NOT NULL,
                elemento2 VARCHAR(255) NOT NULL,
                ordem INTEGER NOT NULL,
                CONSTRAINT dominiofiltro_pk PRIMARY KEY (idDominioFiltro)
);
COMMENT ON COLUMN DominioFiltro.tipo IS 'W-Where, H-Having';


CREATE TABLE DominioTabela (
                idDominioTabela INTEGER NOT NULL,
                idDominio INTEGER NOT NULL,
                tabela VARCHAR(64) NOT NULL,
                apelido VARCHAR(64) NOT NULL,
                tipo CHAR(1) DEFAULT 'N' NOT NULL,
                sql VARCHAR(16384),
                ordem INTEGER NOT NULL,
                CONSTRAINT dominiotabela_pk PRIMARY KEY (idDominioTabela)
);
COMMENT ON COLUMN DominioTabela.tipo IS 'N-Normal, D-Derivada';


CREATE TABLE DominioJuncao (
                idDominioJuncao INTEGER NOT NULL,
                idDominio INTEGER NOT NULL,
                idDominioTabela INTEGER NOT NULL,
                tipo CHAR(3) DEFAULT 'IJ' NOT NULL,
                ordem INTEGER NOT NULL,
                CONSTRAINT dominiojuncao_pk PRIMARY KEY (idDominioJuncao)
);
COMMENT ON COLUMN DominioJuncao.tipo IS 'IJ-Inner Join, LOJ-Left Outer Join, ROJ-Right Outer Join, FOJ-Full Outer Join';


CREATE TABLE DominioJuncaoExpressao (
                idDominioJuncaoExpressao INTEGER NOT NULL,
                idDominioJuncao INTEGER NOT NULL,
                elemento1 VARCHAR(255) NOT NULL,
                expressao VARCHAR(32) NOT NULL,
                elemento2 VARCHAR(255) NOT NULL,
                ordem INTEGER NOT NULL,
                CONSTRAINT dominiojuncaoexpressao_pk PRIMARY KEY (idDominioJuncaoExpressao)
);


CREATE TABLE DominioTabelaColuna (
                idDominioTabelaColuna INTEGER NOT NULL,
                idDominioTabela INTEGER NOT NULL,
                agregacao VARCHAR(32),
                DominioTabelaColuna VARCHAR(255) NOT NULL,
                apelido VARCHAR(32) NOT NULL,
                tipo CHAR(1) DEFAULT 'N' NOT NULL,
                sql VARCHAR(16384),
                ordem INTEGER NOT NULL,
                CONSTRAINT dominiotabelacoluna_pk PRIMARY KEY (idDominioTabelaColuna)
);
COMMENT ON COLUMN DominioTabelaColuna.tipo IS 'N-Normal, C-Calculada';


CREATE TABLE TipoDominio (
                idTipoDominio VARCHAR(128) NOT NULL,
                descricao VARCHAR(256) NOT NULL,
                CONSTRAINT tipodominio_pk PRIMARY KEY (idTipoDominio)
);


CREATE TABLE AssuntoFormaContato (
                idAssuntoFormaContato VARCHAR(128) NOT NULL,
                descricao VARCHAR(256) NOT NULL,
                CONSTRAINT assuntoformacontato_pk PRIMARY KEY (idAssuntoFormaContato)
);


CREATE TABLE DominioFormaContato (
                idTipoDominio VARCHAR(128) NOT NULL,
                idAssuntoFormaContato VARCHAR(128) NOT NULL,
                dominio VARCHAR(128) NOT NULL,
                tipo INTEGER NOT NULL,
                destino VARCHAR(4096),
                CONSTRAINT dominioformacontato_pk PRIMARY KEY (idTipoDominio, idAssuntoFormaContato, dominio, tipo)
);
COMMENT ON COLUMN DominioFormaContato.tipo IS '0-E-mail, 1-Mensageiro, 2-SMS, 3-Client, 4-MSN';


CREATE TABLE Painel (
                idPainel INTEGER NOT NULL,
                descPainel VARCHAR(256),
                apelido VARCHAR(64),
                classificacao VARCHAR(256),
                intervaloAtualizacao INTEGER,
                timeoutAtualizacao INTEGER DEFAULT -1 NOT NULL,
                tipoAcesso INTEGER DEFAULT 0,
                idUsuarioInc INTEGER,
                dataInc DATE,
                horaInc VARCHAR(6),
                frameX INTEGER,
                frameY INTEGER,
                frameWidth INTEGER,
                frameHeight INTEGER,
                backgroundColor INTEGER DEFAULT 1 NOT NULL,
                backgroundImage VARCHAR(256),
                backgroundImageDraw INTEGER DEFAULT 0 NOT NULL,
                iFrameTitleHeight INTEGER DEFAULT -1 NOT NULL,
                iFrameBorderTransparency INTEGER DEFAULT 0 NOT NULL,
                tipoAtualizacao INTEGER DEFAULT 0 NOT NULL,
                versao INTEGER,
                CONSTRAINT pk_painel PRIMARY KEY (idPainel)
);
COMMENT ON COLUMN Painel.tipoAcesso IS '0-Livre, 1-Usuário';
COMMENT ON COLUMN Painel.backgroundImageDraw IS '0-Normal, 1-Redimensionada, 2-Centralizada';
COMMENT ON COLUMN Painel.tipoAtualizacao IS '0-Atualizar automaticamente durante importação, 1-Não atualizar automaticamente';


CREATE INDEX ix_painel_2
 ON Painel
 ( apelido );

CREATE INDEX ix_painel_1
 ON Painel
 ( descPainel );

CREATE TABLE Sequence (
                seq_name VARCHAR(32) NOT NULL,
                seq_count INTEGER NOT NULL,
                CONSTRAINT pk_sequence PRIMARY KEY (seq_name)
);


CREATE TABLE Dummy (
                col1 CHAR(4)
);


CREATE TABLE RecursoPerm (
                idRecursoPerm INTEGER NOT NULL,
                idRecurso INTEGER,
                tipoRecurso INTEGER DEFAULT 0,
                idGrupoUsuario INTEGER,
                tipoGrupoUsuario INTEGER,
                alterar INTEGER,
                alterarPerm INTEGER,
                excluir INTEGER,
                copiar INTEGER,
                versao INTEGER,
                CONSTRAINT pk_recursoperm PRIMARY KEY (idRecursoPerm)
);
COMMENT ON COLUMN RecursoPerm.tipoRecurso IS '0-Painel, 1-Tarefa';
COMMENT ON COLUMN RecursoPerm.tipoGrupoUsuario IS '0-Grupo, 1-Usuário';
COMMENT ON COLUMN RecursoPerm.alterar IS '0-Não, 1-Sim';
COMMENT ON COLUMN RecursoPerm.alterarPerm IS '0-Não, 1-Sim';
COMMENT ON COLUMN RecursoPerm.excluir IS '0-Não, 1-Sim';
COMMENT ON COLUMN RecursoPerm.copiar IS '0-Não, 1-Sim';


CREATE UNIQUE INDEX ix_recursoperm_1
 ON RecursoPerm
 ( idRecurso, tipoRecurso, idGrupoUsuario, tipoGrupoUsuario );

CREATE TABLE ConfigGerais (
                idConfigGerais VARCHAR(32) NOT NULL,
                tarefaFormApelido VARCHAR(64) DEFAULT 'T-CLIENTE-$v{seq"int:00000"}',
                painelFormApelido VARCHAR(64) DEFAULT 'P-CLIENTE-$v{seq"int:00000"}',
                intervaloEnvioNotificacoes INTEGER,
                maxNumTentativasEnvio INTEGER,
                politicaTentativasEnvio INTEGER DEFAULT 0 NOT NULL,
                smsNumeroEnvio VARCHAR(32),
                smsAssunto VARCHAR(64),
                smsUsuario VARCHAR(256),
                smsSenha VARCHAR(256),
                smsRemetente VARCHAR(32),
                smsPrefixoTelefone VARCHAR(32),
                smsTamanhoMaxMsg INTEGER DEFAULT 140 NOT NULL,
                smsSenderClass VARCHAR(256),
                clientAssunto VARCHAR(256),
                msgUsuarioEnvio VARCHAR(40),
                msgAssunto VARCHAR(60),
                msnUsuario VARCHAR(256),
                msnSenha VARCHAR(256),
                msnStatus INTEGER DEFAULT 0 NOT NULL,
                msnTamanhoMaxMsg INTEGER DEFAULT 256 NOT NULL,
                emailsMsgServidor VARCHAR(2048),
                mobileAppKey VARCHAR(256),
                mobileAppTentativasEnvio INTEGER DEFAULT 5 NOT NULL,
                mobileAppTamanhoMaxMsg INTEGER DEFAULT 4096 NOT NULL,
                mobileAppTextCharset VARCHAR(32) DEFAULT 'UTF-8' NOT NULL,
                telegramBotName VARCHAR(256) NOT NULL,
                telegramBotToken VARCHAR(256),
                telegramTamanhoMaxMsg INTEGER DEFAULT 4096 NOT NULL,
                telegramTextCharset VARCHAR(32) DEFAULT 'UTF-8' NOT NULL,
                pushIntervaloEnvioNotificacoes INTEGER DEFAULT 60 NOT NULL,
                pushTamanhoMaxMsg INTEGER DEFAULT 4096 NOT NULL,
                pushTextCharset VARCHAR(32) DEFAULT 'UTF-8' NOT NULL,
                pushTempoExpiracao INTEGER DEFAULT 86400 NOT NULL,
                centralUrl VARCHAR(255),
                centralPrefixoUsuarios VARCHAR(128),
                centralAtualizarUsuarios INTEGER DEFAULT 0 NOT NULL,
                centralHorariosAtualizacao VARCHAR(256) DEFAULT '22:10:00' NOT NULL,
                centralAtualizarSenhaAdmin INTEGER DEFAULT 0 NOT NULL,
                centralCrc VARCHAR(128),
                versao INTEGER,
                CONSTRAINT pk_configgerais PRIMARY KEY (idConfigGerais)
);
COMMENT ON COLUMN ConfigGerais.intervaloEnvioNotificacoes IS 'Em segundos';
COMMENT ON COLUMN ConfigGerais.politicaTentativasEnvio IS '0-Tentar utilizar o servidor SMTP usado na  última notificação, 1-Tentar utilizar sempre o  servidor SMTP principal a cada notificação';
COMMENT ON COLUMN ConfigGerais.msnStatus IS '0-Disponível, 1-Ocupado, 2-Ausente';
COMMENT ON COLUMN ConfigGerais.pushIntervaloEnvioNotificacoes IS 'Em segundos';
COMMENT ON COLUMN ConfigGerais.pushTempoExpiracao IS 'Em segundos';
COMMENT ON COLUMN ConfigGerais.centralAtualizarUsuarios IS '0-Não, 1-Sim';
COMMENT ON COLUMN ConfigGerais.centralAtualizarSenhaAdmin IS '0-Não, 1-Sim';


CREATE TABLE ConfigMail (
                idConfigMail INTEGER NOT NULL,
                idConfigGerais VARCHAR(32) NOT NULL,
                nome VARCHAR(256) NOT NULL,
                ordem INTEGER DEFAULT 1 NOT NULL,
                tipoUso INTEGER DEFAULT 0 NOT NULL,
                numTentativasEnvio INTEGER DEFAULT 3 NOT NULL,
                remetenteOutroDominio INTEGER DEFAULT 0 NOT NULL,
                mailSubject VARCHAR(256),
                mailSmtpHost VARCHAR(256),
                mailSmtpPort INTEGER,
                mailSmtpAuth INTEGER,
                mailUser VARCHAR(256),
                mailPassword VARCHAR(256),
                mailTo VARCHAR(256),
                mailFrom VARCHAR(256),
                mailDebug INTEGER,
                mailCustomProps VARCHAR(2048),
                mailProps INTEGER DEFAULT 0,
                tamanhoPacoteEnvio INTEGER DEFAULT 10 NOT NULL,
                intervaloEntrePacotes INTEGER DEFAULT 10 NOT NULL,
                tamanhoMaximoMensagem INTEGER DEFAULT 0 NOT NULL,
                tamanhoMaximoAnexos INTEGER DEFAULT 0 NOT NULL,
                limiteEnviosHora INTEGER DEFAULT 0 NOT NULL,
                limiteEnviosDia INTEGER DEFAULT 0 NOT NULL,
                tipoIntervaloHora INTEGER DEFAULT 0 NOT NULL,
                tipoIntervaloDia INTEGER DEFAULT 0 NOT NULL,
                situacao INTEGER DEFAULT 0 NOT NULL,
                versao INTEGER,
                CONSTRAINT configmail_pk PRIMARY KEY (idConfigMail)
);
COMMENT ON COLUMN ConfigMail.tipoUso IS '0-Pode ser usado por qualquer tarefa, 1-Será usado exclusivamente por uma ou mais tarefas específicas';
COMMENT ON COLUMN ConfigMail.remetenteOutroDominio IS '0-Não Permite, 1-Permite';
COMMENT ON COLUMN ConfigMail.mailProps IS '0-Padrão, 1-Customizadas';
COMMENT ON COLUMN ConfigMail.intervaloEntrePacotes IS 'Tempo em segundos';
COMMENT ON COLUMN ConfigMail.tamanhoMaximoMensagem IS 'Tamanho em kilobytes (KB)';
COMMENT ON COLUMN ConfigMail.tamanhoMaximoAnexos IS 'Tamanho em kilobytes (KB)';
COMMENT ON COLUMN ConfigMail.tipoIntervaloHora IS '0-Últimos 60 minutos, 1-Hora cheia';
COMMENT ON COLUMN ConfigMail.tipoIntervaloDia IS '0-Últimas 24 horas, 1-Dia cheio';
COMMENT ON COLUMN ConfigMail.situacao IS '0-Ativo, 1-Inativo';


CREATE TABLE VariavelScript (
                idVariavelScript VARCHAR(128) NOT NULL,
                descVariavelScript VARCHAR(256),
                valor VARCHAR(20000),
                valoresPossiveis VARCHAR(20000),
                tipoAtualizacao INTEGER DEFAULT 0 NOT NULL,
                tipoParam INTEGER DEFAULT 0 NOT NULL,
                include INTEGER DEFAULT 0,
                apelidoTarefa VARCHAR(4096),
                versao INTEGER,
                CONSTRAINT pk_variavelscript PRIMARY KEY (idVariavelScript)
);
COMMENT ON COLUMN VariavelScript.tipoAtualizacao IS '0-Atualizar automaticamente durante importação, 1-Não atualizar automaticamente';
COMMENT ON COLUMN VariavelScript.tipoParam IS '0-Editável, 1-Visual, 2-Bloqueado';
COMMENT ON COLUMN VariavelScript.include IS '0-Não, 1-Sim';


CREATE TABLE Subprocesso (
                idSubprocesso INTEGER NOT NULL,
                descSubprocesso VARCHAR(128),
                obs VARCHAR(1000),
                versao INTEGER,
                CONSTRAINT pk_subprocesso PRIMARY KEY (idSubprocesso)
);


CREATE INDEX ix_subprocesso_1
 ON Subprocesso
 ( descSubprocesso );

CREATE TABLE Processo (
                idProcesso INTEGER NOT NULL,
                descProcesso VARCHAR(128),
                obs VARCHAR(1000),
                versao INTEGER,
                CONSTRAINT pk_processo PRIMARY KEY (idProcesso)
);


CREATE INDEX ix_processo_1
 ON Processo
 ( descProcesso );

CREATE TABLE GrupoUsuarios (
                idGrupoUsuarios INTEGER NOT NULL,
                descGrupoUsuarios VARCHAR(128),
                auth VARCHAR(1024),
                crc VARCHAR(128),
                tipoLoginPolitica INTEGER DEFAULT 0 NOT NULL,
                idLoginPolitica INTEGER,
                tipoLoginEndereco INTEGER DEFAULT 0 NOT NULL,
                idLoginEndereco INTEGER,
                versao INTEGER,
                CONSTRAINT pk_grupousuarios PRIMARY KEY (idGrupoUsuarios)
);
COMMENT ON COLUMN GrupoUsuarios.tipoLoginPolitica IS '0-Geral, 1-Grupo';
COMMENT ON COLUMN GrupoUsuarios.tipoLoginEndereco IS '0-Geral, 1-Grupo';


CREATE INDEX ix_grupousuarios_1
 ON GrupoUsuarios
 ( descGrupoUsuarios );

CREATE TABLE Usuario (
                idUsuario INTEGER NOT NULL,
                usuario VARCHAR(128),
                nomeUsuario VARCHAR(128),
                senha VARCHAR(128),
                idGrupoUsuarios INTEGER,
                tipo INTEGER DEFAULT 2 NOT NULL,
                situacao INTEGER DEFAULT 0 NOT NULL,
                tipoAuth INTEGER DEFAULT 0 NOT NULL,
                auth VARCHAR(1024),
                crc VARCHAR(128),
                senhaDataAlt DATE,
                senhaHoraAlt VARCHAR(8),
                senhaAlterarProximoLogin INTEGER DEFAULT 0 NOT NULL,
                bloqueado INTEGER DEFAULT 0 NOT NULL,
                dataBloqueio DATE,
                horaBloqueio VARCHAR(8),
                dataDesbloqueio DATE,
                horaDesbloqueio VARCHAR(8),
                tipoLoginPolitica INTEGER DEFAULT 0 NOT NULL,
                idLoginPolitica INTEGER,
                tipoLoginEndereco INTEGER DEFAULT 0 NOT NULL,
                idLoginEndereco INTEGER,
                attr VARCHAR(1024),
                crc2 VARCHAR(128),
                perm INTEGER DEFAULT 0 NOT NULL,
                central INTEGER DEFAULT 0 NOT NULL,
                versao INTEGER,
                CONSTRAINT pk_usuario PRIMARY KEY (idUsuario)
);
COMMENT ON COLUMN Usuario.tipo IS '0-Administrador, 1-Gerente, 2-Usuário, 3-Sistema';
COMMENT ON COLUMN Usuario.situacao IS '0-Ativo, 1-Inativo';
COMMENT ON COLUMN Usuario.tipoAuth IS '0-Grupo, 1-Usuário';
COMMENT ON COLUMN Usuario.senhaAlterarProximoLogin IS '0-Não, 1-Sim';
COMMENT ON COLUMN Usuario.bloqueado IS '0-Não, 1-Sim';
COMMENT ON COLUMN Usuario.tipoLoginPolitica IS '0-Geral, 1-Grupo, 2-Usuário';
COMMENT ON COLUMN Usuario.tipoLoginEndereco IS '0-Geral, 1-Grupo, 2-Usuário';


CREATE INDEX fk_usuario_1
 ON Usuario
 ( idGrupoUsuarios );

CREATE INDEX ix_usuario_2
 ON Usuario
 ( nomeUsuario );

CREATE INDEX ix_usuario_3
 ON Usuario
 ( idGrupoUsuarios );

CREATE UNIQUE INDEX ix_usuario_1
 ON Usuario
 ( usuario );

CREATE TABLE LogAcao (
                idLogAcao INTEGER NOT NULL,
                tipo CHAR(1) DEFAULT 'H' NOT NULL,
                classe VARCHAR(128),
                acao CHAR(1) NOT NULL,
                tabela VARCHAR(128),
                chave VARCHAR(2048),
                idRegistro INTEGER,
                valores VARCHAR(32000),
                idUsuario INTEGER NOT NULL,
                data DATE NOT NULL,
                hora VARCHAR(8) NOT NULL,
                situacao CHAR(1),
                dataSituacao DATE,
                horaSituacao VARCHAR(8),
                idUsuarioSituacao INTEGER,
                CONSTRAINT logacao_pk PRIMARY KEY (idLogAcao)
);
COMMENT ON COLUMN LogAcao.tipo IS 'H-Histórico, P-Problema';
COMMENT ON COLUMN LogAcao.classe IS 'Exemplo: API Google';
COMMENT ON COLUMN LogAcao.acao IS 'Ação realizada: A-Alteração, I-Inclusão, E- Exclusão, U-Última Alteração, S-Solicitação de Alteração';
COMMENT ON COLUMN LogAcao.chave IS 'Para tabela com PK composta (mais de uma coluna), utilizar esse campo. Define um json de chaves, ex: { idproduto: 1, idfornecedor: 100 } ou { idproduto: 1 }';
COMMENT ON COLUMN LogAcao.idRegistro IS 'Para tabelas com PK simples (uma coluna) utilizar esse campo para indicar o registro, caso contrário, utilizar o campo chave';
COMMENT ON COLUMN LogAcao.situacao IS 'P-Pendente, A-Aceita, R-Rejeitada';


CREATE INDEX logacao_idx_datahora
 ON LogAcao
 ( data, hora );

CREATE INDEX logacao_idx_datahorasituacao
 ON LogAcao
 ( dataSituacao, horaSituacao );

CREATE INDEX logacao_idx_tabelaidregistro
 ON LogAcao
 ( tabela, idRegistro );

CREATE TABLE Login (
                idLogin INTEGER NOT NULL,
                idUsuario INTEGER,
                usuarioLogin VARCHAR(128),
                sessionId VARCHAR(128),
                dataLogin DATE,
                horaLogin VARCHAR(8),
                dataHoraLogin TIMESTAMP NOT NULL,
                dataLogout DATE,
                horaLogout VARCHAR(8),
                tipoLogout INTEGER DEFAULT 0 NOT NULL,
                dataUltAcesso DATE,
                horaUltAcesso VARCHAR(8),
                numeroAcessos INTEGER DEFAULT 0 NOT NULL,
                remoteAddress VARCHAR(128),
                device VARCHAR(128),
                tipoApp INTEGER NOT NULL,
                resultado INTEGER NOT NULL,
                token VARCHAR(128),
                versao INTEGER,
                CONSTRAINT login_pk PRIMARY KEY (idLogin)
);
COMMENT ON COLUMN Login.tipoLogout IS '0-Não realizado, 1-Usuário, 2-Sessão Expirada, 3-App Server Stop';
COMMENT ON COLUMN Login.tipoApp IS '0-Client, 1-Web View, 2-Mobile App';
COMMENT ON COLUMN Login.resultado IS '0-Sucesso, 1-Usuário/Senha Inválido, 2-Usuário Bloqueado, 3-Login Bloqueado Temporariamente, 4-Senha Expirada, 5-Necessário Alterar Senha, 6-Alteração de Senha Inválida, 7-Horário não Permitido, 8-Endereço não Permitido, 9-Falha Autenticação em 2 Etapas';


CREATE UNIQUE INDEX login_idx_token
 ON Login
 ( token );

CREATE INDEX login_idx_datahoralogin
 ON Login
 ( dataLogin, horaLogin );

CREATE INDEX login_idx_sessionid_datalogin
 ON Login
 ( sessionId, dataLogin );

CREATE TABLE Preferencia (
                idPreferencia INTEGER NOT NULL,
                idUsuario INTEGER NOT NULL,
                tipoHierarquiaMenu INTEGER DEFAULT 0 NOT NULL,
                apelidoTarefaMenu VARCHAR(128),
                dataHoraVisualExecMilis BIGINT,
                dataHoraVisualNotifMilis BIGINT,
                versao INTEGER,
                CONSTRAINT preferencia_pk PRIMARY KEY (idPreferencia)
);


CREATE TABLE VisaoInicial (
                idVisaoInicial INTEGER NOT NULL,
                idUsuario INTEGER NOT NULL,
                tipoItem INTEGER DEFAULT 0 NOT NULL,
                idItem VARCHAR(255) NOT NULL,
                titulo VARCHAR(255),
                ordem INTEGER DEFAULT 0 NOT NULL,
                versao INTEGER,
                CONSTRAINT visaoinicial_pk PRIMARY KEY (idVisaoInicial)
);
COMMENT ON COLUMN VisaoInicial.tipoItem IS '0-Tarefa, 1-URL';
COMMENT ON COLUMN VisaoInicial.idItem IS 'Identificador do item favorito conforme o campo tipoItem. Exemplo: Para o tipoItem 0-Tarefa, este campo irá conter o Apelido da Tarefa.';


CREATE TABLE Favorito (
                idFavorito INTEGER NOT NULL,
                idUsuario INTEGER NOT NULL,
                tipoItem INTEGER DEFAULT 0 NOT NULL,
                idItem VARCHAR(255) NOT NULL,
                gridX INTEGER DEFAULT 0 NOT NULL,
                gridY INTEGER DEFAULT 0 NOT NULL,
                gridWidth INTEGER DEFAULT 0 NOT NULL,
                gridHeight INTEGER DEFAULT 0 NOT NULL,
                imagem VARCHAR(255),
                props VARCHAR(1024),
                ordem INTEGER DEFAULT 0 NOT NULL,
                versao INTEGER,
                CONSTRAINT favorito_pk PRIMARY KEY (idFavorito)
);
COMMENT ON COLUMN Favorito.tipoItem IS '0-Tarefa';
COMMENT ON COLUMN Favorito.idItem IS 'Identificador do item favorito conforme o campo tipoItem. Exemplo: Para o tipoItem 0-Tarefa, este campo irá conter o Apelido da Tarefa.';


CREATE TABLE PastaMsgUsuario (
                idPastaMsgUsuario INTEGER NOT NULL,
                idUsuario INTEGER,
                pasta VARCHAR(256),
                versao INTEGER,
                CONSTRAINT pk_pastamsgusuario PRIMARY KEY (idPastaMsgUsuario)
);


CREATE INDEX fk_pastamsgusuario_1
 ON PastaMsgUsuario
 ( idUsuario );

CREATE INDEX ix_pastamsgusuario_1
 ON PastaMsgUsuario
 ( idUsuario, pasta );

CREATE TABLE LogExecutorTarefas (
                idLogExecutorTarefas INTEGER NOT NULL,
                dataRef DATE,
                horaRef VARCHAR(6),
                idUsuario INTEGER,
                tipoLog INTEGER,
                descricao VARCHAR(256),
                versao INTEGER,
                CONSTRAINT pk_logexecutortarefas PRIMARY KEY (idLogExecutorTarefas)
);
COMMENT ON COLUMN LogExecutorTarefas.tipoLog IS '0-Inicialização, 1-Finalização, 2-Outros';


CREATE INDEX fk_logexecutortarefas_1
 ON LogExecutorTarefas
 ( idUsuario );

CREATE INDEX ix_logexecutortarefas_1
 ON LogExecutorTarefas
 ( idLogExecutorTarefas );

CREATE TABLE FormaContato (
                idFormaContato INTEGER NOT NULL,
                idUsuario INTEGER NOT NULL,
                tipo INTEGER NOT NULL,
                destino VARCHAR(4096),
                situacao INTEGER DEFAULT 0 NOT NULL,
                recuperacaoSenha INTEGER DEFAULT 0 NOT NULL,
                autenticacao2Etapas INTEGER DEFAULT 0 NOT NULL,
                versao INTEGER,
                CONSTRAINT pk_formacontato PRIMARY KEY (idFormaContato)
);
COMMENT ON COLUMN FormaContato.tipo IS '0-E-mail, 1-Mensageiro, 2-SMS, 3-Client, 4-WhatsApp, 5-Mobile App, 6-Telegram, 7-Web View, 8-Web View ou Mobile App';
COMMENT ON COLUMN FormaContato.situacao IS '0-Ativa, 1-Inativa';
COMMENT ON COLUMN FormaContato.recuperacaoSenha IS '0-Não, 1-Sim';
COMMENT ON COLUMN FormaContato.autenticacao2Etapas IS '0-Não, 1-Sim';


CREATE INDEX fk_formacontato_1
 ON FormaContato
 ( idUsuario );

CREATE INDEX ix_formacontato_1
 ON FormaContato
 ( idUsuario );

CREATE TABLE Tarefa (
                idTarefa INTEGER NOT NULL,
                descTarefa VARCHAR(256),
                codigoTarefa INTEGER DEFAULT 0,
                apelido VARCHAR(128),
                pacote VARCHAR(256),
                classificacao VARCHAR(256),
                idProcesso INTEGER,
                idSubprocesso INTEGER,
                situacao INTEGER DEFAULT 0 NOT NULL,
                tipoDias INTEGER DEFAULT 0 NOT NULL,
                diasSemana VARCHAR(7),
                dias VARCHAR(256),
                meses VARCHAR(256),
                anos VARCHAR(256),
                datas VARCHAR(2048),
                tipoHorarios INTEGER DEFAULT 0 NOT NULL,
                tipoIntervalo INTEGER DEFAULT 1 NOT NULL,
                intervalo INTEGER,
                horaInicial VARCHAR(6),
                horaFinal VARCHAR(6),
                horarios VARCHAR(256),
                script VARCHAR(32765),
                condicaoNotificacao VARCHAR(2000),
                scriptAcao VARCHAR(3000),
                emailTipoMsg INTEGER DEFAULT 0,
                emailAssunto VARCHAR(256),
                idFormaContato INTEGER,
                nomeSmtpEnvio VARCHAR(256),
                mensageiroTipoMsg INTEGER DEFAULT 1,
                mensageiroAssunto VARCHAR(256),
                smsTipoMsg INTEGER DEFAULT 3,
                smsAssunto VARCHAR(64),
                clientTipoMsg INTEGER DEFAULT 0 NOT NULL,
                clientAssunto VARCHAR(256),
                tipoEnvioMsg INTEGER DEFAULT 0 NOT NULL,
                tipoTarefaExec INTEGER DEFAULT 0 NOT NULL,
                idUsuarioInc INTEGER,
                dataInc DATE,
                horaInc VARCHAR(6),
                tipoInc INTEGER DEFAULT 0 NOT NULL,
                idUsuarioAlt INTEGER,
                dataAlt DATE,
                horaAlt VARCHAR(6),
                idUsuarioImp INTEGER,
                dataImp DATE,
                horaImp VARCHAR(6),
                tipoImp INTEGER DEFAULT 0 NOT NULL,
                tipoAtualizacao INTEGER DEFAULT 0 NOT NULL,
                web INTEGER DEFAULT 0 NOT NULL,
                mobile INTEGER DEFAULT 0,
                include INTEGER DEFAULT 0 NOT NULL,
                bloquearExecManual INTEGER DEFAULT 0 NOT NULL,
                apelidoTarefaMae VARCHAR(128),
                guardarVersaoAoExecutar INTEGER DEFAULT 1 NOT NULL,
                guardarVersaoAoSalvar INTEGER DEFAULT 0 NOT NULL,
                versaoTarefa INTEGER DEFAULT 0 NOT NULL,
                hashScripts VARCHAR(128),
                usuarioVersao VARCHAR(128),
                dataVersao DATE,
                horaVersao VARCHAR(6),
                tipoAcesso INTEGER DEFAULT 0 NOT NULL,
                chaveAcesso VARCHAR(128) NOT NULL,
                proprietario VARCHAR(128),
                auditoria INTEGER DEFAULT 1 NOT NULL,
                modulePackage VARCHAR(128),
                deviceInc VARCHAR(128),
                deviceAlt VARCHAR(128),
                deviceImp VARCHAR(128),
                deviceVersao VARCHAR(128),
                versao INTEGER,
                CONSTRAINT pk_tarefa PRIMARY KEY (idTarefa)
);
COMMENT ON COLUMN Tarefa.situacao IS '0-Ativa, 1-Inativa';
COMMENT ON COLUMN Tarefa.tipoDias IS '0-Dias da semana, 1-Dias, meses e anos';
COMMENT ON COLUMN Tarefa.tipoHorarios IS '0-Intervalo, 1-Horários fixos';
COMMENT ON COLUMN Tarefa.tipoIntervalo IS '0-Segundos, 1-Minutos, 2-Horas';
COMMENT ON COLUMN Tarefa.intervalo IS '0-Segundos, 1-Minutos, 2-Horas';
COMMENT ON COLUMN Tarefa.emailTipoMsg IS '0-HTML, 1-Texto, 2-Resumo HTML, 3-Resumo Texto';
COMMENT ON COLUMN Tarefa.idFormaContato IS 'Forma de contato usada como remetente no envio de notificações por e-mail';
COMMENT ON COLUMN Tarefa.mensageiroTipoMsg IS '0-HTML, 1-Texto, 2-Resumo HTML, 3-Resumo Texto';
COMMENT ON COLUMN Tarefa.smsTipoMsg IS '0-HTML, 1-Texto, 2-Resumo HTML, 3-Resumo Texto';
COMMENT ON COLUMN Tarefa.clientTipoMsg IS '0-HTML, 1-Texto, 2-Resumo HTML, 3-Resumo Texto';
COMMENT ON COLUMN Tarefa.tipoEnvioMsg IS '0-Normal, 1-Inativa';
COMMENT ON COLUMN Tarefa.tipoTarefaExec IS '0-Normal, 1-Personalizada';
COMMENT ON COLUMN Tarefa.tipoInc IS '0-Manual, 1-Importação Indivídual, 2-Importação Automática';
COMMENT ON COLUMN Tarefa.tipoImp IS '1-Importação Indivídual, 2-Importação Automática';
COMMENT ON COLUMN Tarefa.tipoAtualizacao IS '0-Atualizar automaticamente durante importação, 1-Não atualizar automaticamente';
COMMENT ON COLUMN Tarefa.web IS '0-Não, 1-Sim';
COMMENT ON COLUMN Tarefa.mobile IS '0-Não, 1-Sim';
COMMENT ON COLUMN Tarefa.include IS '0-Não, 1-Sim';
COMMENT ON COLUMN Tarefa.bloquearExecManual IS '0-Não, 1-Sim';
COMMENT ON COLUMN Tarefa.guardarVersaoAoExecutar IS '0-Não, 1-Sim';
COMMENT ON COLUMN Tarefa.guardarVersaoAoSalvar IS '0-Não, 1-Sim';
COMMENT ON COLUMN Tarefa.tipoAcesso IS '0-Usuário/senha, 1-Público, 2-Chave, 3-Chave (SHA1), 4-Chave (MD5)';
COMMENT ON COLUMN Tarefa.auditoria IS '0-Não, 1-Sim';


CREATE INDEX fk_tarefa_3
 ON Tarefa
 ( idUsuarioImp );

CREATE INDEX ix_tarefa_2
 ON Tarefa
 ( apelido );

CREATE INDEX fk_tarefa_1
 ON Tarefa
 ( idProcesso );

CREATE INDEX fk_tarefa_2
 ON Tarefa
 ( idSubprocesso );

CREATE INDEX fk_tarefa_4
 ON Tarefa
 ( idUsuarioInc );

CREATE INDEX fk_tarefa_5
 ON Tarefa
 ( idUsuarioAlt );

CREATE INDEX ix_tarefa_1
 ON Tarefa
 ( codigoTarefa );

CREATE TABLE PainelIndicador (
                idPainelIndicador INTEGER NOT NULL,
                descPainelIndicador VARCHAR(256),
                titulo VARCHAR(256),
                idPainel INTEGER,
                idTarefa INTEGER,
                tipoExecucao INTEGER DEFAULT 0 NOT NULL,
                intervaloExecucao INTEGER DEFAULT 0 NOT NULL,
                tipoIntervalo INTEGER DEFAULT 0 NOT NULL,
                campo VARCHAR(40),
                numSeq INTEGER,
                referencia VARCHAR(256),
                formato VARCHAR(256),
                valorDefault VARCHAR(64),
                valorMinimo VARCHAR(64),
                valorMaximo VARCHAR(64),
                intervalos VARCHAR(256),
                unidades VARCHAR(64),
                propriedades VARCHAR(256),
                formatoDataRef VARCHAR(256),
                tipoContainer INTEGER DEFAULT 0 NOT NULL,
                tipoView INTEGER DEFAULT 0,
                tipoMsg INTEGER,
                relatorio VARCHAR(256),
                zoom INTEGER DEFAULT 100 NOT NULL,
                toolBar INTEGER DEFAULT 0 NOT NULL,
                statusPanel INTEGER DEFAULT 0 NOT NULL,
                startPage INTEGER DEFAULT 1 NOT NULL,
                horizontalScrollBar INTEGER DEFAULT 0 NOT NULL,
                verticalScrollBar INTEGER DEFAULT 0 NOT NULL,
                transparency INTEGER DEFAULT 0 NOT NULL,
                frameX INTEGER,
                frameY INTEGER,
                frameWidth INTEGER,
                frameHeight INTEGER,
                frameState INTEGER,
                versao INTEGER,
                CONSTRAINT pk_painelindicador PRIMARY KEY (idPainelIndicador)
);
COMMENT ON COLUMN PainelIndicador.tipoExecucao IS '0-Tarefa previamente executada, 1-Executar  tarefa a cada atualização, 2-Executar tarefa  uma vez por dia, 3-Executar tarefa se a última execução foi a mais de';
COMMENT ON COLUMN PainelIndicador.tipoIntervalo IS '0-Segundos, 1-Minutos, 2-Horas, 3-Dias';
COMMENT ON COLUMN PainelIndicador.tipoContainer IS '0-Janela Interna, 1-Janela Independente, 2-Janela Independente (sempre no topo)';
COMMENT ON COLUMN PainelIndicador.tipoView IS '0-Meter, 1-Thermometer, 2-Painel, 3-Notificação';
COMMENT ON COLUMN PainelIndicador.tipoMsg IS '0-HTML, 1-Texto';
COMMENT ON COLUMN PainelIndicador.toolBar IS '0-Não, 1-Sim';
COMMENT ON COLUMN PainelIndicador.statusPanel IS '0-Não, 1-Sim';
COMMENT ON COLUMN PainelIndicador.horizontalScrollBar IS '0-Quando Necessário, 1-Nunca, 2-Sempre';
COMMENT ON COLUMN PainelIndicador.verticalScrollBar IS '0-Quando Necessário, 1-Nunca, 2-Sempre';
COMMENT ON COLUMN PainelIndicador.frameState IS '0-Normal, 1-Fechado, 2-Iconizado';


CREATE INDEX fk_painelindicador_1
 ON PainelIndicador
 ( idTarefa );

CREATE INDEX fk_painelindicador_2
 ON PainelIndicador
 ( idPainel );

CREATE INDEX ix_painelindicador_1
 ON PainelIndicador
 ( descPainelIndicador );

CREATE TABLE TarefaMsg (
                idTarefaMsg INTEGER NOT NULL,
                idTarefa INTEGER,
                tipoMsg INTEGER DEFAULT 0 NOT NULL,
                template VARCHAR(128),
                msg VARCHAR(32765),
                versao INTEGER,
                CONSTRAINT pk_tarefamsg PRIMARY KEY (idTarefaMsg)
);
COMMENT ON COLUMN TarefaMsg.tipoMsg IS '0-HTML, 1-Texto, 2-Resumo HTML, 3-Resumo Texto';


CREATE INDEX fk_tarefamsg_1
 ON TarefaMsg
 ( idTarefa );

CREATE TABLE TarefaExecucao (
                idTarefaExecucao INTEGER NOT NULL,
                idTarefa INTEGER,
                versaoTarefa INTEGER,
                idLoteExecucao INTEGER DEFAULT 0 NOT NULL,
                tipoTarefaExec INTEGER DEFAULT 0 NOT NULL,
                versaoBdo VARCHAR(8),
                dataAgendamento DATE,
                horaAgendamento VARCHAR(6),
                dataInicial DATE,
                horaInicial VARCHAR(6),
                dataFinal DATE,
                horaFinal VARCHAR(6),
                tipoExecucao INTEGER DEFAULT 0 NOT NULL,
                idUsuario INTEGER,
                tipoResultado INTEGER,
                html INTEGER,
                texto INTEGER,
                resumoHtml INTEGER,
                resumoTexto INTEGER,
                obs VARCHAR(256),
                mensageiroAssunto VARCHAR(256),
                smsAssunto VARCHAR(64),
                idRefExecucao INTEGER DEFAULT 0,
                hash VARCHAR(128),
                execLoteSeq INTEGER,
                execLoteTotal INTEGER,
                versao INTEGER,
                CONSTRAINT pk_tarefaexecucao PRIMARY KEY (idTarefaExecucao)
);
COMMENT ON COLUMN TarefaExecucao.tipoTarefaExec IS '0-Normal, 1-Personalizada';
COMMENT ON COLUMN TarefaExecucao.tipoExecucao IS '0-Automática, 1-Manual, 2-Tarefa, 3-Painel,  4-Web';
COMMENT ON COLUMN TarefaExecucao.tipoResultado IS '0-Em Execução, 1-Normal s/ Notificação, 2-Normal c/ Notificação, 3-Erro na Execução, 4-Erro na Condição, 5-Erro na Notificação, 6-Execução Interrompida, 7-Normal (Ver Relacionadas)';
COMMENT ON COLUMN TarefaExecucao.html IS '0-Não, 1-Sim';
COMMENT ON COLUMN TarefaExecucao.texto IS '0-Não, 1-Sim';
COMMENT ON COLUMN TarefaExecucao.resumoHtml IS '0-Não, 1-Sim';
COMMENT ON COLUMN TarefaExecucao.resumoTexto IS '0-Não, 1-Sim';
COMMENT ON COLUMN TarefaExecucao.idRefExecucao IS 'Para o tipo de execução Tarefa, armazenará o id da execução que disparou o processo. Para o tipo de execução Painél, armazenará o id do painél que disparou o processo. Para os demais tipos de execução, armazenará zero.';


CREATE INDEX fk_tarefaexecucao_1
 ON TarefaExecucao
 ( idTarefa );

CREATE INDEX fk_tarefaexecucao_2
 ON TarefaExecucao
 ( idUsuario );

CREATE INDEX ix_tarefaexecucao_1
 ON TarefaExecucao
 ( dataAgendamento, horaAgendamento, idTarefa );

CREATE INDEX ix_tarefaexecucao_2
 ON TarefaExecucao
 ( dataInicial, horaInicial, idTarefa );

CREATE INDEX ix_tarefaexecucao_3
 ON TarefaExecucao
 ( dataFinal, horaFinal, idTarefa );

CREATE INDEX ix_tarefaexecucao_4
 ON TarefaExecucao
 ( idTarefa, idTarefaExecucao );

CREATE INDEX ix_tarefaexecucao_5
 ON TarefaExecucao
 ( hash );

CREATE TABLE TarefaExecucaoFormaContato (
                idTarefaExecucaoFormaContato INTEGER NOT NULL,
                idTarefaExecucao INTEGER,
                idUsuario INTEGER,
                tipo INTEGER,
                destino VARCHAR(4096),
                situacao INTEGER,
                dataEnvio DATE,
                horaEnvio VARCHAR(6),
                dataHoraEnvioMilis BIGINT,
                nomeSmtpEnvio VARCHAR(256),
                nomeSmtpEnvioUtilizado VARCHAR(256),
                numTentativasEnvio INTEGER,
                msgErro VARCHAR(1024),
                codErro INTEGER DEFAULT 0 NOT NULL,
                remetente VARCHAR(256),
                remetenteHost VARCHAR(256),
                respostaPara VARCHAR(4096),
                dataLeitura DATE,
                horaLeitura VARCHAR(6),
                hash VARCHAR(128),
                dataExpiracao DATE,
                horaExpiracao VARCHAR(6),
                dataHoraExpiracaoMilis BIGINT,
                usuarioDestino VARCHAR(255),
                fila CHAR(1),
                versao INTEGER,
                CONSTRAINT pk_tarefaexecucaoformacontato PRIMARY KEY (idTarefaExecucaoFormaContato)
);
COMMENT ON COLUMN TarefaExecucaoFormaContato.tipo IS '0-E-mail, 1-Mensageiro, 2-SMS, 3-Client, 4-MSN, 5-Mobile App, 6-Telegram, 7-Web View, 8-Web View ou Mobile App';
COMMENT ON COLUMN TarefaExecucaoFormaContato.situacao IS '0-Não Enviado, 1-Enviado, 2-Envio Cancelado, 3-Expirado';
COMMENT ON COLUMN TarefaExecucaoFormaContato.fila IS 'null-Sem fila específica, P-Fila Prioritária';


CREATE INDEX fk_tarefaexecucaoformacon_1
 ON TarefaExecucaoFormaContato
 ( idUsuario );

CREATE INDEX fk_tarefaexecucaoformacon_2
 ON TarefaExecucaoFormaContato
 ( idTarefaExecucao );

CREATE INDEX ix_tarefaexecucaoformacon_1
 ON TarefaExecucaoFormaContato
 ( situacao, numTentativasEnvio );

CREATE INDEX ix_tarefaexecucaoformacon_3
 ON TarefaExecucaoFormaContato
 ( dataHoraEnvioMilis );

CREATE INDEX ix_tarefaexecucaoformacon_4
 ON TarefaExecucaoFormaContato
 ( usuarioDestino, dataEnvio );

CREATE TABLE TarefaExecucaoAnexo (
                idTarefaExecucaoAnexo INTEGER NOT NULL,
                idTarefaExecucao INTEGER,
                tipo INTEGER,
                nomeArquivo VARCHAR(256),
                tamanhoArquivo INTEGER,
                nomeAnexo VARCHAR(256),
                versao INTEGER,
                CONSTRAINT pk_tarefaexecucaoanexo PRIMARY KEY (idTarefaExecucaoAnexo)
);
COMMENT ON COLUMN TarefaExecucaoAnexo.tipo IS '0-Gráfico, 1-Planilha, 2-Relatório';


CREATE INDEX fk_tarefaexecucaoanexo_1
 ON TarefaExecucaoAnexo
 ( idTarefaExecucao );

CREATE TABLE TarefaExecucaoValor (
                idTarefaExecucaoValor INTEGER NOT NULL,
                idTarefa INTEGER,
                idTarefaExecucao INTEGER,
                campo VARCHAR(40),
                numSeq INTEGER,
                numSql INTEGER,
                numRow INTEGER,
                valor VARCHAR(1024),
                tipo INTEGER,
                dataRef DATE,
                horaRef VARCHAR(6),
                versao INTEGER,
                CONSTRAINT pk_tarefaexecucaovalor PRIMARY KEY (idTarefaExecucaoValor)
);


CREATE INDEX fk_tarefaexecucaovalor_2
 ON TarefaExecucaoValor
 ( idTarefa );

CREATE INDEX fk_tarefaexecucaovalor_3
 ON TarefaExecucaoValor
 ( idTarefaExecucao );

CREATE INDEX ix_tarefaexecucaovalor_1
 ON TarefaExecucaoValor
 ( idTarefa, campo, numSeq, idTarefaExecucao );

CREATE INDEX ix_tarefaexecucaovalor_2
 ON TarefaExecucaoValor
 ( idTarefa, idTarefaExecucao, campo, numSeq );

CREATE INDEX ix_tarefaexecucaovalor_3
 ON TarefaExecucaoValor
 ( idTarefa, campo, numSeq, dataRef, horaRef );

CREATE TABLE MsgUsuario (
                idMsgUsuario INTEGER NOT NULL,
                idLoteMsg INTEGER,
                idUsuario INTEGER,
                idUsuarioOrigem INTEGER,
                idUsuarioDestino INTEGER,
                para VARCHAR(2048),
                idTarefaExecucao INTEGER,
                idTarefa INTEGER,
                idPastaMsgUsuario INTEGER,
                dataRef DATE,
                horaRef VARCHAR(6),
                tipoMsg INTEGER DEFAULT 0,
                assunto VARCHAR(256),
                dataAcesso DATE,
                horaAcesso VARCHAR(6),
                dataLeitura DATE,
                horaLeitura VARCHAR(6),
                mensagem VARCHAR(20000),
                obs VARCHAR(10000),
                versao INTEGER,
                CONSTRAINT pk_msgusuario PRIMARY KEY (idMsgUsuario)
);
COMMENT ON COLUMN MsgUsuario.tipoMsg IS '0-HTML, 1-Texto, 2-Resumo HTML, 3-Resumo Texto';


CREATE INDEX fk_msgusuario_2
 ON MsgUsuario
 ( idTarefaExecucao );

CREATE INDEX fk_msgusuario_3
 ON MsgUsuario
 ( idTarefa );

CREATE INDEX fk_msgusuario_4
 ON MsgUsuario
 ( idUsuarioDestino );

CREATE INDEX fk_msgusuario_5
 ON MsgUsuario
 ( idUsuarioOrigem );

CREATE INDEX fk_msgusuario_6
 ON MsgUsuario
 ( idPastaMsgUsuario );

CREATE INDEX ix_msgusuario_1
 ON MsgUsuario
 ( idUsuario, idPastaMsgUsuario, idMsgUsuario );

CREATE INDEX ix_msgusuario_2
 ON MsgUsuario
 ( idUsuarioOrigem, idPastaMsgUsuario, idMsgUsuario );

CREATE INDEX ix_msgusuario_3
 ON MsgUsuario
 ( idUsuarioDestino, idPastaMsgUsuario, idMsgUsuario );

CREATE INDEX ix_msgusuario_4
 ON MsgUsuario
 ( idLoteMsg );

CREATE TABLE TarefaVersao (
                idTarefaVersao INTEGER NOT NULL,
                idTarefa INTEGER NOT NULL,
                versaoTarefa INTEGER NOT NULL,
                hashScripts VARCHAR(128),
                script VARCHAR(32765),
                condicaoNotificacao VARCHAR(2000),
                scriptAcao VARCHAR(3000),
                usuarioVersao VARCHAR(128),
                deviceVersao VARCHAR(128),
                dataVersao DATE,
                horaVersao VARCHAR(6),
                tipoVersao INTEGER DEFAULT 0,
                usuarioInc VARCHAR(128),
                deviceInc VARCHAR(128),
                dataInc DATE,
                horaInc VARCHAR(6),
                versao INTEGER,
                CONSTRAINT pk_tarefaversao PRIMARY KEY (idTarefaVersao)
);
COMMENT ON COLUMN TarefaVersao.tipoVersao IS '0-Nao Aplicado, 1-Usuario, 2-Ao Executar, 3-Ao Salvar, 4-Alteracao Simultanea';


CREATE INDEX fk_tarefaversao_1
 ON TarefaVersao
 ( idTarefa );

CREATE INDEX ix_tarefaversao_1
 ON TarefaVersao
 ( idTarefa, versaoTarefa, hashScripts );

CREATE INDEX ix_tarefaversao_2
 ON TarefaVersao
 ( idTarefa, dataVersao, horaVersao, versaoTarefa );

CREATE INDEX ix_tarefaversao_3
 ON TarefaVersao
 ( usuarioVersao, dataVersao, horaVersao, versaoTarefa );

CREATE TABLE TarefaMsgVersao (
                idTarefaMsgVersao INTEGER NOT NULL,
                idTarefaVersao INTEGER NOT NULL,
                tipoMsg INTEGER DEFAULT 0 NOT NULL,
                template VARCHAR(128),
                msg VARCHAR(32765),
                versao INTEGER,
                CONSTRAINT pk_tarefamsgversao PRIMARY KEY (idTarefaMsgVersao)
);
COMMENT ON COLUMN TarefaMsgVersao.tipoMsg IS '0-HTML, 1-Texto, 2-Resumo HTML, 3-Resumo Texto';


CREATE INDEX fk_tarefamsgversao_1
 ON TarefaMsgVersao
 ( idTarefaVersao );

CREATE TABLE TarefaFormaContato (
                idTarefaFormaContato INTEGER NOT NULL,
                idTarefa INTEGER,
                idFormaContato INTEGER,
                situacao INTEGER DEFAULT 0 NOT NULL,
                numOcorrAnormais INTEGER,
                referencia VARCHAR(64),
                condicaoNotificacao VARCHAR(2000),
                destinatario INTEGER DEFAULT 1 NOT NULL,
                respostaPara INTEGER DEFAULT 0 NOT NULL,
                nomeSmtpEnvio VARCHAR(256),
                versao INTEGER,
                CONSTRAINT pk_tarefaformacontato PRIMARY KEY (idTarefaFormaContato)
);
COMMENT ON COLUMN TarefaFormaContato.situacao IS '0-Ativa, 1-Inativa';
COMMENT ON COLUMN TarefaFormaContato.destinatario IS '0-Não, 1-Sim';
COMMENT ON COLUMN TarefaFormaContato.respostaPara IS '0-Não, 1-Sim';


CREATE INDEX fk_tarefaformacontato_2
 ON TarefaFormaContato
 ( idTarefa );

CREATE INDEX fk_tarefaformacontato_3
 ON TarefaFormaContato
 ( idFormaContato );

ALTER TABLE LoginEnderecoRegra ADD CONSTRAINT loginendereco_loginenderecoregra_fk
FOREIGN KEY (idLoginEndereco)
REFERENCES LoginEndereco (idLoginEndereco)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE GrupoUsuarios ADD CONSTRAINT loginendereco_grupousuarios_fk
FOREIGN KEY (idLoginEndereco)
REFERENCES LoginEndereco (idLoginEndereco)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Usuario ADD CONSTRAINT loginendereco_usuario_fk
FOREIGN KEY (idLoginEndereco)
REFERENCES LoginEndereco (idLoginEndereco)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE LoginCalendarioDia ADD CONSTRAINT calendariologin_calendariologindia_fk
FOREIGN KEY (idCalendarioLogin)
REFERENCES LoginCalendario (idLoginCalendario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE LoginPolitica ADD CONSTRAINT logincalendario_loginpolitica_fk
FOREIGN KEY (idLoginCalendario)
REFERENCES LoginCalendario (idLoginCalendario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Usuario ADD CONSTRAINT loginpolitica_usuario_fk
FOREIGN KEY (idLoginPolitica)
REFERENCES LoginPolitica (idLoginPolitica)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE GrupoUsuarios ADD CONSTRAINT loginpolitica_grupousuarios_fk
FOREIGN KEY (idLoginPolitica)
REFERENCES LoginPolitica (idLoginPolitica)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DominioTabela ADD CONSTRAINT dominio_dominiotabela_fk
FOREIGN KEY (idDominio)
REFERENCES Dominio (idDominio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DominioJuncao ADD CONSTRAINT dominio_dominiojuncao_fk
FOREIGN KEY (idDominio)
REFERENCES Dominio (idDominio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DominioFiltro ADD CONSTRAINT dominio_dominiofiltro_fk
FOREIGN KEY (idDominio)
REFERENCES Dominio (idDominio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DominioOrdem ADD CONSTRAINT dominio_dominioordem_fk
FOREIGN KEY (idDominio)
REFERENCES Dominio (idDominio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DominioAgrupamento ADD CONSTRAINT dominio_dominioagrupamento_fk
FOREIGN KEY (idDominio)
REFERENCES Dominio (idDominio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DominioUniao ADD CONSTRAINT dominio_dominiouniao_fk
FOREIGN KEY (idDominio)
REFERENCES Dominio (idDominio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DominioUniao ADD CONSTRAINT dominio_dominiouniao2_fk
FOREIGN KEY (idDominioUnido)
REFERENCES Dominio (idDominio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DominioTabelaColuna ADD CONSTRAINT domtabela_domtabelacoluna_fk
FOREIGN KEY (idDominioTabela)
REFERENCES DominioTabela (idDominioTabela)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DominioJuncao ADD CONSTRAINT dominiotabela_dominiojuncao_fk
FOREIGN KEY (idDominioTabela)
REFERENCES DominioTabela (idDominioTabela)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DominioJuncaoExpressao ADD CONSTRAINT domjuncao_domjuncaoexpressao_fk
FOREIGN KEY (idDominioJuncao)
REFERENCES DominioJuncao (idDominioJuncao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DominioFormaContato ADD CONSTRAINT tipodominio_dominioformacontato_fk
FOREIGN KEY (idTipoDominio)
REFERENCES TipoDominio (idTipoDominio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE DominioFormaContato ADD CONSTRAINT assuntoformacontato_dominioformacontato_fk
FOREIGN KEY (idAssuntoFormaContato)
REFERENCES AssuntoFormaContato (idAssuntoFormaContato)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PainelIndicador ADD CONSTRAINT fk_painelindicador_2
FOREIGN KEY (idPainel)
REFERENCES Painel (idPainel)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ConfigMail ADD CONSTRAINT configgerais_configmail_fk
FOREIGN KEY (idConfigGerais)
REFERENCES ConfigGerais (idConfigGerais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Tarefa ADD CONSTRAINT fk_tarefa_2
FOREIGN KEY (idSubprocesso)
REFERENCES Subprocesso (idSubprocesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Tarefa ADD CONSTRAINT fk_tarefa_1
FOREIGN KEY (idProcesso)
REFERENCES Processo (idProcesso)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Usuario ADD CONSTRAINT fk_usuario_1
FOREIGN KEY (idGrupoUsuarios)
REFERENCES GrupoUsuarios (idGrupoUsuarios)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE FormaContato ADD CONSTRAINT fk_formacontato_1
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Tarefa ADD CONSTRAINT fk_tarefa_4
FOREIGN KEY (idUsuarioInc)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Tarefa ADD CONSTRAINT fk_tarefa_3
FOREIGN KEY (idUsuarioImp)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Tarefa ADD CONSTRAINT fk_tarefa_5
FOREIGN KEY (idUsuarioAlt)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE LogExecutorTarefas ADD CONSTRAINT fk_logexecutortarefas_1
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PastaMsgUsuario ADD CONSTRAINT fk_pastamsgusuario_1
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MsgUsuario ADD CONSTRAINT fk_msgusuario_5
FOREIGN KEY (idUsuarioOrigem)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MsgUsuario ADD CONSTRAINT fk_msgusuario_4
FOREIGN KEY (idUsuarioDestino)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE TarefaExecucao ADD CONSTRAINT fk_tarefaexecucao_2
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE TarefaExecucaoFormaContato ADD CONSTRAINT fk_tarefaexecucaoformacon_1
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Favorito ADD CONSTRAINT usuario_favorito_fk
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE VisaoInicial ADD CONSTRAINT usuario_visaoinicial_fk
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Preferencia ADD CONSTRAINT usuario_preferencia_fk
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Login ADD CONSTRAINT usuario_login_fk
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE LogAcao ADD CONSTRAINT usuario_logacao_fk
FOREIGN KEY (idUsuario)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE LogAcao ADD CONSTRAINT usuariosituacao_logacao_fk
FOREIGN KEY (idUsuarioSituacao)
REFERENCES Usuario (idUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MsgUsuario ADD CONSTRAINT fk_msgusuario_6
FOREIGN KEY (idPastaMsgUsuario)
REFERENCES PastaMsgUsuario (idPastaMsgUsuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE TarefaFormaContato ADD CONSTRAINT fk_tarefaformacontato_3
FOREIGN KEY (idFormaContato)
REFERENCES FormaContato (idFormaContato)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Tarefa ADD CONSTRAINT formacontato_tarefa_fk
FOREIGN KEY (idFormaContato)
REFERENCES FormaContato (idFormaContato)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE TarefaVersao ADD CONSTRAINT fk_tarefaversao_1
FOREIGN KEY (idTarefa)
REFERENCES Tarefa (idTarefa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MsgUsuario ADD CONSTRAINT fk_msgusuario_3
FOREIGN KEY (idTarefa)
REFERENCES Tarefa (idTarefa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE TarefaExecucao ADD CONSTRAINT fk_tarefaexecucao_1
FOREIGN KEY (idTarefa)
REFERENCES Tarefa (idTarefa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE TarefaExecucaoValor ADD CONSTRAINT fk_tarefaexecucaovalor_2
FOREIGN KEY (idTarefa)
REFERENCES Tarefa (idTarefa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE TarefaFormaContato ADD CONSTRAINT fk_tarefaformacontato_2
FOREIGN KEY (idTarefa)
REFERENCES Tarefa (idTarefa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE TarefaMsg ADD CONSTRAINT fk_tarefamsg_1
FOREIGN KEY (idTarefa)
REFERENCES Tarefa (idTarefa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE PainelIndicador ADD CONSTRAINT fk_painelindicador_1
FOREIGN KEY (idTarefa)
REFERENCES Tarefa (idTarefa)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE MsgUsuario ADD CONSTRAINT fk_msgusuario_2
FOREIGN KEY (idTarefaExecucao)
REFERENCES TarefaExecucao (idTarefaExecucao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE TarefaExecucaoValor ADD CONSTRAINT fk_tarefaexecucaovalor_3
FOREIGN KEY (idTarefaExecucao)
REFERENCES TarefaExecucao (idTarefaExecucao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE TarefaExecucaoAnexo ADD CONSTRAINT fk_tarefaexecucaoanexo_1
FOREIGN KEY (idTarefaExecucao)
REFERENCES TarefaExecucao (idTarefaExecucao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE TarefaExecucaoFormaContato ADD CONSTRAINT fk_tarefaexecucaoformacon_2
FOREIGN KEY (idTarefaExecucao)
REFERENCES TarefaExecucao (idTarefaExecucao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE TarefaMsgVersao ADD CONSTRAINT fk_tarefamsgversao_1
FOREIGN KEY (idTarefaVersao)
REFERENCES TarefaVersao (idTarefaVersao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;