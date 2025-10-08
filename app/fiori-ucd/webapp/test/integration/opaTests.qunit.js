sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'fioriucd/test/integration/FirstJourney',
		'fioriucd/test/integration/pages/SolicitacoesList',
		'fioriucd/test/integration/pages/SolicitacoesObjectPage'
    ],
    function(JourneyRunner, opaJourney, SolicitacoesList, SolicitacoesObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('fioriucd') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheSolicitacoesList: SolicitacoesList,
					onTheSolicitacoesObjectPage: SolicitacoesObjectPage
                }
            },
            opaJourney.run
        );
    }
);