-- WFG: nós do fluxo por fila (dados operacionais no ds_bridge / Observador).
-- Apelido da tarefa de execução (datasource2): CLIENTE-wfg-{codigoTarefa}-execucao

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
