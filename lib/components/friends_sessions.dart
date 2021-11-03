import 'package:choose_food/common.dart' show BasePage;
import 'package:choose_food/main.dart' show TableNames;
import 'package:flutter/widgets.dart'
    show
        BuildContext,
        Expanded,
        Key,
        ListView,
        State,
        StatefulWidget,
        Text,
        Widget;
import 'package:get/get.dart' show Get, Inst;
import 'package:supabase/supabase.dart' show SupabaseClient;

class FriendsSessions extends StatefulWidget {
  static const routeName = "/friends";

  const FriendsSessions({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FriendsSessionsState();
}

class FriendsSessionsState extends State<FriendsSessions> {
  SupabaseClient supabaseClient = Get.find();

  List<Widget> sessions = [];

  @override
  void initState() async {
    super.initState();
    sessions =
        ((await supabaseClient.from(TableNames.session).select().execute()).data
                as List<Map<String, dynamic>>)
            .map((e) => Text(e['id']))
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(selectedIndex: 1, children: [
      Expanded(child: ListView(children: sessions, primary: true))
    ]);
  }
}
