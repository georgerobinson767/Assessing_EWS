
% This script will produce all the figures contained in our paper, as well
% as the entries for the table

[fig1] = fig1_maker();

[fig2, fig3, fig4, table_entries] = make_local_workspace();

function [fig2, fig3, fig4, table_entries] = make_local_workspace()

    load("final_session_results.mat", "stor1","stor2","stor3","stor4");

    [fig2, fig3, fig4, table_entries] = function_4(stor1, stor2, stor3, stor4);

end