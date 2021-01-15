function c = twilight(varargin)
% Copyright Bastian Bechtold 2015
% Adapted for MATLAB by William Warriner 2020
% pulled from
% https://github.com/bastibe/twilight/blob/master/twilight.m

parsed = mc_input_parse(varargin{:});
m = parsed.m;

rgb = [...
    0.95588623 0.91961077 0.95812116;...
    0.94967876 0.91615763 0.95315546;...
    0.94353853 0.91268927 0.94824212;...
    0.9374452  0.90921449 0.94337733;...
    0.93140447 0.90573033 0.93856712;...
    0.92542215 0.90223373 0.93381777;...
    0.91947392 0.89873478 0.92912752;...
    0.91357865 0.89522463 0.92450721;...
    0.90772105 0.89170929 0.91995838;...
    0.90189106 0.88819234 0.91548457;...
    0.8960938  0.8846711  0.91109116;...
    0.89031153 0.88115247 0.90677917;...
    0.88453669 0.87763908 0.90255063;...
    0.87877004 0.87413042 0.89840629;...
    0.87299914 0.87063131 0.89434535;...
    0.86721094 0.86714674 0.89036725;...
    0.86141058 0.86367475 0.88646923;...
    0.85559299 0.86021735 0.88264858;...
    0.84974682 0.85677881 0.87890418;...
    0.84387192 0.85335917 0.87523342;...
    0.83797164 0.84995717 0.87163289;...
    0.83204469 0.84657319 0.86810058;...
    0.82609045 0.84320733 0.86463493;...
    0.82010052 0.83986227 0.86123767;...
    0.81408416 0.83653448 0.85790541;...
    0.80804251 0.83322322 0.85463767;...
    0.80197661 0.82992779 0.85143441;...
    0.79588772 0.82664733 0.84829592;...
    0.78977733 0.82338091 0.8452227;...
    0.78364717 0.82012747 0.84221541;...
    0.7774989  0.81688599 0.83927495;...
    0.77133274 0.81365586 0.83640309;...
    0.76515383 0.81043494 0.83359933;...
    0.75896452 0.80722199 0.83086447;...
    0.75276734 0.80401573 0.82819926;...
    0.74656497 0.80081486 0.82560433;...
    0.74036019 0.79761806 0.82308018;...
    0.73415594 0.79442399 0.82062712;...
    0.72795524 0.79123135 0.81824533;...
    0.7217612  0.78803884 0.81593475;...
    0.71557653 0.78484528 0.81369544;...
    0.70940398 0.78164957 0.81152729;...
    0.70324772 0.77845022 0.80942895;...
    0.69711099 0.77524608 0.8073995;...
    0.69099696 0.77203607 0.8054378;...
    0.68490872 0.76881916 0.80354253;...
    0.67884928 0.76559441 0.80171222;...
    0.67282151 0.76236096 0.79994524;...
    0.66682814 0.75911802 0.79823983;...
    0.66087179 0.7558649  0.79659413;...
    0.65495439 0.75260107 0.7950067;...
    0.64907877 0.74932586 0.79347499;...
    0.64324724 0.74603878 0.79199677;...
    0.63746171 0.74273942 0.79056997;...
    0.63172396 0.73942747 0.7891925;...
    0.62603562 0.73610266 0.78786229;...
    0.62039814 0.73276477 0.78657732;...
    0.61481293 0.72941363 0.78533547;...
    0.60928127 0.72604912 0.7841347;...
    0.60380419 0.72267116 0.78297314;...
    0.59838267 0.71927971 0.78184895;...
    0.59301756 0.71587476 0.78076036;...
    0.58770967 0.7124563  0.77970565;...
    0.5824597  0.70902436 0.77868317;...
    0.57726849 0.70557897 0.77769104;...
    0.5721366  0.70212016 0.77672775;...
    0.56706445 0.69864803 0.7757921;...
    0.56205254 0.69516262 0.77488269;...
    0.55710135 0.69166401 0.7739982;...
    0.55221135 0.68815225 0.77313735;...
    0.54738299 0.68462741 0.77229891;...
    0.54261669 0.68108954 0.7714817;...
    0.53791302 0.6775387  0.77068427;...
    0.53327235 0.67397494 0.76990557;...
    0.52869499 0.67039831 0.76914482;...
    0.52418136 0.66680884 0.76840101;...
    0.51973187 0.66320657 0.76767313;...
    0.51534697 0.65959152 0.76696023;...
    0.51102708 0.6559637  0.76626135;...
    0.50677264 0.65232312 0.76557558;...
    0.50258409 0.64866978 0.76490201;...
    0.49846187 0.64500368 0.76423976;...
    0.49440652 0.64132483 0.7635876;...
    0.49041839 0.63763319 0.76294498;...
    0.48649792 0.63392874 0.76231111;...
    0.48264558 0.63021144 0.76168515;...
    0.4788618  0.62648125 0.76106626;...
    0.47514703 0.62273814 0.76045361;...
    0.4715017  0.61898207 0.75984637;...
    0.46792623 0.61521297 0.75924371;...
    0.46442103 0.6114308  0.75864479;...
    0.4609865  0.6076355  0.7580488;...
    0.45762301 0.60382702 0.7574549;...
    0.45433091 0.60000529 0.75686228;...
    0.45111051 0.59617026 0.75626997;...
    0.44796212 0.59232188 0.75567717;...
    0.44488599 0.58846006 0.75508316;...
    0.44188237 0.58458473 0.7544871;...
    0.43895145 0.58069584 0.75388814;...
    0.43609336 0.5767933  0.75328544;...
    0.43330824 0.57287707 0.75267815;...
    0.43059613 0.56894708 0.75206541;...
    0.42795705 0.56500326 0.75144639;...
    0.42539095 0.56104556 0.75082021;...
    0.42289775 0.55707392 0.75018601;...
    0.42047728 0.55308828 0.74954294;...
    0.41812934 0.54908859 0.74889012;...
    0.41585365 0.54507481 0.7482267;...
    0.41364987 0.54104688 0.7475518;...
    0.41151761 0.53700476 0.74686455;...
    0.40945636 0.53294843 0.74616402;...
    0.40746562 0.52887785 0.74544937;...
    0.40554478 0.52479298 0.74471976;...
    0.4036932  0.52069379 0.74397434;...
    0.40191012 0.51658025 0.74321222;...
    0.40019476 0.51245234 0.74243254;...
    0.39854625 0.50831006 0.74163443;...
    0.39696364 0.50415338 0.74081703;...
    0.39544595 0.4999823  0.73997947;...
    0.39399211 0.49579683 0.7391209;...
    0.39260099 0.49159695 0.73824046;...
    0.39127141 0.48738268 0.73733729;...
    0.39000213 0.48315403 0.73641054;...
    0.38879184 0.478911   0.73545936;...
    0.3876392  0.47465363 0.73448291;...
    0.38654279 0.47038193 0.73348035;...
    0.38550116 0.46609593 0.73245082;...
    0.38451281 0.46179566 0.73139351;...
    0.3835762  0.45748116 0.73030757;...
    0.38268975 0.45315247 0.72919218;...
    0.38185182 0.44880962 0.7280465;...
    0.38106076 0.44445268 0.72686969;...
    0.38031486 0.44008169 0.72566094;...
    0.37961245 0.43569671 0.72441943;...
    0.37895177 0.43129778 0.72314434;...
    0.37833106 0.42688498 0.72183484;...
    0.37774855 0.42245837 0.72049011;...
    0.37720243 0.41801803 0.71910933;...
    0.37669089 0.41356403 0.71769166;...
    0.37621211 0.40909646 0.71623627;...
    0.37576424 0.4046154  0.71474232;...
    0.37534545 0.40012094 0.71320896;...
    0.3749539  0.39561319 0.71163536;...
    0.37458773 0.39109226 0.71002064;...
    0.3742451  0.38655825 0.70836394;...
    0.37392415 0.38201129 0.7066644;...
    0.37362303 0.3774515  0.70492111;...
    0.37333991 0.37287903 0.70313318;...
    0.37307294 0.36829402 0.70129969;...
    0.37282029 0.36369664 0.69941971;...
    0.37258013 0.35908705 0.69749231;...
    0.37235064 0.35446544 0.6955165;...
    0.37212999 0.349832   0.69349132;...
    0.3719164  0.34518697 0.69141574;...
    0.37170804 0.34053056 0.68928875;...
    0.37150314 0.33586303 0.68710929;...
    0.37130003 0.33118458 0.68487633;...
    0.37109685 0.32649557 0.68258873;...
    0.3708918  0.32179632 0.68024534;...
    0.37068312 0.31708718 0.67784499;...
    0.37046904 0.31236853 0.67538648;...
    0.3702478  0.3076408  0.67286859;...
    0.37001764 0.30290445 0.67029004;...
    0.3697768  0.29815996 0.66764952;...
    0.36952351 0.29340788 0.6649457;...
    0.36925602 0.28864881 0.66217719;...
    0.36897256 0.28388339 0.65934258;...
    0.36867134 0.27911233 0.6564404;...
    0.36835059 0.27433641 0.65346914;...
    0.3680085  0.26955647 0.65042726;...
    0.36764328 0.26477344 0.64731318;...
    0.36725311 0.25998832 0.64412527;...
    0.3668366  0.25520194 0.64086184;...
    0.36639158 0.2504157  0.63752117;...
    0.36591607 0.24563096 0.63410149;...
    0.36540817 0.24084915 0.63060103;...
    0.36486595 0.23607183 0.62701797;...
    0.36428747 0.2313007  0.62335047;...
    0.36367073 0.2265376  0.61959664;...
    0.36301372 0.22178452 0.61575461;...
    0.36231439 0.21704365 0.61182247;...
    0.36157068 0.21231734 0.60779834;...
    0.36078129 0.20760765 0.60367993;...
    0.35994327 0.20291779 0.59946566;...
    0.35905442 0.19825076 0.59515371;...
    0.35811253 0.19360973 0.59074229;...
    0.35711536 0.18899812 0.5862297;...
    0.35606065 0.18441957 0.5816143;...
    0.35494612 0.17987796 0.57689459;...
    0.35377006 0.17537711 0.57206861;...
    0.35252969 0.17092163 0.56713551;...
    0.35122252 0.1665162  0.56209448;...
    0.34984626 0.16216558 0.55694478;...
    0.34839867 0.15787473 0.5516859;...
    0.34687754 0.15364873 0.54631766;...
    0.34528103 0.14949272 0.54083967;...
    0.34360674 0.1454121  0.535253;...
    0.34185263 0.14141215 0.5295588;...
    0.34001688 0.13749807 0.52375852;...
    0.33809785 0.13367489 0.51785407;...
    0.33609404 0.12994744 0.51184794;...
    0.33400409 0.12632016 0.50574349;...
    0.33182701 0.12279709 0.49954424;...
    0.32956205 0.11938176 0.49325427;...
    0.32720876 0.11607711 0.48687817;...
    0.32476698 0.1128854  0.48042104;...
    0.32223661 0.10980755 0.47389029;...
    0.31961836 0.10684434 0.46729116;...
    0.31691312 0.10399563 0.46062961;...
    0.31412208 0.10126033 0.45391229;...
    0.31124668 0.09863647 0.44714607;...
    0.30828872 0.09612127 0.44033795;...
    0.30525021 0.09371113 0.433495;...
    0.30213347 0.09140049 0.42662674;...
    0.29894109 0.08918489 0.41973884;...
    0.29567576 0.08705943 0.41283683;...
    0.2923403  0.08501829 0.40592705;...
    0.28893761 0.08305536 0.39901552;...
    0.28547067 0.08116432 0.39210787;...
    0.28194249 0.07933875 0.38520933;...
    0.27835606 0.07757226 0.37832469;...
    0.27471434 0.07585853 0.37145825;...
    0.27102024 0.07419145 0.36461386;...
    0.26727656 0.0725651  0.35779486;...
    0.263486   0.07097387 0.35100416;...
    0.25965113 0.06941247 0.34424417;...
    0.2557744  0.06787594 0.33751691;...
    0.2518586  0.06635773 0.33082656;...
    0.24790678 0.06485041 0.32417842;...
    0.24392    0.06335391 0.31756813;...
    0.23990011 0.0618647  0.31099621;...
    0.23584881 0.06037959 0.30446287;...
    0.23176762 0.05889569 0.29796805;...
    0.22765793 0.05741044 0.29151145;...
    0.2235249  0.0559091  0.28510781;...
    0.21936673 0.05439937 0.2787442;...
    0.21518395 0.05288082 0.27241805;...
    0.21097738 0.05135188 0.26612831;...
    0.20675095 0.04980177 0.25988492;...
    0.20250558 0.04822872 0.25368699;...
    0.19823879 0.04664038 0.24752274;...
    0.19395092 0.04503581 0.24139075;...
    0.18964939 0.04339464 0.2353118;...
    0.18532874 0.04173194 0.22926588;...
    0.18098806 0.04004406 0.22324832;...
    0.17663372 0.03832764 0.21727622;...
    0.1722628  0.0366263  0.21133883;...
    0.16787203 0.03494898 0.20542535;...
    0.16346916 0.03327796 0.19955633;...
    0.15904897 0.03162694 0.19371576;...
    0.15460852 0.03000286 0.18789489;...
    0.15015881 0.02838308 0.18212224;...
    0.1456879  0.02679372 0.17636536;...
    0.14120085 0.02522488 0.17063713;...
    0.13669847 0.02367601 0.16493914;...
    0.13217294 0.02216185 0.15925166;...
    0.13715771 0.0238647  0.16279915;...
    0.142138   0.02560107 0.16632081;...
    0.14712696 0.02735575 0.16981697;...
    0.15211729 0.02913553 0.17328696;...
    0.15711127 0.03093684 0.17673054;...
    0.1621132  0.03275335 0.18014741;...
    0.16711334 0.03459602 0.18353723;...
    0.17212778 0.03644357 0.18689953;...
    0.17714184 0.03831372 0.19023414;...
    0.18216272 0.04019623 0.19354057;...
    0.18719181 0.04204197 0.19681833;...
    0.19222138 0.04385446 0.20006748;...
    0.19726438 0.04562162 0.20328673;...
    0.20231059 0.04735883 0.20647637;...
    0.20736026 0.04906721 0.20963605;...
    0.21242374 0.05073417 0.21276409;...
    0.21748944 0.05237662 0.21586133;...
    0.22256097 0.05399093 0.21892687;...
    0.2276448  0.05556951 0.22195906;...
    0.2327317  0.05712593 0.22495882;...
    0.23782409 0.05865801 0.2279252;...
    0.24292948 0.06015655 0.23085593;...
    0.24803856 0.06163518 0.23375227;...
    0.25315165 0.06309447 0.23661359;...
    0.25827753 0.06452336 0.23943683;...
    0.26340901 0.06593256 0.24222299;...
    0.26854476 0.0673248  0.24497172;...
    0.27368637 0.06869883 0.24768176;...
    0.27883959 0.07004759 0.25035015;...
    0.28399705 0.0713821  0.2529784;...
    0.28915882 0.07270312 0.2555656;...
    0.29432497 0.07401148 0.25811079;...
    0.29950154 0.07529967 0.26061023;...
    0.30468256 0.07657683 0.26306525;...
    0.30986729 0.07784489 0.26547507;...
    0.31505561 0.07910492 0.2678386;...
    0.32024732 0.0803581  0.2701547;...
    0.32544482 0.08160204 0.27242069;...
    0.33064667 0.08283969 0.27463586;...
    0.33585053 0.08407525 0.27680013;...
    0.34105598 0.08531029 0.27891231;...
    0.34626256 0.08654644 0.28097121;...
    0.35146972 0.08778547 0.28297562;...
    0.35667687 0.08902924 0.28492434;...
    0.36188334 0.09027973 0.28681618;...
    0.36708839 0.09153902 0.28864998;...
    0.37229131 0.09280915 0.2904245;...
    0.37749189 0.09409153 0.29213802;...
    0.38268807 0.09539008 0.29379048;...
    0.38787885 0.09670726 0.29538088;...
    0.39306317 0.09804561 0.29690835;...
    0.39823991 0.09940776 0.29837204;...
    0.40340787 0.10079637 0.29977124;...
    0.40856581 0.10221419 0.30110533;...
    0.41371275 0.10366356 0.30237338;...
    0.41884758 0.10514695 0.30357463;...
    0.42396841 0.1066678  0.3047094;...
    0.42907377 0.10822892 0.30577763;...
    0.43416218 0.10983307 0.3067794;...
    0.43923211 0.11148296 0.30771496;...
    0.44428204 0.11318118 0.30858474;...
    0.44931042 0.11493024 0.30938934;...
    0.45431572 0.11673249 0.31012956;...
    0.45929645 0.11859012 0.31080632;...
    0.46425232 0.12050381 0.31141829;...
    0.46918047 0.12247703 0.31196941;...
    0.47407948 0.12451142 0.31246122;...
    0.47894794 0.12660841 0.31289546;...
    0.48378454 0.12876919 0.31327402;...
    0.48858861 0.13099415 0.31359736;...
    0.49335851 0.13328448 0.3138686;...
    0.4980928  0.13564099 0.31409096;...
    0.50279043 0.13806389 0.31426689;...
    0.50745058 0.1405531  0.31439855;...
    0.51207262 0.14310825 0.31448774;...
    0.51665528 0.1457293  0.31453872;...
    0.52119791 0.14841559 0.31455424;...
    0.52569995 0.15116629 0.31453693;...
    0.53016101 0.15398036 0.31448913;...
    0.53458045 0.1568568  0.31441462;...
    0.53895794 0.15979435 0.31431622;...
    0.54329324 0.16279163 0.31419663;...
    0.54758618 0.16584718 0.31405871;...
    0.55183659 0.16895949 0.3139054;...
    0.55604443 0.17212695 0.31373936;...
    0.56020971 0.17534794 0.31356335;...
    0.56433247 0.1786208  0.31338008;...
    0.56841285 0.18194387 0.31319183;...
    0.57245099 0.1853155  0.31300097;...
    0.57644706 0.18873401 0.31281029;...
    0.58040129 0.19219776 0.31262196;...
    0.58431392 0.19570523 0.31243779;...
    0.58818523 0.19925487 0.31225983;...
    0.59201548 0.20284508 0.31209072;...
    0.59580496 0.20647443 0.31193222;...
    0.59955398 0.2101416  0.31178574;...
    0.60326283 0.21384527 0.31165305;...
    0.60693181 0.21758404 0.31153632;...
    0.61056126 0.22135662 0.31143744;...
    0.61415144 0.22516202 0.3113573;...
    0.61770261 0.22899913 0.31129746;...
    0.62121505 0.23286692 0.3112594;...
    0.62468917 0.23676405 0.31124564;...
    0.6281251  0.24068989 0.31125653;...
    0.63152309 0.24464358 0.3112934;...
    0.63488335 0.24862429 0.3113576;...
    0.63820616 0.25263112 0.31145067;...
    0.64149182 0.25666317 0.31157436;...
    0.64474038 0.26072    0.31172919;...
    0.64795203 0.26480095 0.3119164;...
    0.65112691 0.26890541 0.31213721;...
    0.65426523 0.27303275 0.31239299;...
    0.65736724 0.27718218 0.31268539;...
    0.66043291 0.28135348 0.31301496;...
    0.66346234 0.28554617 0.31338289;...
    0.66645563 0.28975979 0.31379035;...
    0.66941285 0.29399391 0.31423853;...
    0.67233423 0.29824791 0.31472899;...
    0.67521975 0.30252154 0.31526265;...
    0.67806939 0.30681452 0.31584052;...
    0.68088318 0.3111265  0.31646379;...
    0.68366117 0.31545715 0.31713364;...
    0.68640337 0.31980615 0.31785128;...
    0.68910996 0.324173   0.31861821;...
    0.69178081 0.32855759 0.31943534;...
    0.6944159  0.33295966 0.32030382;...
    0.69701522 0.33737894 0.32122489;...
    0.69957876 0.34181516 0.32219978;...
    0.70210653 0.34626807 0.3232297;...
    0.7045986  0.35073729 0.32431605;...
    0.70705492 0.35522263 0.32545997;...
    0.70947542 0.3597239  0.32666265;...
    0.7118601  0.36424085 0.32792534;...
    0.71420894 0.36877323 0.3292493;...
    0.71652194 0.37332079 0.3306358;...
    0.71879913 0.37788325 0.33208612;...
    0.72104061 0.38246028 0.3336016;...
    0.72324628 0.38705172 0.33518339;...
    0.72541618 0.3916573  0.33683277;...
    0.72755035 0.39627674 0.33855099;...
    0.72964884 0.40090978 0.34033932;...
    0.73171172 0.40555611 0.34219899;...
    0.73373911 0.41021541 0.34413127;...
    0.73573115 0.41488736 0.34613738;...
    0.73768789 0.41957169 0.34821851;...
    0.73960949 0.42426807 0.35037584;...
    0.7414961  0.42897616 0.35261056;...
    0.74334793 0.43369562 0.35492382;...
    0.74516521 0.43842607 0.35731674;...
    0.74694821 0.44316712 0.35979044;...
    0.74869724 0.44791835 0.36234598;...
    0.75041257 0.4526794  0.36498439;...
    0.75209454 0.45744986 0.36770666;...
    0.75374356 0.46222929 0.37051374;...
    0.75536003 0.46701725 0.37340656;...
    0.75694444 0.47181326 0.37638597;...
    0.75849733 0.47661683 0.37945279;...
    0.76001934 0.48142741 0.38260777;...
    0.76151097 0.48624456 0.38585161;...
    0.76297286 0.49106776 0.38918495;...
    0.76440573 0.49589647 0.39260837;...
    0.76581031 0.50073015 0.39612236;...
    0.76718741 0.50556824 0.39972737;...
    0.76853788 0.51041015 0.40342376;...
    0.76986291 0.51525513 0.40721173;...
    0.77116324 0.52010271 0.41109152;...
    0.77243989 0.5249523  0.41506327;...
    0.77369391 0.52980327 0.41912699;...
    0.77492645 0.53465502 0.42328264;...
    0.77613869 0.53950688 0.42753006;...
    0.77733187 0.54435824 0.43186902;...
    0.77850729 0.54920844 0.43629918;...
    0.77966679 0.55405656 0.44081985;...
    0.78081138 0.55890219 0.4454307;...
    0.78194248 0.56374468 0.45013112;...
    0.7830616  0.5685834  0.45492037;...
    0.78417029 0.57341769 0.45979765;...
    0.78527014 0.57824693 0.46476204;...
    0.78636281 0.58307048 0.46981252;...
    0.78744997 0.58788771 0.474948;...
    0.78853333 0.59269801 0.48016727;...
    0.78961491 0.59750067 0.48546886;...
    0.79069671 0.60229498 0.49085119;...
    0.79178009 0.6070806  0.49631312;...
    0.79286688 0.61185698 0.50185312;...
    0.7939589  0.61662359 0.50746956;...
    0.79505802 0.62137992 0.51316075;...
    0.79616609 0.62612549 0.51892492;...
    0.79728497 0.63085984 0.52476024;...
    0.79841652 0.63558252 0.53066483;...
    0.7995626  0.64029314 0.53663673;...
    0.80072505 0.64499131 0.54267394;...
    0.80190568 0.64967668 0.54877442;...
    0.80310632 0.65434893 0.55493609;...
    0.80432873 0.65900778 0.56115682;...
    0.80557466 0.66365295 0.56743447;...
    0.80684582 0.66828424 0.57376686;...
    0.80814389 0.67290145 0.58015179;...
    0.8094705  0.67750443 0.58658707;...
    0.81082722 0.68209304 0.59307049;...
    0.81221558 0.68666721 0.59959981;...
    0.81363705 0.69122688 0.60617284;...
    0.81509306 0.69577202 0.61278737;...
    0.81658494 0.70030265 0.6194412;...
    0.81811398 0.70481883 0.62613217;...
    0.81968139 0.70932062 0.63285811;...
    0.82128832 0.71380816 0.63961689;...
    0.82293582 0.71828159 0.64640643;...
    0.82462489 0.7227411  0.65322464;...
    0.82635642 0.72718691 0.66006948;...
    0.82813124 0.73161926 0.66693898;...
    0.82995006 0.73603846 0.67383115;...
    0.83181351 0.74044483 0.68074409;...
    0.83372214 0.74483873 0.68767592;...
    0.83567636 0.74922057 0.69462479;...
    0.83767708 0.75359061 0.70158791;...
    0.83972535 0.75794913 0.70856199;...
    0.84181991 0.76229704 0.71554745;...
    0.84396065 0.76663495 0.72254259;...
    0.84614733 0.77096352 0.72954568;...
    0.8483795  0.77528348 0.73655503;...
    0.85065653 0.77959564 0.74356888;...
    0.85297758 0.7839009  0.75058542;...
    0.8553436  0.7881998  0.75759877;...
    0.8577521  0.79249376 0.76460878;...
    0.86020061 0.79678427 0.77161459;...
    0.8626872  0.80107277 0.77861331;...
    0.86520968 0.80536087 0.78560141;...
    0.86776571 0.8096503  0.79257445;...
    0.87035656 0.81394216 0.79951954;...
    0.87297684 0.81823907 0.80643635;...
    0.87562545 0.82254271 0.81331573;...
    0.87830287 0.82685434 0.8201464;...
    0.88101291 0.83117417 0.82691355;...
    0.88376436 0.8355008  0.83359813;...
    0.88656419 0.83983241 0.84019282;...
    0.88942615 0.84416471 0.84668696;...
    0.89236612 0.84849196 0.85307571;...
    0.89540326 0.85280703 0.85935491;...
    0.89854578 0.85710498 0.86554325;...
    0.90180023 0.86138156 0.87165915;...
    0.90516762 0.86563454 0.87772373;...
    0.90864556 0.86986351 0.88375343;...
    0.91222303 0.87407051 0.8897753;...
    0.91589042 0.87825797 0.89580632;...
    0.91963903 0.88242879 0.9018554;...
    0.92345937 0.88658601 0.90793267;...
    0.92734253 0.89073234 0.914049;...
    0.93128235 0.89487013 0.92020762;...
    0.93527444 0.89900167 0.92640565;...
    0.93931328 0.90312833 0.93265281;...
    0.94339574 0.90725141 0.93895042;...
    0.9475205  0.91137261 0.94528884;...
    0.95168443 0.9154922  0.95167893;...
    0.95588623 0.91961077 0.95812116;...
    ];
    
c = distill(rgb, m);

end
