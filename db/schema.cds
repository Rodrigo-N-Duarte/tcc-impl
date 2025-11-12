namespace ucd.app;

using { cuid, managed } from '@sap/cds/common';

/**
 * Entidade principal representando uma solicitação feita por um usuário.
 * Essa modelagem reflete o foco na experiência e no fluxo de uso do usuário.
 */
entity Solicitacoes : cuid, managed {
    key ID   : UUID;
    Solicitante        : String(100)       @title: 'Nome do Solicitante';
    Departamento       : String(80)        @title: 'Departamento';
    TipoSolicitacao    : String(60)        @title: 'Tipo de Solicitação'; // Ex: Material, Acesso, Melhoria
    Descricao          : String(500)       @title: 'Descrição Detalhada';
    Prioridade         : String(20)        @title: 'Prioridade';
    Status             : String(30)        @title: 'Status';
    DataSolicitacao    : DateTime          @title: 'Data da Solicitação';
    DataConclusao      : DateTime          @title: 'Data de Conclusão';
}

/**
 * Tabela auxiliar para tipos de solicitação — ajuda a manter consistência visual e semântica no app Fiori.
 */
entity TiposSolicitacao {
    key ID   : Integer;
    Nome     : String(60);
    Ativo    : Boolean default true;
}


