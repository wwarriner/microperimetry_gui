function c = corkO(varargin)
%credit to Fabio Crameri, see: http://www.fabiocrameri.ch/colourmaps.php

parsed = mc_input_parse(varargin{:});
m = parsed.m;

rgb = [...
    [0.246514, 0.243518, 0.229200];...
    [0.246074, 0.242433, 0.232323];...
    [0.245643, 0.241447, 0.235542];...
    [0.245220, 0.240524, 0.238831];...
    [0.244807, 0.239744, 0.242251];...
    [0.244407, 0.239052, 0.245764];...
    [0.244020, 0.238467, 0.249403];...
    [0.243647, 0.238019, 0.253162];...
    [0.243292, 0.237693, 0.257030];...
    [0.242955, 0.237488, 0.261017];...
    [0.242639, 0.237411, 0.265130];...
    [0.242349, 0.237472, 0.269403];...
    [0.242086, 0.237675, 0.273788];...
    [0.241849, 0.238020, 0.278314];...
    [0.241642, 0.238522, 0.282995];...
    [0.241466, 0.239214, 0.287801];...
    [0.241327, 0.240053, 0.292779];...
    [0.241229, 0.241086, 0.297907];...
    [0.241177, 0.242294, 0.303192];...
    [0.241177, 0.243679, 0.308658];...
    [0.241231, 0.245267, 0.314253];...
    [0.241345, 0.247068, 0.320033];...
    [0.241522, 0.249063, 0.325942];...
    [0.241763, 0.251268, 0.332045];...
    [0.242074, 0.253668, 0.338280];...
    [0.242460, 0.256274, 0.344686];...
    [0.242934, 0.259134, 0.351245];...
    [0.243502, 0.262175, 0.357948];...
    [0.244167, 0.265445, 0.364778];...
    [0.244938, 0.268948, 0.371749];...
    [0.245823, 0.272631, 0.378858];...
    [0.246829, 0.276565, 0.386073];...
    [0.247970, 0.280669, 0.393409];...
    [0.249209, 0.285009, 0.400856];...
    [0.250593, 0.289561, 0.408362];...
    [0.252143, 0.294281, 0.415959];...
    [0.253829, 0.299221, 0.423617];...
    [0.255668, 0.304315, 0.431347];...
    [0.257671, 0.309611, 0.439092];...
    [0.259862, 0.315041, 0.446886];...
    [0.262207, 0.320662, 0.454698];...
    [0.264729, 0.326392, 0.462494];...
    [0.267429, 0.332303, 0.470307];...
    [0.270357, 0.338305, 0.478085];...
    [0.273434, 0.344444, 0.485838];...
    [0.276704, 0.350708, 0.493554];...
    [0.280150, 0.357054, 0.501228];...
    [0.283800, 0.363476, 0.508838];...
    [0.287629, 0.369992, 0.516370];...
    [0.291667, 0.376594, 0.523845];...
    [0.295857, 0.383243, 0.531233];...
    [0.300240, 0.389936, 0.538543];...
    [0.304804, 0.396690, 0.545753];...
    [0.309546, 0.403494, 0.552865];...
    [0.314424, 0.410324, 0.559891];...
    [0.319491, 0.417174, 0.566812];...
    [0.324694, 0.424036, 0.573626];...
    [0.330072, 0.430932, 0.580341];...
    [0.335581, 0.437835, 0.586946];...
    [0.341221, 0.444739, 0.593454];...
    [0.347003, 0.451643, 0.599853];...
    [0.352900, 0.458545, 0.606142];...
    [0.358908, 0.465438, 0.612335];...
    [0.365046, 0.472343, 0.618431];...
    [0.371281, 0.479226, 0.624418];...
    [0.377628, 0.486093, 0.630308];...
    [0.384061, 0.492947, 0.636098];...
    [0.390584, 0.499790, 0.641787];...
    [0.397184, 0.506620, 0.647388];...
    [0.403874, 0.513434, 0.652888];...
    [0.410632, 0.520214, 0.658307];...
    [0.417449, 0.526995, 0.663635];...
    [0.424320, 0.533730, 0.668865];...
    [0.431261, 0.540462, 0.674009];...
    [0.438241, 0.547164, 0.679065];...
    [0.445264, 0.553843, 0.684035];...
    [0.452340, 0.560501, 0.688931];...
    [0.459434, 0.567135, 0.693723];...
    [0.466560, 0.573736, 0.698436];...
    [0.473703, 0.580317, 0.703069];...
    [0.480872, 0.586864, 0.707605];...
    [0.488064, 0.593390, 0.712059];...
    [0.495246, 0.599883, 0.716426];...
    [0.502430, 0.606341, 0.720690];...
    [0.509613, 0.612768, 0.724873];...
    [0.516785, 0.619175, 0.728951];...
    [0.523937, 0.625527, 0.732937];...
    [0.531065, 0.631850, 0.736815];...
    [0.538169, 0.638130, 0.740589];...
    [0.545222, 0.644364, 0.744254];...
    [0.552238, 0.650561, 0.747809];...
    [0.559191, 0.656708, 0.751242];...
    [0.566089, 0.662799, 0.754548];...
    [0.572922, 0.668831, 0.757721];...
    [0.579670, 0.674803, 0.760763];...
    [0.586325, 0.680708, 0.763657];...
    [0.592889, 0.686552, 0.766407];...
    [0.599339, 0.692323, 0.768997];...
    [0.605663, 0.697998, 0.771432];...
    [0.611869, 0.703598, 0.773683];...
    [0.617929, 0.709106, 0.775763];...
    [0.623843, 0.714500, 0.777659];...
    [0.629576, 0.719802, 0.779351];...
    [0.635140, 0.724985, 0.780845];...
    [0.640515, 0.730041, 0.782130];...
    [0.645680, 0.734968, 0.783189];...
    [0.650637, 0.739758, 0.784032];...
    [0.655360, 0.744391, 0.784633];...
    [0.659845, 0.748872, 0.784993];...
    [0.664075, 0.753187, 0.785106];...
    [0.668041, 0.757333, 0.784965];...
    [0.671720, 0.761291, 0.784566];...
    [0.675118, 0.765063, 0.783902];...
    [0.678218, 0.768624, 0.782963];...
    [0.681000, 0.771988, 0.781763];...
    [0.683477, 0.775130, 0.780281];...
    [0.685626, 0.778055, 0.778528];...
    [0.687438, 0.780747, 0.776502];...
    [0.688920, 0.783206, 0.774192];...
    [0.690051, 0.785428, 0.771621];...
    [0.690837, 0.787403, 0.768767];...
    [0.691283, 0.789134, 0.765659];...
    [0.691382, 0.790608, 0.762276];...
    [0.691133, 0.791836, 0.758645];...
    [0.690543, 0.792812, 0.754762];...
    [0.689621, 0.793537, 0.750631];...
    [0.688356, 0.794008, 0.746261];...
    [0.686761, 0.794227, 0.741664];...
    [0.684846, 0.794201, 0.736852];...
    [0.682619, 0.793931, 0.731829];...
    [0.680084, 0.793419, 0.726601];...
    [0.677269, 0.792669, 0.721180];...
    [0.674153, 0.791690, 0.715587];...
    [0.670775, 0.790487, 0.709811];...
    [0.667125, 0.789069, 0.703872];...
    [0.663236, 0.787430, 0.697778];...
    [0.659095, 0.785590, 0.691544];...
    [0.654735, 0.783546, 0.685174];...
    [0.650168, 0.781310, 0.678671];...
    [0.645388, 0.778884, 0.672052];...
    [0.640429, 0.776282, 0.665317];...
    [0.635283, 0.773500, 0.658479];...
    [0.629975, 0.770559, 0.651546];...
    [0.624512, 0.767448, 0.644510];...
    [0.618908, 0.764188, 0.637398];...
    [0.613153, 0.760777, 0.630202];...
    [0.607298, 0.757219, 0.622928];...
    [0.601310, 0.753521, 0.615578];...
    [0.595226, 0.749687, 0.608173];...
    [0.589042, 0.745730, 0.600688];...
    [0.582779, 0.741641, 0.593155];...
    [0.576448, 0.737434, 0.585562];...
    [0.570022, 0.733108, 0.577900];...
    [0.563558, 0.728661, 0.570198];...
    [0.557029, 0.724106, 0.562458];...
    [0.550448, 0.719443, 0.554652];...
    [0.543831, 0.714663, 0.546809];...
    [0.537188, 0.709790, 0.538920];...
    [0.530506, 0.704805, 0.530988];...
    [0.523810, 0.699719, 0.523022];...
    [0.517103, 0.694532, 0.515012];...
    [0.510377, 0.689260, 0.506969];...
    [0.503657, 0.683872, 0.498898];...
    [0.496940, 0.678401, 0.490802];...
    [0.490237, 0.672836, 0.482660];...
    [0.483541, 0.667169, 0.474508];...
    [0.476876, 0.661418, 0.466323];...
    [0.470240, 0.655574, 0.458126];...
    [0.463626, 0.649645, 0.449918];...
    [0.457057, 0.643620, 0.441702];...
    [0.450538, 0.637522, 0.433463];...
    [0.444070, 0.631339, 0.425246];...
    [0.437658, 0.625071, 0.417024];...
    [0.431304, 0.618736, 0.408805];...
    [0.425019, 0.612311, 0.400621];...
    [0.418804, 0.605822, 0.392435];...
    [0.412689, 0.599277, 0.384293];...
    [0.406641, 0.592664, 0.376199];...
    [0.400705, 0.585986, 0.368135];...
    [0.394843, 0.579258, 0.360128];...
    [0.389103, 0.572481, 0.352187];...
    [0.383469, 0.565651, 0.344316];...
    [0.377942, 0.558794, 0.336534];...
    [0.372536, 0.551916, 0.328851];...
    [0.367261, 0.545000, 0.321249];...
    [0.362122, 0.538076, 0.313772];...
    [0.357114, 0.531130, 0.306417];...
    [0.352221, 0.524187, 0.299182];...
    [0.347497, 0.517255, 0.292087];...
    [0.342904, 0.510320, 0.285135];...
    [0.338440, 0.503410, 0.278372];...
    [0.334152, 0.496530, 0.271744];...
    [0.329998, 0.489688, 0.265325];...
    [0.325977, 0.482890, 0.259099];...
    [0.322137, 0.476144, 0.253042];...
    [0.318434, 0.469457, 0.247192];...
    [0.314873, 0.462810, 0.241561];...
    [0.311471, 0.456259, 0.236144];...
    [0.308217, 0.449781, 0.230934];...
    [0.305114, 0.443385, 0.225970];...
    [0.302128, 0.437078, 0.221220];...
    [0.299320, 0.430861, 0.216708];...
    [0.296626, 0.424744, 0.212419];...
    [0.294053, 0.418722, 0.208367];...
    [0.291641, 0.412827, 0.204573];...
    [0.289337, 0.407019, 0.200965];...
    [0.287137, 0.401336, 0.197646];...
    [0.285071, 0.395767, 0.194568];...
    [0.283136, 0.390300, 0.191665];...
    [0.281275, 0.384960, 0.189032];...
    [0.279551, 0.379745, 0.186606];...
    [0.277900, 0.374647, 0.184407];...
    [0.276356, 0.369657, 0.182405];...
    [0.274875, 0.364791, 0.180634];...
    [0.273507, 0.360044, 0.179082];...
    [0.272180, 0.355427, 0.177733];...
    [0.270975, 0.350908, 0.176511];...
    [0.269818, 0.346493, 0.175527];...
    [0.268723, 0.342210, 0.174739];...
    [0.267660, 0.338018, 0.174089];...
    [0.266699, 0.333959, 0.173611];...
    [0.265782, 0.329992, 0.173299];...
    [0.264890, 0.326111, 0.173142];...
    [0.264077, 0.322366, 0.173134];...
    [0.263285, 0.318697, 0.173268];...
    [0.262523, 0.315126, 0.173538];...
    [0.261802, 0.311647, 0.173941];...
    [0.261114, 0.308275, 0.174477];...
    [0.260455, 0.304989, 0.175118];...
    [0.259828, 0.301770, 0.175843];...
    [0.259224, 0.298661, 0.176723];...
    [0.258622, 0.295621, 0.177731];...
    [0.258037, 0.292666, 0.178788];...
    [0.257493, 0.289794, 0.179939];...
    [0.256958, 0.286984, 0.181192];...
    [0.256419, 0.284266, 0.182545];...
    [0.255901, 0.281623, 0.183996];...
    [0.255410, 0.279056, 0.185552];...
    [0.254919, 0.276550, 0.187141];...
    [0.254422, 0.274108, 0.188825];...
    [0.253930, 0.271726, 0.190576];...
    [0.253448, 0.269457, 0.192421];...
    [0.252970, 0.267202, 0.194366];...
    [0.252495, 0.265049, 0.196352];...
    [0.252028, 0.262972, 0.198389];...
    [0.251564, 0.260945, 0.200520];...
    [0.251092, 0.259004, 0.202749];...
    [0.250611, 0.257113, 0.205044];...
    [0.250136, 0.255307, 0.207416];...
    [0.249678, 0.253559, 0.209848];...
    [0.249229, 0.251897, 0.212377];...
    [0.248782, 0.250279, 0.214954];...
    [0.248331, 0.248790, 0.217648];...
    [0.247873, 0.247344, 0.220422];...
    [0.247413, 0.245975, 0.223258];...
    [0.246960, 0.244699, 0.226195]...
    ];

c = distill(rgb, m);

end