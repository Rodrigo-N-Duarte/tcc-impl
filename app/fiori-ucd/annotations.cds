using SolicitacaoService as service from '../../srv/solicitacao-service';
annotate service.Solicitacoes with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : Solicitante,
            },
            {
                $Type : 'UI.DataField',
                Value : Departamento,
            },
            {
                $Type : 'UI.DataField',
                Value : TipoSolicitacao,
            },
            {
                $Type : 'UI.DataField',
                Value : Descricao,
            },
            {
                $Type : 'UI.DataField',
                Value : Prioridade,
            },
            {
                $Type : 'UI.DataField',
                Value : Status,
            },
            {
                $Type : 'UI.DataField',
                Value : DataSolicitacao,
            },
            {
                $Type : 'UI.DataField',
                Value : DataConclusao,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : Solicitante,
        },
        {
            $Type : 'UI.DataField',
            Value : Departamento,
        },
        {
            $Type : 'UI.DataField',
            Value : TipoSolicitacao,
        },
        {
            $Type : 'UI.DataField',
            Value : Descricao,
        },
        {
            $Type : 'UI.DataField',
            Value : Prioridade,
        },
    ],
);

