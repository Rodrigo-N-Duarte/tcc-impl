const cds = require('@sap/cds')

class SolicitacaoServiceImpl extends cds.ApplicationService {
    init() {
        this.on('concluirSolicitacao', async function (req) {
            const { ID } = req.params[0];
            const { observacoes } = req.data;

            const result = await cds.ql.UPDATE('Solicitacoes')
                .set({
                    Status: 'Concluída',
                    DataConclusao: new Date(),
                    ObservacoesConclusao: observacoes
                })
                .where({ ID });

            // 💬 Mensagem que o Fiori Elements mostrará no topo da tela
            return req.info(200, 'Solicitação concluída com sucesso!');
        })

        this.on('cancelarSolicitacao', async function (req) {
            const { ID } = req.params[0];
            const { motivo } = req.data;

            const result = await cds.ql.UPDATE('Solicitacoes')
                .set({
                    Status: 'Cancelada',
                    DataConclusao: new Date(),
                    ObservacoesConclusao: motivo
                })
                .where({ ID });

             // 💬 Mensagem que o Fiori Elements mostrará no topo da tela
            return req.info(200, 'Solicitação concluída com sucesso!');
        })

        return super.init()
    }
}
module.exports = SolicitacaoServiceImpl