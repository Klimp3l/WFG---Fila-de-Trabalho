$> import com.elisha.commons.util.CryptUtil;
$> msgBuilder.setContentType('text/javascript');

const store = new Vue({
	data() {
		return {
		}
	}
});

const vueDef = {
	vueTable: {
		url: "odwctrl?action=execTarefa&scriptFunction=getList&apelido=~~~", -> $v{apelidoTarefaMae};
		columns: [
			{ prop: "id", label: "Cód.", width: 100, sortable: "custom", align: "right" },
			{ prop: "descricao", label: "Descrição", minWidth: 150, sortable: "custom", align: "left" },
			{ prop: "situacao", label: "Situação", slotName: "ativo" }
		],
		defaultFilter: { 
			situacao: '',
			descricao: '',
			id: null,
			usafilatrabalho:'',
			usanaoconformidade:''
		},
		data() {
			return {
				filterModel: tarefa.store.getItem("Filter.model") || $.extend({}, this.$options.defaultFilter),
				loading: false,
			}
		},
		methods: {
			onSortChange(obj) {
				const vm = this;

				obj.order = (obj.order === 'ascending' ? 'asc' : 'desc');
				vm.filterModel.order = obj.prop + ' ' + obj.order; 
				vm.filter(false);
			},
			onCurrentChange(currentRow, oldCurrentRow) {
				const row = $.extend({}, currentRow);
				this.$$bus.$emit("Table.currentChange", row);
			},
			fetch(params) {
				return this.$$ui.fetchTable(this, "table", this.$options.url, params);
			},
			filter(resetPageIndex) {
				const filterModel = JSON.stringify(this.filterModel);
				tarefa.store.setItem("Filter.model", filterModel);
				this.$refs.table.searchHandler(resetPageIndex);
			},
			reset() {
				this.filterModel = $.extend({}, this.$options.defaultFilter);
				this.$nextTick(function () {
			        this.filter(true);
		      	});
			}
		},
		mounted() {
			this.$$bus.$on("FormEdit.update", () => {
				this.filter(false);
			});
		}
	},
	vueFormEdit: {
		defaultEdit: { 
			id: null,
			situacao: 'A',
			usanaoconformidade: 'N',
			usafilatrabalho:'N',
		},
		data() {
			return {
				editModel: $.extend({}, this.$options.defaultEdit),

				loading: false,
				action: "insert",

				rules: {
					descricao: [
						{ required: true, message: "Descrição precisa ser informado", trigger: "blur" }
					],
				}
			}
		},
		methods: {
			insert() {
				this.action = "insert";
				this.reset();
			},
			edit(data) {
				this.$refs.formEdit.clearValidate();
				this.action = "update";
				this.editModel = $.extend(true, {}, this.$options.defaultEdit, data);
				
			},
			save() {
				this.$refs.formEdit.validate((valid) => {
					if (valid) {
						this.loading = true;
						const  { editModel } = this;
						let promisse = service.save({ model: JSON.stringify(editModel) }, this.action);
						promisse
							.done((response) => {
							    if (response.error == '') {
							    	this.$$ui.showSuccessMessage(response.msg);
							    	this.$$bus.$emit("FormEdit.update");
							    	this.insert();
							    } else {
							    	this.$$ui.showErrorMessage(response.msg, response.error);
							    }
							})
							.fail(() => {
								this.$$ui.showErrorMessage("Não foi possível gravar este registro");
							})
							.always(() => {
								setTimeout(() => {
									this.loading = false;
								}, 500);
							});
					} else {
						return false;
					}
				});
			},
			reset() {
				this.editModel = $.extend({}, this.$options.defaultEdit);
			},
			remove() {
				this.$$ui.showConfirmDeleteMessage()
					.then(() => {
						this.loading = true;
						service.remove({ id: this.editModel.id })
							.done((response) => {
							    if (response.error == '') {
							    	this.$$ui.showSuccessMessage(response.msg);
							    	this.$$bus.$emit("FormEdit.update");
							    	this.insert();
							    } else {
							    	this.$$ui.showErrorMessage(response.msg, response.error);
							    }
							})
							.fail(() => {
								this.$$ui.showErrorMessage("Não foi possível excluir este registro");
							})
							.always(() => {
								setTimeout(() => {
									this.loading = false;
								}, 500);
							});
			        }).catch(() => {
			        });
			},
		},
		mounted() {
			this.$$bus.$on("Table.currentChange", (data) => {
				if (data.id) {
					this.edit(data);
				} else {
					this.insert();
				}
			});
			this.insert();
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
