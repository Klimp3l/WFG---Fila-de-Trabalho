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