-- Colunas do aplicativo por atividade.
-- Sem aspas, o nome fica camposusoaplicacao. Nulo ou lista vazia libera todas as colunas.
-- JSON: [{"campo":"produto","visual":true}]

ALTER TABLE public.WFAtividade ADD COLUMN camposUsoAplicacao VARCHAR(12345);
ALTER TABLE WFAtividade ALTER COLUMN camposUsoAplicacao TYPE jsonb USING camposUsoAplicacao::jsonb;

COMMENT ON COLUMN WFAtividade.camposUsoAplicacao IS 'Colunas do aplicativo. JSON [{"campo","visual"}]. Nulo ou vazio libera todas.';
