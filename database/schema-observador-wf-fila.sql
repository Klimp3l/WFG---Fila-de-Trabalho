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


CREATE TABLE WFFilaTrabalhoCausa (
                idWFFilaTrabalho INTEGER NOT NULL,
                idWFCausa INTEGER NOT NULL,
                descricao VARCHAR(255),
                CONSTRAINT wffilatrabalhocausa_pk PRIMARY KEY (idWFFilaTrabalho, idWFCausa)
);;

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
