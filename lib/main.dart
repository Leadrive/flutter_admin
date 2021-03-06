import 'package:cry/common/application_context.dart';
import 'package:cry/constants/cry_constant.dart';
import 'package:cry/generated/l10n.dart' as cryS;
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_admin/common/cry_dio_interceptors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'common/cry_root.dart';
import 'common/routes.dart';
import 'generated/l10n.dart';
import 'models/configuration_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApplicationContext.instance.init();
  loadBean();

  runApp(MyApp());
}

loadBean() {
  ApplicationContext.instance.addBean(CryConstant.KEY_DIO_INTERCEPTORS, [CryDioInterceptors()]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CryRoot(
      Builder(
        builder: (context) {
          return MaterialApp(
            title: 'FLUTTER_ADMIN',
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            localizationsDelegates: [
              S.delegate,
              cryS.S.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            locale: CryRootScope.of(context).state.configuration.locale,
            localeResolutionCallback: (locale, supportedLocales) {
              deviceLocale = locale;
              return locale;
            },
            supportedLocales: S.delegate.supportedLocales,
            onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
          );
        },
      ),
    );
  }
}
