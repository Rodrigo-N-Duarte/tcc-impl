using {ucd.app as db} from '../db/schema';

/**
 * ============================================================================
 * SERVIÇO PRINCIPAL - SOLICITAÇÃO SERVICE
 * ============================================================================
 * Serviço de usabilidade centrada no usuário desenvolvido em SAP CAP
 * Expõe entidades com anotações completas para Fiori Elements
 * Path: /odata/v4/solicitacao
 */
service SolicitacaoService @(path: '/odata/v4/solicitacao') {

            /**
             * ========================================================================
             * ENTIDADE PRINCIPAL: SOLICITAÇÕES
             * ========================================================================
             * Projeção da entidade db.Solicitacoes com annotations UI completas
             * para List Report e Object Page patterns
             */
    @(
        // ====================================================================
        // CONFIGURAÇÕES GERAIS E CAPABILITIES
        // ====================================================================
        odata.draft.enabled                    : true,
        odata.draft.bypass                     : false,

        Common                                 : {
            SemanticKey: [ID],
            Label      : 'Solicitação'
        },

        Capabilities                           : {
            FilterRestrictions: {FilterExpressionRestrictions: [{
                Property          : DataSolicitacao,
                AllowedExpressions: 'SingleRange'
            }]},
            SortRestrictions  : {NonSortableProperties: [Descricao]}
        },

        // ====================================================================
        // HEADER INFO - Cabeçalho da Object Page
        // ====================================================================
        UI.HeaderInfo                          : {
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
        UI.SelectionFields                     : [
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
        UI.LineItem                            : [
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
        UI.DataPoint #Status                   : {
            $Type                    : 'UI.DataPointType',
            Value                    : Status,
            Title                    : 'Status da Solicitação',
            Criticality              : StatusCriticality,
            CriticalityRepresentation: #WithIcon
        },

        UI.DataPoint #Prioridade               : {
            $Type                    : 'UI.DataPointType',
            Value                    : Prioridade,
            Title                    : 'Nível de Prioridade',
            Criticality              : PrioridadeCriticality,
            CriticalityRepresentation: #WithIcon
        },

        UI.DataPoint #DiasDecorridos           : {
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
        UI.HeaderFacets                        : [
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
        // FACETS - Seções da Object Page
        // ====================================================================
        UI.Facets                              : [
            // Seção 1: Informações Gerais
            {
                $Type : 'UI.CollectionFacet',
                Label : 'Informações Gerais',
                ID    : 'InformacoesGeraisFacet',
                Facets: [
                    {
                        $Type : 'UI.ReferenceFacet',
                        Target: '@UI.FieldGroup#DadosSolicitante',
                        Label : 'Dados do Solicitante',
                        ID    : 'DadosSolicitanteFacet'
                    },
                    {
                        $Type : 'UI.ReferenceFacet',
                        Target: '@UI.FieldGroup#ClassificacaoSolicitacao',
                        Label : 'Classificação da Solicitação',
                        ID    : 'ClassificacaoFacet'
                    }
                ]
            },

            // Seção 2: Descrição Detalhada
            {
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#DescricaoDetalhada',
                Label : 'Descrição Detalhada',
                ID    : 'DescricaoFacet'
            },

            // Seção 3: Controle e Acompanhamento
            {
                $Type : 'UI.CollectionFacet',
                Label : 'Controle e Acompanhamento',
                ID    : 'ControleFacet',
                Facets: [
                    {
                        $Type : 'UI.ReferenceFacet',
                        Target: '@UI.FieldGroup#StatusControle',
                        Label : 'Status e Controle',
                        ID    : 'StatusControleFacet'
                    },
                    {
                        $Type : 'UI.ReferenceFacet',
                        Target: '@UI.FieldGroup#Prazos',
                        Label : 'Prazos e Datas',
                        ID    : 'PrazosFacet'
                    }
                ]
            },

            // Seção 4: Dados Administrativos
            {
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#DadosAdministrativos',
                Label : 'Informações Administrativas',
                ID    : 'AdminFacet'
            }
        ],

        // ====================================================================
        // FIELD GROUPS - Agrupamentos de Campos
        // ====================================================================

        // Datas Importantes (Header)
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

        // Dados do Solicitante
        UI.FieldGroup #DadosSolicitante        : {Data: [
            {
                $Type                : 'UI.DataField',
                Value                : Solicitante,
                Label                : 'Nome do Solicitante',
                ![@HTML5.CssDefaults]: {width: '100%'}
            },
            {
                $Type                : 'UI.DataField',
                Value                : Departamento,
                Label                : 'Departamento',
                ![@HTML5.CssDefaults]: {width: '100%'}
            }
        ]},

        // Classificação da Solicitação
        UI.FieldGroup #ClassificacaoSolicitacao: {Data: [
            {
                $Type               : 'UI.DataField',
                Value               : TipoSolicitacao,
                Label               : 'Tipo de Solicitação',
                ![@Common.ValueList]: {
                    CollectionPath: 'TiposSolicitacao',
                    Parameters    : [{
                        $Type            : 'Common.ValueListParameterInOut',
                        LocalDataProperty: TipoSolicitacao,
                        ValueListProperty: 'Nome'
                    }]
                }
            },
            {
                $Type                              : 'UI.DataField',
                Value                              : Prioridade,
                Label                              : 'Prioridade',
                ![@Common.ValueListWithFixedValues]: true
            }
        ]},

        // Descrição Detalhada
        UI.FieldGroup #DescricaoDetalhada      : {Data: [{
            $Type                : 'UI.DataField',
            Value                : Descricao,
            Label                : 'Descrição Completa da Solicitação',
            ![@UI.MultiLineText] : true,
            ![@HTML5.CssDefaults]: {width: '100%'}
        }]},

        // Status e Controle
        UI.FieldGroup #StatusControle          : {Data: [
            {
                $Type                              : 'UI.DataField',
                Value                              : Status,
                Label                              : 'Status Atual',
                ![@Common.ValueListWithFixedValues]: true
            },
            {
                $Type                              : 'UI.DataField',
                Value                              : Prioridade,
                Label                              : 'Nível de Prioridade',
                ![@Common.ValueListWithFixedValues]: true
            }
        ]},

        // Prazos e Datas
        UI.FieldGroup #Prazos                  : {Data: [
            {
                $Type            : 'UI.DataField',
                Value            : DataSolicitacao,
                Label            : 'Data da Solicitação',
                ![@UI.Importance]: #High
            },
            {
                $Type            : 'UI.DataField',
                Value            : DataConclusao,
                Label            : 'Data de Conclusão',
                ![@UI.Importance]: #High
            },
            {
                $Type            : 'UI.DataField',
                Value            : DiasDecorridos,
                Label            : 'Dias Decorridos desde a Solicitação',
                ![@UI.Importance]: #Medium
            }
        ]},

        // Dados Administrativos (managed fields)
        UI.FieldGroup #DadosAdministrativos    : {Data: [
            {
                $Type            : 'UI.DataField',
                Value            : createdBy,
                Label            : 'Criado por',
                ![@Core.Computed]: true
            },
            {
                $Type            : 'UI.DataField',
                Value            : createdAt,
                Label            : 'Criado em',
                ![@Core.Computed]: true
            },
            {
                $Type            : 'UI.DataField',
                Value            : modifiedBy,
                Label            : 'Modificado por',
                ![@Core.Computed]: true
            },
            {
                $Type            : 'UI.DataField',
                Value            : modifiedAt,
                Label            : 'Modificado em',
                ![@Core.Computed]: true
            }
        ]},

        // ====================================================================
        // IDENTIFICATION - Ações no Header da Object Page
        // ====================================================================
        UI.Identification                      : [
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
    )
    entity Solicitacoes     as
        projection on db.Solicitacoes
        // ========================================================================
        // CAMPOS VIRTUAIS CALCULADOS
        // ========================================================================
        {
            *,
            // Campo virtual: Criticidade do Status
            virtual null as StatusCriticality         : Integer @title: 'Status Criticality',

            // Campo virtual: Criticidade da Prioridade
            virtual null as PrioridadeCriticality     : Integer @title: 'Prioridade Criticality',

            // Campo virtual: Dias decorridos desde a solicitação
            virtual null as DiasDecorridos            : Integer @title: 'Dias Decorridos',

            // Campo virtual: Criticidade dos dias decorridos
            virtual null as DiasDecorridosCriticality : Integer @title: 'Dias Decorridos Criticality'
        }
        // ========================================================================
        // ACTIONS - Ações de Negócio
        // ========================================================================
        actions {
            /**
             * Concluir uma solicitação em andamento
             */
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

            /**
             * Cancelar uma solicitação
             */
            @(Common.SideEffects: {TargetProperties: [
                'Status',
                'StatusCriticality',
                'modifiedAt',
                'modifiedBy'
            ]})
            action cancelarSolicitacao(motivo: String(500)  @title: 'Motivo do Cancelamento'  @mandatory
            ) returns Solicitacoes;
        };

    // ========================================================================
    // ENTIDADE DE VALUE HELP: TIPOS DE SOLICITAÇÃO
    // ========================================================================
    @(
        readonly,
        Capabilities: {
            InsertRestrictions.Insertable: false,
            UpdateRestrictions.Updatable : false,
            DeleteRestrictions.Deletable : false,
            SearchRestrictions.Searchable: true
        },
        UI          : {
            Identification : [{
                $Type: 'UI.DataField',
                Value: Nome
            }],
            SelectionFields: [
                Nome,
                Ativo
            ],
            LineItem       : [
                {
                    $Type: 'UI.DataField',
                    Value: ID,
                    Label: 'ID'
                },
                {
                    $Type: 'UI.DataField',
                    Value: Nome,
                    Label: 'Tipo de Solicitação'
                },
                {
                    $Type: 'UI.DataField',
                    Value: Ativo,
                    Label: 'Ativo'
                }
            ]
        }
    )
    entity TiposSolicitacao as projection on db.TiposSolicitacao

    // ========================================================================
    // FUNÇÃO: ESTATÍSTICAS DE SOLICITAÇÕES
    // ========================================================================
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

    // ========================================================================
    // FUNÇÃO: RELATÓRIO DE SOLICITAÇÕES POR PERÍODO
    // ========================================================================
    @(readonly)
    function relatorioPorPeriodo(dataInicio: DateTime @title: 'Data Início',
                                 dataFim: DateTime @title: 'Data Fim'
    )                            returns array of Solicitacoes;
}
