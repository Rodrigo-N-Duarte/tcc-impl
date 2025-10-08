using { ucd.app as db } from '../db/schema';

/**
 * Serviço principal do protótipo de usabilidade centrada no usuário
 * Desenvolvido em SAP CAP + Fiori Elements
 */
service SolicitacaoService {

    /**
     * Entidade principal projetada com annotations UI
     * para exibição automática em um app Fiori Elements (ListReport/ObjectPage)
     */
    @(
        UI: {
            HeaderInfo: {
                TypeName: 'Solicitação',
                TypeNamePlural: 'Solicitações',
                Title: { Value: Solicitante },
                Description: { Value: Descricao },
            },
            SelectionFields: [ Solicitante, Departamento, TipoSolicitacao, Status, Prioridade ],
            LineItem: [
                { Value: Solicitante, Label: 'Solicitante' },
                { Value: Departamento, Label: 'Departamento' },
                { Value: TipoSolicitacao, Label: 'Tipo de Solicitação' },
                { Value: Prioridade, Label: 'Prioridade' },
                { Value: Status, Label: 'Status' },
                { Value: DataSolicitacao, Label: 'Data da Solicitação' },
                { Value: DataConclusao, Label: 'Data de Conclusão' }
            ]
        }
    )
    entity Solicitacoes as projection on db.Solicitacoes;

    action AtualizarStatus(ID: UUID, NovoStatus: String) returns Boolean;
}
