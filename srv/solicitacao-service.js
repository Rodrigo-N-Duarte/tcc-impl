const cds = require('@sap/cds')

class SolicitacaoServiceImpl extends cds.ApplicationService {
  init() {
    this.on('concluirSolicitacao', async req => {
      const { ID } = req.params[0];
      const { observacoes } = req.data;

      await UPDATE('Solicitacoes')
        .set({
          Status: 'Concluída',
          DataConclusao: new Date(),
          ObservacoesConclusao: observacoes
        })
        .where({ ID });

      req.info('Solicitação concluída com sucesso!');

      return SELECT.one.from('Solicitacoes').where({ ID });
    });

    this.on('cancelarSolicitacao', async req => {
      const { ID } = req.params[0];
      const { motivo } = req.data;

      await UPDATE('Solicitacoes')
        .set({
          Status: 'Cancelada',
          DataConclusao: new Date(),
          ObservacoesConclusao: motivo
        })
        .where({ ID });

      req.info('Solicitação cancelada com sucesso!');

      return SELECT.one.from('Solicitacoes').where({ ID });
    });

    this.after('READ', 'Solicitacoes', data => {
      const rows = Array.isArray(data) ? data : [data];

      for (const row of rows) {

        // Status → Criticality
        row.StatusCriticality =
          row.Status === 'Concluída' ? 1 :
          row.Status === 'Em Andamento' ? 2 :
          row.Status === 'Pendente' ? 2 :
          row.Status === 'Cancelada' ? 3 : 1;

        // Prioridade → Criticality
        row.PrioridadeCriticality =
          row.Prioridade === 'Alta' ? 3 :
          row.Prioridade === 'Média' ? 2 : 1;

        // Dias decorridos
        if (row.DataSolicitacao) {
          const dias = Math.floor((Date.now() - new Date(row.DataSolicitacao)) / 86400000);
          row.DiasDecorridos = dias;

          row.DiasDecorridosCriticality =
            dias > 10 ? 3 :
            dias > 5 ? 2 : 1;
        }
      }
    });

    return super.init();
  }
}

module.exports = SolicitacaoServiceImpl;
