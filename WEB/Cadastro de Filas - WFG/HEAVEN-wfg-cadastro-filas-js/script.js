$> import com.elisha.commons.util.CryptUtil;
$> msgBuilder.setContentType('text/javascript');

// Auxiliares: Store, scriptBasicFilters, scriptDiasSemVendaFilters, scriptCurvaABCFilters, scriptEstoqueNegativoFilters, consts
$include{notif:HEAVEN-wfg-cadastro-filas-parte2-js}include
$include{notif:HEAVEN-wfg-cadastro-filas-parte3-js}include

const vueDef = {
	vueTable: {
		url: "odwctrl?action=execTarefa&scriptFunction=getList&apelido=~~~", -> $v{apelidoTarefaMae};
		columns: [
			{ prop: "id", label: "Cód.", width: 90, sortable: "custom", align: "right" },
			{ prop: "descricao", label: "Descrição da Fila", minWidth: 240, sortable: "custom" },
			{ prop: "wfprocessodescricao", label: "Processo", minWidth: 180, sortable: "custom" },
			{ prop: "wfprocessoeventodescricao", label: "Evento", minWidth: 180, sortable: "custom" },
			{ prop: "ativo", label: "Ativo", width: 80, slotName: "ativo" }
		],
		defaultFilter: {
			id: null,
			descricao: "",
			situacao: "A"
		},
		data() {
			return {
				filterModel: tarefa.store.getItem("Filter.wfgFila.model") || $.extend({}, this.$options.defaultFilter),
				loading: false,
				selectedRow: null,
				dialogNodeVisible: false,
				newNodeTaskAlias: null,
				addNodeSourceNodeId: null,
				addNodeTaskOptions: [],
				_terminalPlusTimer: null,
				isEnsuringStartNode: false,
				flowStatusTick: 0,
				drawflowError: "",
				drawflowEditor: null,
				drawflowZoomLabel: "100%",
				isImportingFlow: false,
				flowByFila: {},
				nodeFiltersByFila: {},
				selectedDrawflowNodeId: null,
				sidePanelTask: null,
				sidePanelValues: {},
				availableNodeTasks: [
					{
						nome: "Expirar Ocorrência",
						apelido: "HEAVEN-wfg-expira-wfocorrencia"
					},
					{
						nome: "Expirar Fila de Trabalho",
						apelido: "HEAVEN-wfg-expira-wffilatrabalho"
					},
					{
						nome: "Gera Ocorrência",
						apelido: "HEAVEN-wfg-gera-ocorrencia-generica",
						filters: [
							$> sb.append(scriptBasicFilters());
							$> sb.append(scriptCurvaABCFilters());
							$> sb.append(scriptDiasSemVendaFilters());
							$> sb.append(scriptEstoqueNegativoFilters());
							$> sb.append(scriptPontoExposicaoFilters());
						]
					},
					{
						nome: "Finaliza Fila",
						apelido: "HEAVEN-wfg-finaliza-fila-trabalho-generica",
						filters: [
							$> sb.append(scriptAtividadeRealizadaFinalizacaoFilters());
						]
					},
				]
			};
		},
		methods: {
			onSortChange(obj) {
				obj.order = obj.order === "ascending" ? "asc" : "desc";
				this.filterModel.order = obj.prop + " " + obj.order;
				this.filter(false);
			},
			onCurrentChange(currentRow) {
				const row = $.extend({}, currentRow);
				this.selectedRow = row && row.id ? row : null;
				this.addNodeSourceNodeId = null;
				this.addNodeTaskOptions = [];
				this.selectedDrawflowNodeId = null;
				this.sidePanelTask = null;
				this.sidePanelValues = {};
				
				if (this.selectedRow && this.selectedRow.id) {
					const fk = String(this.selectedRow.id);
					const parsed = parseJsonSafe(this.selectedRow.nodefiltersjson, {});
					if (!this.nodeFiltersByFila[fk]) {
						this.$set(this.nodeFiltersByFila, fk, {});
					}
					Object.keys(parsed).forEach((nodeId) => {
						this.$set(this.nodeFiltersByFila[fk], nodeId, $.extend({}, parsed[nodeId] || {}));
					});
				}
				
				this.loadDrawflowBySelectedRow();
				this.$$bus.$emit("Table.currentChange", row);
			},
			fetch(params) {
				return this.$$ui.fetchTable(this, "table", this.$options.url, params);
			},
			filter(resetPageIndex) {
				tarefa.store.setItem("Filter.wfgFila.model", JSON.stringify(this.filterModel));
				this.selectedRow = null;
				this.clearDrawflow();
				this.$refs.table.searchHandler(resetPageIndex);
			},
			reset() {
				this.filterModel = $.extend({}, this.$options.defaultFilter);
				this.selectedRow = null;
				this.clearDrawflow();
				this.$nextTick(() => this.filter(true));
			},
			openInsert() {
				this.$$bus.$emit("FormEdit.openInsert");
			},
			openEdit() {
				if (!this.selectedRow || !this.selectedRow.id) {
					return this.$$ui.showWarningMessage("Selecione uma fila para editar.");
				}
				this.$$bus.$emit("FormEdit.openEdit", this.selectedRow);
			},
			openCopy() {
				if (!this.selectedRow || !this.selectedRow.id) {
					return this.$$ui.showWarningMessage("Selecione uma fila para copiar.");
				}
				this.$$bus.$emit("FormEdit.openCopy", this.selectedRow);
			},
			$> sb.append(drawflowJs());
			$> sb.append(drawflowJs2());
			$> sb.append(drawflowJs3());
		},
		computed: {
			nodeCountSelected() {
				if (!this.selectedRow || !this.selectedRow.id) {
					return 0;
				}
				const key = String(this.selectedRow.id);
				const cached = this.flowByFila[key];
				if (cached && cached.drawflow) {
					const mod = cached.drawflow || {};
					const home = mod.Home || mod[Object.keys(mod)[0]];
					return Object.keys((home && home.data) || {}).length;
				}
				if (!this.drawflowEditor) {
					return 0;
				}
				try {
					const exported = this.exportCurrentFlow();
					const inner = exported.drawflow || {};
					const moduleName = this.drawflowEditor.module || "Home";
					return Object.keys(((inner[moduleName] || {}).data) || {}).length;
				} catch (e) {
					return 0;
				}
			},
			flowIsValid() {
				if (!this.selectedRow || !this.selectedRow.id || !this.drawflowEditor || typeof this.isFlowConnectivityValid !== "function") {
					return false;
				}
				try {
					const _tick = this.flowStatusTick;
					const flowDefinition = this.exportCurrentFlow();
					const moduleData = this.getCurrentModuleData(flowDefinition);
					return _tick >= 0 && this.isFlowConnectivityValid(moduleData);
				} catch (e) {
					return false;
				}
			},
			flowStatusText() {
				return this.flowIsValid ? "Válido" : "Inválido";
			},
			flowStatusClass() {
				return this.flowIsValid ? "ok" : "warning";
			}
		},
		mounted() {
			this.$$bus.$on("FormEdit.update", () => this.filter(false));
			this.$$bus.$on("Wfg.collectSaveExtras", (filaId) => {
				const payload = { nodefilters: {}, wfgNodes: [] };
				if (this.selectedRow && String(this.selectedRow.id) === String(filaId)) {
					payload.nodefilters = $.extend(true, {}, this.nodeFiltersByFila[String(filaId)] || {});
					payload.wfgNodes = this.buildWfgNodesForPersist();
				}
				if (typeof tarefa !== "undefined") {
					tarefa.wfgSaveExtras = payload;
				}
			});
			this.$nextTick(() => {
				this.ensureDrawflowEditor();
				this.scheduleRefreshTerminalNodePlus();
				setTimeout(() => {
					if (this.$refs.filter_descricao) {
						this.$refs.filter_descricao.focus();
					}
				}, 350);
			});
		}
	},
	vueFormEdit: {
		defaultEdit: {
			id: null,
			situacao: "A",
			idwfprocesso: null,
			idwfprocessoevento: null,
		},
		data() {
			return {
				editModel: $.extend(true, {}, this.$options.defaultEdit, getEmptyAgenda()),

				collapseAgendaNames: ["collapseDias", "collapseHoras"],

				loading: false,

				dialogVisible: false,
				dialogDiasVisible: false,
				dialogMesesVisible: false,
				dialogAnosVisible: false,
				dialogDatasVisible: false,
				dialogHorariosVisible: false,

				action: "insert",

				dialogDias: {
					dias: []
				},
				dialogMeses: {
					meses: []
				},
				dialogAnos: {
					anos: []
				},
				dialogDatas: {
					datas: []
				},
				dialogHorarios: {
					intervalo: 30,
					horaInicialHoraFinal: [new Date(2018, 1, 1, 0, 0, 0), new Date(2018, 1, 1, 23, 59, 59)],
					horarios: [],
					_horarios: []
				},

				rules: {
					descricao: [
						{ required: true, message: "Descrição da fila é obrigatória", trigger: "blur" }
					],
					idwfprocesso: [
						{ required: true, message: "Processo é obrigatório", trigger: "change" }
					],
					idwfprocessoevento: [
						{ required: true, message: "Evento é obrigatório", trigger: "change" }
					]
				}
			};
		},
		methods: {
			insert() {
				this.action = "insert";
				this.editModel = $.extend(true, {}, this.$options.defaultEdit, getEmptyAgenda());
				this.dialogVisible = true;
				if (this.$refs.formEdit) {
					this.$refs.formEdit.clearValidate();
				}
				this.firstFocus();
			},
			copy(data) {
				this.action = "insert-copy";
				this.dialogVisible = true;
				
				if (data && data.id) {
					this.editModel = $.extend(true, {}, this.$options.defaultEdit, data, {id: null}, getEmptyAgenda(), parseJsonSafe(data.agendajson, {}));
					delete this.editModel.agendajson;
				} else {
					this.editModel.id = null;
				}
				
				if (this.$refs.formEdit) {
					this.$refs.formEdit.clearValidate();
				}
				
				this.firstFocus();
			},
			edit(data) {
				this.action = "update";
				
				this.editModel = $.extend(true, {}, this.$options.defaultEdit, data);
				this.$$store.optionsEventos = this.$$store.optionsProcessos.find(x => x.value == this.editModel.idwfprocesso).eventos;

				let diasSemana = this.editModel.diasSemana || "0000000" ;
				this.$set(this.editModel, "_diasSemana", []);
				for (let i in diasSemana) {
					this.editModel._diasSemana.push(diasSemana.charAt(i));
				}
				this.$set(this.editModel, "_horaInicialHoraFinal", [ moment(data.horaInicial, "HH:mm:ss").toDate(), moment(data.horaFinal, "HH:mm:ss").toDate() ]);
				
				if (this.$refs.formEdit) {
					this.$refs.formEdit.clearValidate();
				}

				console.log(this.editModel);

				this.$nextTick(() => {
					this.dialogVisible = true;
					this.firstFocus();
				});
			},
	      	showDialogHorarios() {
	      		this.dialogHorariosRefresh();
	      		this.dialogHorariosVisible = true;
	      	},
	      	dialogDiasOK() {
	      		this.dialogDiasMesesAnosOK(this.$options.dias, this.dialogDias.dias, "dias", "dialogDiasVisible");
	      	},
	      	dialogMesesOK() {
	      		this.dialogDiasMesesAnosOK(this.$options.meses, this.dialogMeses.meses, "meses", "dialogMesesVisible");
	      	},
	      	dialogAnosOK() {
	      		this.dialogDiasMesesAnosOK(this.$options.anos, this.dialogAnos.anos, "anos", "dialogAnosVisible");
	      	},
	      	dialogDatasOK() {
	      		this.editModel.datas = this.dialogDatas.datas.join(", ");
	      		this.dialogDatasVisible = false;
	      	},
	      	dialogHorariosOK() {
	      		this.dialogDiasMesesAnosOK(this.dialogHorarios._horarios, this.dialogHorarios.horarios, "horarios", "dialogHorariosVisible");
	      	},
	      	dialogDiasMesesAnosOK(array, modelArray, model, visible) {
	      		modelArray.sort(function(a, b){return a-b});
	      		this.editModel[model] = "";
	      		for (i in modelArray) {
	      			this.editModel[model] += (i == 0 ? "" : ", ") + array[modelArray[i]-1].desc;
	      		}
	      		this[visible] = false;
	      	},
	      	dialogHorariosRefresh() {
	      		let dataInicial = moment(this.dialogHorarios.horaInicialHoraFinal[0]);
	      		let dataFinal = moment(this.dialogHorarios.horaInicialHoraFinal[1]);
	      		let horarios = [];
	      		let hms;
	      		let i = 0;
	      		while (dataInicial.isBefore(dataFinal)) {
	      			hms = dataInicial.format("HH:mm:ss");
	      			horarios.push({ horario: ++i, desc: hms });
	      			dataInicial = dataInicial.add(this.dialogHorarios.intervalo, "minutes");
	      		}
	      		this.dialogHorarios._horarios = horarios;
	      	},
			firstFocus() {
				this.$nextTick(() => {
					if (this.$refs.edit_descricao) {
						this.$refs.edit_descricao.focus();
					}
				});
			},
			onChangeProcesso(idprocesso) {
				this.editModel.idwfprocessoevento = null;
				this.$$store.optionsEventos = this.$$store.optionsProcessos.find(x => x.value == idprocesso).eventos;
			},
			save() {
				this.$refs.formEdit.validate((valid) => {
					if (!valid) {
						return this.$$ui.showWarningMessage("Preencha os campos obrigatórios.");
					}
					this.loading = true;
					
					const model = $.extend(true, {}, this.editModel);
					
					model.diasSemana = model._diasSemana.join().replace(/,/g,"");
					model.horaInicial = moment(this.editModel._horaInicialHoraFinal[0]).format("HHmmss");
					model.horaFinal = moment(this.editModel._horaInicialHoraFinal[1]).format("HHmmss");
					
					this.$$service.save({ model: JSON.stringify(model) }, this.action)
						.done((response) => {
							if (response.error == '') {
								this.$$ui.showSuccessMessage(response.msg);
								this.$$bus.$emit("FormEdit.update");
								this.dialogVisible = false;
								this.action = "update";
							} else {
								this.$$ui.showErrorMessage(response.msg, response.error);
							}
						})
						.fail(() => {
							this.$$ui.showErrorMessage("Não foi possível gravar este registro.");
						})
						.always(() => {
							setTimeout(() => { this.loading = false; }, 350);
						});
				});
			},
		},
		mounted() {
			this.$$bus.$on("FormEdit.openInsert", () => this.insert());
			this.$$bus.$on("FormEdit.openEdit", (data) => this.edit(data));
			this.$$bus.$on("FormEdit.openCopy", (data) => this.copy(data));
		},
		computed: {
			editFormTitle() {
				return (this.action == "insert" ? "Incluir" : this.action == "insert-copy" ? "Incluir (Cópia)" : "Editar");
			}
		}
	},
	init() {
		for (let property in this) {
			let component = this[property];
			if (typeof component === "object") {
				component.el = "#" + property;
				this[property] = new Vue(component);
			}
		}
		return this;
	}
}.init();
