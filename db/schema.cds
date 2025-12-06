namespace ucd.app;
using {
    cuid,
    managed
} from '@sap/cds/common';

entity Solicitacoes : cuid, managed {
    key ID              : UUID;
        Solicitante     : String(100)  @title: 'Nome do Solicitante'  @mandatory;
        Departamento    : String(80)   @title: 'Departamento'         @mandatory;
        TipoSolicitacao : String(60)   @title: 'Tipo de Solicitação';
        Descricao       : String(500)  @title: 'Descrição Detalhada';
        
        Prioridade      : String(30)   @title: 'Prioridade'           @mandatory;
                                       
        Status          : String(30)   @title: 'Status'               @mandatory;
        DataSolicitacao : DateTime     @title: 'Data da Solicitação'  @mandatory;
        DataConclusao   : DateTime     @title: 'Data de Conclusão';
}

entity StatusOptions {
    key ID   : String(30);
        Nome : String(60);
}

entity PrioridadesOptions {
    key ID : String(20);
        Nome : String(50);
}

