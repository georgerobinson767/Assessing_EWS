
% This script will produce all the figures contained in our paper.

[fig1] = fig1_maker();

[fig2, fig3, fig4] = make_local_workspace();

function [fig2, fig3, fig4] = make_local_workspace()
    load("final_session_results.mat", "stor1","stor2","stor3","stor4");

    [fig2, fig3, fig4] = function_4(stor1, stor2, stor3, stor4);

end