alpha = 0.8;
D = 2 * 1/13;

Alphabet = 20;
States = 49;
KK = 20;
% Alphabet is max possible epoch length
%   need to be large enough to ensure numeric precision of P(j, 2) 
%   asd well as neligible probability of larger j
% States is the number of states in the Markov chain tracked
% KK is the max number of confirmation to evaluate

[Pa, PH, PD, PA, PAD] = PoWSlotPdf(alpha, D, Alphabet);

St0 = PoWMCWarmupUB(PAD, Alphabet, States);
Error = zeros(KK, 1);
tic
for K = 1:KK
    St2 = PoWMCConfirmUB(K, Pa, PH, PD, PA, St0, Alphabet, States);
    Error(K) = PoWMCFinalUB(PAD, St2, Alphabet, States);
end
toc
ErrorUB = Error;

St0 = PoWMCWarmupLB(PAD, Alphabet, States);

Error = zeros(KK, 1);
tic
for K = 1:KK
    % private mining as lower bound
    St2 = PoWMCConfirmPM(K, Pa, PH, PD, PA, PAD, St0, Alphabet, States);    
    Error(K) = PoWMCFinalLB(PAD, St2, Alphabet, States);
end
toc
ErrorLB = Error;

%csvwrite('graph-ETH-2s-0.2-upper.csv', [(1:KK)',ErrorUB])
%csvwrite('graph-ETH-2s-0.2-lower.csv', [(1:KK)',ErrorLB])
