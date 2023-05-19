alpha = 0.9;
D = 2 * 1/20;       % Cardano 20s per block

Alphabet = 10;
States = 19;
KK = 10;
% Alphabet is max possible epoch length
%   need to be large enough to ensure numeric precision of P(j, 2) 
%   asd well as neligible probability of larger j
% States is the number of states in the Markov chain tracked
% KK is the max number of confirmation to evaluate

[Pa, PH, PD, PA, PAD] = PoSSlotPdf(alpha, D, Alphabet);

% PoS warmup and final stages are the same as PoW
St0 = PoWMCWarmupUB(PAD, Alphabet, States); 
Error = zeros(KK, 1);
tic
for K = 1:KK
    St2 = PoSMCConfirmUB(K, Pa, PH, PD, PA, St0, Alphabet, States);
    Error(K) = PoWMCFinalUB(PAD, St2, Alphabet, States);
end
toc
ErrorUB = Error;

St0 = PoWMCWarmupLB(PAD, Alphabet, States);
Error = zeros(KK, 1);
tic
for K = 1:KK
    % private mining as lower bound 
    St2 = PoSMCConfirmPM(K, Pa, PH, PD, PA, PAD, St0, Alphabet, States);
    Error(K) = PoWMCFinalLB(PAD, St2, Alphabet, States);
end
toc
ErrorLB = Error;

%csvwrite('graph-ADA-5s-0.1-upper.csv', [(1:KK)',ErrorUB])
%csvwrite('graph-ADA-5s-0.1-lower.csv', [(1:KK)',ErrorLB])

