
<script_content name="drawflowJs">
	ensureDrawflowEditor() {
		if (this.drawflowEditor) {
			return true;
		}
		
		if (typeof Drawflow === "undefined") {
			this.drawflowError = "Drawflow não carregado. Verifique a CDN e recarregue a página.";
			return false;
		}
		
		const container = document.getElementById("drawflowEditor");

		this.drawflowError = "";
		this.drawflowEditor = new Drawflow(container);
		this.drawflowEditor.reroute = true;
		this.drawflowEditor.start();
		this.protectStartNodeRemoval();

		const onChange = () => this.handleFlowChanged();
		this.drawflowEditor.on("nodeCreated", onChange);
		this.drawflowEditor.on("nodeRemoved", onChange);
		this.drawflowEditor.on("nodeMoved", onChange);
		this.drawflowEditor.on("connectionCreated", onChange);
		this.drawflowEditor.on("connectionRemoved", onChange);
		this.drawflowEditor.on("nodeSelected", (id) => this.onDrawflowNodeSelected(id));
		this.drawflowEditor.on("nodeUnselected", () => this.onDrawflowNodeUnselected());
		container.addEventListener("click", (evt) => {
			const plusBtn = evt.target && evt.target.closest ? evt.target.closest(".wfg-terminal-plus-btn") : null;
			if (!plusBtn) {
				return;
			}
			evt.preventDefault();
			evt.stopPropagation();
			const nodeId = plusBtn.getAttribute("data-source-node-id");
			if (!nodeId) {
				return;
			}
			this.openAddNodeDialog(nodeId);
		});

		console.log(this.drawflowEditor);
		
		return true;
	},
	getNodeBoundsForFit(moduleData, container) {
		const data = moduleData || {};
		const nodeIds = Object.keys(data);
		if (!nodeIds.length) {
			return null;
		}
		let minX = Number.POSITIVE_INFINITY;
		let minY = Number.POSITIVE_INFINITY;
		let maxX = Number.NEGATIVE_INFINITY;
		let maxY = Number.NEGATIVE_INFINITY;
		nodeIds.forEach((nodeId) => {
			const node = data[nodeId] || {};
			const posX = Number(node.pos_x || 0);
			const posY = Number(node.pos_y || 0);
			let nodeWidth = 220;
			let nodeHeight = 90;
			if (container && container.querySelector) {
				const nodeEl = container.querySelector(`#node-${nodeId}`);
				if (nodeEl) {
					nodeWidth = nodeEl.offsetWidth || nodeWidth;
					nodeHeight = nodeEl.offsetHeight || nodeHeight;
				}
			}
			minX = Math.min(minX, posX);
			minY = Math.min(minY, posY);
			maxX = Math.max(maxX, posX + nodeWidth);
			maxY = Math.max(maxY, posY + nodeHeight);
		});
		if (!isFinite(minX) || !isFinite(minY) || !isFinite(maxX) || !isFinite(maxY)) {
			return null;
		}
		return { minX, minY, maxX, maxY };
	},
	applyDrawflowTransform(zoom, canvasX, canvasY) {
		if (!this.drawflowEditor || !this.drawflowEditor.precanvas) {
			return;
		}
		this.drawflowEditor.zoom = zoom;
		this.drawflowEditor.canvas_x = canvasX;
		this.drawflowEditor.canvas_y = canvasY;
		this.drawflowEditor.precanvas.style.transform = `translate(${canvasX}px, ${canvasY}px) scale(${zoom})`;
	},
	fitFlowToView() {
		if (!this.selectedRow || !this.selectedRow.id || !this.ensureDrawflowEditor()) {
			return;
		}
		const container = document.getElementById("drawflowEditor");
		if (!container) {
			return;
		}
		const flowDefinition = this.exportCurrentFlow();
		const moduleData = this.getCurrentModuleData(flowDefinition);
		const bounds = this.getNodeBoundsForFit(moduleData, container);
		if (!bounds) {
			if (typeof this.drawflowEditor.zoom_reset === "function") {
				this.drawflowEditor.zoom_reset();
			}
			return;
		}
		const padding = 40;
		const viewportWidth = Math.max((container.clientWidth || 0) - (padding * 2), 1);
		const viewportHeight = Math.max((container.clientHeight || 0) - (padding * 2), 1);
		const contentWidth = Math.max(bounds.maxX - bounds.minX, 1);
		const contentHeight = Math.max(bounds.maxY - bounds.minY, 1);
		const ratioX = viewportWidth / contentWidth;
		const ratioY = viewportHeight / contentHeight;
		const minZoom = this.drawflowEditor.zoom_min || 0.2;
		const maxZoom = this.drawflowEditor.zoom_max || 1.6;
		let targetZoom = Math.min(ratioX, ratioY);
		if (!isFinite(targetZoom) || targetZoom <= 0) {
			targetZoom = 1;
		}
		targetZoom = Math.max(minZoom, Math.min(maxZoom, targetZoom));
		const boundsCenterX = bounds.minX + (contentWidth / 2);
		const boundsCenterY = bounds.minY + (contentHeight / 2);
		const canvasX = (container.clientWidth / 2) - (boundsCenterX * targetZoom);
		const canvasY = (container.clientHeight / 2) - (boundsCenterY * targetZoom);
		this.applyDrawflowTransform(targetZoom, canvasX, canvasY);
	},
	scheduleFitFlowToView() {
		this.$nextTick(() => {
			setTimeout(() => this.fitFlowToView(), 0);
		});
	},
	getCurrentModuleName() {
		return (this.drawflowEditor && this.drawflowEditor.module) ? this.drawflowEditor.module : "Home";
	},
	getCurrentModuleData(flowDefinition) {
		const moduleName = this.getCurrentModuleName();
		const inner = ((flowDefinition || {}).drawflow) || {};
		return ((inner[moduleName] || {}).data) || {};
	},
	isStartNode(node) {
		const data = (node || {}).data || {};
		return !!data.isStartNode;
	},
	nodeHasOutputConnection(node) {
		if (!node || !node.outputs) {
			return false;
		}
		const outputs = node.outputs || {};
		return Object.keys(outputs).some((outputKey) => {
			const out = outputs[outputKey] || {};
			return Array.isArray(out.connections) && out.connections.length > 0;
		});
	},
	nodeHasInputConnection(node) {
		if (!node || !node.inputs) {
			return false;
		}
		const inputs = node.inputs || {};
		return Object.keys(inputs).some((inputKey) => {
			const inp = inputs[inputKey] || {};
			return Array.isArray(inp.connections) && inp.connections.length > 0;
		});
	},
	nodeHasAnyConnection(node) {
		return this.nodeHasInputConnection(node) || this.nodeHasOutputConnection(node);
	},
	isFlowConnectivityValid(moduleData) {
		const data = moduleData || {};
		const nodeIds = Object.keys(data);
		if (!nodeIds.length) {
			return false;
		}
		return nodeIds.every((nodeId) => this.nodeHasAnyConnection(data[nodeId]));
	},
	findStartNodeId(moduleData) {
		const data = moduleData || {};
		const startId = Object.keys(data).find((nodeId) => this.isStartNode(data[nodeId]));
		return startId ? String(startId) : null;
	},
	isStartNodeId(nodeId) {
		if (nodeId == null || nodeId === "") {
			return false;
		}
		const moduleData = this.getCurrentModuleData(this.exportCurrentFlow());
		const node = moduleData[String(nodeId)] || null;
		return this.isStartNode(node);
	},
	normalizeRemovedNodeId(nodeIdOrSelector) {
		if (nodeIdOrSelector == null || nodeIdOrSelector === "") {
			return null;
		}
		const raw = String(nodeIdOrSelector);
		return raw.startsWith("node-") ? raw.replace("node-", "") : raw;
	},
	protectStartNodeRemoval() {
		if (!this.drawflowEditor || this.drawflowEditor._wfgStartNodeGuardInstalled) {
			return;
		}
		const originalRemoveNodeId = this.drawflowEditor.removeNodeId;
		if (typeof originalRemoveNodeId !== "function") {
			return;
		}
		this.drawflowEditor.removeNodeId = (nodeIdOrSelector) => {
			const nodeId = this.normalizeRemovedNodeId(nodeIdOrSelector);
			if (this.isStartNodeId(nodeId)) {
				if (this.$$ui && typeof this.$$ui.showWarningMessage === "function") {
					this.$$ui.showWarningMessage("O nó de Início não pode ser excluído.");
				}
				return false;
			}
			return originalRemoveNodeId.call(this.drawflowEditor, nodeIdOrSelector);
		};
		this.drawflowEditor._wfgStartNodeGuardInstalled = true;
	},
	getNextConnectedNodeId(node) {
		if (!node || !node.outputs) {
			return null;
		}
		const outputs = node.outputs || {};
		const outputKeys = Object.keys(outputs);
		for (let i = 0; i < outputKeys.length; i++) {
			const out = outputs[outputKeys[i]] || {};
			const connections = Array.isArray(out.connections) ? out.connections : [];
			if (!connections.length) {
				continue;
			}
			const targetId = connections[0] && connections[0].node;
			if (targetId != null && targetId !== "") {
				return String(targetId);
			}
		}
		return null;
	},
	getOrderedNodeIdsForPersist(moduleData) {
		const data = moduleData || {};
		const ordered = [];
		const visited = new Set();
		const startNodeId = this.findStartNodeId(data);
		let currentId = startNodeId;

		// Percorre encadeamento principal partindo do nó Início.
		while (currentId && !visited.has(String(currentId)) && data[String(currentId)]) {
			const nodeId = String(currentId);
			visited.add(nodeId);
			const node = data[nodeId] || {};
			if (!this.isStartNode(node)) {
				ordered.push(nodeId);
			}
			const nextId = this.getNextConnectedNodeId(node);
			currentId = nextId ? String(nextId) : null;
		}

		// Mantém nós fora da cadeia no final para não perder dados em cenários quebrados.
		Object.keys(data)
			.sort((a, b) => parseInt(a, 10) - parseInt(b, 10))
			.forEach((nodeId) => {
				if (visited.has(String(nodeId))) {
					return;
				}
				const node = data[nodeId] || {};
				if (!this.isStartNode(node)) {
					ordered.push(String(nodeId));
				}
			});

		return ordered;
	},
	ensureStartNodeExists() {
		if (!this.selectedRow || !this.selectedRow.id || !this.ensureDrawflowEditor() || this.isEnsuringStartNode) {
			return null;
		}
		const moduleData = this.getCurrentModuleData(this.exportCurrentFlow());
		const existingStartId = this.findStartNodeId(moduleData);
		if (existingStartId) {
			return existingStartId;
		}
		this.isEnsuringStartNode = true;
		let startNodeId = null;
		try {
			const startHtml = `<div class="wfg-df-node-content"><div class="wfg-df-node-title">Início</div><div class="wfg-df-node-subtitle">Nó inicial do fluxo</div></div>`;
			startNodeId = this.drawflowEditor.addNode(
				"WFG_START",
				0,
				1,
				70,
				120,
				"wfg-df-node wfg-df-start-node",
				{ apelido: "", nome: "Início", isStartNode: true },
				startHtml,
				false
			);

			const freshData = this.getCurrentModuleData(this.exportCurrentFlow());
			const firstNodeId = Object.keys(freshData)
				.filter((nodeId) => String(nodeId) !== String(startNodeId) && !this.isStartNode(freshData[nodeId]))
				.sort((a, b) => parseInt(a, 10) - parseInt(b, 10))
				.find((nodeId) => !this.nodeHasInputConnection(freshData[nodeId]));
			if (firstNodeId) {
				try {
					this.drawflowEditor.addConnection(String(startNodeId), String(firstNodeId), "output_1", "input_1");
				} catch (e) {
				}
			}
		} finally {
			this.isEnsuringStartNode = false;
		}
		return startNodeId != null ? String(startNodeId) : null;
	},
	getTerminalNodeId(moduleData) {
		const data = moduleData || {};
		const nodeIds = Object.keys(data);
		if (!nodeIds.length) {
			return null;
		}
		const terminalIds = nodeIds.filter((nodeId) => !this.nodeHasOutputConnection(data[nodeId]));
		if (!terminalIds.length) {
			return null;
		}
		if (this.selectedDrawflowNodeId && terminalIds.includes(String(this.selectedDrawflowNodeId))) {
			return String(this.selectedDrawflowNodeId);
		}
		return terminalIds.sort((a, b) => parseInt(a, 10) - parseInt(b, 10)).pop();
	},
	scheduleRefreshTerminalNodePlus() {
		clearTimeout(this._terminalPlusTimer);
		this._terminalPlusTimer = setTimeout(() => this.refreshTerminalNodePlus(), 0);
	},
	refreshTerminalNodePlus() {
		const container = document.getElementById("drawflowEditor");
		if (!container || !this.drawflowEditor || this.drawflowError) {
			return;
		}
		container.querySelectorAll(".wfg-terminal-plus-btn").forEach((el) => el.remove());
		container.querySelectorAll(".drawflow-node.wfg-terminal-node").forEach((el) => el.classList.remove("wfg-terminal-node"));
		if (!this.selectedRow || !this.selectedRow.id) {
			return;
		}
		this.ensureStartNodeExists();
		const moduleData = this.getCurrentModuleData(this.exportCurrentFlow());
		const terminalNodeId = this.getTerminalNodeId(moduleData);
		if (!terminalNodeId) {
			return;
		}
		const terminalNodeEl = container.querySelector(`#node-${terminalNodeId}`);
		if (!terminalNodeEl) {
			return;
		}
		terminalNodeEl.classList.add("wfg-terminal-node");
		const plusBtn = document.createElement("button");
		plusBtn.type = "button";
		plusBtn.className = "wfg-terminal-plus-btn";
		plusBtn.setAttribute("data-source-node-id", String(terminalNodeId));
		plusBtn.setAttribute("title", "Adicionar ligação a partir deste nó");
		plusBtn.innerHTML = "+";
		terminalNodeEl.appendChild(plusBtn);
	},
	getSelectableTasksForAddNode() {
		if (!this.ensureDrawflowEditor()) {
			return [];
		}
		const moduleData = this.getCurrentModuleData(this.exportCurrentFlow());
		const usedAliases = new Set();
		Object.keys(moduleData).forEach((nodeId) => {
			const node = moduleData[nodeId] || {};
			const data = node.data || {};
			const alias = (data.apelido || node.name || "").toString().trim();
			if (alias) {
				usedAliases.add(alias);
			}
		});
		return this.availableNodeTasks.filter((task) => !usedAliases.has(String(task.apelido || "")));
	},
</script_content>

<script_content name="drawflowJs2">
	openAddNodeDialog(sourceNodeId = null) {
		if (!this.selectedRow || !this.selectedRow.id) {
			return this.$$ui.showWarningMessage("Selecione uma fila antes de adicionar um nó.");
		}
		if (!this.ensureDrawflowEditor()) {
			return this.$$ui.showWarningMessage(this.drawflowError || "Não foi possível iniciar o editor de fluxo.");
		}
		const options = this.getSelectableTasksForAddNode();
		if (!options.length) {
			return this.$$ui.showWarningMessage("Não há tarefas disponíveis para adicionar.");
		}
		this.addNodeSourceNodeId = sourceNodeId != null ? String(sourceNodeId) : null;
		this.addNodeTaskOptions = options;
		this.newNodeTaskAlias = null;
		this.dialogNodeVisible = true;
	},
	confirmAddNode() {
		if (!this.newNodeTaskAlias) {
			return this.$$ui.showWarningMessage("Selecione uma tarefa para adicionar ao fluxo.");
		}

		const options = this.getSelectableTasksForAddNode();
		this.addNodeTaskOptions = options;
		const task = options.find(item => item.apelido === this.newNodeTaskAlias);
		if (!task) {
			return this.$$ui.showWarningMessage("Tarefa inválida ou já adicionada no fluxo.");
		}
		if (!this.ensureDrawflowEditor()) {
			return this.$$ui.showWarningMessage(this.drawflowError || "Não foi possível iniciar o editor de fluxo.");
		}

		const currentFlow = this.exportCurrentFlow();
		const moduleData = this.getCurrentModuleData(currentFlow);
		const count = Object.keys(moduleData).length;
		const posX = 90 + ((count % 3) * 260);
		const posY = 90 + (Math.floor(count / 3) * 140);
		const nodeHtml = `<div class="wfg-df-node-content"><div class="wfg-df-node-title">${task.nome}</div><div class="wfg-df-node-subtitle">${task.apelido}</div></div>`;

		const newNodeId = this.drawflowEditor.addNode(
			task.apelido,
			1,
			1,
			posX,
			posY,
			"wfg-df-node",
			{ apelido: task.apelido, nome: task.nome },
			nodeHtml,
			false
		);
		if (this.addNodeSourceNodeId && newNodeId != null) {
			try {
				this.drawflowEditor.addConnection(String(this.addNodeSourceNodeId), String(newNodeId), "output_1", "input_1");
			} catch (e) {
			}
		}
		this.dialogNodeVisible = false;
		this.addNodeSourceNodeId = null;
		this.addNodeTaskOptions = [];
		this.handleFlowChanged();
	},

	buildNodesMetadata(flowDefinition) {
		const metadata = {};
		const drawflow = (flowDefinition || {}).drawflow || {};
		Object.keys(drawflow).forEach((moduleName) => {
			const moduleData = (((drawflow[moduleName] || {}).data) || {});
			Object.keys(moduleData).forEach((nodeId) => {
				const node = moduleData[nodeId] || {};
				const data = node.data || {};
				metadata[nodeId] = {
					nome: data.nome || "",
					apelido: data.apelido || node.name || ""
				};
			});
		});
		return metadata;
	},
	parseFlowFromRow(row) {
		if (!row || !row.flowjson) {
			return getEmptyFlowDefinition();
		}
		try {
			const parsed = typeof row.flowjson === "string" ? JSON.parse(row.flowjson) : row.flowjson;
			if (parsed && parsed.drawflow && parsed.drawflow.drawflow) {
				return parsed.drawflow;
			}
			if (parsed && parsed.drawflow) {
				return parsed;
			}
		} catch (e) {
		}
		return getEmptyFlowDefinition();
	},
	wrapFlow(flowDefinition) {
		const normalized = flowDefinition && flowDefinition.drawflow ? flowDefinition : getEmptyFlowDefinition();
		return {
			version: 1,
			drawflow: normalized,
			nodesMetadata: this.buildNodesMetadata(normalized)
		};
	},
	clearDrawflow() {
		if (!this.drawflowEditor) {
			return;
		}
		this.isImportingFlow = true;
		try {
			this.drawflowEditor.clear();
		} catch (e) {
		}
		this.isImportingFlow = false;
		this.refreshTerminalNodePlus();
	},
	exportCurrentFlow() {
		if (!this.drawflowEditor) {
			return getEmptyFlowDefinition();
		}
		try {
			const exported = this.drawflowEditor.export();
			return exported && exported.drawflow ? exported : getEmptyFlowDefinition();
		} catch (e) {
			return getEmptyFlowDefinition();
		}
	},
	importFlowToEditor(flowDefinition) {
		if (!this.ensureDrawflowEditor()) {
			return;
		}
		this.isImportingFlow = true;
		try {
			this.drawflowEditor.clear();
			this.drawflowEditor.import(flowDefinition || getEmptyFlowDefinition());
		} catch (e) {
		}
		this.isImportingFlow = false;
		this.flowStatusTick = (this.flowStatusTick || 0) + 1;
		this.scheduleRefreshTerminalNodePlus();
	},
	loadDrawflowBySelectedRow() {
		if (!this.selectedRow || !this.selectedRow.id) {
			this.clearDrawflow();
			return;
		}
		this.$nextTick(() => {
			if (!this.ensureDrawflowEditor()) {
				return;
			}
			const key = String(this.selectedRow.id);
			if (!this.flowByFila[key]) {
				this.flowByFila[key] = this.parseFlowFromRow(this.selectedRow);
			}
			this.importFlowToEditor(this.flowByFila[key]);
			this.ensureDefaultNodesForNewRow();
			this.scheduleFitFlowToView();
		});
	},
	syncCurrentFlowInMemory() {
		if (!this.selectedRow || !this.selectedRow.id) {
			return;
		}
		const key = String(this.selectedRow.id);
		const exported = this.exportCurrentFlow();
		this.flowByFila[key] = exported;
		this.selectedRow.flowjson = JSON.stringify(this.wrapFlow(exported));
	},
	buildRowFlowSnapshotForRefresh() {
		if (!this.selectedRow || !this.selectedRow.id) {
			return null;
		}
		const key = String(this.selectedRow.id);
		const flowDefinition = this.flowByFila[key] || this.exportCurrentFlow();
		const wrappedFlow = JSON.stringify(this.wrapFlow(flowDefinition));
		const nodefilters = $.extend(true, {}, this.nodeFiltersByFila[key] || {});
		const wfgNodes = this.buildWfgNodesForPersist();
		return {
			id: this.selectedRow.id,
			flowjson: wrappedFlow,
			nodefiltersjson: JSON.stringify(nodefilters),
			nodefiltersJson: JSON.stringify(nodefilters),
			wfgnodesjson: JSON.stringify(wfgNodes),
			wfgNodesJson: JSON.stringify(wfgNodes)
		};
	},
	applyFlowSnapshotToRow(row, snapshot) {
		if (!row || !snapshot) {
			return;
		}
		const applyValue = (target, key, value) => {
			if (typeof this.$set === "function") {
				this.$set(target, key, value);
				return;
			}
			target[key] = value;
		};
		Object.keys(snapshot).forEach((key) => {
			if (key === "id") {
				return;
			}
			applyValue(row, key, snapshot[key]);
		});
	},
	refreshRowFlowInTable(snapshot) {
		if (!snapshot || !this.$refs || !this.$refs.table) {
			return;
		}
		const tableRef = this.$refs.table;
		const tableLists = [
			tableRef.tableData,
			tableRef.data,
			tableRef.rows,
			tableRef.list,
			(tableRef.$refs && tableRef.$refs.elTable && tableRef.$refs.elTable.store && tableRef.$refs.elTable.store.states && tableRef.$refs.elTable.store.states.data) || null
		];
		const rowId = String(snapshot.id);
		for (let i = 0; i < tableLists.length; i++) {
			const list = tableLists[i];
			if (!Array.isArray(list)) {
				continue;
			}
			const targetRow = list.find((item) => item && String(item.id) === rowId);
			if (!targetRow) {
				continue;
			}
			this.applyFlowSnapshotToRow(targetRow, snapshot);
			break;
		}
	},
	handleFlowChanged() {
		if (this.isImportingFlow) {
			return;
		}
		this.flowStatusTick = (this.flowStatusTick || 0) + 1;
		this.syncCurrentFlowInMemory();
		this.scheduleRefreshTerminalNodePlus();
	},
	saveFlow() {
		if (!this.selectedRow || !this.selectedRow.id) {
			return this.$$ui.showWarningMessage("Selecione uma fila para salvar o fluxo.");
		}
		this.syncSidePanelToStore();
		this.syncCurrentFlowInMemory();
		const flowSnapshot = this.buildRowFlowSnapshotForRefresh();
		this.persistCurrentFlow()
			.done(() => {
				this.applyFlowSnapshotToRow(this.selectedRow, flowSnapshot);
				this.refreshRowFlowInTable(flowSnapshot);
				this.$$ui.showSuccessMessage("Fluxo salvo com sucesso.");
			})
			.fail(() => {
				this.$$ui.showWarningMessage("Não foi possível salvar o fluxo da fila.");
			});
	},
	persistCurrentFlow() {
		if (!this.selectedRow || !this.selectedRow.id) {
			return $.Deferred().reject().promise();
		}
		const key = String(this.selectedRow.id);
		const flowDefinition = this.flowByFila[key] || this.exportCurrentFlow();
		this.flowByFila[key] = flowDefinition;
		const wfgNodes = this.buildWfgNodesForPersist();
		const nodefilters = this.nodeFiltersByFila[key] || {};
		return this.$$service.post({
			id: this.selectedRow.id,
			flow: JSON.stringify(this.wrapFlow(flowDefinition)),
			wfgNodesJson: JSON.stringify(wfgNodes),
			nodefiltersJson: JSON.stringify(nodefilters),
		}, {
			scriptFunction: "saveFlow"
		});
	},
	normalizeSidePanelValues(task, stored) {
		const out = $.extend({}, stored || {});
		if (!task || !task.filters) {
			return out;
		}
		task.filters.forEach((g) => {
			(g.items || []).forEach((it) => {
				const k = it.key || it.value;
				if (!k) {
					return;
				}
				if (!(k in out) && it.default !== undefined) {
					out[k] = it.default;
				}
				if (it.type === "select" && it.multiple) {
					if (out[k] == null || out[k] === "") {
						out[k] = [];
					} else if (!Array.isArray(out[k])) {
						out[k] = [out[k]];
					}
				}
			});
		});
		return out;
	},
	syncSidePanelToStore() {
		if (!this.selectedRow || !this.selectedDrawflowNodeId) {
			return;
		}
		const fk = String(this.selectedRow.id);
		if (!this.nodeFiltersByFila[fk]) {
			this.$set(this.nodeFiltersByFila, fk, {});
		}
		this.$set(this.nodeFiltersByFila[fk], this.selectedDrawflowNodeId, $.extend({}, this.sidePanelValues));
	},
	onDrawflowNodeSelected(id) {
		this.selectedDrawflowNodeId = id != null ? String(id) : null;
		this.scheduleRefreshTerminalNodePlus();
		if (!this.selectedRow || !this.selectedDrawflowNodeId || !this.ensureDrawflowEditor()) {
			this.sidePanelTask = null;
			this.sidePanelValues = {};
			return;
		}
		const exported = this.exportCurrentFlow();
		const inner = exported.drawflow || {};
		const moduleName = this.drawflowEditor.module || "Home";
		const node = (((inner[moduleName] || {}).data) || {})[this.selectedDrawflowNodeId] || {};
		const data = node.data || {};
		const apelido = data.apelido || node.name || "";
		this.sidePanelTask = this.availableNodeTasks.find((t) => t.apelido === apelido) || null;
		const fk = String(this.selectedRow.id);
		const stored = ((this.nodeFiltersByFila[fk] || {})[this.selectedDrawflowNodeId]) || {};
		this.sidePanelValues = this.normalizeSidePanelValues(this.sidePanelTask, stored);
	},
	onDrawflowNodeUnselected() {
		this.syncSidePanelToStore();
		this.selectedDrawflowNodeId = null;
		this.sidePanelTask = null;
		this.sidePanelValues = {};
		this.scheduleRefreshTerminalNodePlus();
	},
	buildFilterEntriesForTask(task, nodeVals) {
		const out = [];
		if (!task || !task.filters || !nodeVals) {
			return out;
		}
		task.filters.forEach((g) => {
			(g.items || []).forEach((it) => {
				const key = it.key || it.value;
				if (!key) {
					return;
				}
				if (!(key in nodeVals)) {
					return;
				}
				const val = nodeVals[key];
				if (val === undefined || val === null || val === "") {
					return;
				}
				if (Array.isArray(val) && val.length === 0) {
					return;
				}
				const valueStr = Array.isArray(val) ? val.join(",") : String(val);
				out.push({
					key: String(key),
					value: valueStr
				});
			});
		});
		return out;
	},
	filterItemVisible(it) {
		const cond = it["vShow"];
		if (!cond) {
			return true;
		}
		return !!this.sidePanelValues[cond];
	},
</script_content>

<script_content name="drawflowJs3">
	resolvePathValue(rootObj, path) {
		if (!rootObj || !path) {
			return undefined;
		}
		const parts = String(path).split(".").filter((p) => !!p);
		let current = rootObj;
		for (let i = 0; i < parts.length; i++) {
			if (current == null) {
				return undefined;
			}
			current = current[parts[i]];
		}
		return current;
	},
	resolveFilterOptions(it) {
		const rawOptions = it ? it.options : null;
		if (Array.isArray(rawOptions)) {
			return rawOptions;
		}
		if (typeof rawOptions !== "string") {
			return [];
		}
		const ref = rawOptions.trim();
		if (!ref) {
			return [];
		}
		let resolved;
		if (ref.startsWith("$$store.")) {
			resolved = this.resolvePathValue(this.$$store, ref.replace("$$store.", ""));
		} else if (ref.startsWith("this.")) {
			resolved = this.resolvePathValue(this, ref.replace("this.", ""));
		} else {
			resolved = this.resolvePathValue(this, ref);
			if (resolved === undefined) {
				resolved = this.resolvePathValue(this.$$store, ref);
			}
		}
		return Array.isArray(resolved) ? resolved : [];
	},
	buildWfgNodesForPersist() {
		if (!this.selectedRow || !this.selectedRow.id || !this.ensureDrawflowEditor()) {
			return [];
		}
		const id = this.selectedRow.id;
		this.ensureStartNodeExists();
		const exported = this.exportCurrentFlow();
		const moduleData = this.getCurrentModuleData(exported);
		const orderedIds = this.getOrderedNodeIdsForPersist(moduleData);
		const byFila = this.nodeFiltersByFila[String(id)] || {};
		const list = [];
		let ord = 1;
		orderedIds.forEach((nid) => {
			const node = moduleData[nid] || {};
			const data = node.data || {};
			const apelido = data.apelido || node.name || "";
			const nome = data.nome || "";
			const task = this.availableNodeTasks.find((t) => t.apelido === apelido);
			const nodeVals = byFila[nid] || {};
			const filters = task ? this.buildFilterEntriesForTask(task, nodeVals) : [];
			list.push({
				drawflowNodeId: String(nid),
				apelidoTarefa: apelido,
				nome,
				ordemExecucao: ord++,
				filters
			});
		});
		return list;
	},
	findNodeIdByAlias(moduleData, alias) {
		if (!moduleData || !alias) {
			return null;
		}
		const ids = Object.keys(moduleData);
		for (let i = 0; i < ids.length; i++) {
			const nodeId = String(ids[i]);
			const node = moduleData[nodeId] || {};
			const data = node.data || {};
			const nodeAlias = (data.apelido || node.name || "").toString().trim();
			if (nodeAlias === String(alias)) {
				return nodeId;
			}
		}
		return null;
	},
	hasConnectionBetweenNodes(moduleData, sourceId, targetId) {
		if (!moduleData || sourceId == null || targetId == null) {
			return false;
		}
		const source = moduleData[String(sourceId)] || {};
		const outputs = source.outputs || {};
		return Object.keys(outputs).some((key) => {
			const output = outputs[key] || {};
			const connections = Array.isArray(output.connections) ? output.connections : [];
			return connections.some((conn) => String((conn || {}).node) === String(targetId));
		});
	},
	addDefaultTaskNode(taskAlias, posX, posY) {
		const task = this.availableNodeTasks.find((item) => String(item.apelido) === String(taskAlias));
		if (!task) {
			return null;
		}
		const nodeHtml = `<div class="wfg-df-node-content"><div class="wfg-df-node-title">${task.nome}</div><div class="wfg-df-node-subtitle">${task.apelido}</div></div>`;
		const newNodeId = this.drawflowEditor.addNode(
			task.apelido,
			1,
			1,
			posX,
			posY,
			"wfg-df-node",
			{ apelido: task.apelido, nome: task.nome },
			nodeHtml,
			false
		);
		return newNodeId != null ? String(newNodeId) : null;
	},
	ensureDefaultNodesForNewRow() {
		if (!this.selectedRow || !this.selectedRow.id || !this.ensureDrawflowEditor()) {
			return;
		}
		if (this.selectedRow.flowjson != null && String(this.selectedRow.flowjson).trim() !== "") {
			return;
		}
		const startNodeId = this.ensureStartNodeExists();
		if (!startNodeId) {
			return;
		}
		const aliases = [
			"HEAVEN-wf-expira-wfocorrencia",
			"HEAVEN-wf-expira-wffilatrabalho"
		];
		let moduleData = this.getCurrentModuleData(this.exportCurrentFlow());
		const nodeIds = [];
		for (let i = 0; i < aliases.length; i++) {
			const alias = aliases[i];
			let nodeId = this.findNodeIdByAlias(moduleData, alias);
			if (!nodeId) {
				nodeId = this.addDefaultTaskNode(alias, 330 + (i * 260), 120);
				moduleData = this.getCurrentModuleData(this.exportCurrentFlow());
			}
			if (nodeId) {
				nodeIds.push(String(nodeId));
			}
		}
		if (nodeIds.length < 2) {
			return;
		}
		moduleData = this.getCurrentModuleData(this.exportCurrentFlow());
		if (!this.hasConnectionBetweenNodes(moduleData, startNodeId, nodeIds[0])) {
			try {
				this.drawflowEditor.addConnection(String(startNodeId), String(nodeIds[0]), "output_1", "input_1");
			} catch (e) {
			}
		}
		moduleData = this.getCurrentModuleData(this.exportCurrentFlow());
		if (!this.hasConnectionBetweenNodes(moduleData, nodeIds[0], nodeIds[1])) {
			try {
				this.drawflowEditor.addConnection(String(nodeIds[0]), String(nodeIds[1]), "output_1", "input_1");
			} catch (e) {
			}
		}
		this.handleFlowChanged();
	},
</script_content>