$> sb.append(consts());
$> sb.append(store());

<script_content name="store">
const store = new Vue({
	data() {
		return {
			optionsProcessos: [],
			optionsEventos: [],
			optionsEmpresas: [],
			optionsDepartamentos: [],
			optionsSetores: [],
			optionsGrupos: [],
			optionsFamilias: [],
			optionsMetas: [],
			optionsLocalEstoque: [],
			optionsPontoExposicao: [],

			loadingProcessos: false,
			loadingEmpresas: false,
			loadingMercadologicos: false,
			loadingMetas: false,
			loadingLocalEstoque: false,

			tiposIntervalos: [
				{ value: 0, label: "Segundo(s)" },
				{ value: 1, label: "Minuto(s)" },
				{ value: 2, label: "Hora(s)" }
			],
			dias: [],
			meses: [],
			anos: [],
		}
	},
	methods: {
		getProcessos() {
			return this.$$service.get({}, { scriptFunction: 'getProcessos' })
				.then((response) => {
					this.optionsProcessos = response;
				})
				.always(() => {
					this.$nextTick(function () {
						this.loadingProcessos = false;
					  })
				});
		},
		getEmpresas() {
			this.$$service.get({}, { scriptFunction: 'getEmpresas' })
				.then((response) => {
					this.optionsEmpresas = response;
				})
				.always(() => {
					this.$nextTick(function () {
						this.loadingEmpresas = false;
					})
				});
		},
		getMercadologicos() {
			return this.$$service.get({}, { scriptFunction: 'getMercadologicos' })
				.then((response) => {
					this.optionsDepartamentos = response.departamentos;
					this.optionsSetores = response.setores;
					this.optionsGrupos = response.grupos;
					this.optionsFamilias = response.familias;
				})
				.always(() => {
					this.$nextTick(function () {
						this.loadingMercadologicos = false;
					})
				});
		},
		getMetas() {
			return this.$$service.get({}, { scriptFunction: 'getMetas' })
				.then((response) => {
					this.optionsMetas = response;
				})
				.always(() => {
					this.$nextTick(function () {
						this.loadingMetas = false;
					})
				});
		},
		getLocalEstoque() {
			return this.$$service.get({}, { scriptFunction: 'getLocalEstoque' })
				.then((response) => {
					this.optionsLocalEstoque = response;
				})
				.always(() => {
					this.$nextTick(function () {
						this.loadingLocalEstoque = false;
					})
				});
		},
		getPontoExposicao() {
			return this.$$service.get({}, { scriptFunction: 'getPontoExposicao' })
				.then((response) => {
					this.optionsPontoExposicao = response;
				})
				.always(() => {
					this.$nextTick(function () {
						this.loadingPontoExposicao = false;
					})
				});
		},
	},
	created() {
		
		Promise.all([
			this.getProcessos(),
			this.getEmpresas(),
			this.getMercadologicos(),
			this.getMetas(),
			this.getLocalEstoque(),
			this.getPontoExposicao()
		])
		.catch((error) => {
			console.error("Erro ao carregar opcoes iniciais:", error);
		})
		.finally(() => {
			// init dias
			for (let i = 1; i <= 31; i++) {
				this.dias.push({ dia: i, desc: i });
			}
			this.dias.push({ dia: 32, desc: "<Ultimo dia>" });
			this.dias.push({ dia: 33, desc: "<Todos>" });
			// init meses
			const meses = [ "Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez", "<Todos>" ];
			for (let i = 1; i <= 13; i++) {
				this.meses.push({ mes: i, desc: meses[i-1] });
			}
			// init anos
			const ano = new Date().getFullYear()-2;
			for (let i = 1; i <= 20; i++) {
				this.anos.push({ ano: i, desc: i+ano });
			}
			this.anos.push({ ano: 21, desc: "<Todos>" });
		});
	},
});
</script_content>

<script_content name="consts">
	const getEmptyFlowDefinition = () => ({
		drawflow: {
			Home: {
				data: {}
			}
		}
	});

	const parseJsonSafe = (raw, fallback) => {
		if (raw == null || raw === "") {
			return fallback;
		}
		try {
			return typeof raw === "string" ? JSON.parse(raw) : raw;
		} catch (e) {
			return fallback;
		}
	};

	const getEmptyAgenda = () => ({
		tipoDias: 0,
		diasSemana: "0000000",
		dias: "",
		meses: "",
		anos: "",
		datas: "",
		tipoHorarios: 1,
		tipoIntervalo: 1,
		intervalo: 30,
		horaInicial: "00:00:00",
		horaFinal: "23:59:59",
		horarios: "",
		scriptAcao: "e:1",
		_diasSemana: ["0", "0", "0", "0", "0", "0", "0"],
		_horaInicialHoraFinal: []
	});
</script_content>


<script_content name="scriptPontoExposicaoFilters">
	{
		label: "Ponto de Exposição",
		items: [
			{
				label: "Estoque Zero",
				value: "estoqueZeroPontoExposicao",
				type: "checkbox",
				placeholder: "Estoque Zero",
				optional: true,
				default: false,
				disabled: false,
			},
			{
				label: "Estoque Negativo",
				value: "estoqueNegativoPontoExposicao",
				type: "checkbox",
				placeholder: "Estoque Negativo",
				optional: true,
				default: false,
				disabled: false,
			},
			{
				label: "Estoque Positivo",
				value: "estoquePositivoPontoExposicao",
				type: "checkbox",
				placeholder: "Estoque Positivo",
				optional: true,
				default: false,
				disabled: false,
			},
			{
				label: "Ponto de Exposição",
				value: "pontoExposicao",
				type: "select",
				options: '$$store.optionsPontoExposicao',
				multiple: true,
				placeholder: "Selecione os pontos de exposição",
				optional: true,
				default: null,
				disabled: false,
			}
		]
	}
</script_content>

<script_content name="scriptEstoqueNegativoFilters">
	{
		label: "Estoque",
		items: [
			{
				label: "Estoque Zero",
				value: "estoqueZero",
				type: "checkbox",
				placeholder: "Estoque Zero",
				optional: true,
				default: false,
				disabled: false,
			},
			{
				label: "Estoque Negativo",
				value: "estoqueNegativo",
				type: "checkbox",
				placeholder: "Estoque Negativo",
				optional: true,
				default: false,
				disabled: false,
			},
			{
				label: "Estoque Positivo",
				value: "estoquePositivo",
				type: "checkbox",
				placeholder: "Estoque Positivo",
				optional: true,
				default: false,
				disabled: false,
			},
			{
				label: "Local de Estoque",
				value: "localEstoque",
				type: "select",
				options: '$$store.optionsLocalEstoque',
				multiple: true,
				placeholder: "Selecione os locais de estoque",
				optional: true,
				default: null,
				disabled: false,
			},
			{
				label: "Tipo de Local de Estoque",
				value: "tipoLocalEstoque",
				type: "select",
				options: [{ value: "C", label: "Compras" }, { value: "V", label: "Vendas" }],
				multiple: true,
				placeholder: "Selecione o tipo de local de estoque",
				optional: true,
				default: null,
				disabled: false,
			},
		]
	},
</script_content>

<script_content name="scriptCurvaABCFilters">
	{
		label: "Curva ABC",
		items: [
			{
				key: "curvaABC",
				label: "Curva ABC",
				type: "select",
				options: [{ value: "A", label: "A" }, { value: "B", label: "B" }, { value: "C", label: "C" }],
				multiple: true,
				placeholder: "Selecione a curva ABC",
				optional: true,
				default: null,
				disabled: false,
			}
		]
	},
</script_content>

<script_content name="scriptDiasSemVendaFilters">
	{
		label: "Dias Sem Venda",
		items: [
			{
				key: "diasSemVenda",
				label: "Dias Sem Venda",
				type: "number",
				placeholder: "Selecione os dias sem venda",
				optional: true,
				default: null,
				disabled: false,
				min: 0,
			},
			{
				key: "utilizaMetaDiasSemVenda",
				label: "Utiliza Meta de Dias Sem Venda",
				type: "checkbox",
				placeholder: "Utiliza Meta de Dias Sem Venda",
				optional: true,
				default: false,
				disabled: false
			},
			{
				key: "idMetaSemVendaDepartamento",
				label: "Meta do Departamento de Sem Venda",
				type: "select",
				options: '$$store.optionsMetas',
				placeholder: "Selecione a meta do departamento de sem venda",
				optional: true,
				default: null,
				disabled: false,
				vShow: "utilizaMetaDiasSemVenda"
			},
			{
				key: "idMetaSemVendaSetor",
				label: "Meta do Setor de Sem Venda",
				type: "select",
				options: '$$store.optionsMetas',
				placeholder: "Selecione a meta do setor de sem venda",
				optional: true,
				default: null,
				disabled: false,
				vShow: "utilizaMetaDiasSemVenda"
			},
			{
				key: "idMetaSemVendaGrupo",
				label: "Meta do Grupo de Sem Venda",
				type: "select",
				options: '$$store.optionsMetas',
				placeholder: "Selecione a meta do grupo de sem venda",
				optional: true,
				default: null,
				disabled: false,
				vShow: "utilizaMetaDiasSemVenda"
			},
			{
				key: "idMetaSemVendaFamilia",
				label: "Meta da Família de Sem Venda",
				type: "select",
				options: '$$store.optionsMetas',
				placeholder: "Selecione a meta da família de sem venda",
				optional: true,
				default: null,
				disabled: false,
				vShow: "utilizaMetaDiasSemVenda"
			}
		]
	},
</script_content>

<script_content name="scriptBasicFilters">
	{
		label: "Ocorrência",
		items: [
			{
				key: "naoGerarOcorrenciaSemFinalizacao",
				label: "Não gerar ocorrência para produtos sem finalização",
				type: "checkbox",
				placeholder: "Não gerar ocorrência para produtos sem finalização",
				optional: true,
				default: true,
				disabled: false,
			},
		]
	},
	{
		label: "Empresa",
		items: [
			{
				key: "empresa",
				label: "Empresa",
				type: "select",
				options: '$$store.optionsEmpresas',
				multiple: true,
				placeholder: "Selecione as empresas",
				optional: true,
				default: null,
				disabled: false,
			},
			{
				key: "ignorarEmpresa",
				label: "Ignorar Empresa",
				type: "checkbox",
				placeholder: "Ignorar Empresa",
				optional: true,
				default: false,
				disabled: false,
			}
		]
	},
	{
		label: "Mercadológicos",
		items: [
			{
				label: "Departamento",
				key: "departamento",
				type: "select",
				options: '$$store.optionsDepartamentos',
				multiple: true,
				placeholder: "Selecione os departamentos",
				optional: true,
				default: null,
				disabled: false,
			},
			{
				key: "ignorarDepartamento",
				label: "Ignorar Departamento",
				type: "checkbox",
				placeholder: "Ignorar Departamento",
				optional: true,
				default: false,
				disabled: false,
			},
			{
				key: "setor",
				label: "Setor",
				type: "select",
				options: '$$store.optionsSetores',
				multiple: true,
				placeholder: "Selecione os setores",
				optional: true,
				default: null,
				disabled: false,
			},
			{
				key: "ignorarSetor",
				label: "Ignorar Setor",
				type: "checkbox",
				placeholder: "Ignorar Setor",
				optional: true,
				default: false,
				disabled: false,
			},
			{
				key: "grupo",
				label: "Grupo",
				type: "select",
				options: '$$store.optionsGrupos',
				multiple: true,
				placeholder: "Selecione os grupos",
				optional: true,
				default: null,
				disabled: false,
			},
			{
				key: "ignorarGrupo",
				label: "Ignorar Grupo",
				type: "checkbox",
				placeholder: "Ignorar Grupo",
				optional: true,
				default: false,
				disabled: false,
			},
			{
				key: "familia",
				label: "Família",
				type: "select",
				options: '$$store.optionsFamilias',
				multiple: true,
				placeholder: "Selecione as famílias",
				optional: true,
				default: null,
				disabled: false,
			},
			{
				key: "ignorarFamilia",
				label: "Ignorar Família",
				type: "checkbox",
				placeholder: "Ignorar Família",
				optional: true,
				default: false,
				disabled: false,
			},
		]
	},
</script_content>