function c = cork(varargin)
%credit to Fabio Crameri, see: http://www.fabiocrameri.ch/colourmaps.php

parsed = mc_input_parse(varargin{:});
m = parsed.m;

rgb = [...
    [0.171002, 0.100333, 0.299842];...
    [0.171098, 0.106192, 0.305325];...
    [0.171127, 0.111940, 0.310821];...
    [0.171092, 0.117628, 0.316326];...
    [0.170996, 0.123286, 0.321840];...
    [0.170843, 0.128953, 0.327378];...
    [0.170638, 0.134629, 0.332953];...
    [0.170385, 0.140210, 0.338510];...
    [0.170091, 0.145847, 0.344093];...
    [0.169761, 0.151413, 0.349710];...
    [0.169393, 0.157017, 0.355341];...
    [0.168981, 0.162635, 0.360956];...
    [0.168527, 0.168218, 0.366624];...
    [0.168060, 0.173842, 0.372281];...
    [0.167603, 0.179470, 0.377972];...
    [0.167137, 0.185135, 0.383679];...
    [0.166645, 0.190772, 0.389393];...
    [0.166142, 0.196482, 0.395129];...
    [0.165651, 0.202154, 0.400890];...
    [0.165194, 0.207899, 0.406645];...
    [0.164781, 0.213653, 0.412434];...
    [0.164407, 0.219446, 0.418217];...
    [0.164066, 0.225250, 0.424030];...
    [0.163773, 0.231114, 0.429860];...
    [0.163548, 0.237011, 0.435703];...
    [0.163408, 0.242899, 0.441549];...
    [0.163369, 0.248876, 0.447399];...
    [0.163450, 0.254879, 0.453272];...
    [0.163667, 0.260898, 0.459151];...
    [0.164035, 0.266965, 0.465023];...
    [0.164556, 0.273096, 0.470907];...
    [0.165255, 0.279264, 0.476781];...
    [0.166222, 0.285442, 0.482654];...
    [0.167417, 0.291707, 0.488521];...
    [0.168856, 0.297976, 0.494376];...
    [0.170546, 0.304307, 0.500203];...
    [0.172534, 0.310690, 0.506016];...
    [0.174857, 0.317081, 0.511811];...
    [0.177481, 0.323518, 0.517581];...
    [0.180396, 0.329997, 0.523307];...
    [0.183680, 0.336486, 0.529000];...
    [0.187322, 0.343029, 0.534641];...
    [0.191254, 0.349574, 0.540242];...
    [0.195548, 0.356150, 0.545800];...
    [0.200151, 0.362731, 0.551296];...
    [0.205108, 0.369336, 0.556741];...
    [0.210355, 0.375951, 0.562134];...
    [0.215912, 0.382566, 0.567459];...
    [0.221708, 0.389197, 0.572732];...
    [0.227801, 0.395826, 0.577933];...
    [0.234115, 0.402439, 0.583088];...
    [0.240647, 0.409068, 0.588182];...
    [0.247424, 0.415686, 0.593231];...
    [0.254377, 0.422293, 0.598211];...
    [0.261487, 0.428908, 0.603153];...
    [0.268777, 0.435516, 0.608045];...
    [0.276201, 0.442111, 0.612880];...
    [0.283733, 0.448695, 0.617686];...
    [0.291409, 0.455274, 0.622452];...
    [0.299175, 0.461848, 0.627187];...
    [0.307026, 0.468414, 0.631891];...
    [0.314963, 0.474991, 0.636572];...
    [0.322993, 0.481545, 0.641215];...
    [0.331056, 0.488112, 0.645850];...
    [0.339218, 0.494670, 0.650469];...
    [0.347410, 0.501229, 0.655066];...
    [0.355651, 0.507788, 0.659661];...
    [0.363920, 0.514350, 0.664241];...
    [0.372240, 0.520907, 0.668817];...
    [0.380610, 0.527473, 0.673385];...
    [0.389000, 0.534037, 0.677952];...
    [0.397413, 0.540616, 0.682509];...
    [0.405870, 0.547193, 0.687073];...
    [0.414336, 0.553774, 0.691635];...
    [0.422827, 0.560367, 0.696201];...
    [0.431362, 0.566964, 0.700765];...
    [0.439899, 0.573561, 0.705330];...
    [0.448461, 0.580171, 0.709903];...
    [0.457038, 0.586779, 0.714472];...
    [0.465632, 0.593403, 0.719053];...
    [0.474259, 0.600028, 0.723633];...
    [0.482891, 0.606664, 0.728220];...
    [0.491555, 0.613298, 0.732815];...
    [0.500209, 0.619957, 0.737407];...
    [0.508903, 0.626606, 0.742008];...
    [0.517603, 0.633271, 0.746614];...
    [0.526318, 0.639943, 0.751230];...
    [0.535041, 0.646619, 0.755841];...
    [0.543787, 0.653298, 0.760462];...
    [0.552548, 0.659996, 0.765089];...
    [0.561317, 0.666690, 0.769715];...
    [0.570100, 0.673403, 0.774349];...
    [0.578906, 0.680111, 0.778992];...
    [0.587714, 0.686838, 0.783640];...
    [0.596547, 0.693566, 0.788286];...
    [0.605381, 0.700304, 0.792942];...
    [0.614230, 0.707050, 0.797594];...
    [0.623101, 0.713799, 0.802254];...
    [0.631972, 0.720555, 0.806919];...
    [0.640852, 0.727321, 0.811579];...
    [0.649750, 0.734094, 0.816242];...
    [0.658643, 0.740866, 0.820896];...
    [0.667555, 0.747654, 0.825548];...
    [0.676462, 0.754441, 0.830196];...
    [0.685373, 0.761226, 0.834829];...
    [0.694272, 0.768015, 0.839447];...
    [0.703182, 0.774807, 0.844037];...
    [0.712069, 0.781604, 0.848603];...
    [0.720940, 0.788388, 0.853129];...
    [0.729793, 0.795166, 0.857607];...
    [0.738604, 0.801933, 0.862030];...
    [0.747373, 0.808688, 0.866368];...
    [0.756077, 0.815414, 0.870613];...
    [0.764707, 0.822113, 0.874748];...
    [0.773233, 0.828767, 0.878742];...
    [0.781645, 0.835363, 0.882566];...
    [0.789893, 0.841893, 0.886197];...
    [0.797952, 0.848325, 0.889581];...
    [0.805777, 0.854646, 0.892690];...
    [0.813316, 0.860818, 0.895470];...
    [0.820514, 0.866808, 0.897871];...
    [0.827307, 0.872581, 0.899846];...
    [0.833620, 0.878081, 0.901331];...
    [0.839377, 0.883260, 0.902281];...
    [0.844500, 0.888065, 0.902642];...
    [0.848916, 0.892441, 0.902367];...
    [0.852553, 0.896328, 0.901423];...
    [0.855342, 0.899680, 0.899792];...
    [0.857237, 0.902449, 0.897459];...
    [0.858215, 0.904605, 0.894433];...
    [0.858260, 0.906132, 0.890735];...
    [0.857383, 0.907018, 0.886413];...
    [0.855620, 0.907275, 0.881506];...
    [0.853008, 0.906926, 0.876077];...
    [0.849620, 0.906005, 0.870188];...
    [0.845518, 0.904551, 0.863918];...
    [0.840790, 0.902621, 0.857305];...
    [0.835502, 0.900256, 0.850427];...
    [0.829737, 0.897515, 0.843328];...
    [0.823554, 0.894441, 0.836059];...
    [0.817028, 0.891077, 0.828653];...
    [0.810206, 0.887473, 0.821139];...
    [0.803146, 0.883670, 0.813548];...
    [0.795886, 0.879687, 0.805901];...
    [0.788466, 0.875568, 0.798212];...
    [0.780910, 0.871328, 0.790492];...
    [0.773247, 0.866989, 0.782753];...
    [0.765509, 0.862582, 0.775000];...
    [0.757696, 0.858100, 0.767242];...
    [0.749830, 0.853572, 0.759480];...
    [0.741933, 0.849012, 0.751727];...
    [0.734006, 0.844416, 0.743967];...
    [0.726058, 0.839801, 0.736210];...
    [0.718093, 0.835162, 0.728466];...
    [0.710122, 0.830515, 0.720726];...
    [0.702142, 0.825857, 0.712995];...
    [0.694164, 0.821197, 0.705275];...
    [0.686195, 0.816535, 0.697559];...
    [0.678226, 0.811869, 0.689858];...
    [0.670266, 0.807206, 0.682157];...
    [0.662308, 0.802540, 0.674474];...
    [0.654352, 0.797881, 0.666794];...
    [0.646413, 0.793230, 0.659128];...
    [0.638482, 0.788576, 0.651475];...
    [0.630565, 0.783930, 0.643819];...
    [0.622646, 0.779281, 0.636185];...
    [0.614740, 0.774639, 0.628553];...
    [0.606856, 0.770005, 0.620929];...
    [0.598970, 0.765380, 0.613304];...
    [0.591094, 0.760750, 0.605696];...
    [0.583229, 0.756126, 0.598097];...
    [0.575379, 0.751511, 0.590503];...
    [0.567535, 0.746890, 0.582916];...
    [0.559699, 0.742278, 0.575339];...
    [0.551874, 0.737663, 0.567763];...
    [0.544051, 0.733058, 0.560195];...
    [0.536242, 0.728446, 0.552626];...
    [0.528441, 0.723838, 0.545062];...
    [0.520641, 0.719233, 0.537505];...
    [0.512856, 0.714618, 0.529941];...
    [0.505076, 0.710009, 0.522374];...
    [0.497310, 0.705390, 0.514818];...
    [0.489536, 0.700767, 0.507249];...
    [0.481788, 0.696136, 0.499670];...
    [0.474035, 0.691487, 0.492099];...
    [0.466295, 0.686830, 0.484500];...
    [0.458564, 0.682151, 0.476901];...
    [0.450843, 0.677464, 0.469289];...
    [0.443133, 0.672740, 0.461640];...
    [0.435437, 0.667987, 0.453971];...
    [0.427749, 0.663198, 0.446270];...
    [0.420074, 0.658362, 0.438539];...
    [0.412432, 0.653478, 0.430773];...
    [0.404792, 0.648544, 0.422946];...
    [0.397197, 0.643541, 0.415084];...
    [0.389639, 0.638473, 0.407160];...
    [0.382120, 0.633322, 0.399167];...
    [0.374666, 0.628084, 0.391129];...
    [0.367258, 0.622745, 0.383004];...
    [0.359940, 0.617306, 0.374804];...
    [0.352714, 0.611755, 0.366537];...
    [0.345586, 0.606084, 0.358184];...
    [0.338597, 0.600302, 0.349763];...
    [0.331755, 0.594393, 0.341270];...
    [0.325080, 0.588354, 0.332725];...
    [0.318620, 0.582202, 0.324097];...
    [0.312359, 0.575941, 0.315458];...
    [0.306386, 0.569547, 0.306781];...
    [0.300643, 0.563074, 0.298082];...
    [0.295216, 0.556497, 0.289423];...
    [0.290106, 0.549856, 0.280759];...
    [0.285330, 0.543156, 0.272171];...
    [0.280904, 0.536416, 0.263689];...
    [0.276862, 0.529653, 0.255272];...
    [0.273160, 0.522885, 0.246962];...
    [0.269828, 0.516123, 0.238796];...
    [0.266832, 0.509410, 0.230797];...
    [0.264214, 0.502728, 0.222969];...
    [0.261910, 0.496110, 0.215283];...
    [0.259935, 0.489564, 0.207812];...
    [0.258237, 0.483101, 0.200494];...
    [0.256842, 0.476724, 0.193415];...
    [0.255684, 0.470438, 0.186490];...
    [0.254777, 0.464248, 0.179747];...
    [0.254050, 0.458135, 0.173186];...
    [0.253515, 0.452138, 0.166818];...
    [0.253143, 0.446212, 0.160554];...
    [0.252913, 0.440390, 0.154481];...
    [0.252806, 0.434658, 0.148531];...
    [0.252804, 0.429003, 0.142747];...
    [0.252893, 0.423423, 0.137056];...
    [0.253057, 0.417931, 0.131481];...
    [0.253283, 0.412515, 0.126010];...
    [0.253560, 0.407148, 0.120572];...
    [0.253880, 0.401846, 0.115268];...
    [0.254234, 0.396615, 0.110077];...
    [0.254615, 0.391450, 0.104811];...
    [0.255011, 0.386313, 0.099710];...
    [0.255409, 0.381257, 0.094670];...
    [0.255809, 0.376231, 0.089581];...
    [0.256221, 0.371237, 0.084565];...
    [0.256643, 0.366315, 0.079479];...
    [0.257060, 0.361411, 0.074491];...
    [0.257455, 0.356559, 0.069524];...
    [0.257835, 0.351723, 0.064405];...
    [0.258210, 0.346946, 0.059366];...
    [0.258577, 0.342183, 0.054120];...
    [0.258926, 0.337452, 0.049005];...
    [0.259245, 0.332757, 0.043542];...
    [0.259532, 0.328062, 0.038204];...
    [0.259790, 0.323407, 0.032741];...
    [0.260018, 0.318768, 0.027725];...
    [0.260213, 0.314146, 0.022967];...
    [0.260374, 0.309553, 0.018450];...
    [0.260497, 0.304950, 0.014165];...
    [0.260580, 0.300360, 0.009894]...
    ];

c = distill(rgb, m);

end