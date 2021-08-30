import 'package:amuzcore/_API.dart';

import 'models/Config.dart';

  // init config
  Future<dynamic> init() async {

    var configs = await doApiGET(BaseApi().config);

    List<Config> configList = List.generate(configs.length, (i) {
      return Config(
          savedName: configs[i]['config_list']['name'],
          savedVars:  configs[i]['config_list']['vars']
      );
    });

  }
