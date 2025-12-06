using {ucd.app as db} from '../db/schema';

service SolicitacaoService @(path: '/odata/v4/solicitacao') {
            @(
        // ====================================================================
        // CONFIGURAÇÕES GERAIS E CAPABILITIES
        // ====================================================================
        odata.draft.enabled         : true,
        odata.draft.bypass          : false,

        Common                      : {
            SemanticKey: [ID],
            Label      : 'Solicitação'
        },

        Capabilities                : {
            FilterRestrictions: {FilterExpressionRestrictions: [{
                Property          : DataSolicitacao,
                AllowedExpressions: 'MultiRangeOrSearchExpression'
            }]},
            SortRestrictions  : {NonSortableProperties: [Descricao]}
        },

        // ====================================================================
        // HEADER INFO - Cabeçalho da Object Page
        // ====================================================================
        UI.HeaderInfo               : {
            TypeName      : 'Solicitação',
            TypeNamePlural: 'Solicitações',
            Title         : {
                $Type: 'UI.DataField',
                Value: Solicitante
            },
            Description   : {
                $Type: 'UI.DataField',
                Value: TipoSolicitacao
            },
            ImageUrl      : 'sap-icon://request',
            TypeImageUrl  : 'sap-icon://document-text'
        },

        // ====================================================================
        // SELECTION FIELDS - Campos de Filtro na List Report
        // ====================================================================
        UI.SelectionFields          : [
            Solicitante,
            TipoSolicitacao,
            Status,
            Prioridade,
            DataSolicitacao
        ],

        // ====================================================================
        // PRESENTATION VARIANT - Ordenação e Visualização Padrão
        // ====================================================================
        UI.PresentationVariant                 : {
            $Type         : 'UI.PresentationVariantType',
            Text          : 'Padrão',
            SortOrder     : [
                {
                    Property  : DataSolicitacao,
                    Descending: true
                },
                {
                    Property  : Prioridade,
                    Descending: false
                }
            ],
            Visualizations: ['@UI.LineItem'],
            RequestAtLeast: [
                Solicitante,
                TipoSolicitacao,
                Status,
                Prioridade
            ]
        },

        // ====================================================================
        // LINE ITEM - Tabela Principal (List Report)
        // ====================================================================
        UI.LineItem                 : [
            {
                $Type            : 'UI.DataField',
                Value            : ID,
                Label            : 'ID',
                ![@UI.Importance]: #High
            },
            {
                $Type            : 'UI.DataField',
                Value            : Solicitante,
                Label            : 'Solicitante',
                ![@UI.Importance]: #High
            },
            {
                $Type            : 'UI.DataField',
                Value            : Departamento,
                Label            : 'Departamento',
                ![@UI.Importance]: #Medium
            },
            {
                $Type            : 'UI.DataField',
                Value            : TipoSolicitacao,
                Label            : 'Tipo de Solicitação',
                ![@UI.Importance]: #High
            },
            {
                $Type            : 'UI.DataFieldForAnnotation',
                Target           : '@UI.DataPoint#Status',
                Label            : 'Status',
                ![@UI.Importance]: #High
            },
            {
                $Type            : 'UI.DataFieldForAnnotation',
                Target           : '@UI.DataPoint#Prioridade',
                Label            : 'Prioridade',
                ![@UI.Importance]: #High
            },
            {
                $Type            : 'UI.DataField',
                Value            : DataSolicitacao,
                Label            : 'Data da Solicitação',
                ![@UI.Importance]: #Medium
            },
            {
                $Type            : 'UI.DataField',
                Value            : DataConclusao,
                Label            : 'Data de Conclusão',
                ![@UI.Importance]: #Medium,
                ![@UI.Hidden]    : {$edmJson: {$Eq: [
                    {$Path: 'DataConclusao'},
                    null
                ]}}
            },
            {
                $Type            : 'UI.DataFieldForAnnotation',
                Target           : '@UI.DataPoint#DiasDecorridos',
                Label            : 'Dias em Aberto',
                ![@UI.Importance]: #Low
            }
        ],

        // ====================================================================
        // DATA POINTS - Indicadores Visuais com Criticality
        // ====================================================================
        UI.DataPoint #Status        : {
            $Type                    : 'UI.DataPointType',
            Value                    : Status,
            Title                    : 'Status da Solicitação',
            Criticality              : StatusCriticality,
            CriticalityRepresentation: #WithIcon
        },

        UI.DataPoint #Prioridade    : {
            $Type                    : 'UI.DataPointType',
            Value                    : Prioridade,
            Title                    : 'Nível de Prioridade',
            Criticality              : PrioridadeCriticality,
            CriticalityRepresentation: #WithIcon
        },

        UI.DataPoint #DiasDecorridos: {
            $Type                    : 'UI.DataPointType',
            Value                    : DiasDecorridos,
            Title                    : 'Dias em Aberto',
            Criticality              : DiasDecorridosCriticality,
            CriticalityRepresentation: #WithoutIcon,
            ValueFormat              : {NumberOfFractionalDigits: 0}
        },

        // ====================================================================
        // HEADER FACETS - KPIs no Cabeçalho da Object Page
        // ====================================================================
        UI.HeaderFacets             : [
            {
                $Type               : 'UI.ReferenceFacet',
                Target              : '@UI.DataPoint#Status',
                ID                  : 'StatusHeaderFacet',
                ![@UI.PartOfPreview]: true
            },
            {
                $Type               : 'UI.ReferenceFacet',
                Target              : '@UI.DataPoint#Prioridade',
                ID                  : 'PrioridadeHeaderFacet',
                ![@UI.PartOfPreview]: true
            },
            {
                $Type               : 'UI.ReferenceFacet',
                Target              : '@UI.DataPoint#DiasDecorridos',
                ID                  : 'DiasDecorridosHeaderFacet',
                ![@UI.PartOfPreview]: true
            },
            {
                $Type               : 'UI.ReferenceFacet',
                Target              : '@UI.FieldGroup#DatasImportantes',
                ID                  : 'DatasHeaderFacet',
                ![@UI.PartOfPreview]: true
            }
        ],

        // ====================================================================
        // FIELD GROUPS - Agrupamentos de Campos
        // ====================================================================
        UI.FieldGroup #DatasImportantes        : {Data: [
            {
                $Type: 'UI.DataField',
                Value: DataSolicitacao,
                Label: 'Solicitada em'
            },
            {
                $Type: 'UI.DataField',
                Value: DataConclusao,
                Label: 'Concluída em'
            }
        ]},

        // ====================================================================
        // IDENTIFICATION - Ações no Header da Object Page
        // ====================================================================
        UI.Identification           : [
            {
                $Type      : 'UI.DataFieldForAction',
                Action     : 'SolicitacaoService.concluirSolicitacao',
                Label      : 'Concluir Solicitação',
                Criticality: 3,
                @UI.Hidden : {$edmJson: {$Or: [
                    {$Ne: [
                        {$Path: 'IsActiveEntity'},
                        true
                    ]},
                    {$Eq: [
                        {$Path: 'Status'},
                        'Cancelada'
                    ]},
                    {$Eq: [
                        {$Path: 'Status'},
                        'Concluída'
                    ]}
                ]}}
            },
            {
                $Type      : 'UI.DataFieldForAction',
                Action     : 'SolicitacaoService.cancelarSolicitacao',
                Label      : 'Cancelar Solicitação',
                Criticality: 1,
                @UI.Hidden : {$edmJson: {$Or: [
                    {$Ne: [
                        {$Path: 'IsActiveEntity'},
                        true
                    ]},
                    {$Eq: [
                        {$Path: 'Status'},
                        'Cancelada'
                    ]},
                    {$Eq: [
                        {$Path: 'Status'},
                        'Concluída'
                    ]}
                ]}}
            }
        ]

        // ====================================================================
        // Value Helps
        // ====================================================================
    )

    entity Solicitacoes       as
        projection on db.Solicitacoes
        // ========================================================================
        // CAMPOS VIRTUAIS CALCULADOS
        // ========================================================================
        {
            *,
            virtual null as StatusCriticality         : Integer @title: 'Status Criticality',
            virtual null as PrioridadeCriticality     : Integer @title: 'Prioridade Criticality',
            virtual null as DiasDecorridos            : Integer @title: 'Dias Decorridos',
            virtual null as DiasDecorridosCriticality : Integer @title: 'Dias Decorridos Criticality'
        }

        // ========================================================================
        // ACTIONS - Ações de Negócio
        // ========================================================================
        actions {
            /** Concluir uma solicitação em andamento */
            @(Common.SideEffects: {TargetProperties: [
                'Status',
                'StatusCriticality',
                'DataConclusao',
                'DiasDecorridos',
                'modifiedAt',
                'modifiedBy'
            ]})
            action concluirSolicitacao(observacoes: String(500)  @title: 'Observações de Conclusão'  @mandatory
            ) returns Solicitacoes;

            /* Cancelar uma solicitação */
            @(Common.SideEffects: {TargetProperties: [
                'Status',
                'StatusCriticality',
                'modifiedAt',
                'modifiedBy'
            ]})
            action cancelarSolicitacao(motivo: String(500)  @title: 'Motivo do Cancelamento'  @mandatory
            ) returns Solicitacoes;
        };

    @readonly
    entity StatusOptions      as projection on db.StatusOptions;

    // Annotation para value list de status
    annotate Solicitacoes : Status with @(
        Common.ValueListWithFixedValues,
        Common.ValueList: {
            CollectionPath: 'StatusOptions',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: Status,
                ValueListProperty: 'ID'
            }]
        }
    );

    @readonly
    entity PrioridadesOptions as projection on db.PrioridadesOptions;

    // Annotation para value list de prioridades
    annotate Solicitacoes : Prioridade with @(
        Common.ValueListWithFixedValues,
        Common.ValueList: {
            CollectionPath: 'PrioridadesOptions',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: Prioridade,
                ValueListProperty: 'ID'
            }]
        }
    );



    /* Obter estatisticas */
    @(readonly)
    function obterEstatisticas() returns {
        TotalSolicitacoes         : Integer;
        Pendentes                 : Integer;
        EmAndamento               : Integer;
        Concluidas                : Integer;
        Canceladas                : Integer;
        MediaDiasAtendimento      : Decimal(10, 2);
        SolicitacoesPorTipo       : array of {
            Tipo       : String(60);
            Quantidade : Integer;
        };
        SolicitacoesPorPrioridade : array of {
            Prioridade : String(20);
            Quantidade : Integer;
        };
    };

    /* Obter relatório do período */
    @(readonly)
    function relatorioPorPeriodo(dataInicio: DateTime @title: 'Data Início',
                                 dataFim: DateTime @title: 'Data Fim'
    )                            returns array of Solicitacoes;
}
