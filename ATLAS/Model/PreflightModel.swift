//
//  PreflightModel.swift
//  ATLAS
//
//  Created by phuong phan on 26/09/2023.
//

import Foundation

enum PreflightTabEnumeration: CustomStringConvertible {
    case SummaryScreen
    case NotamScreen
    case MetarTafScreen
    case StatisticsScreen
    case Mapcreen
    case NotesScreen
    
    var description: String {
        switch self {
            case .SummaryScreen:
                return "Summary"
            case .NotamScreen:
                return "NOTAMs"
            case .MetarTafScreen:
                return "METAR & TAF"
            case .StatisticsScreen:
                return "Statistics"
            case .Mapcreen:
                return "Map"
            case .NotesScreen:
                return "Notes"
        }
    }
}

struct PreflightTab {
    var title: String
    var screenName: PreflightTabEnumeration
}

let IPreflightTabs = [
    PreflightTab(title: "Summary", screenName: PreflightTabEnumeration.SummaryScreen),
    PreflightTab(title: "NOTAMs", screenName: PreflightTabEnumeration.NotamScreen),
    PreflightTab(title: "METAR & TAF", screenName: PreflightTabEnumeration.MetarTafScreen),
    PreflightTab(title: "Statistics", screenName: PreflightTabEnumeration.StatisticsScreen),
    PreflightTab(title: "Map", screenName: PreflightTabEnumeration.Mapcreen),
    PreflightTab(title: "Notes", screenName: PreflightTabEnumeration.NotesScreen),
]

struct INoteCommentResponse: Codable {
    var comment_id: String
    var post_id: String
    var user_id: String
    var comment_date: String
    var comment_text: String
    var username: String
}

struct INotePostResponse: Codable {
    var post_id: String
    var user_id: String
    var post_date: String
    var post_title: String
    var post_text: String
    var upvote_count: String
    var comment_count: String
    var category: String
    var comments: [INoteCommentResponse]
    var username: String
    var voted: Bool
    var favourite: Bool
    var blue: Bool
}

struct INoteResponse: Codable {
    var name: String
    var lat: String
    var long: String
    var post_count: String
    var posts: [INotePostResponse]
}

struct INotePostJson: Codable {
    var departure: [INoteResponse]
    var arrival: [INoteResponse]
    var preflight: [INoteResponse]
    var enroute: [INoteResponse]
}

let ALTN_DROP_DOWN: [String] =  ["WMKP", "WMKK", "VTSP", "WIMM", "WMKL", "VTBD", "VTSM"]
//["AGGH", "AYAY", "AYNZ", "AYPY", "BGBW", "BGSF", "BGUK", "BGUM", "BIEG", "BIKF", "CYAT", "CYBE", "CYCB", "CYDF", "CYEV", "CYFA", "CYFB", "CYFC", "CYFO", "CYGL", "CYGW", "CYGX", "CYHM", "CYHR", "CYHZ", "CYIF", "CYKA", "CYLR", "CYLW", "CYMM", "CYMU", "CYMX", "CYOP", "CYOW", "CYPN", "CYPR", "CYQB", "CYQD", "CYQG", "CYQM", "CYQR", "CYQT", "CYQX", "CYRB", "CYSJ", "CYSM", "CYTH", "CYTZ", "CYUL", "CYUX", "CYVB", "CYVO", "CYVP", "CYVQ", "CYVR", "CYWG", "CYWK", "CYXE", "CYXJ", "CYXN", "CYXS", "CYXT", "CYXU", "CYXY", "CYYC", "CYYD", "CYYJ", "CYYQ", "CYYR", "CYYT", "CYYZ", "CYZF", "CYZP", "CZFG", "CZKE", "CZSN", "CZTM", "CZWH", "DAAG", "DAAV", "DABB", "DABC", "DAOO", "DBBB", "DFFD", "DFOO", "DGAA", "DIAP", "DIBK", "DIDL", "DIKO", "DIMN", "DISP", "DISS", "DIYO", "DNAA", "DNJO", "DNKN", "DNMM", "DNPO", "DRRM", "DRRN", "DRZA", "DRZL", "DRZR", "DTMB", "DTTA", "DTTJ", "DTTX", "DXXX", "EBAW", "EBBR", "EBLG", "EDCD", "EDCG", "EDDB", "EDDC", "EDDE", "EDDF", "EDDG", "EDDH", "EDDK", "EDDL", "EDDM", "EDDN", "EDDP", "EDDR", "EDDS", "EDDT", "EDDV", "EDDW", "EDFH", "EDHK", "EDLP", "EDLW", "EDMA", "EDNY", "EDQD", "EDQM", "EDSB", "EDWJ", "EDXW", "EETN", "EETU", "EFET", "EFHK", "EFIV", "EFJO", "EFJY", "EFKE", "EFKI", "EFKJ", "EFKK", "EFKS", "EFKT", "EFKU", "EFLP", "EFMA", "EFMI", "EFOU", "EFPO", "EFRO", "EFSA", "EFSI", "EFSO", "EFTP", "EFTU", "EFVA", "EFVR", "EGAA", "EGAC", "EGAE", "EGBB", "EGBE", "EGCC", "EGCN", "EGEC", "EGEF", "EGET", "EGFF", "EGGD", "EGGP", "EGGW", "EGHC", "EGHH", "EGHI", "EGHQ", "EGJA", "EGJB", "EGJJ", "EGKK", "EGLC", "EGLL", "EGMC", "EGMD", "EGMH", "EGNH", "EGNJ", "EGNM", "EGNT", "EGNV", "EGNX", "EGPA", "EGPB", "EGPC", "EGPD", "EGPE", "EGPF", "EGPH", "EGPI", "EGPK", "EGPL", "EGPN", "EGPO", "EGPR", "EGPW", "EGSC", "EGSH", "EGSS", "EGTE", "EHAM", "EHBK", "EHEH", "EHGG", "EHLE", "EHRD", "EHVK", "EICK", "EICM", "EIDL", "EIDW", "EIKN", "EIKY", "EINN", "EISG", "EKAH", "EKBI", "EKCH", "EKEB", "EKKA", "EKOD", "EKRN", "EKSB", "EKSP", "EKTS", "EKVG", "EKYT", "ELLX", "ENAL", "ENAT", "ENBN", "ENBO", "ENBR", "ENCN", "ENDU", "ENEV", "ENFL", "ENGM", "ENHD", "ENHF", "ENKB", "ENKR", "ENNA", "ENSB", "ENSG", "ENTC", "ENTO", "ENVA", "ENZV", "EPGD", "EPKK", "EPPO", "EPSC", "EPWA", "ESDF", "ESGG", "ESGJ", "ESGL", "ESMK", "ESMQ", "ESMX", "ESNN", "ESNQ", "ESNU", "ESOE", "ESOK", "ESPA", "ESSA", "ESSP", "ESSV", "ETOU", "EVRA", "EYVI", "FAAB", "FAAG", "FAAL", "FABL", "FACT", "FAEL", "FAER", "FAGG", "FAKM", "FAKN", "FAKZ", "FALA", "FALE", "FAMG", "FAMO", "FAMS", "FAMW", "FANC", "FANS", "FAOH", "FAOR", "FAPE", "FAPG", "FAPH", "FAPM", "FAPN", "FAPP", "FARB", "FASB", "FASS", "FASZ", "FATN", "FAUL", "FAUP", "FAUT", "FAVY", "FAWB", "FAWM", "FBFT", "FBJW", "FBMN", "FBSK", "FBSP", "FCBB", "FCPP", "FDMS", "FEFC", "FEFF", "FEFG", "FEFI", "FEFM", "FEFR", "FEFT", "FEFW", "FGSL", "FIMP", "FIMR", "FKKD", "FKKL", "FKKN", "FKKR", "FKKY", "FLCP", "FLLS", "FLMF", "FLND", "FLSO", "FMCH", "FMCV", "FMCZ", "FMEE", "FMMI", "FMNM", "FNBG", "FNCA", "FNLU", "FNUG", "FOGF", "FOGM", "FOGR", "FOOD", "FOOG", "FOOL", "FOON", "FPST", "FQBR", "FQMA", "FSIA", "FTTC", "FTTD", "FTTJ", "FVBU", "FVCZ", "FVFA", "FVHA", "FVMV", "FVTL", "FVWN", "FWCL", "FWKI", "FXMM", "FZAA", "FZGA", "FZIC", "FZQA", "GABS", "GAKY", "GBYD", "GCFV", "GCHI", "GCLA", "GCLP", "GCRR", "GFLL", "GLMR", "GLRB", "GMAD", "GMFF", "GMFO", "GMMC", "GMME", "GMMN", "GMMX", "GMMZ", "GMTA", "GMTT", "GOOY", "GQNO", "GQPP", "GQPZ", "GUCY", "GULB", "GVAC", "GVNP", "HAAB", "HABC", "HAJJ", "HAJM", "HBBA", "HCMM", "HDAM", "HE25", "HEAR", "HEAT", "HEAX", "HEBL", "HECA", "HEGN", "HEKG", "HELX", "HEMA", "HEMM", "HEPS", "HESC", "HESH", "HESN", "HHAS", "HKJK", "HKML", "HKMO", "HLLB", "HLLS", "HLLT", "HRYR", "HSKA", "HSSJ", "HSSS", "HTAR", "HTDA", "HTDO", "HTKJ", "HUEN", "HUGU", "HUJI", "KABE", "KABI", "KABQ", "KABR", "KABY", "KACK", "KACT", "KACV", "KACY", "KAGS", "KAHN", "KALB", "KALO", "KALW", "KAMA", "KAOO", "KAPF", "KARB", "KASE", "KATL", "KATW", "KATY", "KAUG", "KAUS", "KAVL", "KAVP", "KAXS", "KAZO", "KBDL", "KBDR", "KBEH", "KBFD", "KBFL", "KBGM", "KBGR", "KBHM", "KBIL", "KBIS", "KBJI", "KBKL", "KBKW", "KBKX", "KBLF", "KBLI", "KBMG", "KBMI", "KBNA", "KBOI", "KBOS", "KBPT", "KBQK", "KBRD", "KBRL", "KBTM", "KBTR", "KBTV", "KBUF", "KBUR", "KBWI", "KBZN", "KCAE", "KCAK", "KCCR", "KCDC", "KCEC", "KCHA", "KCHO", "KCHS", "KCIC", "KCID", "KCKB", "KCLE", "KCLL", "KCLM", "KCLT", "KCMH", "KCMI", "KCMX", "KCOD", "KCON", "KCOS", "KCPR", "KCRE", "KCRG", "KCRP", "KCRQ", "KCRW", "KCSG", "KCVG", "KCWA", "KCXP", "KCXY", "KCYS", "KDAB", "KDAL", "KDAN", "KDAY", "KDBQ", "KDCA", "KDEC", "KDEN", "KDFW", "KDHN", "KDLH", "KDRO", "KDSM", "KDTW", "KDUJ", "KDVL", "KEAT", "KEAU", "KEGE", "KEKM", "KEKO", "KELM", "KELP", "KELY", "KERI", "KESC", "KESF", "KEUG", "KEVV", "KEWN", "KEWR", "KEYW", "KFAR", "KFAT", "KFAY", "KFHU", "KFKL", "KFLG", "KFLL", "KFLO", "KFMN", "KFMY", "KFNT", "KFOD", "KFRI", "KFSD", "KFSM", "KFWA", "KFYV", "KGAD", "KGCC", "KGCN", "KGDV", "KGEG", "KGFK", "KGGG", "KGGW", "KGJT", "KGLH", "KGNV", "KGON", "KGPI", "KGPT", "KGPZ", "KGRB", "KGRR", "KGSO", "KGSP", "KGTF", "KGUC", "KHDN", "KHIB", "KHII", "KHKS", "KHKY", "KHLN", "KHON", "KHOU", "KHPN", "KHRL", "KHSV", "KHTS", "KHUF", "KHVN", "KHVR", "KHXD", "KHYA", "KIAD", "KIAG", "KIAH", "KICT", "KIDA", "KIJX", "KILE", "KILM", "KIND", "KINL", "KIPL", "KIPT", "KISO", "KISP", "KITH", "KIYK", "KJAC", "KJAN", "KJAX", "KJBR", "KJEF", "KJFK", "KJHW", "KJLN", "KJMS", "KJSO", "KJST", "KJVL", "KJXN", "KLAF", "KLAN", "KLAR", "KLAS", "KLAW", "KLAX", "KLBB", "KLBE", "KLCH", "KLEB", "KLEX", "KLFT", "KLGA", "KLGB", "KLIT", "KLMT", "KLNK", "KLNS", "KLRD", "KLRF", "KLSE", "KLWB", "KLWS", "KLWT", "KLYH", "KLYO", "KMAF", "KMBS", "KMCE", "KMCI", "KMCN", "KMCO", "KMCW", "KMDT", "KMDW", "KMEI", "KMEM", "KMFE", "KMFR", "KMGM", "KMGW", "KMHE", "KMHT", "KMIA", "KMJQ", "KMKE", "KMKG", "KMKL", "KMLB", "KMLI", "KMLS", "KMLU", "KMOB", "KMOD", "KMOT", "KMRB", "KMRY", "KMSL", "KMSN", "KMSO", "KMSP", "KMSY", "KMTH", "KMTJ", "KMTO", "KMVY", "KMWH", "KMYR", "KNIP", "KNYL", "KOAJ", "KOAK", "KOKC", "KOLF", "KOMA", "KONT", "KORD", "KORF", "KORH", "KORL", "KOSH", "KOTH", "KOWB", "KOXR", "KPAH", "KPBI", "KPDT", "KPDX", "KPGA", "KPGV", "KPHF", "KPHL", "KPHX", "KPIA", "KPIB", "KPIH", "KPIR", "KPIT", "KPKB", "KPLN", "KPMD", "KPNS", "KPOU", "KPQI", "KPSC", "KPSP", "KPUB", "KPUW", "KPVD", "KPWM", "KRAP", "KRDD", "KRDG", "KRDM", "KRDU", "KRFD", "KRHI", "KRIC", "KRKD", "KRKS", "KRNO", "KROA", "KROC", "KRST", "KRSW", "KRWI", "KSAN", "KSAT", "KSAV", "KSAW", "KSBA", "KSBN", "KSBP", "KSBY", "KSCK", "KSDF", "KSDL", "KSDY", "KSEA", "KSFO", "KSGF", "KSGU", "KSHD", "KSHR", "KSHV", "KSJC", "KSJT", "KSLC", "KSLE", "KSMF", "KSMS", "KSMX", "KSNA", "KSNS", "KSPI", "KSPS", "KSRQ", "KSTL", "KSTS", "KSUN", "KSUX", "KSWF", "KSYR", "KTCL", "KTEX", "KTLH", "KTOL", "KTPA", "KTRI", "KTTN", "KTUL", "KTUP", "KTUS", "KTVC", "KTVF", "KTVL", "KTWF", "KTXK", "KTYR", "KTYS", "KUIN", "KUKI", "KUNI", "KUNV", "KVEL", "KVIS", "KVLD", "KVPS", "KVRB", "KWRL", "KWYS", "KYKM", "LATI", "LBBG", "LBGO", "LBRS", "LBSF", "LBSS", "LBTG", "LBWN", "LCLK", "LCPH", "LCRA", "LDDU", "LDLO", "LDOS", "LDPL", "LDRI", "LDSP", "LDZA", "LDZD", "LEAL", "LEAM", "LEAS", "LEBA", "LEBB", "LEBL", "LEBZ", "LEGE", "LEGR", "LEIB", "LEJR", "LELC", "LEMD", "LEMG", "LEMH", "LEPA", "LERS", "LESO", "LEST", "LEVC", "LEVD", "LEVT", "LEVX", "LEXJ", "LEZG", "LEZL", "LFBD", "LFBE", "LFBH", "LFBI", "LFBL", "LFBO", "LFBP", "LFBT", "LFBZ", "LFCI", "LFCR", "LFJL", "LFKB", "LFKC", "LFKF", "LFKJ", "LFLB", "LFLC", "LFLL", "LFLO", "LFLP", "LFLS", "LFLW", "LFMD", "LFMH", "LFML", "LFMN", "LFMP", "LFMT", "LFPG", "LFQQ", "LFRB", "LFRD", "LFRH", "LFRN", "LFRO", "LFRQ", "LFRS", "LFRT", "LFSF", "LFSN", "LFST", "LFTW", "LFVP", "LGAV", "LGHI", "LGIR", "LGKL", "LGKO", "LGKP", "LGKR", "LGKV", "LGMK", "LGMT", "LGNX", "LGPZ", "LGRP", "LGRX", "LGSA", "LGSK", "LGSM", "LGSR", "LGTS", "LGZA", "LHBP", "LIBD", "LIBP", "LIBR", "LICA", "LICC", "LICD", "LICG", "LICJ", "LICR", "LICT", "LIEA", "LIEE", "LIEO", "LIMC", "LIMF", "LIMJ", "LIPE", "LIPH", "LIPO", "LIPQ", "LIPR", "LIPX", "LIPY", "LIPZ", "LIQS", "LIRF", "LIRJ", "LIRN", "LIRP", "LIRQ", "LIRZ", "LJLJ", "LJMB", "LKKU", "LKPR", "LLBG", "LLET", "LLHA", "LLOV", "LMML", "LOWG", "LOWI", "LOWK", "LOWL", "LOWS", "LOWW", "LPAZ", "LPFR", "LPHR", "LPLA", "LPMA", "LPPD", "LPPR", "LPPS", "LPPT", "LQMO", "LQSA", "LRCK", "LROP", "LSGG", "LSZA", "LSZB", "LSZC", "LSZH", "LSZR", "LTAC", "LTAD", "LTAF", "LTAI", "LTAJ", "LTAN", "LTAR", "LTAT", "LTAU", "LTAY", "LTBA", "LTBS", "LTBU", "LTCD", "LTCE", "LTCG", "LTCI", "LTCK", "LTCM", "LTCN", "LTCP", "LTCR", "LTFE", "LTFH", "LTFJ", "LUKK", "LVGZ", "LWOH", "LWSK", "LXGB", "LYBE", "LYNI", "LYPG", "LYTV", "LZIB", "MDCY", "MDLR", "MDPC", "MDPP", "MDSD", "MGGT", "MHJU", "MHLM", "MHRO", "MHSR", "MHTG", "MHUT", "MKJP", "MKJS", "MMAA", "MMAN", "MMAS", "MMBT", "MMCE", "MMCL", "MMCN", "MMCS", "MMCT", "MMCU", "MMCV", "MMCZ", "MMGL", "MMHO", "MMIA", "MMJA", "MMJC", "MMLC", "MMLM", "MMLO", "MMLP", "MMLT", "MMMD", "MMML", "MMMM", "MMMT", "MMMX", "MMMY", "MMMZ", "MMNL", "MMOX", "MMPB", "MMPN", "MMPR", "MMPS", "MMSD", "MMSM", "MMSP", "MMTG", "MMTJ", "MMTM", "MMUN", "MMVA", "MMVR", "MMZC", "MMZH", "MMZO", "MNMG", "MPJE", "MPTO", "MROC", "MRUP", "MSLP", "MTJA", "MTJE", "MTPP", "MUCF", "MUCU", "MUHA", "MUHG", "MUVR", "MWCR", "MYAM", "MYAT", "MYBC", "MYEH", "MYEM", "MYER", "MYGF", "MYNN", "MYSM", "MZBZ", "NCRG", "NFCS", "NFFN", "NFNA", "NFTF", "NLWF", "NLWW", "NSFA", "NSTU", "NTAA", "NTGI", "NTMP", "NTMU", "NTTB", "NTTG", "NTTH", "NTTM", "NTTP", "NTTR", "NVSS", "NVSU", "NVVV", "NWWE", "NWWL", "NWWR", "NWWU", "NWWV", "NWWW", "NZGT", "NZHN", "NZMF", "NZMO", "NZNS", "NZPM", "NZRO", "NZTH", "NZWB", "NZWK", "NZWR", "OAJL", "OAKB", "OARG", "OBBI", "OEAB", "OEDF", "OEDR", "OEJN", "OEMA", "OERK", "OESK", "OETB", "OETF", "OEYN", "OIAA", "OIII", "OITR", "OJAI", "OJAM", "OJAQ", "OJJR", "OKBK", "OLBA", "OMAA", "OMAL", "OMDB", "OMFJ", "OMRK", "OMSJ", "OOMS", "OOSA", "OPBN", "OPBW", "OPCH", "OPDI", "OPFA", "OPGD", "OPGT", "OPJA", "OPJI", "OPKC", "OPKD", "OPKH", "OPKT", "OPLA", "OPMF", "OPMI", "OPMJ", "OPMP", "OPMT", "OPNH", "OPPG", "OPPI", "OPPS", "OPQT", "OPRK", "OPRN", "OPRT", "OPSD", "OPSK", "OPSS", "OPSU", "OPTU", "OPZB", "ORBI", "ORBM", "ORKK", "ORMM", "OSAP", "OSDI", "OTHH", "OYAA", "OYSN", "PABE", "PACV", "PADL", "PADQ", "PADU", "PAEN", "PAFA", "PAGY", "PAHN", "PAHO", "PAHY", "PAIL", "PAIN", "PAJN", "PAKN", "PAKT", "PAKW", "PAMM", "PANC", "PAOH", "PAOM", "PAOT", "PAPG", "PASC", "PASI", "PATK", "PAUN", "PAVD", "PAWG", "PAYA", "PGSN", "PGUM", "PHJH", "PHKO", "PHLI", "PHMK", "PHMU", "PHNL", "PHNY", "PHOG", "PHTO", "PHUP", "PLCH", "PMDY", "PTPN", "RCKH", "RCQC", "RCTP", "RJAA", "RJAF", "RJBB", "RJCH", "RJCK", "RJDC", "RJFF", "RJFK", "RJFM", "RJFO", "RJFT", "RJFU", "RJGG", "RJKA", "RJNK", "RJNT", "RJOA", "RJOB", "RJOK", "RJOM", "RJOS", "RJOT", "RJSA", "RJSC", "RJSD", "RJSF", "RJSI", "RJSK", "RJSN", "RJSS", "RJTH", "RJTT", "RKPK", "RKPU", "RKSI", "ROAH", "ROIG", "ROMY", "RPLL", "RPLO", "RPMJ", "RPVM", "SAAJ", "SAAR", "SABE", "SACO", "SAEZ", "SAME", "SARI", "SASA", "SASJ", "SAWH", "SAWS", "SAZM", "SAZR", "SAZS", "SBAR", "SBBE", "SBBR", "SBBV", "SBCG", "SBCT", "SBCY", "SBEG", "SBFL", "SBFZ", "SBGO", "SBJF", "SBJP", "SBJV", "SBMO", "SBMQ", "SBNT", "SBPA", "SBPJ", "SBPV", "SBRB", "SBRF", "SBSL", "SBSV", "SBTE", "SBUG", "SBUL", "SBUP", "SBUR", "SBVT", "SCCF", "SCCI", "SCEL", "SCIP", "SCRD", "SDJL", "SEGU", "SEJI", "SEQM", "SESA", "SGAS", "SKBG", "SKBO", "SKBQ", "SKCG", "SKCL", "SKPE", "SKRG", "SKSL", "SKSP", "SLCB", "SLET", "SLLP", "SLSR", "SMJP", "SNJB", "SNJN", "SOCA", "SOGS", "SPIM", "SPJI", "SPJJ", "SPJL", "SPQT", "SPZA", "SSJA", "SSZR", "SUMU", "SVBC", "SVMC", "SVMG", "SVMI", "SVPR", "SVUM", "SVVA", "SWJW", "SYCJ", "TAPA", "TBPB", "TDPD", "TFFF", "TFFG", "TFFR", "TGPY", "TIST", "TISX", "TJBQ", "TJMZ", "TJPS", "TJSJ", "TKPK", "TKPN", "TLPC", "TLPL", "TNCA", "TNCB", "TNCC", "TNCM", "TQPF", "TTCP", "TTPP", "TUPJ", "TUPW", "TVSA", "TVSC", "TVSU", "TXKF", "UAAA", "UAFM", "UBBN", "UDYZ", "UEEE", "UGTB", "UHHH", "UIAA", "UIII", "UIUU", "UKBB", "UKFF", "UKHH", "UKKK", "UKLL", "UKLU", "UKON", "UKOO", "ULAA", "ULLI", "ULMM", "ULOL", "UMKK", "UMMS", "UNNT", "URMM", "URRP", "URRR", "URSS", "USSS", "UTAA", "UTDD", "UTNU", "UTSS", "UTTT", "UUEE", "UUYH", "UWGG", "UWKD", "UWPS", "UWUU", "UWWW", "VAAH", "VABB", "VABM", "VABO", "VABP", "VAJB", "VAJM", "VANP", "VAPO", "VARK", "VASU", "VAUD", "VCBI", "VCCJ", "VDPP", "VEBD", "VEBN", "VEBS", "VECC", "VEGT", "VEJP", "VEJS", "VEJT", "VEPT", "VERC", "VGBR", "VGEG", "VGHS", "VGJR", "VGSY", "VHHH", "VIAR", "VICG", "VIDP", "VIJO", "VIJP", "VIJR", "VIJU", "VIKA", "VILK", "VISR", "VLVT", "VMMC", "VNJI", "VNJL", "VNJP", "VNJS", "VNKT", "VOBL", "VOCB", "VOCI", "VOCL", "VOGO", "VOHS", "VOMM", "VOMY", "VOTR", "VOTV", "VQPR", "VRMM", "VTBD", "VTBF", "VTBS", "VTBU", "VTCC", "VTSF", "VTSP", "VTSS", "VTUD", "VTUU", "VVNB", "VVPB", "VVTS", "VYMD", "VYYY", "WAAA", "WADD", "WAJJ", "WAMM", "WARR", "WASA", "WBGB", "WBGG", "WBGR", "WBGS", "WBKK", "WBKL", "WBKW", "WBSB", "WICC", "WIII", "WIMK", "WIMM", "WIPA", "WMBT", "WMKD", "WMKJ", "WMKK", "WMKL", "WMKP", "WMSA", "WPDL", "WSAP", "WSSL", "WSSS", "YABA", "YAYE", "YAYR", "YBAS", "YBBN", "YBCG", "YBCS", "YBHI", "YBHM", "YBMA", "YBMK", "YBNA", "YBPI", "YBPN", "YBRK", "YBRM", "YBSU", "YBTL", "YBTR", "YBUD", "YBWN", "YBWP", "YCAR", "YCAS", "YCBP", "YCDU", "YCFS", "YCHT", "YCKN", "YCMT", "YCNK", "YCOM", "YCSV", "YDAY", "YDBY", "YDKI", "YDPO", "YDYS", "YEML", "YESP", "YGDI", "YGEL", "YGKL", "YGLA", "YGLG", "YGTE", "YGTH", "YGYM", "YHBA", "YHML", "YIFL", "YIGM", "YJDA", "YJLC", "YKBY", "YKII", "YKMB", "YKOW", "YKSC", "YLEO", "YLHR", "YLIN", "YLIS", "YLMQ", "YLRE", "YLST", "YLTN", "YLZI", "YMAY", "YMEK", "YMER", "YMHB", "YMIA", "YMLT", "YMML", "YMMU", "YMND", "YMOG", "YMOR", "YMRB", "YMRY", "YMTG", "YMYB", "YNAR", "YNBR", "YNPE", "YNWN", "YOLD", "YORG", "YPAD", "YPAG", "YPBO", "YPDN", "YPGV", "YPJT", "YPKA", "YPKG", "YPKU", "YPLC", "YPLM", "YPMP", "YPMQ", "YPOD", "YPPD", "YPPH", "YPTN", "YPWR", "YQNS", "YSCB", "YSCO", "YSDU", "YSGT", "YSNF", "YSSY", "YSTW", "YSWG", "YTEM", "YTMP", "YTNK", "YTRE", "YTWB", "YWBL", "YWHA", "YWLM", "YWLU", "YWOL", "YWYM", "YWYY", "ZBAA", "ZBTJ", "ZBUL", "ZBYN", "ZGGG", "ZGKL", "ZGNN", "ZGSZ", "ZHHH", "ZHYC", "ZKPY", "ZLJN", "ZLJQ", "ZLXY", "ZMUB", "ZPJH", "ZPMS", "ZSAM", "ZSHC", "ZSJA", "ZSJD", "ZSJJ", "ZSJN", "ZSPD", "ZSQD", "ZSQZ", "ZSSS", "ZUCK", "ZUUU", "ZWAT", "ZWWW", "ZYCC", "ZYCY", "ZYHB", "ZYJL", "ZYJM", "ZYJZ", "ZYTL", "ZYTX"]
